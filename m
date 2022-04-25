Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4413B50E17A
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 15:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbiDYNYb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 09:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiDYNY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 09:24:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168802DCD
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 06:21:23 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23ONEItG017768
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 06:21:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/KfJlHd20rlW1vHJher6tjLqiZr4n2ETQstHiPdj6L4=;
 b=ZdmNQAF0cFH3n8XMgM5H9+I/L0gl72BvaT/ouIzgUyfkWumZTgDyq1qIe4lX56GJw/fi
 8YW8twYzOc6te7pAL5LH4tn9KWETUvNlVZsmGnz0wgbpK+SpVOlAEkJh5sTnz11o5nE1
 Bt+vw8Vp2rywu5jYDlyO5j7die1T4BWw8HI= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmf5f1uaq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 06:21:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4eXy6FywPEtALQkjB3vcfog4WAeSNR9Zom35fd+s1QskNBXpQrjGNoOtsGRM6tHzyL/dVF9n1iNVyEpkA74PSS359jxRLTuxcQz/Gl8MdESRcBHgLAvByYPH88Dua43T35wADe5itC+Yu8lYthcyd/neJMHJBetjxDdyrgru6/zxFRsuPrjYiKWZpaCHs25KykTBqR4N8l5U18s76d1GbbnMsx7E74T236tnf5ExIH0dRfbUrMwQT1zgjEYWYzJLu4JS20aTguJKVS/r+nd/5BGGPmLWeADvl3HrnIbK043v15FeqfR0eL7hrybeogk5vv5Y+SYF+2TVAxhFu9Jyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KfJlHd20rlW1vHJher6tjLqiZr4n2ETQstHiPdj6L4=;
 b=OhVkql/6uBdFQq0PWH3xYxsaq5g1n6ZBJ7a9sqyQXQzQa08PevRBBx3J50/cnKz8L1Xbb1n8YExhSf7N/sllppMtHEVMIc9m+GJiS0W6eaMUjaQaVf7B/Z3Y25MlH9eLGqu80quRH+udIJgE5XWYd/8sjoVEBkNkvrAJZtGXx129PG6KLupWPlnBLAtVLvS0rKPOdOzzJFEBGiKvn+1Xq3+ncyh4Pc5OLMLrDm55TYpV2OskqFwXC7/1/iajf2daiiSAIdfZiJzWLolraBXAqgiMgq+IZFeU/ojdVvlv8wxDETJ81XSw5spCNzJz1oKGXOqttzN1cFNr0cT1KQoarA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BYAPR15MB2982.namprd15.prod.outlook.com (2603:10b6:a03:f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Mon, 25 Apr
 2022 13:21:19 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d%2]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 13:21:19 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH 1/3] io_uring: add io_uring_get_opcode
Thread-Topic: [PATCH 1/3] io_uring: add io_uring_get_opcode
Thread-Index: AQHYWIf2TU2fqKFuJ0iNrCitkEU7Xq0AkbSAgAAL7QA=
Date:   Mon, 25 Apr 2022 13:21:19 +0000
Message-ID: <911a8804fbaa3a564214971e9a3e5b19ddd227db.camel@fb.com>
References: <20220425093613.669493-1-dylany@fb.com>
         <20220425093613.669493-2-dylany@fb.com>
         <5e09c3ea-8d72-5984-8c9e-9eec14567393@kernel.dk>
In-Reply-To: <5e09c3ea-8d72-5984-8c9e-9eec14567393@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbe05e8b-699b-43da-e08d-08da26be7c2e
x-ms-traffictypediagnostic: BYAPR15MB2982:EE_
x-microsoft-antispam-prvs: <BYAPR15MB2982BF53C36494A4D8D37632B6F89@BYAPR15MB2982.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 93kyf0l3Xz00uRoEFiXj/duZNuhikxp7wBqFW8aSweYZdAcbofhKlv5vxhfbtw4vyF8H6wQQCXNyVs02OIBBrTmKZEUubhL2sdDEjgkmFBWHEN5/qv1NvuCsE44qRKqaSGYFqkmE6hcmbXZMiB3SbyVwi2rqQmVPBpsj+wN7q4qxz/QbOF6e3DwMePvWkXGKz+wFBk0vzFYLieg/jCCjZ7V+4dLNPpdiAEgwgStjHM8b7+GY5EFuwLZxUnMIl0ikTwVaxr2BepGoYY+8tZ26+yLK/nhGFZlF+A1FxUtvH3tzOIJUaTCviKaaPAd1N8Htt9KW+806LgBCYSTGuAnu9YZIPPJh7SXTwoJrI0tQaEc8Z7ysWuDf30j8btG2pDLU9x+xvUyFCu3sMwz4dmKryAy0VWLQzUjJk4X15m/v1XwFyo/mr6IvFRGWSnOSvsjgSr0ZcMn/c2NP+z/fE1yi7Co//pclzgQ+y7iirIpCfikVN24/1D0+l11no2ZW44IXjFwUuSmnTgXVEBK85nczPNqHKcmAFB/1Wx9JGS1mWS6R4HA9izdpxtFfgvDZEEegprrtZujKgZjBf+r+Tfa7m2IEpPdwfoVO5v/WTs5fsw77eyaVDgn/JnOzrlfZrbullGyl5lmcUBpNFZtHKPc3UzqJ5Ci+b4kIX1qJX9rk0L6VPsd1jI6+pRQE5hRBeyoyDPnc2mw+jabWV9sDiv9bxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(186003)(53546011)(86362001)(122000001)(8936002)(4326008)(8676002)(36756003)(2906002)(5660300002)(91956017)(76116006)(66476007)(6512007)(508600001)(6506007)(66946007)(66446008)(64756008)(316002)(66556008)(38070700005)(38100700002)(71200400001)(110136005)(54906003)(6486002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEVjeDBaOVdFUjFLaUFpd0pwcFcvN0FSQlovU3FyYngwd2UxUWJuN285TkV0?=
 =?utf-8?B?TzF1THpDWUZ0bUg1SmVPWHMvS2NQUmpiTkJEU1c4SXRhVmpOem1IT0xVVXpR?=
 =?utf-8?B?UTZFSVcxOVhuMmxmM0ptMGs1ZC9YbUp4SWNXSmIyVG1nTDVRRkw2M3Y3L3RK?=
 =?utf-8?B?S2V1cEErdXgxb0tlUWZrdW43TVQ2V2xrakdtSDZjWXA0MWZFMGhCK3ZqWGJN?=
 =?utf-8?B?QWVDN2syWkc1bGFjbG5HQXk4d2NDU1ZXN3lIM2ZkcWdYT1RNN1J4Si9BeEl1?=
 =?utf-8?B?YTZEb2pHdEZYUldiQ1RvZnRvRThEdzcvOUhiaUVjM1o2RndzMVNNdVo4Z3hW?=
 =?utf-8?B?azRzNkxZNVlPZ3JyN1Nha3ZiRUFrU2dmeXFSeVIwOUZhaCtMdHBJT281R3VV?=
 =?utf-8?B?cWFwUWtGdFJqTjF0WHcvN0JKOFJJV21OQmdKVDZMaVY1STRYeEI1Zml6VFIz?=
 =?utf-8?B?ZjRsVkZsdFEzTE5ZZVgzbzVSSXJWeUJzQlJTRTFpNGtNaTI3WTBLbjFoZ0or?=
 =?utf-8?B?QnM1OVIwaTNYSFBWQXd1S3VCdWxjUzRyMy9ETmgzVjFtSUNNaDZhUzRFdjRj?=
 =?utf-8?B?VFBwVi9HRXJHcWw4SThFUmRXckVRU2wwcVI1ODREV2N6RUVhU1pRNjB0Vm1H?=
 =?utf-8?B?bEk0ZXpCTVlBaEM5TGZrTWFVK3Q0c1ZkRUJoRllFV2pENjJsSlhlVGlZTk02?=
 =?utf-8?B?d0F5anhZeWNTNnRPQyswTVRPR2c5UVYrdldPRVZFbEhzRjFEMWY4NWs5bkov?=
 =?utf-8?B?T2dvU05xNnJ4dkZtTmQ1UE1XcEIrdHA0cWZyVGo2czFrSXI2S2lWS0JMbUZR?=
 =?utf-8?B?V1k5TTBPTUxwZ1lQS3ZsWFlHenpWM0hacUtyL2JrMkRRTisyQk1JVWE2bjcr?=
 =?utf-8?B?QzVxckxxdktGbFByL0xvRzZCV3VOTXpmY2NIVURZRVZ5RmtYT2JtdWp2UTQ4?=
 =?utf-8?B?Y2ZhQ0RlZ1ppSHVQdGIvank0U3NyRlg2d0xXSTFnNW94dTdEY21CTWs1RjRX?=
 =?utf-8?B?Y1QxSDE2eG5HMGpxOC9VNFQxS0pCT2RXbjJnT1pHYStGUEVaK2pFN0g2VnI3?=
 =?utf-8?B?RE1TVk1mMWEvWEdlQlkwVWhRbHl0QXc0clRUd0Q0MnlNMFVzQmZMa3FMamdj?=
 =?utf-8?B?N29FdUtMZk9MK2EwejNVbTQ0bm9HODZYSTFLUDByUmVFeloyb1BMOVNpMnBu?=
 =?utf-8?B?MzlpR01SaEFXSkEySUZpazlWVUJUQk9JL2ZRRzhzOUJlWU85dFVvekQySFUz?=
 =?utf-8?B?R0g1VDJ6UGJaWG5ZRkUvOEdiNHhVMXlLR0tRUkYrUW82YU9FMWFYaWtwT0M1?=
 =?utf-8?B?MTJ1WHVsOHpVUWxVdUtmdTlwSkI5ZU1FclEvYzhxNTRkVnh5QXJCa2Z0cUZs?=
 =?utf-8?B?ZURUV05oZ0FqOWhsaHVCVWw1bEdYWDhBRlZYZTcwUzltejYrb1BCVVBySklI?=
 =?utf-8?B?SFBEY1llK0pER1FvVTR5a1gxK0lmUW9wZElQNElNbkpxQno3TUNGVEhyTE8y?=
 =?utf-8?B?c05ZQ2dYZFhhTjRPMVJDV0JScDdJc3EzemJseU9RSUg4OWpKSnJDNjBncm9L?=
 =?utf-8?B?OSs2Z0hCbWpsNDRKQjUvd0ZkU2x3akk5WkZlMFFBdEI2YlJzRFlqZS8yYmZF?=
 =?utf-8?B?N2szYTNhQjQwWjUxUmRCaThnbEtJNGozczE1U0xuTXZ2bmZNVnBZWldPbU11?=
 =?utf-8?B?TFdueVZ4R0hzN2I1bWcwUjV2Zkh4ejFlYkFlZ01pMWRicTU2cnIvU3BqSExV?=
 =?utf-8?B?Z2V3c2NhQTk2ZkV5dmk2ckIyczBFUFdaUzkwb0RFem9WMUU5dk4yTXF3QlFm?=
 =?utf-8?B?UnhCdXVVcndpSDduNFRRZ3ZEWVUwZGZjQzFQVVJsVGxMK0ZnRldxanliV1lD?=
 =?utf-8?B?ei9QMXlnN0J5eVRyNU9ZbXU0T2pzSG1lMkxJVFk0SjZDOFRIQXFWRUp1Vkdq?=
 =?utf-8?B?cXQzV0tjMDd6dS9HaW9aSFNmOHN4ZndPb2tCWGhoYmZVbEg3WUFzYmRTOTRL?=
 =?utf-8?B?SDYvbU9oLzhFZ2cySzl6ZCtuanNZMHdCN1piRnVrcXBHRmhNcVJ4M3A1RkVm?=
 =?utf-8?B?YjdOZmxHd3hqM3EvNUVScEpPRFBMaVFEbXdpbTJ3MkVFb1NOR2kySW9NQUFC?=
 =?utf-8?B?WTdsemluY1dXUXNyTS91cnhYdUhFQmJ0OStaV0hac3Y1SkVhNkwySEhoU1pv?=
 =?utf-8?B?SjAzWWdDYWY3ZzM2NzJ1VG9YNGFPZ1JnaFFjZFJKdHdDYjNmMkR4b3plL3ZU?=
 =?utf-8?B?RDZGNE5HMWNYSll5KzhzeTkzOFJkOEZhZ2NpVXJvajIxQVVSUzZ2ZnBlZUtM?=
 =?utf-8?B?NlhCTnVsU3dhSXAzQTdaRDhPMGtOMU9iYUxkY2NWZTU1ZUFiejVXSjJHbXdx?=
 =?utf-8?Q?cw/MwPltAOyuCwnM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA7BEC11632A7B4B9D28536384DFC50F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe05e8b-699b-43da-e08d-08da26be7c2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 13:21:19.5122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F4iFkvJaCkNYBSckSzbXN5Tj+gD1mJPW5+vNHZYl/Dc8zXbImDTULrBf/h3wXVcY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2982
X-Proofpoint-GUID: ypVmhXWxMFv9_YAaIZ2uKn_FiEbRjuSB
X-Proofpoint-ORIG-GUID: ypVmhXWxMFv9_YAaIZ2uKn_FiEbRjuSB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA0LTI1IGF0IDA2OjM4IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IE9u
IDQvMjUvMjIgMzozNiBBTSwgRHlsYW4gWXVkYWtlbiB3cm90ZToKPiA+IEluIHNvbWUgZGVidWcg
c2NlbmFyaW9zIGl0IGlzIHVzZWZ1bCB0byBoYXZlIHRoZSB0ZXh0IHJlcHJlc2VudGF0aW9uCj4g
PiBvZgo+ID4gdGhlIG9wY29kZS4gQWRkIHRoaXMgZnVuY3Rpb24gaW4gcHJlcGFyYXRpb24uCj4g
PiAKPiA+IFNpZ25lZC1vZmYtYnk6IER5bGFuIFl1ZGFrZW4gPGR5bGFueUBmYi5jb20+Cj4gPiAt
LS0KPiA+IMKgZnMvaW9fdXJpbmcuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA5MQo+ID4gKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ID4gwqBpbmNsdWRlL2xpbnV4
L2lvX3VyaW5nLmggfMKgIDUgKysrCj4gPiDCoDIgZmlsZXMgY2hhbmdlZCwgOTYgaW5zZXJ0aW9u
cygrKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMK
PiA+IGluZGV4IGU1N2Q0N2EyMzY4Mi4uMzI2Njk1Zjc0YjkzIDEwMDY0NAo+ID4gLS0tIGEvZnMv
aW9fdXJpbmcuYwo+ID4gKysrIGIvZnMvaW9fdXJpbmcuYwo+ID4gQEAgLTEyNTUsNiArMTI1NSw5
NyBAQCBzdGF0aWMgc3RydWN0IGttZW1fY2FjaGUgKnJlcV9jYWNoZXA7Cj4gPiDCoAo+ID4gwqBz
dGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBpb191cmluZ19mb3BzOwo+ID4gwqAK
PiA+ICtjb25zdCBjaGFyICppb191cmluZ19nZXRfb3Bjb2RlKHU4IG9wY29kZSkKPiA+ICt7Cj4g
PiArwqDCoMKgwqDCoMKgwqBzd2l0Y2ggKG9wY29kZSkgewo+ID4gK8KgwqDCoMKgwqDCoMKgY2Fz
ZSBJT1JJTkdfT1BfTk9QOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biAiTk9QIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1JFQURWOgo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiUkVBRFYiOwo+ID4gK8KgwqDCoMKg
wqDCoMKgY2FzZSBJT1JJTkdfT1BfV1JJVEVWOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiAiV1JJVEVWIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09Q
X0ZTWU5DOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiRlNZTkMi
Owo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfUkVBRF9GSVhFRDoKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIlJFQURfRklYRUQiOwo+ID4gK8KgwqDC
oMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfV1JJVEVfRklYRUQ6Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuICJXUklURV9GSVhFRCI7Cj4gPiArwqDCoMKgwqDCoMKgwqBj
YXNlIElPUklOR19PUF9QT0xMX0FERDoKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gIlBPTExfQUREIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1BP
TExfUkVNT1ZFOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiUE9M
TF9SRU1PVkUiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfU1lOQ19GSUxFX1JB
TkdFOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiU1lOQ19GSUxF
X1JBTkdFIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1NFTkRNU0c6Cj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuICJTRU5ETVNHIjsKPiA+ICvCoMKg
wqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1JFQ1ZNU0c6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuICJSRUNWTVNHIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9S
SU5HX09QX1RJTUVPVVQ6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
ICJUSU1FT1VUIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1RJTUVPVVRfUkVN
T1ZFOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiVElNRU9VVF9S
RU1PVkUiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfQUNDRVBUOgo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiQUNDRVBUIjsKPiA+ICvCoMKgwqDC
oMKgwqDCoGNhc2UgSU9SSU5HX09QX0FTWU5DX0NBTkNFTDoKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gIkFTWU5DX0NBTkNFTCI7Cj4gPiArwqDCoMKgwqDCoMKgwqBj
YXNlIElPUklOR19PUF9MSU5LX1RJTUVPVVQ6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuICJMSU5LX1RJTUVPVVQiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJ
TkdfT1BfQ09OTkVDVDoKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
IkNPTk5FQ1QiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfRkFMTE9DQVRFOgo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiRkFMTE9DQVRFIjsKPiA+
ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX09QRU5BVDoKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIk9QRU5BVCI7Cj4gPiArwqDCoMKgwqDCoMKgwqBjYXNl
IElPUklOR19PUF9DTE9TRToKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gIkNMT1NFIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX0ZJTEVTX1VQREFU
RToKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIkZJTEVTX1VQREFU
RSI7Cj4gPiArwqDCoMKgwqDCoMKgwqBjYXNlIElPUklOR19PUF9TVEFUWDoKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIlNUQVRYIjsKPiA+ICvCoMKgwqDCoMKgwqDC
oGNhc2UgSU9SSU5HX09QX1JFQUQ6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuICJSRUFEIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1dSSVRFOgo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiV1JJVEUiOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfRkFEVklTRToKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gIkZBRFZJU0UiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJ
T1JJTkdfT1BfTUFEVklTRToKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gIk1BRFZJU0UiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfU0VORDoKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIlNFTkQiOwo+ID4gK8KgwqDC
oMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfUkVDVjoKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gIlJFQ1YiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1Bf
T1BFTkFUMjoKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIk9QRU5B
VDIiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfRVBPTExfQ1RMOgo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiRVBPTExfQ1RMIjsKPiA+ICvCoMKg
wqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1NQTElDRToKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gIlNQTElDRSI7Cj4gPiArwqDCoMKgwqDCoMKgwqBjYXNlIElPUklO
R19PUF9QUk9WSURFX0JVRkZFUlM6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuICJQUk9WSURFX0JVRkZFUlMiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdf
T1BfUkVNT1ZFX0JVRkZFUlM6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuICJSRU1PVkVfQlVGRkVSUyI7Cj4gPiArwqDCoMKgwqDCoMKgwqBjYXNlIElPUklOR19PUF9U
RUU6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuICJURUUiOwo+ID4g
K8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfU0hVVERPV046Cj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuICJTSFVURE9XTiI7Cj4gPiArwqDCoMKgwqDCoMKgwqBj
YXNlIElPUklOR19PUF9SRU5BTUVBVDoKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gIlJFTkFNRUFUIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX1VO
TElOS0FUOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAiVU5MSU5L
QVQiOwo+ID4gK8KgwqDCoMKgwqDCoMKgY2FzZSBJT1JJTkdfT1BfTUtESVJBVDoKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIk1LRElSQVQiOwo+ID4gK8KgwqDCoMKg
wqDCoMKgY2FzZSBJT1JJTkdfT1BfU1lNTElOS0FUOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiAiU1lNTElOS0FUIjsKPiA+ICvCoMKgwqDCoMKgwqDCoGNhc2UgSU9S
SU5HX09QX0xJTktBVDoKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
IkxJTktBVCI7Cj4gPiArwqDCoMKgwqDCoMKgwqBjYXNlIElPUklOR19PUF9NU0dfUklORzoKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gIk1TR19SSU5HIjsKPiA+ICvC
oMKgwqDCoMKgwqDCoGNhc2UgSU9SSU5HX09QX0xBU1Q6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuICJMQVNUIjsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiA+ICvCoMKg
wqDCoMKgwqDCoHJldHVybiAiVU5LTk9XTiI7Cj4gPiArfQo+IAo+IE15IG9ubHkgd29ycnkgaGVy
ZSBpcyB0aGF0IGl0J3MgYW5vdGhlciBwbGFjZSB0byB0b3VjaCB3aGVuIGFkZGluZyBhbgo+IG9w
Y29kZS4gSSdtIGFzc3VtaW5nIHRoZSBjb21waWxlciBkb2Vzbid0IHdhcm4gaWYgeW91J3JlIG1p
c3Npbmcgb25lCj4gc2luY2UgaXQncyBub3Qgc3Ryb25nbHkgdHlwZWQ/CgpJdCBkb2Vzbid0IGNv
bXBsYWluLCBidXQgd2UgY291bGQgc3Ryb25nbHkgdHlwZSBpdCB0byBnZXQgaXQgdG8/IEkKZG9u
J3QgdGhpbmsgaXQgd2lsbCBicmVhayBhbnl0aGluZyAoY2VydGFpbmx5IGRvZXMgbm90IGxvY2Fs
bHkpLiBXaGF0CmFib3V0IHNvbWV0aGluZyBsaWtlIHRoaXM6CgpkaWZmIC0tZ2l0IGEvZnMvaW9f
dXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMKaW5kZXggMzI2Njk1Zjc0YjkzLi45MGVjZDY1NmNjMTMg
MTAwNjQ0Ci0tLSBhL2ZzL2lvX3VyaW5nLmMKKysrIGIvZnMvaW9fdXJpbmcuYwpAQCAtMTI1Nyw3
ICsxMjU3LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMKaW9fdXJpbmdf
Zm9wczsKIAogY29uc3QgY2hhciAqaW9fdXJpbmdfZ2V0X29wY29kZSh1OCBvcGNvZGUpCiB7Ci0g
ICAgICAgc3dpdGNoIChvcGNvZGUpIHsKKyAgICAgICBzd2l0Y2ggKChlbnVtIGlvX3VyaW5nX29w
KW9wY29kZSkgewogICAgICAgIGNhc2UgSU9SSU5HX09QX05PUDoKICAgICAgICAgICAgICAgIHJl
dHVybiAiTk9QIjsKICAgICAgICBjYXNlIElPUklOR19PUF9SRUFEVjoKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oCmIvaW5jbHVkZS91YXBpL2xpbnV4L2lvX3VyaW5n
LmgKaW5kZXggOTgwZDgyZWIxOTZlLi5hMTBiMjE2ZWRlM2UgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC9pb191cmluZy5oCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5o
CkBAIC0xMDMsNyArMTAzLDcgQEAgZW51bSB7CiAjZGVmaW5lIElPUklOR19TRVRVUF9SX0RJU0FC
TEVEICAgICAgICAoMVUgPDwgNikgICAgICAgLyogc3RhcnQgd2l0aApyaW5nIGRpc2FibGVkICov
CiAjZGVmaW5lIElPUklOR19TRVRVUF9TVUJNSVRfQUxMICAgICAgICAoMVUgPDwgNykgICAgICAg
LyogY29udGludWUKc3VibWl0IG9uIGVycm9yICovCiAKLWVudW0geworZW51bSBpb191cmluZ19v
cCB7CiAgICAgICAgSU9SSU5HX09QX05PUCwKICAgICAgICBJT1JJTkdfT1BfUkVBRFYsCiAgICAg
ICAgSU9SSU5HX09QX1dSSVRFViwKCgo+IAo+IEluIGFueSBjYXNlLCB0aGUgTEFTVCBvbmUgaXMg
anVzdCBhIHNlbnRpbmVsLCBib3RoIHRoYXQgYW5kIGJleW9uZAo+IHNob3VsZCByZXR1cm4gZWcg
SU5WQUxJRC4KPiAKCldpbGwgZG8K
