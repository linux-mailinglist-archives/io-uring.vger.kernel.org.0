Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A0815C4D7
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2020 16:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbgBMPvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 10:51:10 -0500
Received: from mail-shaon0151.outbound.protection.partner.outlook.cn ([42.159.164.151]:62707
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387677AbgBMPvK (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 13 Feb 2020 10:51:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSY/rnKttS0OXedKwCGs7eyUKzusps4HpXqRim3O16h9QhZJprA1DlcutFiuXZrmVLBubv6wx3VUYKiH7U1FeJhOfXOFrttLu5IWdcm4CgmIhPuAPI0QuzQR95r72rrLUOWZHJsxffcMHkGlACW95iem/OqhKdkdfKdChom9X8VtfHCeK57eJmtaQgIEjAyyQLcv92BTXXzSfa1ihDSx5D0xIx+/H6pO3J5hg8vWxPD+deQCMIkwk/jflPcrYh3oSudmP+OJjBN8yG7ogU8FzM8a+iKfzNkPrNsepbNgT5ORFSYePp90hzxpDYrfXoJ563R3RLe4nBck3v0e6Fnyag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4gM22flo1dA3jX9ieq6mw/cUV3ZiXGX3oKpp7vPUsk=;
 b=ScHccGvPUEOU1BiJbU0XDvLR0RWAJmifJh6HQokeDzZ29muyldA9Qbh8D3XUMMlEaZ72S3tpVDZZDRvRSyoVQZ+pnuChGef3iPyF4aEomo2HfipGU7vMf7zI2L3OHq3CJUF3XWIXWIKU2gl3OrSOKJlQQsjGXJ1H7qw+3a0wRy3AKCSXW8BfZBKWKujOihvNAfFtbV7SNuBeqseZzYSpop9oIku0Q6Xr6lvs7dc9BDyi33RPm2ku9hQ5aUg09QpQhF2Yfdog3qQTKuPGagLIXLARWeR1Egbok/CICdSRPSudhcapTVDNSb7aO0u5yWQuwAmOAjC65URRFEUXBg2SFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4gM22flo1dA3jX9ieq6mw/cUV3ZiXGX3oKpp7vPUsk=;
 b=pB3v+f3/OrkTmv83yfDLNFhfnxnV7uz8U2ON3ABMWyOnS9KQris4QgwXkHXl/VcneKcpriPtSb37ydLxWxQN/bTQp7chD6ipeyYYbgbKC3hEBdZJEUQS9lNukVJmGGOEiKisg09B2x1Nc8dYLFJsCbAtDsxUe3jX2DQZztK/nBU=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0555.CHNPR01.prod.partner.outlook.cn (10.43.108.86) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23; Thu, 13 Feb
 2020 15:51:03 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Thu, 13 Feb 2020 15:51:03 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Topic: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Index: AQHV4cHhpj4vlwaolEOmZJk1sNu8q6gXy2CAgAB7iICAAPRcgIAAAeCAgAAKIQA=
Date:   Thu, 13 Feb 2020 15:51:03 +0000
Message-ID: <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
In-Reply-To: <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [59.42.253.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7090274a-f7b4-4062-6760-08d7b09c8792
x-ms-traffictypediagnostic: SH0PR01MB0555:
x-microsoft-antispam-prvs: <SH0PR01MB05559AED2E5FB19D72BD2416941A0@SH0PR01MB0555.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(329002)(328002)(199004)(189003)(76116006)(54906003)(66476007)(66556008)(4326008)(8676002)(2616005)(81166006)(66446008)(85182001)(36756003)(64756008)(6916009)(59450400001)(53546011)(86362001)(95416001)(2906002)(26005)(186003)(81156014)(33656002)(8936002)(71200400001)(5660300002)(508600001)(63696004)(66946007)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0555;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6hK6c/GcJAgXUFxlRIDUiq0SOXn7Rr7OpxXgdIrHKU/OtNHySnPRppdBj0/WmwHE6CIAwHA/Cf6RDK260xMYKlJ3ZxgoPWlrjBC3y/H2SpNZFU/EMfw6FJkC0VXTpCE9BnSf2uea0vNo09KdpawUTdKH/4AIcphZMolY2WAAIJ7QGw38cK/uu1aoGoRkPF3x93CntJunLNs0dq6AcZMFyy2Son4vEH+IC7xz/XYpmJ69mrXSqOuU8EW8YnVbWjsbvAlT9RnxGgcYd41493gOr43jk+0XORAZkKFx2uYtP6kEp+KxutepS6BFnoCxdEShx9J3U6x0UGTTbfrwUDz/rf+SWv0N4UsowFiVZQyPz0nPbTrd3VoQVDS+NzxYBWwVB+O0sCikIkiwXoua99Uh1PbJKSyzVR6UZxlwTr/pCthGKUtLs3hFPC3Bs6PJmCeWInEzZEzLY1vEkE0wq+h9cJoORgng8yCCKVhES9IIN0Yd5jN47xY8QuKqmrXj9ra9mhEv839uzy+9WglFqwvYfQ==
x-ms-exchange-antispam-messagedata: 75RGe7i+WRn5zLQAlN617A6LEKXCl+t3mrRg76Y8x1lYW02cgDpJ2x38QRlbSL1EJXN8t2GW0pGi+YBS2gESSHarJuJs4/Qe65cftoBPFzmh0zdlqSwSSKr1HGdV8NiTPV8OBmyRcHhGlqUQ7EY0cw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <81F079C4B2DBA745AC611DC16E4EBBC0@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7090274a-f7b4-4062-6760-08d7b09c8792
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 15:51:03.0611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b/Y1X78wEFHZh5YYx06eBAf1DO1OiiLh0QuPQ1UBnIdfE3txpLwH3KpYLjsdViOS2EdvtS+1WdmuRBzwU8otYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0555
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

DQoNCj4gMjAyMOW5tDLmnIgxM+aXpSDkuIvljYgxMToxNO+8jEplbnMgQXhib2UgPGF4Ym9lQGtl
cm5lbC5kaz4g5YaZ6YGT77yaDQo+IA0KPiBPbiAyLzEzLzIwIDg6MDggQU0sIFBhdmVsIEJlZ3Vu
a292IHdyb3RlOg0KPj4gT24gMi8xMy8yMDIwIDM6MzMgQU0sIENhcnRlciBMaSDmnY7pgJrmtLIg
d3JvdGU6DQo+Pj4gVGhhbmtzIGZvciB5b3VyIHJlcGx5Lg0KPj4+IA0KPj4+IFlvdSBhcmUgcmln
aHQgdGhlIG5vcCBpc24ndCByZWFsbHkgYSBnb29kIHRlc3QgY2FzZS4gQnV0IEkgYWN0dWFsbHkN
Cj4+PiBmb3VuZCB0aGlzIGlzc3VlIHdoZW4gYmVuY2htYXJraW5nIG15IGVjaG8gc2VydmVyLCB3
aGljaCBkaWRuJ3QgdXNlDQo+Pj4gTk9QIG9mIGNvdXJzZS4NCj4+IA0KPj4gSWYgdGhlcmUgYXJl
IG5vIGhpZGRlbiBzdWJ0bGUgaXNzdWVzIGluIGlvX3VyaW5nLCB5b3VyIGJlbmNobWFyayBvciB0
aGUNCj4+IHVzZWQgcGF0dGVybiBpdHNlbGYsIGl0J3MgcHJvYmFibHkgYmVjYXVzZSBvZiBvdmVy
aGVhZCBvbiBhc3luYyBwdW50aW5nDQo+PiAoY29weWluZyBpb3ZlY3MsIHNldmVyYWwgZXh0cmEg
c3dpdGNoZXMsIHJlZmNvdW50cywgZ3JhYmJpbmcgbW0vZnMvZXRjLA0KPj4gaW8td3EgaXRzZWxm
KS4NCj4+IA0KPj4gSSB3YXMgZ29pbmcgdG8gdHVuZSBhc3luYy9wdW50aW5nIHN0dWZmIGFueXdh
eSwgc28gSSdsbCBsb29rIGludG8gdGhpcy4NCj4+IEFuZCBvZiBjb3Vyc2UsIHRoZXJlIGlzIGFs
d2F5cyBhIGdvb2QgY2hhbmNlIEplbnMgaGF2ZSBzb21lIGJyaWdodCBpbnNpZ2h0cw0KPiANCj4g
VGhlIG1haW4gaXNzdWUgaGVyZSBpcyB0aGF0IGlmIHlvdSBkbyB0aGUgcG9sbC0+cmVjdiwgdGhl
biBpdCdsbCBiZQ0KPiBhbiBhdXRvbWF0aWMgcHVudCBvZiB0aGUgcmVjdiB0byBhc3luYyBjb250
ZXh0IHdoZW4gdGhlIHBvbGwgY29tcGxldGVzLg0KPiBUaGF0J3MgcmVnYXJkbGVzcyBvZiB3aGV0
aGVyIG9yIG5vdCB3ZSBjYW4gY29tcGxldGUgdGhlIHBvbGwgaW5saW5lLA0KPiB3ZSBuZXZlciBh
dHRlbXB0IHRvIHJlY3YgaW5saW5lIGZyb20gdGhhdCBjb21wbGV0aW9uLiBUaGlzIGlzIGluIGNv
bnRyYXN0DQo+IHRvIGRvaW5nIGEgc2VwYXJhdGUgcG9sbCwgZ2V0dGluZyB0aGUgbm90aWZpY2F0
aW9uLCB0aGVuIGRvaW5nIGFub3RoZXINCj4gc3FlIGFuZCBpb191cmluZ19lbnRlciB0byBwZXJm
b3JtIHRoZSByZWN2LiBGb3IgdGhpcyBjYXNlLCB3ZSBlbmQgdXANCj4gZG9pbmcgZXZlcnl0aGlu
ZyBpbmxpbmUsIGp1c3Qgd2l0aCB0aGUgY29zdCBvZiBhbiBhZGRpdGlvbmFsIHN5c3RlbSBjYWxs
DQo+IHRvIHN1Ym1pdCB0aGUgbmV3IHJlY3YuDQo+IA0KPiBJdCdkIGJlIHJlYWxseSBjb29sIGlm
IHdlIGNvdWxkIGltcHJvdmUgb24gdGhpcyBzaXR1YXRpb24sIGFzIHJlY3YgKG9yDQo+IHJlYWQp
IHByZWNlZGVkIGJ5IGEgcG9sbCBpcyBpbmRlZWQgYSBjb21tb24gdXNlIGNhc2UuIE9yIGRpdHRv
IGZvciB0aGUNCj4gd3JpdGUgc2lkZS4NCj4gDQo+PiBCVFcsIHdoYXQncyBiZW5lZml0IG9mIGRv
aW5nIHBvbGwoZmQpLT5yZWFkKGZkKSwgYnV0IG5vdCBkaXJlY3RseSByZWFkKCk/DQo+IA0KPiBJ
ZiB0aGVyZSdzIG5vIGRhdGEgdG8gYmVnaW4gd2l0aCwgdGhlbiB0aGUgcmVhZCB3aWxsIGdvIGFz
eW5jLiBIZW5jZQ0KPiBpdCdsbCBiZSBhIHN3aXRjaCB0byBhIHdvcmtlciB0aHJlYWQuIFRoZSBh
Ym92ZSBzaG91bGQgYXZvaWQgaXQsIGJ1dA0KPiBpdCBkb2Vzbid0Lg0KDQpZZXMuIEkgYWN0dWFs
bHkgdGVzdGVkIGBkaXJlY3RseSByZWFkKClgIGZpcnN0LCBhbmQgZm91bmQgaXQgd2FzIGFib3V0
IDMwJQ0Kc2xvd2VyIHRoZW4gcG9sbChmZCktPnJlYWQoZmQpLg0KDQpodHRwczovL2dpdGh1Yi5j
b20vYXhib2UvbGlidXJpbmcvaXNzdWVzLzY5DQoNClNvIGl0IHR1cm5zIG91dCB0aGF0IGFzeW5j
IHB1bnRpbmcgaGFzIGhpZ2ggb3ZlcmhlYWQuIEEgKHNpbGx5KSBxdWVzdGlvbjoNCmNvdWxkIHdl
IGltcGxlbWVudCByZWFkL3dyaXRlIG9wZXJhdGlvbnMgdGhhdCB3b3VsZCBibG9jayBhcyBwb2xs
LT5yZWFkL3dyaXRlPw0KDQoNCj4gDQo+IEZvciBjYXJ0ZXIncyBzYWtlLCBpdCdzIHdvcnRoIG5v
dGhpbmcgdGhhdCB0aGUgcG9sbCBjb21tYW5kIGlzIHNwZWNpYWwNCj4gYW5kIG5vcm1hbCByZXF1
ZXN0cyB3b3VsZCBiZSBtb3JlIGVmZmljaWVudCB3aXRoIGxpbmtzLiBXZSBqdXN0IG5lZWQNCj4g
dG8gd29yayBvbiBtYWtpbmcgdGhlIHBvbGwgbGlua2VkIHdpdGggcmVhZC93cml0ZSBwZXJmb3Jt
IG11Y2ggYmV0dGVyLg0KDQpUaGFua3MNCg0KPiANCj4gLS0gDQo+IEplbnMgQXhib2UNCg0K
