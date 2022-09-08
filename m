Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433D65B23CA
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 18:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiIHQnq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 12:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiIHQnk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 12:43:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FC21223B8
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 09:43:36 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288E3KQ3010628
        for <io-uring@vger.kernel.org>; Thu, 8 Sep 2022 09:43:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Vh+lPuNv/LnWxuZ4TMo1brcYZfn6xTlysdpA8rLYXhM=;
 b=Xic+JpEjb0QATGcgt+wJm6niENE8R3WSY4VJ/fOG93OkYHieBkljEWkzcbFHT+ifKkRD
 lrG7eBUVtPGP0eEzsi2I9oIZ8BnAeXMK9tA475YnxfiMNYeRN2J3SXkhnhXedaQtXRZY
 kLiw5j83fz8sItXb5MJaOqln6FfewnYNrxI= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jfhth97h3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 09:43:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1JRIDZbuqdIZkRKES6KbP+GnjllOJddcJzVrDo9MHOew+40TTkNTqCbw7I8+UFMfNSTfbs8hlm+e/I59lML0+oPWfezQHggU0F49I7/Tz5UYSffYr9FG6MjJWlxqo8ESGHiqywqMj9Ri0dKEFZRGDqGqzrqQP/lM4z4rs+RTsjt+wCMEyC1oXnrPK7raeqQpAi1614NCoX5yJ/NeK2qpi3+zLfvlAoN+O0CyCQ9xRz3r0CXV5UpE9XjoozKOQZGL93vtEemMywIGxmyW+SgnLADVMIm3hFn+7Gi8GyY/t2AUfAf4M9Lsl8q3dD2bhJPPLCg7KCXAHAoDdb/sJ5qOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vh+lPuNv/LnWxuZ4TMo1brcYZfn6xTlysdpA8rLYXhM=;
 b=U3+g/sLhl4RBJ3rY9wxquUGEmg8Ssh6rXddw2Q+1vG54kaNRenbZVc7Awp2iHA0TcryLEzs041mZnfMqAuXu9IHQbxZGP3C1G/XkcYJI1mvrveC1Vw5X+3bmhOnBp34c49RTN96WlSXr74DeJso5KnFnYPAkoij7mm5mi5p8fmhhjiSZfA9I6JFe+VTZhU/7s+kzU2yeLqKd/ZRtZa6Z1G8pDbwMfdFYoRkBnqlL2p9iWPBu+D8aT7TOMapydGDOfuRckyww3OEHh9DMyrsxiwnHDrc5GVt2tWvVgXjt2LKHQVcg9Ekh0zHljLqcHj6CjOrdxy0IiAdXJxEZEKMosA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by PH7PR15MB5500.namprd15.prod.outlook.com (2603:10b6:510:1f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:43:33 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%6]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 16:43:33 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 3/6] io_uring/iopoll: fix unexpected returns
Thread-Topic: [PATCH 3/6] io_uring/iopoll: fix unexpected returns
Thread-Index: AQHYw5vsmnKoMXsB2U2FeDMjV7rF2q3VvQyA
Date:   Thu, 8 Sep 2022 16:43:33 +0000
Message-ID: <235002b825769b62c075837a20fb39d8f768a6f3.camel@fb.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
         <c442bb87f79cea10b3f857cbd4b9a4f0a0493fa3.1662652536.git.asml.silence@gmail.com>
In-Reply-To: <c442bb87f79cea10b3f857cbd4b9a4f0a0493fa3.1662652536.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|PH7PR15MB5500:EE_
x-ms-office365-filtering-correlation-id: 4c0781d9-7cf7-4203-098e-08da91b94500
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KRCjXQ1foykGIhv7De52uJos8hFB5DbYxMfQBg+udtQcdKz0w3DdHLNugSnyLL8GFLYeInH9zuH/IGsfqXeD01ZYy0BLck/jhim+1y3q89e6ehsSZ89Vko4ZIPmaZAPDWV0x+8HG6ErGR2K1WuyQR9yObJ1ozAOM1ka9Pa/DKEqLlG+nqDC1I8bPjLuKmfjZrf5j4zcjUkZrpQyIZaYPWWjXLrTtWazSA53igVuyV6BbX4Ppc3kHexK2MhJ0AB3q9AkZKHz7SZM5O8DBEArx6blg4scMtDwgygsLTHp6YXuQALXSCKstZlOwIM4JOFaIUccXF181i5L6/afDCVVWdiWe8PHbAXJ0G8UAc+OEQYWei1lrA/wVNoZR5A5KKIcwTo1CFu1XO3lG4MWcfB1DaYbvrhZhRHOFCWcvf6tG5NEaYHu/0QeXClgeogbyVuuvEWaGVQBiW6l0Kf8t6R5rfZfuNb2H5IzTu79ESwvbCUvkgf9IkmFVbdINafapxZlxUgnaSLLn0riE5nSPgUsECRJe89E2wEKeQO37LDFwsC7Gf+W1OAXVUY4//5UodzIUI1KEKkQkvmY2Jsx6daMeUqM+agMCi1ROCbByVQUrI03akEF/UsEl2tJfFtoio3zYjKqFGG7KVK9WnXD6vah3qJnvD1essHwCc4hzXfyuUwXnOwQsZBUhCKJ+1A8A9Mnj6PaDiHpyACnsk8W6mRcDCGlqbxha/PfCK1UK2dpbXDuQvJ1uKzodj0FOr/XfP+8SM+pUGb0KVLI751yVuw25Hw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(478600001)(316002)(110136005)(6506007)(6512007)(26005)(38070700005)(8936002)(36756003)(2906002)(4744005)(86362001)(5660300002)(64756008)(122000001)(66476007)(76116006)(66446008)(66946007)(66556008)(4326008)(83380400001)(8676002)(186003)(41300700001)(71200400001)(91956017)(2616005)(38100700002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjZVNE8wYWtnQVBCRG5HQzZLWDZ3bTQzMFRTK2hYYThjOFFYTUVuQWpmc3M1?=
 =?utf-8?B?NVdSRkc5V2kwKzNqejIrRHJFRDNPc3Uza282WnRZUlQreG1SM05UZjFqSllC?=
 =?utf-8?B?OFUwS2JhblhTeDVQNE5JYkg5ekxlenJydml3ZklpRlFqaHk3cnpyd25sbnh0?=
 =?utf-8?B?RUJpUXM5bndXSnIzZlpwUnNxemQrRUpkeGhhTFluNCtISlNnK2lJYUVhcmly?=
 =?utf-8?B?d3JUSDZ4UnpTN2Zack9YV2RYL1prVWhBQjc4TDBraFlRdld3TnJZNG9kN0hS?=
 =?utf-8?B?ZmFtTis2ZFhKd2hmRXF2VkZOdnRqWUlMNCtEWnJTKzZsMGpIRzVQSmdRdjV0?=
 =?utf-8?B?UVlMVzJYZHZuMzhyalRPdG5nRHFNSDZBaXljckdxUnZ4UzAvTTIyYW41ZWFD?=
 =?utf-8?B?T0tYcFVuUE9iNTJWNGEwZEV0VGZhSEd0blV6R25GNHpueUFSQ08xaGRNRmJE?=
 =?utf-8?B?WHQyMm1UcHovK1d1MEp3Zmo4UlQraWp4R0pUbk1zZk9yUkJmc2sra3VlRGd3?=
 =?utf-8?B?Q2REaUpkMTh4T3JCSm5kMkZtOGxCNnpGU2Q4MGRBV1d0NUF1cmphTHJnZHh2?=
 =?utf-8?B?ZGxiUkhKUHRrMGdDYzFQUHBIak1KY3FtNXM0QlJFSGVUUlYzWmo4c0oxWG03?=
 =?utf-8?B?WFFMRG0zaW00OUNGb3dvYkk5WHlEaHJWNk40VnhvdE1JN2M5c2RQajdpT3pU?=
 =?utf-8?B?Y2tHQURpaGhtUEJISmd1RURxT3Q1eXJEcHk3ZXR0U0xxbmxrRnppc3lqalRn?=
 =?utf-8?B?SXNnTmN3dE1CalpjVWJJT1oyNEtvN3p0Z1BFVmtjazdqbllDV0FPbUtJNVZQ?=
 =?utf-8?B?Z2JSWVVBY25uWjluTURSbjNqT1c1MC9uV2VmZVI2U1hsaE9YenZBbEhYVHpz?=
 =?utf-8?B?N01wWVdVZW80MWpWcGZWMFBMRVk2MVUxU2VYNXdEQVpnZEwxdWdGQmYvTzRL?=
 =?utf-8?B?MnZqZi90ekxBTWtDaEUyTkhkVzZxY1pCVm1VeWNMRnRWOERpYjNpUVM1dlJB?=
 =?utf-8?B?Q3o4ckpiZGl4ZWhzaVUxY2V0SWhLeHdWclIvd1hHNWJQbjY3ckdGWEJFUlp5?=
 =?utf-8?B?dktNNUpZRXQwMVYyTitRajdqWGNDenBuaTZyTklLY0pDeFkxU1BpaXJCUkhG?=
 =?utf-8?B?T0h0eFE2M0JWVlp0Y0Q2SFkwV3NuSWRRTWNCdXpGSTNCYjNwTmljVEFQWHRO?=
 =?utf-8?B?Y2czSWRXSzd5VmJJWlh4SmlEang1QTVHNitaMmhla3dDeldtS05PQXZZaGJ3?=
 =?utf-8?B?QTNvdDVHWENHeHJ6OTE4d0gvUjd0MjBRMnlGYnM2UFhZeXY0OWNLL2p3OG81?=
 =?utf-8?B?MXlCNmJHOVZydllzam9ZOExROERremJ3RmkrV0s2bEZqWERvVUlWR0czUzI1?=
 =?utf-8?B?SVhxTi9wWWhOcjA3OTBsSEdQU0t0bnljOUZsNFlhU0kwQnBvOUpraytsbk0z?=
 =?utf-8?B?Y0p0U1A0OENnNWxuQ2pYNVNud0lOcHFNdVdJNXhEcFlGMC9CS2t6WDF1bWly?=
 =?utf-8?B?Z2RlK2pFREhIMGs4bVdweWtaRUlZbkdiQTI3SlVoL1ZTRjRld3VFWHZhcjdF?=
 =?utf-8?B?V3RMNnJaQmY0VkVLdFBqYytpMGxGQkxNT0IzWFpWRTkxY25nOEROc1lja3RF?=
 =?utf-8?B?VTR4QThqK2tYQTNDam9HdDdROXFZOGNOdU9sK2RPaE9xTUtsUkxqT2x5RXpz?=
 =?utf-8?B?S2lVR3JlenRXc2g2d0lXaVo5NkpSYVUrOWpqbE5NL2oxTTF6NkZ5T3ArbDgx?=
 =?utf-8?B?Wm55RCs0T2pYM2MzMmEwNWJVQ0NJSjVYMGp1TzdlQklCejE2T2h6Y3dWWS9i?=
 =?utf-8?B?ZmI2Q1ltNUNyZXFiY1FFaU16RmZna2pQMkc5dkFoN0FuNjJpeGNCUTFaWFJ6?=
 =?utf-8?B?aDFOZnlLSzdGb25zQTR6eS9oK2cybE1tKzR4bWJ3SHhXZEdCTnZiSlRyMzNa?=
 =?utf-8?B?OGI2NTBmc1JUYVV5VHZMcEVIMEh6b0M3ZVA4MFVER25KTGcrR2tJNFpFdVQ5?=
 =?utf-8?B?T3JZTlczcG94c1BWYjJNdkhPRytoRGd6dk4rME93VUloajUycEczREJVVkhE?=
 =?utf-8?B?YjNaK3IxMFJoTjRjeVEwYjJTbkVESEE3eW51RExxbUU4QVdVN0VpZHpXRDd6?=
 =?utf-8?Q?FOEn22iiPJhTmz8Rfg5X3NbRx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D02795608B7DE459B9D64957B99F22B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0781d9-7cf7-4203-098e-08da91b94500
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 16:43:33.8485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FKKE/Rh5RHlhwkZjyxDs2YvWdXJLFASY33jnZUYeviuAX1MbOClAqWo7xlY/VXxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5500
X-Proofpoint-GUID: 7Edzvr3kghpXJO4Y6eWG4QsI_PF1N2MS
X-Proofpoint-ORIG-GUID: 7Edzvr3kghpXJO4Y6eWG4QsI_PF1N2MS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA5LTA4IGF0IDE2OjU2ICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gV2UgbWF5IHByb3BhZ2F0ZSBhIHBvc2l0aXZlIHJldHVybiB2YWx1ZSBvZiBpb19ydW5fdGFz
a193b3JrKCkgb3V0IG9mDQo+IGlvX2lvcG9sbF9jaGVjaygpLCB3aGljaCBicmVha3Mgb3VyIHRl
c3RzLiBpb19ydW5fdGFza193b3JrKCkgZG9lc24ndA0KPiByZXR1cm4gYW55dGhpbmcgdXNlZnVs
IGZvciB1cywgaWdub3JlIHRoZSByZXR1cm4gdmFsdWUuDQo+IA0KPiBGaXhlczogZGFjYmIzMDEw
MjY4OSAoImlvX3VyaW5nOiBhZGQgSU9SSU5HX1NFVFVQX0RFRkVSX1RBU0tSVU4iKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4NCj4gLS0t
DQo+IMKgaW9fdXJpbmcvaW9fdXJpbmcuYyB8IDUgKy0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KDQpSZXZpZXdlZC1ieTogRHlsYW4g
WXVkYWtlbiA8ZHlsYW55QGZiLmNvbT4NCg==
