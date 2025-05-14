package ua.kuli.setup;

import com.codeborne.selenide.Configuration;
import com.codeborne.selenide.WebDriverRunner;
import com.codeborne.selenide.logevents.SelenideLogger;
import io.qameta.allure.Attachment;
import io.qameta.allure.selenide.AllureSelenide;
import org.junit.jupiter.api.BeforeAll;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.chrome.ChromeOptions;

public class Setup {

    @BeforeAll
    static void setup() {
        Configuration.browser = "chrome";
        Configuration.baseUrl = "https://kuli.com.ua";
        Configuration.headless = true;
//        Configuration.reportsFolder = "build/reports/tests";
        Configuration.browserCapabilities =
                new ChromeOptions()
                        .addArguments("--no-sandbox")
                        .addArguments("--disable-gpu=false")
                        .addArguments(
                                "--disable-extensions",
                                "--disable-infobars",
                                "--disable-dev-shm-usage");
        Configuration.browserSize = "1920x1080";

        SelenideLogger.addListener("AllureSelenide",
                new AllureSelenide()
                        .screenshots(true)
                        .savePageSource(true));
    }

    @Attachment(value = "Screenshot", type = "image/png")
    public byte[] screenshot() {
        return ((TakesScreenshot) WebDriverRunner.getWebDriver())
                .getScreenshotAs(OutputType.BYTES);
    }
}
