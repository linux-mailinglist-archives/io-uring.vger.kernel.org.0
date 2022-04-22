Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A10450B9CE
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 16:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348481AbiDVORE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 10:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354535AbiDVORD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 10:17:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105CB5AA4E
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 07:14:05 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23LNWg7f031086
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 07:14:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rOvHh3MeEa4jn4L2VvV1OguNbTstnzaz+OM11VVy2f0=;
 b=NNaMv5HtCf0zdBPMoQ0lZlj8GzitO7BUjDCG+jWxr2Hapb8Ufqxdq7Z3serekSHS/gu1
 g8O7gsQZTPurizAaxfMNkbuIgYAOR4SJkw0OdjsDvC8b36G7mNghzQCgdCYGKYkIGO6H
 /rKWY6RugInH3N/mW1dXG8kF53g2ZY1JmtI= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fket44p47-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 07:14:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgAAAkUiTSNu45RQGnfTeTAYlstkApPcJ6PgeekaAIdcR9Noz8OPB3BgstXnqLD1aeiqu0p2IE3DPolJIvrLpt+gpDoqwPb6L3ydXEzMjB9Pe4JIVqbTE1HPvAQ0O+RJZ+LFn/uG6xHDnKGGWbKRvKyz1PSHuvCYTJnOnQBe7SzNz5dLClQKeUd1asTxqE7z/CnEWA7wP0MScQq43mHaLn3XHDT1EpKXrRvuIuTkb21b5791tCIv9j+fz0ooCWFcs0jGWEwclKagxtLaT7s4DqOtwiLQuxKotxH48oM/4Oz5ocDIsoD1DSvPZaoHBIRjLzsEVJfDO/dEKfXepmmarg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOvHh3MeEa4jn4L2VvV1OguNbTstnzaz+OM11VVy2f0=;
 b=FwFluczwBnrRV6s9lsE/BbUK8y3daMj917da/sBCNpjI/zwa9wj6FGeUpNItUp/pFKxr835HlubyI1vjisXPVI2f0gVS6eVue7Q35QJhyxpRDrD7PmuR24msiCnYl8k2DNLX+MYFlFbootxCvUyJGBP2N1STyzj074aRWxASw9dLwmmziLfcv84yqvpCDeVBljd4uKiEIElAXy86ei1cUUx9e0jNspMvieAQpMdoxhpiWrp9VOlUFoICN6qxVu4ZIryy2Nh9+DTjTwXtyUS5xgazGTznygR31K68W7c4deWWYqXWZJwGPkHt8qhzAbOlTnrG0QGltLzzK4Pfr2APTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by CO6PR15MB4180.namprd15.prod.outlook.com (2603:10b6:5:34a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 14:14:02 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9c42:4b28:839d:9788]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9c42:4b28:839d:9788%6]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 14:14:02 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing 6/7] test: add make targets for each test
Thread-Topic: [PATCH liburing 6/7] test: add make targets for each test
Thread-Index: AQHYVj7yd46B6Kl4r0mZU0un//ek1az78LMAgAAJPIA=
Date:   Fri, 22 Apr 2022 14:14:01 +0000
Message-ID: <b486973c0cfd475afd88763489bb5c1ef8c73f73.camel@fb.com>
References: <20220422114815.1124921-1-dylany@fb.com>
         <20220422114815.1124921-7-dylany@fb.com>
         <eb7c07c1-fc2a-a44c-68cb-c98568912d6f@gnuweeb.org>
In-Reply-To: <eb7c07c1-fc2a-a44c-68cb-c98568912d6f@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb587615-8de5-4332-88b8-08da246a59f8
x-ms-traffictypediagnostic: CO6PR15MB4180:EE_
x-microsoft-antispam-prvs: <CO6PR15MB41803E2AB1127B12E78F5CD2B6F79@CO6PR15MB4180.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8B+B02rXY3RsVV77DUy76rT2Cyg3J7/3+xzcpUOBcSm3oLLVbv0BUdhKmPhy75i1EM56t8eoPhRRuakgMbwmcfSTJL2t6cmUhOTUYulwYPSo2ItBjGHbEsT9X5DFJgXKGcfQ5353/B812E27SYRvX7AaN5quviBsXfJbCJYzc1o8SGtNgfbOWksT7aGj+0teg3EL6z5fj2JJT92LqxqeWUkvew3pazLoVd+IIPTVAkcUaLXEK0wBpe4B2G1PURWhbmpq2fid2z8/6I6rRoRfVQ54tJo7A4hhzQw60crpSLE3Wz4TKiG/9V//1dkioeFw8S03Qvyap+bSQq2H42QDKutFGhtWUHRY5MVItaBN/RGiBNllNgugtYJWy/msJY0YJVAQ8dZFifngMlf9w+SpjAz7ActeVNurwnY4CcL7NRnmCZ87d45WxfHLo/gCm+2HKmgXqwkE+0rlmDsyTKuJgQKU2HLFtqh8obf9BeZnZM5FEDzKYhcP8xMKpoEvf/XRQpO74cRsmQzQGvprjsZ41cCclGR+xzKq/wDxkS68Vn2E5xW6VXkvMaPNVKHYeUWFTJOtUQrUbRjwmQ8P9ZU92Mh1hDCqegeroQQPrlNrncl799L0V1YRJpaWBKD9Ct39IXMqxd1YIiLI1AmNevTX9L6gAZchqXRUs785qbML+4a4B3Wf8KE4ixs+Jw8ihR/DDgHBfR8GRdlDRTZazY+wA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(86362001)(38070700005)(66556008)(66446008)(76116006)(91956017)(4326008)(64756008)(66476007)(8676002)(6486002)(83380400001)(36756003)(53546011)(2906002)(6506007)(508600001)(186003)(6512007)(122000001)(2616005)(71200400001)(38100700002)(5660300002)(6916009)(316002)(8936002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alZIWml1OUVremdJL0J6QnpaVFptV1BmbUhoZDV0NGFzb2s3RzdyM2lFc2RV?=
 =?utf-8?B?OEJWeGdZb2dhQUt3ckFQMFFCZVpRTVZQc1BsdVRHMjhoeklYRXYrQ2d0ck5L?=
 =?utf-8?B?MGNCK1NaWU82dFo5Uld1V1FJdmRGZksxVHd0Ym5KZW1WZEQvSUFvdmRNeXRw?=
 =?utf-8?B?cjZKeUMyeHJuT3dQa0pVRnY1amVONzRIVEp4R0ZQcVlWcm9LL1VoQm9FZ2Zm?=
 =?utf-8?B?OXlEQzZhUWhyWWs1Nm9qendLc3JxcGUrdFhOTGRIcm83M1NGYVl0N1hZYzBx?=
 =?utf-8?B?QkErNVZLUHpiTklZQVNDM2J5N1hCcHhZVy9kWjhJUW5iVnVialB2REhLc01k?=
 =?utf-8?B?Rlp6cFVVbEhHWVUwZm54WnE4Zk0ydmJqUksvMy90QnZyR1Y1b0dMbkR3enB4?=
 =?utf-8?B?MUpNVlFWamd0eGJ6ZGtQUzFFY3crKzNVTXpFeUhiNTFST1JBMTFDbmFIRXBV?=
 =?utf-8?B?cVIvY3lwQzA5QUFFMDEvTCtSMUwybXBWQ3l5dWNqM0Ntejc5OW1FOGV1enkw?=
 =?utf-8?B?OUdtSUVTVFpFbHlPaWVBaHhaYzZ4Z3VNNmh0cmZsbTY5WTV3YkttRy9EUHNv?=
 =?utf-8?B?SEdLY3JXVFlnZ2ltU3l2UkhRRE5DenZpcnBWdHBYbUNWM1o3ckRTV1B6Nk5n?=
 =?utf-8?B?d3EwcVdEbnR1R0JXVGlFMFdWSEFsbEdNOWJIWnZtUHJjUURyVnBFc0F3d0dY?=
 =?utf-8?B?UjBGNmpFNkl3SllzRUFNbWZTbStUK2ZYTFMxTVZ4U0JIWk1uUjUyZTl4dmRn?=
 =?utf-8?B?Rmp1eDI3Z3lObTJqS0RYakU2Y2llVDlFSjU4M0VVTTl5eWdPNjRhcmd4SCti?=
 =?utf-8?B?Sm9LMyszUVk0TEZIbGkyMDVaOHBrbTVrNG1GemU1OFdjQ0lzUlhFUlNRdThO?=
 =?utf-8?B?bWswaW9aaFpIL3BRQldWRWZzdHJscnRMa2dsNEN4dWVKSDAwRWMzcEF2cGNm?=
 =?utf-8?B?eXlHUHhwMWNsM1hYYlFQamE3cHNnVFBSY0lLT2xRdFgwQTBzZ1hhV2dEVUk5?=
 =?utf-8?B?SGxUSGhSMmJ4SEtMUTVIYXFES3ZncDl1QkppS0x0QzJFZjBIU1F1dEk4U09Q?=
 =?utf-8?B?TVNDK0Z1Y2ZNa29vbjFlaGo3cnUxZnhkckxXa3NhdVZlM1dkUTMreTMvK2Zz?=
 =?utf-8?B?bFZsL1RCZXI4U1NWWFdvSG1ZRCt2WVRhbUxSSk04NSt0SFg2Z3BrTCs3QkdB?=
 =?utf-8?B?M2ZScXc3TllNQks0am04bHNTWStDVVhCT0YwclA2TWF0U25NNjhNUUdKQXFr?=
 =?utf-8?B?Rk03UmU0NzlOQnhoek5KREpaZDNPMjExMWR5dFhlSzlZWDJvUkZnYjhyalJO?=
 =?utf-8?B?aDVHZ0E5Qm0raVpoazhQeGdlQmpnS25VUVhnay9FajFBTUdySGxpdmdZenRI?=
 =?utf-8?B?WnI2dzgxdjczZ2orS0cxS2wvNDg2SDc2YmhkbFdNMjkrNXA0V0lXUFpSQU1P?=
 =?utf-8?B?TDEzREFScFBjZTI2TStadVhjakFpQVA0MlprczZoUGUwaW1VQ244eGJzcWtX?=
 =?utf-8?B?VGtJVm1DNkJBWXBUMEhvMjBQdW5Rb0pYYmZuZXFEODF1ZmhhclRDMm1YQ2g5?=
 =?utf-8?B?WWluNndKbjU0NXZ5ZWFxdEIrRHlyRE5aRllDLzUrS3BMbDdSelNhUndpWlZM?=
 =?utf-8?B?aFhLeGdEK2JJM2N2WVV1T1I5azlBQ2lZaksyVEE4RVNIV0tDZXRsNXZ4QUYv?=
 =?utf-8?B?OWRWOVhPSHpqVElTWWwvWEx0L3dOMmRwbmU3MVdsc3ZmN2NTRlJkMjFUQ20v?=
 =?utf-8?B?Tlk1cG94MFVwRE1OMm9kNFlhMWlBUjNoRXBtREsrL0pybWcvMytyaHpwQXg2?=
 =?utf-8?B?R2ZKUENFZ0lXaldpc0RWeU13YS9yR3E2OHdBcGZQUzFRZml4dlltWXQ1WEtp?=
 =?utf-8?B?UkVnM3FJejhDMGhWZmhqNnc1eVdaOW1KRnVrKzJSQ3B4bEFSbFBSMWo2Vm93?=
 =?utf-8?B?WldsWFlKSWZJalZ0M3Q4bndidi9mekZjOWhtby9iakNCeUpqMkNGZWlkTjF4?=
 =?utf-8?B?SDQ0MVI4L1dneW5SZ0s4SlI5TFQvMjJjbGRLMFluaHgvdkc5Wng2M3BBRjdQ?=
 =?utf-8?B?UVo1VnRodUJ4NnVYcHRRcVJ1TzV3UkR2cTVCaUcwVlBKcHo4MnVRangvcmZD?=
 =?utf-8?B?MDB4ZlFVOGdsVUxYM0p3VWMyOWVNUSs3SWxFaU15YXRXQkhrNWZkOEcyeHRq?=
 =?utf-8?B?ODhDeUlkd3NnOU5iS1JOQUZTQk1kb1RUUW8yVS85UCtoOVczWnFsZkxGU2c2?=
 =?utf-8?B?T1EyMmJQY3VnbjlmcUNlbEdwOEZUV3AvR3Y0UTl5NzMrdGpDdnZ0b2xiTGls?=
 =?utf-8?B?NTNvamxlSmloSjJ0WEJQbU5odEwzUVdCS3FxMnZzZWdjd1RvK2x1MTFiVU9X?=
 =?utf-8?Q?dY4I5AobwHiOJ4do=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <955AE710BF0E3D4BBCBB951F8AA5FC54@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb587615-8de5-4332-88b8-08da246a59f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 14:14:02.0627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mfBaf32TowJlaHB6zRu69ZbdwpG0/SGRK9Q3Ob2OIgeKWYbRHa7i7M/K+YGrLXih
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4180
X-Proofpoint-ORIG-GUID: dNy8fq7G0Rkrbs8tIb0xpIQ0L2H8f2x1
X-Proofpoint-GUID: dNy8fq7G0Rkrbs8tIb0xpIQ0L2H8f2x1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_04,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gRnJpLCAyMDIyLTA0LTIyIGF0IDIwOjQwICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
T24gNC8yMi8yMiA2OjQ4IFBNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+IEFkZCBhIG1ha2Ug
dGFyZ2V0IHJ1bnRlc3RzLXBhcmFsbGVsIHdoaWNoIGNhbiBydW4gdGVzdHMgaW4NCj4gPiBwYXJh
bGxlbC4NCj4gPiBUaGlzIGlzIHZlcnkgdXNlZnVsIHRvIHF1aWNrbHkgcnVuIGFsbCB0aGUgdGVz
dHMgbG9jYWxseSB3aXRoDQo+ID4gwqDCoCAkIG1ha2UgLWogcnVudGVzdHMtcGFyYWxsZWwNCj4g
PiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBEeWxhbiBZdWRha2VuIDxkeWxhbnlAZmIuY29tPg0KPiAN
Cj4gVHdvIGNvbW1lbnRzIGJlbG93Li4uDQo+IA0KPiA+IMKgIHRlc3QvTWFrZWZpbGXCoMKgwqDC
oMKgwqDCoMKgwqAgfCAxMCArKysrKysrKystDQo+ID4gwqAgdGVzdC9ydW50ZXN0cy1xdWlldC5z
aCB8IDEwICsrKysrKysrKysNCj4gPiDCoCAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4gPiDCoCBjcmVhdGUgbW9kZSAxMDA3NTUgdGVzdC9ydW50ZXN0
cy1xdWlldC5zaA0KPiANCj4gSSBzdWdnZXN0IHRvIGFkZCB0aGUgZm9sbG93aW5nIHRvIHRoZSBt
YWluIE1ha2VmaWxlOg0KPiBgYGANCj4gcnVudGVzdHMtcGFyYWxsZWw6IGFsbA0KPiDCoMKgwqDC
oMKgwqDCoMKgKyQoTUFLRSkgLUMgdGVzdCBydW50ZXN0cy1wYXJhbGxlbA0KPiBgYGANCj4gDQo+
IFNvIHdlIGNhbiBkbyB0aGlzIGRpcmVjdGx5Og0KPiBgYGANCj4gwqDCoMKgIG1ha2UgLWogcnVu
dGVzdHMtcGFyYWxsZWw7DQo+IGBgYA0KPiBpbnN0ZWFkIG9mIGRvaW5nIHRoaXM6DQo+IGBgYA0K
PiDCoMKgwqAgY2QgdGVzdDsNCj4gwqDCoMKgIG1ha2UgLWogcnVudGVzdHMtcGFyYWxsZWw7DQo+
IGBgYA0KPiANCj4gPiAtLlBIT05ZOiBhbGwgaW5zdGFsbCBjbGVhbiBydW50ZXN0cyBydW50ZXN0
cy1sb29wDQo+ID4gKyUucnVuX3Rlc3Q6ICUudA0KPiA+ICvCoMKgwqDCoMKgwqDCoEAuL3J1bnRl
c3RzLXF1aWV0LnNoICQ8DQo+ID4gKw0KPiA+ICtydW50ZXN0cy1wYXJhbGxlbDogJChydW5fdGVz
dF90YXJnZXRzKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoEBlY2hvICJBbGwgdGVzdHMgcGFzc2VkIg0K
PiANCj4gTm90ZSB0aGF0IHRoaXMgcGFyYWxsZWwgdGhpbmcgaXMgZG9pbmc6DQo+IA0KPiDCoMKg
wqAgQC4vcnVudGVzdHMtcXVpZXQuc2ggJFRIRV9URVNUX0ZJTEUNCj4gDQo+IF4gVGhhdCB0aGlu
ZyBpcyBub3QgYSBwcm9ibGVtLiBCdXQgdGhlIC4vcnVudGVzdHMtcXVpZXQuc2ggZXhpdCBjb2Rl
DQo+IGlzLg0KPiA+IGRpZmYgLS1naXQgYS90ZXN0L3J1bnRlc3RzLXF1aWV0LnNoIGIvdGVzdC9y
dW50ZXN0cy1xdWlldC5zaA0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNzU1DQo+ID4gaW5kZXggMDAw
MDAwMC4uYmE5ZmUyYg0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi90ZXN0L3J1bnRlc3Rz
LXF1aWV0LnNoDQo+ID4gQEAgLTAsMCArMSwxMCBAQA0KPiA+ICsjIS91c3IvYmluL2VudiBiYXNo
DQo+ID4gKw0KPiA+ICtURVNUUz0oIiRAIikNCj4gPiArUkVTVUxUX0ZJTEU9JChta3RlbXApDQo+
ID4gKy4vcnVudGVzdHMuc2ggIiR7VEVTVFNbQF19IiAyPiYxID4gJFJFU1VMVF9GSUxFDQo+ID4g
K1JFVD0iJD8iDQo+ID4gK2lmIFsgIiR7UkVUfSIgLW5lIDAgXTsgdGhlbg0KPiA+ICvCoMKgwqAg
Y2F0ICRSRVNVTFRfRklMRQ0KPiA+ICtmaQ0KPiA+ICtybSAkUkVTVUxUX0ZJTEUNCj4gDQo+IFRo
aXMgc2NyaXB0J3MgZXhpdCBjb2RlIGRvZXNuJ3QgbmVjZXNzYXJpbHkgcmVwcmVzZW50IHRoZSBl
eGl0IGNvZGUNCj4gb2YNCj4gdGhlIGAuL3J1bnRlc3RzLnNoICIke1RFU1RTW0BdfSJgLCBzbyB5
b3UgaGF2ZSB0byBhZGQgYGV4aXQgJFJFVGAgYXQNCj4gdGhlDQo+IGVuZCBvZiB0aGUgc2NyaXB0
LiBPdGhlcndpc2UsIHRoZSBNYWtlZmlsZSB3aWxsIGFsd2F5cyBwcmludCAiQWxsDQo+IHRlc3Rz
DQo+IHBhc3NlZCIgZXZlbiBpZiB3ZSBoYXZlIHRlc3RzIGZhaWxlZC4NCj4gDQoNCkJvdGggb2Yg
dGhlc2UgYXJlIGdvb2QgaWRlYXMgLSB0aGFua3MhIFRoZSBzZWNvbmQgb25lIGVzcGVjaWFsbHkg
aXMgYQ0KZ3JlYXQgc3BvdC4gV2lsbCByZXNwaW4gYSB2MiB3aXRoIHRoZW0NCg0KRHlsYW4NCg0K
