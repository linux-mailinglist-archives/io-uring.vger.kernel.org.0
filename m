Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BFC6060A2
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiJTMxV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiJTMxT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:53:19 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B3517F2AA
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:53:17 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K9SHII017130
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:53:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=Fk0eWqYgUJy6gxrHnigNNOrEW6XOhS93yldyF2mIMHk=;
 b=Z83RkePKHEOXDL0HLBcFtfVpl1cXvjQHqJ4Pd5JQUeWVsBzXaGfM3qM7nIrmjJ9lEGx3
 cpuV5Tzx30cd7dUhMakRpWYA4WGFn2oiPpPo3VMLD0FkZ+ivPPlEKvsYQHe4kXC0BzxN
 /L+nZT1lwVemyEgMfIgSBPRf5INI1ih6Qk9bBGzIWDcoe+QDivquetdQSrj9R2I0zuPS
 ibBUPoC3QSSLjQOkf1E0m4jXmXltaMXtwTc2T4LGMJgL/f+VWZ6/bsOjztqTZgK1CqLT
 2L05gl4HxcHRjGVpWQgGWARziFn7+lhtyOT/EatV3SOo2sttpxIVuX+cQ3KpmJpw9IMI Eg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kag0662yc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:53:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1x4BWsi3jpqjnuo4yWaboLj/1ACaDB6D0sZ+WOgSY416tu2FZ7Wm7LlW1N5O8pRrbFm9zCXLGknlY+8slZ5EodlGchRhuOiT8aTLyfgPkXy59Oln0lzneIw7B6k1WLy+Yhfy/eVodDgWw0crgAZw1p17hpxGyVQLdY5ciU1m7f0m0ZDML3e9C65f36A6m9NfSE/yGKz5+nkrKIaS2UJxNv2zszBj9Mca/ia82LdUDFl5dZNYeO4y7UPko5WPshv4cG3XehVyPgil/bDTUXjpzV/wp75DjtW/8pZRcSkwFYtWH1qNF91OREpZaJefNyp8pBKYFypsyW6d6n457Rbtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fk0eWqYgUJy6gxrHnigNNOrEW6XOhS93yldyF2mIMHk=;
 b=FZ0s93nq4W2ZWL/7+arvktRGLLIHFVTug14PbPs6yBiV4Oe17g7nlh90/bvwEtA6r/bJMyHl6CJvAZ5QjmhbMc0rmaXCYkUZk0RsAT1qerzb3CIoZKG1ahuRlBgELSglxbP4Lebz6qt9OjmP506+BDTewS5rIKA454SstnO/b3lkbG3acDhkdpl3Xni9V/b2VCTjUDyEaK9iOMsn4hRRluIaEvgdFqpi5Ut+kXsxYI/qe0sRprR7DSKOAtbNfjMXS5k2YkBV7wg/cWEzMqRlGq3rykYjI97zf43ZIV+IsBsYVwumNcME5pnnIigc7nVrhhHAHhUcjr+ZkPnyVPlCZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM6PR15MB3752.namprd15.prod.outlook.com (2603:10b6:5:2b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Thu, 20 Oct
 2022 12:53:14 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%5]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 12:53:14 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     Kernel Team <Kernel-team@fb.com>, Dylan Yudaken <dylany@meta.com>,
        "gwml@vger.gnuweeb.org" <gwml@vger.gnuweeb.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing v1 0/3] Clean up clang `-Wshorten-64-to-32`
 warnings
Thread-Topic: [PATCH liburing v1 0/3] Clean up clang `-Wshorten-64-to-32`
 warnings
Thread-Index: AQHY5HqF8gdCUzyQMUeTdrmBo6jBt64XPN6A
Date:   Thu, 20 Oct 2022 12:53:14 +0000
Message-ID: <0c8a9f3fe2ff056e9f375f95fa9ecb328587fab5.camel@fb.com>
References: <20221020114814.63133-1-ammar.faizi@intel.com>
In-Reply-To: <20221020114814.63133-1-ammar.faizi@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|DM6PR15MB3752:EE_
x-ms-office365-filtering-correlation-id: 89003358-3043-43fa-04ca-08dab29a0d33
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Guk8EGmMRYvcLejnISmrXiiZBpSOB5Y4V4ROOrphdkXP63bwy5a8Iz/c9d3ZP0Scku10Es8zCwabdlQODNoQzQLVdOaE19uxNDQ2kAGoLpjBwrnn0+BMjC9u29rHfTQwkKp0j6Rl/MQMbdhr7MalVoIguyF2G5ZURUedIYBEAbfP48P+Ac+rkh07lUEEca9n2/NA3XAUPOeRNyKYQZ/Mqx4VOD2AlQiJIf0h0mnHYqAstnD8VjjDh6ziRPWsUFe9FY64y6eLdPu0IeyHvTiNNNRHtONVw+66MTCJBx/uBHF9JJENRmRJ44h3FTQI/ySYMlOQTp+bYd0S0LMZ2SBNHfQlf5WlvPvX4s5vb7psBc+2GH6SEQ8yfqGhAAng2d5fnfepBjpmHbEhZ+83n7y/mzFkvF4k7oV25qwfRNYDaku1Jkra14zh4eouy+5hANvrNcnNLRq1eDoZRaYEm271q2p8jZJohS86QyyG9Mwg/tdTZXMCxZidMvAS/8zQpRTazqYTpVM0iLMU2Wkznc2Q4B1nt7ID6JFiYKs4EIG+Pxr1E6SXbolvhDZYpZpRkBXhaaB8jzDE3JNwSuxhXGbgzSDkFRvL0Dccom4DC/gsSZrsyIqg/au9r5KvmommLKUQ94Z6YHuaWnPd6BgRHEdNgDcDmtnOlQ8mtQm+rv9mAiYFKWkxlvnOfklqyRxAgWSCpG97rcrJApeQOO/WLzVeVH9VTLwtgmo4cQ3j4lE5OPHdARbbtTGIEKjnUrsofQ+Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199015)(186003)(36756003)(71200400001)(86362001)(4744005)(38100700002)(4001150100001)(2906002)(38070700005)(122000001)(6506007)(6512007)(26005)(9686003)(41300700001)(66946007)(316002)(4326008)(91956017)(76116006)(6486002)(66556008)(478600001)(54906003)(8676002)(8936002)(66446008)(5660300002)(110136005)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDUxcGgyTVFoL0hoSDV5QTVHakdpNytja1JGMXVJUUl3cUxpcWNqQVl1c2hL?=
 =?utf-8?B?azVVODNsN3c5a1NlTSt2dU12a21FWVRtakRaUSs4V0xNZjcrTGJidlRFNnVN?=
 =?utf-8?B?VSs2TEx3dWNmWkhRZVlhWFZpTkF0QmRBcFI3S3RNWG14Q0YwajlSZmlQVDF4?=
 =?utf-8?B?Q2wxMGs3ZHlNUHVFeXk2OUg0NFFKODdLUG5HZ2RtKzlDK2REQ2V0NzYwVzNm?=
 =?utf-8?B?c213SVlUZmxMWTJjRnhZR3pWNUNidlJENG5keUdlU293UlJkem9FT1RrbGNB?=
 =?utf-8?B?bjkrR1NtSU5NcytxTVBpamN4YUZIM0FtU3hyOVNyRXFyWE12ejI0Z1RQWWR2?=
 =?utf-8?B?ODc4My9NeU54NUtpQ2ZLcEZLZlUyOHBveE9TM2ZQNVpzZUozMlg0VkRTYk9D?=
 =?utf-8?B?ZDR3dllMb2M5VlY0c0IxcDN6THJJMWRBR3AzY2JsQVgxYmNBdmRtT05Vb2o2?=
 =?utf-8?B?SnFOZ085OUdmVVBmWDJNdElpbWkrMW8ycGdMdkZoU0dBbUhveXZGOUZPQ2U4?=
 =?utf-8?B?SGxrK20vdmZVN1hNTndlWmxHT3FEYWJsdkYvanB5WHJZSnV2SVlpK3IzU05q?=
 =?utf-8?B?a1REOFA0M2dHRHFZRnV5OFVnZnVDcEIzbkl4SnpUcjAzT2lCTlNPcnFaNkZD?=
 =?utf-8?B?UEV3UytHaGRZZDExSGVtcnpXazQrd21YTXpsS2lmOEJaYlZMWkFmZFR1dXdu?=
 =?utf-8?B?bmZpK0hOOXlaQVRQM0tFZ0lRKzFHYjcybTRsdlJ6cEl0L0R0cXZvcWxLR0py?=
 =?utf-8?B?QU50ZkJrS0NRb1ZaSWFJQWh1Uk9PU01vSUg0elJHeEJ5RUpRc0padXZtZFVS?=
 =?utf-8?B?cm1SM3RKYUZUOEcyajRKbytMWTA3R3AvdTRBZ25Jc2QveDV4UlBtdWNlQmtz?=
 =?utf-8?B?b2Y1R2lXcUk5UXhTb0g1TGpROFYyMzBLOHo4QXhtWEkyZXd0RUU2d2VvZ2ZM?=
 =?utf-8?B?MERwZzdSbTA0eTBPZkFmNHo2YzdkQzVQUnZzWWtUUit6dklPVFpjeGhLVkd1?=
 =?utf-8?B?UVpsUDc5VFdZT0NRcjV0RURtT3N0cVB0OUJ6MWlQR0k1dVFKNUU0US9uRENF?=
 =?utf-8?B?MHE5TWRGTTNGcmU2aWNsVWJSK2hOeGFQRHFUS1YxZ3M3d09IMGpjMHFPQkFV?=
 =?utf-8?B?aVBySCtwS1Jabm5mbDJpOVVhSG93RWhVa3ZyWEU5aHBNMmhWU0RLc1JRaXk0?=
 =?utf-8?B?UmgxR2RZaDNIcDFVRkcrd3BlQklJSlZmRGRxaEh4bGVmN09QZWU2QU8vRHk1?=
 =?utf-8?B?RjBOQlpkMFlXc0pBWkM1U0dNaHBxTm0ydGZYS3lMdVBjaWJlYTdRWWo4Z2hq?=
 =?utf-8?B?S3BBc1hRMGozcDNVN0Y3M1FBbmFKVjlvcWdxRGVwYlEvSmxuTWFYcUUrOTdv?=
 =?utf-8?B?NmRjc2o1ZkhKVm91dFpXWUtyYjZyTkM0K3ZOZm5tVmhIYm9Jcnh2OHpwY2cr?=
 =?utf-8?B?ejc5R0Z1M3QxZUd1dTNjOWx2MmcvM0N2U3cya2h5Nll3RnZQZ01WZVpsUzdn?=
 =?utf-8?B?amhXbDhtZEVqb2VKUmxYNlhjancyTXdLS0ZRNE11SThKTDZ3NGxsUHRlaHpP?=
 =?utf-8?B?T0FtTnJXS2F4d0tYem96ME05UmZjRHQ0MjNMSVBjaWRTYmlSUXkrWXZkQmlC?=
 =?utf-8?B?RUpMV0lSZGNkL2tBa0dmWTlUcFNEODFJbVMwYXBhUVRyN3ZDZEI1dWdlZlFV?=
 =?utf-8?B?aDdlT3RaN3ltekZqVVM4VkFsYVpsNlJaVlpDY3d4aHhUNytDRE5DeENrVDRI?=
 =?utf-8?B?Y3p2RzNUVkVGOWJSN1ZGQXlZZkY0WVVaNkxUQ0pRM0cxalpkNzZMY1lCZ05B?=
 =?utf-8?B?cmo3bXFFYzRCMlRmT1htV29aYnpqbTNlT3VUWnB4TVUxN0s3S1lkMStnckFj?=
 =?utf-8?B?WGFsdmROWnVZbzVaL0c4NzNxVzlETWdFaW85TTg4bDUyTWZlOHBGVExEUWt5?=
 =?utf-8?B?SnlQdFhpNkpMbU9abkVNbHRDVG8wY3lNZ0N0dHVJc1VWRy9YbG9MRWpUbkxC?=
 =?utf-8?B?M0FGNW14cVBuWXg5b0FiV21nYnB0S2ptREFrcFRCNXVKQk1sYlIwcUEwT0Ny?=
 =?utf-8?B?ZVFNc24rZm0xb1NmWjBVSmhydnI2SUlXQWZpYm16dG1GSEVRZVFpQWg4QVd5?=
 =?utf-8?Q?cX+Mxp+8BvRMy4Qs/739sVzDs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21B773BA4EC1134F9448879E9627F541@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89003358-3043-43fa-04ca-08dab29a0d33
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 12:53:14.2345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IdGon/PVHorJkIvX/ku1K5TLAO5LVzUBv8hE6nyl/SVTy2ME51H0i6hsdWy7OFNa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3752
X-Proofpoint-ORIG-GUID: 3psBt7aBywlSduLKdGnSoblc9Uq71IGI
X-Proofpoint-GUID: 3psBt7aBywlSduLKdGnSoblc9Uq71IGI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTIwIGF0IDE4OjUyICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
RnJvbTogQW1tYXIgRmFpemkgPGFtbWFyZmFpemkyQGdudXdlZWIub3JnPg0KPiANCj4gLSBQYXRj
aCAyIGlzIHRvIGludHJvZHVjZSBMSUJVUklOR19DRkxBR1MgdmFyaWFibGUgaW4gdGhlIE1ha2Vm
aWxlLg0KPiBXZQ0KPiDCoCBuZWVkIHRoaXMgdmFyYWlibGUgdG8gYXBwbHkgc3BlY2lmaWMgY29t
cGlsZXIgZmxhZ3MgdG8gdGhlIG1haW4NCj4gwqAgbGlicmFyeSBvbmx5LiBDdXJyZW50bHksIHRo
aXMgZmxhZyBpcyBvbmx5IHVzZWQgYnkgdGhlIEdpdEh1YiBib3QuDQo+IA0KPiAtIFBhdGNoIDMg
aXMgdG8gaW50ZWdyYXRlIGAtV3Nob3J0ZW4tNjQtdG8tMzJgIGZsYWcgdG8gdGhlIEdpdEh1Yg0K
PiBib3QuDQoNCg0KSSB0aGluayBiZXR0ZXIgdG8gdGFrZSBteSBjby1hdXRob3JlZCBhbmQgc2ln
bmVkLW9mZiB0YWdzIGZyb20gcGF0Y2gNCjIvMywgYXMgaXRzIG5vdCByZWFsbHkgc2ltaWxhciB0
byB3aGF0IEkgaGFkIGRvbmUNCg0KVGhhbmtzLA0KRHlsYW4NCg==
