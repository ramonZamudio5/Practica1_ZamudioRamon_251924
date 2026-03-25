*** Settings ***
Documentation    Suite de 10 pruebas automatizadas para SauceDemo
Library          SeleniumLibrary
Suite Setup      Set Selenium Speed    0.3s
Suite Teardown   Close All Browsers

*** Variables ***
${URL}           https://www.saucedemo.com/
${NAVEGADOR}     Chrome
${USER_OK}       standard_user
${USER_BAD}      locked_out_user
${PASSWORD}      secret_sauce

*** Keywords ***
Abrir Sauce Demo
    Open Browser    ${URL}    ${NAVEGADOR}
    Maximize Browser Window

Login Con Usuario
    [Arguments]    ${usuario}    ${password}
    Input Text      id=user-name    ${usuario}
    Input Text      id=password     ${password}
    Click Button    id=login-button

*** Test Cases ***

1. Intentar Login con contraseña incorrecta
    [Documentation]    Verifica que muestre error con credenciales malas.
    Abrir Sauce Demo
    Login Con Usuario    ${USER_OK}    clave_equivocada
    Element Should Contain    css=.error-message-container    Epic sadface

2. Intentar Login con usuario bloqueado
    [Documentation]    Verifica el mensaje exacto cuando el usuario está bloqueado.
    Go To    ${URL}
    Login Con Usuario    ${USER_BAD}    ${PASSWORD}
    Element Should Contain    css=.error-message-container    locked out

3. Login Exitoso
    [Documentation]    Ingresa con el usuario correcto.
    Go To    ${URL}
    Login Con Usuario    ${USER_OK}    ${PASSWORD}
    Element Should Be Visible    id=inventory_container

4. Verificar titulo del catalogo
    [Documentation]    Valida que estemos en la página de Productos.
    Element Text Should Be    css=.title    Products

5. Agregar mochila al carrito
    [Documentation]    Hace clic en el botón de agregar la mochila.
    Wait Until Element Is Visible    id=add-to-cart-sauce-labs-backpack    timeout=5s
    Click Element    id=add-to-cart-sauce-labs-backpack
    Wait Until Element Is Visible    id=remove-sauce-labs-backpack    timeout=5s

6. Verificar contador del carrito
    [Documentation]    El icono del carrito debe mostrar un "1".
    Wait Until Element Is Visible    css=.shopping_cart_badge    timeout=5s
    Element Text Should Be    css=.shopping_cart_badge    1

7. Entrar al carrito y verificar producto
    [Documentation]    Abre el carrito y revisa que la mochila esté allí.
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.inventory_item_name    timeout=5s
    Element Text Should Be    css=.inventory_item_name    Sauce Labs Backpack

8. Ir al Checkout y llenar datos
    [Documentation]    Avanza en el proceso de compra y llena el formulario.
    Wait Until Element Is Visible    id=checkout    timeout=5s
    Click Button    id=checkout
    Wait Until Element Is Visible    id=first-name    timeout=5s
    Input Text      id=first-name    Juan
    Input Text      id=last-name     Perez
    Input Text      id=postal-code   12345
    Click Button    id=continue
    Wait Until Element Is Visible    css=.title    timeout=5s
    Element Text Should Be    css=.title    Checkout: Overview

9. Finalizar compra
    [Documentation]    Termina el pedido y verifica el mensaje de éxito.
    Wait Until Element Is Visible    id=finish    timeout=5s
    Click Button    id=finish
    Wait Until Element Is Visible    css=.complete-header    timeout=5s
    Element Text Should Be    css=.complete-header    Thank you for your order!

10. Cerrar sesion
    [Documentation]    Abre el menú lateral y hace logout.
    Wait Until Element Is Visible    id=back-to-products    timeout=5s
    Click Button    id=back-to-products
    Wait Until Element Is Visible    id=react-burger-menu-btn    timeout=5s
    Click Button    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=logout_sidebar_link    timeout=5s
    Click Element   id=logout_sidebar_link
    Wait Until Element Is Visible    id=login-button    timeout=5s
    Element Should Be Visible    id=login-button