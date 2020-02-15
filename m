Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285E015FD21
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 07:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgBOGcw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 01:32:52 -0500
Received: from mail-shaon0142.outbound.protection.partner.outlook.cn ([42.159.164.142]:48911
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725799AbgBOGcw (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 15 Feb 2020 01:32:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5ofqSw+fWJqzugNENcPQFY0no2EpHJCttRCGmThVcZ2x173LmnF4XLJD/lDm8KQOigvNyhKh1csawyL+EJFAP1H6dGyjT91SheQ55ufkDKm8PnYnbUdo0NMeSkqZFFzjfXJ782jU9RCXdPm4RWzdL75sGqNFdo2ISMO0aHuZwqRj0Aj3gu9gmNcCjmaInpuYFT4Cl3+aCYgKdHq0BlGNeYO+wce4S4fyvAIca++Ip8mWU2kqUgsA69nBFkosla9l99ETaTvYKuWvuXlkm81B6FPA+EG9YVbgKDKgY63BaJQGjd9Hrix2cagPOIAjxDmLvXsQYgUxIwbnjj2/boH7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22XBrB/+4x9L1s5JItZV5obUk5cCRKEl6SAWaCejETY=;
 b=jHZB7BfIf5kFqKdrUy8S5D882NeohwFE4YNxnBcw5tOoIEEq1oqyjgHwiiYICmWUA4AZadbgnfEAYlhzC4NOvgmWmgfhpe1VxYm8UsZdCUN6ezNtPZGLeRtkY1lU/8agZ0r/sN001sODjY6sCn0cFMf4fnsh/qCMEj18XjmeMI8Di1cQj86E8abHXAVTqeXXYG71kYEUbbsOCvUUhLJmLZAV4xs+n7zInQRNf/2xfnbVdSZ3uPjyBVqoQSoTV8Fgp1ivni822H50tBUOjLUOKGu0w4TXQNaO834RiBm5shB70pPM8xD1KhaTbkuQSSbn/4Tb7sLOaoQSO0jikhFHPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22XBrB/+4x9L1s5JItZV5obUk5cCRKEl6SAWaCejETY=;
 b=F0iV91DPDJvSYP6si+0z5qWfTwj/zTPhVU92mtjYkGAwPeMzOqnQQcPLcYfflSHqMzDj6MoU2WEe6rPTbsvGzVvWP9RRQ/XCEcCuLWZtsgM+MQhl+atmF1KDP5YJRtSPICg/aqULvCt+vFlj0YqGhKmOvNOhMfnsd/92D2gdOeM=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0635.CHNPR01.prod.partner.outlook.cn (10.43.108.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23; Sat, 15 Feb
 2020 06:32:44 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Sat, 15 Feb 2020 06:32:44 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Topic: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Index: AQHV4cHhpj4vlwaolEOmZJk1sNu8q6gXy2CAgAB7iICAAPRcgIAAAeCAgAAKIQCAAKCdAIAAFkwAgAAmnQCAAK+SAIAABF8AgAAIjwCAABpOgIAAMAEAgAA7HwCAAA8cgIAABGOAgAAAhwCAAEx7AIAACLaA
Date:   Sat, 15 Feb 2020 06:32:44 +0000
Message-ID: <2DA8FE8A-220F-4741-829E-24D0F9EF906B@eoitek.com>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
In-Reply-To: <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [183.200.9.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca41aa9c-30bc-4ba8-8de8-08d7b1e0dd73
x-ms-traffictypediagnostic: SH0PR01MB0635:
x-microsoft-antispam-prvs: <SH0PR01MB0635233F38EAC41D6E4C82A494140@SH0PR01MB0635.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(328002)(189003)(329002)(199004)(66476007)(66556008)(5660300002)(53546011)(508600001)(8936002)(71200400001)(63696004)(2616005)(36756003)(76116006)(26005)(186003)(2906002)(64756008)(66446008)(66946007)(95416001)(54906003)(8676002)(81166006)(81156014)(6916009)(33656002)(86362001)(4326008)(85182001);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0635;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B+H30qA5JjRXjOltj/E3iTS+ciP96z8/6iLebx/k8Hop8evIcjk/GJVZvokKp68GAcbC+oz5n0kyJMTpaUTHi+stBvtcLWp3kQP/t9T1ooLqGO1leLua+juFivXTXKsi8JKFkozSm78SYvbAGTQKEW5SI7IBEIdW5wq/SVdmIlq7D/4KisiWdThqy1VS9EII/P2FB3HolzSo8nokPVFvnNWipQMxZoKRus4lCnAhOKeEgb+cKIaCN2E7+GnzTNDZ97JIB4MA4vQaMOWq3+hetVvkyh2LEnqFanuJ+MesDw1WzjfzOjLiSTVtzkJAchVCn+7gdxRsjMAkZyQ1MZmur8BdFw5YCGM2CTdZRjf9q8k+p6v5BV7HaqWBA40gWNAfJYaa6LNQ1GFuZVabmliO95vShtjsTUAhR17wYKnFNjBZGiuO+7ALh3DrvhEK5CU7
x-ms-exchange-antispam-messagedata: P1zqZXq86tOQ7nT57KjlFBSqvwgGr4xyiFLN45P6P+FzSNKcKCgsRBcKy99xslJ+ui2Bzh9rrUAfI5+O6vNfJPqt918ciVyKLNoIVjqih3aMs1+aTbw0ZDgTIc3BWRHn6FGcbO+3ztmjKdrMc895UA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8711743C7BADAC4896640E4665AFD80C@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca41aa9c-30bc-4ba8-8de8-08d7b1e0dd73
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 06:32:44.1203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WG31fIfZPJzwvbjVZsdBOAMeVw3SYYH67jLKZpJZKE6vHqg9UR/nCEReZIqj6JVMZCoGjUWFhulTPDz591Tjyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0635
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

UmVhbGx5IGFwcHJlY2lhdGUgaXQhIExvb2tpbmcgZm9yd2FyZCB0byBnZXR0aW5nIGl0IG1lcmdl
ZCBpbnRvIG1haW5saW5lIQ0KDQpCeSB0aGUgd2F5LCB3aGF0IHRpbWUgaXMgaXQgbm93IGluIHlv
dXIgY2l0eT8gOy0pDQoNCkNhcnRlcg0KDQo+IDIwMjDlubQy5pyIMTXml6Ug5LiL5Y2IMjowMe+8
jEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4g5YaZ6YGT77yaDQo+IA0KPiBPbiAyLzE0LzIw
IDY6MjcgUE0sIEplbnMgQXhib2Ugd3JvdGU6DQo+PiBPbiAyLzE0LzIwIDY6MjUgUE0sIENhcnRl
ciBMaSDmnY7pgJrmtLIgd3JvdGU6DQo+Pj4gVGhlcmUgYXJlIGF0IGxlYXN0IDIgYmVuZWZpdHMg
b3ZlciBQT0xMLT5SRUFEDQo+Pj4gDQo+Pj4gMS4gUmVkdWNlIGEgbGl0dGxlIGNvbXBsZXhpdHkg
b2YgdXNlciBjb2RlLCBhbmQgc2F2ZSBsb3RzIG9mIHNxZXMuDQo+Pj4gMi4gQmV0dGVyIHBlcmZv
cm1hbmNlLiBVc2VycyBjYW7igJl0IGlmIGFuIG9wZXJhdGlvbiB3aWxsIGJsb2NrIHdpdGhvdXQN
Cj4+PiBpc3N1aW5nIGFuIGV4dHJhIE9fTk9OQkxPQ0sgc3lzY2FsbCwgd2hpY2ggZW5kcyB1cCB3
aXRoIGFsd2F5cyB1c2luZw0KPj4+IFBPTEwtPlJFQUQgbGluay4gSWYgaXTigJlzIGhhbmRsZWQg
Ynkga2VybmVsLCB3ZSBtYXkgb25seSBwb2xsIHdoZW4NCj4+PiB3ZSBrbm93IGl04oCZcyBuZWVk
ZWQuDQo+PiANCj4+IEV4YWN0bHksIGl0J2xsIGVuYWJsZSB0aGUgYXBwIHRvIGRvIHJlYWQvcmVj
diBvciB3cml0ZS9zZW5kIHdpdGhvdXQNCj4+IGhhdmluZyB0byB3b3JyeSBhYm91dCBhbnl0aGlu
ZywgYW5kIGl0J2xsIGJlIGFzIGVmZmljaWVudCBhcyBoYXZpbmcNCj4+IGl0IGxpbmtlZCB0byBh
IHBvbGwgY29tbWFuZC4NCj4gDQo+IENvdWxkbid0IGhlbHAgbXlzZWxmLi4uIFRoZSBiZWxvdyBp
cyB0aGUgZ2VuZXJhbCBkaXJlY3Rpb24sIGJ1dCBub3QNCj4gZG9uZSBieSBhbnkgc3RyZXRjaCBv
ZiB0aGUgaW1hZ2luYXRpb24uIFRoZXJlIGFyZSBhIGZldyBoYWNrcyBpbiB0aGVyZS4NCj4gQnV0
LCBpbiBzaG9ydCwgaXQgZG9lcyBhbGxvdyBlZyBzZW5kL3JlY3YgdG8gYmVoYXZlIGluIGFuIGFz
eW5jIG1hbm5lcg0KPiB3aXRob3V0IG5lZWRpbmcgdGhlIHRocmVhZCBvZmZsb2FkLiBUZXN0ZWQg
aXQgd2l0aCB0aGUgdGVzdC9zZW5kX3JlY3YNCj4gYW5kIHRlc3Qvc2VuZF9yZWN2bXNnIHRlc3Qg
YXBwcywgYW5kIGl0IHdvcmtzIHRoZXJlLiBUaGVyZSBzZWVtcyB0byBiZQ0KPiBzb21lIHdlaXJk
IGlzc3VlIHdpdGggZWcgdGVzdC9zb2NrZXQtcncsIG5vdCBzdXJlIHdoYXQgdGhhdCBpcyB5ZXQu
DQo+IA0KPiBKdXN0IHdhbnRlZCB0byB0aHJvdyBpdCBvdXQgdGhlcmUuIEl0J3MgZXNzZW50aWFs
bHkgdGhlIHNhbWUgYXMgdGhlDQo+IGxpbmtlZCBwb2xsLCBleGNlcHQgaXQncyBqdXN0IGRvbmUg
aW50ZXJuYWxseS4NCj4gDQo=
