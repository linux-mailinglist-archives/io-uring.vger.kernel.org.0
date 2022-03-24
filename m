Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DCF4E65AE
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 15:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbiCXOyc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 10:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242281AbiCXOyc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 10:54:32 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BB7A775F
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:52:56 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22OCHWRW011887
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:52:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IEPmvRgktdXmAqf9n/awcoZ7sCO+vPI3sjDKG7tQ0lM=;
 b=B82DmzsCh3yCo/9wLSYzyVTquWc/Hdwxpyu0DPRAWg6Q6rquBr8Vr6wjkPgmvHog/lV/
 ENFz31gTeUxiGx2VVMOYDf3pVAt95b+fv4WMQePzvCxB4mQtttgssQFExOUL5YWeNchg
 R5sC19Yba0HxoHpcg8zhiQDsHUrZbXyWFSI= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f0rh68wv6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:52:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkueVQ5zWP1/8JpHwTfS+0Yc9qf3Ep4Gx45boiCE25CXoRZw73Ik6oY2GKfXgv83WCZoFMRWUw6l1RmG+p7sCTMv9iFw9dFr1wM+oxim47H6SvDbQ2zXnNsU0Kd2IE+43JhRF9IsXCSaV3Nbz1AvWAFvd3lT1XKpytWtZX7ErtbVREmgW/hR62cFTsJO3S6fRa5acywiE2iy6e/UgqMqYdFK1gX+yBu2v+7AST/JLu6SOERePLeh9j2tM/aNyvwdxbPWl3kB3YeHs+4lVNrthSv9ZqbLcY3kksgJw5RhhqXst1nOyAZBdTDqHdGPdn6dRpsQYCL5NRkPD4dFJrN0nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEPmvRgktdXmAqf9n/awcoZ7sCO+vPI3sjDKG7tQ0lM=;
 b=LJfePmft7LiX9taEQ3CrLttTQ1YZHVfS02VVOuN2U9LSXHMn1x7t/V4EHlRv6OMUCxKxbK7RzihT+zUGHie5WJ+08WGJ2jjcp3Mv4TU2DQG//02rT+tcPV+kiuVX7Ble64qEQmImkY2s6lhudtuIe+t6YRzNycJ8U3xvjKmHg2RNLmkctUhNLSebNNZjYZQa2XBQMGDcWB9g4xuB1vqZOTNCuAwDxHyirrm0S2f76qCHj+O0WHMiMpQbLTDslxM0OIoEE59rxAwHW3HeooFObI6rHdBCa2Y0fl3yBNXbNIcjhQyfXvCkuF5jUPpiaWpclA48+v6/LiPF5VSbcx0d6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA1PR15MB4452.namprd15.prod.outlook.com (2603:10b6:806:197::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Thu, 24 Mar
 2022 14:52:51 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::54d5:f4ed:c960:ba4b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::54d5:f4ed:c960:ba4b%6]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 14:52:51 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH] io_uring: allow async accept on O_NONBLOCK sockets
Thread-Topic: [PATCH] io_uring: allow async accept on O_NONBLOCK sockets
Thread-Index: AQHYP4xV/+GUkhpc30SdpysnwqhQxKzOm4oAgAABMoCAAAHWgA==
Date:   Thu, 24 Mar 2022 14:52:51 +0000
Message-ID: <91c5baf40ef60f0eabbe13986f2462d871caeacf.camel@fb.com>
References: <20220324143435.2875844-1-dylany@fb.com>
         <a545c1ae-02a7-e7f1-5199-5cd67a52bb1e@kernel.dk>
         <4ec0e6e4-6c44-56a3-ef9e-5536f61eea86@kernel.dk>
In-Reply-To: <4ec0e6e4-6c44-56a3-ef9e-5536f61eea86@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c750ee3b-dc77-4ea5-b138-08da0da5f880
x-ms-traffictypediagnostic: SA1PR15MB4452:EE_
x-microsoft-antispam-prvs: <SA1PR15MB44526F3D39375A527AACEDC7B6199@SA1PR15MB4452.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ITCL4/XwDrGstgqa44mdPwyZSdKynvTp14yxiPyZgcT3PkP+plF/ll1jHmlE1MKLwCj1pF5YMVgS7ru9KXQKBGmQ9Khxd5JFg6rYCO1SpXrCvVwA+SvodEjP9lj9JSSzFrJEhnP1Q5+RaKyG4YaeWszaD9edJPpqF/CT7jsnDgjagd2XXjgBXALQy0jgVxtGUliTifK1T2n1JkLv0FkZHSTs2AH2jSqYvBqhtD1Br+Zi3IEh9V05E9ucIbJ4I2sI7xbWJfr05NMprSVK8nsm71K4gpm7UqbAPgq9aLvTg5m1eTFg3HinFf4ND/eFCaR9ub+XDabfHOzr+kVFCaPfEbetZWnUtykLZVqVErUexfygqqcao2zrgWqhULcgE/poNAWVrNatfSZk5xell+Tvi2NFA4+yasiNE6jh+7FcMGoqznXFtrsE/q4gCNLvqh+IOV7zAe7DO2OgYW1Kx5x0TjMVDsyvQahzo4v8oghWggibkiOhp1Q0+oi68ti/BTbfYV/EXSRnlGv8PxHoJ/tBCd+VBIa33gEV/coP8HXM9fhiwq6vXaSyIXTWZQNRR9chrNESfsDjsjkBCtWHtL1ovTnM20YFY11i+2vSa9ktbzqHRze47mQprDHoNTXhJTmBonz8eFYpDowEaddtb+FwlM6+nrng03nn6uXOiaR86zDBgIsb8JR9Sb1inWNQ5/AQc8ZgjUT8kAzdV3eQrzQRdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(5660300002)(6486002)(71200400001)(508600001)(66556008)(4326008)(8676002)(66446008)(64756008)(66946007)(66476007)(38070700005)(91956017)(76116006)(38100700002)(6512007)(122000001)(8936002)(83380400001)(6506007)(53546011)(110136005)(36756003)(2906002)(186003)(26005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkZVeUh5QjZ1L1dUS0pmWXQzaHNtM3hOeUE0YUNKekdVL0RYemIxb0xzNU1v?=
 =?utf-8?B?WU1ZSmsyVythaGNFZzdiNkN6UFJscUtLMXJsaW80YldoU1MyeWpaVjl0WVVN?=
 =?utf-8?B?RnB5OUNrSXYrRU8ybjlzRmVFbFNJQzhObWZPMUtoVVlXRnlkMTUwS2pLRHhD?=
 =?utf-8?B?RzF4NVhuMkxuMnY0ODFrbXJUQmJrby9JVlpJTDNRY0NtUnFERTlzQjJKOGND?=
 =?utf-8?B?R3VuVkFGRWFmaHBnMTMyNC9LaEZPZnJWRkJ2YXdUaFZTdklHRHR2QS9ZNS93?=
 =?utf-8?B?VXpBMHhXa1J5YzN0QXpxbHJIMmZUb3k5MDR4cmo1MUp0dFdacDh3bFM2cWNQ?=
 =?utf-8?B?NjBqdm5LWklMeWJ3V2w1bGdCLzNNYlpXQU1KZEtPUnJBS2JCaGEvaWdESHhF?=
 =?utf-8?B?RkNIcnEwem9MNDZHKzBTYUptd1JsMzlQYjkrNVZpeGd5UkxISHVxUlJ2b3Rk?=
 =?utf-8?B?Z0lWek9ONkxVTlNlM3RYUU94M3ZjVHNLMm0vTU81aHg0R2ZTd3pnRExVUEph?=
 =?utf-8?B?d2RySGRWSGRuYTNIbEQvL1BiR1plN24xUjJDbUFFTmE4Z09LL01SRTc5VHl4?=
 =?utf-8?B?QUR3emV5MEFRSTU4RFBoeHUrOEdPRWZpcHJpK01nS1RENE9YNVJJQ3dlY2tL?=
 =?utf-8?B?NEo5WTRJZkdKeFYxMldWeUk5Vk41ekplLzVyd21aSm9OTTB6L3R3NGNUK1J6?=
 =?utf-8?B?U0pIRmhPbFBNSm9CQkY4bW1yamNJelVqTXZra1YvakNiVFFyZTIyRXppN0VB?=
 =?utf-8?B?K3ZPTWxHOWdUTEJ5QTVQWkJCYXc0TVhSalZ4YUdYZ1BORUY0S3NlUjFrU3dn?=
 =?utf-8?B?WHBsNnlvWi80b0g3WVU3NGg0R3FrcHBITDg4NWtLS1d5bFJMVFJYQjRmR3dM?=
 =?utf-8?B?Z1hTL3pSWlBpMkszcnd3b01jM0xkclRGMG9YYngyUFM2M3hXcUtFZkFCQ0FN?=
 =?utf-8?B?azQ3UnFQU3lWMGxEQjF2cllKVGhEcXloT2E1a0Fab2J5Qm9Qdm5kWVFDQ1Uw?=
 =?utf-8?B?TFVOQjZJZk5samVPR2VkblFsMTQ3QW8yZ1drU3BFc0ljN0x4c0w0QmtjVCtS?=
 =?utf-8?B?UGVmL2VxdUJLYWlQaDZiNlFVZlhUMW9RZlRWM3hPV1FmSGFrUk5adUZaK2xG?=
 =?utf-8?B?dDM4VFIxL21DS1YxU3dJa2FMc0wrVDh0WHR1WkZYa0dHQ0Z3QldMZjFHcU44?=
 =?utf-8?B?aVc3dm0vM0FIempoanNTNkllVDZNNG9rYmdnS1Z1ekIrNlRzYXQ4Vnc0MjFM?=
 =?utf-8?B?SW13blc5bU9obXNrVS9yQlZSaVFTQTJTeCtZUDVTZ1pqL29wVHBzajNTVUU0?=
 =?utf-8?B?TGM4cnQ0WC9JZTZDcDZFa3I3Z3c0aHp6ZnNmQkYxNXllRFJ4Ym0va2ZUdFNT?=
 =?utf-8?B?cGt4dTAzY2d1dEpySWhYVFJxUHdNWGltT0VaYjVhdy9ZNHJzUlFjUGNyaGV2?=
 =?utf-8?B?dEJxcXJKdDV2dGZZaWZCelYxcTlobzkwelhtdEJFOEJVTmtPWVVkdmdFSjJt?=
 =?utf-8?B?UitnYVRHckNJRXB2WmxiaXFMWHV0NngyNDVtSWtCQ1hxUHR1SEpkTkQ0SENz?=
 =?utf-8?B?eWNmVXdFc2VLeUNOMkczbUJKclpkMkt1eURyay9MWEU2eEtmaXNBdzFQN3Ux?=
 =?utf-8?B?WnZrdjFBMERUYUMvS1drdmxrMUNpUjNNcWdmbEJVQWRibVVaK1VXRVFjZ1I4?=
 =?utf-8?B?S09EcVBqSkkzR3lPTHA5S3M2T3ZKNFpETEI3WGJiYXlxNkJjdi82YkhYbHhB?=
 =?utf-8?B?cy9mb1RUUmtmdjhaSlFqdTR2bW1XbWZNNno0c1ZVTkpVN3c5amloR2l0U2FO?=
 =?utf-8?B?TXpNNjlBcU5RWFZqVXlVT1R1VS9xTkNZaHBTZjJmWE00SWlSN0NxU0hwVlNo?=
 =?utf-8?B?cHJJWWkrNHB2dTBKWEo0VnE4ZVRlNkVpcUpvUzhxeFRqMHBkNDdnaEMzelRT?=
 =?utf-8?B?NjFpSHhMT2c1ek9xa1gyZ1lhMTJOdkcvUGV3czRNNDFoNHdJQ3NCZitqU0dp?=
 =?utf-8?B?SDU1Ujh2OGpFM0w0cE45L3NucVhGU0Y2cDNxWUROOVhsNVozT0dEU21OTm10?=
 =?utf-8?B?eGJDdDlzbmwvZkRNZzExVjJmcEM4QzhxTzBUbS91T1VrTmFNNEp5SEI3Mlph?=
 =?utf-8?B?YUVoMjZoVkd1Tkg5VU1pK2Z5bHMrVndMOSs5WHBLa1RWMXVRL3ZlZm9WMy9a?=
 =?utf-8?B?aHZjcm9pNWt5RzlPQlROcUQrY2pOZjJ6cGFQZ1FmNm55NTRudHh3NzdSTFNI?=
 =?utf-8?B?V2RDTnc0YVdFQ2NSKytSaFBiQmZBdXM4S0JXd1dmSTl0aUhQMWo1cWNSY0M2?=
 =?utf-8?B?RHdTV09iNXFZRDY0TkFiWU9vY0VWWFMwa2hnYldVbHBMQnlUdDFIZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8000C6B43DD995498A56F68C3EB28244@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c750ee3b-dc77-4ea5-b138-08da0da5f880
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 14:52:51.5502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQs8gcXw01lve7Y9z9Q9DpYJhjxO2RIc7oIXhqybEh+SDSwtbsyaBgVT59TFjk2o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4452
X-Proofpoint-GUID: XBYLliIlkGcvaWG16672BWKh2lCRaWxN
X-Proofpoint-ORIG-GUID: XBYLliIlkGcvaWG16672BWKh2lCRaWxN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_04,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTAzLTI0IGF0IDA4OjQ2IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IE9u
IDMvMjQvMjIgODo0MiBBTSwgSmVucyBBeGJvZSB3cm90ZToKPiA+IE9uIDMvMjQvMjIgODozNCBB
TSwgRHlsYW4gWXVkYWtlbiB3cm90ZToKPiA+ID4gRG8gbm90IHNldCBSRVFfRl9OT1dBSVQgaWYg
dGhlIHNvY2tldCBpcyBub24gYmxvY2tpbmcuIFdoZW4KPiA+ID4gZW5hYmxlZCB0aGlzCj4gPiA+
IGNhdXNlcyB0aGUgYWNjZXB0IHRvIGltbWVkaWF0ZWx5IHBvc3QgYSBDUUUgd2l0aCBFQUdBSU4s
IHdoaWNoCj4gPiA+IG1lYW5zIHlvdQo+ID4gPiBjYW5ub3QgcGVyZm9ybSBhbiBhY2NlcHQgU1FF
IG9uIGEgTk9OQkxPQ0sgc29ja2V0IGFzeW5jaHJvbm91c2x5Lgo+ID4gPiAKPiA+ID4gQnkgcmVt
b3ZpbmcgdGhlIGZsYWcgaWYgdGhlcmUgaXMgbm8gcGVuZGluZyBhY2NlcHQgdGhlbiBwb2xsIGlz
Cj4gPiA+IGFybWVkIGFzCj4gPiA+IHVzdWFsIGFuZCB3aGVuIGEgY29ubmVjdGlvbiBjb21lcyBp
biB0aGUgQ1FFIGlzIHBvc3RlZC4KPiA+ID4gCj4gPiA+IG5vdGU6IElmIG11bHRpcGxlIGFjY2Vw
dHMgYXJlIHF1ZXVlZCB1cCwgdGhlbiB3aGVuIGEgc2luZ2xlCj4gPiA+IGNvbm5lY3Rpb24KPiA+
ID4gY29tZXMgaW4gdGhleSBhbGwgY29tcGxldGUsIG9uZSB3aXRoIHRoZSBjb25uZWN0aW9uLCBh
bmQgdGhlCj4gPiA+IHJlbWFpbmluZwo+ID4gPiB3aXRoIEVBR0FJTi4gVGhpcyBjb3VsZCBiZSBp
bXByb3ZlZCBpbiB0aGUgZnV0dXJlIGJ1dCB3aWxsCj4gPiA+IHJlcXVpcmUgYSBsb3QKPiA+ID4g
b2YgaW9fdXJpbmcgY2hhbmdlcy4KPiA+IAo+ID4gTm90IHRydWUgLSBhbGwgeW91J2QgbmVlZCB0
byBkbyBpcyBoYXZlIGJlaGF2aW9yIHNpbWlsYXIgdG8KPiA+IEVQT0xMRVhDTFVTSVZFLCB3aGlj
aCB3ZSBhbHJlYWR5IHN1cHBvcnQgZm9yIHNlcGFyYXRlIHBvbGwuIENvdWxkCj4gPiBiZQo+ID4g
ZG9uZSBmb3IgaW50ZXJuYWwgcG9sbCBxdWl0ZSBlYXNpbHksIGFuZCBfcHJvYmFibHlfIG1ha2Vz
IHNlbnNlIHRvCj4gPiBkbyBieQo+ID4gZGVmYXVsdCBmb3IgbW9zdCBjYXNlcyBpbiBmYWN0Lgo+
IAo+IFF1aWNrIHdpcmUtdXAgYmVsb3cuIE5vdCB0ZXN0ZWQgYXQgYWxsLCBidXQgcmVhbGx5IHNo
b3VsZCBiYXNpY2FsbHkKPiBhcwo+IHNpbXBsZSBhcyB0aGlzLgo+IAo+IGRpZmYgLS1naXQgYS9m
cy9pb191cmluZy5jIGIvZnMvaW9fdXJpbmcuYwo+IGluZGV4IDRkOThjYzgyMGE1Yy4uOGRmYWNi
NDc2NzI2IDEwMDY0NAo+IC0tLSBhL2ZzL2lvX3VyaW5nLmMKPiArKysgYi9mcy9pb191cmluZy5j
Cj4gQEAgLTk2Nyw2ICs5NjcsNyBAQCBzdHJ1Y3QgaW9fb3BfZGVmIHsKPiDCoMKgwqDCoMKgwqDC
oMKgLyogc2V0IGlmIG9wY29kZSBzdXBwb3J0cyBwb2xsZWQgIndhaXQiICovCj4gwqDCoMKgwqDC
oMKgwqDCoHVuc2lnbmVkwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwb2xsaW4gOiAx
Owo+IMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25lZMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcG9sbG91dCA6IDE7Cj4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWTCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHBvbGxfZXhjbHVzaXZlIDogMTsKPiDCoMKgwqDCoMKgwqDCoMKgLyog
b3Agc3VwcG9ydHMgYnVmZmVyIHNlbGVjdGlvbiAqLwo+IMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25l
ZMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnVmZmVyX3NlbGVjdCA6IDE7Cj4gwqDC
oMKgwqDCoMKgwqDCoC8qIGRvIHByZXAgYXN5bmMgaWYgaXMgZ29pbmcgdG8gYmUgcHVudGVkICov
Cj4gQEAgLTEwNjEsNiArMTA2Miw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW9fb3BfZGVmIGlv
X29wX2RlZnNbXSA9IHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5uZWVkc19m
aWxlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA9IDEsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAudW5ib3VuZF9ub25yZWdfZmlsZcKgwqDCoMKgPSAxLAo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgLnBvbGxpbsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqA9IDEsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5wb2xsX2V4Y2x1c2l2
ZcKgwqDCoMKgwqDCoMKgwqDCoD0gMSwKPiDCoMKgwqDCoMKgwqDCoMKgfSwKPiDCoMKgwqDCoMKg
wqDCoMKgW0lPUklOR19PUF9BU1lOQ19DQU5DRUxdID0gewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgLmF1ZGl0X3NraXDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoD0gMSwKPiBA
QCAtNjI5Myw2ICs2Mjk1LDggQEAgc3RhdGljIGludCBpb19hcm1fcG9sbF9oYW5kbGVyKHN0cnVj
dCBpb19raW9jYgo+ICpyZXEsIHVuc2lnbmVkIGlzc3VlX2ZsYWdzKQo+IMKgwqDCoMKgwqDCoMKg
wqB9IGVsc2Ugewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWFzayB8PSBQT0xM
T1VUIHwgUE9MTFdSTk9STTsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoGlm
IChkZWYtPnBvbGxfZXhjbHVzaXZlKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBt
YXNrIHw9IEVQT0xMRVhDTFVTSVZFOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmICghKGlzc3Vl
X2ZsYWdzICYgSU9fVVJJTkdfRl9VTkxPQ0tFRCkgJiYKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICFsaXN0X2VtcHR5KCZjdHgtPmFwb2xsX2NhY2hlKSkgewo+IAoKVGhhbmtzIQoKV2lsbCB0YWtl
IGEgbG9vayBhbmQgdXBkYXRlIHRoZSB0ZXN0IGNhc2UgdG8gY2hlY2sgaXQuCgo=
