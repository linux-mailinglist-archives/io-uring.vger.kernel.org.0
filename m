Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF347614A53
	for <lists+io-uring@lfdr.de>; Tue,  1 Nov 2022 13:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKAMKA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Nov 2022 08:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKAMJ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Nov 2022 08:09:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B7CC29
        for <io-uring@vger.kernel.org>; Tue,  1 Nov 2022 05:09:55 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1Ac4xA018336
        for <io-uring@vger.kernel.org>; Tue, 1 Nov 2022 05:09:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=GHgVrtQsIsU7/YDiSjqNF3ZCAJ6aPhLbhtGcn2jKSIQ=;
 b=KmaArDWkMejkLD8jfRsLJEqlwEQb2m+CS7k4ijvw/1a3ETb0HFyKzUf7iSRFe7hMvl8C
 QshUFqw8K72IdO2j+q2nUBNkifACBCEFTogXJfmHxOKP121WWzSrtud744wBkWykMzJY
 d/lCwHJc0iy6zXvPRRn6KPHPmcJz7shnJ26daLRA/u3jgbwkdmZNALV51eRuFtT/3pqo
 bexTNRq9t2O7fcCvJ2Zh99QsfDtWuQ+d3ipKpKnu/lAPlpY13oNruj1J/j4WZOM8aok3
 SZoEQcd/Ps3bOXr7YtHUXk9K20EAsn8fTjDgEAgGOrwTWSA8yXD4CyF7DNPBuiTnL7z1 qg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kk1va0mfh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 01 Nov 2022 05:09:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3B84xH6cPxZXBW0NGEc39iUsXbpYTyfHGIZdlwQao0TT0++PHyHUHNCb0FPR+1l5OCooGBd3Hb40OG3TWI3rvwqYRlMWEAibEjZe6PLGQsQGuDtuqDEFGD0B8uQzpHOSmtnhyVHoBQxPf1F4/Fjv+E882sdoU3zHam94dw3H5A256WlNcn/VDJzkR27FA2pD6FBAxX47F++nKPLJOZETj8Wb4WZih1htXkXVttw+bWr0alsZsctHrFPq0Uh8TlL43Jv+RjK7bHHUXjd1ahcVuK/5G20EWlPAjADa4YRKGUOarBr47DgiVGIIB9FE+m1lF7WDyPjd1Tzk+gPI+/Xzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHgVrtQsIsU7/YDiSjqNF3ZCAJ6aPhLbhtGcn2jKSIQ=;
 b=iynw9UI3OQNUDib3yUlAt60Aw6rg+R2xEJy60H07IkZD6F06J8YL363jXHcS/uWlyEtEUdkgDdZrbQOOhcmoK+1lZLOVtpxs597GqEvW4p39+UYfvaG2/egyY917M7SkiIMaY416WkJdLeqS+n1t53ZxSibB3rFZiKVOqABSjdv5j+uCnto3oKHnlcABUJAZ2AUtWWLXP0KIfVCUimlN9nQ1DsVqDk5hVIVLkyeGsqN+7JR601lNBPjIsoRoVbM0aBBxapUS87sRBfL6qsgUblYAilr4t0fFiTv9/ne2GQmAEIcq2EwvsQmYMP9+UNPE1fq0oAeXLFzBDz3RFkgEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BY3PR15MB4884.namprd15.prod.outlook.com (2603:10b6:a03:3c3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Tue, 1 Nov
 2022 12:09:52 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 12:09:52 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next 04/12] io_uring: reschedule retargeting at
 shutdown of ring
Thread-Topic: [PATCH for-next 04/12] io_uring: reschedule retargeting at
 shutdown of ring
Thread-Index: AQHY7S6KH5nh0ASq+0qMfb8/p5fu/K4oqdoAgAAL/QCAAClrgIABHBCA
Date:   Tue, 1 Nov 2022 12:09:52 +0000
Message-ID: <44de84ef6043a42918c94546e670303bbc4ed080.camel@fb.com>
References: <20221031134126.82928-1-dylany@meta.com>
         <20221031134126.82928-5-dylany@meta.com>
         <83a1653e-a593-ec0e-eb0d-7850d1a0c694@kernel.dk>
         <e56548935adffbbe3ee19a0701a25ee5fb97a79b.camel@fb.com>
         <babb9c9a-cba6-fdb1-93ad-a7339c921ecb@kernel.dk>
In-Reply-To: <babb9c9a-cba6-fdb1-93ad-a7339c921ecb@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|BY3PR15MB4884:EE_
x-ms-office365-filtering-correlation-id: 4667c5af-26ce-4d99-e085-08dabc01fb5f
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDZgOiRSOXeIvKDeQgu3w8/pQMmFVZehYQtT1SxNk6sDSbqToJnCP6VtTEW9NyydykBeHPg/1Q58NtMigGl1CHj3OG6gdUp5wow7oBhWHCJNXvH6+J6X2jomLJSpCRuefXvcH5QbYw/EzrahdoG/gB8VBZ9pgAtn3Efd8YLTgIMVCE+HgNnSSpxzm1PovYm89oekc5sWDbZWGoidQISWLcRLF8MxjrROYeIOLverQ/U9vzmmWLu9/LPPYVjVds7Os6pQtNq3hfoKVpidcNs+ovR34a6EWkrftOORerQ7IvY2i/YyR5D4WZW1SPhRG6cf+3NWokXdNDg0AFVVj6FH0uwf8YCLXbv0PXtLZPtJLbzcsQ1HOLhrVW2kKxUdh/NEV3rGhpBS9ANMPis/JRfxCvRX6lJH/mTaI+mtRrkU96l6hIvN0/6apznmdx5vVZPQ/rxi4dJZoifFiSSxEImHBXoMmbEhXh3xxDoXk87lcxboadQQ8VaFGU+TqN6O83qkwHPFXeb9MuQNOKdClB/bh8qKr42JA+9WJU2T0lP5+m0UhuRwMvHNUaqda+kSkuZgohjhgEx0EH7d800cWjSVwmtuA555OGHSY1oH45vTN1lF1Lo/rDB4gMYU6FGQ/lENkBt+a4zjtR723jrT5VNzcaI2qaEks1oHt+cPYDICnzzIe1QqiebKFz0ccjqx8hDQK5h8B/sntvfzCZJrwUAmCHNsGi9axXQ9SVnWW3EF958xEGUul2Vxpv5Dm/mL7MjKSPzl9pYb23iVK7C/OaKMfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199015)(71200400001)(91956017)(6486002)(66446008)(6506007)(76116006)(8676002)(66556008)(53546011)(66476007)(4326008)(66946007)(64756008)(478600001)(122000001)(54906003)(110136005)(36756003)(38100700002)(316002)(38070700005)(83380400001)(6512007)(41300700001)(9686003)(2906002)(4001150100001)(86362001)(26005)(186003)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3RET1VEL2FPSUFRUVQzcjFtY0doamZEUjJEMG5PTGFzZmJ0TkRWVnN5UGZM?=
 =?utf-8?B?SjFPcUYyL2lkWldpaE1MQkEyWFRNV0FHUFA2R0FvM1pGSmVucU4zVXo5THdP?=
 =?utf-8?B?bDhBZDRVQ0VDMDlZSXNLRDl5WnJuTWNtb0dLUytnTmg1aElENjVtcHBvQnBr?=
 =?utf-8?B?ZFlrT1hDUDZSM3JqS2p4cXZHQUVuVE5NbURISjJLaGZLSFFRY0tMdTBiZVps?=
 =?utf-8?B?UWpGRkZ4RXpnK1ZIdDNLdDB4a01UcmtMblovK1dzZWZBaG9RNEt3WHhsdkNV?=
 =?utf-8?B?dUlVQktGRkhyNHNLeVdkY1Z3N25GK25rcnpDWENCU3g2RGtUcDVrVXpTcUVw?=
 =?utf-8?B?UXRBOFR0MXZySFA0anVxWFdWTXVXMTQzeEczdjdNRWNONFc0MTFmS1RjTTlq?=
 =?utf-8?B?UzI5WnJMaUMwQzIyelNHQXNIamhJdDJoZ2tXT0FmSmJlQkhPdktsa2o2QTdF?=
 =?utf-8?B?V3JhaGdLWHdNaFB5UmJFYWUzZXdLbE5QeDFpTGNtS09lK3cvdW9UUllvS21P?=
 =?utf-8?B?Sm9iWlhpbGRpWFowTFZ5VWNPb09acnJCU0Nxd3p6d1ptQUZuR2NzUy9lL01C?=
 =?utf-8?B?Z21EMk8rSXEyYi9KK1pzUEkzeGdRcGFCd1o3OVlYOGNVL015dlowZjdhblMz?=
 =?utf-8?B?WjNPUzk1UEZoR29zbWNKYTlXczlzejlUa04rOUNUWmVTb3pNeDU1UXMrbmIx?=
 =?utf-8?B?RXplZ2ZvU3k5MDdqTnpwbEt1NXlLUXpWbmRrWXNqN09GMWh5MUVkZFpONjVW?=
 =?utf-8?B?ZzN2R21DUEJjdmxXZ1dCZ3B2bHMxcXloQ28vZzFHRFd3VXA0aXp4akxqaGkw?=
 =?utf-8?B?ZnFwYWQ1azNROTZ0NmJXWUN5d3pZblFQN2xVTHFUaXZlV0MzQ0lnbmVMTFBB?=
 =?utf-8?B?QndsN0NFKzJrdlYzdXp3bGFFNTgzVXBLckZjODVtc1dpcmxZN3hmWWxiUWZl?=
 =?utf-8?B?STdpTGZJMnUxRVZuK1JLWXBoUGpxZnM2VGJRTzRQc2lrWkN5NmJ2eUV6amF2?=
 =?utf-8?B?aDIzcjBxU2hzUlJ6aEJrSnhtd0k4czIrVzd2ZFVsZW5qV0lzcmxZK2lsTWxT?=
 =?utf-8?B?eVcwVWNsdlN5c294Sk13WkFUMk1idXdGenhENjA0RGx5cXhaeU5tWFRmZ0NC?=
 =?utf-8?B?S0grYTREbmhSaFVIaFVZcWxZY1l6RkMwVHFyZDMxaG9UOFN3bzVkL1o4VUNy?=
 =?utf-8?B?eWVGU1Zsa1NpWEtTQ1o0OTliOGRsY2xia3lrWlRVck9oL0I3M3RnMXg4N1dK?=
 =?utf-8?B?L2ViWjVnSTlmYUNFRlA0RWxXTlRNYy9qMjhvcUEzaUI5OS9uQnR2R1plaWh6?=
 =?utf-8?B?RWl0b1c5NzVabGF2QS9JeWdHazFPekhEY3h1bGRLUU5ZeG84RnVYSnhiRlVj?=
 =?utf-8?B?ZDZMMFZMbmdaZkx1YTZoYkxCU0VVcUd0dDJNZjJzTHhoZHJUK0M5M0JkMEkr?=
 =?utf-8?B?NXQ4ZDJJbFdJcmxDMXgwNHNqazhOV2I0dXhnRDFLam5uOWF4MmlNcTlDbEs0?=
 =?utf-8?B?R05tWXBxTVM4S0ZTWkgzRGluQzJuNDNGMHVIdmJjQ0UwNkFkbytiRDhFSDgw?=
 =?utf-8?B?emttL2xVZkU0WXJzd1lXU2pRWGcvU2dFaHA2RDROVlVEaDhCVEd1NnduS3hk?=
 =?utf-8?B?YWxmSG5JZUdZdUxva2RNaUVYV1BXaXduMG1xdGp3VDRtK0xWeDQvMVhOOVEv?=
 =?utf-8?B?NS9WYUdnUkxCU1lVamU3dytuY2JtUjdnL0xOSEVXQ1BLNEdsWFIxR1d6UGZR?=
 =?utf-8?B?ZzVabWRsdlh2TENrb09Ed0RnSWdHMjF2RGI4TjQ5VTA3UVN3ZVdKZ3RFZWJB?=
 =?utf-8?B?WFB3c0tZa045Q0JmeTdQMWFPbHFqdXlmNlI3VjYrV2dRTUxlOENzMFR0dkow?=
 =?utf-8?B?K1JIMXRydXJRS2s1d3JYU1owY21rd3BpQTBTbjM1a1ZSK0cvSExJcnRvS3p0?=
 =?utf-8?B?VG5CRWp3QjJUZkZ6WVZ4NlNMUUE3bkJYZXFIMjBtTnZPV2JsZlBKSE5kN1Zl?=
 =?utf-8?B?ZWwvcnVPaG1RWTJWR0dPeFFrblF4ZWdSUW9ISDZpcDF2RUlPbm5WUzZ5bHdP?=
 =?utf-8?B?QTVHaXBEb01NQXB4M2toNDlZZWc0ZDV5VWlXbjkrS204Wk9veUhOb1NlSnNY?=
 =?utf-8?Q?6NIYWDHe+qGEupF7yhFWKhuKe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A7B67874BD3544890046C1471D95799@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4667c5af-26ce-4d99-e085-08dabc01fb5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 12:09:52.4231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EKiZ+rCH+PEcrVUfIvOcPiTdSazb67zafeEeYuoYx+GoSd7B/5NGl4cD8BrXB4ss
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4884
X-Proofpoint-ORIG-GUID: AWQmrB_tqW7N6y0tsmTD-1XewB8t3yXk
X-Proofpoint-GUID: AWQmrB_tqW7N6y0tsmTD-1XewB8t3yXk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_06,2022-11-01_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTMxIGF0IDEzOjEzIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMC8zMS8yMiAxMDo0NCBBTSwgRHlsYW4gWXVkYWtlbiB3cm90ZToNCj4gPiBPbiBNb24sIDIw
MjItMTAtMzEgYXQgMTA6MDIgLTA2MDAsIEplbnMgQXhib2Ugd3JvdGU6DQo+ID4gPiBPbiAxMC8z
MS8yMiA3OjQxIEFNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEv
aW9fdXJpbmcvcnNyYy5jIGIvaW9fdXJpbmcvcnNyYy5jDQo+ID4gPiA+IGluZGV4IDhkMGQ0MDcx
M2E2My4uNDBiMzc4OTllOTQzIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9pb191cmluZy9yc3JjLmMN
Cj4gPiA+ID4gKysrIGIvaW9fdXJpbmcvcnNyYy5jDQo+ID4gPiA+IEBAIC0yNDgsMTIgKzI0OCwy
MCBAQCBzdGF0aWMgdW5zaWduZWQgaW50DQo+ID4gPiA+IGlvX3JzcmNfcmV0YXJnZXRfdGFibGUo
c3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsDQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
cmVmczsNCj4gPiA+ID4gwqB9DQo+ID4gPiA+IMKgDQo+ID4gPiA+IC1zdGF0aWMgdm9pZCBpb19y
c3JjX3JldGFyZ2V0X3NjaGVkdWxlKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4KQ0KPiA+ID4gPiAr
c3RhdGljIHZvaWQgaW9fcnNyY19yZXRhcmdldF9zY2hlZHVsZShzdHJ1Y3QgaW9fcmluZ19jdHgg
KmN0eCwNCj4gPiA+ID4gYm9vbCBkZWxheSkNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoF9fbXVz
dF9ob2xkKCZjdHgtPnVyaW5nX2xvY2spDQo+ID4gPiA+IMKgew0KPiA+ID4gPiAtwqDCoMKgwqDC
oMKgwqBwZXJjcHVfcmVmX2dldCgmY3R4LT5yZWZzKTsNCj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKg
bW9kX2RlbGF5ZWRfd29yayhzeXN0ZW1fd3EsICZjdHgtPnJzcmNfcmV0YXJnZXRfd29yaywNCj4g
PiA+ID4gNjAgKg0KPiA+ID4gPiBIWik7DQo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoGN0eC0+cnNy
Y19yZXRhcmdldF9zY2hlZHVsZWQgPSB0cnVlOw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqB1bnNp
Z25lZCBsb25nIGRlbDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBpZiAoZGVs
YXkpDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZWwgPSA2MCAqIEha
Ow0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBlbHNlDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBkZWwgPSAwOw0KPiA+ID4gPiArDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oGlmIChsaWtlbHkoIW1vZF9kZWxheWVkX3dvcmsoc3lzdGVtX3dxLCAmY3R4LQ0KPiA+ID4gPiA+
IHJzcmNfcmV0YXJnZXRfd29yaywgZGVsKSkpIHsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHBlcmNwdV9yZWZfZ2V0KCZjdHgtPnJlZnMpOw0KPiA+ID4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3R4LT5yc3JjX3JldGFyZ2V0X3NjaGVkdWxlZCA9IHRy
dWU7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoH0NCj4gPiA+ID4gwqB9DQo+ID4gPiANCj4gPiA+
IFdoYXQgaGFwcGVucyBmb3IgZGVsID09IDAgYW5kIHRoZSB3b3JrIHJ1bm5pbmcgYWxhOg0KPiA+
ID4gDQo+ID4gPiBDUFUgMMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoENQVSAxDQo+ID4gPiBtb2RfZGVsYXllZF93b3JrKC4uLCAwKTsNCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBkZWxheWVkX3dvcmsgcnVucw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBw
dXQgY3R4DQo+ID4gPiBwZXJjcHVfcmVmX2dldChjdHgpDQo+ID4gDQo+ID4gVGhlIHdvcmsgdGFr
ZXMgdGhlIGxvY2sgYmVmb3JlIHB1dChjdHgpLCBhbmQgQ1BVIDAgb25seSByZWxlYXNlcw0KPiA+
IHRoZQ0KPiA+IGxvY2sgYWZ0ZXIgY2FsbGluZyBnZXQoY3R4KSBzbyBpdCBzaG91bGQgYmUgb2su
DQo+IA0KPiBCdXQgaW9fcmluZ19jdHhfcmVmX2ZyZWUoKSB3b3VsZCd2ZSBydW4gYXQgdGhhdCBw
b2ludD8gTWF5YmUgSSdtDQo+IG1pc3Npbmcgc29tZXRoaW5nLi4uDQo+IA0KPiBJbiBhbnkgY2Fz
ZSwgd291bGQgYmUgc2FuZXIgdG8gYWx3YXlzIGdyYWIgdGhhdCByZWYgZmlyc3QuIE9yIGF0DQo+
IGxlYXN0IGhhdmUgYSBwcm9wZXIgY29tbWVudCBhcyB0byB3aHkgaXQncyBzYWZlLCBiZWNhdXNl
IGl0IGxvb2tzDQo+IGlmZnkuDQoNCkkgdGhpbmsgSSBtaXN1bmRlcnN0b29kIC0gYXNzdW1pbmcg
YSByZWYgd2FzIGFscmVhZHkgdGFrZW4gaGlnaGVyIHVwDQp0aGUgc3RhY2suIFRoYXQgaXMgbm90
IHRoZSBjYXNlLCBhbmQgaW4gZmFjdCBpbiB0aGUgX2V4aXRpbmcoKSBjYWxscyBpdA0KaXMgbm90
IHJlYWxseSB2YWxpZCB0byB0YWtlIHRoZSByZWZlcmVuY2UgYXMgaXQgbWF5IGhhdmUgYWxyZWFk
eSBoaXQNCnplcm8uIEluc3RlYWQgd2UgY2FuIHVzZSB0aGUgY2FuY2VsX2RlbGF5ZWRfd29yayBp
biBleGl0aW5nIChubyBuZWVkIHRvDQpyZXRhcmdldCByc3JjIG5vZGVzIGF0IHRoaXMgcG9pbnQp
IGFuZCBpdCBtYWtlcyB0aGluZ3MgYSBiaXQgY2xlYW5lci4NCkknbGwgdXBkYXRlIGluIHYyLg0K
DQo+IA0KPiA+ID4gQWxzbyBJIHRoaW5rIHRoYXQgbGlrZWx5KCkgbmVlZHMgdG8gZ2V0IGRyb3Bw
ZWQuDQo+ID4gPiANCj4gPiANCj4gPiBJdCdzIG5vdCBhIGJpZyB0aGluZywgYnV0IHRoZSBvbmx5
IHRpbWUgaXQgd2lsbCBiZSBlbnF1ZXVlZCBpcyBvbg0KPiA+IHJpbmcNCj4gPiBzaHV0ZG93biBp
ZiB0aGVyZSBpcyBhbiBvdXRzdGFuZGluZyBlbnF1ZXVlLiBPdGhlciB0aW1lcyBpdCB3aWxsDQo+
ID4gbm90DQo+ID4gZ2V0IGRvdWJsZSBlbnF1ZXVlZCBhcyBpdCBpcyBwcm90ZWN0ZWQgYnkgdGhl
IF9zY2hlZHVsZWQgYm9vbCAodGhpcw0KPiA+IGlzDQo+ID4gaW1wb3J0YW50IG9yIGVsc2UgaXQg
d2lsbCBjb250aW51YWxseSBwdXNoIGJhY2sgYnkgMSBwZXJpb2QgYW5kDQo+ID4gbWF5YmUNCj4g
PiBuZXZlciBydW4pDQo+IA0KPiBXZSd2ZSBhbHJlYWR5IGNhbGxlZCBpbnRvIHRoaXMgZnVuY3Rp
b24sIGRvbid0IHRoaW5rIGl0J3Mgd29ydGggYQ0KPiBsaWtlbHkuIFNhbWUgZm9yIG1vc3Qgb2Yg
dGhlIG90aGVycyBhZGRlZCBpbiB0aGlzIHNlcmllcywgaW1obyB0aGV5DQo+IG9ubHkgcmVhbGx5
IG1ha2Ugc2Vuc2UgZm9yIGEgdmVyeSBob3QgcGF0aCB3aGVyZSB0aGF0IGJyYW5jaCBpcw0KPiBp
bmxpbmUuDQoNCldpbGwgcmVtb3ZlIGl0IA0KDQoNCg==
