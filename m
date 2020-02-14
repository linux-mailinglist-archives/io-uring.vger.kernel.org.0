Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DE015D865
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 14:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgBNN1c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 08:27:32 -0500
Received: from mail-shaon0132.outbound.protection.partner.outlook.cn ([42.159.164.132]:62456
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728405AbgBNN1c (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 Feb 2020 08:27:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nz2/sh2asEHkVTTXMCwFR+NW7/HEHrRl0cHYIXkyioOcq2nIqslgQL0RwUD0+Izm4NNoUI9QcTa2zCqJF+9VQGFviFQwQ0uljB9zpRN7vXFuVIX/ohHaOZYo/9XLQfS6kg5s2sCDeL9AoH7kuW2Ltuk+Pz525gNbzqnG1JouKd7hH0jcWPQD2MM6Bm2G1YEoMgGKHM2HoXGeESECT5vTzyB++ihjBC+PJLFoUymGdx1C60ChL/tJILpfKiPya2lv8JdQ0FOYd/Dicwxl1OKcF8uTnxIu+thQwRE+RU30EK86jttwqipSUcKkLTsLyAPrZUCtmyy/77mKITA+si72qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4wG68g9HHC8x+HbUAWcHNwHwx2d33sCpoHifDiiBFI=;
 b=kgM84lBe5ruRSU8T/PscdxUL3wjNzK3qpTbZtRpUuRvyGq3R/n/upMaBdBQ5et3rQasoXdqRZKVEG4+UCDQjBWfEUc38xZgQlz0YfgOvbE0cDDYXUbG4abBw0nvZR5jz5uQrCd2Nr3Yv9CUUQq0fJD7p7wGQtMopYLsdgmqkWrpCIsAZNWu9LVi5M8YAsrvRtvSMpPzxSj7y12PA26/BnedDz/XyDUCGaEwvmQxNsUjw0q95LtwDjisNUzfDzTZe6S+zauHtrYo9dip0FDbM4SX9MN0FaFYbeX+adL49Yu59dE6AzLPyMDNfVg4r6NsSbfJC8UX8weh62mc0BFPU5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4wG68g9HHC8x+HbUAWcHNwHwx2d33sCpoHifDiiBFI=;
 b=Lh4UaxHXaujgXlT85o0HsinvXO6vYtlIycV9N4GRTeR/D9dXXHBt5AkVTJpbf/AQw7QVAr/uRF0X7IrD1tE7JAMMfJNUp+rXWKCz/0yWXaooR0j3XrffSqRHsURj8oNFkpIMorEeRPYn9471lxzcIgA78FJ87u/vYBhTWKAcV/g=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0539.CHNPR01.prod.partner.outlook.cn (10.43.108.82) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23; Fri, 14 Feb
 2020 13:27:27 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Fri, 14 Feb 2020 13:27:27 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [FEATURE REQUEST] Specify a sqe won't generate a cqe
Thread-Topic: [FEATURE REQUEST] Specify a sqe won't generate a cqe
Thread-Index: AQHV4xDdjkRpeTIk4EOwWEL6ELxawKgafmoAgAAPDwCAABd/AIAACeWA
Date:   Fri, 14 Feb 2020 13:27:27 +0000
Message-ID: <57BDF3A6-7279-4250-B200-76FDCDB04765@eoitek.com>
References: <9A41C624-3D2C-40BC-A910-59CBDC5BB76E@eoitek.com>
 <30d88cf3-527e-4396-4934-fff13c449a80@gmail.com>
 <7C48911C-9C0F-42E1-90DA-7C277E37D986@eoitek.com>
 <19236051-0949-ed5c-d1d5-458c07681f36@gmail.com>
In-Reply-To: <19236051-0949-ed5c-d1d5-458c07681f36@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [183.200.9.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c06f8094-b17c-44ef-da63-08d7b151a290
x-ms-traffictypediagnostic: SH0PR01MB0539:
x-microsoft-antispam-prvs: <SH0PR01MB0539B176C8ED0F4A78D8153C94150@SH0PR01MB0539.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(189003)(199004)(328002)(329002)(76116006)(2616005)(63696004)(71200400001)(86362001)(95416001)(2906002)(8676002)(66476007)(66556008)(81166006)(81156014)(53546011)(186003)(66946007)(5660300002)(59450400001)(64756008)(966005)(26005)(66446008)(508600001)(36756003)(8936002)(4326008)(6916009)(85182001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0539;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JZpu3C0vUdaAukRGhv6iLed8292+kFg3VslDYEzDKm0aCWyxOnq+CKXlk2qCLIToP3/ygnxrJFlTsuM/aR3QNtPViuWu4pSr48pk20wkAZKKnm/HkYHowmCqNo/T3sdwe805d/zoNS0KqYTLTeJ/6VXVKQfR1v6UIpkeGhk3N0yrKUvW6gfbSeI4FyoD4btwx5r6NgQUtVk/2xGbjLAhzddSU/EmKtkDHhQvlzHyfoE5QZoC/Cu9Jpeyf8wmhSDcrJLabkYby+2Y3eGFBPNMC+cVkuJMBhI6gOW85vYg0kkkdYULFshoki8enhFzh3V8/IaioTsetVtx56+EOgvzuozT0mCLH5yTtBJDNvJZEblj2ZcvH/yMXeKsUf37cDdp+wxlmyVHhaESVVaWt0o/MnsmB1fedjBYFwnGq72s6JD57VmYhd22K5XN4phllJ0QwvREUbrwhhXzob0iZnWX0fJmpiS6i2HZl3HlsE2+QU7T0BfwSnxcptYLvuk3uMIahxVvZvscWy3InxZGJb+/OA==
x-ms-exchange-antispam-messagedata: R01J9wz0jPkQ7Wg6o97rj5qrD1kkZ06rlvZCUZ8sOJI05ejf1eZMmGmiESq5/jC761MXTSri2QwG7IXr5KIq6P8cXMbYqDKkx2cZ6ybNlt1MTRVR6LT1YsKpbTdqLQ/IAWyvnEWz6EwaBDssffmCbA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BA383A027690D43BF93F848B979A9D6@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06f8094-b17c-44ef-da63-08d7b151a290
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 13:27:27.1605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0HaZctROisS8fmH9hbE+OmwgWLanGvFbkq3IMYuE44AP4iYwqN9KP9IxsyuQ2u8XHavLWGy0O9zeweS0XV4Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0539
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

DQoNCj4gMjAyMOW5tDLmnIgxNOaXpSDkuIvljYg4OjUy77yMUGF2ZWwgQmVndW5rb3YgPGFzbWwu
c2lsZW5jZUBnbWFpbC5jb20+IOWGmemBk++8mg0KPiANCj4gT24gMi8xNC8yMDIwIDI6MjcgUE0s
IENhcnRlciBMaSDmnY7pgJrmtLIgd3JvdGU6DQo+PiANCj4+PiAyMDIw5bm0MuaciDE05pelIOS4
i+WNiDY6MzTvvIxQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4g5YaZ6YGT
77yaDQo+Pj4gDQo+Pj4gT24gMi8xNC8yMDIwIDExOjI5IEFNLCBDYXJ0ZXIgTGkg5p2O6YCa5rSy
IHdyb3RlOg0KPj4+PiBUbyBpbXBsZW1lbnQgaW9fdXJpbmdfd2FpdF9jcWVfdGltZW91dCwgd2Ug
aW50cm9kdWNlIGEgbWFnaWMgbnVtYmVyDQo+Pj4+IGNhbGxlZCBgTElCVVJJTkdfVURBVEFfVElN
RU9VVGAuIFRoZSBwcm9ibGVtIGlzIHRoYXQgbm90IG9ubHkgd2UNCj4+Pj4gbXVzdCBtYWtlIHN1
cmUgdGhhdCB1c2VycyBzaG91bGQgbmV2ZXIgc2V0IHNxZS0+dXNlcl9kYXRhIHRvDQo+Pj4+IExJ
QlVSSU5HX1VEQVRBX1RJTUVPVVQsIGJ1dCBhbHNvIGludHJvZHVjZSBleHRyYSBjb21wbGV4aXR5
IHRvDQo+Pj4+IGZpbHRlciBvdXQgVElNRU9VVCBjcWVzLg0KPj4+PiANCj4+Pj4gRm9ybWVyIGRp
c2N1c3Npb246IGh0dHBzOi8vZ2l0aHViLmNvbS9heGJvZS9saWJ1cmluZy9pc3N1ZXMvNTMNCj4+
Pj4gDQo+Pj4+IEnigJltIHN1Z2dlc3RpbmcgaW50cm9kdWNpbmcgYSBuZXcgU1FFIGZsYWcgY2Fs
bGVkIElPU1FFX0lHTk9SRV9DUUUNCj4+Pj4gdG8gc29sdmUgdGhpcyBwcm9ibGVtLg0KPj4+PiAN
Cj4+Pj4gRm9yIGEgc3FlIHRhZ2dlZCB3aXRoIElPU1FFX0lHTk9SRV9DUUUgZmxhZywgaXQgd29u
4oCZdCBnZW5lcmF0ZSBhIGNxZQ0KPj4+PiBvbiBjb21wbGV0aW9uLiBTbyB0aGF0IElPUklOR19P
UF9USU1FT1VUIGNhbiBiZSBmaWx0ZXJlZCBvbiBrZXJuZWwNCj4+Pj4gc2lkZS4NCj4+Pj4gDQo+
Pj4+IEluIGFkZGl0aW9uLCBgSU9TUUVfSUdOT1JFX0NRRWAgY2FuIGJlIHVzZWQgdG8gc2F2ZSBj
cSBzaXplLg0KPj4+PiANCj4+Pj4gRm9yIGV4YW1wbGUgYFBPTExfQUREKFBPTExJTiktPlJFQUQv
UkVDVmAgbGluayBjaGFpbiwgcGVvcGxlIHVzdWFsbHkNCj4+Pj4gZG9u4oCZdCBjYXJlIHRoZSBy
ZXN1bHQgb2YgYFBPTExfQUREYCBpcyAoIHNpbmNlIGl0IHdpbGwgYWx3YXlzIGJlDQo+Pj4+IFBP
TExJTiApLCBgSU9TUUVfSUdOT1JFX0NRRWAgY2FuIGJlIHNldCBvbiBgUE9MTF9BRERgIHRvIHNh
dmUgbG90cw0KPj4+PiBvZiBjcSBzaXplLg0KPj4+PiANCj4+Pj4gQmVzaWRlcyBQT0xMX0FERCwg
cGVvcGxlIHVzdWFsbHkgZG9u4oCZdCBjYXJlIHRoZSByZXN1bHQgb2YgUE9MTF9SRU1PVkUNCj4+
Pj4gL1RJTUVPVVRfUkVNT1ZFL0FTWU5DX0NBTkNFTC9DTE9TRS4gVGhlc2Ugb3BlcmF0aW9ucyBj
YW4gYWxzbyBiZSB0YWdnZWQNCj4+Pj4gd2l0aCBJT1NRRV9JR05PUkVfQ1FFLg0KPj4+PiANCj4+
Pj4gVGhvdWdodHM/DQo+Pj4+IA0KPj4+IA0KPj4+IEkgbGlrZSB0aGUgaWRlYSEgQW5kIHRoYXQn
cyBvbmUgb2YgbXkgVE9ET3MgZm9yIHRoZSBlQlBGIHBsYW5zLg0KPj4+IExldCBtZSBsaXN0IG15
IHVzZSBjYXNlcywgc28gd2UgY2FuIHRoaW5rIGhvdyB0byBleHRlbmQgaXQgYSBiaXQuDQo+Pj4g
DQo+Pj4gMS4gSW4gY2FzZSBvZiBsaW5rIGZhaWwsIHdlIG5lZWQgdG8gcmVhcCBhbGwgLUVDQU5D
RUxMRUQsIGFuYWxpc2UgaXQgYW5kDQo+Pj4gcmVzdWJtaXQgdGhlIHJlc3QuIEl0J3MgcXVpdGUg
aW5jb252ZW5pZW50LiBXZSBtYXkgd2FudCB0byBoYXZlIENRRSBvbmx5DQo+Pj4gZm9yIG5vdCBj
YW5jZWxsZWQgcmVxdWVzdHMuDQo+Pj4gDQo+Pj4gMi4gV2hlbiBjaGFpbiBzdWNjZWVkZWQsIHlv
dSBpbiB0aGUgbW9zdCBjYXNlcyBhbHJlYWR5IGtub3cgdGhlIHJlc3VsdA0KPj4+IG9mIGFsbCBp
bnRlcm1lZGlhdGUgQ1FFcywgYnV0IHlvdSBzdGlsbCBuZWVkIHRvIHJlYXAgYW5kIG1hdGNoIHRo
ZW0uDQo+Pj4gSSdkIHByZWZlciB0byBoYXZlIG9ubHkgMSBDUUUgcGVyIGxpbmssIHRoYXQgaXMg
ZWl0aGVyIGZvciB0aGUgZmlyc3QNCj4+PiBmYWlsZWQgb3IgZm9yIHRoZSBsYXN0IHJlcXVlc3Qg
aW4gdGhlIGNoYWluLg0KPj4+IA0KPj4+IFRoZXNlIDIgbWF5IHNoZWQgbXVjaCBwcm9jZXNzaW5n
IG92ZXJoZWFkIGZyb20gdGhlIHVzZXJzcGFjZS4NCj4+IA0KPj4gSSBjb3VsZG4ndCBhZ3JlZSBt
b3JlIQ0KPj4gDQo+PiBBbm90aGVyIHByb2JsZW0gaXMgdGhhdCBpb191cmluZ19lbnRlciB3aWxs
IGJlIGF3YWtlZCBmb3IgY29tcGxldGlvbiBvZg0KPj4gZXZlcnkgb3BlcmF0aW9uIGluIGEgbGlu
aywgd2hpY2ggcmVzdWx0cyBpbiB1bm5lY2Vzc2FyeSBjb250ZXh0IHN3aXRjaC4NCj4+IFdoZW4g
YXdha2VkLCB1c2VycyBoYXZlIG5vdGhpbmcgdG8gZG8gYnV0IGlzc3VlIGFub3RoZXIgaW9fdXJp
bmdfZW50ZXINCj4+IHN5c2NhbGwgdG8gd2FpdCBmb3IgY29tcGxldGlvbiBvZiB0aGUgZW50aXJl
IGxpbmsgY2hhaW4uDQo+IA0KPiBHb29kIHBvaW50LiBTb3VuZHMgbGlrZSBJIGhhdmUgb25lIG1v
cmUgdGhpbmcgdG8gZG8gOikNCj4gV291bGQgdGhlIGJlaGF2aW91ciBhcyBpbiB0aGUgKDIpIGNv
dmVyIGFsbCB5b3VyIG5lZWRzPw0KDQooMikgc2hvdWxkIGNvdmVyIG1vc3QgY2FzZXMgZm9yIG1l
LiBGb3IgY2FzZXMgaXQgY291bGRu4oCZdCBjb3ZlciAoIGlmIGFueSApLA0KSSBjYW4gc3RpbGwg
dXNlIG5vcm1hbCBzcWVzLg0KDQo+IA0KPiBUaGVyZSBpcyBhIG51aXNhbmNlIHdpdGggbGlua2Vk
IHRpbWVvdXRzLCBidXQgSSB0aGluayBpdCdzIHJlYXNvbmFibGUNCj4gZm9yIFJFUS0+TElOS0VE
X1RJTUVPVVQsIHdoZXJlIGl0IGRpZG4ndCBmaXJlZCwgbm90aWZ5IG9ubHkgZm9yIFJFUQ0KPiAN
Cj4+PiANCj4+PiAzLiBJZiB3ZSBnZW5lcmF0ZSByZXF1ZXN0cyBieSBlQlBGIGV2ZW4gdGhlIG5v
dGlvbiBvZiBwZXItcmVxdWVzdCBldmVudA0KPj4+IG1heSBicm9rZS4NCj4+PiAtIGVCUEYgY3Jl
YXRpbmcgbmV3IHJlcXVlc3RzIHdvdWxkIGFsc28gbmVlZCB0byBzcGVjaWZ5IHVzZXItZGF0YSwg
YW5kDQo+Pj4gdGhpcyBtYXkgYmUgcHJvYmxlbWF0aWMgZnJvbSB0aGUgdXNlciBwZXJzcGVjdGl2
ZS4NCj4+PiAtIG1heSB3YW50IHRvIG5vdCBnZW5lcmF0ZSBDUUVzIGF1dG9tYXRpY2FsbHksIGJ1
dCBsZXQgZUJQRiBkbyBpdC4NCj4+PiANCj4+PiAtLSANCj4+PiBQYXZlbCBCZWd1bmtvdg0KPj4g
DQo+IA0KPiAtLSANCj4gUGF2ZWwgQmVndW5rb3YNCg0K
