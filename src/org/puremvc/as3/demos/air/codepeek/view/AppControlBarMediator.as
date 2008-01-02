/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.view
{
	import flash.geom.Point;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import mx.containers.ControlBar;
	import mx.managers.PopUpManager;
	import mx.collections.XMLListCollection;

	import org.puremvc.interfaces.*;
	
	import org.puremvc.patterns.mediator.Mediator;
	import org.puremvc.as3.demos.air.codepeek.ApplicationFacade;
	import org.puremvc.as3.demos.air.codepeek.model.CodeSearchProxy;
	import org.puremvc.as3.demos.air.codepeek.view.components.AppControlBar;
	
	/**
	 * A Mediator for interacting with the AppControlBar component.
	 */
	public class AppControlBarMediator extends Mediator implements IMediator
	{
		// Cannonical name of the Mediator
		public static const NAME:String = 'AppControlBarMediator';
		
		/**
		 * Constructor. 
		 * 
		 * <P>
		 * Populate combo box options and add listeners to 
		 * the viewComponent (the AppControlBar).</P>
		 * 
		 * @param object the viewComponent (the AppControlBar instance in this case)
		 */
		public function AppControlBarMediator( viewComponent:Object ) 
		{
			super( viewComponent );
			
			// retrieve and cache a reference to needed proxys
			codeSearchProxy = CodeSearchProxy( facade.retrieveProxy( CodeSearchProxy.NAME ) );
			
			// populate combo box on view component
			controlBar.comboOptions = codeSearchProxy.searchOptions;
			
			// add listeners to the view component
			controlBar.addEventListener( AppControlBar.BEGIN_CODE_SEARCH, beginSearch );
			controlBar.addEventListener( AppControlBar.CANCEL_CODE_SEARCH, resetSearch );
			controlBar.addEventListener( AppControlBar.CANCEL_CODE_SEARCH, resetSearch );
			
		}

		/**
		 * Get the Mediator name
		 * <P>
		 * Called by the framework to get the name of this
		 * mediator. If there is only one instance, we may
		 * define it in a constant and return it here. If
		 * there are multiple instances, this method must
		 * return the unique name of this instance.</P>
		 * 
		 * @return String the Mediator name
		 */
		override public function getMediatorName():String
		{
			return AppControlBarMediator.NAME;
		}

		/**
		 * List all notifications this Mediator is interested in.
		 * <P>
		 * Automatically called by the framework when the mediator
		 * is registered with the view.</P>
		 * 
		 * @return Array the list of Nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			return [ ApplicationFacade.CODE_SEARCH_FAILED,
					 ApplicationFacade.CODE_SEARCH_SUCCESS,
					 ApplicationFacade.SEARCH_TYPE_SELECTED,
					 ApplicationFacade.SEARCH_SELECTED
 				   ];
		}

		/**
		 * Handle all notifications this Mediator is interested in.
		 * <P>
		 * Called by the framework when a notification is sent that
		 * this mediator expressed an interest in when registered
		 * (see <code>listNotificationInterests</code>.</P>
		 * 
		 * @param INotification a notification 
		 */
		override public function handleNotification( note:INotification ):void 
		{
			switch ( note.getName() ) {
				
				// The code search either had no results or 
				// there was an actual failure
				case ApplicationFacade.CODE_SEARCH_FAILED:
					resetSearch();
					break;
				
				// The code search returned successfully	
				case ApplicationFacade.CODE_SEARCH_SUCCESS:
					resetSearch();
					break;
					
				// The user has selected a Search
				case ApplicationFacade.SEARCH_SELECTED:
					resetSearch();
					selectComboOption(note.getBody()[0].@name);
					controlBar.searchTI.text=note.getBody()[1].@name;
					break;
				
				// The user has selected a Search Type 
				case ApplicationFacade.SEARCH_TYPE_SELECTED:
					resetSearch();
					selectComboOption(note.getBody().@name);
					break;
					
			}
		}
		
		/**
		 * The user has initiated a search.
		 */
		private function beginSearch( event:Event=null ):void
		{
			codeSearchProxy.search( controlBar.searchTI.text, controlBar.searchCombo.selectedItem );
		}

		/**
		 * Reset the search controls.
		 */
		private function resetSearch( event:Event=null ):void
		{
			codeSearchProxy.cancel( );
			controlBar.searching = false;
			controlBar.searchTI.text='';
			controlBar.searchTI.setFocus();
		}

		/**
		 * The user clicked in the tree, so lets helpfully keep the combo in sync.
		 */
		private function selectComboOption( option:String ):void
		{
			for ( var i:int=0; i < controlBar.searchCombo.dataProvider.length; i++ ) {
				if ( controlBar.searchCombo.dataProvider[i].label == option ) {
					controlBar.searchCombo.selectedIndex = i;
					break;
				}
			}
		}

		/**
		 * Cast the viewComponent to its actual type.
		 * 
		 * <P>
		 * This is a useful idiom for mediators. The
		 * PureMVC Mediator class defines a viewComponent
		 * property of type Object. </P>
		 * 
		 * <P>
		 * Here, we cast the generic viewComponent to 
		 * its actual type in a protected mode. This 
		 * retains encapsulation, while allowing the instance
		 * (and subclassed instance) access to a 
		 * strongly typed reference with a meaningful
		 * name.</P>
		 * 
		 * @return app the viewComponent cast to org.puremvc.as3.demos.air.view.components.AppControlBar
		 */
		protected function get controlBar():AppControlBar{
			return viewComponent as AppControlBar;
		}

		// Cached reference to search proxy
		private var codeSearchProxy:CodeSearchProxy;
	}
}