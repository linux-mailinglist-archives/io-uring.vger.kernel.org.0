Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AAE557E5C
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiFWO7V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 10:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiFWO7U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 10:59:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475DB5F73
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 07:59:20 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25N0weYC023588
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 07:59:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CKNWLS5xJwiL4vp9srU273EvqyNRUGAHRAl0PirRakY=;
 b=YvwN65YXENu5GrNLIqGSR/amkz+qU0hpgKnCZ/pz+ggP5wGHgCdi1KsyWk9JdWlFflqI
 IsfrvfSdMx+Is3TooI9lU6arxzuaRD8W63biRAFxcqCTyPPdN/KSCk7dmctmDjS15ljB
 JTwO9KO2XZ7rBaDc1aBvws2BT0JnUi/F3NI= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gv2naresm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 07:59:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZTAiFyJQZ4IsPqGAv7+uK6nJu5HwRbYoFr9x8cZymecwTTcQS7WvZ0D43ghepbqVhu3xMqZ9FaVnK/ZcG+WuND8yB6z5ojX+I2JQM+QsTm7ZohB3gE/rQ6hvC1clSp+n78OKwg5H9kIfDaSDk10XqxfbiKdOVYHqgExhd6VS7g43EI7KlMTE1SyBSx+sZfs0QX+a6MiWxmkkq+MR6ijzorTSBCo6ykxM3HO4DWbBKNlrdjtKuyqRQFpxoQsb8nBsO9vSPHjIZhOF+QzcrpVPzGVUwTROWGnc9sydWLMKB3UWRpVMukIJ2TnazY3LQmZYjFIpIFNxVJUHZafQ1DYBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKNWLS5xJwiL4vp9srU273EvqyNRUGAHRAl0PirRakY=;
 b=oKBibRvDF4AQ1Np9i27+DGYsrZvfGlmk1lyE1MF62LxLJzIychzOBH1NDPC12sPUYJIoliG2edtiQpvsC9CDeqYXaxMZ/EMdIQW2/dZ59EipPOEvXqX3GvcOyrB+ODy5tcgDMycPaQv4pr/Ytd0Ygcok2jC6KxOrNu8Q6KlTRZRWnmtKhgM8OkSFxXN/2G6NGEVqg0w+j0MP9LQFqjuDEzLBeYac8h7FuauuONQfyOOdFU/dsQobdGDB7vvgkuJJPyTfEfjCAZ/eNTvehXRqkJ7TKohTdZO2j3/HjDdeOeVcea7EntpFFx3G52UaiCcQJOzy8qc/FUpyXgjSvW9PCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA1PR15MB5000.namprd15.prod.outlook.com (2603:10b6:806:1db::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 14:59:17 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::f0a8:296c:754f:2369]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::f0a8:296c:754f:2369%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 14:59:17 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 5.19] io_uring: move io_uring_get_opcode out of TP_printk
Thread-Topic: [PATCH 5.19] io_uring: move io_uring_get_opcode out of TP_printk
Thread-Index: AQHYhtyavlyC/2lCYU21UXBI48Rgia1dD2YAgAAGfgA=
Date:   Thu, 23 Jun 2022 14:59:17 +0000
Message-ID: <2778cdda9693e38d76c7b725a01b12bd64fb2d13.camel@fb.com>
References: <20220623083743.2648321-1-dylany@fb.com>
         <69518654-e762-cc1e-1262-a78433ee8e7b@kernel.dk>
In-Reply-To: <69518654-e762-cc1e-1262-a78433ee8e7b@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb269d6f-010e-43c3-9f74-08da5528f228
x-ms-traffictypediagnostic: SA1PR15MB5000:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5000E6F9AE22BBD5552C6015B6B59@SA1PR15MB5000.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +9xIZHmXOdJPaH5LP4lBdUKTuhoKE0xfyMeJXtggbmsbmomja/kzJDyDIUJiHxtc5VKOMlgOIWEC1vvMQvlX6wrtUVfn2zd/sXAUXT9A3LvKkpDpQAs7LLnz4+3vrL/JWo/JnYSMsUISbjWMbxT0M85x7H0Ws3lzaq+oc2AekP4LuoTiwY2srwpiejtcgUaAD2pQloj3874nFdAeEm3neKG6DR8/b0/ArBvjURTghbVQPUxNCVRaSp+ivJEF1OP37kPPhbuSTXKkURtWnYj6rO4YJ5oVe1KBxQmbkLNyXUbSZexe5tvYminmaCZ4N0S4f+rMHgXOOQGpOvBukqnZuJbJYvwEWqRPKPdv1rlJ5iDhfSCpsgac+h+lYAqAcnwMrf16/NUic5ZOKWNwdrNIF6Alxx4wtRvYbYX2SEpEvTAcjTG28XSyxzCF+zbzH8bUFCo39HppEZ9PvfbnZMrpf5hXs+scSheJD/ZCWTURN+gd3TA9qjOQ0k4bubSrHeSWWQMm+XDzTOfg2oUasqp307e3fZVLyGM97qwnU4ISQSxEtm7De+lqOx1goZ/Er3kRbQJAEFEN1aPe/lLpXQqNTM7ZfDI6/q9jtC4sFMzQVT6crXq5otS5d0bDgCj8+1HRWyq9VxVsC+ftdOC4TC7QxVqR2X5VH1krwKB4Xrs9w5HwYmcwD+dVql+AYvTmenN7pMy7HjmpbNGVFed3OmZXYaQSoK8z8sicpibX0FEwPGTVGIokvs4yJtWYwpRqUWr4aOHjxy5mC+yKgHePJZP92A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(36756003)(2906002)(2616005)(186003)(4744005)(83380400001)(8936002)(41300700001)(5660300002)(122000001)(38070700005)(6506007)(478600001)(71200400001)(86362001)(91956017)(76116006)(66446008)(66476007)(66556008)(6486002)(66946007)(38100700002)(8676002)(64756008)(6512007)(26005)(110136005)(53546011)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmNkZmVRa0xwOW1ZRU4ra3JDaHpEVmMwckZyQ0dXbVJaZHo5elUyQ2ZCRXhl?=
 =?utf-8?B?NEZxMTlTaFkwbTAzbnZaTmV0bGI1bktUV3VxWlBLTS9sZEhLOXI5U1hua3N0?=
 =?utf-8?B?aDRSaGo0WHlFWDlVNW51REs0YS8rU2lZQk9TQytjd0ZCOFJYeFVzZUZMa0xi?=
 =?utf-8?B?NVBWRGFDVFpuTEdzNWhTT1ZkcmRvOUFvL28vQ3BHVGdsSzFxRmpQZlBBRit4?=
 =?utf-8?B?aE54TDFBTnIwejJoWGlyOEluSTdCZ0tFT1JaWnlNS3dCMzRseHFuY3JtdEtI?=
 =?utf-8?B?R212a3pPcjN2b2ZtTm5xUUpUYWZJZFlFMHJheFBLdy9TbVZ3S1NpV01CMEhi?=
 =?utf-8?B?NER6VUZaUndMV0t1dXZsZnd4TERXSkxBcm41c1V4SWhzMnh6RDVSbWJjWktM?=
 =?utf-8?B?NkhheG9hSGJ6ZzhWTkh4WFdmaldKVmVxNFkrUy9JL3kyaWJrVXJNaXU2YzNv?=
 =?utf-8?B?RGIzbHlUS3l5eGtYbWhGV2lKR0pNbFphMDZkTHlhWWVEOXZsWitTUkdpTjM0?=
 =?utf-8?B?dVZpdWhoRkc1M203REtRdGZBeThXZDN3THA4blhCcGVWWlVITjNZbG9oUUtI?=
 =?utf-8?B?bGI3OUd5VUVxSGVFaWhlTjhienNNNnNyWi94L3RuSEpMKzhuK29maEUybmx3?=
 =?utf-8?B?R2Fva0wwTGhkaWhOWFNmc2haQzBKSWRMMEt1WnZUUEhGZk5yT0hzZ3BvTmdo?=
 =?utf-8?B?NE9YaFhid0tYRUMzbldzandXai9YUzJ2SHJncjczcTVYYjB0ZVJGcEpxT0t5?=
 =?utf-8?B?Y0ZMczhyazZQZ0Q0a3hNYndFc1Nud0RXdDB4WTF1ekhTWHlLOUVWSWtaSlBB?=
 =?utf-8?B?dk16M0RKck9Hdm53Vm0xOVJmU2NpT08rLzRNYkl4WmZOYVpqMUxJQ2ZFclMy?=
 =?utf-8?B?QU9TcEdSbzRKWEJCWnBuWk94OXphdm13NVBZT0VmclNjOG1iT0ZlT2lmR2Yw?=
 =?utf-8?B?NmNubVliY2N6eCtSMGRCRUllRGRQTGlUT0tMV3VmMG5nTHhhK0JKR2NnTjUr?=
 =?utf-8?B?L3QvOE9RY0ZDTnVaR3MrMTduVWVvVnBsTnA3TENXWWtGaXJSQStORDVFdk1W?=
 =?utf-8?B?UmEwOFdONzBzRXNMVlNabEFkVHhENXltVHZ1aTQrR214U2JkOUFrMVVUR2lD?=
 =?utf-8?B?c0dBTEp0THNVcFl4NFNNVWhnSW9WS2RiSUVMQkF0R0tKeklrM0g1RzZZSERB?=
 =?utf-8?B?SFNrNXhBdUg2TjhzL1NFVXcvQWV3a1YwbXJseTVUdm1BRGo3R0NMVm5WaTRm?=
 =?utf-8?B?Ujl5M0tSWHdNdmJWREJQODh3WUJXTG5uOHFmNHRwWm44YkVDSldHM1RSMk02?=
 =?utf-8?B?dXAwbGhlUDRDUzBNYzkybnh2RTVjdk1CZEozb1NMOWYrbWQvV25maW5XSldD?=
 =?utf-8?B?eUc5cmNPZ0swb0x3U3dIazZ0a1c4eTNyRkFpb0oxN3VZT2pTT0NWblN3c3V0?=
 =?utf-8?B?OWJZeEJ2MmczeHNZdVZvY0RiRlphOGhORldhdmRBNzkvdHh0dlltOUt6VXZo?=
 =?utf-8?B?bHNhN2dDU1hYZ2xPcXJRRFkyc21QMWwveXowY1JhWnBVcmJIYUNaQjA4RFhR?=
 =?utf-8?B?NXZNNDhkOXU3ak9ZdzJVS2RSM3UyT3Rnbm1uWitLbXFhcG1xQ0pkMXZWQUYx?=
 =?utf-8?B?U1Z6VWFWd2Z6M0FNNjJlbm5PV1RsUjlPeVl0N0R6NUhxQXA5ZkxuRUNmcmlH?=
 =?utf-8?B?WmxoWFRPbEU4V0laY0xIa3JmS0ZSWXNPQkhuU1NEb3dLK1pXNkwyeXQyWmlU?=
 =?utf-8?B?ZnpVMU1FcXBZa1VFNHBnMEY4cHJkNmNZK05DWmlqV2h2dzFQOThNc21OdjI1?=
 =?utf-8?B?b3BTc1Jnek5GYmpGNUNCUkpMMzdJWEpjRnJUdXRrVnQ5TndoZUE3SGpDbmM4?=
 =?utf-8?B?aUlCMVo2aTlEU3NZODk5QVNMQkl1d1hKSmVISThjZmJSMDdCSVBhVDh6OFdT?=
 =?utf-8?B?TzhvMjRFaU9jcWx5OUVLQXZ2YzRhbXVNTWc3TStwNzJQMzcwWVE2V1RGdXZT?=
 =?utf-8?B?dWF2clhQa3d1NjZXblZpMlhyWU14RWxCL04ybUFON2dGR2ppRVhZSHVMd2Vw?=
 =?utf-8?B?VGR5SVFYNDFLWWJJWDYvRXUwSVRQa3ZlemxndVlTbTVrSmhXK1VBVU5UZW5q?=
 =?utf-8?B?SEo2NFhUSjc3bXNNczBWQlpFUFQ3a0FoN1BQYnAwYUk3VTN1U0FsTUt4L0dy?=
 =?utf-8?B?OFhaNmdOdm9sVmthOWd3OVlEMEVkOHNaa3RaU2pzSUdGOWszdTA5NnpDQUpF?=
 =?utf-8?B?alJiMVcwN0IvNjJCUHc1ak5uSEVEQXNzMDYvc0hia0toV3JwWnNuamo0ZjVC?=
 =?utf-8?B?c1BRelVPV2xMWnlnVzJRNUM5Tm9xbmZpVW52YklWeC9EUE0yMm5UUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF7F1F6F531FA64EB68B45D45E7A1408@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb269d6f-010e-43c3-9f74-08da5528f228
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 14:59:17.5991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5uhMu7fvZTLJCEAzwu7XT+b6jxfHvQm0954mo/XEWGkeLkmuxEnqwUUbSG372niF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5000
X-Proofpoint-ORIG-GUID: H-sWm58PL0BoX6V9zP2CDCTqkqaN1npw
X-Proofpoint-GUID: H-sWm58PL0BoX6V9zP2CDCTqkqaN1npw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_06,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTIzIGF0IDA4OjM2IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IE9u
IDYvMjMvMjIgMjozNyBBTSwgRHlsYW4gWXVkYWtlbiB3cm90ZToKPiA+IEBAIC0zOTAsNiArNDAy
LDggQEAgVFJBQ0VfRVZFTlQoaW9fdXJpbmdfc3VibWl0X3NxZSwKPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgX19maWVsZCjCoCB1MzIswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZmxhZ3PCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKQo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBfX2ZpZWxkKMKgIGJvb2wswqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGZvcmNlX25vbmJsb2NrwqDCoCkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgX19maWVsZCjCoCBib29sLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBzcV90aHJlYWTCoMKgwqDCoMKgwqDCoCkKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBfX3N0cmluZyggb3Bfc3RyLCBpb191cmluZ19nZXRfb3Bjb2RlKG9wY29k
ZSkgKQo+ID4gwqDCoMKgwqDCoMKgwqDCoCksCj4gPiDCoAo+ID4gwqDCoMKgwqDCoMKgwqDCoFRQ
X2Zhc3RfYXNzaWduKAo+ID4gQEAgLTM5OSwxMiArNDEzLDEzIEBAIFRSQUNFX0VWRU5UKGlvX3Vy
aW5nX3N1Ym1pdF9zcWUsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZW50
cnktPm9wY29kZcKgwqDCoMKgwqDCoMKgwqDCoD0gb3Bjb2RlOwo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBfX2VudHJ5LT5mbGFnc8KgwqDCoMKgwqDCoMKgwqDCoMKgPSBmbGFn
czsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX19lbnRyeS0+Zm9yY2Vfbm9u
YmxvY2vCoD0gZm9yY2Vfbm9uYmxvY2s7Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgX19lbnRyeS0+c3FfdGhyZWFkwqDCoMKgwqDCoMKgPSBzcV90aHJlYWQ7Cj4gPiArCj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX19hc3NpZ25fc3RyKG9wX3N0ciwgaW9fdXJp
bmdfZ2V0X29wY29kZShvcGNvZGUpKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqApLAo+ID4gwqAKPiAK
PiBMb29rcyBsaWtlIGEgc3B1cmlvdXMgcmVtb3ZhbCBoZXJlIG9mIHRoZSBzcV90aHJlYWQgYXNz
aWdubWVudD8gSQo+IHdpbGwKPiBmaXggaXQgdXAuCj4gCgpBaCBkYW1uLiBHb29kIHNwb3QhCgpU
aGFua3MhCgo=
