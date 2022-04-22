Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EDD50B482
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446324AbiDVKB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 06:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446319AbiDVKBZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 06:01:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A4953E32;
        Fri, 22 Apr 2022 02:58:32 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23LNWeQ0017797;
        Fri, 22 Apr 2022 02:58:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JuWKBF5k6qXSWhJS4Kwqt/qLz2M/kqFX5ilC77EQRIo=;
 b=EqZ+OLB/lzINf5rEc4JguzvTBdRhH4cV5wP0vNbw4S+un0rrYyFpJVqgQqPOzfTYA8xn
 vWOiGCkLPxAP9ZdGUxeMx1qpP9yJSsbqkZsA4h3GaJS5ft7EVwx20qQ+0ya+kBnleZx8
 IJZQlcuW5ABtT/0yrL5ODc7VoDdDqGItQjw= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fkc2vcmx7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 02:58:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgTaLuOyuHnbZhEoRyM2q93CMENW5emetnCl6gaemntthFDZ+zMmJWb1z0Eun4RKXDX0MSluQYABigy1MxfSbOkheD0xgNRLTKPOGcDkvojkT1oCHOABTn6mXuo6KqkLfhMp6o4fjZIfTv7x3ERjWT9dFQoxKz93yApm86/ay+yEIKMfNOsq/SG54O+Ym+ShzlwMkiSvtaZhWEkKx+m1+TdSORyvJidqJrY/P2K6d/rDdaNQa7p99qv5Vd4TiOtWUkaNL6W4kEVTcWQ+E6DyPBGgOtqG/FU3OSjxCAnx2I1kxPlxDhfG6fMKtij46V9GRAlPSnmeY+9rjofHdQobzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuWKBF5k6qXSWhJS4Kwqt/qLz2M/kqFX5ilC77EQRIo=;
 b=RaR0CnB1sewj7sXLTkwruNTCyKz3G4Iv0CqX17txz6qgrqrorz7UUrmBqHmOJfIVA526337TWS03s6gTddSYsHFyP11DWQnqogtgooEvMrpBrdZ2T4FYU6nxTrsFRtNgpqyH0KXWHj6gp2ytt2Swj6tc9vJZclG/eDxFrRGgW/vWujei8Atsiqb5BxCIX2UbBi1P3iG7QsJnB8HfpUO9YFIA9p7HQLWjeOBm1/6X23xKQu/z1/vsZhv+EsPbru+ZRQlamHzibJ2GbpPVt4DwsbJT5vSKAKa5IAp7a5gBIEi9lfvhWFILyJcqiaCUZ3EXv11+NH3PMYtDKqDC9Wkg1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by CY4PR15MB1253.namprd15.prod.outlook.com (2603:10b6:903:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 09:58:29 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9c42:4b28:839d:9788]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9c42:4b28:839d:9788%6]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 09:58:29 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH 6/6] io_uring: allow NOP opcode in IOPOLL mode
Thread-Topic: [PATCH 6/6] io_uring: allow NOP opcode in IOPOLL mode
Thread-Index: AQHYVWCVousbcGntV020vJwJE0RJiaz7BYoAgACuvAA=
Date:   Fri, 22 Apr 2022 09:58:29 +0000
Message-ID: <39c5d7b8da489a1f802960fa575d904ddc2ab9eb.camel@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
         <20220421091345.2115755-7-dylany@fb.com>
         <b32cf3e2-a68c-b1b0-f3da-72e5f0b9d86c@kernel.dk>
In-Reply-To: <b32cf3e2-a68c-b1b0-f3da-72e5f0b9d86c@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e399c5b-a0bc-411d-66db-08da2446a6d3
x-ms-traffictypediagnostic: CY4PR15MB1253:EE_
x-microsoft-antispam-prvs: <CY4PR15MB125346C12D41FC1782EC24C6B6F79@CY4PR15MB1253.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l9aTonAMntpoJ8lBNQqENzKMVyWEtjsmhuZuMfCjRZjVswQshSxLaMoLBkR0A1Wwp3FO+49o3z51zwW/+CWMu5ouDrXfGw6Le23y6iIDFPvUP6ayyWyydxKUwFv7G7RwPQTHM/XucalQugRS1quGyMpVK0SFXhUNGlOQabbCVAanmxA0Z22VmKT4J0Gk/s1kj7dpw4/wxHTij135yriW4hllWSrhkyjYF1eDkb/kTwj67/vxtiuBU06LLTCmpZDGf6jc4IZbWfF8RHxGF5HaejoEIlpgp+n2OWDhEZU6vujfoqQAo/vCExlN7ffzpxnVfsi4JY+Q1rSmt1+HZULa31cGldhyosuvq00e1nFsujQ76VZ9A4Wc56nkmgQ3YVXOZDsIrmz/96oU+HMJfH5iu27lJZTZAQkzFWoknROmq0SIxRogW2jpz73yMj4S+y7xYkaWk98arEZTR+u6vlqB4bz4oPLTHV/UTiCTwxcOZUD7/Bgmo2d2tKk2uG85VM9ZrusGp+Fi7gV0kISwp3lyvmwU3lEEKsV82N2oNZunG1LMp6aEVhpTdh4hbUBqCjaN3eJax3JGGnkT9ZG3STveq+uWbRtdINLRXC1VvD42T35B7e4h4+p+cY6wz08bOSfEsWL+dtXT7q0N5rg5TyZJ88r0BJow/XElTfkZYBFG0db0eT/f71T9vtD9FNPLJQcCMUBzV3YK5fL8xr5SSGHHIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6506007)(6512007)(86362001)(316002)(2906002)(5660300002)(53546011)(8936002)(6916009)(54906003)(38100700002)(71200400001)(186003)(508600001)(38070700005)(6486002)(122000001)(36756003)(91956017)(8676002)(4326008)(66446008)(66476007)(66556008)(66946007)(76116006)(64756008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2NUMlIrQjBFaEZkRmE5WDgwWm1TWlNBOUdXZk5wSkIwajAvanpLV3VzdXJM?=
 =?utf-8?B?V3R2QVBmZGlPeWsySjU5Tk1EazIxaUVYWnhtV2tFNzRWUjEzMU92SFFLM0I3?=
 =?utf-8?B?UWN4QTFMMFVrS3dVRXVZMzRSVHN1dlA0VHhuaVc0RXhiT0c3azh6dTJDd1hX?=
 =?utf-8?B?cmIveVhNNHhiaFBCRGw0Um1QQUdHUitKWUpRT01xdXNNUTdvSzltcHMxYklB?=
 =?utf-8?B?dTJnSlZCOGtDQnpOa2ZFdlRoWXc1LzhJZk5tSHUwMzMxRFIvci9Uak05cFph?=
 =?utf-8?B?YzQ4UVA3Mnp6djA0L3lDWFVubHE1MEptS3AxNHBCRmpBSElsVis3M3BRUm4w?=
 =?utf-8?B?SmRjUVpaSkFqTWlYLzRhajVqSFhXcWRZNThDbEg2RGpMWjJMcHlXMDl1ZHZQ?=
 =?utf-8?B?eVdDNk9INjh2a1ltWTBVaXdBa25VckV4MnhGUlRYd0NvTGQ5ZE9oU0JhWkl1?=
 =?utf-8?B?TEhSSXFFNE5JM1cyUzFkU1lyclBFUU1OYnl6TGtybTdaNGc5Nkd5ekQvOFRU?=
 =?utf-8?B?N0pBTXFUMFFHeUxTZXE0Z2E1UzFWUDYweFZTZWs0WlZBWDZ0a1FEUGtLWkRE?=
 =?utf-8?B?OGM3WFR3TGZxZEFGaFJzVUlYbFFDRllXWmdoc01MaHI4czlqeWdERnB6a0hs?=
 =?utf-8?B?WldHeGR1LzByM2V1WHZwaWZhQnFRSTYrVGNXZUR0NkhFdDgvK0w2S21Nbzgr?=
 =?utf-8?B?dmxtSnlObGNrekJ4K3VmTVlNVzl0YlFRazliaWpLUnVVRkd0dENETzY4Q0xF?=
 =?utf-8?B?VjdpcTd3Ti9vZ3lJaHAyT0R3QThKVmdQTkZ6UkJQZm5iWWYwTDc3Wkg1bUls?=
 =?utf-8?B?U1JFbG5QWWNFWGpqZGFVZnZ6SXBlb1R0VW43V1VSWEl5TmtmVjhHS2tUWUIy?=
 =?utf-8?B?Q1B5eVhZd2IzbExJVjFwSEMxVk5RdHdMYzU5S051RUc2SmlUK2pTVjlVUGlF?=
 =?utf-8?B?bTBLSXdjZW5aUStFWVBFOWhxZ3A3RCtQUlVXQ3krUGU2RDE4QjJnTndKSWE4?=
 =?utf-8?B?RHh6ZmR4Z2J5UlJ2RHlpRSsvK3U2ZUFzNjgvczNQWjN1a3E3L2pNcnhVZDgz?=
 =?utf-8?B?NFhSVitjdjd5aHpHV0xOMmVpVEc4ZU5ZUVNoYUxIUVRKZ2VGZG1OREthQkNF?=
 =?utf-8?B?OTBSYjFjYUk2ZUlDdVJ4Y3dINTd1KzlQd1NvcndjWjdCRGNDbHdnVmhMZ01U?=
 =?utf-8?B?Qlc1cHAxb0hUbENFekdoODNpQVBRZmVKbElUakIzTWczc3ZDM0N4M2w0cWdq?=
 =?utf-8?B?NTVGNHRQVGZRQUlTbXdKUnZ3MThVbEhkSHRlSU1nMGh1a1dmZUxEZU9ybVh1?=
 =?utf-8?B?YXNmd1VUVnUzUFR5bkZPTUpyaFNDT256L0xobS85dG1VeCtVVEFJQUowSFN0?=
 =?utf-8?B?emxFcmJxSWRZS1RRbHh0V0x5RlN5Q3pFaTZSay85YVVibG1WS1g1ckh1Mmgv?=
 =?utf-8?B?WHV2NXAyUUJvVkZEL2drQjJIYkZZZU9sQkVPV05wOXYrVi9aYUNVeEc2WVRZ?=
 =?utf-8?B?SS9EYTJiSXc4alBLNUlyOGJsejlEMkF3VUNwRmxKcHZUK3YrN2hBSkhJcGo3?=
 =?utf-8?B?RnExZXpGenl3Z21nYjFLc05xeWFpUVlEWE0za3FGNFNQNjZVVndDQThsK3ds?=
 =?utf-8?B?dGRXdmxmYklPdUkrczhzMU1GYlpOVWJhMWRFc1VRM3FIWk1WWlVOdTFXcGEw?=
 =?utf-8?B?NGpqa3puVkh4dzdDcTJoeStpZ2NaOHVQRHQ5UUI0cTlmckxBaU1zY2NYWVp6?=
 =?utf-8?B?em5ERXk2cklpVlJ6NnI3ME5WeXJ1cmRkMS9vREM4RjZjLzAyRU15azlVa2p0?=
 =?utf-8?B?R3Q0RVNEMzlqTUgwekYyQ01MK096cDRWSXIwUmlLbXNkRlIyYXpDRUpwWFJJ?=
 =?utf-8?B?TEQ0Zzl6SjBQSTNLNnRxT01QcnJmbSt3cG12bHNTRnNVczZCSjJNc0o3SHR4?=
 =?utf-8?B?ZEhZUDRyMDg5ZWNQRjd2VnBFSmFKb1d3Z2tCNElCaUFyWlJUbU9leDVOZG5z?=
 =?utf-8?B?WnBCSW5oNjR5QjVaQlRPUHNyaVQ0eDdEdVo0VW94N0krTzE4dWdpK0lqYVVZ?=
 =?utf-8?B?TVFQV2JHeEkraUptUGVRSmF4M2VRSC91aFN1YkxkNmVoa2piUlArbG5sV1Uy?=
 =?utf-8?B?MTNjUStYMCtEZUdjUHh1eWg3dmhQMmRjNWNNb004eFd3c3ZOeEVpeDFMSTRk?=
 =?utf-8?B?QzlsSVQ2dnF0ZVY1ZzNSU3g3WWx4bFdQMGVySnN6cDJaSHcyNWpRSjgrK0N3?=
 =?utf-8?B?VENaTmoybzJnT05PUE9PWmRyczRDYnB4ZjNuNUJLUGFCK01MT0RLNFhwbkR3?=
 =?utf-8?B?bDBwMGhEK0oxY1lpYStXbm1HdEVXbWU2cXZZR1hGUWwvaStzai9UdzR1RGgy?=
 =?utf-8?Q?4f0fou2+JKqpdM3Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A1DBFFD4232CC4CB3160AE50BCD9D21@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e399c5b-a0bc-411d-66db-08da2446a6d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 09:58:29.0871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9IGt/YHa4v6S7UjxhYh8POAS40kV4f/nKpdCmPIaBJ8GcD8Bl9s7QIES1fCiH6D7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1253
X-Proofpoint-GUID: 9wexYiIJBAxfOA2OP97Mj1Hso30yM0cg
X-Proofpoint-ORIG-GUID: 9wexYiIJBAxfOA2OP97Mj1Hso30yM0cg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-21_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA0LTIxIGF0IDE3OjMzIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biBUaHUsIEFwciAyMSwgMjAyMiBhdCAzOjE3IEFNIER5bGFuIFl1ZGFrZW4gPGR5bGFueUBmYi5j
b20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoaXMgaXMgdXNlZnVsIGZvciB0ZXN0cyBzbyB0aGF0IElP
UE9MTCBjYW4gYmUgdGVzdGVkIHdpdGhvdXQNCj4gPiByZXF1aXJpbmcNCj4gPiBmaWxlcy4gTk9Q
IGlzIGFjY2VwdGFibGUgaW4gSU9QT0xMIGFzIGl0IGFsd2F5cyBjb21wbGV0ZXMNCj4gPiBpbW1l
ZGlhdGVseS4NCj4gDQo+IFRoaXMgb25lIGFjdHVhbGx5IGJyZWFrcyB0d28gbGlidXJpbmcgdGVz
dCBjYXNlcyAobGluayBhbmQgZGVmZXIpDQo+IHRoYXQNCj4gYXNzdW1lIE5PUCBvbiBJT1BPTEwg
d2lsbCByZXR1cm4gLUVJTlZBTC4gTm90IGEgaHVnZSBkZWFsLCBidXQgd2UgZG8NCj4gbmVlZCB0
byBmaWd1cmUgb3V0IGhvdyB0byBtYWtlIHRoZW0gcmVsaWFibHkgLUVJTlZBTCBpbiBhIGRpZmZl
cmVudA0KPiB3YXkgdGhlbi4NCj4gDQo+IE1heWJlIGFkZCBhIG5vcF9mbGFncyB0byB0aGUgdXN1
YWwgZmxhZ3Mgc3BvdCBpbiB0aGUgc3FlLCBhbmQgZGVmaW5lDQo+IGEgZmxhZyB0aGF0IHNheXMg
Tk9QX0lPUE9MTCBvciBzb21ldGhpbmcuIFJlcXVpcmUgdGhpcyBmbGFnIHNldCBmb3INCj4gYWxs
b3dpbmcgTk9QIG9uIGlvcG9sbC4gVGhhdCdkIGFsbG93IHRlc3RpbmcsIGJ1dCBzdGlsbCByZXRh
aW4gdGhlDQo+IC1FSU5WQUwgYmVoYXZpb3IgaWYgbm90IHNldC4NCj4gDQo+IEFsdGVybmF0aXZl
bHksIG1vZGlmeSB0ZXN0IGNhc2VzLi4uDQo+IA0KPiBJJ2xsIGRyb3AgdGhpcyBvbmUgZm9yIG5v
dywganVzdCBiZWNhdXNlIGl0IGZhaWxzIHRoZSByZWdyZXNzaW9uDQo+IHRlc3RzLg0KPiANCg0K
VGhhdCdzIGZpbmUgLSBzb3JyeSBJIGRpZG4ndCBub3RpY2UgdGhhdC4gSSB0aGluayBmaXhpbmcg
dGhlIHRlc3RzIGlzDQp0aGUgYmV0dGVyIGFwcHJvYWNoIGhlcmUuIEl0IHNob3VsZCBiZSBlYXN5
IHRvIGdldCBhbiAtRUlOVkFMIGZyb20gaXQuDQo=
