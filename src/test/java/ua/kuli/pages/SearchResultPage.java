package ua.kuli.pages;

import com.codeborne.selenide.SelenideElement;
import io.qameta.allure.Step;

import static com.codeborne.selenide.Condition.exist;
import static com.codeborne.selenide.Selenide.$x;

public class SearchResultPage {

    private SelenideElement getGameTitle(String expectedTitle){
        return $x("//h2[@class='product-title']//div[normalize-space()='" + expectedTitle + "']");
    }

    @Step
    public SearchResultPage shouldHaveTitle(String expectedTitle) {
        getGameTitle(expectedTitle).should(exist);
        return this;
    }

    @Step
    public GamePage clickOnGame(String expectedTitle){
        getGameTitle(expectedTitle).$x("./ancestor::div[@class='item-box']") .click();
        return new GamePage();
    }
}
