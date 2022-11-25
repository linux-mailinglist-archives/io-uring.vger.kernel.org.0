Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BF4638627
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKYJ1D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 04:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiKYJ0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 04:26:37 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21AF32063
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 01:26:32 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP9GFgT007617
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 01:26:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=dfwSYVO1dervhTYB0PHeK83m8XiY+DsFvIWrUDoQiUY=;
 b=ZVqYGT0DsO38k4pd1bdUTD7V4LntarEisXv0+1k5oXwSwU4AvEnCAV5zgME8Hk5U+pkm
 RjIeZ6d81ZNQ9e4/pXrPLpBo/OxoS0GXcxvu1+m8SB3Z1FG0jK0WHlnmS75NEyYDguLs
 sT7b+NBq5jt21Iz6JgeBPt6pdzo4Hd/LUCSovNYQIr4XldWcxiOQIxeKUCIwf8XPm2fJ
 pSHXACWBv5KI3rNm+BHqASTgFYY8gx24qBL1ehABU3TUk2NEwOHFhsJwLxWALjXKyuFV
 /FEohwyy0XKTdSpP7zsytE+C9reCpbSo7RQetdjhzuieB3ObEd8P3+/nVWlf1cQGKHGh vQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m2tx2g1uf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 01:26:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yl9J1MfNeIKbQLJJtZ04guCOq7Qfcod+aTtAuUNAYc/qt3oBxb9nmWEkNjfZYZQV62OCKzCJdJ1ouaSysSk+r9pRUn0cOlDsc6FjpaSojTp06vn46Q110nnIouJUCdqtuhoIidpEcx8JqRKAkd6Ay+Y4G5swH3okMdxO+uCkBFqhesXyxInt4CMrWtjYEcNruEdrEM3lNn4geZctQuhXVhwwThIcOu6m3gW25NmY7xgkvvVO9V9KU+v2sQOM6BToE5Zk+5WiejACZYuMHvLGZ3THFhQ23Yazo46zI9+2WzVgbTVxBEv7H1kcvePX0/43EHXoGa4HCsMLm/DP5BWVLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfwSYVO1dervhTYB0PHeK83m8XiY+DsFvIWrUDoQiUY=;
 b=cHExZYhV/zxPpKrh/n9Z8pQW7SvBJyDfxdPSUVjZEyEiTfZu/sd3MUbNNju2LDdvJg6gzRyEoJ3aYo5rwnbQgJnz4L0JpyBDjBClyawyhg1wxlYNoHscG57p+DUWMalVwffwwUrOEYMVMxlzV7V6gVVy8SirXYjuEx+FsqFaIiXR4jvrglduoEmtrUQ3csXd1ayq7ah+JR7u7n/u1R+kkj1FGD1rsB7CwCvQ0/xrThJjq6LalijoyZbc7WK7p/JEVwcBJe99bjOx9nAtXJ/yRVzHwQoSjCp6C4SAKCgOhzCuFBXEcmmcZo3JRV34PaWud0Vz9jXgXDHwBPCbDgSIgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SJ0PR15MB4440.namprd15.prod.outlook.com (2603:10b6:a03:375::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 09:26:29 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5b6d:c9b7:796a:8300]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5b6d:c9b7:796a:8300%7]) with mapi id 15.20.5834.019; Fri, 25 Nov 2022
 09:26:29 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <kernel-team@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next v3 1/9] io_uring: io_req_complete_post should
 defer if available
Thread-Topic: [PATCH for-next v3 1/9] io_uring: io_req_complete_post should
 defer if available
Thread-Index: AQHY/+g7BtjKBodyakur/L8YdpIoKq5OOriAgAEk4IA=
Date:   Fri, 25 Nov 2022 09:26:28 +0000
Message-ID: <b229a9225112587d71d242f864e4575b39abbfd2.camel@fb.com>
References: <20221124093559.3780686-1-dylany@meta.com>
         <20221124093559.3780686-2-dylany@meta.com>
         <f5cb5923-6ae5-2376-bce2-5de1ede393d9@gmail.com>
In-Reply-To: <f5cb5923-6ae5-2376-bce2-5de1ede393d9@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|SJ0PR15MB4440:EE_
x-ms-office365-filtering-correlation-id: 987060bf-e252-448f-627d-08dacec72203
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xeOyzTCqOJEpIPRs2L7nJWEHcryzIcpBe1DfVGyWIiOCvfszxmLCkNupsqMvFLlwHzfcgQbXoAj3lZWTQyBrihj0CkhhkyYD7YShCOcusAOlxSIr/K5SZA3RnBaCk1AkB8pdNhLvwUUKuXstVUDdda36B90HVqrl+JCnNse5yqithiQlb2LDWUgAH4NAOZl83Ef/1g+Ku+H8vbA9KfOQLMfviWpWLyP1WvgS1QBob5/WgOzcW6Q/TccjOK4MIZH6fArT2/itbFAA6emJESyhUgci82I2CiQEibKumQB2onFDaumlh0L1n5qle39nHARdVeuC3rVr/D+JxvWxRKnmhYVykmvBZx4HNTIwX6B9RkUxwLVUQ9MF6W3zZfEpeVikQMYJTR0XqJyvGIrMOwClEpbxb55cq8G0uubs7X/rzu2Uh+JPWGZmwDKwDy+TPNWdJg6bZ1UpoAeVb0rMolNw0HZNQ0RjHp/XcJ3LCFKadPV1fnrcm+JVNEDbKMHp2JZllug8qc/LFH9kxb3iGLtM0lwABaKTwMFfbmKvZM2rjsCcQtpvPU/7l9Nuxz/s7m/0rDpCqLj0RpajQpZdiJleuPztSPDwo/Kjea5hfRTVd1yx5aqVJhnKFrcyAfB/T8TJwtQjB6n3Dwmro2x/UenGTh4KvNjyR8vfwwou2bMe3NBpU92wxgevCZPfIiot2c5tWBek9o8xNK9xXVTBeAafEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(41300700001)(186003)(86362001)(4001150100001)(8936002)(36756003)(83380400001)(5660300002)(66476007)(110136005)(54906003)(6486002)(38070700005)(316002)(38100700002)(91956017)(8676002)(64756008)(66556008)(66446008)(4326008)(76116006)(66946007)(122000001)(71200400001)(478600001)(9686003)(53546011)(6506007)(6512007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFdxRmFEc1FLNGRXNDNSQ3B4dWhoUE5xTkZEaHEwTGhpU2RXNGRMWmpiN0pC?=
 =?utf-8?B?ZUdGOVBBK3d3M0c5MXFiZHd6ZGkrNWM5Vk42b2grcDJHUXNodDA3c0dpSVVv?=
 =?utf-8?B?RDNsZXJqVmRpeG5jUnEwTHNlRzdtY04zdjFsSlJUTVlPMGFmVFVhY1Y0ZkVG?=
 =?utf-8?B?VHFkOVpybjhoNFJ4Tk9hNWxpM01JQ2dhT0hzUFhXd3FIMElqRTk1Um9OQmNB?=
 =?utf-8?B?R3Mrd0pWTXBweG9rQ25YNkZvZWg1T3QxR1ZDUFd0U1RKdUtmV0VCSmpsZk8v?=
 =?utf-8?B?VXdQSnRPOVl6MyswVmx2SlZmL204YzhVbnhQajNad0tGMG5DLytWM2JDQit4?=
 =?utf-8?B?ai9LV3VHL1dOQzBpU3dDWUQ5OXBFQk1OZmhsZkRiQnpGcDIzcDZhZlRnUDNC?=
 =?utf-8?B?a1RUSSt6UXorRC9TQjBERWNGMk8zcFQvdTB3Rk95VjhFQ0JHVTF3ZHcvM0hl?=
 =?utf-8?B?emNyVmlZT2o5bmZRNE1FNEdmMXFSeGlBRG9QUXk3MHdVT3dwY3paaFFlb0FT?=
 =?utf-8?B?VlVMeDdnUFRCb2tLMEE4OFh0SHFkUGJJMFRzU3RCNlJYNzQzc2ZXcThaaC9D?=
 =?utf-8?B?YnI2WE0xa1kxaVNMb3VLTFpZdEZSWUdwVm1BY29GVFoyTzBmLzhLMy9XTEI5?=
 =?utf-8?B?NDlnSGprU25NcEZMZnpGT3dXVVlZNmZJclZ6OEdZQWQvQ0l1NG1qa1JVWE9h?=
 =?utf-8?B?TFVKV3VwTDBzTWxyQm92a0llSEc4NVBwYkNqZFV2N24vV1NpNU40cVBCa3Ru?=
 =?utf-8?B?UEpIcmlMTWl2RjExelVzVlErK0h5WnFPYndIZEwrVWNiRlBVa2lMamlWVTlz?=
 =?utf-8?B?MW1EbVhhcERHamk1ajdVQzBSVkVQakxzS3E5NlNHSk93a2J1cGRUL0l1NGVM?=
 =?utf-8?B?UFQ3MjkvbHZOQmNhRTNJY01Ob0NRQ2FWSEtQcnRZSkFUeUNHNXRXVGdGTlc0?=
 =?utf-8?B?M2xFcEVST2p4eVVRWGhVVzFvOFBYZ0JXSDlmMDRNZHdHd3liK25iZXdqMkJS?=
 =?utf-8?B?aVhtMllmRVJNNGpaZFUrbGlmNkVoc1I4bXczWGUvemVrdXRUWk53VkpzeXhK?=
 =?utf-8?B?YTQyMVBBNDFMWkxBaDFlTFh3SEswQTlvQ04rMGZlVWdXdFUzRGIxckFtc1N0?=
 =?utf-8?B?RFRHZGdoQUlodmpheVJ2SS9JMzZCK296RUY4QWgxWG5QWWNCemJYbmdPcjdN?=
 =?utf-8?B?VWtMbktnVFJGNlBWZ1Y2aDh4M3paN1dZaHVYcldZMW4xWGVjUUc3L09oSFJ0?=
 =?utf-8?B?ZW02dHlpZzNib2hqYTZPdUlYNVZwcHJFTExOV0FWbEYxQk13VzdPZGlRY2Jn?=
 =?utf-8?B?M0JhTzY5Rk5FR0RrcU1CSEYzT242SHFwbThWSGdFaGdHckp0OU1jMGg0OThq?=
 =?utf-8?B?VENJQ1N2WGxCV29zK2RmK05RS2p5OGdlZ0RCOWtudUNTSDZVYVNYQnBBVHky?=
 =?utf-8?B?NCt5U21nZjZsLzZ6WmM2ZEN6MDFhSkVITzVJSE5XWHo3enJxTFE1ZlFoVWhq?=
 =?utf-8?B?RnpmVTFGc3BJWGZoVmNFMWZScFFkVFUzTlFFQ2hzRllScFVaSUJONDY4MUxn?=
 =?utf-8?B?ZUV3NW13TFRuenR0REdpenlaYzQzYUtxS2ZjcXdWOFcvMzU2d0xYNFpxUHBj?=
 =?utf-8?B?cTBDNXdiUEZjSEhVTVcvdlVDYUpFbzZVMXlJMlUwL2h6UFhWSnV4dktKQ3hv?=
 =?utf-8?B?R1RZcStQUjVkZjV0MUpOVVdybVhoYlFtYXJiaTd4RTdlbTlEMklJVjFLTEFj?=
 =?utf-8?B?citZMjdieUVtcTdCa2xuQzFNTEJTUkNZcWpyUHU2aXYxWnFVcWQ5ci96aW56?=
 =?utf-8?B?R2tVWVByV3cyRHdYMm1XcitzSlpBOEIyYnkvMitoRVluVU1vNDNjb0tjajJI?=
 =?utf-8?B?RUZMVnZPMS9FWElkbHBvM3pBNU0waTdVZ21DUUpVQzM2Z2ptK3ljcVg1ZzZ0?=
 =?utf-8?B?ZjdzOTgwdHMvUm0wMnRGMmdpZEdJRXM1dkdUeE95VDJlSmpGenE0M0ZnbHda?=
 =?utf-8?B?bXBoNDkzM2Nkbm1RRE44cjRZdGxiWjlNOVhKdjhJcWZxZ1FQWkVuZ3B2cEVu?=
 =?utf-8?B?aUpzbmFvcHNXS00yU1pQQjA2M3RON1MrWTFkc21Jb0dVcVhMYUdvYm1vMy9I?=
 =?utf-8?B?VkJQK1BZM0puTHBYdmljcEVtMUNueEJ4SlFKTzcvdGxVcjlRL2NBNE5BSFp1?=
 =?utf-8?Q?xUxgpz/spsk+Bb3hxbSdprE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05D2CBAD5CD4CB4997C875369E022E0F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987060bf-e252-448f-627d-08dacec72203
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 09:26:29.0182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HBPDbN7NJWVQNgf008JktxEZNQjX5iIQ0sH+fOtc1QnLR2m4HQSlBwkozL0J/e0X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4440
X-Proofpoint-ORIG-GUID: fnf-kKwkDGX1dpD6MvPP4lHjBN6SZiV5
X-Proofpoint-GUID: fnf-kKwkDGX1dpD6MvPP4lHjBN6SZiV5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTI0IGF0IDE1OjU2ICswMDAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gT24gMTEvMjQvMjIgMDk6MzUsIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gRm9yIGNvbnNp
c3RlbmN5IGFsd2F5cyBkZWZlciBjb21wbGV0aW9uIGlmIHNwZWNpZmllZCBpbiB0aGUgaXNzdWUN
Cj4gPiBmbGFncy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBEeWxhbiBZdWRha2VuIDxkeWxh
bnlAbWV0YS5jb20+DQo+ID4gLS0tDQo+ID4gwqAgaW9fdXJpbmcvaW9fdXJpbmcuYyB8IDQgKysr
LQ0KPiA+IMKgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lv
X3VyaW5nLmMNCj4gPiBpbmRleCBjYzI3NDEzMTI5ZmMuLmVjMjNlYmI2MzQ4OSAxMDA2NDQNCj4g
PiAtLS0gYS9pb191cmluZy9pb191cmluZy5jDQo+ID4gKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcu
Yw0KPiA+IEBAIC04NTIsNyArODUyLDkgQEAgc3RhdGljIHZvaWQgX19pb19yZXFfY29tcGxldGVf
cG9zdChzdHJ1Y3QNCj4gPiBpb19raW9jYiAqcmVxKQ0KPiA+IMKgIA0KPiA+IMKgIHZvaWQgaW9f
cmVxX2NvbXBsZXRlX3Bvc3Qoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkDQo+ID4gaXNz
dWVfZmxhZ3MpDQo+ID4gwqAgew0KPiA+IC3CoMKgwqDCoMKgwqDCoGlmICghKGlzc3VlX2ZsYWdz
ICYgSU9fVVJJTkdfRl9VTkxPQ0tFRCkgfHwNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoaXNzdWVf
ZmxhZ3MgJiBJT19VUklOR19GX0NPTVBMRVRFX0RFRkVSKSB7DQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlvX3JlcV9jb21wbGV0ZV9kZWZlcihyZXEpOw0KPiA+ICvCoMKgwqDC
oMKgwqDCoH0gZWxzZSBpZiAoIShpc3N1ZV9mbGFncyAmIElPX1VSSU5HX0ZfVU5MT0NLRUQpIHx8
DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAhKHJlcS0+Y3R4LT5mbGFncyAmIElPUklOR19T
RVRVUF9JT1BPTEwpKSB7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBfX2lv
X3JlcV9jb21wbGV0ZV9wb3N0KHJlcSk7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7DQo+
IA0KPiBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIGxlYXZlIGl0IGFuZCBub3QgaW1wb3NlIGEgc2Vj
b25kIG1lYW5pbmcNCj4gb250byBpdC4gV2UgY2FuIGV4cGxpY2l0bHkgY2FsbCBpb19yZXFfY29t
cGxldGVfZGVmZXIoKSBpbiBhbGwNCj4gcGxhY2VzIHRoYXQgcmVxdWlyZSBpdCwgbWF5YmUgd2l0
aCBhIG5ldyBoZWxwZXIgbGlrZQ0KPiBpb19yZXFfY29tcGxldGUoKQ0KPiBpZiBuZWVkZWQuDQo+
IA0KDQpJIHRoaW5rIHlvdSBtYXkgYmUgcmlnaHQgLSBJJ2xsIGdpdmUgaXQgYSB0cnkgYW5kIHNl
bmQgc29tZSBjbGVhbiB1cA0KcGF0Y2hlcy4NCg0KRHlsYW4NCg0K
