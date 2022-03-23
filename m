Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A5E4E59C6
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 21:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244820AbiCWUVP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 16:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240507AbiCWUVP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 16:21:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71B42898B
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 13:19:44 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NH4MfM017099
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 13:19:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kO2tmZwsur4GUJRzZ0RCtNPrWOck6pNgBvb2JRvWrSE=;
 b=rDMTVpASXtH7VawoHvOF0hreXBRkOAczgvd+j8ghbnPcgfi3OGAW3Uu5IvzMXA2cC8Yi
 uFdIY/ng9oENnnlOBnyr+dOVMawM8YYJMAy2ix+KJnJCLv2dp/TEYI2JiYTU5n43MzXV
 erMJzyY5DzpEVxkZvSRRH9/7Bs/aS6JJRVA= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eyc9wwk0a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 13:19:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmpTaVOagLRH0l3xYVOtLp2ptXmNZJPTmnJZbvt8y6vcKfMvRfrxGGyKfzxqWErpwlWqtaLYRXc24MwXxDD+1pD2BbLyloJ3Px9bmILy8TECUx2DfRbMvionCG/2ZD7JYw7kFTp4G9Q/lwbGyZ074tgPujOZNDNlIkxg+gFzrBoT0EoqO8cfsH1VlSLsgSis17qUplMZtqglpln4APM/XR/VXxvHZiMPpsj3Tao25TL/028VCpUWGWCyQ/AgaEHvKvRMeyVtQAmCZldQOmo6pdTrDG/K0QNTlpyOKwFxBtBg5xmWwsyGBYALunKYjJZXDj+41LloUCvFdUYCRFFp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO2tmZwsur4GUJRzZ0RCtNPrWOck6pNgBvb2JRvWrSE=;
 b=M5dgfLNcJRKY1WVA0zM0cBChUjH303v6da4CpIoTwL8me7csIMPx6iOUxnnazt1UMSX+SVkR8Wf7fJC8iTPmOOmgmXXbOecI6Vn9T2xTv8FbQZ9zng7piACS48VheW6prRfo22i47r2AXABttUYBZa8xSPPFeZNw7xOeebyYkzJplsM3ei5XLMlJOD4iDpj5M48pb8h6JTNSkghF0sYuM/FTME1UHl7Vk51/tvYBtqxWveltlWzUozWoCzRkuGBNlZCM6gK40iMVdFrpO+MK/u5A6vk12zwVagDfW7Qx0uIZOCeN6KnZpZUuyEC5A43e8lX9tp9AUlwSrGqsYAShrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BY5PR15MB3731.namprd15.prod.outlook.com (2603:10b6:a03:1b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 23 Mar
 2022 20:19:40 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::54d5:f4ed:c960:ba4b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::54d5:f4ed:c960:ba4b%6]) with mapi id 15.20.5102.016; Wed, 23 Mar 2022
 20:19:40 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: add overflow checks for poll refcounting
Thread-Topic: [PATCH] io_uring: add overflow checks for poll refcounting
Thread-Index: AQHYPqdfXZlM9gE7hkC99QwLAD6HYqzNEiCAgABObACAAAjLAA==
Date:   Wed, 23 Mar 2022 20:19:40 +0000
Message-ID: <5cbe36a1d91d96f4382d248f81e0f3fcfb2005ba.camel@fb.com>
References: <0727ecf93ec31776d7b9c3ed6a6a3bb1b9058cf9.1648033233.git.asml.silence@gmail.com>
         <4e8bcd464b1c97c4bab9e9802f5a6792e8f68229.camel@fb.com>
         <a67eea3f-f500-1a9a-69d1-b63d02142141@gmail.com>
In-Reply-To: <a67eea3f-f500-1a9a-69d1-b63d02142141@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8a7fd81-d9f3-4e33-6d49-08da0d0a760e
x-ms-traffictypediagnostic: BY5PR15MB3731:EE_
x-microsoft-antispam-prvs: <BY5PR15MB373184F8AF73CBBE2F706E86B6189@BY5PR15MB3731.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PqqOdasv8DSc0lnnMuDuNhN6M6cBY2vigVSwd3Klt9YEQan7IRO5Jew1Zk9CGR7/YieINpV3zLlHQX8hjzZelolLoM2cSM2MpdPO0QobP2nCw+xifhyXDVcXdZm8ggLnLG5lcKEozxiHcaMXAe01yIsmzqfmUSTD7lzh9C/vGrLUUYrSILWteji5p+LFwBK8qcuzoL6CNE5IkX/PNFeAUqPIAPIS0NEA9QpolPgDgHt1HxB6e8Ymr+OC5LqmlV2zyFGdAifeSFOYsyZaW2Pw+bGoOAoiO5H+1SMyOYRE0DXtVMXfkztWSqyNCt0gq7Fg+oekq0H6t3fEKIrxLeZT6WGTNN4x1QYpiwpJh0hHp+7mGyXdauU1H5N1V2v+YV3097VVrWOtQslob3pVjj7162PhpJUfk1xe16U/psu22Qtte2bQOywG9IafCFq8IwrueYMfRRTQWVf+3z31MQ9d/C3ONmWR6nTHeHTiMC93hQZ1JnR0GuoEyeze2gbj4Oewy3Sk3MOzDAYb7IWzeJIkg7yeKCkcNUA/vaPpqfWv8zmZADJ+GdS7LnDgsDENrhsFGnVeaS14+Fbb9eVaZZnAOSPcX2tnJTOugNX9/h7Jaem1/5JdVsr5BlMql1x+whfWIgadp1aOcBRKEOueDSQmzOoLkHWpYrssHKRgrwQTOzxuh1QDll5TvyUwpbgfaHm6WnEQQyw+QKco+pkknw3qMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(38100700002)(83380400001)(6486002)(508600001)(8936002)(38070700005)(5660300002)(86362001)(316002)(122000001)(76116006)(186003)(2616005)(4326008)(36756003)(66556008)(110136005)(66476007)(66446008)(66946007)(64756008)(53546011)(6512007)(71200400001)(91956017)(6506007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDNXLy9HeWJtaENLYzZDT1BpdHd1SDdTV25SaHVZR2UwNGZpZXJqbitwSlJT?=
 =?utf-8?B?OC9XQWtFc0VVUVE1RGI5bGR1RTZ2SlNPSlNRSUVpS3dyVE9Pb2JBRFFzblM3?=
 =?utf-8?B?WkhxSjAzdmRBQlRVOEgzbXliYVh1ZVNwK1B4YjVQbW80Tm1nVFphQnhpRnR2?=
 =?utf-8?B?L0JMaXQ2WGZaS0VGbHlYaTJaUlJaSXBORG1jTTgyeFZ2MXFDSFQwM3M1emR6?=
 =?utf-8?B?NUV3RFpldEg0Mks1ZFIvR2NzckpJcThGSXNIRVB3TkdNTGNRWG5aM3RaUjF0?=
 =?utf-8?B?SjMvK0RFQ25vWVZxQ3V2NGZxODVmbUJKS01hdHZxRWtvbVBCQXFtV2psYW16?=
 =?utf-8?B?NlFDTWVTdzBPU05tWStDbVpReDdERVlIYnM3aCtPSHhPTlRGelBLbkVJdXNr?=
 =?utf-8?B?YTcvOVBpZHhYcVRGS3VOL1JWWmpLdkU3bDBDZmJwT0gwVmppTmVUdVZ4K3kx?=
 =?utf-8?B?ZFhQMnlUK3B5MHlFODdXdTF6SHE4ZFkreFozSXhKQ0NsWmk2bVhxanc1dVVq?=
 =?utf-8?B?ZTdKNTd3T2UydmpheEpFbWdiaDJLQ1ZXa2hGemVKazJtVzRhYVVvbjlENUtt?=
 =?utf-8?B?Y1hDb1dLMnprQ2RpSStvQ3dXUXFVemhEQXdBQ2RNN0VYUEErdXVvOHdxNGRI?=
 =?utf-8?B?Q2tSVnR4ZDJQNjVXc1VzNWcvRVdDS1F2VjZDTndrSnNoL2Qyd08yK1Zub1RZ?=
 =?utf-8?B?eWJWV2JyeDFKdnBFdWlvOG90c0NYbm1TQmZPbll0RFg1TTVqakpZNmpxV3Qw?=
 =?utf-8?B?d0RBVEtyb0VtdVM1Zlp1ZnB4TE9CRnUwV3V6TFlUcHArM251cFZlM0RLckZW?=
 =?utf-8?B?WnFwRXg4dUV1UXAzK1QxMGlhWHI2b3IrR2NKS0Q3NHJlR0xlaDJ2cGg4by80?=
 =?utf-8?B?L3FOYzZRYzJsT1RkaEhwaFhHYXlKcjI3a0lFOGJKdkxhMU53U1FyejRMY3dH?=
 =?utf-8?B?Sk5FZHp1VjUrS2JLb3krU294cnRkUTdoL1ZiKzFtQ0RqVE0zeWI1cDRiUDJt?=
 =?utf-8?B?N0xoQTZWZWNEQ3dpT1ZuamJudmphOWQvNHVQRDFCWVhHTE1rWTlUbUgwWnRY?=
 =?utf-8?B?cDVzcytmMzZhcFJoc0IrQmFYazM3Z01KbUk5blIyRy9IWVRza29CaVFtWlor?=
 =?utf-8?B?QmVZZzFlMEJPVldGaVpTbmErZHFXbGdjNkV3Qm81eHU1eTVCUlJKN3lDVUxl?=
 =?utf-8?B?Mk84UUpsQVR2V1RLVU00Uy9kT1dCN0xCc3hHdGlrVlhUaXc0SDJEQnpIUGNR?=
 =?utf-8?B?WjVJdHRTYnFWNW9mL3dPUjJyK1ZMelFTZEg3ZlRpK1dMUWxXMjIrUnF5ckRt?=
 =?utf-8?B?dkN5TVVjTHdsemM0cFFhQzNCcU9nYmRSRVN6TVZXTFRNVEM2a2FQQVhoaUxu?=
 =?utf-8?B?UkhydTlVS2NQWFlObG94UnIvTzRLSnZGNERWT3FUbW03ZGlFWlN0SnI2dEpJ?=
 =?utf-8?B?ZjhvRUl0VzlJVE5lVXNMRkoxMG1yU3FkeUdSSDl3cTQyY0dBdVJZY1RtMElM?=
 =?utf-8?B?VE1mdUhVNHJ2bEd4dndzY2llaDNmQ3VKZC9VSFFPdjNWR1hVcHIvc2ZOV1Jk?=
 =?utf-8?B?d1NjY1NoTno0SFBRMkowS2ZlWWVlbDVzT3hVbVRETW5WVEsyanQ4aWpmd0Va?=
 =?utf-8?B?RldBMEpZYnNYekROb0lJSVh6QnRvOUc2TkZ6V2JOOTRmV1VBUldjZzcrL0pv?=
 =?utf-8?B?TGRiR2NEY1YvM1VCd0Y5R1l5dmhJM3hBdmZ3eWZtNTBFVUpGZjJvbHlVRTN4?=
 =?utf-8?B?T1ZhUklseDQxTEtrSVNHZ2xkbFpaQ3ZteklXU1FGclV3Zkd5YTl1R3BHeVI2?=
 =?utf-8?B?anNtYVVKZVBEWlRNWEFYMnhCUmU5bnEyR3YrdkNCY2F1RFlmWk90T01nUnBy?=
 =?utf-8?B?MTlPZkVGd3gxb0FWaHgya0ZHMFdCc3pDTmd2TVJLRjdwbkRtOHRURzFFQXQx?=
 =?utf-8?B?UGdKemJJTGNqcjc0cDBjOXcyR3NRNWRtVVhJSFgxSGlZVDZRUklSTWE1a3pR?=
 =?utf-8?B?dDgyT1N3YWpRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <470F661CC102E241AEEEDC2F13A26EC0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a7fd81-d9f3-4e33-6d49-08da0d0a760e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 20:19:40.7212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 03JAdXu+y0obbXY2scZjt330GGWVEHHmtHDy9GIIy2sxyAShmzZTvU68i/p7KdV6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3731
X-Proofpoint-GUID: YO0BaAJI2yv3pVvEtEP2gfvzk4BmmY3b
X-Proofpoint-ORIG-GUID: YO0BaAJI2yv3pVvEtEP2gfvzk4BmmY3b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_08,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTAzLTIzIGF0IDE5OjQ4ICswMDAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gT24gMy8yMy8yMiAxNTowNywgRHlsYW4gWXVkYWtlbiB3cm90ZToNCj4gPiBPbiBXZWQsIDIw
MjItMDMtMjMgYXQgMTE6MTQgKzAwMDAsIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPiA+ID4gDQo+
ID4gLi4uDQo+ID4gPiDCoCANCj4gPiA+IC0jZGVmaW5lIElPX1BPTExfQ0FOQ0VMX0ZMQUfCoMKg
wqDCoEJJVCgzMSkNCj4gPiA+IC0jZGVmaW5lIElPX1BPTExfUkVGX01BU0vCoMKgwqDCoMKgwqDC
oEdFTk1BU0soMzAsIDApDQo+ID4gPiArLyoga2VlcCB0aGUgc2lnbiBiaXQgdW51c2VkIHRvIGlt
cHJvdmUgb3ZlcmZsb3cgZGV0ZWN0aW9uICovDQo+ID4gPiArI2RlZmluZSBJT19QT0xMX0NBTkNF
TF9GTEFHwqDCoMKgwqBCSVQoMzApDQo+ID4gPiArI2RlZmluZSBJT19QT0xMX1JFRl9NQVNLwqDC
oMKgwqDCoMKgwqBHRU5NQVNLKDI5LCAwKQ0KPiA+ID4gKw0KPiA+ID4gKy8qIDJeMTYgaXMgY2hv
b3NlbiBhcmJpdHJhcnksIHdvdWxkIGJlIGZ1bmt5IHRvIGhhdmUgbW9yZSB0aGFuDQo+ID4gPiB0
aGF0DQo+ID4gPiAqLw0KPiA+ID4gKyNkZWZpbmUgaW9fcG9sbF9yZWZfY2hlY2tfb3ZlcmZsb3co
cmVmcykgKCh1bnNpZ25lZCBpbnQpcmVmcyA+PQ0KPiA+ID4gNjU1MzZ1KQ0KPiA+ID4gKyNkZWZp
bmUgaW9fcG9sbF9yZWZfY2hlY2tfdW5kZXJmbG93KHJlZnMpICgoaW50KXJlZnMgPCAwKQ0KPiA+
ID4gwqAgDQo+ID4gDQo+ID4gSSBiZWxpZXZlIGlmIHRoZSBjYW5jZWwgZmxhZyBpcyBzZXQsIHRo
ZW4gdGhpcyB3aWxsIG5vdCBjYXRjaCBhbg0KPiA+IHVuZGVyZmxvdyBidXQgdGhlIHJlc3VsdCB3
aWxsIGJlIHRoZSBjYW5jZWwgZmxhZyB1bnNldC4gWW91IGNvdWxkDQo+ID4gZml4DQo+ID4gYnkg
YWxzbyBjaGVja2luZyBmb3Igb3ZlcmZsb3cgb24gdGhlIG1hc2tlZCBiaXRzLg0KPiANCj4gR29v
ZCBwb2ludC4gSSdtIHRoaW5raW5nIG5vdyBhYm91dCB1c2luZyBiaXQoMCkgZm9yDQo+IElPX1BP
TExfQ0FOQ0VMX0ZMQUcNCj4gYW5kIDEtMzEgZm9yIHJlZnMuIFdlJ2QgbmVlZCB0byBkbyArMiBp
biBpb19wb2xsX2dldF9vd25lcnNoaXAoKSBidXQNCj4gdGhlIHNpZ24gbG9naWMgc2hvdWxkIHdv
cmsgdy9vIGV4dHJhIHdlaXJkbmVzcy4NCj4gDQoNCkkgdGhpbmsgdGhhdCBzaG91bGQgd29yay4N
Cg0KSWYgeW91J3JlIGNoZWNraW5nIGFsbCB0aGUgdGltZSBhbnl3YXksIHlvdSBjb3VsZCBhbHNv
IHVzZSBiaXQgMzIgZm9yDQpjYW5jZWwsIGJpdCAzMSBpbml0IGFzIDAsIGFuZCBiaXQgMzAgaW5p
dCBhcyAxLiBPdmVyZmxvdy91bmRlcmZsb3cNCmhhcHBlbnMgd2hlbiBiaXQgMzAgY2hhbmdlcyBi
dXQgc3RpbGwgZG9lc250IGRvIGFueXRoaW5nIHRvIHRoZSBjYW5jZWwNCmJpdC4NCkluIHRoaXMg
Y2FzZSB0aGUgaW9fcG9sbF9wdXRfb3duZXJzaGlwIG1pZ2h0IHdhbnQgdG8gY2hlY2sgZm9yIHRv
byBiaWcNCmEgZGVjcmVtZW50IGluIGBucmAuDQoNCkkgZG9uJ3QgaGF2ZSBhIHN0cm9uZyBvcGlu
aW9uLCBqdXN0IHRoYXQgKzIgaXMgYSB3ZWlyZCBiZWhhdmlvdXIgZm9yIGENCnJlZmVyZW5jZSBj
b3VudC4NCg0K
