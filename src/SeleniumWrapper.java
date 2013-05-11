import org.openqa.selenium.Capabilities;
import org.openqa.selenium.Platform;
import org.openqa.selenium.Proxy;
import org.openqa.selenium.SeleneseCommandExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebDriverBackedSelenium;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.Command;
import org.openqa.selenium.remote.DesiredCapabilities;

import com.thoughtworks.selenium.Selenium;

class SeleniumWrapper {
  WebDriver driver;
  Selenium selenium;
  DesiredCapabilities desiredCapabilities = new DesiredCapabilities();
  String baseUrl;
  String proxyUrl;

  public SeleniumWrapper(String baseUrl) {
    this.baseUrl = baseUrl;
  }

  public SeleniumWrapper setProxy(String url) {
    Proxy proxy = new Proxy();
    proxy.setSslProxy(url);
    proxy.setHttpProxy(url);
    //proxy.setFtpProxy(url);
    this.desiredCapabilities.setCapability(CapabilityType.PROXY, proxy);
    //System.out.println("Setting Proxy to " + url);
    this.proxyUrl = url;
    return this;
  }

  public Selenium openBrowser() {
    this.driver = new FirefoxDriver(this.desiredCapabilities);
    //System.out.println("SeleniumWrapper: Proxy is set to " + proxyUrl);
    //System.out.println("SeleniumWrapper: Base is set to " + baseUrl);
    this.selenium = new WebDriverBackedSelenium(this.driver, this.baseUrl);
    return this.selenium;
  }
}
