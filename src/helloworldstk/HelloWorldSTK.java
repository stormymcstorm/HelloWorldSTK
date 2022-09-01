package helloworldstk;

import javacard.framework.APDU;
import javacard.framework.Applet;
import javacard.framework.ISOException;

import sim.toolkit.EnvelopeHandler;
import sim.toolkit.ProactiveHandler;
import sim.toolkit.ToolkitConstants;
import sim.toolkit.ToolkitInterface;
import sim.toolkit.ToolkitException;
import sim.toolkit.ToolkitRegistry;

public class HelloWorldSTK extends Applet implements ToolkitInterface, ToolkitConstants {

	
	static byte[] menuItemText = new byte[] {'H', 'e', 'l', 'l', 'o', ',', ' ', 'S', 'T', 'K'};
	
	static byte[] welcomeMsg = new byte[] { 'F', 'O', 'O' };
	
	
	public static void install(byte[] bArray, short bOffset, byte bLength) {
		HelloWorldSTK applet = new HelloWorldSTK();
		
		applet.register();
	}
	
	private byte menuItem;
	
	private HelloWorldSTK() {
		ToolkitRegistry reg = ToolkitRegistry.getEntry();
		
		menuItem = reg.initMenuEntry(menuItemText, (short)0, (short)menuItemText.length,
                ToolkitConstants.PRO_CMD_SELECT_ITEM, false, (byte)0, (short)0);
	}
	
	public void process(APDU arg0) throws ISOException {
		if (selectingApplet())
			return;
	}
	
	public void processToolkit(byte event) throws ToolkitException {
		EnvelopeHandler envHdlr = EnvelopeHandler.getTheHandler();
		
		if (event == ToolkitConstants.EVENT_MENU_SELECTION) {
			byte selectedItemId = envHdlr.getItemIdentifier();
			
			if (selectedItemId == menuItem) 
				showHello();
		}
	}
	
	private void showHello() {
		ProactiveHandler proHdlr = ProactiveHandler.getTheHandler();
		
		proHdlr.initDisplayText((byte)0, ToolkitConstants.DCS_8_BIT_DATA, 
				welcomeMsg, (short)0, (short)(welcomeMsg.length));
	}


}
