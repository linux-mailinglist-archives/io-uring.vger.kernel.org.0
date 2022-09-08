Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9225B23C7
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 18:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiIHQnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 12:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIHQnS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 12:43:18 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DBB1203C6
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 09:43:18 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2886cMWa023564
        for <io-uring@vger.kernel.org>; Thu, 8 Sep 2022 09:43:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2igCHivh8+I5v8Lzd2p+Tx+rE818hGt7AO2zGHB+8TY=;
 b=HvMVg4ELxZNpbGUfzSmOXfx15AV+YLXFjCWRRM5yRd5V1uEarK/J/kLR0K+q+VIDAwkz
 XTLYP3wgXXSVtDxevajSjjtnx2N1q5X89OrO17A+n+Rw8Ci0tjX1LGXV2EB/57KKWqub
 Z2X0vqRpEB/fRTKSryW5mOfWawVZWRetvg8= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jet8mhtk9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 09:43:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvyTTXrjxyZT8aZdabyX2RRJI1CZQTtT1iQjpR8CVYa865t5kVJA02g2V3+Z4+H8e1TmINKDxjA/WfAuhWY0F32rS1KqgIL4A/n+oOWng4FDwPSaQxK5MIzgqCoHFvEfLws6eBMTxN5ax/AAv0cK/5xtQnL/qYzwQ8k1e3kRLnt50jkLqSGOO46bKZE2BboVlny4l9WAuh0RjaAploLTswys4bswVgEFk5+9Anv9DVxo8hkgIroW8km+mlJqJaTNgExkR0TGBiZT9bJS6DkPJvuu61cyww8vtyLtySLeldEtfPlWN+2fow1ch0vo1ROQRxoKkyoOltzltPGEEIjBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2igCHivh8+I5v8Lzd2p+Tx+rE818hGt7AO2zGHB+8TY=;
 b=EqjwynKRezRz/rtmv36VVgS9XMHL65vyzRjf8yncAUZ1v294r7yTztN06gSmSD3jtn/30c5b/Q3pPQcI1UHLFkoFKZxwktQO0qpFfjH9YK/RCVG+BFs0pdgrp6qOPODb9P0W38kcJ2i8PgfWu1rAXzbFVeSus+T3p2HveZFvMpmfNspNS4kbmPChHsjRa44mh2P1b+2lm/mW90ZgT1jKGWxEGgIHo46/khqT/VIfNg/elpd0nqaHh2j3OSIof/IXG2FleO5BkQxB34qTOfCz9CV7KVHUPZ0C3Y52NC/xw4zFUN3+uxOmz0k0/FaXLLtHxFgkL5XNI20dX3VE7UXs8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by PH7PR15MB5500.namprd15.prod.outlook.com (2603:10b6:510:1f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:43:15 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%6]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 16:43:14 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 2/6] io_uring: disallow defer-tw run w/ no submitters
Thread-Topic: [PATCH 2/6] io_uring: disallow defer-tw run w/ no submitters
Thread-Index: AQHYw5vrzqIAsZKs20ebbGRWqS+WUa3VvPUA
Date:   Thu, 8 Sep 2022 16:43:14 +0000
Message-ID: <25974c77ebf910875c85f97398dc7c9032812885.camel@fb.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
         <b4f0d3f14236d7059d08c5abe2661ef0b78b5528.1662652536.git.asml.silence@gmail.com>
In-Reply-To: <b4f0d3f14236d7059d08c5abe2661ef0b78b5528.1662652536.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|PH7PR15MB5500:EE_
x-ms-office365-filtering-correlation-id: bed9d4a5-67d8-40fe-6a24-08da91b939b4
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YrvfryRy/rMBHzASBejQvSAJRI+7FKqrBfQj/NVkL3QPb23YDml3WBBnS28BxUqu0fYGs2Ub/v825KSn+iCTnovaBXePUi6m58yHuQ7yOp2w1JsO8m2qaE5VgTNjNhQiOEecSzLQPV/hqTbcIjMsU+qOgtk7wrsaFiiLlWhKaF4ovPyPyVyH/wH70A8rGit2CLwYjbV7mBKfX42ySjaBh009b1pXHLD8pQbnHz8P+jVxhqbJVQ5uvtbpI/fvI6bua75Au7lwWXMDTelclFRvrLk2uRaFBtSneQPkxo1a1RQC34NWbRTl7EWp8naVR3PhhcP4/cRgNM2fmdI5vh6mzLZOUFO3i07D9P2LWNjYpUozCje1biK6a45mtiYjZEgMIeO0tGsuGA9LQo0XhUC5X2M4g+3LXpE7Ev5ykI6PWhvKSC9iN4t4Rq9g9nOUhoXSYrVE4/Y7jWAyaqBIooNC6UFMOa8qHV2APoxYeOQ8zRolwoqg19qYqh5qoRg6Cs5sPZVEHQa94htDkmSnhODcbTmXFuROPOrGvScr6FLLVVru1o0keQO7wlJxREzwSL40K84EUj0hg7nxytcI+mtxkk6Gy2h8m0Vz1iDuiTJnXYDVs0BEf3qK4j4TYNj89T3u+wN/u4+BWlh5JqrLIbMiUVqCvo01IUzHqmnX03nHYBsrU3qsXwsST74Fiq7qnhcocEyoP3+Xhbm9eSCAa3eKMbT5Tur8TofVthYotMO6R98jPUXO61VAP98hvJDLWsldjaHmYqDrLGr6PNpC3gSPjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(478600001)(316002)(110136005)(6506007)(6512007)(26005)(38070700005)(8936002)(36756003)(2906002)(4744005)(86362001)(5660300002)(64756008)(122000001)(66476007)(76116006)(66446008)(66946007)(66556008)(4326008)(83380400001)(8676002)(186003)(41300700001)(71200400001)(91956017)(2616005)(38100700002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzFnWTU4cnBKMi9DK1dXQTBiYS9ldnVFRUs2L0FMWEpVU1ZiR2RLdktybVhY?=
 =?utf-8?B?ZnRsZEN4cnBhMmZ3SmU5REtDYVN3aFB1dnRQSXNGaHhlWHFZVnF6dTg0NU1G?=
 =?utf-8?B?MGFOdSt6QjlQL3ZJMmZyM0NuemFmcUFoRWFXVEFMeU1zQ1pBVCtCS3ZLUy9Z?=
 =?utf-8?B?bDF0OHllMzRjRStrNjk3Sk9mM1J6RlEwYUtBMUtzYXhDTytJcVB1SkMza2tm?=
 =?utf-8?B?K0lON3l2bVJtY3VnUHNvbVhuZWFEYWg1dkdxd0c4eVdiM3JyVnZqbGZrQW9y?=
 =?utf-8?B?L1hsMFhocXBJRFh4UkN2ZklULzZGYUZkTk1tMmtIVUtCSVdDQjc5M3hKNmJB?=
 =?utf-8?B?QTh2SkVUUzVvcWNXTVZiWUlLeUZhZ0Q2djhNYXloMXIrNUc2T2FHUXBpK3pu?=
 =?utf-8?B?VytrOEZqRGgxaHpsOTdNODJlWXlPajljbmRQZnYzRmdUUHMxWTl1LzFGSVp1?=
 =?utf-8?B?NnA2eGR2ZFNnRU4xQ3d4bVVwdGhNaitUTDNYVnIzN3lmdXBJMnVDWHJ1dEdP?=
 =?utf-8?B?N3dFVjRoMElPRkJScWt4Zk9scEd4YStSYXc2TFhiQi9qRDI5L0RZL1F4ZEw4?=
 =?utf-8?B?YjhWcTRna0hQRjZGbDdtaGRLVVFwcVVPcys1VHI3dUdRaXcvMDZPaG45SmRy?=
 =?utf-8?B?cXo1Y1preFI2Vy8yY3VnQmx1NHRza0RnamZScFBiUHZRTFluMnB6YkdGalgy?=
 =?utf-8?B?T05CVXdzWDZDUHRjdWt5MTZMU1pLc0JKSlNBZXc1Q1ptUDhRR3AxZGxsRjVi?=
 =?utf-8?B?aWoyUlAzbzR1cHVDMFJveUZZUndoL0RGVUg1VWFKUVE4WXVOcFk3dFRXUFp6?=
 =?utf-8?B?eDRoREgzV3VLdlU4dTUxNWNMVllRMjhFcFR3K29NV29DbnBGcEJyZ1pCMDFk?=
 =?utf-8?B?MGlJbVQ3U2srVlEzRmI0ODZNYzlPYlF1NU5UWmhEdERuRXpkWGpJdVFMWTBk?=
 =?utf-8?B?MlhZZG1xdytyZUhQM25CdWRKRTFybjFOdFNIeEhIWTcrT0VtZFJHbyt0S1FI?=
 =?utf-8?B?UE1rdG1PWCtlY2hVeTlXL0RHK1dmRkpsdEg4N1dWM2hwUFdJZ1MrRDIxZ0Vs?=
 =?utf-8?B?TVJLVXorSTlCWmtPbHBOS0JSZVVsUk84TWltZi9qU3JCakJXQWcxZDRyZHEx?=
 =?utf-8?B?TDROM1Jtb2pzNlprd0tncm55bXU2Y0JVWjV4d3lCdE1nMXB4UUxHQ1dtN3g1?=
 =?utf-8?B?Q0FmTDVFdG5OU00ra1R5Rll5dlRYVkRBbVE4cWVPbWNVUkp0dno5ejFrQ3Jp?=
 =?utf-8?B?bVg2VFRTUTVyNnlXTGFNbDZHbjV0dGN3Y2IvRkJ5c01Va0wrNDU3NHkrMEZI?=
 =?utf-8?B?VUpUUURwTVRXcTdnZUdGMzZlTDZLZ2dkWnVabEtNcGFIT0pJajl6WjNnbWZY?=
 =?utf-8?B?Ym5wU2dhdnNhMHgxWC9sRVRxWmhBTlYyTkpuV2hqN2UrQzA0KzRHQzUySlJy?=
 =?utf-8?B?OVhIeDRpeTVnRlVtS0dMNmpIRmZLSVh1VlJtVFRqY1dVQ3ZGUXdkd05sQ1FH?=
 =?utf-8?B?Sk5JVWhLZHRzdmI4cFNCNDFtc2xWNXFmSXQxSitDa0Z6NGV2RTU5Mld3cWlH?=
 =?utf-8?B?ei9Mak9SdUdDQlRIMGdMaDBkdjl2YUlwTHJaM1p3R1IyMXRMZEI4WlJGOWtY?=
 =?utf-8?B?b1VpQzBYY2NyOGU0Yll0OFh3LzBzQkNCSU82K05UTzBzcldraUw2WmJPMkpz?=
 =?utf-8?B?blJQaUduODRvRGp1N0VwMitTcVpiZmptSWJlYXJ4RWpCUFJYcE8rakx4L0R6?=
 =?utf-8?B?azNwVENYWlBpcXRVSEVDZ1FuOEo1MkNidDhuSWNleENhTzVxb3k1V3Q0N0JU?=
 =?utf-8?B?ZzhmZHJXYXFHQVhLbFN1REFUWHJTNnp5VjdHNmJ0c1R5NXBENDRoYThaUnpN?=
 =?utf-8?B?RVFiTzhXTlBCd1J2SkgzQk11TzdGWDRjRWtGanVscHdGOHNza2l1aVVsVVhN?=
 =?utf-8?B?NmNNaVcyV1BkY2NobUhEUmRLMmU4ZFFVSHl0VUZkR3NrbHQ4N05uZ292Tk02?=
 =?utf-8?B?cWpILytoaTRBZUNZYnMvZjM2TjN1SExObmhvSy9hRWsrdWlweXBjbFRWQnVx?=
 =?utf-8?B?MFU5Q25Oa3RtNUxDa0NSWjI3RklQL2NVUEZNNmRnOU5aaWwrcklSbEZsRktu?=
 =?utf-8?Q?iwJaifOTzCNasc/tQEEDl/ewe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAC1C45486B50F4390F1880EBE72A2BE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed9d4a5-67d8-40fe-6a24-08da91b939b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 16:43:14.9136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4qTE49T+UhWDFzM4ntcX6qAHhfQHcU0r7CUcq0ScSwrGhUGN+ssdplytBSSNUHeQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5500
X-Proofpoint-ORIG-GUID: yA-CuwHd9Bd_sB4e_bLOT1f3KJtcSwCA
X-Proofpoint-GUID: yA-CuwHd9Bd_sB4e_bLOT1f3KJtcSwCA
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

T24gVGh1LCAyMDIyLTA5LTA4IGF0IDE2OjU2ICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gV2UgdHJ5IHRvIHJlc3RyaWN0IENRIHdhaXRlcnMgd2hlbiBJT1JJTkdfU0VUVVBfREVGRVJf
VEFTS1JVTiBpcyBzZXQsDQo+IGJ1dCBpZiBub3RoaW5nIGhhcyBiZWVuIHN1Ym1pdHRlZCB5ZXQg
aXQnbGwgYWxsb3cgYW55IHdhaXRlciwgd2hpY2gNCj4gdmlvbGF0ZXMgdGhlIGNvbnRyYWN0Lg0K
PiANCj4gRml4ZXM6IGRhY2JiMzAxMDI2ODkgKCJpb191cmluZzogYWRkIElPUklOR19TRVRVUF9E
RUZFUl9UQVNLUlVOIikNCj4gU2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2ls
ZW5jZUBnbWFpbC5jb20+DQo+IC0tLQ0KPiDCoGlvX3VyaW5nL2lvX3VyaW5nLmMgfCA3ICstLS0t
LS0NCj4gwqBpb191cmluZy9pb191cmluZy5oIHwgOSArKy0tLS0tLS0NCj4gwqAyIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pDQo+IA0KDQpSZXZpZXdlZC1i
eTogRHlsYW4gWXVkYWtlbiA8ZHlsYW55QGZiLmNvbT4NCg==
