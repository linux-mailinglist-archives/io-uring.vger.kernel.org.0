Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDACD5B23B9
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 18:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiIHQjr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 12:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHQjq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 12:39:46 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5081F601
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 09:39:41 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288FcTg7001291
        for <io-uring@vger.kernel.org>; Thu, 8 Sep 2022 09:39:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LeUoiv0ya5dmkUROY/NFL/u50yU3tKERSxuccmCDq9g=;
 b=DLjjYlNdA7qn3hQw3AjXml6kyiugiz4LE7A4eN4hIqc4FoS7Wj2WooRgvbc4GtxGHLgg
 YfWNExJKYq66I1Lo93tQqGe1FXL8Ym0oP8d6TFB+rDe1pfgvXS9CLtI5Wu9GPiInkIRM
 pvuhISg6Oa6vWC3PSjXlGZR3O5lRrFG8LGM= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jfk74gfys-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 09:39:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdyVxCWO+BcKiTgjLZYqrB36bQYhWo9f3f7808K4RjHTovRxSUVgZa3WcAaTOuXvgqeHE5RS6SLPCUmeoy6W2BfWwTjcGUZ+VfMHNYnhH7/VofkMvHi8CsDjSapQnHT+bUnmsGB+ew3oFi2zSLcpEMxOi0qOWAHkMKqHv6kfed2sa3FI2EOaASny3OiGG45CoGfCgu77Nq43J01PmDjdqBEafWVWKsbZNaTZ5JF0wna//b+mYW9u1HfkzcTQIxio0VVBNeKy8mk0k6naB9lFpRoLFiF7j/hiz+7OjqpzmMkMhRf0pnSaLzji0+AOcySlYUavGUBAdzWH0WCWXxllfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeUoiv0ya5dmkUROY/NFL/u50yU3tKERSxuccmCDq9g=;
 b=ML1SN0G/MnP2sL1jQlMVwad8Z8DFUrmmiQ+Hm6247WSWTB3/GqpYofn8XbBPWvsz8QO3944JP/WOyZFYoxZo9NypE0/p5dpxVJx/dqR/lrgGXDTwqJ4hOO/zKnAe2ZWn3Y+BuGNwwc6KBdDjhAeRQv2CZSnzJdhXwcK2XUxTWcuIE1j5UipNbN7JYWLVJ1ZXWko0s6vFzLFrxKZc7nCE2G3kD7VNh2KADTE+7mFZv3RjcRoYUffMVWIHKn684rI73IM1cbNFrcJgL9imWgAtFWeoITQs2Z1RfydcsGvsp2WmRytMDZ6xXYac+EFjuFwRNadePBb4zSfzD13XgYu/RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA1PR15MB4657.namprd15.prod.outlook.com (2603:10b6:806:19c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Thu, 8 Sep
 2022 16:39:37 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%6]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 16:39:37 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 1/6] io_uring: further limit non-owner defer-tw cq waiting
Thread-Topic: [PATCH 1/6] io_uring: further limit non-owner defer-tw cq
 waiting
Thread-Index: AQHYw5vrkH1uIbhpy02/oSb1Zleo3q3Vu/KA
Date:   Thu, 8 Sep 2022 16:39:37 +0000
Message-ID: <3a0e4f5d1fe8616911af22598647e42e9a4ffbbe.camel@fb.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
         <94c83c0a7fe468260ee2ec31bdb0095d6e874ba2.1662652536.git.asml.silence@gmail.com>
In-Reply-To: <94c83c0a7fe468260ee2ec31bdb0095d6e874ba2.1662652536.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|SA1PR15MB4657:EE_
x-ms-office365-filtering-correlation-id: 037f0aff-4293-4adf-98dd-08da91b8b847
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ipl6M/cdfmPOZ/oxWAQJAbd7bfBrsnMr4BEtzmXl1tnwNwNj2GKBmtMzoG9F7RA/+rKzJgFsrDs8c2oBtCU5H6RA66z5KoElsRZvKmbAcmVQemfzTnHeu8CdX4yXrKm2pLa+Eab74lqGFlXfHMeYpF/Huu3n7PkLtlhnHmXEZ4pfUtm1cOUbeDZ+4JLW1Skl070MOqC1KNJf1dy/J148GzznSrjyobEKUO4n0T0tRleOZVbpMhQOiuq1kfJ4pL/anRjWOpdZycebNn7G0ZNDtC3nfJZLllZUPytOWKtdHBc5L3kGywEO77r6fFlQb3ArY6ynsse22jkp4bukrTGQwCSP80CdIrj/9NHkLzNxDSaL7b4VTH67t/3i9C5NB9B5hwoUo6evLK6O/7QrnAdaOer4r+ly4PDLpfa3/92OWrVLC0wGgfL4MZitwvKXpuoPU+aw4WAHxHLjy8riodnN77GMcJzbdiuJ9TZg5bDdt6y4qns0X8KABrRy0OimZgQWqWQqoCs8UaBH1YbYHM3xN4lc3iVHyEUqadizaSqntgKvrWRjGI6FJQ/bRWN0nZgAnci89r5uL95XShdAiy41yd9WQtLqvSXubb1BfjDPVH13CUeTq6K6l8fe9jwG3xNEpsULhcYlLV2TffDJkmA3YuWC9iebbDKAECS40KQjye3P/QyBd2qQnaEXgdxrtcIn8vTaf17kjLVDm3XuRQuGnFi3BSNIT6nzUlwbEYpTM5RD8wN2KIxCQmBgBpAI43r6bx0BXoOy7lvKNMBwQ/Xggg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(6506007)(41300700001)(26005)(6512007)(478600001)(6486002)(2616005)(71200400001)(186003)(2906002)(5660300002)(8936002)(110136005)(316002)(66946007)(4326008)(8676002)(64756008)(66556008)(66476007)(66446008)(76116006)(91956017)(36756003)(122000001)(38100700002)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUhzUG1sMlNhQXFpWEcwcTNZQ2hoMzQ5SG96d2NDTlVrYmU5bmpMWHlkQlVh?=
 =?utf-8?B?aW9DbDZvRXpVeUs2TFllczhreWJ1ZXJMZXJyc0JacGdhcWgrY0VXUDVBNzNm?=
 =?utf-8?B?NlhFa1BKRFk5RlFPYm1KN2Q3NWduVjUvQnJPV3ZaczM5WmF6RElBSEorVk10?=
 =?utf-8?B?azkzM2RVbFdWOGdlcVZyelp6bTN3QTEyckVrZlpjelBqM1B6azNmSStNSjJP?=
 =?utf-8?B?dUhmSTVvR0Q4RmJBUHc5cTNxdVB3dFRDYkJRUWZieEg5SkwrbmY0aDFLZk9T?=
 =?utf-8?B?WjlRelNJRmF1UzBPQWY2WlZIZTdZZDdFLzU1TEhpa2FzUUNuUmh3clAwdVBX?=
 =?utf-8?B?YjdtSFBXNlpoSU1uU3JXWTcxMXJKMEpYM3k5RVpyWW5lblNPV1puenY4dldX?=
 =?utf-8?B?aVhTQWJJVlVaWUUvaHJERlNHb2RCQWdGZ2lobCtpby9ZTmlUaU9lM0xuSmFX?=
 =?utf-8?B?d1lhNWhlNVZYazlwOXVEYnl2aVVFM3prczlPTElTOXBnaUd6QzN6NEU3cUlH?=
 =?utf-8?B?dDA1QnhrY0FlTThkYkNmcUUzVHhVN2toWTlybnVhS2h0L3hxc0FGWHIwQTRG?=
 =?utf-8?B?dTZRWlA5MmozVmRzSFVBRHNoZDczcFo4ZE0rdVdEcS9Rb2tLUlRkWEZOWEc2?=
 =?utf-8?B?SnFIaHZYL3pja285SVI1NDRValRTRHZFb3g5S1RRaGRwU0VjM3lSck5oalRt?=
 =?utf-8?B?YlhtM0JlVkRIYnI4bUNuUExqNG1vVjF5Z2FTaGxDVXJkMzMrTjlMbDJIRC9G?=
 =?utf-8?B?ekQxcTFTSGJCMEZtVTVOUU9icnlzdTlSM1dEUDljdHMxUDFiWndFRnZQYjdk?=
 =?utf-8?B?ZFFBSTcwRTV6aGNsSFFXcTg3VDlzNEpHZG5STXdjS0diWTh2dHNkRjlEMjZv?=
 =?utf-8?B?QXNvdGRUUlBvTGdyTEEwK09VQXpXQTlIT1RsQVVrNGpTYlJ3c21rcDhKZmVE?=
 =?utf-8?B?U1dIaERKZ043SmNlTTNHTk40WjI4Y1FUYk9YT2VYREFkKzVZMk1ReEtaVlFp?=
 =?utf-8?B?SXdzRm4wKzI5b0lzOUx1Rk94SnNMNlpxb0x5dmxXdG9WUVViS2Jsdml6cnNZ?=
 =?utf-8?B?cE9qT3FBNzdvbGtDMGEyWHZYeUc4WlR0RWlMSmxxeEI4cjFLdXYrWDFYQTdZ?=
 =?utf-8?B?b0pMLzU1UEVVbXhpdDNxMjZIMnJBU0xwSXJRaFJQVHROcjg5ZWxFa2hURkpH?=
 =?utf-8?B?cnR2a2hpNGljdTJUZUVpUXFMVldDbTBTU3lMdHVxVzBLM0dQU3I4OUg4QkEv?=
 =?utf-8?B?Y1EwS3RnSG5JQ29Wdmc4NjBzMWZyQnp4VnQrSnZwblBmcWdxeDRxUEoyVU8z?=
 =?utf-8?B?MzFwRmprNndBMTBJRGJoVU1WbFlKTFkzb3NDd1ZVZ3dxc01ibHo3eHpha3k3?=
 =?utf-8?B?UXpOS21pR3FJZ1V6bmE2OSsyWWk3cGxqOHI1RHZ5SnVHZkhRTmdEc3BmK253?=
 =?utf-8?B?eXJpcHlmT0hZdDcvcVM4dGZkTytLQVNESjl5MGdZSmt6V05SZUtjeEpDT1Ux?=
 =?utf-8?B?Ukh5MmdzZHVNanBNVTluNlU5RUpzbyt6RWVVU2tIekJoaUVQek5nOGxRMlFj?=
 =?utf-8?B?SmV3Ym9CUWI1OVRFRmNrMjBUaGRuN1NKT2JuZkIwVExJNnBsZDFCaGNJN0kr?=
 =?utf-8?B?Z2NYRjRxSXFTOXFIajRpNElWMTdmK2gxWUNEZGFyS3ZWSEJpaEhpdnpiSlBO?=
 =?utf-8?B?UjJWK0l4bDV4LzgyQVVCWGVzNmExRURrZHZtOHJBeHd5T3ZaUTdBSWF0SzJi?=
 =?utf-8?B?ZU9QeXBnOGdtMldCdXlIUFN1bjM3U2lYLzdZWDFGZmhpcGRKejdjR2VtdDY4?=
 =?utf-8?B?TTcvTjM5NVVCYVd1MDJFb1ROVit5d3Rsd2NCVUJhQysxWENBKzNmdEd5UnRo?=
 =?utf-8?B?U3dmN2FnZ0VuVlRMV1c0RHYzVE9UNTlOcEhZaEFLL0xxL1RYTngxQ3AvVkJx?=
 =?utf-8?B?ckZtMjZKM216MVZ0NmJCR3ZjeENIMWZPZ1VYY0s5bmFlREFjcmdtYmxFampt?=
 =?utf-8?B?THFtWi9lZEFXL2JJclNOR2lHVXlaY2FaaWxuckdGcXhZeDJadVRqRVZxRmVy?=
 =?utf-8?B?cy9SVUI4QVpyRExCdUVEWDFLbytBRE5SMXR1NnpsamM1NHpMTFdhdFQ2bGhl?=
 =?utf-8?Q?aQtpVrz4gccyfpylfQIo309P/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40633542C09CDF4CBF78666104EC0F99@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 037f0aff-4293-4adf-98dd-08da91b8b847
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 16:39:37.7587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U4nkuzzW8uef8p4GiXM0FjTHwXtgXrWg44DK9HvM08bysq2sL/0EFhcLJF+wkhWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4657
X-Proofpoint-ORIG-GUID: CLAvZ9J_VpbcGG5Dv30v2gVgMraD7O5n
X-Proofpoint-GUID: CLAvZ9J_VpbcGG5Dv30v2gVgMraD7O5n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA5LTA4IGF0IDE2OjU2ICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToK
PiBJbiBjYXNlIG9mIERFRkVSX1RBU0tfV09SSyB3ZSB0cnkgdG8gcmVzdHJpY3Qgd2FpdGVycyB0
byBvbmx5IG9uZQo+IHRhc2ssCj4gd2hpY2ggaXMgYWxzbyB0aGUgb25seSBzdWJtaXR0ZXI7IGhv
d2V2ZXIsIHdlIGRvbid0IGRvIGl0IHJlbGlhYmx5LAo+IHdoaWNoIG1pZ2h0IGJlIHZlcnkgY29u
ZnVzaW5nIGFuZCBiYWNrZmlyZSBpbiB0aGUgZnV0dXJlLiBFLmcuIHdlCj4gY3VycmVudGx5IGFs
bG93IG11bHRpcGxlIHRhc2tzIGluIGlvX2lvcG9sbF9jaGVjaygpLgo+IAo+IEZpeGVzOiBkYWNi
YjMwMTAyNjg5ICgiaW9fdXJpbmc6IGFkZCBJT1JJTkdfU0VUVVBfREVGRVJfVEFTS1JVTiIpCj4g
U2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+Cj4g
LS0tCj4gwqBpb191cmluZy9pb191cmluZy5jIHzCoCA2ICsrKysrKwo+IMKgaW9fdXJpbmcvaW9f
dXJpbmcuaCB8IDExICsrKysrKysrKysrCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlv
bnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lv
X3VyaW5nLmMKPiBpbmRleCAwNDgyMDg3YjdjNjQuLmRjNmY2NGVjZDkyNiAxMDA2NDQKPiAtLS0g
YS9pb191cmluZy9pb191cmluZy5jCj4gKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwo+IEBAIC0x
Mzk4LDYgKzEzOTgsOSBAQCBzdGF0aWMgaW50IGlvX2lvcG9sbF9jaGVjayhzdHJ1Y3QgaW9fcmlu
Z19jdHgKPiAqY3R4LCBsb25nIG1pbikKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldCA9IDA7Cj4g
wqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGxvbmcgY2hlY2tfY3E7Cj4gwqAKPiArwqDCoMKgwqDC
oMKgwqBpZiAoIWlvX2FsbG93ZWRfcnVuX3R3KGN0eCkpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiAtRUVYSVNUOwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgY2hlY2tfY3Eg
PSBSRUFEX09OQ0UoY3R4LT5jaGVja19jcSk7Cj4gwqDCoMKgwqDCoMKgwqDCoGlmICh1bmxpa2Vs
eShjaGVja19jcSkpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChjaGVj
a19jcSAmIEJJVChJT19DSEVDS19DUV9PVkVSRkxPV19CSVQpKQo+IEBAIC0yMzg2LDYgKzIzODks
OSBAQCBzdGF0aWMgaW50IGlvX2NxcmluZ193YWl0KHN0cnVjdCBpb19yaW5nX2N0eAo+ICpjdHgs
IGludCBtaW5fZXZlbnRzLAo+IMKgwqDCoMKgwqDCoMKgwqBrdGltZV90IHRpbWVvdXQgPSBLVElN
RV9NQVg7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gwqAKPiArwqDCoMKgwqDCoMKgwqBp
ZiAoIWlvX2FsbG93ZWRfcnVuX3R3KGN0eCkpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiAtRUVYSVNUOwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgZG8gewo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogYWx3YXlzIHJ1biBhdCBsZWFzdCAxIHRhc2sgd29y
ayB0byBwcm9jZXNzIGxvY2FsCj4gd29yayAqLwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmV0ID0gaW9fcnVuX3Rhc2tfd29ya19jdHgoY3R4KTsKPiBkaWZmIC0tZ2l0IGEvaW9f
dXJpbmcvaW9fdXJpbmcuaCBiL2lvX3VyaW5nL2lvX3VyaW5nLmgKPiBpbmRleCA5ZDg5NDI1Mjky
YjcuLjRlZWEwODM2MTcwZSAxMDA2NDQKPiAtLS0gYS9pb191cmluZy9pb191cmluZy5oCj4gKysr
IGIvaW9fdXJpbmcvaW9fdXJpbmcuaAo+IEBAIC0zMjksNCArMzI5LDE1IEBAIHN0YXRpYyBpbmxp
bmUgc3RydWN0IGlvX2tpb2NiCj4gKmlvX2FsbG9jX3JlcShzdHJ1Y3QgaW9fcmluZ19jdHggKmN0
eCkKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGNvbnRhaW5lcl9vZihub2RlLCBzdHJ1Y3QgaW9f
a2lvY2IsIGNvbXBfbGlzdCk7Cj4gwqB9Cj4gwqAKPiArc3RhdGljIGlubGluZSBib29sIGlvX2Fs
bG93ZWRfcnVuX3R3KHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4KQo+ICt7Cj4gK8KgwqDCoMKgwqDC
oMKgaWYgKCEoY3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9ERUZFUl9UQVNLUlVOKSkKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHRydWU7Cj4gK8KgwqDCoMKgwqDCoMKg
aWYgKHVubGlrZWx5KGN0eC0+c3VibWl0dGVyX3Rhc2sgIT0gY3VycmVudCkpIHsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogbWF5YmUgdGhpcyBpcyBiZWZvcmUgYW55IHN1Ym1p
c3Npb25zICovCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAhY3R4LT5z
dWJtaXR0ZXJfdGFzazsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJu
IHRydWU7Cj4gK30KPiArCj4gwqAjZW5kaWYKClJldmlld2VkLWJ5OiBEeWxhbiBZdWRha2VuIDxk
eWxhbnlAZmIuY29tPgo=
