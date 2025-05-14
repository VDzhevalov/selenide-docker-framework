package ua.kuli.tests;

import io.qameta.allure.Description;
import io.qameta.allure.Story;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import ua.kuli.data.GameData;
import ua.kuli.pages.MainPage;
import ua.kuli.setup.Setup;

import static com.codeborne.selenide.Selenide.*;

public class MainPageTest extends Setup {

    @BeforeAll
    public static void setDataJsonFile(){
        GameData.setResourcePath("/test-data/games.json");
    }

    MainPage mainPage = new MainPage();

    @Story("ShowAllTranslations")
    @ParameterizedTest
    @MethodSource("ua.kuli.data.GameData#getDataFromJson")
    void canOpenGamePageAndCheckAllTranslationsButton(String searchQuery, String expectedTitle) {
        mainPage.openMainPage();
        mainPage.searchFor(searchQuery)
                .shouldHaveTitle(expectedTitle)
                .clickOnGame(expectedTitle)
                .shouldHaveShowAllTranslationsButton();
        screenshot();
    }

    @Story("MainPage Title")
    @Description()
    @Test
    void mainPageTitleShouldContainText() {
        open("/");
        mainPage.pageTitleShouldContain("Каталог української локалізації ігор");
    }
    @Story("MainPage HeaderMenu")
    @Description()
    @Test
    void mainPageShouldHaveHeaderMenu() {
        mainPage.openMainPage();
        mainPage.shouldHaveMenuLinks();
    }

    @Story("Game Title")
    @Description()
    @Test
    void gamePageShouldHaveTitle() {
        mainPage.openMainPage();
        mainPage.searchFor("Metro")
                .clickOnGame("Metro Awakening")
                .shouldHaveTitle("Metro Awakening");
        screenshot();
    }


    @Description()
    @Test
    void iWillFail() {
        mainPage.openMainPage();
        mainPage.searchFor("qwe")
                .clickOnGame("qwe")
                .shouldHaveShowAllTranslationsButton();
        screenshot();
    }
}
