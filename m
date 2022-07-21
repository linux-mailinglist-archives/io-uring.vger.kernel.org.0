Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B480C57CB9B
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 15:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiGUNOr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 09:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiGUNOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 09:14:43 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE4856B95;
        Thu, 21 Jul 2022 06:14:36 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KNbF6c005894;
        Thu, 21 Jul 2022 06:14:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KkDJxfKapPbnmU4igTw9G4WhiEWTaN+B6Ohxy3EJpS4=;
 b=PzHhvY2R6o3GuE5MfnzyMykOWwfOh4hjoxPQY94Tw2fbgUyNbO2UXSE1s/V4mY+w+sGG
 pMw1Vb8qQavLTGlPC53XrgfkCFKFKZ/te9wm1QefC4Moq/Pf3l0qUd3xglg+xY2ZPear
 mnW4MZwJBWI1KuGduKhjrjtfUciWy9Fl8mk= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hes8vc11g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 06:14:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QExkfRt9JUFv4S6xWWfXLDm0WE0P+xlgZ5FFJzEqZLflE61Qw04NodUY2wjDyE45GsWCg9lt5j6mO/j+QRj/qdLjdNsgplWgrfhvjJS8ak15kES8mVvddfwqtCdYfN6CTbD2utU68RjlrYECvLQ/Mm6xATh7PrJx+sc5VA3/+CD9Z9o/BUfw2KIb3cEs0o8b/A2IPO7D10GBsNLAJvIkz6Qx+Yn5w6229jprVOo6ou1iwsLARAetkMm1iLx21rM4+clKQFmm64Po+NqQp9JTR80PA/5Stu4vHfMUvsU8/atdpeuZITlT1rupELMMjv4fuuYhtuBvnujSGo/T7V67BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkDJxfKapPbnmU4igTw9G4WhiEWTaN+B6Ohxy3EJpS4=;
 b=J7D//30jmwAjSni/zNv5jlEWddecEqPdh1+9oKFdKSwNT3qbeHUY5Pf+HZNkSD5w0poDVC856U2a4i/QY93GiPD0L9kX18OnEEL9jfLf+f0Ey9mVm4AlzfyqoNibKMla6qASpG9rj0tIO0oOgSHLGqiGfDPd6dcVNDZsiE8YEs0RnlLOTwpu1/l6xRgWFGVkE6ul7jmYeWuKAv2yp8N/IE3d2dGIsNoJFAkNOEMUeuJYblUSVp30XRs9o4vjyRg6IXAsXj05+QZJEzgR+IHILrdFiu6lqP17w5UpRG7sSGqhWJX/S+uOaJz0zxW9ot+HaBMxhIWf1VAz7XujqHImpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BY3PR15MB4977.namprd15.prod.outlook.com (2603:10b6:a03:3c4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Thu, 21 Jul
 2022 13:14:33 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 13:14:33 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>
CC:     "gwml@vger.gnuweeb.org" <gwml@vger.gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "fernandafmr12@gnuweeb.org" <fernandafmr12@gnuweeb.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 5.19-rc7 liburing test `poll-mshot-overflow.t` and
 `read-write.t` fail
Thread-Topic: Linux 5.19-rc7 liburing test `poll-mshot-overflow.t` and
 `read-write.t` fail
Thread-Index: AQHYnI+FXh38kPC/ekCuYW7IUr0g+a2IlPEAgAAO6QCAABd0AIAAEXeAgAABvIA=
Date:   Thu, 21 Jul 2022 13:14:32 +0000
Message-ID: <fbf3911151dd3cbf875b8d2a4b9e7ad4b31c80d2.camel@fb.com>
References: <2709ed98-6459-70ea-50d4-f24b7278fb24@gnuweeb.org>
         <3489ef4e810b822d6fdb0948ef7fdaeb5547eeba.camel@fb.com>
         <beae1b3b-eec3-1afb-cdf9-999a1d161db4@gnuweeb.org>
         <e3987a2f55d154a7b217d86d805719043957db60.camel@fb.com>
         <3761ef37-85fc-de81-b211-39eaf3fe2362@gnuweeb.org>
In-Reply-To: <3761ef37-85fc-de81-b211-39eaf3fe2362@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16170b38-08c5-46d1-f077-08da6b1af3c7
x-ms-traffictypediagnostic: BY3PR15MB4977:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RuEgGEPZ8Ddc9vWfB62Qd+NqG1PYYW8BvLsY25Pdogv7X+LtqqsGoLRVVDg7NukjtdQ3B8xiG+Cbhpsi5ozv5MwL8g2O3+sY/Xh+I1/T8hybYnCd2xneWKAazdEFhYyyNzjbmsTJRwfaNzZ5jM5me64KvxvFo5/3OPzRDB+1nh/9ayYwVhKwpZA/PBLgwciJ3UIlUexA+XfKkAuCnl/rVZJ4DNYlCp8Y/CNO6i0jv326p/4V4snwJ2aZrYFCvEBGAeu6AIkhrYXDM+F/mAVI2bt5YI3K0JUzk/kRV8Msm7V4xByf4cQk9R7aotUlcTE2/ajAe0Gi2fAzmCYfrNd5zfUcYYwujevjLPM5jRGXkrw6NSjlsbhgnzEaMM4N3CK76X37qgkgzBr5CYDgmhRLm3A88eysIUvOOJFhRS98MAnVvq6Ev8Xs77ZmhcQi8rCwsgrIruuJGNwvODuDT/CsYehjq1SLwUxeHOio2nPKN1074CXLlwB7roI6JXN6+wcqZ5Ujb5oejQ8b5FCdexZr31WgMa57A27rqlH6F4PkUe2zNYsSQW6CFaeyarCFX8t+F3qUL9S/lGxprWiv5u3fMyHNasWzCj52cPBYQvHbmDE9M7exCeIcZskZHBM7lxMvSS2L3t1b83nvHbEGVoHVc3u+StrvG4CovcHr1rJSqeSHlu3U/HjcGaMbx5ylEmWTqhEpPavF/pcIp8JcO+fEgekx9Lo5K3V7zpJm4SwbBiWegyovDX3J/VZYMMVNoWj96gc9bRzEXwotvKGjo57nxWHL1MJVZAbwrGMvSR4vRskFaqk+/W6HhKxjkPxju/A+O2ddtCbDmSxedxG3or5XWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(6512007)(5660300002)(6506007)(83380400001)(2616005)(71200400001)(53546011)(41300700001)(186003)(478600001)(6486002)(38070700005)(76116006)(54906003)(66446008)(8676002)(8936002)(122000001)(6916009)(66476007)(64756008)(66946007)(66556008)(91956017)(4326008)(38100700002)(316002)(2906002)(36756003)(86362001)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmpKdEltSFFYeThyYzAralc0aW1CN3VXSkJlVXNKSkpzaitlM3A3Z3BQNzBw?=
 =?utf-8?B?MW9wV3BHdGR4VDdTOUE5WlVKT0dVeUl6ZWNCSnp1V1pwVjR0bVkydjNUOHlE?=
 =?utf-8?B?K3FqcldwbVFLRWJCR2UyTCtYM2ZPMW52bWU1S0dpTUNHMTNzWi9uTVR4d0R6?=
 =?utf-8?B?TkhmdnlGTnRDM0xuTXp1bnFkbTRnRUJkRk1lMjlDalQ0Z29ONmtxU2lvSzBt?=
 =?utf-8?B?Wnp6UUlMaDBlbWtEd01EYUYzVjdyRUVEYzhuUi9KbjFJVkJOeXp6SmJvemZa?=
 =?utf-8?B?ekRwZ3pjS1pxOW11bnplMXU5RTFXL1RwRUhZdmV0ZlZTYTAvcmwrYjlOOVZJ?=
 =?utf-8?B?WnoxSWRxcjBiRTh4MXpSak53WWpqMzYzWVBkbmdQNHRxTXhIazBhWE9rSnp6?=
 =?utf-8?B?OXlHYWJ1bnUxekhVQzJPbEQ4d1FTWitjd0taZjROL3ZoUGFCT05Da0VFcGcv?=
 =?utf-8?B?Wm44ZW5wYWo5Wmd1TkVNVWJ0Zmc3bFlVTjFka01PNlZDcDM0K253cWpSVE9a?=
 =?utf-8?B?STlVZTZsN0VZejJ2SFlQdVBvcjlLZE1PR1NwWXVTK1IyWjU4aXU0OU1nNWNv?=
 =?utf-8?B?YzZnbUZTcDRlZUdnelVSSUlKdndnNVIzL2J1VElwdFF3QjhRMHRGbitFOUJ5?=
 =?utf-8?B?YjFkYmYwT3pTdVNJelVwemlnbHlqVHBBbWJuRG1UbTYxaDNJNCtDYVB5Q2pM?=
 =?utf-8?B?WmpubkVVQTN6RXJ3c1JZak5abjFxMk9IV3FES3JuUWxRMGtLR0dZOS9RSXBr?=
 =?utf-8?B?aVFkTUxGMlhGNUtuUXVKOTFaQW80anFJMTYrdWw5Mkh1QzFuUFdmZFZoaXI1?=
 =?utf-8?B?QnRvcGtxTTNSVldFRE1jdDRhZ1Brd0pIdlJmOFRhYTlyWFVUK2szV3ZQTWJu?=
 =?utf-8?B?R01YUm1ZNXhjSEdlWGlNTWErOStMeWUwK0ZYa29NNUd3Q25VQ3o5TlM5LzF3?=
 =?utf-8?B?NGtOZ24xUEI0UG5kWlNsSDNkVlQydnRxbExSOWUyT3hGQU1udzMxQ3hBbWRh?=
 =?utf-8?B?NzBhNjRWNlQzUlRlbjBNdzZTdEpQbXlNeENNOXljRkEyaE5DUzFObS9RVkZ0?=
 =?utf-8?B?VGpLNVRGN25xS1BjSkdXYnV5Y2VsaHppdGxDTlBmVTU2TGhhNkNoRlZmcHZa?=
 =?utf-8?B?eGt4cUh4NldpRzRSNldtcXlWOE9xcWFlYlRxOTkrMXBER3ZLaCtCbXZFQ3Zu?=
 =?utf-8?B?alNNaWE3VWxjN1VLZTB4cmp2aXNFVlRIQTdYbzRGcVE4MXVSellla29xTTZP?=
 =?utf-8?B?dWZ0a0tsakNVRzM4bEQ5bk5QYTJKSHpzM2F6TEh5UHdtNEpRUTFsNERVS21S?=
 =?utf-8?B?SERqSnowVnFJemdNeDl6eVdVRk44c1U0NG9BWFQ3endhN1pXdGRvZmhjcXNM?=
 =?utf-8?B?RDdQTzZoQVVMbFNac3h2OTBHc2RjVEJibTU2WFdIVmh5U0R2bm1CT2V2N013?=
 =?utf-8?B?MzJtbDQ2SEhZd3QxTlI4cEJTUmhWYkFWT3JacklBakZ2M3hQZFh5RnFudWhB?=
 =?utf-8?B?bG9JemIzcU0vWDNzcmRmMU51RWNzZlJYMjVkSkdaMkZqUm9IS29DTmtPMzNv?=
 =?utf-8?B?Nmd5akpFSDBLZEdFNGhWRnMwWU1mY1J1QWo4V083YUNkVDh5bjZhNE9ZK3Vw?=
 =?utf-8?B?MzNhQTdmK3RXeTBiVHo4bTg4dXNRTzFWdVRNSmJOYmdUUS9kQlA0djJxL1FQ?=
 =?utf-8?B?ZTRBdDVsZ0hoL1Z0eVpZTlFsOGtjQklKWTczcklUaHhqY0RCTGwvMXFrL1po?=
 =?utf-8?B?Tis1YVZFdHREZVBpSTR6SjdYbWJ0MndsR1lVSytpSjREQk11NmVzajhZTmhZ?=
 =?utf-8?B?VTVsdVpxUWNCaEVYbU90a1R4bkZ5QVR2elBSeGhCSXcraXVPU3hidi9TUXBq?=
 =?utf-8?B?SFNYdE1WVzMxeGdhVWljWFdoWFZCempkWnRoaWlham00VElXbG1OWGhkL2V3?=
 =?utf-8?B?VW1DYWM1ay9uWEFSY2xZWDlLNWhpamdXZmJZSHJFdjVEQUI4N2w5OENnS0hD?=
 =?utf-8?B?Z0xveEV6NnVCTVpic1dmSE54ZnpZZEJEOUIvbGIyRmZmWE1uRDBKWUVncHZJ?=
 =?utf-8?B?UTcraHhuenlERWlwNXNUNkJRUEZXWWlVeE9uNFMvVzlFT055RDgvV3ZodHE0?=
 =?utf-8?B?ZGh4bVZidVJvZWREUzN1MWxrZDEzemFDcnlZWlJrVnFMalRDVzVHYVIxL0lO?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <679C91A7A439A64888067815E4B46E25@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16170b38-08c5-46d1-f077-08da6b1af3c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:14:32.9010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uS+3ONrwtcRIc83HzVPbiV67r4X2vY+7npSrlrnXdKLU8h+LNQ+7sElgMh3gftor
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4977
X-Proofpoint-GUID: XYzRxK_orE6kWNoG8wGurfyUjprcxbI9
X-Proofpoint-ORIG-GUID: XYzRxK_orE6kWNoG8wGurfyUjprcxbI9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_17,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA3LTIxIGF0IDIwOjA4ICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
T24gNy8yMS8yMiA3OjA1IFBNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+IEl0IHNlZW1zIHRv
IGJlIGEgcHJvYmxlbSB3aXRoIGJsb2NraW5nIHJlYWRzLCBidWZmZXIgc2VsZWN0IGFuZA0KPiA+
IFJFQURWLg0KPiA+IE15IGd1ZXNzIGlzIHRoYXQgZXh0NC94ZnMgYXJlIG5vdCBibG9ja2luZy4N
Cj4gPiANCj4gPiBpbiBiNjZlNjVmNDE0MjYgKCJpb191cmluZzogbmV2ZXIgY2FsbCBpb19idWZm
ZXJfc2VsZWN0KCkgZm9yIGENCj4gPiBidWZmZXINCj4gPiByZS1zZWxlY3QiKSwgdGhpcyBsaW5l
IHdhcyBhZGRlZCBpbiBfX2lvX2lvdl9idWZmZXJfc2VsZWN0DQo+ID4gDQo+ID4gLcKgwqDCoMKg
wqDCoCBpb3ZbMF0uaW92X2xlbiA9IGxlbjsNCj4gPiArwqDCoMKgwqDCoMKgIHJlcS0+cncubGVu
ID0gaW92WzBdLmlvdl9sZW4gPSBsZW47DQo+ID4gDQo+ID4gQmFzaWNhbGx5IHN0YXNoaW5nIHRo
ZSBidWZmZXIgbGVuZ3RoIGluIHJ3Lmxlbi4gVGhlIHByb2JsZW0gaXMgdGhhdA0KPiA+IHRoZQ0K
PiA+IG5leHQgdGltZSBhcm91bmQgdGhhdCBicmVha3MgYXQNCj4gPiANCj4gPiDCoMKgwqDCoMKg
wqDCoMKgIGlmIChyZXEtPnJ3LmxlbiAhPSAxKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOw0KPiA+IA0KPiA+IA0KPiA+IFRoZSBiZWxvdyBmaXhl
cyBpdCBhcyBhbiBleGFtcGxlLCBidXQgaXQncyBub3QgZ3JlYXQuIE1heWJlIHNvbWVvbmUNCj4g
PiBjYW4NCj4gPiBmaWd1cmUgb3V0IGEgYmV0dGVyIHBhdGNoPyBPdGhlcndpc2UgSSBjYW4gdHJ5
IHRvbW9ycm93Og0KPiANCj4gSXQncyA4OjA1IFBNIGZyb20gbXkgZW5kLiBJJ2xsIHRyeSB0byBw
bGF5IHdpdGggeW91ciBwYXRjaCBhZnRlcg0KPiBkaW5uZXINCj4gd2hpbGUgd2FpdGluZyBmb3Ig
b3RoZXJzIHNheSBzb21ldGhpbmcuDQo+IA0KDQpJJ3ZlIGp1c3Qgc2VudCB0aGUgYmVsb3cgYWN0
dWFsbHkgd2hpY2ggaXMgYSBiaXQgc2ltcGxlci4gSSByZXJhbiBhbGwNCnRoZSB0ZXN0cyBvbiBi
dHJmcyBhbmQgeGZzIGFuZCBpdCBzZWVtcyB0byB3b3JrIG5vdzoNCg0KZGlmZiAtLWdpdCBhL2Zz
L2lvX3VyaW5nLmMgYi9mcy9pb191cmluZy5jDQppbmRleCBhMDFlYTQ5ZjMwMTcuLmIwMTgwNjc5
NTg0ZiAxMDA2NDQNCi0tLSBhL2ZzL2lvX3VyaW5nLmMNCisrKyBiL2ZzL2lvX3VyaW5nLmMNCkBA
IC0xNzM3LDYgKzE3MzcsMTQgQEAgc3RhdGljIHZvaWQgaW9fa2J1Zl9yZWN5Y2xlKHN0cnVjdCBp
b19raW9jYg0KKnJlcSwgdW5zaWduZWQgaXNzdWVfZmxhZ3MpDQogICAgICAgICAgICAocmVxLT5m
bGFncyAmIFJFUV9GX1BBUlRJQUxfSU8pKQ0KICAgICAgICAgICAgICAgIHJldHVybjsNCiANCisg
ICAgICAgLyoNCisgICAgICAgICogUkVBRFYgdXNlcyBmaWVsZHMgaW4gYHN0cnVjdCBpb19yd2Ag
KGxlbi9hZGRyKSB0byBzdGFzaCB0aGUNCnNlbGVjdGVkDQorICAgICAgICAqIGJ1ZmZlciBkYXRh
LiBIb3dldmVyIGlmIHRoYXQgYnVmZmVyIGlzIHJlY3ljbGVkIHRoZSBvcmlnaW5hbA0KcmVxdWVz
dA0KKyAgICAgICAgKiBkYXRhIHN0b3JlZCBpbiBhZGRyIGlzIGxvc3QuIFRoZXJlZm9yZSBmb3Ji
aWQgcmVjeWNsaW5nIGZvcg0Kbm93Lg0KKyAgICAgICAgKi8NCisgICAgICAgaWYgKHJlcS0+b3Bj
b2RlID09IElPUklOR19PUF9SRUFEVikNCisgICAgICAgICAgICAgICByZXR1cm47DQorDQogICAg
ICAgIC8qDQogICAgICAgICAqIFdlIGRvbid0IG5lZWQgdG8gcmVjeWNsZSBmb3IgUkVRX0ZfQlVG
RkVSX1JJTkcsIHdlIGNhbiBqdXN0DQpjbGVhcg0KICAgICAgICAgKiB0aGUgZmxhZyBhbmQgaGVu
Y2UgZW5zdXJlIHRoYXQgYmwtPmhlYWQgZG9lc24ndCBnZXQNCmluY3JlbWVudGVkLg0KDQoNCg==
