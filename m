Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB954ABF5
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 10:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355470AbiFNIkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 04:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355627AbiFNIkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 04:40:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A601F44A38
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 01:38:40 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E3jjdH006613
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 01:38:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9Iheqi8aBSPYcXFHVgSzhfK4lNOsFv6LSHO2k2xHeZE=;
 b=napP59YfXkkshcXCRW7PIbqZt/GbCHLJAiKlMcyEGZtcs+XoPNYUlZ5dfpgAeN7PpfWi
 MX20z9Ew85tSOP09i7lrm+4NFBquy3K506MFEJS05v3022MxW+utRDyYN+DRRmKDbmqZ
 BGjzgmIzumpxpRoyNUpjygpgNePuLT2vzuc= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmpcmp7uk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 01:38:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSF1ta1hpEcseLX2f74LC9xSxA/l8+z+jjhhi6WxFpyRNGbs6pULgYdNNhWgNKj84K3ulPI8yL1LfeYDolB+rYNhQgbZ9Sxz6h55htVb9AAHOGSCyUIfrwCx+KLfnDIz7zQRySNsSXU1o0wqz4jKKl9wMNPDzpwQthq3RssgoYXR5AvYhPCsZhIg6NjaJD5Wdzslx65GO86JnHGL/8aOWaE2E8DxoPgOuvtyRx59nRiMLYfZWRR78ZRPXZEwBz5atuQHuw4Z676fV/D+GirBR+W73FzJZfKjI3yyCNVewq9sAMBU5OnjaRvGILCPO+RoNQ0GaPHoj7jrsJwGDB7kRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Iheqi8aBSPYcXFHVgSzhfK4lNOsFv6LSHO2k2xHeZE=;
 b=QTSw3NbTTzeVfx87PdjO8ONlL/cBFqWRSyvBM8lwNZ4Ow3m/VbiPptzeb2FKPC4qO9C2k9eV70SmudjfSzpN+rmDyUG5F2uxHMgqBlI3QSGS9NQF1ylxv8A5tsslgW81ov9ieNMAHG58AAnOXpyqnn5ZPkpcvnmYpOdjKuhM69+NSmdhX8VKplUhm1OncsJRiSkVlOygBoHHzglLZ2QpqSfrdKwhFbpzOjwnDXJ8JtA9Be+WC8nsyizHbEOXROpRA4fbSVXTk9GuegGvqZ+DgylAzskSZAYi+UdbCyGnRT416bG4fZLdPgZAOtHFzmRTxPRSsRXz8XwWnTeeOVJnyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BYAPR15MB2663.namprd15.prod.outlook.com (2603:10b6:a03:15c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 08:38:32 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5062:4f9f:83f3:1100]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5062:4f9f:83f3:1100%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 08:38:32 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "hao.xu@linux.dev" <hao.xu@linux.dev>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [RFC] support memory recycle for ring-mapped provided buffer
Thread-Topic: [RFC] support memory recycle for ring-mapped provided buffer
Thread-Index: AQHYfI7F8AYCLiEXt06J06TK5OpSka1LY1WAgAMSxwCAACUIAA==
Date:   Tue, 14 Jun 2022 08:38:32 +0000
Message-ID: <a62d21cc5a3f9741673f9bf912d2ec4c97c4e193.camel@fb.com>
References: <6641baea-ba35-fb31-b2e7-901d72e9d9a0@linux.dev>
         <4980fd4d-b1f3-7b1c-8bfc-6be4d31f9da0@linux.dev>
         <d4aada77-1dce-55e7-3a7c-bf4b3add3ac3@linux.dev>
In-Reply-To: <d4aada77-1dce-55e7-3a7c-bf4b3add3ac3@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34e033d5-7a3b-4e2c-f4ba-08da4de143d3
x-ms-traffictypediagnostic: BYAPR15MB2663:EE_
x-microsoft-antispam-prvs: <BYAPR15MB2663D8AE170049A4462F4A9DB6AA9@BYAPR15MB2663.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dNsgEDpwAfqwXm2AepPeUkXhAD2pE8Rbj4yval0ogxMztANxYGIGR/McxmXKmqiDbQVGwVGNArTcg/eYu8JRZxyoKWLDEmEf5QygIbaIgjRJhY7TOggTDX4OV7xcLMzCAShOIIF0dYpiqxuWGCvBcjidFQZgLv7zv4kcwKTZKKUeNrWzKQB1v9jcdcYKr2gh/jgXkvj8XPS+tOPFdiivg2uYGmcQoMZST0zF4/KmC4EqpeU8f9LUGAoKrVOI+0bBoU4ck5cfrnbTeJKTTtGa7bB6cCRSv1dqAZo1MsihDZOPqBs6A5kYgpLeLSw2n0gbOY68kc1bC8zFaFt+s1EiFemRlZ5oUzTkfkruTduUHhcQ6Fy/y9dKMhdjfWa3r0lDuGwtyIvCiDXYU3R77l7KnGVo8uBTn4NAkjt1dflM+jVAHU8rChW9ByFe/mHwtjy5qFxQY7Y4LBMdMi55FZS7g/QfPYL+IK8MAMOvCqfT05XKJ9pnvQ3GWRhh93nVKoKecnGYMctS1uYxT2RHzElf5fnvWzmLZ3GA36SaGLt8b4V8hiQ3sKTOcZuO5w8Yanl8Mi+CxUc5iotu8fdC0mdsck6kvgXgB0cIMdfVunfb++HE602iHZ5EnIG+rt8lwVQNiNvachHDvqUh9FTaBcFWMyYs35tiqMwZtzLN3fLx2kf7dgbfsvkPuJhySXCU7GEj98FK14PwPv6E/mN396cCWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(6512007)(83380400001)(66556008)(186003)(6506007)(110136005)(91956017)(54906003)(316002)(36756003)(2906002)(5660300002)(66446008)(508600001)(53546011)(86362001)(76116006)(8936002)(71200400001)(6486002)(122000001)(38070700005)(4326008)(66946007)(66476007)(38100700002)(8676002)(64756008)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGVXTmt4cm9QZ2NWVCtZeW5yKzdnc0p0SVlZaUEvZURJTTBlUUIwSXlLTkFh?=
 =?utf-8?B?bWdsREVxdmRLdTVWbVMybTlXYVlZZ251bHh6WTZSaWRnajZGdFpnZ1lPVDF5?=
 =?utf-8?B?VGtqdE9pNkxQQnljK2l0QW4xYlo0STJjSGtjWm9TY003eFhWTXYvME5DZFpE?=
 =?utf-8?B?QXpuanUxWU01cFdxQkNBWW1sSVl6OEh3Q1pvK3BpM1pxdFdteHBiNVNOUnVv?=
 =?utf-8?B?OFI3em41c0VGMHBEZDRJZmtaOStudm9UblUwb3pVM3Q3RGdSOGM1YmNnakY0?=
 =?utf-8?B?b1FIOFZONG01V0pMZnVUSE5Bb3VYNEcyVGVuVG5QenlxU2N2OW1kbTNhNHZ3?=
 =?utf-8?B?cVhIZ3VkR2NNeTd5Mlg0U3hjSXlpaldyeXFIUVNIZTRMWC9CYXByNmo2THRo?=
 =?utf-8?B?MWFVdk1EVVgrMmJrVkxPODh2SXI2dFhDdGMzQnlyTnozVHJLZU1laWV3MU5U?=
 =?utf-8?B?U0RDM1Uvb0dUVyt6ZityWlhDNHA5L3VaL0RRZEJxclhNV3ZhOEJFNTVDS2FZ?=
 =?utf-8?B?VkVVeTNIbTBJZzRySjVEd0JweStKTkhHdHVRSlhZdGhtWFp2K0p2end5MFRO?=
 =?utf-8?B?WS9uV0p2bjUvbkZYSUFkek5FaFkyNUM1Vjl5VVEzWlBWRkd6U3p2SnJ1RmN6?=
 =?utf-8?B?RXBaWnpRSHlHZUY2OU9CalZubzdqK2pKUklUMXo1T0x0cnlkK2Uwdmc2OUwv?=
 =?utf-8?B?WkxmQ0dBbmZMd2d1V2NhdlU2emFxa0l4K3VVMnI5ZS8vOHJkMmJPbWZVeVli?=
 =?utf-8?B?MElJNWJsU1B1VHRMV0ltcnRmUlBDWUMwa3JpMXowUUlOQWVUSDVxYVFoYXhm?=
 =?utf-8?B?SHNVb292N09mUlh5VWwxSlRXSEp0cXY1blZRKzhwTFlMUDQyVmVUUWtiQnVs?=
 =?utf-8?B?VDF0LzRYb1NSWnJvWGFiSFhNTzkrN3NxYVFrWkNoOFV0eWgxNGtkZk9tWS9Y?=
 =?utf-8?B?N094Q2NyYm9sMHhTV1F4V1pYdkFIMUNjWUVUNTNkVHZwMzFBVWc4L1ZVRWgw?=
 =?utf-8?B?Z2t1SzNwZkZrZTJROW1sb3JWNmhEMjZuYXJOWStjQXJRWTFCblA3MVE1V3Vn?=
 =?utf-8?B?VExTakRmVkhoZEphcUxScEhyTXpPcWRiNmVwTi9SQlZhTm5EQlZUTHdJUDdu?=
 =?utf-8?B?b1J6RW1ycDVPRXB2T3ZqU2M0M0xrdnFYNzVEbFp0MXF3SXMveUhNZjJOTEds?=
 =?utf-8?B?Y20rT3gvY2w1eWZ3cktFSjM0eWg2NjhiL21wbFV0VHdCcGVqa2M4R3lVYTBa?=
 =?utf-8?B?dC9ORTZFdEtPdkU4SDEwODc2anh0T1dTelFxaVk0ZVJVQXBGbS8yUmJiWTJE?=
 =?utf-8?B?ckRzTEx0WHJ6MHByamxwekE2L25laHpDVS82akMzWTRlSXpxRHlMMjJHK0gw?=
 =?utf-8?B?bkJ5clhhYnZ1aEttV0FLek9McEZZcjFQdXppSERjM2F6L3Y1bDRWK0VQb1JB?=
 =?utf-8?B?OTExQW1XY2RhaTlhUTFBeUhLZzBaTTRMa1hxSlY1b2hYbXl6MkVva0xadDlp?=
 =?utf-8?B?eGJSVmFIY0szUFVLTDVkdWdERFowczF0NFR1bmZUWjdNVGs3ejQxUndobGc5?=
 =?utf-8?B?NmRXSnUxSnpjdnZ5QzUySzVDRThDMTB6Y0lFZlFKU0ZJdnRaS1NlMXYxeHI0?=
 =?utf-8?B?S0EyWk9sOGdYTWJwckdkSjBkb3YyM3JxUUl5aXdhTDU1YXVOV3FibkxBY25n?=
 =?utf-8?B?YkRRbExXc0ZOcXVscWhPV1BBOFF4cGY4U2V3T0RNZmRqcElxaUNnMWlmNDMw?=
 =?utf-8?B?M1JOWkFLWDdlSCs4Z2hMcnZnL0NkeHd0S1Vmck5pUHEwVWdEbDgrQjZ6K2xz?=
 =?utf-8?B?TmJTKzBRSXduN3R2MWdrUmdkY05SbWd3Z2o3c1BLaENTOHhsc2xjZml2ZEZ6?=
 =?utf-8?B?YUhRelp1U0V0dFVnOFhqcVZKbjM4TzFTN1Q5RlRTZFJkbzErb1BJc3NJLzF5?=
 =?utf-8?B?K0NqREV3anR1Q1lDZEJHSWtiQ0twczM2d1RlaTQwdmZTdWpxOFNudGlGc1Uy?=
 =?utf-8?B?SDlNUHpVdHBmVjk5WVJubXJtUW53cWptOHVQTkIzc3FjRzMvNW9oelZwVWR2?=
 =?utf-8?B?UmJCZXVOcHNuekppTjBMWWhvWDZIbThsTEFFakFXN2lqaVczM05rQVMvTXRP?=
 =?utf-8?B?MXI2WWl0TnJmcjlUbjNrU21QMHhGY28yaXM0UVZ2YlArLzlMMHVza1JyMlh2?=
 =?utf-8?B?RFllN1dLbzMwVTRRWlZWUUJkNjJXN0hUbEFGWWpiWk5SelhDdGtMdUdlYzY4?=
 =?utf-8?B?VlM0REtzUDNMMEhnaUs0eGFPMFlNZjd4bFpQZ1JNMWJ4cEpmM3Ivem1MTStK?=
 =?utf-8?B?MEdsejJkckVDQkpuNFo5NjRGM21GNFdUWnRoK05UdVFORWFPN3AxOG9GM3Ew?=
 =?utf-8?Q?69a8AEBQTpCI/xgU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3B5569A9EFA894484E741938A809EEF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e033d5-7a3b-4e2c-f4ba-08da4de143d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 08:38:32.6822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4RBzJHY+tziCUFnKH2FuJzavS+opZP7wYSCRiMW4VERxy/2iHkwIFTUQ6mD46jbH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2663
X-Proofpoint-ORIG-GUID: EVJP9z88W5JQeUpoekVfVEPcpcyv9YWF
X-Proofpoint-GUID: EVJP9z88W5JQeUpoekVfVEPcpcyv9YWF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_02,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTE0IGF0IDE0OjI2ICswODAwLCBIYW8gWHUgd3JvdGU6DQo+IE9uIDYv
MTIvMjIgMTU6MzAsIEhhbyBYdSB3cm90ZToNCj4gPiBPbiA2LzEwLzIyIDEzOjU1LCBIYW8gWHUg
d3JvdGU6DQo+ID4gPiBIaSBhbGwsDQo+ID4gPiANCj4gPiA+IEkndmUgYWN0dWFsbHkgZG9uZSBt
b3N0IGNvZGUgb2YgdGhpcywgYnV0IEkgdGhpbmsgaXQncyBuZWNlc3NhcnkNCj4gPiA+IHRvDQo+
ID4gPiBmaXJzdCBhc2sgY29tbXVuaXR5IGZvciBjb21tZW50cyBvbiB0aGUgZGVzaWduLiB3aGF0
IEkgZG8gaXMgd2hlbg0KPiA+ID4gY29uc3VtaW5nIGEgYnVmZmVyLCBkb24ndCBpbmNyZW1lbnQg
dGhlIGhlYWQsIGJ1dCBjaGVjayB0aGUNCj4gPiA+IGxlbmd0aA0KPiA+ID4gaW4gcmVhbCB1c2Uu
IFRoZW4gdXBkYXRlIHRoZSBidWZmZXIgaW5mbyBsaWtlDQo+ID4gPiBidWZmLT5hZGRyICs9IGxl
biwgYnVmZi0+bGVuIC09IGxlbjsNCj4gPiA+IChvZmYgY291cnNlIGlmIGEgcmVxIGNvbnN1bWVz
IHRoZSB3aG9sZSBidWZmZXIsIGp1c3QgaW5jcmVtZW50DQo+ID4gPiBoZWFkKQ0KPiA+ID4gYW5k
IHNpbmNlIHdlIG5vdyBjaGFuZ2VkIHRoZSBhZGRyIG9mIGJ1ZmZlciwgYSBzaW1wbGUgYnVmZmVy
IGlkDQo+ID4gPiBpcw0KPiA+ID4gdXNlbGVzcyBmb3IgdXNlcnNwYWNlIHRvIGdldCB0aGUgZGF0
YS4gV2UgaGF2ZSB0byBkZWxpdmVyIHRoZQ0KPiA+ID4gb3JpZ2luYWwNCj4gPiA+IGFkZHIgYmFj
ayB0byB1c2Vyc3BhY2UgdGhyb3VnaCBjcWUtPmV4dHJhMSwgd2hpY2ggbWVhbnMgdGhpcw0KPiA+
ID4gZmVhdHVyZQ0KPiA+ID4gbmVlZHMgQ1FFMzIgdG8gYmUgb24uDQo+ID4gPiBUaGlzIHdheSBh
IHByb3ZpZGVkIGJ1ZmZlciBtYXkgYmUgc3BsaXRlZCB0byBtYW55IHBpZWNlcywgYW5kDQo+ID4g
PiB1c2Vyc3BhY2UNCj4gPiA+IHNob3VsZCB0cmFjayBlYWNoIHBpZWNlLCB3aGVuIGFsbCB0aGUg
cGllY2VzIGFyZSBzcGFyZSBhZ2FpbiwNCj4gPiA+IHRoZXkgY2FuDQo+ID4gPiByZS1wcm92aWRl
IHRoZSBidWZmZXIuKHRoZXkgY2FuIHN1cmVseSByZS1wcm92aWRlIGVhY2ggcGllY2UNCj4gPiA+
IHNlcGFyYXRlbHkNCj4gPiA+IGJ1dCB0aGF0IGNhdXNlcyBtb3JlIGFuZCBtb3JlIG1lbW9yeSBm
cmFnbWVudHMsIGFueXdheSwgaXQncw0KPiA+ID4gdXNlcnMnDQo+ID4gPiBjaG9pY2UuKQ0KPiA+
ID4gDQo+ID4gPiBIb3cgZG8geW91IHRoaW5rIG9mIHRoaXM/IEFjdHVhbGx5IEknbSBub3QgYSBm
dW4gb2YgYmlnIGNxZSwgaXQncw0KPiA+ID4gbm90DQo+ID4gPiBwZXJmZWN0IHRvIGhhdmUgdGhl
IGxpbWl0YXRpb24gb2YgaGF2aW5nIENRRTMyIG9uLCBidXQgc2VlbXMgbm8NCj4gPiA+IG90aGVy
DQo+ID4gPiBvcHRpb24/DQo+IA0KPiBBbm90aGVyIHdheSBpcyB0d28gcmluZ3MsIGp1c3QgbGlr
ZSBzcXJpbmcgYW5kIGNxcmluZy4gVXNlcnMgcHJvdmlkZQ0KPiBidWZmZXJzIHRvIHNxcmluZywg
a2VybmVsIGZldGNoZXMgaXQgYW5kIHdoZW4gZGF0YSBpcyB0aGVyZSBwdXQgaXQgdG8NCj4gY3Fy
aW5nIGZvciB1c2VycyB0byByZWFkLiBUaGUgZG93bnNpZGUgaXMgd2UgbmVlZCB0byBjb3B5IHRo
ZSBidWZmZXINCj4gbWV0YWRhdGEuIGFuZCB0aGVyZSBpcyBhIGxpbWl0YXRpb24gb2YgaG93IG1h
bnkgdGltZXMgd2UgY2FuIHNwbGl0DQo+IHRoZQ0KPiBidWZmZXIgc2luY2UgdGhlIGNxcmluZyBo
YXMgYSBsZW5ndGguDQo+IA0KPiA+ID4gDQo+ID4gPiBUaGFua3MsDQo+ID4gPiBIYW8NCj4gPiAN
Cj4gPiBUbyBpbXBsZW1lbnQgdGhpcywgQ1FFMzIgaGF2ZSB0byBiZSBpbnRyb2R1Y2VkIHRvIGFs
bW9zdA0KPiA+IGV2ZXJ5d2hlcmUuDQo+ID4gRm9yIGV4YW1wbGUgZm9yIGlvX2lzc3VlX3NxZToN
Cj4gPiANCj4gPiBkZWYtPmlzc3VlKCk7DQo+ID4gaWYgKHVubGlrZWx5KENRRTMyKSkNCj4gPiDC
oMKgwqDCoCBfX2lvX3JlcV9jb21wbGV0ZTMyKCk7DQo+ID4gZWxzZQ0KPiA+IMKgwqDCoMKgIF9f
aW9fcmVxX2NvbXBsZXRlKCk7DQo+ID4gDQo+ID4gd2hpY2ggd2lsbCBjZXJudGFpbmx5IGhhdmUg
c29tZSBvdmVyaGVhZCBmb3IgbWFpbiBwYXRoLiBBbnkNCj4gPiBjb21tZW50cz8NCj4gPiANCj4g
PiBSZWdhcmRzLA0KPiA+IEhhbw0KPiA+IA0KPiANCg0KSSBmaW5kIHRoZSBpZGVhIGludGVyZXN0
aW5nLCBidXQgaXMgaXQgZGVmaW5pdGVseSB3b3J0aCBkb2luZz/CoA0KDQpPdGhlciBkb3duc2lk
ZXMgSSBzZWUgd2l0aCB0aGlzIGFwcHJvYWNoOg0KKiB1c2Vyc3BhY2Ugd291bGQgaGF2ZSB0byBr
ZWVwIHRyYWNrIG9mIHdoZW4gYSBidWZmZXIgaXMgZmluaXNoZWQuIFRoaXMNCm1pZ2h0IGdldCBj
b21wbGljYXRlZC7CoA0KKiB0aGVyZSBpcyBhIHByb2JsZW0gb2YgdGlueSB3cml0ZXMgLSB3b3Vs
ZCB3ZSB3YW50IHRvIHN1cHBvcnQgYQ0KbWluaW11bSBidWZmZXIgc2l6ZT8NCg0KSSB0aGluayBp
biBnZW5lcmFsIGl0IGNhbiBiZSBhY2hlaXZlZCB1c2luZyB0aGUgZXhpc3RpbmcgYnVmZmVyIHJp
bmcNCmFuZCBsZWF2ZSB0aGUgbWFuYWdlbWVudCB0byB1c2Vyc3BhY2UuIEZvciBleGFtcGxlIGlm
IGEgdXNlciBwcmVwYXJlcyBhDQpyaW5nIHdpdGggTiBsYXJnZSBidWZmZXJzLCBvbiBlYWNoIGNv
bXBsZXRpb24gdGhlIHVzZXIgaXMgZnJlZSB0bw0KcmVxdWV1ZSB0aGF0IGJ1ZmZlciB3aXRob3V0
IHRoZSByZWNlbnRseSBjb21wbGV0ZWQgY2h1bmsuIA0KDQpUaGUgZG93bnNpZGVzIGhlcmUgSSBz
ZWUgYXJlOg0KICogdGhlcmUgaXMgYSBkZWxheSB0byByZXF1ZXVpbmcgdGhlIGJ1ZmZlci4gVGhp
cyBtaWdodCBjYXVzZSBtb3JlDQpFTk9CVUZTLiBQcmFjdGljYWxseSBJICdmZWVsJyB0aGlzIHdp
bGwgbm90IGJlIGEgYmlnIHByb2JsZW0gaW4NCnByYWN0aWNlDQogKiB0aGVyZSBpcyBhbiBhZGRp
dGlvbmFsIGF0b21pYyBpbmNyZW1lbW50IG9uIHRoZSByaW5nDQoNCkRvIHlvdSBmZWVsIHRoZSB3
aW5zIGFyZSB3b3J0aCB0aGUgZXh0cmEgY29tcGxleGl0eT8NCg0KDQo=
