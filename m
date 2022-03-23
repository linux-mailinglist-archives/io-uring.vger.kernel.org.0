Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F894E54DF
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbiCWPJG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237757AbiCWPJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:09:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6571F7D035
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:07:35 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NBcVOC001778
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:07:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GL/tHj6rY0qfIKiH+akNmapN6NpxAayvRvUrvVHgm7M=;
 b=ol76qFbX0xbcjSafP7qkzAyaVNLCBalsc1ybPdAhZvKS7pxI1X/omXzys5w9P7gZJdAn
 aZp2L7nKpdqlVPGFuSDeAc0OnUXVA3VdHYy618M30RAW+/Zyv2gJqtSkVso19wECdDQ1
 d994zPWGT0K89y2Jy2+eQFiiqhsa15DTUtE= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f02uvsdm3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:07:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiEoRKocd7Xczp2ArVfodyXCZ5vrgZ7W0cZH9KEWCYSZZ5+nL0REk8nYVQ3djvq+QCORAKlkJvbXcktE4rupUYESW7y6y9xkN5/rhDkYkhZlkvZpONQeFi3iFcwI7aVWe2EEGZT5EettOi3IIvD08l3bV0eVp9eIocPY8zARi6go3aeEXN4eSc/OcgmF6iFrP9qJHAEDssM2MF6oLdIHWVCBuFHjkHlzhk1RueytrCkZyI1opQjpzk/BmhpjBh8L5TX58z15bMNXLdSHRH6by3BMjXcNKiET4mXfOdLPKykGH4t03fhFSUb1tQlRoXD6g1HFly93+bhd53yKhlk5DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GL/tHj6rY0qfIKiH+akNmapN6NpxAayvRvUrvVHgm7M=;
 b=Bum5RdYQGM3renPeCLdjgVqiQ1IJoLrwOBW0CfIsUhSD5mC2Ae7JNq4c1G+SZqm4ISUWVsbN4I9ZMFmgUEftPjkkZy65E1bZO3BxaIzNFDnn53KbdJqNeySQZa6u8Ssuac0vnDKIaM//L95t7hS3wUU+cBh98ie9qULHjPFcH648pY6dJZcXbXptJjiQmZQBOWWGjWPnnDfzb03/qeTeCspzvxF9Zyxi+FI1ziQ7ezdgt4It5WvsWImgb2/xGB4vYqabcXEfo0MdfaG3C30opsuHfwpzZxfyoKYXq0BXJ6RqAVdBXOYXG9naQejL1JDbMHyExyEUdP/rtXBSQVNE9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by CH2PR15MB4791.namprd15.prod.outlook.com (2603:10b6:610:1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 15:07:32 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::54d5:f4ed:c960:ba4b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::54d5:f4ed:c960:ba4b%6]) with mapi id 15.20.5102.016; Wed, 23 Mar 2022
 15:07:32 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: add overflow checks for poll refcounting
Thread-Topic: [PATCH] io_uring: add overflow checks for poll refcounting
Thread-Index: AQHYPqdfXZlM9gE7hkC99QwLAD6HYqzNEiCA
Date:   Wed, 23 Mar 2022 15:07:32 +0000
Message-ID: <4e8bcd464b1c97c4bab9e9802f5a6792e8f68229.camel@fb.com>
References: <0727ecf93ec31776d7b9c3ed6a6a3bb1b9058cf9.1648033233.git.asml.silence@gmail.com>
In-Reply-To: <0727ecf93ec31776d7b9c3ed6a6a3bb1b9058cf9.1648033233.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5a62037-7a26-4e26-6418-08da0cdedae5
x-ms-traffictypediagnostic: CH2PR15MB4791:EE_
x-microsoft-antispam-prvs: <CH2PR15MB4791E9D4AC2A211A0F11EF18B6189@CH2PR15MB4791.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D9Z5BaD+GmVtakx+kOXYvwDXQHWwwKDvxgdL1XsLRadPgEGEmsii5b64CZhtiwWHQ6mgqvEiQ2yuYuZddXoeys77XL5HrwnjXWspIaCtBHkqXnXVo6uEzk+1uiRHiuW4AMjyoQMHB91Pawt3S9WSsVuZ69nDaQBMclHmzoXQGX6x224crmTkjZVXkqHh1JVEL+OdP39y7gY5fvx1LecX0FTarvW3pwcAiMoru1TSpQDb0UA0ZKl8lF10Z/N2rH2T8++vIi8sUgUE7dfwU47JZUCrBN6HkMUy7ncP+Wfs06ErURwXuYgSoJhA/CQG0rfCfMh7xOQ5j9P8AHXyqxWurBjsMlI0y5g81+o/FJisKcU2UJ36ldkdBY3IBmOKYmVaP/VXF8K4y69SyLH4Hp6nHXCtV0rBGTPlIZhs9gVIg/PqGqDeCdiFFxsbZUP8GDjk4UdXCjtRo/suz5gNlaLRoyTXY9dOsE+BqaAX27gD4J9kIjx+SbxgDp+GKvafOLeuOy7D1tJlLL6PRB0gKqqA546OoTKUJTQ4dbCD7Ua1HO4R+h5BdKzXx+pHmF4GOLRUUuBkQlIxnF1rSuueTNMjtIFXPPCsmWidvF+XygYLW9vHEqiS4GCl3ZAn2OJRch392iiLS2SB8lFkZnRPbexAtcr7Ev9dWJmjoWhXPCTyJ0pTAAvdU3G8Cb1NpxgWoisrBiB2yZjew39m3pT7D5UD0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(4326008)(36756003)(66556008)(66476007)(64756008)(76116006)(66946007)(66446008)(8676002)(2616005)(6506007)(6486002)(71200400001)(6512007)(316002)(508600001)(83380400001)(110136005)(186003)(4744005)(38070700005)(2906002)(86362001)(38100700002)(5660300002)(122000001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OU9VYzh4OWtVYXF3OGJmUmx4SjBOODRqdjNBZmFuRVdrdjJ0SmpWcEg3dG00?=
 =?utf-8?B?ZnV1M1dKejU5Q0NsTldoVEhSbnhTVG5mZm1rRk9Wc1YxWGJxOTV4VmFnQkFE?=
 =?utf-8?B?Zis0ZGRwYUNxUit6WnlWSWFVT2FETjFBQlBLWEVwS2VWRXRUU1h0cUpXVmFN?=
 =?utf-8?B?ZmF1T2J6SlNYeFVNbmszMHhpNDVpRTVmdEFWUXpPYnBLNGlqbFprUEo0dFhQ?=
 =?utf-8?B?YjRYTmxTWVYyRVNZcDZTVzhJMkZCYjI1OE5zK1VOcXRhQUprSDI4ZEdHSDN0?=
 =?utf-8?B?S1VEUU5ISXpZN3JDTTM4Nmx1cXN5all0NDNSOGVVZGtGSVZqQzlja3ZISHVs?=
 =?utf-8?B?d0wrSG5CZTBzNXJYVmtlY1lvaDJaL28xSXV4VEkwazd3a0JBZjlxQjlKVkxL?=
 =?utf-8?B?NngvYWkvcFBBZ01lU3RDaDJrK1h1b0pCdGFJWUNVMytQNW41YnpvT1JMSGZY?=
 =?utf-8?B?cHE4R1VJZTVuZVhOd3I2UmJpbUxjMjV4SXE0cjFEMzkwZkJQWHZSeU5Jb0Rr?=
 =?utf-8?B?RjkxUm5uaXZJNFBCbjFxdE5SbkxqSUxFcmpaNVdJb1BtYStQOGlmb2FDYnBO?=
 =?utf-8?B?dDdSbFRrdC8xWjNkbFYzUFl6NUFROWZJclhSSm9WZTRCSEJFNkhLVlAxaG5h?=
 =?utf-8?B?TGRFSnlIUjI0eVdnTVFIRDV4RFZiYXZzaGFJMTRwTzNNK3N3a05wS1hkL3V4?=
 =?utf-8?B?TCthTFRWMVVBNTJNQVA3YkYvSjYvMDVIK21GK1BrQzI0WU1aS1hVOWY3dmJS?=
 =?utf-8?B?dFdlNnpxWEJ1QnYwNm1keFR5YWcxQThHYlljYkptZEx0a3VWVmFWNDJMRTJI?=
 =?utf-8?B?YjZkZ0tBS2cyZDFubEdRbENtbS9hVzRkY3crMHZJVS9jY0lwMEkrZHRuMStO?=
 =?utf-8?B?WDY3VXM1ZVI1SUEyWEtTTVYvZk5qdk93WmRBVGRPTkVEeGFpVW5CdEdJR1cy?=
 =?utf-8?B?M3NiNlJORm5GdG5NVVN3WWtxTlcwcW1WTlhyMHZKUGZOTEVmVVN3T3V4OTEy?=
 =?utf-8?B?ZytQMFI2RFc0TlZVcTZXblVYem9HUHg2MTBibTc3Nk5VdE4zSjhscE1RSzdM?=
 =?utf-8?B?RjNUc3hzZXJaTkh1Z0xYenpLWUFiTHAydnNjTFlzVWtkMXpPaWRsTzFJZkZM?=
 =?utf-8?B?ZGR6eHIybXJ6MlV3WGRCb0pDWnhBSlkxZ0lPNy9jR3FsdmlrYmtxb1pXYmxz?=
 =?utf-8?B?QzI4VnBBTWNKbUdDSnpUTGdWUTBnVXN6NldzbTRkcXRiVi9aUW5aczFwSkJh?=
 =?utf-8?B?NmJrWW5HKzQ0UUpydkJFTFJ5QkRab2JOYkt6YXJxdDY0RWJDcC83ZU5KbFVj?=
 =?utf-8?B?UFpSeFh1QmMvdWluUHM3TlRBeGk5eG5TcTJGNERIYXcyNVVKQXRBVEZndTNF?=
 =?utf-8?B?aTArUUVpVitpSmZMZGZ0WG05cCtwNW1mRXJQQ3ZlRks5U3BlM2FzSmtsKzNm?=
 =?utf-8?B?YUdqZ3JFUmFOcWhqSzdERzlYMHBFV1lwZUVQTnZqek1aUkoyVGhEUG5jaHl4?=
 =?utf-8?B?UWw0T21qMW0wTnFIaUc5MFNEa2didWNobDRKRHBwZTY2MDVUNGRDWWU3Zkhk?=
 =?utf-8?B?WXBsM2NRWEZuQzlwaWdMNmN4cFVqMythalJOWkpIckxuYUpKZFVOTUN5QjZQ?=
 =?utf-8?B?eHN2Wm5HM0dRZ1FWb1R5MmVTWXpYY1ZQdkJwempZL1JqZmpZSGZKTHdZcVov?=
 =?utf-8?B?SSt2TmZ2blRCd0p3WjB1K05IaGhvZ3pLWFdNcENrU1NiVkZmYmpCT3ZBbHpS?=
 =?utf-8?B?QzdITFB6enRKRHpvdVRVbTBtS1F6bmJadWlibzJQNHBMNXlYU1JVMEgvc1FV?=
 =?utf-8?B?SnppODZQN3JQQ2x3R1h3RWYvNnQ4Rm56UnE1UCtjZURFYVFRSHoxM2NpY1Jh?=
 =?utf-8?B?dFgrSS91eURpdkJ4bHU2SFVKUE0xaGdOMGJBMGFIOXRWZklCOUo1YjQwZEMw?=
 =?utf-8?B?ejFBdDJBMkVoNjdBZWV3WjBIREpjbXhFalk2M3E5NFpQUkY3YzBJN0N4VTd3?=
 =?utf-8?B?aEk2bS9UdU1nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DC818DC71E2EB4484C797A060528303@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a62037-7a26-4e26-6418-08da0cdedae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 15:07:32.0461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QSmcVUAf42a/uv3wcelEc8uQmylVNgZes6Nj/11EvvvZNg2MrVUhzZkA81tKcaJH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB4791
X-Proofpoint-ORIG-GUID: AjJnLxNMI6edj-LCS1wYwI4yN6oy--2-
X-Proofpoint-GUID: AjJnLxNMI6edj-LCS1wYwI4yN6oy--2-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTAzLTIzIGF0IDExOjE0ICswMDAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gDQouLi4NCj4gwqANCj4gLSNkZWZpbmUgSU9fUE9MTF9DQU5DRUxfRkxBR8KgwqDCoMKgQklU
KDMxKQ0KPiAtI2RlZmluZSBJT19QT0xMX1JFRl9NQVNLwqDCoMKgwqDCoMKgwqBHRU5NQVNLKDMw
LCAwKQ0KPiArLyoga2VlcCB0aGUgc2lnbiBiaXQgdW51c2VkIHRvIGltcHJvdmUgb3ZlcmZsb3cg
ZGV0ZWN0aW9uICovDQo+ICsjZGVmaW5lIElPX1BPTExfQ0FOQ0VMX0ZMQUfCoMKgwqDCoEJJVCgz
MCkNCj4gKyNkZWZpbmUgSU9fUE9MTF9SRUZfTUFTS8KgwqDCoMKgwqDCoMKgR0VOTUFTSygyOSwg
MCkNCj4gKw0KPiArLyogMl4xNiBpcyBjaG9vc2VuIGFyYml0cmFyeSwgd291bGQgYmUgZnVua3kg
dG8gaGF2ZSBtb3JlIHRoYW4gdGhhdA0KPiAqLw0KPiArI2RlZmluZSBpb19wb2xsX3JlZl9jaGVj
a19vdmVyZmxvdyhyZWZzKSAoKHVuc2lnbmVkIGludClyZWZzID49DQo+IDY1NTM2dSkNCj4gKyNk
ZWZpbmUgaW9fcG9sbF9yZWZfY2hlY2tfdW5kZXJmbG93KHJlZnMpICgoaW50KXJlZnMgPCAwKQ0K
PiDCoA0KDQpJIGJlbGlldmUgaWYgdGhlIGNhbmNlbCBmbGFnIGlzIHNldCwgdGhlbiB0aGlzIHdp
bGwgbm90IGNhdGNoIGFuDQp1bmRlcmZsb3cgYnV0IHRoZSByZXN1bHQgd2lsbCBiZSB0aGUgY2Fu
Y2VsIGZsYWcgdW5zZXQuIFlvdSBjb3VsZCBmaXgNCmJ5IGFsc28gY2hlY2tpbmcgZm9yIG92ZXJm
bG93IG9uIHRoZSBtYXNrZWQgYml0cy4NCg0KDQo=
