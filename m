Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CAE4BF38B
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 09:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiBVI13 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 03:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiBVI12 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 03:27:28 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70D299EFF;
        Tue, 22 Feb 2022 00:26:56 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21M813uM020259;
        Tue, 22 Feb 2022 00:26:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WV33ILRz3qXOcgSHpKBcF/wSIzS0OJIj8kNWzV282yc=;
 b=jD9wyz1I4njc8849cathhGgfs6ktEaYVM0Q8vi4Ci0GJy5TO4X0rgsrcQ68sC59yE6Nr
 o7X+AUh9EWCPda+i+VE43xvvm3A1O0+7nI64NhZCGQMmYpc+DP7qBe3R9b7bj+/4FJjI
 MWn2fcQU/DA+MehwixoD1LSVtyyabpHPs0k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ecajb4t73-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Feb 2022 00:26:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 00:26:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvWZC1f0rfKCSCmqYbRul3dgkw2f/tXRPK28gF3t0stTjZEC8qQmmKqQ4Spw4bR7mBxuPtYJHdgrnQskxItNT8GpltLjIF/TqW9paGMIPpQH/RFxmUcS05FNK7ioFlo7b3bizr8bmMJgl8/cN9TBEEYvKgWt/qJ3lqsZdIPfowG00XQuEgdWkplbnaA6zKNr4EkaD7fuY3EYJEg10ZrYxoBmECjqzshZt+YeZXNWVjG+hGYTbUu9f7JYUxb1QKXg4omU8LbSbsGGSjwSM4/mkau8Pe/rfEY2j7MQwPNXuMCsz0+6D+Npv1VMfDRE5+py0NaxpFS85duZMZ8KfS2x8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WV33ILRz3qXOcgSHpKBcF/wSIzS0OJIj8kNWzV282yc=;
 b=AasJPFw2OxA2MvwE88BjLmc7Ygx7Yu8+O6QiFFhMP6SQ7WoyxRGxpoZU/RXgX5c6lPH/Gac27NQcmqIVVsNJjlp+2SWGL72t1pG3fR+EgREEkEKQoao2f7/C00t+Gb3wWKiwxiM/o2W6jN5EyIf0zzJdZ86MYcjnxtk0152tvKwFEqZ2aIYi5MgVSSnzgsOI3Eibjf5bkQedoS9eyE+QFRWxAz1oXcky9JrH4eF5Zgtos/bDjt4WnYuuz5EDma4+zbrvgivzEHroaSBhUaO2xKQaZv7SfFMxNRYODw+Gd5t4U0iw7HB8UIo34e4DB4zf7NJMSLhSh4WsYJv01cAKNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN7PR15MB2401.namprd15.prod.outlook.com (2603:10b6:406:89::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Tue, 22 Feb
 2022 08:26:52 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 08:26:52 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] io_uring: pre-increment f_pos on rw
Thread-Topic: [PATCH v2 4/4] io_uring: pre-increment f_pos on rw
Thread-Index: AQHYJy3DKkNH7lIuQ0i9mEbODtcbvayeS2iAgADyHoA=
Date:   Tue, 22 Feb 2022 08:26:52 +0000
Message-ID: <7cb73276b793dbae411938d7b84e20d8a2356749.camel@fb.com>
References: <20220221141649.624233-1-dylany@fb.com>
         <20220221141649.624233-5-dylany@fb.com>
         <ec1647f3-2c37-04be-bdbd-ab78b9f07a03@gmail.com>
In-Reply-To: <ec1647f3-2c37-04be-bdbd-ab78b9f07a03@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80ef56fa-88a4-4a8e-8e96-08d9f5dd1425
x-ms-traffictypediagnostic: BN7PR15MB2401:EE_
x-microsoft-antispam-prvs: <BN7PR15MB2401D9C88A4B24262935B74DB63B9@BN7PR15MB2401.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6UAQixFrJdK21YiGdn5vwseRLVN8MvKLreWsrjIfLsZ6v9R5T+0zPjUiuSjHW8ah9c+FqtOixq4GDrY/bf+khOvzv886Qh/nvx9+kV6jpxv7B8wzTkRd0wV+CEn5uv0DNluDxt6/kIbxsnQFiTE0bZgQkTbWW4E9Y4SDyVAZB/3JXoUqJaxGwtB4GazqHhmQ5u6VBvI5pcEvvfkKvTBNPWCFnllBkBjPdekVW3doktESS3k8ylZqEkbV89t1L0titfl9h5BHNd+xdiJOq6uUytyImvwKZZbhtp4OvPBUjphIuUNxdOqcHEHta+hRXX4aJqxJIJ2t8WyOVPZkcyPRUPOhnNr6HZBKrOjl66148RjhzDV6WUDgBZq93f658UqzT2xFfvfpEeAYb9ncJ0fk/a+BcFnw401sZauL0I83FDQWfCVqKE6uYJaE0pPjXm8pOigrAtrnFqzcYuFs/vB9Tvdt4dl4aJ9/YFKnuMZbHkI+2L11r9rXmPAp6uzn4KHEbo72YKYg4qkrgH0giCHVTVzttLzXXIB5/i5Yp93WEbk90iTuQ3IODzL7VixNU7dartHASlBcmdemlc7nIr5/oL3grM5lSKwP3LUVukqEhQ0U3GqJJL4vLZ32zGb7HimNLhXLWu4fmt29E6fcfkH8Cheys1NHr0jEIji7jqlBWm+Vth91dm/Ae5tO3m+dRisObPlJNjn9B+fMjoOgpFln3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(122000001)(83380400001)(8936002)(5660300002)(2906002)(508600001)(53546011)(6506007)(91956017)(36756003)(6512007)(76116006)(64756008)(66446008)(66556008)(8676002)(66476007)(86362001)(71200400001)(38100700002)(38070700005)(186003)(316002)(2616005)(54906003)(110136005)(4326008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXFVc0JxcElVelBwb2xjcGw0NlZjUjRXVnNKUXFaNmJSQTdiYjAwWjNkZ0Rp?=
 =?utf-8?B?VFAwYUJBK3F6U3lTZXd2V3RFRTJxR1BuWkNsOXoyWFdyVytMbFBaRklKRU1O?=
 =?utf-8?B?VWd2TWtEK0k4Y0MzR3JBczNRV1Rrd0lWZk5oK3NXakFIcXpSdkdjUW42SUpj?=
 =?utf-8?B?WGx2YTQrL1ZxZWRjNlFxYVBlM3VmMk1tOTlqK1NCRmhRbTd1TjRSSlNIVUJI?=
 =?utf-8?B?b0RZT1hWeWNCRjdjbUtvTGQ0RStHQ0VxYncxd0pIbHpqKy81OTlSUWIzYkx5?=
 =?utf-8?B?NjZ2ek9tcGJoRTNuT3BlbVhCQWRHbk5FT2pRdFUydEZ0OUlQSjRLbFJRQUdZ?=
 =?utf-8?B?Z1NNWUY5dW4zRmFwWkx3OUlZMWp1ZENxUTlmNkJoZXdUYnVWK09yUFlPaHRB?=
 =?utf-8?B?dmlWcktIUzc0VUc5UkIwQkJsQmdQY3gvbHN2SkcxVDRGMlFNY3g4UytCR1ZF?=
 =?utf-8?B?dnU5RlNMaXVkS0FtOUNTTDVrNmxNZjhlSGNMOWFkZW9DV1VML3IzdVY1YkRC?=
 =?utf-8?B?aHlmYjRjSkc3WERsbXJ4YUdqVVRBMXdKaTBuRVBHcjZ2cGMrdTdOQm4yYnJ4?=
 =?utf-8?B?Y00rckJ2SmNQUGtPS1NVblVwblhEU013SEJFTEswRjV1NWRPM1VEOFMvSUJV?=
 =?utf-8?B?dUhzNVhLb3Zlb045K1JjOVEydlBJTjJrTlFXd1lSc2JFNm1DV1lKamZWQUpF?=
 =?utf-8?B?T0lsSzZaVUw5Q29paTRwMmxJNm52SlMycXpqRXRrZFZZdHUrWTdwWHJBMkh4?=
 =?utf-8?B?ZkMyUlhkclA2QTFJWWpjK0FaU3M0RGVDYzZRN0E0eWd5b01Ed0N1alB0bjNk?=
 =?utf-8?B?QTk4Y0ZPNFNjRXlqNmlEQklQV1Q3SU9vUWVmTnkyaDVxTHFTWis2eVN5a2lS?=
 =?utf-8?B?ZjNENXFPampTcnptNUJlajNoVk43ejFYS25wWHpDRnB5VDJ6T2JIZjA4eUFG?=
 =?utf-8?B?aEd4NDVOZmRxMVkwOEhYb1Q0ZU14ekQ0OUtJQ0N4WEFMZEpNVnRreVZyQXFh?=
 =?utf-8?B?SDV0ZXJXSW1jUzMvRnVOekZnOHR4Rm8rV1creHVsdnc5UU1RWFo2REVTSEZt?=
 =?utf-8?B?aTU1S3VFZzUxdU5wbkJaUCtsRDYzNDdWVlV5Y1lZSzd6eW5ZaGRCdzhMSisv?=
 =?utf-8?B?d3ZEOXpZRitRWlFwdjhnbmEyQldCbk5WM0ZtVHJWSDJrUks5cHF0a2NyYUZH?=
 =?utf-8?B?V3NGU0thV21vQmUwL1M0MFJFNEZ2MmZGQ2c5TXNBRGVIZFB3cjJSN3pMMHpH?=
 =?utf-8?B?NU9CMTFEa0xCMklIemVIcE1jWEt4T25Yall0bFFWbmNtTzhYdTluNTB3Qk1l?=
 =?utf-8?B?dEcraUJSQTJBTTlQNTdqVlEzVnRQTGNBV2ZjaU5NR1dFVnppcktMcjZDT3l0?=
 =?utf-8?B?bXcvMldIbFg2ZlZ2ZW1pVVNIVmlwZnZpUkI3cWh1b0pDYk9SNWtOWGtPR1hj?=
 =?utf-8?B?MTB5cFA0djFyZ3J1elN5S08xSEt4VVVIYU1hTDRwZ0grc2FMZGY2eDlsMHd5?=
 =?utf-8?B?TWJkME5oV2pDcStDelFFZmtCZW4vWjJoWUx3ejcrN0VUMUNVTXNGWjZ3UHZk?=
 =?utf-8?B?Uk5FLzFaYVhiQTlTMEVjM2h0cFkvMFZ6aVdQZ1I2VVpRY2lYL21LeDdPQVZq?=
 =?utf-8?B?bmpEclNLYVF3KzVEZncvYm1qQTN4ZWNBNkE1ZG5LaFBFZ0dhWjdaZTdPQnlH?=
 =?utf-8?B?UW15dk8yMEp5UHdlaVphTTJpQThBTEJ6OWRoTHRqZ01EUEx2QmExV2dOVVhj?=
 =?utf-8?B?Ylh4NTVFQk0rT05JTGpvcDVyRUtvaEVnUCtFZStZRWtiWmNkNHA5STMvN01i?=
 =?utf-8?B?ZmYvSmtWYVFKYjJBb2J5TXVRMkt5YVRJdXRtK2h2RmxITUxYcW1TMFQ2WFE1?=
 =?utf-8?B?aWxqNkxMc2V1R2lRNCtmM0I5QkNnKy9JWWpNU3BHQ3BDa2FydU51aGJ0Zk1z?=
 =?utf-8?B?a1k0cktERU9QK0k5NmR6YjZIbWk0NG9KV1ZLYWk1V0FEZVJweURIL09WVGdj?=
 =?utf-8?B?N2lXTElhMVRLMkJYOWFSbnMreENUYTFuRXdybjJCMldXVnE1OHN0ZnNkejk5?=
 =?utf-8?B?YS82WjdUTndTVXh2WEpMcGF5WXpGTHBwM05FL3RHNU4yelh6Ym9YZEhTVFAy?=
 =?utf-8?B?Z0t2SUNwcUN4M0dOM1RkbEVydzJUOHVpVUFRWHRydldSOFdoRGhhSTlzVUNL?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69E60765D61AF5419416F373FD98B487@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ef56fa-88a4-4a8e-8e96-08d9f5dd1425
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 08:26:52.3113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uPpUu2v6r6krlywkiJChARx8TfOENbJE/KsIH4qROKSlL1oBBx72M27je0KTCTLf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2401
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: g8uZL9V35_PPzOheoOiH5MovCHle5jRc
X-Proofpoint-ORIG-GUID: g8uZL9V35_PPzOheoOiH5MovCHle5jRc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=832
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202220047
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTAyLTIxIGF0IDE4OjAwICswMDAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToK
PiBPbiAyLzIxLzIyIDE0OjE2LCBEeWxhbiBZdWRha2VuIHdyb3RlOgo+ID4gSW4gcmVhZC93cml0
ZSBvcHMsIHByZWluY3JlbWVudCBmX3BvcyB3aGVuIG5vIG9mZnNldCBpcyBzcGVjaWZpZWQsCj4g
PiBhbmQKPiA+IHRoZW4gYXR0ZW1wdCBmaXggdXAgdGhlIHBvc2l0aW9uIGFmdGVyIElPIGNvbXBs
ZXRlcyBpZiBpdCBjb21wbGV0ZWQKPiA+IGxlc3MKPiA+IHRoYW4gZXhwZWN0ZWQuIFRoaXMgZml4
ZXMgdGhlIHByb2JsZW0gd2hlcmUgbXVsdGlwbGUgcXVldWVkIHVwIElPCj4gPiB3aWxsIGFsbAo+
ID4gb2J0YWluIHRoZSBzYW1lIGZfcG9zLCBhbmQgc28gcGVyZm9ybSB0aGUgc2FtZSByZWFkL3dy
aXRlLgo+ID4gCj4gPiBUaGlzIGlzIHN0aWxsIG5vdCBhcyBjb25zaXN0ZW50IGFzIHN5bmMgci93
LCBhcyBpdCBpcyBhYmxlIHRvCj4gPiBhZHZhbmNlIHRoZQo+ID4gZmlsZSBvZmZzZXQgcGFzdCB0
aGUgZW5kIG9mIHRoZSBmaWxlLiBJdCBzZWVtcyBpdCB3b3VsZCBiZSBxdWl0ZSBhCj4gPiBwZXJm
b3JtYW5jZSBoaXQgdG8gd29yayBhcm91bmQgdGhpcyBsaW1pdGF0aW9uIC0gc3VjaCBhcyBieSBr
ZWVwaW5nCj4gPiB0cmFjawo+ID4gb2YgY29uY3VycmVudCBvcGVyYXRpb25zIC0gYW5kIHRoZSBk
b3duc2lkZSBkb2VzIG5vdCBzZWVtIHRvIGJlIHRvbwo+ID4gcHJvYmxlbWF0aWMuCj4gPiAKPiA+
IFRoZSBhdHRlbXB0IHRvIGZpeCB1cCB0aGUgZl9wb3MgYWZ0ZXIgd2lsbCBhdCBsZWFzdCBtZWFu
IHRoYXQgaW4KPiA+IHNpdHVhdGlvbnMKPiA+IHdoZXJlIGEgc2luZ2xlIG9wZXJhdGlvbiBpcyBy
dW4sIHRoZW4gdGhlIHBvc2l0aW9uIHdpbGwgYmUKPiA+IGNvbnNpc3RlbnQuCj4gPiAKPiA+IENv
LWRldmVsb3BlZC1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgo+ID4gU2lnbmVkLW9m
Zi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgo+ID4gU2lnbmVkLW9mZi1ieTogRHls
YW4gWXVkYWtlbiA8ZHlsYW55QGZiLmNvbT4KPiA+IC0tLQo+ID4gwqAgZnMvaW9fdXJpbmcuYyB8
IDgxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KPiA+IC0t
LS0tCj4gPiDCoCAxIGZpbGUgY2hhbmdlZCwgNjggaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25z
KC0pCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9mcy9pb191cmluZy5jIGIvZnMvaW9fdXJpbmcuYwo+
ID4gaW5kZXggYWJkOGM3Mzk5ODhlLi5hOTUxZDA3NTQ4OTkgMTAwNjQ0Cj4gPiAtLS0gYS9mcy9p
b191cmluZy5jCj4gPiArKysgYi9mcy9pb191cmluZy5jCj4gPiBAQCAtMzA2NiwyMSArMzA2Niw3
MSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgaW9fcndfZG9uZShzdHJ1Y3Qga2lvY2IKPiA+ICpraW9j
Yiwgc3NpemVfdCByZXQpCj4gCj4gWy4uLl0KPiAKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGZhbHNlOwo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gLcKgwqDCoMKgwqDC
oMKgcmV0dXJuIGlzX3N0cmVhbSA/IE5VTEwgOiAma2lvY2ItPmtpX3BvczsKPiA+ICvCoMKgwqDC
oMKgwqDCoCpwcG9zID0gaXNfc3RyZWFtID8gTlVMTCA6ICZraW9jYi0+a2lfcG9zOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgcmV0dXJuIGZhbHNlOwo+ID4gK30KPiA+ICsKPiA+ICtzdGF0aWMgaW5saW5l
IHZvaWQKPiA+ICtpb19raW9jYl9kb25lX3BvcyhzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgc3RydWN0
IGtpb2NiICpraW9jYiwgdTY0Cj4gPiBhY3R1YWwpCj4gCj4gVGhhdCdzIGEgbG90IG9mIGlubGlu
aW5nLCBJIHdvdWxkbid0IGJlIHN1cnByaXNlZCBpZiB0aGUgY29tcGlsZXIKPiB3aWxsIGV2ZW4g
cmVmdXNlIHRvIGRvIHRoYXQuCj4gCj4gaW9fa2lvY2JfZG9uZV9wb3MoKSB7Cj4gwqDCoMKgwqDC
oMKgwqDCoC8vIHJlc3Qgb2YgaXQKPiB9Cj4gCj4gaW5saW5lIGlvX2tpb2NiX2RvbmVfcG9zKCkg
ewo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIShmbGFncyAmIENVUl9QT1MpKTsKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsKPiDCoMKgwqDCoMKgwqDCoMKgX19pb19raW9j
Yl9kb25lX3BvcygpOwo+IH0KPiAKPiBpb19raW9jYl91cGRhdGVfcG9zKCkgaXMgaHVnZSBhcyB3
ZWxsCgpHb29kIGlkZWEsIHdpbGwgc3BsaXQgdGhlIHNsb3dlciBwYXRocyBvdXQuCgo+IAo+ID4g
K3sKPiA+ICvCoMKgwqDCoMKgwqDCoHU2NCBleHBlY3RlZDsKPiA+ICsKPiA+ICvCoMKgwqDCoMKg
wqDCoGlmIChsaWtlbHkoIShyZXEtPmZsYWdzICYgUkVRX0ZfQ1VSX1BPUykpKQo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDC
oGV4cGVjdGVkID0gcmVxLT5ydy5sZW47Cj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoYWN0dWFsID49
IGV4cGVjdGVkKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsKPiA+
ICsKPiA+ICvCoMKgwqDCoMKgwqDCoC8qCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBJdCdzIG5vdCBk
ZWZpbml0ZWx5IHNhZmUgdG8gbG9jayBoZXJlLCBhbmQgdGhlCj4gPiBhc3N1bXB0aW9uIGlzLAo+
ID4gK8KgwqDCoMKgwqDCoMKgICogdGhhdCBpZiB3ZSBjYW5ub3QgbG9jayB0aGUgcG9zaXRpb24g
dGhhdCBpdCB3aWxsIGJlCj4gPiBjaGFuZ2luZywKPiA+ICvCoMKgwqDCoMKgwqDCoCAqIGFuZCBp
ZiBpdCB3aWxsIGJlIGNoYW5naW5nIC0gdGhlbiB3ZSBjYW4ndCB1cGRhdGUgaXQKPiA+IGFueXdh
eQo+ID4gK8KgwqDCoMKgwqDCoMKgICovCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocmVxLT5maWxl
LT5mX21vZGUgJiBGTU9ERV9BVE9NSUNfUE9TCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgJiYgIW11dGV4X3RyeWxvY2soJnJlcS0+ZmlsZS0+Zl9wb3NfbG9jaykpCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuOwo+ID4gKwo+ID4gK8KgwqDCoMKgwqDC
oMKgLyoKPiA+ICvCoMKgwqDCoMKgwqDCoCAqIG5vdyB3ZSB3YW50IHRvIG1vdmUgdGhlIHBvaW50
ZXIsIGJ1dCBvbmx5IGlmIGV2ZXJ5dGhpbmcKPiA+IGlzIGNvbnNpc3RlbnQKPiA+ICvCoMKgwqDC
oMKgwqDCoCAqIHdpdGggaG93IHdlIGxlZnQgaXQgb3JpZ2luYWxseQo+ID4gK8KgwqDCoMKgwqDC
oMKgICovCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocmVxLT5maWxlLT5mX3BvcyA9PSBraW9jYi0+
a2lfcG9zICsgKGV4cGVjdGVkIC0KPiA+IGFjdHVhbCkpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmVxLT5maWxlLT5mX3BvcyA9IGtpb2NiLT5raV9wb3M7Cj4gCj4gSSB3b25k
ZXIsIGlzIGl0IGdvb2QgZW5vdWdoIC8gc2FmZSB0byBqdXN0IGFzc2lnbiBpdCBjb25zaWRlcmlu
ZyB0aGF0Cj4gdGhlIHJlcXVlc3Qgd2FzIGV4ZWN1dGVkIG91dHNpZGUgb2YgbG9ja3M/IHZmc19z
ZWVrKCk/CgpObyBJIGRvIG5vdCB0aGluayBzbyAtIGluIHRoZSBjYXNlIG9mIG11bHRpcGxlIHIv
dyB0aGUgc2FtZSB0aGluZyB3aWxsCmhhcHBlbiwgZXZlbiB3aXRoIG5vIHZmc19zZWVrKCkuCgo+
IAo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgLyogZWxzZSBzb21ldGhpbmcgZWxzZSBtZXNzZWQg
d2l0aCBmX3BvcyBhbmQgd2UgY2FuJ3QgZG8KPiA+IGFueXRoaW5nICovCj4gPiArCj4gPiArwqDC
oMKgwqDCoMKgwqBpZiAocmVxLT5maWxlLT5mX21vZGUgJiBGTU9ERV9BVE9NSUNfUE9TKQo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG11dGV4X3VubG9jaygmcmVxLT5maWxlLT5m
X3Bvc19sb2NrKTsKPiA+IMKgIH0KPiAKPiBEbyB3ZSBldmVuIGNhcmUgYWJvdXQgcmFjZXMgd2hp
bGUgcmVhZGluZyBpdD8gRS5nLgo+IHBvcyA9IFJFQURfT05DRSgpOwoKSSB0aGluayBzbyAtIGlm
IEkgcmVtb3ZlIGFsbCB0aGUgbG9ja3MgdGhlIHRlc3QgY2FzZXMgZmFpbC4KCj4gCj4gPiDCoCAK
PiA+IC3CoMKgwqDCoMKgwqDCoHBwb3MgPSBpb19raW9jYl91cGRhdGVfcG9zKHJlcSwga2lvY2Ip
Owo+ID4gLQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldCA9IHJ3X3ZlcmlmeV9hcmVhKFJFQUQsIHJl
cS0+ZmlsZSwgcHBvcywgcmVxLT5yZXN1bHQpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmICh1bmxp
a2VseShyZXQpKSB7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGtmcmVlKGlv
dmVjKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpb19raW9jYl9kb25lX3Bv
cyhyZXEsIGtpb2NiLCAwKTsKPiAKPiBXaHkgZG8gd2UgdXBkYXRlIGl0IG9uIGZhaWx1cmU/Cj4g
Cj4gWy4uLl0KPiAKPiA+IC3CoMKgwqDCoMKgwqDCoHBwb3MgPSBpb19raW9jYl91cGRhdGVfcG9z
KHJlcSwga2lvY2IpOwo+ID4gLQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldCA9IHJ3X3ZlcmlmeV9h
cmVhKFdSSVRFLCByZXEtPmZpbGUsIHBwb3MsIHJlcS0+cmVzdWx0KTsKPiA+IMKgwqDCoMKgwqDC
oMKgwqBpZiAodW5saWtlbHkocmV0KSkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZ290byBvdXRfZnJlZTsKPiA+IEBAIC0zODU4LDYgKzM5MTIsNyBAQCBzdGF0aWMgaW50IGlv
X3dyaXRlKHN0cnVjdCBpb19raW9jYiAqcmVxLAo+ID4gdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdz
KQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0ID86IC1FQUdB
SU47Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gwqAgb3V0X2ZyZWU6Cj4gPiArwqDCoMKgwqDC
oMKgwqBpb19raW9jYl9kb25lX3BvcyhyZXEsIGtpb2NiLCAwKTsKPiAKPiBMb29rcyB3ZWlyZC4g
SXQgYXBwZWFycyB3ZSBkb24ndCBuZWVkIGl0IG9uIGZhaWx1cmUgYW5kCj4gc3VjY2Vzc2VzIGFy
ZSBjb3ZlcmVkIGJ5IGtpb2NiX2RvbmUoKSAvIC0+a2lfY29tcGxldGUKPiAKPiA+IMKgwqDCoMKg
wqDCoMKgwqAvKiBpdCdzIHJlcG9ydGVkbHkgZmFzdGVyIHRoYW4gZGVsZWdhdGluZyB0aGUgbnVs
bCBjaGVjayB0bwo+ID4ga2ZyZWUoKSAqLwo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChpb3ZlYykK
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga2ZyZWUoaW92ZWMpOwo+IAoK
