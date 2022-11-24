Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6C16375FE
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 11:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKXKOR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 05:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiKXKOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 05:14:16 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91306C0503
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:14:15 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO4TuPq022894
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:14:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=rAEnfc3nATW5ABhXApnzODB4MrabXPcWC3PqNdbyI9g=;
 b=aEMoJr2GR2Zj/2Ea7XqmY4P1d6zAc3DhbK7yQDY3uZIc0NoqUWN0cTyTXc7mNCFPVOxV
 hSr+MNp76joFMjcK4CV5cqB5iyPRXDHeFb6chhsJ7UuIdtWKlZDMm5aHOyVhVncN8Wmg
 aTY1i24o8nplukWuezubbY2umVUvVwjA7sXwZmSZ4MUzLtOAJA9oWyuTT1jpx7f8HYbB
 foBQmj/ueZ3fx61eTcl7ZWJJDw39qFriM10oBwyF36YOeNlY0SWh+YxS4/XXZEwOEMcS
 0fWJ95nisAstHrquEwiBOklqHyR2QjmDjOWO0fwMu4xqDFHgGKi6YN+SqtgbOCKaoIhj fA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1n88ebh2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FM8EAmLD6P/gmw1QYIs9xUSGXzC9KlT40Agl0kfpRAUobVDb7Muqu3ignm+leu3/pq+f8n88hMm7OvK5Z9EXfpaXIpPK0xz9ps13PSca3a/O5dIFnlR8WuKOtbfhhIjt+HhmKhmKNC2XYqBcr32uYr9nWxhEYtwYl98rtapvTiYLTetgcvPUtYQg0WZxF+ZWn5V8hKgjyle4PAxstfZDkoHqwYEKMZdrhLeQyQv93DCbovKWczZ4y/eBhqVgUJTMt2TFOeU++MxPPulDec80oFNN/kYMpjKQ7yGE4k2+VLX2d/zn4c6cj8KC8GfviviYaufWQSEB/LTXnG2pEwsmYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAEnfc3nATW5ABhXApnzODB4MrabXPcWC3PqNdbyI9g=;
 b=ZT9uzyOs4wBTZ5mcE9PEohdqnh/7GXcm6z/YBvXb8gQ6OceCFQ0wZUMmiCJ7NS08kI2YZcDa4Qf7xMEwgoxqa43jcCh/gJznoyqhje5W7VL9JMeClQHwNm6J7KVhv7QVNCsyT3K5AWl5WHgowg0nT2awKrf8iUAJxy9fXqjHetwV2rjSYdul28awPipk5rABji9LLnco7U7gIqi6DW7iQfKln3lHGSl727mTxohbeSZILoGjBTBMLmAM4sVdEZBVKOxfET2C//r5kQF5xvGd338gWNkXA7GKzl9pfOKmTy92JXMfqJ84h+QbeglD8jUHfNFy11IbnOiKx7XLTTYBYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MW5PR15MB5121.namprd15.prod.outlook.com (2603:10b6:303:196::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 10:14:10 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5b6d:c9b7:796a:8300]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5b6d:c9b7:796a:8300%7]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 10:14:09 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "gilang4321@gmail.com" <gilang4321@gmail.com>,
        "gwml@vger.gnuweeb.org" <gwml@vger.gnuweeb.org>,
        "alviro.iskandar@gnuweeb.org" <alviro.iskandar@gnuweeb.org>,
        "kiizuha@gnuweeb.org" <kiizuha@gnuweeb.org>,
        "kernel@vnlx.org" <kernel@vnlx.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing v1 1/7] liburing.h: Export
 `__io_uring_flush_sq()` function
Thread-Topic: [PATCH liburing v1 1/7] liburing.h: Export
 `__io_uring_flush_sq()` function
Thread-Index: AQHY/9r3MZg+cCjhAECpZWhyfSIURK5N20WA
Date:   Thu, 24 Nov 2022 10:14:09 +0000
Message-ID: <f750be65c33e5d3a782cebf85954319caa77672f.camel@fb.com>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
         <20221124075846.3784701-2-ammar.faizi@intel.com>
In-Reply-To: <20221124075846.3784701-2-ammar.faizi@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|MW5PR15MB5121:EE_
x-ms-office365-filtering-correlation-id: 43e10a46-e609-4476-1080-08dace04a0bf
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2rxrxGAJbmXTtaOMyfxv+J3dpYVX3VVr7T5oVVi0UZAjZdpTqxYP5rK5TCrl22g0bti72wpJCm2FB1YIWcM4pxO0nBex2KVrdVcduJ7poI+klAliEGjzNDlVOWTS+I0UTWw14eOHJy3Vv6qnTUVVr/1D4gHZz07ranoVX3SwHe5LozAa2BL1FcbR2wZzAzBzd+W+8Pj8wxUDFk0bTXAAJepNNlz3dSHEOECNUv1uoc+y4mz7Zx51Jn1zggiLnEwsQMqL/m3UTW9K0IhfYOWQuKzxUL1ekwFore8Owx4dcVC7xBMGiw7ITR2/pDXgGG9ZbITfOmLKPefcX+dX25Cq+RgdgnS/F/65ZVXTHBgPTHyn9olwDzxl4QqcOLSI2UlzxBFLilrqW7MZJgmblS0aF5D9Se4sNCbgl8F6jHldAza3dPp4m6bHzwq/q/rsJYEc9oXnMKaSkd0DcXbGqUopEzkxIj4jdoB4SA3CkcoIPhJBvWWvfnann+oICR4cCp2N1jzN4R9KEPg+MW9Km+klBCtoNGF8iz/fluKEFGU4yugQlSbGHsDDgpncszmlAwSXAIxzxFYhtEJ2Mu7Tzp+8oWCcq4rYoqY0y1tP5XKSZ0ZeE9FwCMpMbagAXFhOCH0g0ixjl5Le+E5Fwm2qtmawpr35AXlKfIVkTF7iZvYm6bEkrwKq/0EpU3cIct7d6uAFE3+eZUdLYQFJgdGJgDvHxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(2906002)(4744005)(4001150100001)(36756003)(5660300002)(8936002)(41300700001)(9686003)(6512007)(91956017)(186003)(6506007)(86362001)(76116006)(4326008)(8676002)(66476007)(66946007)(64756008)(66446008)(66556008)(110136005)(54906003)(316002)(38070700005)(71200400001)(122000001)(38100700002)(6486002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVd1czY3QWlWR1pZYXhoQzlqMGdwaUEzTUw2TGJxNUJ4MFNTOHRGaUZ0K0Ro?=
 =?utf-8?B?NEpGYzdndjRUWWtDRlJZWXBLSTdkNDR3a21mWUlsZ25DQldSZ3lReEwyWEhk?=
 =?utf-8?B?SjRldVFqcGNVbEptZkxoRlVYSk1PaDlIaVpjRUlSRVVXOU9ZTHNnekwxNjN0?=
 =?utf-8?B?ZDdEbS9WYXVOT0NBU3ppcHlHaHdIMjl5eVY4Y0hISHFrSUsxYnNiK3NXd05L?=
 =?utf-8?B?WHJPSmsrVkNpY3FEUmZuOUgvc09BV0w1aEp4ak1sVUlqdkNkcGE0M2lYVVJY?=
 =?utf-8?B?V0dHV2szWUswSjkrOExzM09RWTIrSGYvWXo1clVNamZPaysyZGwxZWRsSTR0?=
 =?utf-8?B?ZUUyY0t4NFJSd1k1bzRBdk02V3JKNXNtUDdCeGpWY2lQUlliVjhtam5rQ0Jx?=
 =?utf-8?B?b0NONVk5bitGK2J5VndqRjFyZnZuVUgyRUVPanozNi9YNVR5OXdEeldXZU5t?=
 =?utf-8?B?Sk03cGRTSmZlakRXNkVtWTZVY0RrdjgzOGQvb2tWSHdZMlNtd3NhN1RSL3VG?=
 =?utf-8?B?WStOL0ZNcHJBQm5FUk5BeTkyMmJwTW1OSTdKdWlNcHFyZlF5N1k4SWpSTmwv?=
 =?utf-8?B?LzFZYzR3bW1VVi9oWWxPRThaN1ZDRFhENmhQL0ZnSHJtVmV2YTB0UVpPT2NT?=
 =?utf-8?B?Vmp2cDBVZGgwOXo4MzIyU21FTEFuK2VVTnZWZlF0WEc4QmZaSXBDOVoyVFBQ?=
 =?utf-8?B?RWx0VWQrM3NqMjd3VkFJaTdrc3FsVEZCVHZMd2ZEamRwRUIvdmlrdW1laEt6?=
 =?utf-8?B?dkJGRmxRZk9ZTnhyWStma3N0RHJKRmVxaTRvbkgvbUJidy94V3I2azExaWg2?=
 =?utf-8?B?S3ExSm1MVmRQdDdCY21wU1A5Wk9CK1ZpckJoT01pUUhoaFpkYUYwUUlGdVpB?=
 =?utf-8?B?anc2ZCtOQk9zT2JLOGlLU3dhWW1DdTlPN3ltR3dIYkN2WUtPZ3p5aEwraVFE?=
 =?utf-8?B?MXAwYWhyaSt6RVNEbzBBNGNBUmVIOFYwMUpSYVR4MEVjdHdhVy9IUGpNTDVP?=
 =?utf-8?B?WkNxZ0dxZHNESkg3aUd2bm5pVjlUbzlaWFdmN1lmNlZhSVRSZGtIbUloWlFw?=
 =?utf-8?B?MVhUclhtQlJBT2RrT21iNms1V0JJS0pWY1J6UGpZNVVVMk41R2hXeGl0cDFi?=
 =?utf-8?B?TEkrUXJaT0JXamllcFJCOG9SMjlzNGkyQ3VSd1dNaDdKVmtvbTh2RUdrSHNq?=
 =?utf-8?B?MFVWRGx3SmZkRTNZamVKT2xZNmdETFQ0OEtucmQzYnhhaTd2c2h3UjZVZUp3?=
 =?utf-8?B?aUNRbERNYnFneXBJYmliZ0VjTHB2MjRuQ3poTUo2UUQxV0dEaGRJV0lCZkxM?=
 =?utf-8?B?R3hsOFoyQVdWeUNMeWNSSGpyMkVBSUYrM1pBQnA2Ni9GL2tkSWI1Nk12ajVU?=
 =?utf-8?B?enQ1VnlOa1ZYRDBTY2RhaERFd01BcmF5dzlIeGt0bFRFNkNzcnd3cVV0T0N6?=
 =?utf-8?B?aFBsK1dLbkJrc0kxeWVyQTMvRFd4WmNibkFFVmFFMmVQSEJFZzlTdmFjNzVk?=
 =?utf-8?B?MXl4ZDVQbk91UmZYck1IdG1hZzMzR3UvM3lFaE9pSVN4blJwc2x0cjY0dVhs?=
 =?utf-8?B?S085TnhZSlV6emZQT2lVdFFBaE5kRUw3SVpzL2x0UllRUGxnMVBuQjk4N09n?=
 =?utf-8?B?bTRFYzRrRDE2ZEoxWGtVaWFFaGRlMVhRVlZzQnNtL3RTazJzdkxNbW5ZK0Zk?=
 =?utf-8?B?OTh0aEg3T01HS0VPWmNkYkVCMDREVEpsZVR1UjU2UHpQMW5Cc1FvUUNkQ1lH?=
 =?utf-8?B?TFJQRyswNDVWWXdhYW1vMUIvVmhPaTRKTkdscEFHZ21MN0ViTXk5Smp6bVAz?=
 =?utf-8?B?MmNBOWxvenFtQXZKUUVIOEZtdit3OVZtM2pIOTc2SEpDRDRBRG80TENmWWNZ?=
 =?utf-8?B?WGhmTGNTVEh4MWdSQ1hQa1J3NmJNWUUzaEtRZWIzRElRTlhpNk1JYWpQMlRB?=
 =?utf-8?B?bEpXeTMzUHJQSGl5K3ZZbVNENjFtT3ZoRTB4eTVlZzdhWGJzL1c1QTRXaVJu?=
 =?utf-8?B?anNTWmtRMFpKdW5aUzNETG84NHdSN0RnVFM3SDRBUzVyM3ZUWFIzcjFCeTcw?=
 =?utf-8?B?anVnNG44WEl6bkgxT2lDbk1sUFVuS1hMZnY0NG5vRG4zM1JBU2J6SXFzYzRr?=
 =?utf-8?B?aEZETTJtamxuL3V5eXY0dDFqNjJaN1JSc1preGZYL3ZIQ1E0ZGFMUHZ3WXRJ?=
 =?utf-8?B?Qnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE60B310E4A9E24EAB0CD6D6FB21E86F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e10a46-e609-4476-1080-08dace04a0bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 10:14:09.7945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6HrLJKfq5UoNU7H21srWftz+QYlQz0H/Nn3RdMG3N16pbPMJ0gHdrRcjtrYmRs6C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5121
X-Proofpoint-GUID: ysTc1lEF9RSXNudGnserJ9hocgVSj_Qx
X-Proofpoint-ORIG-GUID: ysTc1lEF9RSXNudGnserJ9hocgVSj_Qx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTI0IGF0IDE1OjAwICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
RnJvbTogQW1tYXIgRmFpemkgPGFtbWFyZmFpemkyQGdudXdlZWIub3JnPg0KPiANCj4gY2xhbmcg
c2F5czoNCj4gDQo+IMKgIHF1ZXVlLmM6MjA0OjEwOiBlcnJvcjogbm8gcHJldmlvdXMgcHJvdG90
eXBlIGZvciBmdW5jdGlvbiBcDQo+IMKgICdfX2lvX3VyaW5nX2ZsdXNoX3NxJyBbLVdlcnJvciwt
V21pc3NpbmctcHJvdG90eXBlc10gXA0KPiDCoCB1bnNpZ25lZCBfX2lvX3VyaW5nX2ZsdXNoX3Nx
KHN0cnVjdCBpb191cmluZyAqcmluZykNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgXg0KPiDCoCBx
dWV1ZS5jOjIwNDoxOiBub3RlOiBkZWNsYXJlICdzdGF0aWMnIGlmIHRoZSBmdW5jdGlvbiBpcyBu
b3QNCj4gaW50ZW5kZWQgXA0KPiDCoCB0byBiZSB1c2VkIG91dHNpZGUgb2YgdGhpcyB0cmFuc2xh
dGlvbiB1bml0IFwNCj4gwqAgdW5zaWduZWQgX19pb191cmluZ19mbHVzaF9zcShzdHJ1Y3QgaW9f
dXJpbmcgKnJpbmcpDQo+IA0KPiBUaGlzIGZ1bmN0aW9uIGlzIHVzZWQgYnkgdGVzdC9pb3BvbGwu
YywgdGhlcmVmb3JlLCBpdCBjYW4ndCBiZQ0KPiBzdGF0aWMuDQo+IEV4cG9ydCBpdC4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEFtbWFyIEZhaXppIDxhbW1hcmZhaXppMkBnbnV3ZWViLm9yZz4NCj4g
LS0tDQo+IMKgc3JjL2luY2x1ZGUvbGlidXJpbmcuaCB8IDEgKw0KPiDCoHNyYy9saWJ1cmluZy5t
YXDCoMKgwqDCoMKgwqAgfCA1ICsrKysrDQo+IMKgMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKykNCj4gDQoNCkkgdGhpbmsgY2hhbmdpbmcgdGhlIHRlc3RzIHRvIHVzZSB0aGUgcHVibGlj
IEFQSSBpcyBwcm9iYWJseSBiZXR0ZXINCnRoYW4gZXhwb3J0aW5nIHRoaXMgZnVuY3Rpb24uIEkg
ZG9uJ3QgYmVsaWV2ZSBpdCBoYXMgbXVjaCBnZW5lcmFsIHVzZT8NCg0KRHlsYW4NCg==
