Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EC115D685
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 12:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgBNL2F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 06:28:05 -0500
Received: from mail-bjbon0141.outbound.protection.partner.outlook.cn ([42.159.36.141]:12507
        "EHLO CN01-BJB-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728864AbgBNL2F (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 Feb 2020 06:28:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfZAETjxLuL40CirPauAkL2Po2UuZ2z9vwNaXAJiuYcV6YAx181S7tk9DseDTCN7Yde4EkolSzNEy4/GDaQixezKB618s6DweQw+VwX2BhaJsvUWEmJpTRd2SJbh4WaNlC56+2Cziw93T5fSvTAqTgHqKf4glqPTLZYzyLQSMP7oo7tyfHaJvAL9N3Ls03Z+6i8S6f/KjoMHrKCd6smGYrOp2nGro2OTqkoHOQnmHNuv0Vh1lgJoGb/Eph3R9MJTkHhP2J+IHWwRh5cSNAKzxHzFSndwv4SQm+eE7f6/x/sCdPaIgcuEVglpBcxFPOUOeLwXTtuTxai5/eNpoa3stg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW2B4XrA07BgiKbwoOLjFd4yjSpgxquLbn1QUAKIvM8=;
 b=AuCryi0eqsoMeEoK/KEkKqyvWzziviD0FNKN01PNYz3PZ9wpGsCSmiA28CBCGXyYlXDWzNl8EeGWGXHNFzuNnom0Mh0a6IaayuQ5bnCwwss+tCbN18g5BDTff98uhu9gc0fUwFQKAvc9zowQAv9r35h327oCBEwcd60xvBASqme34OtHoDjwKqkkdxUqZoJWKa9P5TKPOd5XfJO7RfZK6ViAJsTnu2y1VHCDWzr/pK2F2lxIPPqcbLxMahXILir3YVIxe9gW2mZKPCad//SdIu6RNGLvKHwMcF7ukORjoTBADlaU+TzwY9gVwyzWv2guvPpbzheP0rx6OlMBdTU/UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW2B4XrA07BgiKbwoOLjFd4yjSpgxquLbn1QUAKIvM8=;
 b=tF286Vt+1lxqjq01bcAAdaGq+bg4OaPXkrD/M00q7cRj0Wq8JTHITZy0TMP43zTIEh6koPJfyIvu1SOvqfIO4V3bAprggVd1tM183y41MQWPaMzjFijD4xqu5r0bUhEnSyDpg470vIhqi7kaNXa3uA0HPPD5VHNXJxdmPn8hk4k=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0585.CHNPR01.prod.partner.outlook.cn (10.43.108.11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23; Fri, 14 Feb
 2020 11:27:58 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Fri, 14 Feb 2020 11:27:58 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [FEATURE REQUEST] Specify a sqe won't generate a cqe
Thread-Topic: [FEATURE REQUEST] Specify a sqe won't generate a cqe
Thread-Index: AQHV4xDdjkRpeTIk4EOwWEL6ELxawKgafmoAgAAPDwA=
Date:   Fri, 14 Feb 2020 11:27:58 +0000
Message-ID: <7C48911C-9C0F-42E1-90DA-7C277E37D986@eoitek.com>
References: <9A41C624-3D2C-40BC-A910-59CBDC5BB76E@eoitek.com>
 <30d88cf3-527e-4396-4934-fff13c449a80@gmail.com>
In-Reply-To: <30d88cf3-527e-4396-4934-fff13c449a80@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [59.42.253.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 259c1f0a-90fe-4c7e-1920-08d7b140f18c
x-ms-traffictypediagnostic: SH0PR01MB0585:
x-microsoft-antispam-prvs: <SH0PR01MB05852194D9CBCF96B7E4C3CC94150@SH0PR01MB0585.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(328002)(189003)(329002)(199004)(66476007)(66556008)(5660300002)(53546011)(508600001)(8936002)(966005)(59450400001)(71200400001)(63696004)(2616005)(36756003)(76116006)(26005)(186003)(2906002)(64756008)(66446008)(66946007)(95416001)(8676002)(81166006)(81156014)(6916009)(33656002)(86362001)(4326008)(85182001);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0585;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UOfOktgffuK1It7nWy3A0JVSyls5rhKgWMEK4a4XiyZlkQ9P102EWdSVC0bs3LGPY6/6o3pfWGjMKGzo01Bb2CdsMuVEcXGuYuwRJGNM5Pw/cnPyTG3VnqMIuXJYHB4yosanM2DUWaqokPYAbX2GZRXjYMvh7mVBIf2KPLa7MrnbSyODRkPSCDjYpxkC5cT/tpGEEahPwCeIHFtSNqvOw6ZhtegEB0g7aECDg+F2tYiZPM2iv033RAq9zjQpN8AtjhF/5fIsWPFw/JgcZpPRHYlrpMBO/J83fDPorLGGUKzlL0xy+AbyE9hLg7zD81+f57NOTDXEP2CB7IgIiBNv9nPEYvtPrQtQZhFNQflsKHw7i53yfxq1ad5RYceuAm/K7skjo5UpBRCJMICvQEn7MOUVKfgrpL2eT6JxTKW5cjX8hw5dMTjYi2jiOnzsTQyv1VLnF2XWRqzjPVutl4MJKFHKA43OZ98GM3nC2JUWk4qnUHAx5MyWbdVESdv7g2mvxiVEl10o3iRE7uiCq8BR2A==
x-ms-exchange-antispam-messagedata: s3bM7FC9u67LLTy2s9BIX5kYMvFyV7HRiYsuMCE5izSG3X2aCqxhKDEGAv9MMopgvolV6oO4Y/KTibg2cPfpfynAtrPW7e5GnwWePEqQ8oQFsI3Zpdu+cu946FDqeiRVQZJJ+KJaqonZAyz3sy2TEg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <21DD900B64C66A48B3AE71E9CF299740@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259c1f0a-90fe-4c7e-1920-08d7b140f18c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 11:27:58.2439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkHCCMbURjh4lV8qUvpSIpVLnYhT0RBFiHqGemktKHP8m3D8Y4U2w1WE0N/0JpcDEGPPM+zb/B3S3/S/A00t5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0585
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

DQo+IDIwMjDlubQy5pyIMTTml6Ug5LiL5Y2INjozNO+8jFBhdmVsIEJlZ3Vua292IDxhc21sLnNp
bGVuY2VAZ21haWwuY29tPiDlhpnpgZPvvJoNCj4gDQo+IE9uIDIvMTQvMjAyMCAxMToyOSBBTSwg
Q2FydGVyIExpIOadjumAmua0siB3cm90ZToNCj4+IFRvIGltcGxlbWVudCBpb191cmluZ193YWl0
X2NxZV90aW1lb3V0LCB3ZSBpbnRyb2R1Y2UgYSBtYWdpYyBudW1iZXINCj4+IGNhbGxlZCBgTElC
VVJJTkdfVURBVEFfVElNRU9VVGAuIFRoZSBwcm9ibGVtIGlzIHRoYXQgbm90IG9ubHkgd2UNCj4+
IG11c3QgbWFrZSBzdXJlIHRoYXQgdXNlcnMgc2hvdWxkIG5ldmVyIHNldCBzcWUtPnVzZXJfZGF0
YSB0bw0KPj4gTElCVVJJTkdfVURBVEFfVElNRU9VVCwgYnV0IGFsc28gaW50cm9kdWNlIGV4dHJh
IGNvbXBsZXhpdHkgdG8NCj4+IGZpbHRlciBvdXQgVElNRU9VVCBjcWVzLg0KPj4gDQo+PiBGb3Jt
ZXIgZGlzY3Vzc2lvbjogaHR0cHM6Ly9naXRodWIuY29tL2F4Ym9lL2xpYnVyaW5nL2lzc3Vlcy81
Mw0KPj4gDQo+PiBJ4oCZbSBzdWdnZXN0aW5nIGludHJvZHVjaW5nIGEgbmV3IFNRRSBmbGFnIGNh
bGxlZCBJT1NRRV9JR05PUkVfQ1FFDQo+PiB0byBzb2x2ZSB0aGlzIHByb2JsZW0uDQo+PiANCj4+
IEZvciBhIHNxZSB0YWdnZWQgd2l0aCBJT1NRRV9JR05PUkVfQ1FFIGZsYWcsIGl0IHdvbuKAmXQg
Z2VuZXJhdGUgYSBjcWUNCj4+IG9uIGNvbXBsZXRpb24uIFNvIHRoYXQgSU9SSU5HX09QX1RJTUVP
VVQgY2FuIGJlIGZpbHRlcmVkIG9uIGtlcm5lbA0KPj4gc2lkZS4NCj4+IA0KPj4gSW4gYWRkaXRp
b24sIGBJT1NRRV9JR05PUkVfQ1FFYCBjYW4gYmUgdXNlZCB0byBzYXZlIGNxIHNpemUuDQo+PiAN
Cj4+IEZvciBleGFtcGxlIGBQT0xMX0FERChQT0xMSU4pLT5SRUFEL1JFQ1ZgIGxpbmsgY2hhaW4s
IHBlb3BsZSB1c3VhbGx5DQo+PiBkb27igJl0IGNhcmUgdGhlIHJlc3VsdCBvZiBgUE9MTF9BRERg
IGlzICggc2luY2UgaXQgd2lsbCBhbHdheXMgYmUNCj4+IFBPTExJTiApLCBgSU9TUUVfSUdOT1JF
X0NRRWAgY2FuIGJlIHNldCBvbiBgUE9MTF9BRERgIHRvIHNhdmUgbG90cw0KPj4gb2YgY3Egc2l6
ZS4NCj4+IA0KPj4gQmVzaWRlcyBQT0xMX0FERCwgcGVvcGxlIHVzdWFsbHkgZG9u4oCZdCBjYXJl
IHRoZSByZXN1bHQgb2YgUE9MTF9SRU1PVkUNCj4+IC9USU1FT1VUX1JFTU9WRS9BU1lOQ19DQU5D
RUwvQ0xPU0UuIFRoZXNlIG9wZXJhdGlvbnMgY2FuIGFsc28gYmUgdGFnZ2VkDQo+PiB3aXRoIElP
U1FFX0lHTk9SRV9DUUUuDQo+PiANCj4+IFRob3VnaHRzPw0KPj4gDQo+IA0KPiBJIGxpa2UgdGhl
IGlkZWEhIEFuZCB0aGF0J3Mgb25lIG9mIG15IFRPRE9zIGZvciB0aGUgZUJQRiBwbGFucy4NCj4g
TGV0IG1lIGxpc3QgbXkgdXNlIGNhc2VzLCBzbyB3ZSBjYW4gdGhpbmsgaG93IHRvIGV4dGVuZCBp
dCBhIGJpdC4NCj4gDQo+IDEuIEluIGNhc2Ugb2YgbGluayBmYWlsLCB3ZSBuZWVkIHRvIHJlYXAg
YWxsIC1FQ0FOQ0VMTEVELCBhbmFsaXNlIGl0IGFuZA0KPiByZXN1Ym1pdCB0aGUgcmVzdC4gSXQn
cyBxdWl0ZSBpbmNvbnZlbmllbnQuIFdlIG1heSB3YW50IHRvIGhhdmUgQ1FFIG9ubHkNCj4gZm9y
IG5vdCBjYW5jZWxsZWQgcmVxdWVzdHMuDQo+IA0KPiAyLiBXaGVuIGNoYWluIHN1Y2NlZWRlZCwg
eW91IGluIHRoZSBtb3N0IGNhc2VzIGFscmVhZHkga25vdyB0aGUgcmVzdWx0DQo+IG9mIGFsbCBp
bnRlcm1lZGlhdGUgQ1FFcywgYnV0IHlvdSBzdGlsbCBuZWVkIHRvIHJlYXAgYW5kIG1hdGNoIHRo
ZW0uDQo+IEknZCBwcmVmZXIgdG8gaGF2ZSBvbmx5IDEgQ1FFIHBlciBsaW5rLCB0aGF0IGlzIGVp
dGhlciBmb3IgdGhlIGZpcnN0DQo+IGZhaWxlZCBvciBmb3IgdGhlIGxhc3QgcmVxdWVzdCBpbiB0
aGUgY2hhaW4uDQo+IA0KPiBUaGVzZSAyIG1heSBzaGVkIG11Y2ggcHJvY2Vzc2luZyBvdmVyaGVh
ZCBmcm9tIHRoZSB1c2Vyc3BhY2UuDQoNCkkgY291bGRuJ3QgYWdyZWUgbW9yZSENCg0KQW5vdGhl
ciBwcm9ibGVtIGlzIHRoYXQgaW9fdXJpbmdfZW50ZXIgd2lsbCBiZSBhd2FrZWQgZm9yIGNvbXBs
ZXRpb24gb2YNCmV2ZXJ5IG9wZXJhdGlvbiBpbiBhIGxpbmssIHdoaWNoIHJlc3VsdHMgaW4gdW5u
ZWNlc3NhcnkgY29udGV4dCBzd2l0Y2guDQpXaGVuIGF3YWtlZCwgdXNlcnMgaGF2ZSBub3RoaW5n
IHRvIGRvIGJ1dCBpc3N1ZSBhbm90aGVyIGlvX3VyaW5nX2VudGVyDQpzeXNjYWxsIHRvIHdhaXQg
Zm9yIGNvbXBsZXRpb24gb2YgdGhlIGVudGlyZSBsaW5rIGNoYWluLg0KDQo+IA0KPiAzLiBJZiB3
ZSBnZW5lcmF0ZSByZXF1ZXN0cyBieSBlQlBGIGV2ZW4gdGhlIG5vdGlvbiBvZiBwZXItcmVxdWVz
dCBldmVudA0KPiBtYXkgYnJva2UuDQo+IC0gZUJQRiBjcmVhdGluZyBuZXcgcmVxdWVzdHMgd291
bGQgYWxzbyBuZWVkIHRvIHNwZWNpZnkgdXNlci1kYXRhLCBhbmQNCj4gIHRoaXMgbWF5IGJlIHBy
b2JsZW1hdGljIGZyb20gdGhlIHVzZXIgcGVyc3BlY3RpdmUuDQo+IC0gbWF5IHdhbnQgdG8gbm90
IGdlbmVyYXRlIENRRXMgYXV0b21hdGljYWxseSwgYnV0IGxldCBlQlBGIGRvIGl0Lg0KPiANCj4g
LS0gDQo+IFBhdmVsIEJlZ3Vua292DQoNCg==
