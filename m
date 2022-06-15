Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D59154C2A5
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 09:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241752AbiFOHdc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 03:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbiFOHda (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 03:33:30 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F158F27CC0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:33:29 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EMd5lF023488
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:33:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Pf+ryCg2XXUD1GR/VhHtT1pMnYPXvTZxnwx7Zt06oG4=;
 b=iN2yfYb0Uqs0sQnPitSqPIEE8GQXzTRottJ5oX3P74QU0NAgapijuKFOeTXFcGm+pGvM
 BX03wG+u/7ROiMM4s92Q/Aw5xOnE4JteC5cLhq8INJtUJfI5lsTgntMHM5OPob5ky9kk
 N2muQE82Du6WpzTowo26EYtDmAne8UVMQ0k= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmrvvcugg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y38CMcgHEbJElqMU39GQ274YJR1t6/mncb3mLOvSK0QuJw3ZAiUt2ehzR8bwlXN2Z/qWCbSHHvsx6kfeC6M9h6nDLqokSVqtHRL+2NTgxtR/q01BMziOnpBIWBqQLA5TEKktQTaLd6XDAcqZGsHRBaCfM9hOv0pH7cPPvFJ0hIIJE4HEO8JPV7JtI3UAoUnozzPmEfF8YbU7OuCqDhthQRx3swGr2xukYaj+utYYrBmOjKOeu9hQ3fmYdP/aOolU58Pa7YeKRah2TkgUKtcakANsxv3rDRq5vsRYXQhrixKlLQAuHsrIR0Lpzab44F5Uais4vFxpB6gltj1vgWChbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pf+ryCg2XXUD1GR/VhHtT1pMnYPXvTZxnwx7Zt06oG4=;
 b=iZ+pditNx81pa9RuCW61u40PicZ9Nry/2WsT6H3YXOOkLF/NvU3asXLDXcKc4mZk3HsMkx4C1cSNXn9juGrVAw7+QxxOy2eTlQxki9ihB+4hbFhTMsVsZJLBhXtQzELo8bKr2vlxYus9X3x9ZiTpmf1/11qgyC8OyG6agmQrxd7UDL0mYc8iXyzxM4CpECJJDK5FXf5JPq8h8gQhVQ5NOgtKEdOkHo1CO6MHLtue8twMIBlxkEo5zH4+A0qvUG5uffLrVitbd057obVkMzM3H6mI7R0c1N+9AKaikcGl6EkrqYu+FBwIDQPCMfDlKmG46PDLcpSxmw+he40BAc2L9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN8PR15MB3457.namprd15.prod.outlook.com (2603:10b6:408:a3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.21; Wed, 15 Jun
 2022 07:33:26 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::8198:e29e:552e:5b11]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::8198:e29e:552e:5b11%2]) with mapi id 15.20.5353.014; Wed, 15 Jun 2022
 07:33:25 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 5.19 2/3] Revert "io_uring: add buffer selection support
 to IORING_OP_NOP"
Thread-Topic: [PATCH 5.19 2/3] Revert "io_uring: add buffer selection support
 to IORING_OP_NOP"
Thread-Index: AQHYgA81JNhe2Gn0Kkiipbdj/ZZt5a1PNuGAgAABk4CAANvRAA==
Date:   Wed, 15 Jun 2022 07:33:25 +0000
Message-ID: <063bf37d245eddc309680bac4cfb10bea205dd3b.camel@fb.com>
References: <cover.1655224415.git.asml.silence@gmail.com>
         <c5012098ca6b51dfbdcb190f8c4e3c0bf1c965dc.1655224415.git.asml.silence@gmail.com>
         <477e92153bbfa3620c801dd58e8625281988ef49.camel@fb.com>
         <417f842f-0204-0f16-4355-edf7cc75dcaa@kernel.dk>
In-Reply-To: <417f842f-0204-0f16-4355-edf7cc75dcaa@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8d19846-59a7-4c3b-abed-08da4ea15586
x-ms-traffictypediagnostic: BN8PR15MB3457:EE_
x-microsoft-antispam-prvs: <BN8PR15MB3457F90D294D68106837B79DB6AD9@BN8PR15MB3457.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X9GKItZES+A+7jqQF07F/51VlKMY62fuA+yNSZ9StsTYvdfzqz+HD5bATZYQb0dxqFNZTQAx7XvpaynofF+fpBuFoqcahP5Z5jxHZm2sWVN+Z7ko1hd2CwMok6XQ1KWy2rUNGihtC1N0fVR3ZYKPUGTpNUecel3XkMp2lPmZldY7tNdE18yU6aAgnwMa5950wccIyzNl+ww5JiuZCnp9wDgCBEn/S4RmLtUlwtRN5BNEt6fHi+0rqQ9rTQ/o1soz7Nd3W67DToRe/PDknbcGtLHxVQVmDLa9Uto+h6dR3eCQ0HTpej1nutq5DnWgHEtcG2jFUMpkTa4Jk7V8hMOw9r77Ald8gChJ+3dLmMHzz5293CruNXjX9K4VhAMesylCFw2Hbv+gOsF5PZNPr+hrtOtNasyiuL0SwVMqCxS2zQvesRH44ws3VBBZbIEpLTE3YSq1BrP+cO3elbFIrFcIIGk9B+neO0gQdUTCs2Pu+1AubhDME7Z0kL8coj36BfSCU19WwUeTZFz19qj7WuTOSa36AUQXY9Tw8I10bebTcZKBkOd2jIFGcm3Vmlsh+h1CIGKL8IoexX4yGBwWQD6IdI1ouONI+KHagkzhZ4uZ76i8g5Q1og9oqfscV2U/oZinoTJ0+SmEF1feKpR+7LNOTPMnNsIaNAU4mg8VnnaIOZB7tUaWzA4bWQbOSqHpOsODpeWIinmddA8DRCgqberLpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8936002)(76116006)(508600001)(8676002)(66446008)(64756008)(6486002)(316002)(122000001)(38070700005)(66556008)(5660300002)(2616005)(91956017)(66946007)(110136005)(36756003)(86362001)(71200400001)(6506007)(66476007)(38100700002)(6512007)(26005)(53546011)(186003)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ulk0dFN6RWVJTTNBKy9uYW0vNmg1STk4eE5FSXEwTGwzcEdjZ295Vng1VTFB?=
 =?utf-8?B?cDFrSjczTWJ6VVdmMlJCcTdtbE9id2gyck91MFovOXRDSVpXUlpMdlJVRlZi?=
 =?utf-8?B?djZ5MDBFSFl1V1Z5dG9JNTZPZDVDWm9EWFp1cjJWTTQvdDl6eWt5Q1FuZTlS?=
 =?utf-8?B?clVsN2tvd1d0dHZOb2c1R0tWWkxRWlIya1VYWDVlWXBFVXQ2dWpRczhMODV3?=
 =?utf-8?B?aEtSSWxMOUdUWjJtQXd3SnF6RWYwUmo1TjNJazNSTlM1WXdDTlRnM2hIT0tl?=
 =?utf-8?B?a2p3Q3BBVk9jdkQ0ZWFwVnZvaDY4QW5ZQmwySnd0UkkyMkE4QXh5TFdmd0VB?=
 =?utf-8?B?dnE5MWM5eitQQnErQ2Q4bllLVWVKclMwd0VENDhDZ0RVbkZYWUNwOHpaQ09x?=
 =?utf-8?B?NStpYURrWEF6TFR0MmtibWc2VngrTDdlbncwS2FvRER0cE1lRTA5bVh1b0Nu?=
 =?utf-8?B?eU9tOWp4ZC9NdWpWbjZNWFhtOUorRFE3TDhyWW9DUzE4V05NRmZwY25yVkFV?=
 =?utf-8?B?SGVkWkNTQ1g0eHpua2pQN3hmbkY2UTArYnFpbUtLRUZkd2RRUzdBNG12cUQx?=
 =?utf-8?B?cHg5cDJPWkNoRGVnQ2VMS3pvTE1McmROdkthN3NKYTB3WWFJc3BPQUN5Wm85?=
 =?utf-8?B?TUw5Z3NmYmgyQk5TcGlwZFZqcjhTRi9HOHZRS1ZUcWhKcXNXaSt1T0xFbHJN?=
 =?utf-8?B?QllvN2xjVVpVandOVWpmTkxoTnJqQkdiRU8vNnNkaFJhdURmUTQ5RU01b2R2?=
 =?utf-8?B?RkpkbnEwZXJzZ3pobjFOQ0dNdzE4RFNQVUh6ZXRiTS9kdTlXbHpuU0JLZVZV?=
 =?utf-8?B?eEhMbzBobzBzSEdua3RJUUVMd0FTd2hSeU1QWmhjYmRDWHV1a2lBY0xkYzQz?=
 =?utf-8?B?VlFDUmJ1dmtqTG9CZzFmR2VzdXFEY3BRcmtEaWhRcEQ5eG9LOXJseWhWazBs?=
 =?utf-8?B?QzJ5SVBxNWFqU3MvUUlRRGYvOUpUZHJFcVFCR1Y5eTZOVDJWclNRMXl0MGJv?=
 =?utf-8?B?SXFVdFBoVU4rOFQ3QzNwRklMQzlqRTBaTVZBOGlFSGx3UE0yeVkzbi9sTml5?=
 =?utf-8?B?QUZWN0grVmU1VHJ3cWkrY0FteWs5WDNSOERaZVBhclBrd0RTcHpraFhpVkhr?=
 =?utf-8?B?V1R4NHl3VXNma2lqdWx0QjNxWUl0ZGs3ZWIwQVdRT0plOHZZdjVuTVl6R0hF?=
 =?utf-8?B?SW44aGtNZ2hWMEZQWUxNYTFBR0NxaDBNeHM1YnRTMFJrOEx6UEJBdGxSSmdS?=
 =?utf-8?B?VGtkdWlUTm5QQllZZUoyb3FFbnRzNm5yTGtBT3RLbEJGUU9GTHZDU3k0S0FW?=
 =?utf-8?B?Z3JaR2dvd0tOTFcwQTREcStaZ214am9GcUtRZ3hLQmxTajMvaG9RODlJVS9o?=
 =?utf-8?B?L0RaUjZVWXVVd0N1TEhkQzRUVEpWdXhsNS9DODNVbldJWDhtWWxMbVRlZFNW?=
 =?utf-8?B?RkRlNXJZUVA1c0tTVWcvMDVWc3VUV1BsVWlvTVNwZElNVnJ5ejRXQ2xnV0ZU?=
 =?utf-8?B?N2NNNG9PQ2ozdlhLamVpUkFzM1o4amMrbmhWR2pGQ2dvYWx2dThwUTRMb08w?=
 =?utf-8?B?NVRjaDJHZkh5NnExeGF2aTA3YU5ZMmlycHREYkdKUUNkVnpkZ0M1dCtHdWpW?=
 =?utf-8?B?bERhT21IY3B6V2E1Mkcwa3JPL1Z3TG4yRDBPSGtxTmcrRjkvVW14V1BTOXZN?=
 =?utf-8?B?KzdIOUpyUWkweEwvb2pRVm9IT3NkbzlCeTZwRld0NHI4ZkFwZnBBbUgydnc0?=
 =?utf-8?B?a1A1UWhGZmh3eXRZVXBHUzlCdExBSVhlOUkxRHlGdVZCNmlBYWR4VXRQK2FB?=
 =?utf-8?B?d05xRy8wTHljcHI4R1dCci93L3owR1NYWHlHb2xUVERPNmdiaWtFaDdmUzBo?=
 =?utf-8?B?ZHRCM1BDbTVsd0w5YStVL21WbzhKcE5TRGpNS1BmVGNScm83QnhSYzkvQVk2?=
 =?utf-8?B?ak9IcEd0c25HTzQvYU5pQURFTjRxVFBhQ1hLbDlwSVk0dzhGTWgrTC8zc3pB?=
 =?utf-8?B?M3J6ZVcrbXlFaDNCZFRLYzdla3Q5ZVhVQm9zdzZ4Tlk2MVA1cnAwWXFwcGY4?=
 =?utf-8?B?WUUxN0luSW1YRjRWbTEwVFFqSGwwU0p5UmlBT1ZGRzNxQ3J6WXhXeEtyZ2FT?=
 =?utf-8?B?LzZDalFNNjM3WVI2Qkg5azRBUWkxZkZvdGIxRWhmSjVHblpMczFtZDZ5V0F3?=
 =?utf-8?B?anFubWZxN2xVSUlnZCsyZzR4UjIyWC9FN2JpdzVpZ2FoTzlQVWJZdW9RNUVX?=
 =?utf-8?B?R3k2VnZVdVJCU0lTYXR6UHdhTys2QjgvNi9EYnRLQ2VoRlc4d1dSdGs0TFFm?=
 =?utf-8?B?ZFlvTzVseXpsNjd3R1NNU1M5L0JIZGRhU2ZwaWczMjhNcWlIRXF6Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <606918008EFB8C4AB27A9E9976C25BD8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d19846-59a7-4c3b-abed-08da4ea15586
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 07:33:25.7780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KR04fapCFLHIUMPA7LXpYwDy6ro+5TaQcz/Lbg6kuHMCaF97CpvhgUtzumZbpt4V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3457
X-Proofpoint-ORIG-GUID: PdQ1Pj9nyvnCsxAVt4Qg5z4jn7mYKp8n
X-Proofpoint-GUID: PdQ1Pj9nyvnCsxAVt4Qg5z4jn7mYKp8n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTE0IGF0IDEyOjI2IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IE9u
IDYvMTQvMjIgMTI6MjEgUE0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6Cj4gPiBPbiBUdWUsIDIwMjIt
MDYtMTQgYXQgMTc6NTEgKzAxMDAsIFBhdmVsIEJlZ3Vua292IHdyb3RlOgo+ID4gPiBUaGlzIHJl
dmVydHMgY29tbWl0IDNkMjAwMjQyYTZjOTY4YWYzMjE5MTNiNjM1ZmM0MDE0YjIzOGNiYTQuCj4g
PiA+IAo+ID4gPiBCdWZmZXIgc2VsZWN0aW9uIHdpdGggbm9wcyB3YXMgdXNlZCBmb3IgZGVidWdn
aW5nIGFuZAo+ID4gPiBiZW5jaG1hcmtpbmcKPiA+ID4gYnV0Cj4gPiA+IGlzIHVzZWxlc3MgaW4g
cmVhbCBsaWZlLiBMZXQncyByZXZlcnQgaXQgYmVmb3JlIGl0J3MgcmVsZWFzZWQuCj4gPiA+IAo+
ID4gPiBTaWduZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNv
bT4KPiA+ID4gLS0tCj4gPiA+IMKgZnMvaW9fdXJpbmcuYyB8IDE1ICstLS0tLS0tLS0tLS0tLQo+
ID4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMTQgZGVsZXRpb25zKC0pCj4g
PiA+IAo+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMKPiA+
ID4gaW5kZXggYmY1NTZmNzdkNGFiLi4xYjk1YzY3NTBhODEgMTAwNjQ0Cj4gPiA+IC0tLSBhL2Zz
L2lvX3VyaW5nLmMKPiA+ID4gKysrIGIvZnMvaW9fdXJpbmcuYwo+ID4gPiBAQCAtMTExNCw3ICsx
MTE0LDYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpb19vcF9kZWYgaW9fb3BfZGVmc1tdCj4gPiA+
ID0gewo+ID4gPiDCoMKgwqDCoMKgwqDCoCBbSU9SSU5HX09QX05PUF0gPSB7Cj4gPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAuYXVkaXRfc2tpcMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCA9IDEsCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAuaW9wb2xswqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPSAxLAo+ID4gPiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAuYnVmZmVyX3NlbGVjdMKgwqDCoMKgwqDCoMKgwqDCoCA9IDEsCj4gPiA+
IMKgwqDCoMKgwqDCoMKgIH0sCj4gPiA+IMKgwqDCoMKgwqDCoMKgIFtJT1JJTkdfT1BfUkVBRFZd
ID0gewo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLm5lZWRzX2ZpbGXCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgPSAxLAo+ID4gPiBAQCAtNTI2OSwxOSArNTI2OCw3IEBAIHN0
YXRpYyBpbnQgaW9fbm9wX3ByZXAoc3RydWN0IGlvX2tpb2NiCj4gPiA+ICpyZXEsCj4gPiA+IGNv
bnN0IHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSkKPiA+ID4gwqAgKi8KPiA+ID4gwqBzdGF0aWMg
aW50IGlvX25vcChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50Cj4gPiA+IGlzc3Vl
X2ZsYWdzKQo+ID4gPiDCoHsKPiA+ID4gLcKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgY2ZsYWdz
Owo+ID4gPiAtwqDCoMKgwqDCoMKgIHZvaWQgX191c2VyICpidWY7Cj4gPiA+IC0KPiA+ID4gLcKg
wqDCoMKgwqDCoCBpZiAocmVxLT5mbGFncyAmIFJFUV9GX0JVRkZFUl9TRUxFQ1QpIHsKPiA+ID4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZV90IGxlbiA9IDE7Cj4gPiA+IC0KPiA+
ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnVmID0gaW9fYnVmZmVyX3NlbGVjdChy
ZXEsICZsZW4sIGlzc3VlX2ZsYWdzKTsKPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaWYgKCFidWYpCj4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gLUVOT0JVRlM7Cj4gPiA+IC3CoMKgwqDCoMKgwqAgfQo+ID4gPiAtCj4g
PiA+IC3CoMKgwqDCoMKgwqAgY2ZsYWdzID0gaW9fcHV0X2tidWYocmVxLCBpc3N1ZV9mbGFncyk7
Cj4gPiA+IC3CoMKgwqDCoMKgwqAgX19pb19yZXFfY29tcGxldGUocmVxLCBpc3N1ZV9mbGFncywg
MCwgY2ZsYWdzKTsKPiA+ID4gK8KgwqDCoMKgwqDCoCBfX2lvX3JlcV9jb21wbGV0ZShyZXEsIGlz
c3VlX2ZsYWdzLCAwLCAwKTsKPiA+ID4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4gPiA+IMKg
fQo+ID4gPiDCoAo+ID4gCj4gPiBUaGUgbGlidXJpbmcgdGVzdCBjYXNlIEkgYWRkZWQgaW4gImJ1
Zi1yaW5nOiBhZGQgdGVzdHMgdGhhdCBjeWNsZQo+ID4gdGhyb3VnaCB0aGUgcHJvdmlkZWQgYnVm
ZmVyIHJpbmciIHJlbGllcyBvbiB0aGlzLgo+IAo+IEdvb2QgcG9pbnQuCj4gCj4gPiBJIGRvbid0
IG1pbmQgZWl0aGVyIHdheSBpZiB0aGlzIGlzIGtlcHQgb3IgdGhhdCBsaWJ1cmluZyBwYXRjaCBp
cwo+ID4gcmV2ZXJ0ZWQsIGJ1dCBpdCBzaG91bGQgYmUgY29uc2lzdGVudC4gV2hhdCBkbyB5b3Ug
dGhpbms/Cj4gCj4gSXQgd2FzIHVzZWZ1bCBmb3IgYmVuY2htYXJraW5nIGFzIHdlbGwsIGJ1dCBp
dCdkIGJlIGEgdHJpdmlhbCBwYXRjaAo+IHRvCj4gZG8gZm9yIHRhcmdldGVkIHRlc3RpbmcuCj4g
Cj4gSSdtIGZpbmUgd2l0aCBraWxsaW5nIGl0LCBidXQgY2FuIGFsc28gYmUgcGVyc3VhZGVkIG5v
dCB0byA7LSkKPiAKCkkgZ3Vlc3MgaXQncyBiZXR0ZXIgdG8ga2lsbCB0aGUgbGlidXJpbmcgdGVz
dCB3aGljaCBjYW4gYWx3YXlzIGJlIG1hZGUKdG8gd29yayB3aXRoIHNvbWV0aGluZyBvdGhlciB0
aGFuIE5PUCwgdGhhbiBrZWVwaW5nIGNvZGUgaW4gdGhlIGtlcm5lbApqdXN0IGZvciBhIGxpYnVy
aW5nIHRlc3QuLgoKSSBjYW4gc2VuZCBhIHJldmVydCBub3cK
