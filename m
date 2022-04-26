Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF37C50F382
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 10:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiDZIUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 04:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237904AbiDZIT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 04:19:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199BC37A3D
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:16:51 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q1NgaO016123
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:16:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=l5dpc9oF9UJfW9j0DRyWfPecPV9JHJe+jhmvhX9hTwQ=;
 b=AgGtlXt9cumJVhVPmUFfbfZizGjeLSweBDAYdJjnrF7WNL44XNHvLVkiDd+WO4fJcNEh
 dRJs92AapCa8etka60PsDbJzjM90FlUAH4bk8HQvD46IEiauoymAE2VavrVDOBx+IOj2
 APHVXxKZoF8/N7OoZ9KcCLtFt8v3L11JSz8= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1gdvn86-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:16:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQv1bOKEc98HS/1D3HozRH472/5Lm7jPN2MyRPp/t26mAgnm7a+ewanqmlcK+mwgLwfE0USBt8ySqufdbYJMIDbJPOVcFxqit+3vyOEpZeebG0/iPQZF8W8b+ZR6ENoIMbrT/Ttdyz3z3d6bJ3CarlLC1BBX6KgCWVec/4RfWun1H91bdA2G/ziT/yzoBGP9wLGB8egB2L7o4i6C1qQ5DuZzV7J8HElJBoT4it9xIykGmdAtz4j3w8CxwMiQ85Jzus04oRj7u3WH07pBhzKs46KaqDs/JetpmrdsLHvX+ge9iVbWiGr4Q5JCpIeIEXO9ZMWj9EI079FCI/6WZh24Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5dpc9oF9UJfW9j0DRyWfPecPV9JHJe+jhmvhX9hTwQ=;
 b=fBCr9tQ1zX732RKEq2i0+SxQctCMyLlJxiv8Sb997SLnvtJPYxZ+AkPH1knZFqU3vdvy5QzuXaND1bUxixR+HEBZmmttKp9RBTDa0k2TYaxVnQCJFFGFNkMS52MkUatB9p0qya2T7MN6kIxQVOFz1Y0jA2qD3yShzmiYRReDrGfFNtpI4SJ4SgvBub+GJGlExN1emb/i9f8EsbpTQ9inTH+oT48qPAs4/4Meezrbn5yJtiBBOH/IWleK+72HIVmwTNw1KdKR+GIXJaur0mOOYzzeZw+Nygu01dW/z63ZlRoVM5nEVkxLcdWikBTkINGZAXAJU9nQSalPwqNYM3astw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM6PR15MB3546.namprd15.prod.outlook.com (2603:10b6:5:1f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Tue, 26 Apr
 2022 08:16:48 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d%2]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 08:16:48 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] io_uring: text representation of opcode in trace
Thread-Topic: [PATCH v2 0/4] io_uring: text representation of opcode in trace
Thread-Index: AQHYWLZClBVu6MlKAk2nKKHVs+C+pq0BO2KAgACfI4A=
Date:   Tue, 26 Apr 2022 08:16:48 +0000
Message-ID: <09bb847c0557e89432d1d3a24cd46d82d0f4c04d.camel@fb.com>
References: <20220425150740.2826784-1-dylany@fb.com>
         <3fb298f3-c3a9-0240-5bc6-9ea84739e915@kernel.dk>
In-Reply-To: <3fb298f3-c3a9-0240-5bc6-9ea84739e915@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 312e8c19-5d34-4f4e-9590-08da275d1c1b
x-ms-traffictypediagnostic: DM6PR15MB3546:EE_
x-microsoft-antispam-prvs: <DM6PR15MB3546BDB6F798271370A288C9B6FB9@DM6PR15MB3546.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J3TocZhwHgQkWekV6/EPBFIpZQD1qKbhz+IClOVNpeaYoMB3QAxCLRq+UqqcdIUzoZ2uTqHlmtcBYi42ob3YC0ko4fSdL8XvC9kCR0Uwg58IcSc3y9XaCD94fUPoA4Pm1dQvaa1I+S5MrXwO0H6A4Ga8l1Jxkf4sw9WmkLiaKwb7IxvfUi4wI5IKsJVRCPnuG0ASZWY8iKoSw6blWeLBxtsBK9CoBUQfrFiB+OXMomfQDqOPnZ/eZggVwMdExO4rJsGfydz/fmjCmnBPTQqbmloOQbHct8yiVYNY55XpjaEsImBFq5Qp8gAPRvHNvQg/kFxtU+/L3GZNnBEH2+ZIx7reShnkaKwy1Ow9TO1dlj9S2eQ8goLxuQIa/KxCavLiIbVM7M32GdN3Gp/et4Y4cmKOkIEqlNvLLBgTqDrGUAW1idayGgOCG4VFjWxCeH74JQ5gFt6J7Sdgu6h8BZuAIanuZ5U05fN/4TYYi1hGBjZcU8nc2QRpI254yo6KHxQRCH9rJujEy6jQXpg1yRpF0wAWzu4wgXPYvy05uLYVUHIqjp8xLgn3C/8ltFrsvFsnhLM7BvnWURYRv+vbxYrE/kHlXV5Y8q/ln2Y6ml00SQm6UJbURNFBLOocJIazB9cTP9SbhjdhKhAU4C9dlS72bzz/thir48eKfkc4CuF5smqAzJL5UyHEsWcuOH9GQkdCVQN62wBNYNumhW0coxwfCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(4744005)(5660300002)(38100700002)(6486002)(122000001)(38070700005)(508600001)(4326008)(316002)(2906002)(110136005)(83380400001)(54906003)(6512007)(66556008)(66946007)(186003)(2616005)(6506007)(66476007)(8676002)(66446008)(71200400001)(64756008)(91956017)(76116006)(53546011)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3Q2SEFmZjJ5QlZVV1VydjVmVWxQK3dOK1pvZWlEUHdycXRuQldxOW9peFBI?=
 =?utf-8?B?N3ljTEM5cWk1RXRNVUZBekpwOUtuNG5MUllpRnZQcDNwQnkxTXQrVDEzangy?=
 =?utf-8?B?b095Z0I1RG5xaStyTlJ5Qklxbk41NUZ2N1dNYXVza2xJeElPWmdKUThzUlVF?=
 =?utf-8?B?amdWQnVmaHpoT2ZZR3pxOEo3bFFodDVGd2ZsSk5nN01lKzUzVXFjSGkrN0l5?=
 =?utf-8?B?enhSMkVWMmVobXMxUEcrRkk2RC9VUERnQWN5RmJNb3h2c21qNGZ0NGs1ay80?=
 =?utf-8?B?TGd1MjFOME9SbHdaQ1VpM0lrWGhHYldwUGlHTEx1RitWL0IxV0FKb3k1Z2xm?=
 =?utf-8?B?bUV6dzFodUJ1cHZ6UDRlNDBWQ0k1Zk16MjZlbjhRUjVUaWlkK3AvTUpaSEYx?=
 =?utf-8?B?TW1vQXZudFpMYWZxQ1p1RThmeklvMlFWcFlQQmY4OUdCZWV3YzFTQW9qSmdu?=
 =?utf-8?B?ak8vMzArdTlCQXcvWFB4QVhpTk5EeDJuS3FQd3FnS1RWWHNEcEQ3Tzg3ZDFy?=
 =?utf-8?B?TmpQRThOd1Q5YXIyV2FFaGZZVUhQazNSUzgrcEJqRmo0amhreXR4Q2VwVHM0?=
 =?utf-8?B?OUw4WGFMc3k2cTZrSXhPaE5XZHNOQTlUdytXeDZLcnN5a2pQWmFHcVFPWEJQ?=
 =?utf-8?B?dSt0Tkxzdjlad2pMbHFjKy9nbTVhb3ViNnVsQTNhQ09TeWVZcEtTVGVXT2FS?=
 =?utf-8?B?Mkd2MlJhTlZXZHBrL1dsazlLYXBOcUFVSnVXRlYyRTU5My9Da0M1SGx2NlVo?=
 =?utf-8?B?QkVJMjdvWS9qdXBlTXF2V0FET1dOU0crMlkyTk1jZ1N2RW1nWURlNzRRSHdo?=
 =?utf-8?B?VFVYcUI4OGNpNldMVlZaWGZCanRvelpVZjJkTHBHM1RhNGNWNE1ETDE5eVNM?=
 =?utf-8?B?RU1PQ0d6M0JzV04yS3owN2NkUWR5cG5SL0N1TXF6U2EvNUFpV1FXckZJS3NQ?=
 =?utf-8?B?eXBWd2pXd3BPZWxOdXBhOGR5ekJiNGNYSEY4azJGTmNnbXZDNjBwcUF6b0Rq?=
 =?utf-8?B?RUk5WVprRldHSk41RzVmVDZneXQ0TWlUeWFlR1pDc05xeDRIOThvUzV3RHNS?=
 =?utf-8?B?U2VNVElLRzI5ckdFZHFYUjJ6NEJrcnFzdC8vWERhY0xjMCswTmRyS3FZZW8z?=
 =?utf-8?B?dWtBeFZ2bGZjZ3RCN3R5MktBeFFTS00yblh0K2dsU2oya3VoZDR3Q2poWVBh?=
 =?utf-8?B?VjUzWkZHMmNwb2kwN29WdzJtdEJlSk5wS2E2b0pwT1M1OVF6U3FVdElocVpW?=
 =?utf-8?B?Y2cxNFBuS0dxaytXbVZLSWU0Q0tLZjNMNXhSdzNIb1hMV3pHZVVNTkh4WTFz?=
 =?utf-8?B?dkRQL2FkODRCY2o4OEJ1amI5eVk5ajloZU1GRUVzNlNmeUowc3ZQRUE2WXA2?=
 =?utf-8?B?ZzdCa2M5TDNKTEhjd3FneUdGbndac0RDWEFuUHAzSzJMSjJHREsvbVlwUGQw?=
 =?utf-8?B?eVMyT09UQ0Q3cGdsWG40OE1jZmViRHZTT3ZEY0hBUXljWEE2cHh2NUYwQkhX?=
 =?utf-8?B?WTRnb3Zmd3Nwa25ZTFZwNVp3Z2JWWjBEcXl1SnFuMnYweEdvcTNUa01jc2JJ?=
 =?utf-8?B?OVVTclJKOS9lbExRZXlLdisrRWw5VzUrNlZWR1NKQmRQQzFaeDRkRFc5R200?=
 =?utf-8?B?dXpUUzQvQXNXSnpIOGdZQ1hBa29EMjhTcHNNMXRsNE51a2N2Y1p3cDMwU0hI?=
 =?utf-8?B?c1ZPdnNBSzFqcXNNL0dsNytLOXhlQ1ZINzBRaDFweW1JQ3dPWHNZK3ZmM1Fy?=
 =?utf-8?B?TDBDN1hNYjlIaXlLelVPQWxvMWwyMnE3K1ZCTGxoUUZSRDhkamZQRmNZMFY4?=
 =?utf-8?B?ditBY2kvczZZZXJHcTVMV2Z0U2tYM2xmcWgrVzFHekI0djB2TVEwZmVIam9H?=
 =?utf-8?B?SDF0cjVsWnBIQk93NHBiRStDM2h3elNYVmpRaG1zdXhPVVU0SHVjTGJKUmx1?=
 =?utf-8?B?eVQxOU5wYzZ2NHorQ2FrbDV4OGpMNDVqOGI4ZmxpdFZCcTljOWZWbDF4Szc5?=
 =?utf-8?B?TGlZLzdXSXpSNEhvMldFYUpEcXNNSUt4cVpseWpsZkgwUURrbHVJSXJmQmoy?=
 =?utf-8?B?cmdCTFVaTWwrQUs0cDNlR2tyTUFJT0Y2YVNWTVZ6UU5VMXlmYzY2Mk5SU3Va?=
 =?utf-8?B?QzEzbmV3UEVPNlowMTZTei9nbmFOWXBNSEZVaGZScVJ5YkNLNG1zWXVSK2k1?=
 =?utf-8?B?RzJNYnROQkdXNWhjM3hKdkRVY1Z2NjBSelQ5WXM1YS9ZTXN6VEVsT1pMRjlu?=
 =?utf-8?B?eFRUMlN4L3JwWU1QTGluNnpDeUhMSWszYXZmRWVOdVdQS3liQlJJZlpJUGtx?=
 =?utf-8?B?RUovaGwvOE5salFPSFFRcFk4T3BaazVtUUVVZE9jWUdwK2dtV3AxMTBXd0xU?=
 =?utf-8?Q?aqghv7AkU5UyJus+Mkl9JU+d9//GI8ST4Bh/Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C3082E69D8C964DAA6E107C6F35FF75@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312e8c19-5d34-4f4e-9590-08da275d1c1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 08:16:48.2889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gNVWRyJp18MHtpM3sH3nRQAjtR26q4k9XBM2fo9JOa+mxUA4+ggJRrQ9Gyptz/kk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3546
X-Proofpoint-ORIG-GUID: vY7eqnCcBcXttMM3n-rcq2MiCsmRbwCW
X-Proofpoint-GUID: vY7eqnCcBcXttMM3n-rcq2MiCsmRbwCW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA0LTI1IGF0IDE2OjQ3IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biA0LzI1LzIyIDk6MDcgQU0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gDQo+ID4gVGhpcyBz
ZXJpZXMgYWRkcyB0aGUgdGV4dCByZXByZXNlbnRhdGlvbiBvZiBvcGNvZGVzIGludG8gdGhlIHRy
YWNlLg0KPiA+IFRoaXMNCj4gPiBtYWtlcyBpdCBtdWNoIHF1aWNrZXIgdG8gdW5kZXJzdGFuZCB0
cmFjZXMgd2l0aG91dCBoYXZpbmcgdG8NCj4gPiB0cmFuc2xhdGUNCj4gPiBvcGNvZGVzIGluIHlv
dXIgaGVhZC4NCj4gPiANCj4gPiBQYXRjaCAxIGFkZHMgYSB0eXBlIHRvIGlvX3VyaW5nIG9wY29k
ZXMNCj4gPiBQYXRjaCAyIGlzIHRoZSB0cmFuc2xhdGlvbiBmdW5jdGlvbi4NCj4gPiBQYXRjaCAz
IGlzIGEgc21hbGwgY2xlYW51cA0KPiA+IFBhdGNoIDQgdXNlcyB0aGUgdHJhbnNsYXRvciBpbiB0
aGUgdHJhY2UgbG9naWMNCj4gDQo+IFNvcnJ5IGZvcmdvdCwgb25lIGxhc3QgcmVxdWVzdCAtIGNh
biB5b3UgbWFrZSB0aGlzIGFnYWluc3QgdGhlDQo+IGZvci01LjE5L2lvX3VyaW5nLXNvY2tldCBi
cmFuY2g/IFRoYXQnbGwgaW5jbHVkZSB0aGUgb3Bjb2RlcyBhZGRlZA0KPiBmb3INCj4gNS4xOSwg
b3RoZXJ3aXNlIHdlJ2xsIG1vc3QgbGlrZWx5IGVuZCB1cCBpbiBhIHNpdHVhdGlvbiB3aGVyZSBp
dCdsbA0KPiBtZXJnZSBjbGVhbmx5IGJ1dCB0cmlnZ2VyIGEgd2FybmluZyBhdCBidWlsZCB0aW1l
LiBBbHNvIGF2b2lkcyBoYXZpbmcNCj4gdG8NCj4gZml4IHRob3NlIHVwIGFmdGVyIHRoZSBmYWN0
IGluIGFueSBjYXNlLg0KPiANCg0KU3VyZSAtIHRoYXQncyBlYXN5IGVub3VnaA0K
