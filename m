Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24787580F4F
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 10:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiGZInP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 04:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiGZInP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 04:43:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC2622BDA;
        Tue, 26 Jul 2022 01:43:14 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q0rlRA011124;
        Tue, 26 Jul 2022 01:43:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7zVTO92iRj0dkYBiorfWutEKRTVex/QBfCZk5nelVjI=;
 b=hCJxDQOrgEhgyDWUhF01cVWmCMaNinFKzAvarvPGAqztQWlxGiBFwlpwirlDZSn0Pjcn
 oWlHW4Dwxkb5am3ZjpHpoGiDoWQWspZ/ZsXNQ16a+Ef7U0ygsk/QxySNRf8JuUxTOUna
 aSELtaWdtF6+UG6w3RNORfKxPqafWH/zyQ4= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hhxbwn2rx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 01:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H71hbloFEDZNw5f+GnUeVoCNVlgJP6gunJ9/8YRlFtAVf2F7znM2UbS5QD2ozI4yf3xEblCaCutRBlzSbQDlTUSTX2b9VlPwtxldMDqbBI3I0sbq3tK0KgL9y6TEcvMZl8U+dhjI+vg6tPlwr4SZvFj+3Coj4rkrnOdqFn2vN60ZsTbchtpc3hlKIzo742ECA82denKpguCQJybd9ESWEi4JFthg9frzdMFZQMhT5bqHrY4eRiZxVMysqtu7ZSDsO80MH91Pw/0YWM4K2GCH4NRrOwGIE9c2I+LBcQqZcq42HoIDbvDU/DYOph1M3S8+MGFY8Dm5c1SbbUlrxsFasg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zVTO92iRj0dkYBiorfWutEKRTVex/QBfCZk5nelVjI=;
 b=I7YPZ9qqmqsGWcp7+/8HnpoHPZ9R9tzWIWmjjcgUQuS0NPmwmbUon9YlWdpoGS7HC1NLdyqAFpUI/vMgVi21a8B/fpw88QZgZt73FrQZQ7pcJLWnPcoaSW5Y8FmVJ1qju0bOPxRAafDRWIPZVAmD3g5ykR8wF1Z/BX/PSh3omZhNJUqqz4MMlvhz8dHSOPgCONDysuVNWGqQJquAJgWpYH2Z315AQcvYfIOUsjXqhEE5/1Qbd1/yX4cX1bblJbCj8SQjLAwvJnvkAZCfkUFAGTSmqrCyJjM1Z7lVBc7SEln0ZBy3ZXv7ggJom5sIM7jF5QxGy/D6ljNSJge+gPUQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MW4PR15MB4539.namprd15.prod.outlook.com (2603:10b6:303:108::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 08:43:11 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%5]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 08:43:11 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "mail.dipanjan.das@gmail.com" <mail.dipanjan.das@gmail.com>
CC:     "fleischermarius@googlemail.com" <fleischermarius@googlemail.com>,
        "its.priyanka.bose@gmail.com" <its.priyanka.bose@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Subject: Re: KASAN: use-after-free Read in __io_remove_buffers
Thread-Topic: KASAN: use-after-free Read in __io_remove_buffers
Thread-Index: AQHYnKMMh/zxMjVYwUGeiFeZyBTdAK2IqpmAgAR6mgCAAvrIAIAAPjYA
Date:   Tue, 26 Jul 2022 08:43:11 +0000
Message-ID: <bd7b1d78bf38a1b8eb5fd13c96f54066ab0f507f.camel@fb.com>
References: <CANX2M5YiZBXU3L6iwnaLs-HHJXRvrxM8mhPDiMDF9Y9sAvOHUA@mail.gmail.com>
         <e21e651299a4230b965cf79d4ae9efd1bc307491.camel@fb.com>
         <CANX2M5YXHVTZfst7h5vkPtyt-xBTn1-zsoA=XUAWztbVurioOA@mail.gmail.com>
         <CANX2M5aYZ2kj+OZHUQF78O_fZoF0Oegytx4iFKjU+mAf9JtQbA@mail.gmail.com>
In-Reply-To: <CANX2M5aYZ2kj+OZHUQF78O_fZoF0Oegytx4iFKjU+mAf9JtQbA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a01bdd2-7da2-4016-ef04-08da6ee2df38
x-ms-traffictypediagnostic: MW4PR15MB4539:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TKZ2p2aFCUwCa3EeSHvqBR8wIsR+S8RtEBwXZ7u+NuNxO1R2Lyx59rJAk9Yc9/4fI3RLLE9E4MphwOUKwaFHgXYvblgTTsPywMNy6x3WIx0o5YGXLCCdqQ5Xtha2h4e8KGmbKOHu69+0o0b0FlLu0rINbfDV8r8zhp3Cb4NEyL6jgeBigDxacZz/OBcgTFSujaNJYcY/ai1LMWFCO5mQafUqKyVYnMHFVKrmlhrbsldCqrAilFpeijr5u/fi4iKjZFu3v0lnHWrIjWBsXYC+WDb4VPdvvb0cIu2x0PhlQ6cYtpB/HrFb43YcuP4nU0p1DYHOkPGtZNhn8PeTfLDDiAYugEbkoHjko+j+czUfL3fYa6Cmkptd7NMt9mCa9/IEZBFC85mHid0A5TDNhyUZoaGYJmCpINq5F34/LFLOQ/Y5sa1aqPDX1RPIukk7BKYa78N6NGk81S5wwpsJgzQ1gcf7G7eEnNQ48Z8cIrlKPPx7KkVSP3FHawOWOSoFiiMN/NGk4tma/JaN44s5igTrysRqxqB7WjfWJ5Qek7uRmDhYWjAo4hAjRw4fF+hf1F2fRdxKi9Ik6qVV8buY1mAPK0GPwLRw0GQKzc/BXCeCwq0kzmOThX50FimOUAxo8xVes/AbA9/I9urOCZjytq6eLoXPZPIB8HSunyTTjIkDk1ZLSKgGIiAseRWaLnFe07uRCLQvzyGXHXbeyOzn+nFY2j62cn/GEIYwvJC552NF3JG8aMBGSCIPd9SqmoPnoTwq/MTg1ztcRv5VL8KYwdXq0R66wxFtc55ODfyGpXQzWj+34vhE8OgM7E/Z1IuQ4Gyg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(86362001)(36756003)(54906003)(6916009)(38100700002)(4744005)(5660300002)(2906002)(38070700005)(8936002)(66946007)(76116006)(64756008)(66556008)(8676002)(4326008)(478600001)(91956017)(122000001)(66476007)(66446008)(41300700001)(6506007)(53546011)(83380400001)(26005)(6512007)(186003)(316002)(6486002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkdEWVc4SUgvV3RtdmNSb2cxTUVwWGJOVFJMYUJYeWgxUmlEUTN5OXdCSk82?=
 =?utf-8?B?OWpYalNCRm5mcjFXTk0vMHVBY01MVTNOWGJzWkY1YmpicCtOdzF5N1FSN0tZ?=
 =?utf-8?B?c3hHdGtPSFAwaDlOQ1VObUpsYnU5M0tpSTlwYUVZTTFub21TV3ZEa1hMUVNi?=
 =?utf-8?B?R1VsYnVuMnU1c0I3RHFFMitPcnZFNjVqU05RdmFQd2JUamlTT3ozbFkwS0cv?=
 =?utf-8?B?dEVRU3NLVVJZbkJsU2w1MFNHZitrSjJuaDlia1hPcXdsWm9WUENNVDA2WXhG?=
 =?utf-8?B?OVkrbnAydHIvenZ5ZGJmSnFKdnJ1cmcwRG1GbnplZU9wZC9kOXZzeEVVbG5B?=
 =?utf-8?B?OWhScnV3ZXArazNsWVBRMGZrNUhHVVZSUnB4L3h0L2dHS0pSNVZQYzhEYWFq?=
 =?utf-8?B?NDY0Y1hSM0Q5Rmg2WDJSMWhmUFArdGtQTERYeERXSGhHTWZ2M1crY3p5U3ZX?=
 =?utf-8?B?VVdicys0Q2FDSVZhVFZlRUY2VHJJYXpOMHVzQlpYdCtTVldqODRHcVQrQjhP?=
 =?utf-8?B?ZitadEhhbzZBWmgvSXhJalFzSm9YZG8reHFOV2xJSjdHZUwxQkhNT3E1Q1Vt?=
 =?utf-8?B?cXkxOGRWUVBxRGw1bGptbk1DQjNWbURqR3JIRHF2TU82b2NPbDY2ZzJjdnVB?=
 =?utf-8?B?NktudEI1eTBTb3M2VjRKbWpNTFdXNGFkYStrQWo5WDN6QzZzWkZBSncwK2JX?=
 =?utf-8?B?WTRvU29hUWFwalNjTHh5TTlEWDlqYWQxV25kcGo1TEFadjVkRUVEUmk0WlFO?=
 =?utf-8?B?M2hPUVJmZVh6MjFObG9KODU0M3phQ1FCai9wZ0Z3c2h3VFE5aVdqVEhmdXN6?=
 =?utf-8?B?Rm1FNGFLbU8reDU3SG9MQU0zeHBScXhuYVBLa0syZWYydlozRmMvTXo4OXhM?=
 =?utf-8?B?d3lYSXpPRXQ4V1ozQ0tSY0lLdzRkcHgzY2Nob3BwYVRQQnQrNVU2NmNoRk9Q?=
 =?utf-8?B?eXVicS9lUENzNDd5UlJHSVlvY1pJZUJwQWoxT1VkSUsvbXIvRGE3c2ZpZzd1?=
 =?utf-8?B?SFd1SHVCeFRqa3A1Q2NzcnFRbXRDeldzOGI5N1BjdXBTTWkzU2l1RTNqeHcv?=
 =?utf-8?B?MFNrWHRBVlcrR2MyN2FVejhsZGlPVHVtbnB2QmxpS1JtalNWc0FHQkt1QjlO?=
 =?utf-8?B?VW0rM3ZoUlNQTEt0dGpZM05QYk03Rzg3dEY5NlJDTXJKK01VY2NOZ3dHc1ZK?=
 =?utf-8?B?SmdJTXdhQ295MGg2b3V4cUFranVlVUNnVzZka0lyQXNIZzBBNGxReFhJMVYr?=
 =?utf-8?B?anZhNE5Ob1VCZytUby9wdEZiUzQ1SHZCUHMxN0k2cUJwUWplQkh0clZsazRV?=
 =?utf-8?B?QVhRTTFWd1ZYcE8yRmZ5SFphWWZLbU45dm05SGVyQ1ZobHl6UWF6cFVOWkV3?=
 =?utf-8?B?WVNNSkh1RWtFd2Yyb29RQ0tuSlRRdGU1Zmh3dU1JOWtzK2g1VkE0SVRjNWw2?=
 =?utf-8?B?VFluZnN1Q21xWmNtM1lpZDhmWWFIaUMvUWRQSloyd2ZlV0UxZ3NRT0IzZ0Ez?=
 =?utf-8?B?T0VyMHlueXZ3bmZrTGM2VkpIdTFuTXl6d0JGRjNrbmVIQmcwQVdSOFdhZis2?=
 =?utf-8?B?bXl0d3dyamFNUEE0ZG50YWRPbGVBNW9TNFNIclFINVhYRG9MYTdrTS9VY2Vp?=
 =?utf-8?B?emx2OWtkd0Z5SUlRMk03bllmaXFIeXNOUGhKcEFJODhYV1h6Z2ZuVkt6c01s?=
 =?utf-8?B?VkdrWGJHbzd0V2M5QnMxOEJLdzhocGI3MXFWY3ZRR1VnRUs1N1NFNEZ5ejlw?=
 =?utf-8?B?bVFpdkFMT0w0UU9pSXdGU3ZxY2loZ3hNRTNLeWlORXlCUEdJRUY5WXlHeVJj?=
 =?utf-8?B?ZVFKamtqMFZ6K0NuYTIwU1hOVmNMYi8rK1c0bllzZUNObGd3V3ZSN3V6ZEhY?=
 =?utf-8?B?d1hPRzdQZkV1NzhZVzVRWHIvcWRQczc3UWJkMGVST2JFTkpLbzB3eVBDOXBB?=
 =?utf-8?B?V2xpczh0blRJYlpUUWNSOE9lZXNJY0xZeG93WVI2Z1NhY05ZWWMyRzhpZWtx?=
 =?utf-8?B?QnlYU1REZnQ1TXpQaHlDdW9YTG5rdGJtUERQSURIenRnUzBwUFN5RFBWaFhP?=
 =?utf-8?B?d1F0MFQ4QThPY2piVmtmeGZVRUg5cVNxOFdxMFhKc2NmeDlNZFV5U2J5bXY5?=
 =?utf-8?Q?ztZmPtumofP9X5nxsCc46FyXq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2891D57CFE56154B9F8D2FD2413B980A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a01bdd2-7da2-4016-ef04-08da6ee2df38
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 08:43:11.2436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFLePPVVhwmPbUEaYrvcuFARLHiQIiwwp4v+8NidmyBTsNUSZrZiafkyrwwnmMDs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4539
X-Proofpoint-GUID: BkYROKyzwI-v-NId-J-LCN8WPA7UtsM6
X-Proofpoint-ORIG-GUID: BkYROKyzwI-v-NId-J-LCN8WPA7UtsM6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_02,2022-07-25_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA3LTI1IGF0IDIyOjAwIC0wNzAwLCBEaXBhbmphbiBEYXMgd3JvdGU6DQo+
IA0KPiA+IE9uIFRodSwgSnVsIDIxLCAyMDIyIGF0IDQ6MDYgQU0gRHlsYW4gWXVkYWtlbiA8ZHls
YW55QGZiLmNvbT4NCj4gPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gQm90aCBvZiB0aGUgYnVnIHJl
cG9ydHMgeW91IHNlbnQgc2VlbSB0byBiZSBmaXhlZCBieSB0aGUgcGF0Y2ggSQ0KPiA+ID4ganVz
dA0KPiA+ID4gc2VudC4NCj4gPiA+IA0KPiA+ID4gVGhpcyBvbmUgaG93ZXZlciBkb2VzIG5vdCBz
ZWVtIHRvIHRlcm1pbmF0ZSBvbmNlIGZpeGVkLiBJcyB0aGVyZQ0KPiA+ID4gYW4NCj4gPiA+IGV4
cGVjdGVkIHJ1biB0aW1lPw0KPiA+IA0KPiANCj4gV2UgY2FuIGNvbmZpcm0gdGhhdCB0aGUgQy1y
ZXBybyBoYW5ncyB3aGlsZSB0aGUgc3l6LXJlcHJvIGRvZXMgbm90Lg0KPiBGb3IgdGhlIHVucGF0
Y2hlZCBrZXJuZWwsIHRoZSByZXBybyB0cmlnZ2VycyB0aGUgYnVnIGluIGxlc3MgdGhhbiBhDQo+
IG1pbnV0ZS4NCj4gDQo+IA0KDQpHcmVhdCwgdGhhbmtzIGZvciBjb25maXJtaW5nLg0K
