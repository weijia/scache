public final class shutdownhook extends Thread
{
     protected Thread directory_saver_thread;

     public void run()
     {
	System.out.println("[INFO] shutdown hook is running...");
	directory_saver_thread.interrupt();
	try {
		directory_saver_thread.join(15000);
		System.out.println("[INFO] shutdown hook is done.");
	} catch (Exception ex)
	{
			System.out.println("[ERROR] shutdown hook join failed:"+ex.toString());
	}
     }

     public shutdownhook(Thread saver)
     {
	this.setName("shutdown_hook");
	directory_saver_thread = saver;
	Runtime.getRuntime().addShutdownHook(this);
     }
}
