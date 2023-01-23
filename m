Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF5C677D86
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjAWOE3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjAWOE2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:04:28 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC454695
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:04:26 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ND9ZFq025966
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:04:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=lv6Jdb5UsTDKvRNq80VELnPRWAxe5plmdDBoowojLG4=;
 b=SmAjQdiMHdSu1PSK5dc+PMsaOctzTXNNwVlbG0NGkbqlWbPgUoO1CCsUPjRrA4J/sGZs
 edM6wLkOiCwUomZMp6SAToIi8Q/EGXVhO5RqbRsqSDD9eVEJu7IWCt81CXEfHiPGAhB0
 SOJ5YvX70WkzvcUSiz6I5GHlb7qXW97qbicuBEILbZRTxpG4/b2C/1kLnwtHaelHepZ5
 JxcIrFLTo05MTdHhOtKZPiWx+8g3js44yxLf6lwmR5yj53OAYWuhVyeIJpGpygLu/TdB
 VmeZsh4fKRc1+BCJ4lOdUj4efhTAaxx3FPHUpSFlHKsVFV/84+f/gRC1CtQIdroieHDl Kw== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n8ep4hhph-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:04:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtkGSG+HmCRZdCFcgOu14OCbrsFm6V1vjQEXVgJ6M1GykEv3CJwoA+0AwYBEnfEQhv646PxjAyeDzqe4vPv8w+vu2iwM37X3/f3aZiL2N/PYb+NhhYL+eGIjSXSMYi1Tfsx1mWSdlvCqeTBOLX4OacmBxrnW3wiZAqZoxcR7DuhBBlTobUTqzCDP08VndOkQV87OyZ3O/QakRin8Em6xBbdL/xHi3kUjnoJOZ/IkWBEZwUWkjkdOeYRTHhXqOnMm2TY8B1hYCWqiiwucBeAOkU1o8qx3PI67vIPTsvmad8orEtKPUoKqpXNWRr/y1xEetA9+RY6XN5qS+1sYDbdfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lv6Jdb5UsTDKvRNq80VELnPRWAxe5plmdDBoowojLG4=;
 b=atNGisQvs3t2Tg2L2iJeUh39vAL4na4mtgWh1E+8jZ79qZ/yPLQ0BUTakvLgEsCn49L4ZjYhnrLuUyBj1q7c3Yi3gmFOVBmNuMQPaLTH2oSutedmHogPZREye5U5a+1BCsTz2tJnMpi2HigVVf77m9CZLEcfXYx6aaGG3qqeXri5+QijWHyEbMAX8VtshZf6CxK9y87/VuEwN6w1IGORAtKVeeXSenVjnuUus3QCPSN6VWGlcC4y8fDikoR/01lfhJmW2hIEbgGLNMlUQkuoa+sD4vENjhXosLSmq7q5A6EsUYcgiRnFjZ+1TYrnuiebWlsU8pFI4ejrYikmg1uWXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MN6PR15MB6243.namprd15.prod.outlook.com (2603:10b6:208:471::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 14:04:19 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::483d:9524:b087:a7e0]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::483d:9524:b087:a7e0%9]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 14:04:19 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/net: cache provided buffer group value for
 multishot receives
Thread-Topic: [PATCH] io_uring/net: cache provided buffer group value for
 multishot receives
Thread-Index: AQHZLoTjfdM8TTHPo0SHxMbTN9AQpq6sCh+A
Date:   Mon, 23 Jan 2023 14:04:18 +0000
Message-ID: <842b838f529636435dd4408989f7b03de4a9e0ca.camel@meta.com>
References: <3627b18d-92b0-394e-4d39-6e0807aa417c@kernel.dk>
In-Reply-To: <3627b18d-92b0-394e-4d39-6e0807aa417c@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|MN6PR15MB6243:EE_
x-ms-office365-filtering-correlation-id: 8c89e806-5376-43b5-5b5d-08dafd4ab8b0
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kWLBXoGGg7CM7oy1oUMh38FCLuEbJo+gEsDrqh0IA0nzTfJTBdK8w94DNzDm9K4CrXpLtfQCePYbije4JWr+GWfcfEtNSm4iXq0eU7smkIsl727roSOim/sxEuzLe/j9RIIT8YbkQVOgU4t0I/IxZZ2FT13bEv8jr45z1ec6M7F2TP8AKJLZLW0vgqyl3Z8dP/aH97TH2TCG/eIfYdI/e7qo0yZxyMjtcKUOzfat+lluVKjadIXMdkFcua7OBvwDCS6MNhEepXrnBVsjULM4p3NQnaaUOid2nAPNuX9QDy0SeYJBjzFmrDIga6El0Sgyo6iqYRH6+LeyrkSIyrvDxFLdGwQn+isRhLYp9JF3U50URqOVOj9RGBsxHnSg7wNVcnu3RpFkjELUV49AuKnKo5MH+jOJR6tsVJG+Ibz+zwwhHz+bPLEPL+N9Lsqm1OKIxPQV4QyTDbUPAwxnS+hvqeyt09NeIQodIZ6+9sK5J/c2t11BcnmtiWD3ufVttqdbulaDC5MZfP10xQhAdlw6TnT2zyuo6QpvjAPD4qkqAeoGpzE9LExORmwdH6q94ThzgaJeZJLM8dN12rRsnU7TXGHp31DzP/V9+RQIkWfC1ch5bg4cF3gcufPAtXSdSjxKkIXMGPLYb3DiCTIMRb9kshSf8eoIr4Ou6Rbe3ctNu/wE1XLp+VDzok0SgIwY8k0cwOj66d30ye8iHw262kah6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199015)(41300700001)(38100700002)(91956017)(110136005)(86362001)(36756003)(316002)(2616005)(122000001)(2906002)(64756008)(66476007)(66556008)(66446008)(66946007)(8676002)(76116006)(83380400001)(5660300002)(38070700005)(8936002)(6506007)(71200400001)(478600001)(6486002)(186003)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODY2MGVQRkpCUnB0NVhCMlBuVFdYTUl0VGo4eGJXby9HV3F0RzBKb3YzSVNW?=
 =?utf-8?B?THJ2MjBkZTZWOU5HY1pCSWxxbkNIRUpCRmlTU1JrU1FJYWp6bnJPcTFLQi81?=
 =?utf-8?B?RGFIclhHOEMwUDBKRUZzc2J6U0FDTHFmdWEwWkYza3hKRUZyS3ROSXI5L3dM?=
 =?utf-8?B?UkxGVUxHbHA3UjRXMHJ6SnIvTXN1RmJ1dnoyOXJYWHNZc3Qwdk1WSWhlcEhV?=
 =?utf-8?B?Z205bm1BUHdVbzVqN1ZmdktUYlFQbVJlK1ZxaEVjeVhSS3M5aEtFTitRKzBD?=
 =?utf-8?B?MTdhRVZQS2xaTUt4eldqM2lRcnAraGFPWW42dzNXK0hJNk82Z2dyWndoYnFG?=
 =?utf-8?B?MWV1dE1YMm9nTlVkaUtQOThORTZxemtLTHFsTTU1Y2ZROGZ4RkhVeit0eE5W?=
 =?utf-8?B?dUUxUS9OUVI0WHZGRG5pamU1allmdmhmdkROTkNQKzJ5WkRNempDbTlLaTBm?=
 =?utf-8?B?QWFKcGUyclQyc1Y3Um15dHJOQUhPL2o2RndNLzREVjZWbnNiNmpFTjZSUXFm?=
 =?utf-8?B?RUtuVTNDZ2Z5d1NFN0VoQ3MyZlMvall0U2pRSDJyNkZxVWtReWI2MFdMb0hP?=
 =?utf-8?B?clZOR3dKQ1pKL1R3blpVL3g0RE1DWFE0WkNTY1d4RHladnhVNXVnZWcrSUlj?=
 =?utf-8?B?SGE1cUl3RHpTc2RUV2QrYlhoWllWOFd4OER1KzJCenVwMTdyMDNvalJwZDc2?=
 =?utf-8?B?UVNyd2VVYko0V3pKVkRMUzVTZHlielZFZXRDcXk1a2FkZE1hdnVDejFtVm9m?=
 =?utf-8?B?d255ZkRxNGNyOEc0aXMyYlJkdjhrSklTUmhiK0lyNkdVRlhDaUF2TUhBcXNy?=
 =?utf-8?B?NzNNZlFiQ0tVZVlIVXNsSGlZS0tjZjRlYzkxNUFBdWdERDFmUlpsdEhLYk5J?=
 =?utf-8?B?ejBGSkNvT2J2bE9yQ1QvR0wrZXBzcU5GS1d1eTlzbmNOaHJqNC9LSzJnWG9J?=
 =?utf-8?B?WDUrbG1udHRFTkN5M2RFaDQ2Tm5Ub2JQaWhtRGhaTVJDMVlVZGJxbVdKUlpq?=
 =?utf-8?B?aHlpTmc2dHAwV1ZmUm1JVHRYNTVSajZsWXBlNDNrN0V4bGFNSEwvdFV3WlNQ?=
 =?utf-8?B?MTFSSzZxNVEyRHdjR3gxZmxJK2VQL25vclc1aitCQWgrYnBBdFZ5bFpYblVY?=
 =?utf-8?B?dTdSYW5uR3d2U1pPZHNtZUE0TG9RM2wrOXdqNGErZTkxNmx3WUJXMlpFaDNI?=
 =?utf-8?B?VFVRcENaZmp5V1NGcUhnTGFiVTNjU2ZQWTJXZ20zemhmQXZKbWx5Mk5FaU9q?=
 =?utf-8?B?QnFGSWRjd25IVkhLU0JBMUtZTThrNFJwTGtQSjkydmlVZmdISEk4NE56ZTFY?=
 =?utf-8?B?YjV6aDVwU1Nma2hQMmVxQ2xjdVZ5c3JlZVNWVWdpZ1YyR09kLzFCbTIzMkRO?=
 =?utf-8?B?YUw4Wm1kcDgrZlVlV2ZHclVXRGJXNWhxUFJWWHdrVUhQbjhUSE5FQVY2TzJv?=
 =?utf-8?B?cXY1REFOQitOTENMczFCL0Mya3F2OVpaL3U4MGpqS29peFhDNU1lT2R3K1Na?=
 =?utf-8?B?d3pYY1VWSGFlTUVGcFF3bTZzR3pVTmdwU3ZQK3VRNGh2NTU5Mk5wVnlzbmdS?=
 =?utf-8?B?UEtBcVRHRmQyZTQ4bHdBQitzbFdYQ0xqTnd6Mkg5T0hBSXovamlhY01RQ29Q?=
 =?utf-8?B?OG1yRDN3NDd1Zkt5Sk1xUlZPMVJZelBLS3JVWllWNGFldUxPNzkwYmJjZklT?=
 =?utf-8?B?NEpLbDlsVVNnNE1BQ3BvQXFUZlRxcktmbkFWc0RsaEwxY3NKOHp0dm1BUTBY?=
 =?utf-8?B?ZHBQSmRERXAzQ3hlQ2MwVGVZcHR1eFRGVlZpOW53TVZkM1hZam51RHB0ZXY5?=
 =?utf-8?B?K3EzTndacnhieWRzY2JiSmxCMVpvalR3clZ3VXZhd1dpMis4b21BbGFoeHpI?=
 =?utf-8?B?NUdUMnp6Q2RnOHdzV2ZxSW9LSkNQWE5wNW56MG9Nd2lkNXF2ZmRBdmF2SjZt?=
 =?utf-8?B?REIzTDB1ZEp0Nms4VjE0NUIrV01GWmNKOTIyL1pxYlpkZkpBTTJnTEVrWGc2?=
 =?utf-8?B?ZVVvUjU1YWpHYmcyTmxDM00vV2h3LzdHc1Q4V0YvdS9Vam5MYVIyQTdUNmFG?=
 =?utf-8?B?UHZWWjFMWXk5M0cvcjQydlVXWWRmOHZKNnA2SnJpSnJLS2ptRkxQcno4SENN?=
 =?utf-8?B?Nkw0SVduQjl1Ukc3OXNsSENkTEJvaWZQQ3dETno5ZEYrRXRGbTFuVGZPZHdk?=
 =?utf-8?Q?AmHDOtY+zc2qgMTqODOjSq0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <414F17BCC182AE4CAB50D07FFC2DF1D4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c89e806-5376-43b5-5b5d-08dafd4ab8b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 14:04:19.3851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KzVPy+1C4mg3oOIn5FKk+bHFRf2NAriUG3MSoQLKqGhrkQ0Fvepw41M8vDSJF8wQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6243
X-Proofpoint-GUID: zmGdX0WJ1E7cMNHRE0ea4WBInVFPmJqF
X-Proofpoint-ORIG-GUID: zmGdX0WJ1E7cMNHRE0ea4WBInVFPmJqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_10,2023-01-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gU3VuLCAyMDIzLTAxLTIyIGF0IDEwOjEzIC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IElm
IHdlJ3JlIHVzaW5nIHJpbmcgcHJvdmlkZWQgYnVmZmVycyB3aXRoIG11bHRpc2hvdCByZWNlaXZl
LCBhbmQgd2UKPiBlbmQKPiB1cCBkb2luZyBhbiBpby13cSBiYXNlZCBpc3N1ZSBhdCBzb21lIHBv
aW50cyB0aGF0IGFsc28gbmVlZHMgdG8KPiBzZWxlY3QKPiBhIGJ1ZmZlciwgd2UnbGwgbG9zZSB0
aGUgaW5pdGlhbGx5IGFzc2lnbmVkIGJ1ZmZlciBncm91cCBhcwo+IGlvX3JpbmdfYnVmZmVyX3Nl
bGVjdCgpIGNvcnJlY3RseSBjbGVhcnMgdGhlIGJ1ZmZlciBncm91cCBsaXN0IGFzIHRoZQo+IGlz
c3VlIGlzbid0IHNlcmlhbGl6ZWQgYnkgdGhlIGN0eCB1cmluZ19sb2NrLiBUaGlzIGlzIGZpbmUg
Zm9yIG5vcm1hbAo+IHJlY2VpdmVzIGFzIHRoZSByZXF1ZXN0IHB1dHMgdGhlIGJ1ZmZlciBhbmQg
ZmluaXNoZXMsIGJ1dCBmb3IKPiBtdWx0aXNob3QsCj4gd2Ugd2lsbCByZS1hcm0gYW5kIGRvIGZ1
cnRoZXIgcmVjZWl2ZXMuIE9uIHRoZSBuZXh0IHRyaWdnZXIgZm9yIHRoaXMKPiBtdWx0aXNob3Qg
cmVjZWl2ZSwgdGhlIHJlY2VpdmUgd2lsbCB0cnkgYW5kIHBpY2sgZnJvbSBhIGJ1ZmZlciBncm91
cAo+IHdob3NlIHZhbHVlIGlzIHRoZSBzYW1lIGFzIHRoZSBidWZmZXIgSUQgb2YgdGhlIGxhcyBy
ZWNlaXZlLiBUaGF0IGlzCj4gb2J2aW91c2x5IGluY29ycmVjdCwgYW5kIHdpbGwgcmVzdWx0IGlu
IGEgcHJlbWF0dXJlIC1FTk9VRlMgZXJyb3IgZm9yCj4gdGhlIHJlY2VpdmUgZXZlbiBpZiB3ZSBo
YWQgYXZhaWxhYmxlIGJ1ZmZlcnMgaW4gdGhlIGNvcnJlY3QgZ3JvdXAuCj4gCj4gQ2FjaGUgdGhl
IGJ1ZmZlciBncm91cCB2YWx1ZSBhdCBwcmVwIHRpbWUsIHNvIHdlIGNhbiByZXN0b3JlIGl0IGZv
cgo+IGZ1dHVyZSByZWNlaXZlcy4gVGhpcyBvbmx5IG5lZWRzIGRvaW5nIGZvciB0aGUgYWJvdmUg
bWVudGlvbmVkIGNhc2UsCj4gYnV0Cj4ganVzdCBkbyBpdCBieSBkZWZhdWx0IHRvIGtlZXAgaXQg
ZWFzaWVyIHRvIHJlYWQuCj4gCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKPiBGaXhlczog
YjNmZGVhNmVjYjU1ICgiaW9fdXJpbmc6IG11bHRpc2hvdCByZWN2IikKPiBGaXhlczogOWJiNjY5
MDZmMjNlICgiaW9fdXJpbmc6IHN1cHBvcnQgbXVsdGlzaG90IGluIHJlY3Ztc2ciKQo+IENjOiBE
eWxhbiBZdWRha2VuIDxkeWxhbnlAbWV0YS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogSmVucyBBeGJv
ZSA8YXhib2VAa2VybmVsLmRrPgo+IAo+IC0tLQo+IAo+IGRpZmYgLS1naXQgYS9pb191cmluZy9u
ZXQuYyBiL2lvX3VyaW5nL25ldC5jCj4gaW5kZXggZmJjMzRhN2MyNzQzLi4wN2E2YWEzOWFiNmYg
MTAwNjQ0Cj4gLS0tIGEvaW9fdXJpbmcvbmV0LmMKPiArKysgYi9pb191cmluZy9uZXQuYwo+IEBA
IC02Miw2ICs2Miw3IEBAIHN0cnVjdCBpb19zcl9tc2cgewo+IMKgwqDCoMKgwqDCoMKgwqB1MTbC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ZmxhZ3M7Cj4gwqDCoMKgwqDCoMKgwqDCoC8qIGluaXRpYWxpc2VkIGFuZCB1c2VkIG9ubHkgYnkg
IW1zZyBzZW5kIHZhcmlhbnRzICovCj4gwqDCoMKgwqDCoMKgwqDCoHUxNsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBhZGRyX2xlbjsKPiAr
wqDCoMKgwqDCoMKgwqB1MTbCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgYnVmX2dyb3VwOwo+IMKgwqDCoMKgwqDCoMKgwqB2b2lkIF9fdXNl
csKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCphZGRyOwo+IMKgwqDC
oMKgwqDCoMKgwqAvKiB1c2VkIG9ubHkgZm9yIHNlbmQgemVyb2NvcHkgKi8KPiDCoMKgwqDCoMKg
wqDCoMKgc3RydWN0IGlvX2tpb2NiwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpu
b3RpZjsKPiBAQCAtNTgwLDYgKzU4MSwxNSBAQCBpbnQgaW9fcmVjdm1zZ19wcmVwKHN0cnVjdCBp
b19raW9jYiAqcmVxLCBjb25zdAo+IHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSkKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyZXEtPm9wY29kZSA9PSBJT1JJTkdfT1BfUkVD
ViAmJiBzci0+bGVuKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiAtRUlOVkFMOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmVxLT5mbGFncyB8PSBSRVFfRl9BUE9MTF9NVUxUSVNIT1Q7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIFN0b3Jl
IHRoZSBidWZmZXIgZ3JvdXAgZm9yIHRoaXMgbXVsdGlzaG90IHJlY2VpdmUKPiBzZXBhcmF0ZWx5
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBhcyBpZiB3ZSBlbmQgdXAgZG9p
bmcgYW4gaW8td3EgYmFzZWQgaXNzdWUgdGhhdAo+IHNlbGVjdHMgYQo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKiBidWZmZXIsIGl0IGhhcyB0byBiZSBjb21taXR0ZWQgaW1tZWRp
YXRlbHkgYW5kCj4gdGhhdCB3aWxsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
IGNsZWFyIC0+YnVmX2xpc3QuIFRoaXMgbWVhbnMgd2UgbG9zZSB0aGUgbGluayB0bwo+IHRoZSBi
dWZmZXIKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogbGlzdCwgYW5kIHRoZSBl
dmVudHVhbCBidWZmZXIgcHV0IG9uIGNvbXBsZXRpb24KPiB0aGVuIGNhbm5vdAo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiByZXN0b3JlIGl0Lgo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3ItPmJ1
Zl9ncm91cCA9IHJlcS0+YnVmX2luZGV4Owo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiDCoCNp
ZmRlZiBDT05GSUdfQ09NUEFUCj4gQEAgLTgxNiw4ICs4MjYsMTAgQEAgaW50IGlvX3JlY3Ztc2co
c3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkCj4gaW50IGlzc3VlX2ZsYWdzKQo+IMKgwqDC
oMKgwqDCoMKgwqBpZiAoa21zZy0+bXNnLm1zZ19pbnEpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBjZmxhZ3MgfD0gSU9SSU5HX0NRRV9GX1NPQ0tfTk9ORU1QVFk7Cj4gwqAKPiAt
wqDCoMKgwqDCoMKgwqBpZiAoIWlvX3JlY3ZfZmluaXNoKHJlcSwgJnJldCwgY2ZsYWdzLCBtc2hv
dF9maW5pc2hlZCwKPiBpc3N1ZV9mbGFncykpCj4gK8KgwqDCoMKgwqDCoMKgaWYgKCFpb19yZWN2
X2ZpbmlzaChyZXEsICZyZXQsIGNmbGFncywgbXNob3RfZmluaXNoZWQsCj4gaXNzdWVfZmxhZ3Mp
KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlcS0+YnVmX2luZGV4ID0gc3It
PmJ1Zl9ncm91cDsKCkkgdGhpbmsgdGhpcyBpcyBiZXR0ZXIgcGxhY2VkIGluIGlvX3JlY3ZfcHJl
cF9yZXRyeSgpPyBJdCB3b3VsZCByZW1vdmUKdGhlIGR1cGxpY2F0ZWQgbG9naWMgYmVsb3cKCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIHJldHJ5X211bHRpc2hvdDsKPiAr
wqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKG1zaG90X2ZpbmlzaGVk
KSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBmYXN0IHBhdGgsIGNoZWNr
IGZvciBub24tTlVMTCB0byBhdm9pZCBmdW5jdGlvbgo+IGNhbGwgKi8KPiBAQCAtOTE4LDggKzkz
MCwxMCBAQCBpbnQgaW9fcmVjdihzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50Cj4g
aXNzdWVfZmxhZ3MpCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChtc2cubXNnX2lucSkKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNmbGFncyB8PSBJT1JJTkdfQ1FFX0ZfU09DS19OT05F
TVBUWTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoGlmICghaW9fcmVjdl9maW5pc2gocmVxLCAmcmV0
LCBjZmxhZ3MsIHJldCA8PSAwLAo+IGlzc3VlX2ZsYWdzKSkKPiArwqDCoMKgwqDCoMKgwqBpZiAo
IWlvX3JlY3ZfZmluaXNoKHJlcSwgJnJldCwgY2ZsYWdzLCByZXQgPD0gMCwKPiBpc3N1ZV9mbGFn
cykpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVxLT5idWZfaW5kZXggPSBz
ci0+YnVmX2dyb3VwOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byByZXRy
eV9tdWx0aXNob3Q7Cj4gK8KgwqDCoMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiByZXQ7Cj4gwqB9Cj4gCgoK
