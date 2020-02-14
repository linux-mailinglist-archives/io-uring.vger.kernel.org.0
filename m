Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5715CF76
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 02:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBNB0B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 20:26:01 -0500
Received: from mail-shaon0147.outbound.protection.partner.outlook.cn ([42.159.164.147]:27110
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728154AbgBNB0A (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 13 Feb 2020 20:26:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0oLAKRsr6mpMrVVNXopvI9aOM3toju8WyuhBDUT8KvYbRY9EkCVXbVbf5wQRkieqrb+dMIN3TzU+xMxHOzP9zr582DZZyv4wlNkxVVX1/cHdXUrery+1xGnduK3t2NZaK0AtyhAq17vFm0bZW3g/QYPm1n5x90rAtql7kN+wyUQW8SqaaYZaFvAR4h0gUOriH4b5cQ5iazwUjGf+AiSoHyv5aRxSFYt42Tn9KsVMuqSuCYaDGlgY9bbHVbik2MjBNLG/95H7PVv6t7Jfm6qbuOuHHxHCfvyUahJaaTEzeqF45j4YFGfz29uGiuBfgL1I2O02AnRQ4uj+IERS11hfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPTSfULASpsl3s/+LoSuuCgM5WTOsQ1eC5PGRYJG+mQ=;
 b=myNcwmsmbsLJJenYnNMIxbal00xmQzdYYvLGOlFAXLAnBBkoOIF1U4dFEpvVeFFS1SjyvhS7OnDnOXDo4cBiFNb/n75psQR91BzbQqN90iUHdMiLudb9bC82URK+NOTa54a5aNqkS/Tin/tH7aDzuZC/nuPAYURhudxTKK3BMBozkQUnNgKDMag8NtqWpqZyMYyf54tkhTq8p7veWFJP8JKvIIKlZ6U2Ul0zlT9fOr8j1uvgDuqo4WsvMAst1cYBUd0Y4FbsC+gG45CPWvXCaZiQ/7WL9MtsaHUHe5ne3efemB92HWN3YR1iD0iDP7muwUdwGq2YYGoM2ajullzoHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPTSfULASpsl3s/+LoSuuCgM5WTOsQ1eC5PGRYJG+mQ=;
 b=gGCFSZTsH//iCFUIDtdiPz6RYJtGxXSKWKSv8/u+IycB2b1PIJKr0jkpolR6FnKB89JA5iYIPmMUjVKxKPQH/x1O3QxUFJfge8LSK2V/EavPBRPnLlYUxxv1SZVXlXUsnbFCEKZod8D3kDYWl2AspvJOuX1pF975ywvphqC7Tcc=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0553.CHNPR01.prod.partner.outlook.cn (10.43.108.140) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23; Fri, 14 Feb
 2020 01:25:56 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Fri, 14 Feb 2020 01:25:56 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Topic: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Index: AQHV4cHhpj4vlwaolEOmZJk1sNu8q6gXy2CAgAB7iICAAPRcgIAAAeCAgAAKIQCAAKCdAA==
Date:   Fri, 14 Feb 2020 01:25:56 +0000
Message-ID: <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
In-Reply-To: <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [111.68.10.170]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a79c06c8-8574-4249-cdcc-08d7b0ecd6fe
x-ms-traffictypediagnostic: SH0PR01MB0553:
x-microsoft-antispam-prvs: <SH0PR01MB05531EF18BFDEB56ABB8CF2E94150@SH0PR01MB0553.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(328002)(189003)(329002)(199004)(66476007)(66556008)(5660300002)(53546011)(508600001)(8936002)(966005)(59450400001)(71200400001)(63696004)(2616005)(36756003)(76116006)(26005)(186003)(2906002)(64756008)(66446008)(66946007)(95416001)(54906003)(8676002)(81166006)(81156014)(6916009)(33656002)(86362001)(4326008)(85182001);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0553;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S2VD8zydYIgW3foNj6oO9pneSQzSHhS60qsk1FnpOIDYyYek8uYDipd0ITDVSH/jRnXrKT+0gaaZ0T4bdjUiJpRx4SEy0snB47BZYBYyMJDDT3loYOPc5IWwB0IRSwU7YMEg9iQJB72zhbNn6W1eEsXrqEiq+DBFuU6zdHxh8Itay6YcDyyw3kVoI5TdU0ZQzz3ewnkDf9Mm1tyVTjpzvm93iAoXqGEcI6dtoL++9MV6jaCnMjQ5ItxKFzh4q+hy3cEBIObKAaHRbZqqi5MxRSUkyJPeiV769+n3CLezv0pJosvgmuI7gRhqez5BPBTo9VJpiCzmNhzjx1ozFNFqZkSqyJqcDZSrru9EmwUwY6TW4q6uWQCSK6a7gGMC+OewLkSSQ+WAzs8EjaJFyJbdXPsxwSLbQFZfKiDTBxS2PAHHW0T5O8/JXPJ59B0rcZ0rf5lBbzO0axKVi9hCgs+t9dJQ9DEFEizVHPbf9O4q+O2jy37Rido0izsYx0rJrrR80EQvKlcNq1nVwZQYV9UfRg==
x-ms-exchange-antispam-messagedata: ZTUssBcihERdVuG9AlYOWRJrOrUr37Fji7JR1OTDBNIXZAgZylY+CCVQwzaqG9oZ2yH3MundHb7cwM6rysxNznKTzObCM51dRiGr0GkWR8FP6GdXL/bjfMJBXu8eJKBqxOmuAYhS1fIz4TxXkw/AzQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BFBB9F7B1E0B843BECD611AFCFCD78A@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79c06c8-8574-4249-cdcc-08d7b0ecd6fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 01:25:56.1458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tflBf1EbDbCdkK9coAhrOU6NHQoMaxfRyMnOLnSk4hFxc2RqNDXSlmSrpzTvI6XZBF9PLVOGSzZD/OrVBK/CKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0553
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

QW5vdGhlciBzdWdnZXN0aW9uOiB3ZSBzaG91bGQgYWx3YXlzIHRyeSBjb21wbGV0aW5nIG9wZXJh
dGlvbnMgaW5saW5lDQp1bmxlc3MgSU9TUUVfQVNZTkMgaXMgc3BlY2lmaWVkLCBubyBtYXR0ZXIg
aWYgdGhlIG9wZXJhdGlvbnMgYXJlIHByZWNlZGVkDQpieSBhIHBvbGwuDQoNCkNhcnRlcg0KDQo+
IDIwMjDlubQy5pyIMTPml6Ug5LiL5Y2IMTE6NTHvvIxDYXJ0ZXIgTGkg5p2O6YCa5rSyIDxjYXJ0
ZXIubGlAZW9pdGVrLmNvbT4g5YaZ6YGT77yaDQo+IA0KPiANCj4gDQo+PiAyMDIw5bm0MuaciDEz
5pelIOS4i+WNiDExOjE077yMSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPiDlhpnpgZPvvJoN
Cj4+IA0KPj4gT24gMi8xMy8yMCA4OjA4IEFNLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToNCj4+PiBP
biAyLzEzLzIwMjAgMzozMyBBTSwgQ2FydGVyIExpIOadjumAmua0siB3cm90ZToNCj4+Pj4gVGhh
bmtzIGZvciB5b3VyIHJlcGx5Lg0KPj4+PiANCj4+Pj4gWW91IGFyZSByaWdodCB0aGUgbm9wIGlz
bid0IHJlYWxseSBhIGdvb2QgdGVzdCBjYXNlLiBCdXQgSSBhY3R1YWxseQ0KPj4+PiBmb3VuZCB0
aGlzIGlzc3VlIHdoZW4gYmVuY2htYXJraW5nIG15IGVjaG8gc2VydmVyLCB3aGljaCBkaWRuJ3Qg
dXNlDQo+Pj4+IE5PUCBvZiBjb3Vyc2UuDQo+Pj4gDQo+Pj4gSWYgdGhlcmUgYXJlIG5vIGhpZGRl
biBzdWJ0bGUgaXNzdWVzIGluIGlvX3VyaW5nLCB5b3VyIGJlbmNobWFyayBvciB0aGUNCj4+PiB1
c2VkIHBhdHRlcm4gaXRzZWxmLCBpdCdzIHByb2JhYmx5IGJlY2F1c2Ugb2Ygb3ZlcmhlYWQgb24g
YXN5bmMgcHVudGluZw0KPj4+IChjb3B5aW5nIGlvdmVjcywgc2V2ZXJhbCBleHRyYSBzd2l0Y2hl
cywgcmVmY291bnRzLCBncmFiYmluZyBtbS9mcy9ldGMsDQo+Pj4gaW8td3EgaXRzZWxmKS4NCj4+
PiANCj4+PiBJIHdhcyBnb2luZyB0byB0dW5lIGFzeW5jL3B1bnRpbmcgc3R1ZmYgYW55d2F5LCBz
byBJJ2xsIGxvb2sgaW50byB0aGlzLg0KPj4+IEFuZCBvZiBjb3Vyc2UsIHRoZXJlIGlzIGFsd2F5
cyBhIGdvb2QgY2hhbmNlIEplbnMgaGF2ZSBzb21lIGJyaWdodCBpbnNpZ2h0cw0KPj4gDQo+PiBU
aGUgbWFpbiBpc3N1ZSBoZXJlIGlzIHRoYXQgaWYgeW91IGRvIHRoZSBwb2xsLT5yZWN2LCB0aGVu
IGl0J2xsIGJlDQo+PiBhbiBhdXRvbWF0aWMgcHVudCBvZiB0aGUgcmVjdiB0byBhc3luYyBjb250
ZXh0IHdoZW4gdGhlIHBvbGwgY29tcGxldGVzLg0KPj4gVGhhdCdzIHJlZ2FyZGxlc3Mgb2Ygd2hl
dGhlciBvciBub3Qgd2UgY2FuIGNvbXBsZXRlIHRoZSBwb2xsIGlubGluZSwNCj4+IHdlIG5ldmVy
IGF0dGVtcHQgdG8gcmVjdiBpbmxpbmUgZnJvbSB0aGF0IGNvbXBsZXRpb24uIFRoaXMgaXMgaW4g
Y29udHJhc3QNCj4+IHRvIGRvaW5nIGEgc2VwYXJhdGUgcG9sbCwgZ2V0dGluZyB0aGUgbm90aWZp
Y2F0aW9uLCB0aGVuIGRvaW5nIGFub3RoZXINCj4+IHNxZSBhbmQgaW9fdXJpbmdfZW50ZXIgdG8g
cGVyZm9ybSB0aGUgcmVjdi4gRm9yIHRoaXMgY2FzZSwgd2UgZW5kIHVwDQo+PiBkb2luZyBldmVy
eXRoaW5nIGlubGluZSwganVzdCB3aXRoIHRoZSBjb3N0IG9mIGFuIGFkZGl0aW9uYWwgc3lzdGVt
IGNhbGwNCj4+IHRvIHN1Ym1pdCB0aGUgbmV3IHJlY3YuDQo+PiANCj4+IEl0J2QgYmUgcmVhbGx5
IGNvb2wgaWYgd2UgY291bGQgaW1wcm92ZSBvbiB0aGlzIHNpdHVhdGlvbiwgYXMgcmVjdiAob3IN
Cj4+IHJlYWQpIHByZWNlZGVkIGJ5IGEgcG9sbCBpcyBpbmRlZWQgYSBjb21tb24gdXNlIGNhc2Uu
IE9yIGRpdHRvIGZvciB0aGUNCj4+IHdyaXRlIHNpZGUuDQo+PiANCj4+PiBCVFcsIHdoYXQncyBi
ZW5lZml0IG9mIGRvaW5nIHBvbGwoZmQpLT5yZWFkKGZkKSwgYnV0IG5vdCBkaXJlY3RseSByZWFk
KCk/DQo+PiANCj4+IElmIHRoZXJlJ3Mgbm8gZGF0YSB0byBiZWdpbiB3aXRoLCB0aGVuIHRoZSBy
ZWFkIHdpbGwgZ28gYXN5bmMuIEhlbmNlDQo+PiBpdCdsbCBiZSBhIHN3aXRjaCB0byBhIHdvcmtl
ciB0aHJlYWQuIFRoZSBhYm92ZSBzaG91bGQgYXZvaWQgaXQsIGJ1dA0KPj4gaXQgZG9lc24ndC4N
Cj4gDQo+IFllcy4gSSBhY3R1YWxseSB0ZXN0ZWQgYGRpcmVjdGx5IHJlYWQoKWAgZmlyc3QsIGFu
ZCBmb3VuZCBpdCB3YXMgYWJvdXQgMzAlDQo+IHNsb3dlciB0aGVuIHBvbGwoZmQpLT5yZWFkKGZk
KS4NCj4gDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9heGJvZS9saWJ1cmluZy9pc3N1ZXMvNjkNCj4g
DQo+IFNvIGl0IHR1cm5zIG91dCB0aGF0IGFzeW5jIHB1bnRpbmcgaGFzIGhpZ2ggb3ZlcmhlYWQu
IEEgKHNpbGx5KSBxdWVzdGlvbjoNCj4gY291bGQgd2UgaW1wbGVtZW50IHJlYWQvd3JpdGUgb3Bl
cmF0aW9ucyB0aGF0IHdvdWxkIGJsb2NrIGFzIHBvbGwtPnJlYWQvd3JpdGU/DQo+IA0KPiANCj4+
IA0KPj4gRm9yIGNhcnRlcidzIHNha2UsIGl0J3Mgd29ydGggbm90aGluZyB0aGF0IHRoZSBwb2xs
IGNvbW1hbmQgaXMgc3BlY2lhbA0KPj4gYW5kIG5vcm1hbCByZXF1ZXN0cyB3b3VsZCBiZSBtb3Jl
IGVmZmljaWVudCB3aXRoIGxpbmtzLiBXZSBqdXN0IG5lZWQNCj4+IHRvIHdvcmsgb24gbWFraW5n
IHRoZSBwb2xsIGxpbmtlZCB3aXRoIHJlYWQvd3JpdGUgcGVyZm9ybSBtdWNoIGJldHRlci4NCj4g
DQo+IFRoYW5rcw0KPiANCj4+IA0KPj4gLS0gDQo+PiBKZW5zIEF4Ym9lDQoNCg==
