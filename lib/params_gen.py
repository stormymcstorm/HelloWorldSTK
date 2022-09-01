import argparse

parser = argparse.ArgumentParser(description='Generate parameters for GlobalPlatformPro')

parser.add_argument('--volatile-memory-for-install', type=int,
                    help='Volatile Memory Quota', default=0)
parser.add_argument('--nonvolatile-memory-required', type=int,
                    help='Non-volatile Memory Quota', default=0)

parser.add_argument('--enable-sim-toolkit', 
                    help='Enable SIM toolkit parameters', action='store_true')
parser.add_argument('--access-domain',  type=str,
                    help='The applications access domain (HEX str 1 byte)', 
                    default='FF')
parser.add_argument('--priority-level', type=str,
                    help='The applications priority level (HEX str 1 byte)', 
                    default='01')
parser.add_argument('--max-timers', type=int, 
                    help='The maximum number timers', default=0)
parser.add_argument('--max-menu-entry-text', type=int, 
                    help='The maximum length of menu entries', default=16)
parser.add_argument('--max-menu-entries', type=int, 
                    help='The maximum number of menu entries', default=0)
parser.add_argument('--app-parameters', type=str,
                    help='Extra parameters for the application (HEX str)', 
                    default='')

if __name__ == '__main__':
  args = parser.parse_args()
  
  toolkit_params = ''
  if args.enable_sim_toolkit:
    assert(len(args.access_domain) % 2 == 0)
    toolkit_params += ('%02X' % (len(args.access_domain) // 2)) + args.access_domain
    
    assert(len(args.priority_level) == 2)
    toolkit_params += args.priority_level
    
    toolkit_params += ('%02X' % args.max_timers)
    toolkit_params += ('%02X' % args.max_menu_entry_text)
    toolkit_params += ('%02X' % args.max_menu_entries)
    
    for i in range(args.max_menu_entries):
      toolkit_params += ('%02X' % i) + '00'
      
    max_channels = 0
    toolkit_params += ('%02X' % max_channels)
    
    minimum_security = ''
    toolkit_params += ('%02X' % (len(minimum_security) // 2)) + minimum_security
    
    tar = ''
    toolkit_params += ('%02X' % (len(tar) // 6)) + tar
      
    assert(len(toolkit_params) % 2 == 0)
    toolkit_params = 'CA' + ('%02X' % (len(toolkit_params) // 2)) + toolkit_params 

  system_params = toolkit_params
  
  if system_params:
    assert(len(system_params) % 2 == 0)
    
    system_params = 'EF' + ('%02X' % (len(system_params) // 2)) + system_params

  app_params = args.app_parameters
  
  assert(len(app_params) % 2 == 0)
  app_params = 'C9' + ('%02X' % (len(app_params) // 2)) + app_params
  
  params = app_params + system_params
  
  print(params)
