Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E37F15FC01
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 02:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgBOB0E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 20:26:04 -0500
Received: from mail-shaon0150.outbound.protection.partner.outlook.cn ([42.159.164.150]:33196
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727658AbgBOB0E (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 Feb 2020 20:26:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ai65xxM/GIi+BidbmVh7hJBma2no1atxKGGfD612cYIpuYT47U1oqu9vQlzIivTAoGrmzunRxQ1dIqyUJ9+5hmMhsnqrCgX31VDyoAuU5z/NgOGws/m+enPjuMVTGlD7+RXVEkSzAB6fa9xqhg1pgUNTu0tTr59QY9lvwjVdEMBENqkIMYVxK5jU7gZAIqboPoK6HZRYpKRHvlpBeH7XoRNC74DHeR5sZZ/eFigaKr/Tr5GBea0rErAgAyQyttiFFOn10LmxL10lUZqhq4bbEk9Bk66ha7hFHIwIFUq35SHxEv2F4tQ/VS9gNR0JNXQcj+5F1f4sOb7jjGJenA1cyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpDGIsn1c8uhAD9Pwy1GqibDt12YpuT9kwRUrQDFlrc=;
 b=F5xiWVggHnaA65MuTG2EfKPeWcv31GNubtl11KMBmf2wWYmTqWFmc5o4r+TE0wux4gDdrXco2n//lR1to0QeOpvaoGT8AvopF378Mwun2UYcpUx9t9aXrVtXpL38BZLfRzHooNxijAcgThHwzFZ/Jpyi6zKneMh0ZD0ZB/GNIWh/Xz99ryLRifAWXHuDLIxQ/BwAsZ+fxjUkcbv2ojOkTAAxieEXEWp4KPnjvvK3EiBA1b0l1GuBl0/GhxA337k2IhPaCRojpQDFmayXJkeytRD73ovV8NycKLQVXJuy4o3cZcQ81fRt0Sj5W2U2/q1T70AdoKCMLf90kNXaFdZ8qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpDGIsn1c8uhAD9Pwy1GqibDt12YpuT9kwRUrQDFlrc=;
 b=KaJXScr6/WBbgJloWsXRNV5VuwFDlBIuvp3rNHU3eYxfOZtylIqfXN/cgrVlYsLqosWn+itD/Slbvpv+vbAdUkJrUpo869xg4k6ZjhIavoTIANKEMNnea5dQE0Ilkf35uAkrqzYt5WbxL7zCmA44p1OrOpyTPwT0EskxK5jtAcs=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0554.CHNPR01.prod.partner.outlook.cn (10.43.108.12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23; Sat, 15 Feb
 2020 01:25:58 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Sat, 15 Feb 2020 01:25:58 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Topic: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Index: AQHV4cHhpj4vlwaolEOmZJk1sNu8q6gXy2CAgAB7iICAAPRcgIAAAeCAgAAKIQCAAKCdAIAAFkwAgAAmnQCAAK+SAIAABF8AgAAIjwCAABpOgIAAMAEAgAA7HwCAAA8cgIAABGOA
Date:   Sat, 15 Feb 2020 01:25:58 +0000
Message-ID: <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
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
In-Reply-To: <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [183.200.9.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b59fd2e5-1fdd-4d49-95e6-08d7b1b602b5
x-ms-traffictypediagnostic: SH0PR01MB0554:
x-microsoft-antispam-prvs: <SH0PR01MB05540C09BD7962140283203A94140@SH0PR01MB0554.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(329002)(328002)(199004)(189003)(76116006)(54906003)(66476007)(66556008)(4326008)(8676002)(2616005)(81166006)(66446008)(85182001)(36756003)(64756008)(6916009)(53546011)(86362001)(95416001)(2906002)(26005)(186003)(81156014)(33656002)(8936002)(71200400001)(5660300002)(508600001)(63696004)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0554;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LMRek64Qm4lHroLR5VBZMYZ6XuNw88M/o663GNki43DNfFaeRSx2okz0kzGEVrsfU8a5YJYBJYfTsja68fqNb72uhTt2a5IxXqx+VndtmvC9h0w2RlpIhUO35L6fjptw11VCHNd1pC04ZiGYPiY8sHb3FS6ePLsbwkpI9VceaUuLkOhM/Wynhjz3RI6i/sCmsM9k1C8n6M+9xm7JsnrX1sVXl25/EBWtBR0QrFW19bLvB+0m8VY+5pmyEvStGHbjJ/WYyqH4PRJWh+JhFjzP1BiYMN+wr9f2e4IPVNoVciQwXWdt6WpWMcRXGAl8VKq1Q1kjJp7pXoQk+Fpdy6HRPiqkx6y5GAPDSSVjkd+lq9+rrqO9RBpjAUnKsicSEqKDqyvyYvvvbQRWPQ7gBrscacb0rNVbDDafzztaEmCObk3pc2e4DGJJDsP70y21QkWc
x-ms-exchange-antispam-messagedata: I5ozTewiTYUWcbnPes/ENFgsZooz2ZoMmq4X+KxtRqS1muR1xuRHbjk3rgLMaNS5bKzcvi4Bqi/086dUZ5+5OL7qW4sXyZrnydZcqffROmzK0AdwtRsL3GoJafGw//y1dJOwlC/QCEV7okqCd7hJiQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <089488F516E9FD4AAE58EE582318690F@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b59fd2e5-1fdd-4d49-95e6-08d7b1b602b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 01:25:58.2564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8K7N8tFZdXGcLJK/2/iMAdDmEaz3Xm48w71TSCcspY/CyxHUXO7HxWo6h2E22odpbRHOCwrhLZBc3pf4+58Ilg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0554
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

VGhlcmUgYXJlIGF0IGxlYXN0IDIgYmVuZWZpdHMgb3ZlciBQT0xMLT5SRUFEDQoNCjEuIFJlZHVj
ZSBhIGxpdHRsZSBjb21wbGV4aXR5IG9mIHVzZXIgY29kZSwgYW5kIHNhdmUgbG90cyBvZiBzcWVz
Lg0KMi4gQmV0dGVyIHBlcmZvcm1hbmNlLiBVc2VycyBjYW7igJl0IGlmIGFuIG9wZXJhdGlvbiB3
aWxsIGJsb2NrIHdpdGhvdXQNCmlzc3VpbmcgYW4gZXh0cmEgT19OT05CTE9DSyBzeXNjYWxsLCB3
aGljaCBlbmRzIHVwIHdpdGggYWx3YXlzIHVzaW5nDQpQT0xMLT5SRUFEIGxpbmsuIElmIGl04oCZ
cyBoYW5kbGVkIGJ5IGtlcm5lbCwgd2UgbWF5IG9ubHkgcG9sbCB3aGVuDQp3ZSBrbm93IGl04oCZ
cyBuZWVkZWQuDQoNCg0KPiAyMDIw5bm0MuaciDE15pelIOS4iuWNiDk6MTDvvIxKZW5zIEF4Ym9l
IDxheGJvZUBrZXJuZWwuZGs+IOWGmemBk++8mg0KPiANCj4gT24gMi8xNC8yMCA1OjE2IFBNLCBD
YXJ0ZXIgTGkg5p2O6YCa5rSyIHdyb3RlOg0KPj4gSGVsbG8gSmVucywNCj4+IA0KPj4gDQo+Pj4g
SXQncyBub3cgdXAgdG8gMy41eCB0aGUgb3JpZ2luYWwgcGVyZm9ybWFuY2UgZm9yIHRoZSBzaW5n
bGUgY2xpZW50IGNhc2UuDQo+Pj4gSGVyZSdzIHRoZSB1cGRhdGVkIHBhdGNoLCBmb2xkZWQgd2l0
aCB0aGUgb3JpZ2luYWwgdGhhdCBvbmx5IHdlbnQgaGFsZg0KPj4+IHRoZSB3YXkgdGhlcmUuDQo+
PiANCj4+IA0KPj4gSeKAmW0gbG9va2luZyBmb3J3YXJkIHRvIGl0Lg0KPj4gDQo+PiBBbmQgcXVl
c3Rpb24gYWdhaW46IHNpbmNlIFBPTEwtPlJFQUQvUkVDViBpcyBtdWNoIGZhc3RlciB0aGVuIFJF
QUQvUkVDViBhc3luYywNCj4+IGNvdWxkIHdlIGltcGxlbWVudCBSRUFEL1JFQ1YgdGhhdCB3b3Vs
ZCBibG9jayBhcyBQT0xMLT5SRUFEL1JFQ1Y/IE5vdCBvbmx5IGZvcg0KPj4gbmV0d29ya2luZywg
YnV0IGFsc28gZm9yIGFsbCBwb2xsYWJsZSBmZHMuDQo+IA0KPiBUaGF0J3MgZXhhY3RseSB0aGUg
bmV4dCBzdGVwLiBXaXRoIHRoaXMsIHdlIGhhdmUgYSB2ZXJ5IGVmZmljaWVudCB3YXkgb2YNCj4g
ZG9pbmcgYXN5bmMgSU8gZm9yIGFueXRoaW5nIHRoYXQgY2FuIGJlIGRyaXZlbiBieSBwb2xsLiBU
aGVuIHdlIGNhbiBkbyBpdA0KPiBieSBkZWZhdWx0LCBpbnN0ZWFkIG9mIGRvaW5nIGFuIGFzeW5j
IHB1bnQuIE11Y2ggZmFzdGVyIGFuZCBtdWNoIG1vcmUNCj4gZWZmaWNpZW50Lg0KPiANCj4gSSds
bCB0cnkgYW5kIHdvcmsgb24gdGhhdCBuZXh0IHdlZWssIEkgdGhpbmsgdGhpcyBjb3VsZCBiZSBh
IHJlYWwgZ2FtZQ0KPiBjaGFuZ2VyLg0KPiANCj4gLS0gDQo+IEplbnMgQXhib2UNCg0K
