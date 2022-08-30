Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD315A5CD7
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 09:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiH3HXu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 03:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiH3HXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 03:23:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AADDC7F92
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 00:23:33 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27U3COBq023293
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 00:23:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sQnOVRFroF6z7JyNFyCzjeipYQlGVyIV2JzntQwOLg4=;
 b=G9gV4A3jYxUsg8mKhDfRx8hl3wUfX4zIS1SFmP5Rvnnlfi9jV/deofRMyILDDXnEaEiu
 wdVEhDD8Ue+fWFSqY/wcyes6rxv5SLVgOhMOpao+dcPjVeaMbaD+aAR8gFCQ2KHqSzxb
 OFbXd+XOdsoxJkk87tARqRJx4BNOYLxzD4Y= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j9ae48td5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 00:23:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXkl+lq9KUvw+C+KAHb874jxODyUP/MkAqH3i8JwaCBqTLWbtiHo6GlYqkE5N/gRgWSKvXmXNajdinTmJ9MTApf3gSN5WTDPQkWwXiKKQQn4hK+z6PM3MkexshqLSFgZZ8VbBENOklbujLj0k5KJxbMqe1/p+9mfrvq6hErrRG3q26Pmhcx2daN+uSmEDi3e0mj73/lI/aUy0ljDNdySIQ7KA6qkxutjB4SodEKAFJTCHV+V0hkVTYaFgqvPiAkYmB9ZiQk5/PB3TxCjjoo0ABw8MHhOXg5/3Rc+YeCNHA1Q4GXl2zamSAOKsuJLbZnlWOCN7cb/db6p3Gg4hJBnjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQnOVRFroF6z7JyNFyCzjeipYQlGVyIV2JzntQwOLg4=;
 b=SYMzrt3/m1kfXAuj4E/wiiPaWKLgU0v5alBXaAJCWJIyjIRBAmBbT6ZVpST9ZNU72Pc48SxhgUa3cA7igRISlrc3bsmztzSHaqzXZxfOElo+E1uIM/WZUj1UeJ2Qcms7H55P5Pj4iBQgOvfhoj5EeE5AK8366x8sd7Ryfhq2mnvoNb2rmEH4b/0E+MjoFzA+0BgVwOqYt79x2JjJ+1/ucbH5cnYXggfz8kgIJgMtjBnmKx4IgcdmWepv1MjiwxvmVHQXgl++8kSfnXvo9EZgD9zP9qUcB01f9N9VbJnFzIF+DvL/cZ00cz11d+h6NVjXEwPvEEvBRWrRWezSVlEI6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM5PR15MB1674.namprd15.prod.outlook.com (2603:10b6:3:127::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 07:23:29 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 07:23:29 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "hao.xu@linux.dev" <hao.xu@linux.dev>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Thread-Topic: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Thread-Index: AQHYs8YZgYIjfx1FPk+KZcivvCe6gK26zqQAgAqsIICAAaB9gA==
Date:   Tue, 30 Aug 2022 07:23:29 +0000
Message-ID: <c708e882393f3e9ae0e90f368d941868325f1cf1.camel@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
         <20220819121946.676065-5-dylany@fb.com>
         <d3ad2512-ab06-1a56-6394-0dc4a62f0028@gmail.com>
         <370dd3d4-1f54-279c-3d6a-8c9f8473a80a@linux.dev>
In-Reply-To: <370dd3d4-1f54-279c-3d6a-8c9f8473a80a@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 386ead48-1b13-4395-ef62-08da8a5889aa
x-ms-traffictypediagnostic: DM5PR15MB1674:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l5cEPcBjjWcbMQPflLG63iI/DWd3kaeXmEIqaNbzDMZcerhTKtP9dIakrKFD8ZPHjw1Q6zG0EqK5/8JZfAfbP7TCzqAdmKyB5LrMWdr7J+B8g3vN8pGPK9cBhizJBzN6JzaimC8dbRVEw7MwiEeU6/Lqv6WLoKjc0W3uYihQ11uNY4u6dUu+VW2SYq5mYVt3Ry5V1cbEAFnrEd0x4JGR2PqTD6nC1QsDoPihQM1fFZYPG9HaRrINwXzmTFhwvTce6AdbmvD8bkuqryrzKJQr9WdScIDCNpExNVHhrGx4+Zpg6J4Lvlslu1nCYlwpAx1kg8+fFJl7x37kVmKOFPQsg5SGrPHNP0HvWzwUWnmSetv2HJweHLpiYqiGS2Kphaflf7zBVeyN047skOUObPy/3LmsmJqbwd/OUKJ7Jj6qAIpid7DPEu5gTWVouedx0KdM9RPSFrGMdkvx5j84/EsNyf+mg8rPPj9BkGUPnSEVdE6AfTmKth4awt27VKk1BcGqjN36jMvCIlvED4+5b8wLbO+L/QhtOkN934LXU80l8mTrIm3ldxB7QYFTVrRyNs5XN3LZmJepH07320mV0ZGZL3b15D92yACBsKS0Sl0vQaf2yWotqAd0jlh8DlSkA80ZHbqR7b9ZQJHgVCkG4nzkfFcidZhXmm7f6L2BUlA71x9P0IkzvGw0Owlst58+tnmHsKFLSrwoSk0EsOngXmPaw+C8r8+oNg4YJ2dwCvC1ltQNjwOt7Q0vO8ctzfek5Squ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(76116006)(41300700001)(6486002)(66946007)(478600001)(66446008)(8676002)(66556008)(66476007)(4326008)(64756008)(2906002)(6506007)(5660300002)(8936002)(91956017)(6512007)(71200400001)(110136005)(316002)(38070700005)(2616005)(36756003)(86362001)(186003)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFI3L1VteUt2Wktxak9uL0VEVW1NVGt6NlFlejFjM2RaNHpkdHhta1drd2Nj?=
 =?utf-8?B?d3E0Z3dLM29qclRLdU1WR0lRdEc2c3NJbndnQXNLTTFEcWpOQ0dhK2IzS0Mw?=
 =?utf-8?B?R1MvbXR3elRaYWtGNE1aNW5HZWI4c3V4MEg0elZReXVCd1FXL3BkOE50bnVr?=
 =?utf-8?B?WUtHd1hSakNPTTdZeW1VKzBVR2JaTTZUcVVwaWdPZ1lpTGI3Ny9VQzVmeG9V?=
 =?utf-8?B?RURxdHlKREZ5U1pEcjZBMVhVaVdQZ0dmNDBlT3FkbWQ5ZnViMEZyVnc0cnlp?=
 =?utf-8?B?ZVBtYllKeFhtYm5pUGdqcUlMcEl4ektDd1BtOWVpYzc5cWNERUc2b1hwYlha?=
 =?utf-8?B?djd4ZjVUL0ViYlV3WkNWZzRMcVMzN3RvRDd6MUJoZW1HSW5hK3BQb2lJZ1hP?=
 =?utf-8?B?RHVoQWZ5NTh2dVRiMy9FRlhuR1JCeHlnZCtHRDFhUXhnK3ZmaWFVaEo2aU1J?=
 =?utf-8?B?ViszemVrbk9kTXROK1BiV1hRWmJKUGdoTE1DbmFsOGQ4SitwcEtxejlkOHhL?=
 =?utf-8?B?eWNTUXBPT1RDMHZNcGlRNDVXL1gxTEdpNjFMSWp4OStjZWtRZFVlSHlSbDhm?=
 =?utf-8?B?RWdPZ3pvMUp6WTFySnVUbnJHN1lwR3BxWEVVQ2FFTzRTTzRHRU1rLzhnd1pa?=
 =?utf-8?B?WXdMT3N3WHNxeEtJWStBOCtEZkFnNS9JS2srQjMzTFBERFd3U0xYUnBXNU5L?=
 =?utf-8?B?OXI0djdpUTFYK3ZZNHpXQ3JsdlN0dlVrLzlxaTBjb2t0eVovWGxxVnFrNFBv?=
 =?utf-8?B?Rng5OUdmZ2ZKN1BtdGNsZ2Z4Y1E2NFp0Yjh1RlI5cnlEczcwV0xRdDRNbnJx?=
 =?utf-8?B?OGYxVWw0L0RKNGU5UWRtdVdWZ052Zk5hL0FsSEVwTy9GeEJFelJ6U25RdStS?=
 =?utf-8?B?WFhUYi9NWEhxQ3pMZGkzcE9rcnVrNmRSUTgrV24wMENIYm1Fcmx3VHRDa2My?=
 =?utf-8?B?NUxPYjlCTVk4cVN5emtLaXpCV2R3VFlJOUZPa21FYmdaaDdKOTlXSW9YWjM0?=
 =?utf-8?B?UWY1em9FYW1aeWMyTjdWeStGS21ZdTQyZXZGN3NDY2R4Q0FSaFU1UXBJeHlm?=
 =?utf-8?B?bWs0SWdacG1jc05VRzcwczhNa0VGVGluY0UwUDAxWjNqdm1zNk83dWJOVVB3?=
 =?utf-8?B?WlZtdzlNL1ByODlBekhlTCtiWkdxMDJ5azB0YW9LRGhQVXpxT3dpQVkyRkZk?=
 =?utf-8?B?djRmSEdzWS83VHZHclpMQ2Z2SEk4TjFFMWJOeVYrdzVTM3VMVmYyaDdYMlc5?=
 =?utf-8?B?V25VQllZTnp5UlExcENoUm5NeUpCOGVVTmcydnNDNXJjM3lIeWF6TTQ4cE94?=
 =?utf-8?B?RmMvcGIrVFc0cjZkSTJTTm1TSUxObnE0MU5qdHhoUkNaTTc4WGk0Tyt4T3JB?=
 =?utf-8?B?eWJBbTFLWlF0WlU4U0FUTk1mTy84ZWFYaWpMc3B3T2FGRjdrS0hnSHhDY3F6?=
 =?utf-8?B?QnA2eHV0RXdJbXNnN2dWR0JQWC81TmU0WFlVR05mMlZGeTdCRVJVNWl2UmRp?=
 =?utf-8?B?b1pXcHNWN3dUWkJuL255ck1nWm9tY2NJYTdBL0JsTE0wNEFpdjdNMUZUN2w5?=
 =?utf-8?B?WDRZNm1nSGptbWI4V1NkUWJtZkQ1UkxxNFk3VnJqalNXNlpFTmxJSWpZd25p?=
 =?utf-8?B?MlJqYUlxRSs5N1Bkb0ErRCtyVVE2cjdYdExBaTJ1VW1mNWxZYVZsSGxPSnRq?=
 =?utf-8?B?K2h4SExxZnVKSHZrYmtKVnd6SlZIcVNqZy9VVWc1cHVLekd4N3JwVW4wcm5i?=
 =?utf-8?B?VkxtYVl0RjJiYThsZi93NlRNa2pIUHhEdVNUcDRCaUlMT0MycFg0WTlybnRj?=
 =?utf-8?B?Q2JQL1hIdWxKaDZwZnN2UmplNzN3emtzeXZuVHNqOGhKbmVEcnMzT1dXa29W?=
 =?utf-8?B?Z3RtSlRSQUc1aWpsdHZQTjlyelprVkRUOGZONTJXV1FlbnFUWFdITWdZREdj?=
 =?utf-8?B?ZzVjUmZ1QnpBc2E4R09HK0FKbmRHYXc0a3N1Mk8rZkh3NHVEUW1QeU9aN2Z4?=
 =?utf-8?B?QW5QZmszVXJvZzFma1FQKy8yS2k2aHNuSExKMCthbll6QndOZ3VDdVVVNThO?=
 =?utf-8?B?Vi93ejNtaHZLZkpzSFJaU0pRWm1sdFhqRUJ2aHAvUUVwajdMV281c0NsTVlQ?=
 =?utf-8?B?UkJlWU96Y2lwNjd1aFFYZFRVYUhYVXpkWENObWh6RG1HenpIbm1haXZaWFkr?=
 =?utf-8?B?MkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4319BA3D24CE284AA3121235E3ED7D5F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386ead48-1b13-4395-ef62-08da8a5889aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 07:23:29.7313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zztv5Y0G5IiCDOHHIpUMSjOlGn7kK0zwO3EHZYmS7oDC/tlO5ndwwniCgBbxIu/N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1674
X-Proofpoint-ORIG-GUID: 3BOPo6WNwfL_oXp405lC627qcrAR-XBU
X-Proofpoint-GUID: 3BOPo6WNwfL_oXp405lC627qcrAR-XBU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_02,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA4LTI5IGF0IDE0OjMyICswODAwLCBIYW8gWHUgd3JvdGU6DQo+ID4gPiBA
QCAtMzI4OSwxNyArMzQwOSwyOSBAQCBzdGF0aWMgX19jb2xkIGludA0KPiA+ID4gaW9fdXJpbmdf
Y3JlYXRlKHVuc2lnbmVkIA0KPiA+ID4gZW50cmllcywgc3RydWN0IGlvX3VyaW5nX3BhcmFtcyAq
cCwNCj4gPiA+IMKgwqDCoMKgwqAgaWYgKGN0eC0+ZmxhZ3MgJiBJT1JJTkdfU0VUVVBfU1FQT0xM
KSB7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgLyogSVBJIHJlbGF0ZWQgZmxhZ3MgZG9uJ3Qg
bWFrZSBzZW5zZSB3aXRoIFNRUE9MTCAqLw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChj
dHgtPmZsYWdzICYgKElPUklOR19TRVRVUF9DT09QX1RBU0tSVU4gfA0KPiA+ID4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSU9SSU5HX1NFVFVQX1RBU0tSVU5fRkxBRykpDQo+
ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBJT1JJTkdfU0VUVVBfVEFT
S1JVTl9GTEFHIHwNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIElP
UklOR19TRVRVUF9ERUZFUl9UQVNLUlVOKSkNCj4gPiANCj4gPiBTb3VuZHMgbGlrZSB3ZSBzaG91
bGQgYWxzbyBmYWlsIGlmIFNRUE9MTCBpcyBzZXQsIGVzcGVjaWFsbHkgd2l0aA0KPiA+IHRoZSB0
YXNrIGNoZWNrIG9uIHRoZSB3YWl0aW5nIHNpZGUuDQo+IA0KPiBzcXBvbGwgYXMgYSBuYXR1cmFs
IHNpbmdsZSBpc3N1ZXIgY2FzZSwgc2hvdWxkbid0IHdlIHN1cHBvcnQgdGhpcw0KPiBmZWF0dXJl
IGZvciBpdD8gQW5kIHN1cmVseSwgaW4gdGhhdCBjYXNlLCBkb24ndCBkbyBsb2NhbCB0YXNrIHdv
cmsNCj4gY2hlY2sNCj4gaW4gY3FyaW5nIHdhaXQgdGltZSBhbmQgYmUgY2FyZWZ1bCBpbiBvdGhl
ciBwbGFjZXMgbGlrZQ0KPiBpb191cmluZ19yZWdpc3Rlcg0KDQpJIHRoaW5rIHRoZXJlIGlzIGRl
ZmluaXRlbHkgc2NvcGUgZm9yIHRoYXQgLSBidXQgaXQncyBsZXNzIG9idmlvdXMgaG93DQp0byBk
byBpdC4NCmkuZS4gaW4gaXQncyBjdXJyZW50IGZvcm0gREVGRVJfVEFTS1JVTiByZXF1aXJlcyB0
aGUgR0VURVZFTlRTIHRvIGJlDQpzdWJtaXR0ZWQgb24gdGhlIHNhbWUgdGFzayBhcyB0aGUgaW5p
dGlhbCBzdWJtaXNzaW9uLCBidXQgd2l0aCBTUVBPTEwNCnRoZSBzdWJtaXNzaW9uIHRhc2sgaXMg
YSBrZXJuZWwgdGhyZWFkIHNvIHdvdWxkIGhhdmUgdG8gaGF2ZSBzb21lDQpkaWZmZXJlbmNlIGlu
IHRoZSBBUEkuDQoNCkFzIGFuIGlkZWEgZm9yIGEgbGF0ZXIgcGF0Y2ggc2V0IC0gcGVyaGFwcyB0
aGUgc2VtYW50aWNzIHNob3VsZCBiZSB0bw0Ka2VlcCB0YXNrIHdvcmsgbG9jYWwgYnV0IG9ubHkg
cnVuIGl0IG9uY2Ugc3VibWlzc2lvbnMgaGF2ZSBiZWVuDQpwcm9jZXNzZWQgZm9yIGEgY3R4LiBJ
IHN1c3BlY3QgdGhhdCB3aWxsIHJlcXVpcmUgc29tZSBjYXJlIHRvIGVuc3VyZQ0KdGhlIHdha2V1
cCBmbGFnIGlzIHNldCBjb3JyZWN0bHkgYW5kIHRoYXQgaXQgY2xlYW5zIHVwIHByb3Blcmx5Lg0K
DQpEeWxhbg0KDQo=
