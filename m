Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1433E3F1D
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 06:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhHIEuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 00:50:23 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:16868
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230491AbhHIEuW (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 9 Aug 2021 00:50:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxz8lSF9V7m2Gi33rZRCRHPt8oXXbp51v0oTUrl9vlWK4esG1RYMYQrskaWEHyyRHxHBACwAEL7s0x2IKCgptp5nDfNxpVrZCblbIHao7KBCTGckjGhM2xQ1H8wxckWK9DHUzI01yExPvmtenLe3qrbjMCzFA2a0FZi5UC0itKdP4uCDbXqNjcKmx+F+GsSZSkgNGA6ysq5PqTVj3y/r/LyGEzg4+p9IwIbJUUby5Qx7tvMa2HOe0zGhnQwsZ9CQbikDq89QqnRJqx1pb4bfWrbR4De8GW2GH5dtId7j/sPG1Js49vXBwIL7k/KfYg/ef1WTboMy5KjJPMpxGB4Lgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hl5qg/5SQy/NePnYMeBB9h2+L47I0rnkKyCcn+RVqX4=;
 b=UuE7338GHZ+CuDTkFNfSQ2mUPj/k6/ZvScoKChvFMQLs4pHaIingq7B7P0XZSyugncli7ozZMdHd94+Imt8IVTnYeu790kOCll43pprlOHjTxtj8NBqr2WZrOkbqMICjizRclTmN4fHszAjYqfanYFhs5lTc3EkW2QCbxldcWUqE9O6CKQK+DYPdfiPZWR+VERXFvXSPOY/zZU3AeQ2ch6+Sy7wjFBfoLRK07rFuRpiXi9ip/0mejdSiWLpl/6wTC6uJ91srQnLmDhTUoxu/Wtj5dwQ4zlXSq1vEKzVOUFev1a8yaQtqnyshtyjuJ5bSwE5aLhIwucczwBLsSowdlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hl5qg/5SQy/NePnYMeBB9h2+L47I0rnkKyCcn+RVqX4=;
 b=eJt3i7BS0P4NXWx3N3M/F0dkDg7N1DoaVSC7HCrRE0UtE7I5GrNYhAW23oJL9pqWIhDCLhJCkxTf1QAAEAKmHxBvLUws4/rroxyg83OgwIdETnfKosuKVljTRzzKE5cwxjsPodfZR3Yiw/AFXQmR0PqYo84+u6B/s9vvIMsfQtw=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by SJ0PR05MB8710.namprd05.prod.outlook.com (2603:10b6:a03:38a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.7; Mon, 9 Aug
 2021 04:50:00 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::c52:f841:f870:86b5]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::c52:f841:f870:86b5%9]) with mapi id 15.20.4415.012; Mon, 9 Aug 2021
 04:50:00 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Hao Xu <haoxu@linux.alibaba.com>
CC:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
Thread-Topic: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
Thread-Index: AQHXjFSzesNuD57xTUuTkIhmri8yNqtp3csAgACxwQCAAAvOgA==
Date:   Mon, 9 Aug 2021 04:50:00 +0000
Message-ID: <CAC2285F-0841-47F5-8567-24C1377DDFB6@vmware.com>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <488f005c-fd92-9881-2700-b2eb1adbb78e@gmail.com>
 <40885F33-F35D-49E9-A79F-DB3C35278F73@vmware.com>
 <8825c48c-3574-c76f-4ff2-e68aaf657cda@linux.alibaba.com>
In-Reply-To: <8825c48c-3574-c76f-4ff2-e68aaf657cda@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4acbfd6e-929a-46cb-1210-08d95af1250e
x-ms-traffictypediagnostic: SJ0PR05MB8710:
x-microsoft-antispam-prvs: <SJ0PR05MB8710B6F3426BC5AD1480FDF8D0F69@SJ0PR05MB8710.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4xlwAMXZjehsS2mtYn6KPVXs5nDNBiIiROZkOvkcwYJjGXN3ZJDAd1r5K+OttfGCJqk3PVK4FLKsWxfh88hdR/5g6VDRe/dUUDJZKSkbhFC7zpeTryGxfWxpmtuCsCBa2VeRajdiKEWhTGy0N1EbWxfB+T+v449NetwuM3iAVDBQZKW1meE2mo90mRWVqCPHhh4ETXXVisVhXwaPHjwgB6iTFjsHBARM4+8IFc0U36HpXZZaYUG5Wm2vAeTTmgM3jzNpHaf7LiujuN49Td7Mx3L2rLTS8FF4CfbnnW3o39sYxoZZU6l3J13+qtrOBAcXlGE9lMVK4fbrJufu8ml9hxA/OYCbIZP0RL/ezDWyUs4IRK9RDHgB6llMd6HEpJcUMVTKiL1zirARl6u6H8I4+ZExCBYilxuoUSrYshr2KkylqovJhJ2fMnPKAZfPGcCewV05hX+atZy7p44D1LDU4kY7qoRZjpzRUMV78ZL9Y7iBpS12cRD2wF9/4qeU04Vlh/rk+OBwpGW0PBzguHWGYN00A/JO2CGGKy7SNBGUxTmCxf0yR0dEOf7l5uxYwMReYfXcYDDF/lbUYuRv7TyE4UwSmReQSIvDTkRP22UBM1isNviKDTpx0eWfxeuki2C47R/ccfrKFbzcqRiHfG5741Z2VzGhuS+nlUbYuUWpVfhFjT/kw8dhtcE/Ug9voZz0mujDfDzFAEDifpjnfwJDNjdtH9WpMFdPs237Sh/lt5I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(186003)(26005)(6486002)(8676002)(2616005)(54906003)(316002)(86362001)(6916009)(38070700005)(5660300002)(76116006)(66476007)(2906002)(66946007)(4326008)(66556008)(508600001)(66446008)(64756008)(122000001)(33656002)(6506007)(71200400001)(6512007)(8936002)(38100700002)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDdNQVY4Y04vUXhYTlFFMU1iVTFxbTFzMzVTS01MREhXblRuRk9CRE8vbUFW?=
 =?utf-8?B?eCtqcWtDNTNSMjZ4MlV6UTNURGxhRlplVFZzZFd6bE1qNkIxT1gzQ3E3MmQ0?=
 =?utf-8?B?dkpQWXlMeURqdUNtSHNzdzQzaDBjekd2QW5TajZIWGptWU5EU1o1aXVIbGNn?=
 =?utf-8?B?WFZ1YncwLzBCVFlHQnQrWGhUbFQ3SzFVTW9VdEp6MkZYTUhTOURCV2VOZ28w?=
 =?utf-8?B?dkNXYmZpaVZjR0tCK0dpTDFiS2p5c21FNlV5NzJUbkRMc1VIeXNpMG52ekps?=
 =?utf-8?B?bmxHL1o2S2RER3FqYndUc0pNVzBvaHdpYWFTNjAxdmJNUzdhSlF3OWxXUHdG?=
 =?utf-8?B?UDlGUlp3YStSLys3dnFhQ1E0amZLdGd0cHhRNEtHQXZ5MitrUHQ0SS9jZEM1?=
 =?utf-8?B?Ull0QmJKaE1CT3c2dHlrZk5ZakRON3JGb1k5TGZIUkdreWVXZU1XRnBjcGYw?=
 =?utf-8?B?YVdjSk45Tytab09UYmtEWU8ya1AvZlE2dWNVZ00zNGtERFVibS9ReVY3b1pF?=
 =?utf-8?B?YTdaZVhSMGxQVVd3bGRkWXNhU2kyd00xM2RjaUd3N2QwVXEyQWViajR1K2tk?=
 =?utf-8?B?OENaM0VnWWpjY1dNSllLZ1o1K1lFdmwzVExqckhIMDRTdjl6dGFpTVFIRDM5?=
 =?utf-8?B?R2dvNExBMmZOUnBzUUxOeDI4eERqUDhlaVdEWmNIU2dPbkZUa201cERCTUtB?=
 =?utf-8?B?T0psdzNjSWZDQjlpVUNKbllzUnFHT3BGaDc3RG1UTWYycnpLTGthaW1QckRJ?=
 =?utf-8?B?amtvcC8yZFhwYnprNU1iYWRJYU1FNDIvdWdHTlNPNW8zTGlWQ2dpVUxBdEJP?=
 =?utf-8?B?STc1aGpSRVRyVXc3MXJLTFRFTms5ZlpmbjhJSk5MVGZMenpjRlhQdklWUzhI?=
 =?utf-8?B?VytFWTlKL1licjB3bFJ3cGlkMkxyT2VyTTF2ZnlyaVVFYUQ0cWZwYUJrQ0Ex?=
 =?utf-8?B?ajVRVGpTZ3E1a0t5VWRrQWpSK09YcUxKeHdBZk14TUttSU5Ic1VQYjlpTjFB?=
 =?utf-8?B?MU5ONERpQWNKUGhWM2lBSXRZdnBDL3c4aUw1Z0FnbXpISVlra2EwYTlnenB4?=
 =?utf-8?B?dUZuQW90bnl0cnZkdXc0MTRLWGJWdXl6dU1HU0F1OVFzdXhUWDBjajZoY0FF?=
 =?utf-8?B?UzltWXpJeS93L0hTK3Qvb0p1K3R6U1FPU3ZaY1ltUEkxUmlFOFdTTUpFSXFq?=
 =?utf-8?B?elVFaXJnQnlEeTFoM0xZU2UzWkNlOG9DOGxBTHBVSlREOURVakREZTFqMjVJ?=
 =?utf-8?B?TXdLVXpaaDJ5d0gxR2VzamFvdGlFVUREUGt3blh5cDJmZU82eVhjRmxuTjZi?=
 =?utf-8?B?dE81TExoWC9xVFc0VXhiRVUxSDBHbEI1UnM5ZWRHRzVTbFBuWXlIOUpZWFFu?=
 =?utf-8?B?VDlvYmdkTXFNeGNwcW5Zd09Xd0dReXB2N0NuKzdIYUM2V1VVYXgrTTRPQmRK?=
 =?utf-8?B?bko5T1BSWEpMRm9hb05tdURaMzFsOFZRcCtJMW44REs1N2hDZ0ZRdnIrd0lR?=
 =?utf-8?B?dzdxK2prRDVQaHV1SGNWTXZvL3BLYUovcjlwZ3Zjc3F0MmZBayt3QnlMNzhk?=
 =?utf-8?B?Z0xndDBHc29YNWtXQUJaR3lIQm11dy9CNXJoK2ZrV0ljMkV1dTFQVDVNQlNH?=
 =?utf-8?B?QTJRZ0VyQytGbUl2Zm9WRVdCKytZRjUwUENub0MrTzhhd1lqR2hkNkgreUFH?=
 =?utf-8?B?T0dNYXpsdnZvUjZzY3lJTmZNSzdkU2M0bGRjZjhLRnNxdnF3QkVCRHRzdi90?=
 =?utf-8?Q?qGHPMiPoapIzQ6e9ZC0agAB/W8pwMbaFWBTugv/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <01C898BC7D69094B9042FBC083242CA6@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4acbfd6e-929a-46cb-1210-08d95af1250e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 04:50:00.4017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mwKJIUoxwUVms+rhXcRCNAfktcuMky1+xnBRL1uoNIIGvakPnHcQft+CEMiJJrgUj4IDsg6iLqEKUduaUqBlkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB8710
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

DQoNCj4gT24gQXVnIDgsIDIwMjEsIGF0IDk6MDcgUE0sIEhhbyBYdSA8aGFveHVAbGludXguYWxp
YmFiYS5jb20+IHdyb3RlOg0KPiANCj4g5ZyoIDIwMjEvOC85IOS4iuWNiDE6MzEsIE5hZGF2IEFt
aXQg5YaZ6YGTOg0KPj4+IE9uIEF1ZyA4LCAyMDIxLCBhdCA1OjU1IEFNLCBQYXZlbCBCZWd1bmtv
diA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gOC84LzIxIDE6
MTMgQU0sIE5hZGF2IEFtaXQgd3JvdGU6DQo+Pj4+IEZyb206IE5hZGF2IEFtaXQgPG5hbWl0QHZt
d2FyZS5jb20+DQo+Pj4+IA0KPj4+PiBXaGVuIHVzaW5nIFNRUE9MTCwgdGhlIHN1Ym1pc3Npb24g
cXVldWUgcG9sbGluZyB0aHJlYWQgY2FsbHMNCj4+Pj4gdGFza193b3JrX3J1bigpIHRvIHJ1biBx
dWV1ZWQgd29yay4gSG93ZXZlciwgd2hlbiB3b3JrIGlzIGFkZGVkIHdpdGgNCj4+Pj4gVFdBX1NJ
R05BTCAtIGFzIGRvbmUgYnkgaW9fdXJpbmcgaXRzZWxmIC0gdGhlIFRJRl9OT1RJRllfU0lHTkFM
IHJlbWFpbnMNCj4+PiANCj4+PiBzdGF0aWMgaW50IGlvX3JlcV90YXNrX3dvcmtfYWRkKHN0cnVj
dCBpb19raW9jYiAqcmVxKQ0KPj4+IHsNCj4+PiAJLi4uDQo+Pj4gCW5vdGlmeSA9IChyZXEtPmN0
eC0+ZmxhZ3MgJiBJT1JJTkdfU0VUVVBfU1FQT0xMKSA/IFRXQV9OT05FIDogVFdBX1NJR05BTDsN
Cj4+PiAJaWYgKCF0YXNrX3dvcmtfYWRkKHRzaywgJnRjdHgtPnRhc2tfd29yaywgbm90aWZ5KSkN
Cj4+PiAJLi4uDQo+Pj4gfQ0KPj4+IA0KPj4+IGlvX3VyaW5nIGRvZXNuJ3Qgc2V0IFRJRl9OT1RJ
RllfU0lHTkFMIGZvciBTUVBPTEwuIEJ1dCBpZiB5b3Ugc2VlIGl0LCBJJ20NCj4+PiByYXRoZXIg
Y3VyaW91cyB3aG8gZG9lcy4NCj4+IEkgd2FzIHNheWluZyBpby11cmluZywgYnV0IEkgbWVhbnQg
aW8tdXJpbmcgaW4gdGhlIHdpZGVyIHNlbnNlOg0KPj4gaW9fcXVldWVfd29ya2VyX2NyZWF0ZSgp
Lg0KPj4gSGVyZSBpcyBhIGNhbGwgdHJhY2UgZm9yIHdoZW4gVFdBX1NJR05BTCBpcyB1c2VkLiBp
b19xdWV1ZV93b3JrZXJfY3JlYXRlKCkNCj4+IHVzZXMgVFdBX1NJR05BTC4gSXQgaXMgY2FsbGVk
IGJ5IGlvX3dxZV9kZWNfcnVubmluZygpLCBhbmQgbm90IHNob3duIGR1ZQ0KPj4gdG8gaW5saW5p
bmc6DQo+IEhpIE5hZGF2LCBQYXZlbCwNCj4gSG93IGFib3V0IHRyeWluZyB0byBtYWtlIHRoaXMg
a2luZCBvZiBjYWxsIHRvIHVzZSBUV0FfTk9ORSBmb3Igc3F0aHJlYWQsDQo+IHRob3VnaCBJIGtu
b3cgZm9yIHRoaXMgY2FzZSBjdXJyZW50bHkgdGhlcmUgaXMgbm8gaW5mbyB0byBnZXQgdG8ga25v
dyBpZg0KPiB0YXNrIGlzIHNxdGhyZWFkLiBJIHRoaW5rIHdlIHNob3VsZG4ndCBraWNrIHNxdGhy
ZWFkLg0KDQpJdCBpcyBwb3NzaWJsZSwgYnV0IGl0IHdvdWxkIGJyZWFrIHRoZSBhYnN0cmFjdGlv
bnMgYW5kIHByb3BhZ2F0aW5nDQppdCB3b3VsZCBiZSBkaXNndXN0aW5nLiBMZXQgbWUgZ2l2ZSBp
dCBzb21lIHRob3VnaHQuDQoNClJlZ2FyZGxlc3MsIEkgdGhpbmsgdGhhdCB0aGlzIHBhdGNoIHNo
b3VsZCBnbyB0byA1LjE0IGFuZCBzdGFibGUsDQphbmQgYW55IHNvbHV0aW9uIHRvIGF2b2lkIGtp
Y2tpbmcgdGhlIFNRIHNob3VsZCBjb21lIG9uIHRvcCAodG8gYmUNCnNhZmUpLg==
