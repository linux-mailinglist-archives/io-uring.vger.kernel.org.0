Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A1C54B876
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 20:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiFNSVK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 14:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbiFNSVI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 14:21:08 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1AC47575
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:21:04 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25EIGUiH022682
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:21:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6LjBQm7eq5ZYW14CzMkN61YDx1/sA6QWUZhTZOeYr/E=;
 b=l1Tx1UGY+rA7BH+slyvyUmTBMom77JhHdZrX6f3cHgh6Dfogm+extsIiuLcBhR7xOwPr
 tgfgpzaiwWyueHLXw2Naa/LlHnfk6V6SczfPQyWkOldIZ+l7tZVXKlOmY/ZtNAYr+Vme
 t3D3eFmtbsHB6RrAqdXt5GvfWUqMQBy+JMc= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gpw7qh610-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:21:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRPQ/QDOFkluHbnfh6yYSj1dXlNJlD73ESMWUulL2/poOOJVSuEZXQfHokCTG8RimEFNZtTMd4neDqjaqpXDUSPlD49EBAXNpE2vu5cYSRojsxCE+mgNdO92ng1lIV0ric6DN87fF2k+OOchlGfsLn+CmIPoAqj06KffnK5Agc7Zx7bS15q2KAgh8ozHtawACMjV4QdXDqJxSX5qCqc4Jgp0s/ZQMrSwA8qPiZiweGA2HG7zSH+5eR8PPX5hRMMZxg54NM2ad3bRQ7BJwgTPpLcEPpPPzuGfDuaw+OhiCawCbybyV5Pn2c2ToXTML3QyRpsJpg9+pHJRhy+WfkGArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LjBQm7eq5ZYW14CzMkN61YDx1/sA6QWUZhTZOeYr/E=;
 b=Af3f53QQiLytVs8RXzROxjx7YD9VdTcHkH935z74JgT6RL1VaKFqAEUf2Ws6knFfEB8f3veBICd8yamvNM5quwmtF6okwq+jHKE1oDzJeKsMKh3FYi5U6PISJLf1tgBjoMcSLEzB1MxuMyqd0cH0wTV4pTwZcn622JxLiUiXCckpzn9FSsei+DL5b2IzNR92FDbQnA0jKDiF0cFfIfsHDbYfGYv2Y+UHTFKiBYQXjut1+rIxbNScYO+3tu6RQWmY/rWSDcBLVtXGDsSK0ZihII/16W06kwlNN4X0cdAX/H7WClME68gjK/wbgfnvo1tLUpPv/vHg4VqnznMmeTj7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN8PR15MB3457.namprd15.prod.outlook.com (2603:10b6:408:a3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.21; Tue, 14 Jun
 2022 18:21:01 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5062:4f9f:83f3:1100]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5062:4f9f:83f3:1100%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 18:21:01 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 5.19 2/3] Revert "io_uring: add buffer selection support
 to IORING_OP_NOP"
Thread-Topic: [PATCH 5.19 2/3] Revert "io_uring: add buffer selection support
 to IORING_OP_NOP"
Thread-Index: AQHYgA81JNhe2Gn0Kkiipbdj/ZZt5a1PNuGA
Date:   Tue, 14 Jun 2022 18:21:01 +0000
Message-ID: <477e92153bbfa3620c801dd58e8625281988ef49.camel@fb.com>
References: <cover.1655224415.git.asml.silence@gmail.com>
         <c5012098ca6b51dfbdcb190f8c4e3c0bf1c965dc.1655224415.git.asml.silence@gmail.com>
In-Reply-To: <c5012098ca6b51dfbdcb190f8c4e3c0bf1c965dc.1655224415.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30f04556-88e4-4d0b-031b-08da4e32a303
x-ms-traffictypediagnostic: BN8PR15MB3457:EE_
x-microsoft-antispam-prvs: <BN8PR15MB3457ED0645EBD1D920834B0EB6AA9@BN8PR15MB3457.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r7Y9HOXTRFSZuYrq8VYuu/QZA6FmV1ZZJKFJvYVAitnSsvDgBSxnWGc9XUmqOUvTVxLDil15FVWaMX0QN0UufZICco7OytZv28XdxSeYbag5b1cqZCA7/qlto1WgIv/UTsLybzVpN1nuG32uLuXLHtvfcwBFSRhbmdmqFKqALrVAhnM6jW4QYNRTe28eZlr54LHhtmJplXL8tno6zKv5wGJvspn3NlnvT1zk/l/uMfpkdENE9HViVA5fNKm4CP7nU9Y1r+5yI5XI9INUWgjWeBOgme/XX40iMNXeksttRfwrUUgkmuYYksnivv1yVU9g7Gd7NKUkTQxhcGWd7CvuvddP4yKJNy3VjytU8wkpfbx5ItKTm0+D7kimAXqYo9Es5imBQMF8XxqZeoWVMdGMsz3LFnioyJbFsWAweJ5FlFS+q+EkuzIZAxAigvmjYKdViZOm+GbjvVLP0WmCZ82sQvx5Mb08uifHzn6cPqwmk6wRQpOxqHGabCNSsR8c31cTSwqVTEJoaYuJ9xE8TYuYyeX2Kay38/gqfBAZeTIqbsIxCH4w3KJkrqKN1HPoWZj9KyDt492fQi4/3S5mXUW/gcrVIXUHtaAkLVFuM61lgl1PpTr1uMUPu6YqVDUCdAs459x67wydQ4ry5yr7n0toW5TXDf0lNT6q6FtCN9OQn8Q7BrdjBgaZg8sUODo39WAOEf1RBAvNNelLYa1DzV/xOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(6512007)(6506007)(38100700002)(186003)(2906002)(83380400001)(66946007)(122000001)(66476007)(91956017)(5660300002)(2616005)(316002)(64756008)(66446008)(508600001)(8936002)(76116006)(66556008)(6486002)(8676002)(36756003)(4326008)(86362001)(38070700005)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTFaRFFRN0F1KzhhOE1yNnFQaGNtRkRmSFVzZXYzbXBaWitMVHlxdFIyUkFG?=
 =?utf-8?B?TlVBWFZkclNKSitLRFNoRGtYR0pQdmNtL2RYeFg3LzFIQU4rR1Q4UW1YUGJp?=
 =?utf-8?B?SVFUZERqR1ZnMy9NUzJGSnVZbWVuNjhvM0EvSGJaT0tGTnhBTXdoNTFGMjZE?=
 =?utf-8?B?aVdabWF3QjY4QnVTWXg5dWJUNUViR01nY2N1MU54REdXdWVIem9YRERoSFJT?=
 =?utf-8?B?cXQyYmFQbE5ZU1JyUWRHbmp3NnpkanBxcHFNTXZhNytDN0NpdFREaDdqTU5O?=
 =?utf-8?B?VFdWQmxjZ0hiaEN6WHJvMEZHaTA2RE82TDh5Z0V1UUhPcW1KZ21PS3JHOE1B?=
 =?utf-8?B?RTEyQ004RnJmSDNwd2NxMUErRkZLOXdVQXlONm5sYkY3dnlWdXI5S3JPRytP?=
 =?utf-8?B?ZTVwNzUvajdrMFVJY3d5RzdMVGJVZnBLNHl3QzRuYzBpejMvZU4raFMzMVlw?=
 =?utf-8?B?VXpXOHVTR1hxVE9rNGU1VmwxNStxbHpIdzNzOWtueGZtR1lPcitVL2pWRk5K?=
 =?utf-8?B?UzRaaDloOHNOeEN1STFIUEcrL2hWK3pyWlorQmxXZnpXOFB0UFRaSzE5SHZ1?=
 =?utf-8?B?VTVxdVhHMGFlTUd2VnpuOFBJc0FJc1VOcXBkM0lZNFpnQldaT3dmcW8xMGZt?=
 =?utf-8?B?VzBBbDZYVjB2ejU0bmZoRFRJSzBCL0VBalNjSm13RFJxRHIrbGhBSVlYTmw1?=
 =?utf-8?B?L3BBSUdKU3RDd01tMVE5bndPQlg5Z3NqMjNvdVFBNGllWTJuK2hVVjZSWXZM?=
 =?utf-8?B?LzEwOG1WOXFUQVR1NEd0VFJqamxiYisvSHlYekIyTFh3cnV2UXU0MStJR1Ev?=
 =?utf-8?B?NEZxK09LZUNvaU9reDFya0h5ZVN1OTg2SmhKMXc1NktwWjNpdnVFL1p2eVV6?=
 =?utf-8?B?N1hXd25tckNwWEY2N21xMHhuMlVaUW43UFRJaGlFZmthcUhNZGpGNmNiaUYy?=
 =?utf-8?B?SDVDVWpVUFUvZ2hpQXBFc3hwRnFHNFFtV2dCOUhhSHVNN2g1T1BmYlBwelN1?=
 =?utf-8?B?bitQeFVvWEZrYi80c2xPbU1wazl2Z2oxZ0c4NUZTd1VPeXB2Vk5IalJMVGt1?=
 =?utf-8?B?ak9SR2hqWHplWkEwMVVZZVFTTnQ1anRKaTNJQ1NkWFVjT0gvUkFzRDRudzlS?=
 =?utf-8?B?WnRkZER4UjRYM1g2QWVjTDlCeUVlUVAvSXF6LzJRbENjK0FhMytncm85Zmp4?=
 =?utf-8?B?bEpEZnorMWJ5VkpSSWpGZ01URmJYUmc2MXpLbDFpdXAxOHpQbHJ3T3J3ckZq?=
 =?utf-8?B?L2tGcU5ON3VPb2dPbmphL1Y2bjdyZGU3MU9sVWk3eFYrQXlZd2JuMEkrWVpG?=
 =?utf-8?B?dzAyUHQ2cHkrcWZ6VXZ1ZkZiUDlCdTNHQU9odHhDMHZjQkUrcFJxQnJZYk54?=
 =?utf-8?B?YkhMVGNWODFFOTVSM0NUT05qVWdqT0JxRHp1RUZCMG9rbXE4NG4yUG10WlhP?=
 =?utf-8?B?NE53OVZiWXR0UWo4bHBIa3h1QmhMeCtmcHFXSzRTWjRXY29QaEdEc1pkZVNz?=
 =?utf-8?B?NGhNZTdWZkNVT0F4MkV6dzM5SkpJYWExVzhzaWdnVDZ0dkdnWTdNaVUrSTBW?=
 =?utf-8?B?U3hNb1ZQNVBVaklNL1NYSTRKQWcxeFNINHpOZHdCNk1QKzNIbU52TmwrTDJt?=
 =?utf-8?B?MFZYeXFuMUs2VlMyT3RBWnB1TVpCYzlFZUNzcHJRNzR6UkVFYkpEb0FuVG9T?=
 =?utf-8?B?NGJ2VDBjbUkrNVMwUnk1d3pjdVdPNFB3TnY1VHVNN1B3TDdySm1XNFdybmRF?=
 =?utf-8?B?ZTM0eTNZemRObkx5b2lxS2JySUZSOTMybUFDUm54ejlGNy9YT3FGV3Zld1FH?=
 =?utf-8?B?ZzkwOXVWZmNzd0N3R2NtR0lXVFNoL05tN1ZjWXF3OTljRmNYMGppODRiTmhQ?=
 =?utf-8?B?ZE9JMkQzcDdsWUd4ZGdTNE5QelFDVzJEL2U4dXpkeWZSdlM4S0M5SndDUGZE?=
 =?utf-8?B?eGkvbEV4NlRpZlcrMnpORTMwWVZuSkpLRDRvTU4zWWtZS3pqUzFRbWpFeVBL?=
 =?utf-8?B?MzlsUGJhVXhBd2hKSlRoZUVPTlRCcG9pVGNGaVNlcU92UEVuOGU1bWlSVUww?=
 =?utf-8?B?RmFIazUyc0tDTSs2OXBoTUo1R2RmQmVBWUxFNW56L0lucldETGpqZmFXdDZC?=
 =?utf-8?B?dnV4Z0xld3FDbmQrZUVONmx4S0l2L24waFptVTN2eFppVkNzemZOUDNRcE1M?=
 =?utf-8?B?SHBycWVXWmVvZy9hUCtzejVoeWNCU3hPdEVuMTlmUG5IL09JaEYyUit6ek4y?=
 =?utf-8?B?SEpubGF3cWF5WlQvQ2RlcDNvaFhTYU9xTmJZWDQ2WDJSZXJxenhwKzBkVlov?=
 =?utf-8?B?dWlrNGM2ejBQckFkUmpjbnZwKytEZXBjYlVLSjIvUVovMS94WXdCeGJsZ2dC?=
 =?utf-8?Q?By4385LUHM/KIqio=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1BACB7EBA15B54DB18C2A7F83A13329@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f04556-88e4-4d0b-031b-08da4e32a303
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 18:21:01.5937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SMjXCnPjby8IvWuQDXUI78AvLC540GT6fLf13c8r0M2oXyeeUAhpjOqsXASKWupL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3457
X-Proofpoint-GUID: nJt4uksmTGTU3Rn015DpnhiO1Cu8VAxK
X-Proofpoint-ORIG-GUID: nJt4uksmTGTU3Rn015DpnhiO1Cu8VAxK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_07,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTE0IGF0IDE3OjUxICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToK
PiBUaGlzIHJldmVydHMgY29tbWl0IDNkMjAwMjQyYTZjOTY4YWYzMjE5MTNiNjM1ZmM0MDE0YjIz
OGNiYTQuCj4gCj4gQnVmZmVyIHNlbGVjdGlvbiB3aXRoIG5vcHMgd2FzIHVzZWQgZm9yIGRlYnVn
Z2luZyBhbmQgYmVuY2htYXJraW5nCj4gYnV0Cj4gaXMgdXNlbGVzcyBpbiByZWFsIGxpZmUuIExl
dCdzIHJldmVydCBpdCBiZWZvcmUgaXQncyByZWxlYXNlZC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBQ
YXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4KPiAtLS0KPiDCoGZzL2lvX3Vy
aW5nLmMgfCAxNSArLS0tLS0tLS0tLS0tLS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMTQgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5nLmMgYi9m
cy9pb191cmluZy5jCj4gaW5kZXggYmY1NTZmNzdkNGFiLi4xYjk1YzY3NTBhODEgMTAwNjQ0Cj4g
LS0tIGEvZnMvaW9fdXJpbmcuYwo+ICsrKyBiL2ZzL2lvX3VyaW5nLmMKPiBAQCAtMTExNCw3ICsx
MTE0LDYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpb19vcF9kZWYgaW9fb3BfZGVmc1tdID0gewo+
IMKgwqDCoMKgwqDCoMKgwqBbSU9SSU5HX09QX05PUF0gPSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAuYXVkaXRfc2tpcMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPSAxLAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLmlvcG9sbMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqA9IDEsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5i
dWZmZXJfc2VsZWN0wqDCoMKgwqDCoMKgwqDCoMKgwqA9IDEsCj4gwqDCoMKgwqDCoMKgwqDCoH0s
Cj4gwqDCoMKgwqDCoMKgwqDCoFtJT1JJTkdfT1BfUkVBRFZdID0gewo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgLm5lZWRzX2ZpbGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoD0g
MSwKPiBAQCAtNTI2OSwxOSArNTI2OCw3IEBAIHN0YXRpYyBpbnQgaW9fbm9wX3ByZXAoc3RydWN0
IGlvX2tpb2NiICpyZXEsCj4gY29uc3Qgc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlKQo+IMKgICov
Cj4gwqBzdGF0aWMgaW50IGlvX25vcChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50
IGlzc3VlX2ZsYWdzKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBjZmxhZ3M7
Cj4gLcKgwqDCoMKgwqDCoMKgdm9pZCBfX3VzZXIgKmJ1ZjsKPiAtCj4gLcKgwqDCoMKgwqDCoMKg
aWYgKHJlcS0+ZmxhZ3MgJiBSRVFfRl9CVUZGRVJfU0VMRUNUKSB7Cj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHNpemVfdCBsZW4gPSAxOwo+IC0KPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgYnVmID0gaW9fYnVmZmVyX3NlbGVjdChyZXEsICZsZW4sIGlzc3VlX2ZsYWdz
KTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKCFidWYpCj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVOT0JVRlM7Cj4g
LcKgwqDCoMKgwqDCoMKgfQo+IC0KPiAtwqDCoMKgwqDCoMKgwqBjZmxhZ3MgPSBpb19wdXRfa2J1
ZihyZXEsIGlzc3VlX2ZsYWdzKTsKPiAtwqDCoMKgwqDCoMKgwqBfX2lvX3JlcV9jb21wbGV0ZShy
ZXEsIGlzc3VlX2ZsYWdzLCAwLCBjZmxhZ3MpOwo+ICvCoMKgwqDCoMKgwqDCoF9faW9fcmVxX2Nv
bXBsZXRlKHJlcSwgaXNzdWVfZmxhZ3MsIDAsIDApOwo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
MDsKPiDCoH0KPiDCoAoKVGhlIGxpYnVyaW5nIHRlc3QgY2FzZSBJIGFkZGVkIGluICJidWYtcmlu
ZzogYWRkIHRlc3RzIHRoYXQgY3ljbGUKdGhyb3VnaCB0aGUgcHJvdmlkZWQgYnVmZmVyIHJpbmci
IHJlbGllcyBvbiB0aGlzLgoKSSBkb24ndCBtaW5kIGVpdGhlciB3YXkgaWYgdGhpcyBpcyBrZXB0
IG9yIHRoYXQgbGlidXJpbmcgcGF0Y2ggaXMKcmV2ZXJ0ZWQsIGJ1dCBpdCBzaG91bGQgYmUgY29u
c2lzdGVudC4gV2hhdCBkbyB5b3UgdGhpbms/Cg==
