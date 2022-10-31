Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C17E613BA0
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 17:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiJaQrH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 12:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiJaQrF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 12:47:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98861181E
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:47:04 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFdOC018940
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:47:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=AtSEZLjA8jZczsJ1/SNHDF6Ax+c605KUqCadAnJ1F4U=;
 b=nHtnvEmcsX3Lhw2L2v8ceBGSEHF0xxXUM4oPmaur5UyDSyAfQ5ns/q6jIZWwpT47pyNm
 A+kuELBdV+nQR/xUK/fryN5v3p7m7qJZ5Y6UvKK6zGODrvafIcGQHH5O2zRVGLVK39Gk
 PDT0fzXwutFPo9hUdI0YRO5F0TwzBhuCS6l8sQe9WWagH5ZnrYm0HCFXxvRpA1p3pYyo
 gEbULRVbogZc7P3MuPAkV6C5l/XqsS84T28vKa5k7xM1OxIDjsYFOWgEZdegOmlA8F5p
 DbtYBOuHTmOWWOOlyOLyAhyfU2ygmeV0WcHSu3i0QURHWLGXJS5NHO3KEDq3jzRsMdQ6 Sw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1vq04up-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:47:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpiRnliJe9hOuB+uaW2tpkhVHYpgxT9NJPH0spT9kfGTNJcJd78ofVEuKILbUS1QGnJESytoWUbVda+E/2mH/Lmgv/8+BMWxa76m1ATkKGwit5V7FlCTYObzXzuoCjx5dOMM+t0irOa60VBHiWTCx2aZh9GGvnq5zbVvbvGx69Ps3DR7tvOellC/7ODQGC9/vOxMapFn8GkWBL8gq99VS4nPjahiGoZnTDSHxanL2ig3mzmPI3sBbYiYjxVOAsFk3yJK/yfH+QJ3tr+vHW0sRGxuNz4eLKfQTIZV8xoWCDZz3V4ua6OiJoWPMywIr9KT2ZR4ZSJdyG8ByoK47/7FQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtSEZLjA8jZczsJ1/SNHDF6Ax+c605KUqCadAnJ1F4U=;
 b=fqaPMWbLNWfNrrLMvm8gNbfF4c9ktzDi6X4eZJximV3GWbGlNFymO9yti08Om4IKHVX++GtOHde6Jp9IAsq3NbeHo7AKe1Ro9pbU1TNByaccaitS3vnNvRDR43wJtxSCjv+j4jh3dCRjRpY0uN5lTiJvk7L1/cGEB02mDXvZ92UX9YNmKkFWwrIR96sDh6y0JIpdBSlATCNXFEkm9dIdMUlFSoKEiTyIxRaKHNL6qg+yjb1b/kViLgeAoU8ySk82gJOxKHKOeOHdGmRYNeMXrVdqdUsTvzm6g1kEtA2Xq3hz1nRiNlHbhq7nt4U0JxHUAn9OcPlYAK/MGslqFlZNag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by PH0PR15MB4431.namprd15.prod.outlook.com (2603:10b6:510:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Mon, 31 Oct
 2022 16:47:01 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 16:47:01 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next 06/12] io_uring: add fixed file peeking function
Thread-Topic: [PATCH for-next 06/12] io_uring: add fixed file peeking function
Thread-Index: AQHY7S6LI2lAw9pbt0KiTkWEcH/DO64oqqUAgAALyAA=
Date:   Mon, 31 Oct 2022 16:47:01 +0000
Message-ID: <340bd9d2a0889857bce22767e29883842a333b9f.camel@fb.com>
References: <20221031134126.82928-1-dylany@meta.com>
         <20221031134126.82928-7-dylany@meta.com>
         <a482ab89-37af-2df7-1863-438a7615c905@kernel.dk>
In-Reply-To: <a482ab89-37af-2df7-1863-438a7615c905@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|PH0PR15MB4431:EE_
x-ms-office365-filtering-correlation-id: d87f5a0d-039b-4fd9-5550-08dabb5f88a1
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sN4n/yIQZyApXOxEH5dG/8SR1DLswTM13Ps5Kwl5thCnatxYiOrVirE3xCCo98VIJaAeCB1xEy+Xp4FOfzqucVjsQGxiz9rL4HTPqdabMC6RAYLBuA3yyhV3gkj/d4nHN8kbyUm9gHNbJh8msAx5/CWxE1ukFEDytsuiRiUNKkn7RZwGUYHsNhQ0rqNBz3ST1h7AvQQkjBj+vr+0xImbDjVz3bRpam0UXlnUsmvWrL+UdUQGwPfXy4rT2mnBftxJw9qVQGv7okGmSXIm3cxS0WfmOPfxTyo206aGFvLXgvbT+HIzQY3sx6soq+hqKLN9CYghHA2hkJ6BX1vAPwkP8GO/89hkFABQ7ukniYO9vjyZj90nGD5NSRAhXV1csoXtPj0FO+4DIY6KsRwNtxrX2wHZJnENcyRldmmF3rQ/opW9Ig3JXCWl4Kg+ckPDoC0MQmIDBUQJHCsnRu7u6ip3GMj34RVj7hOVLmUupv8QKnIJgiaBe3P1eSc8J+JKRrpFG5cvoPVFFqGyGuUku0YspgoBK47bBv96JTjWWqRXA5Ybfzhu+V2PQr4BMTpmIpl8/KtcrRsRkkJTqFejtOHERiRQDvq0J+YcN3FPvTBh9PNPLxVwIVSrPYL81wP5QsslTzgNEFCdbIRDizOdzJyzBpB/i2kDSMuTjUazYeD4b9e7hdpK5FIVhLCqUzOlUBqP9YExjSMfO77eh6NrKjjX9ixEBZi73otwCYYaFgyjQUCqLBHO1kgZyU2tmLft0UaJCt2YhDqHRKze1Nqo+9tOGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199015)(36756003)(86362001)(122000001)(38070700005)(38100700002)(186003)(4001150100001)(2906002)(53546011)(6512007)(9686003)(478600001)(6506007)(83380400001)(41300700001)(71200400001)(6486002)(54906003)(110136005)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(4326008)(64756008)(91956017)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WURTNmJ2T1I2bHNWaWFpVi9RMXBkNFN2cXdFdmVEblEyM01pS3ErWTFoSExs?=
 =?utf-8?B?UzhLYzluNk9ra3gwWGxMSzE4QTlVNjd1cEluK2dCOGJpVUNlc1Z6WDQrdUlK?=
 =?utf-8?B?aGFjTmNUb28xSStTeWJBT2l5NE9oNkVjU25oc3VoVk84Z1ExQzhRbm8vMWxo?=
 =?utf-8?B?Qm9rZjR5Y2IyYlVwekwyb05xejdPQTBIRFZaNHA3NnJLVzRHWkRzaW9sMWg5?=
 =?utf-8?B?V0pxY1NMVVJBYkt4VitycFQrT0hYanM0UldPV2FHb2xlT21ySDNWendnTm9Q?=
 =?utf-8?B?ZndWbVVFT3A5a1htSHgvWnROek9hL2U4Uy91Z3FsUVNSUU1hcHphTGd3LzJF?=
 =?utf-8?B?M0NZc2ljV3VGN2tyeVErODlFbXV2akpTUEo0ZDlhUTVOM2NHU0wydHVSdDBa?=
 =?utf-8?B?ZHRIRTdtR3laMVBvelY0RHFkWmhJbUY0VVJkY04zSlBBdDZvQWlld0RtdXIz?=
 =?utf-8?B?M3RHcTBSd3NEbktpSGkwWjVoQm1UdWhaeVRBMUxLUGtML2IrdDZsS1VMUzVF?=
 =?utf-8?B?M2picS9PUEQzWkhPNGcxZEJNOVdvT1lGMVl6WXU2MjZMLzNuSUtNd2M0UVJV?=
 =?utf-8?B?YkVKZDJRUHYwdHNPNjgzdzR3YTc1cVZqZjlkcUxERTRWY1FJa0tpQnd0Rkcr?=
 =?utf-8?B?dmU3dkRDZExSMWlpMy9xVFdDZzVkODlCRkMyQ2xoaXVrL00vSHBIVWxDeVlt?=
 =?utf-8?B?SjRaMXozNVdSN1RlYkJLMjZqYVRUR2Q5WjRHL1owWnpteGw1enBiU05BakU5?=
 =?utf-8?B?K3I0bUtKN3pJUHh4Q2REYktVeHR6Wm9Obld0Z2oyNk9SU29PalRxdEZ0SnhM?=
 =?utf-8?B?eE0vL0wzQjBiOFBIRUlsaGUvMlBsK1lnblFqdWFzb1NhWlVVUzByVFFJMWxr?=
 =?utf-8?B?b2xVeUtITC9QQWdjeTBpSjN3WVFCWmxzL0ZZZ2M2M0lxd2ZnYVZMSkdURU1G?=
 =?utf-8?B?RGZRTHpEc0J6WjZTUVhIYVlQVFFFemdDajVNOUl4a3hKV2RJZ2VpYVhCVVVV?=
 =?utf-8?B?VnBKWHc5MDVUdEkvK0lqYXBXY1V0Y2hpclllVmM5dDZ0U0UyNlhMWTVhNW5C?=
 =?utf-8?B?WkppUWZwRXVWQ2RHNy9HcXJKN2JGcXkvb1VPa2ZabTdpQlFXREdUNFZWQmxN?=
 =?utf-8?B?MHNJbkw3QVF0QmlNbkNhSWVENTQ1TzVSeFoxMGoxcm4rbGp2QXhWNTlOb29I?=
 =?utf-8?B?SFJiM2E4eUtodk9EQ1pDMXdkTFdQM1VMWVJOMCtrcTRHOUVRTEVvbEFjWmQw?=
 =?utf-8?B?K21DZFJKK3pmSVFLa2JxaEpJRUhFN3JLUk1ybllBeXZyUXhoR3Q5R0NsZExT?=
 =?utf-8?B?bnhKM3hSNkczRmZjekU0ZlVQUTJEZGVaeVlrbVY5MWpuZlR2SnMxaC9wOTlL?=
 =?utf-8?B?VXZPK1NVcENxenJ1aHpZa2d0eG96MU1NUnJ4S0JRdkhMSUFYdHJPNTU1b3ZC?=
 =?utf-8?B?cmFFTXZ4aVA2Q2tYdFlCbWVHV3Z3b0JqQ2hkb25aYlZRWkc5YXJyNk5JQ2xu?=
 =?utf-8?B?eTNUNVpIYmxqUHFUZnc3cGhTUFBvY2JzWTRIWHhyaFptSWhJQUxvYURhWnky?=
 =?utf-8?B?a1FDQTgwQ3YvS0NzcklyVEZjU28wR3NERUV6a3hBRTVHeDV1QVFsOXN0dFBs?=
 =?utf-8?B?elE3dVRPdVFWYTR2OXJ0MTMzUUgwZFMvYjVlQUR0bkFqc1hjMWFRanQzY2dH?=
 =?utf-8?B?NGJmOXFOS3dtSm9vRW00dWM3NE95NWRnT3VXQVBOZjZuOUFwczFTR0JqK1R4?=
 =?utf-8?B?Z2RTWVEzNHRmaWV2SnFFUlFHSlVOSzhVVFg3ZVlGbHJoUURVQWg0MGUwekpR?=
 =?utf-8?B?d1lNbE0rV1hNNGs0SkhSaE1PU1N0QklkZFE4TzRuOFc4UUVNM2c2UWs5U2o5?=
 =?utf-8?B?UVlnTGZMeUw1L1RsTG1XOWtaSXdnaXN0ZjZyTFZvUkdmdE55ZEtxaTJKQ0ZE?=
 =?utf-8?B?UU5BUHB2dU9wYUF0VGZMVy9UenhDMnZGbEUxUGlrQXd4b3RrWmM4MWI3SEpW?=
 =?utf-8?B?bjJzeTJCUkN3cnhEN0Z4WjlPVHgrQk5YQzVwaGJ1eVhXRi81NERkcmhlNG9D?=
 =?utf-8?B?b1dacTBlbEdCNVEwZEc1MHlPVmhnVm9ZN1BkQlBtZzhwbWpZZUhSaW13ZEFO?=
 =?utf-8?B?ekVpbkRaV09MOUNycFE3SEp2Z0hlL2V6YWlTUU1kWDlOdlJKdUJaY0Z5Ynk3?=
 =?utf-8?Q?EMTUhv/w1hArt9gsOaGiUIs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B55CBBA9B085847AD506A83743AAF15@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87f5a0d-039b-4fd9-5550-08dabb5f88a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 16:47:01.4752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgd+rvi+5dKJSZbfkbZJToKklowUFqtkLHtuC3XY61brIjd7+rXpGqa5KUC2rQ8k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4431
X-Proofpoint-GUID: zTK7w438r-SYUELpYUU_zojG0SdLkubX
X-Proofpoint-ORIG-GUID: zTK7w438r-SYUELpYUU_zojG0SdLkubX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_19,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTMxIGF0IDEwOjA0IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMC8zMS8yMiA3OjQxIEFNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+IEBAIC0xODQ5LDE3
ICsxODY2LDE0IEBAIGlubGluZSBzdHJ1Y3QgZmlsZQ0KPiA+ICppb19maWxlX2dldF9maXhlZChz
dHJ1Y3QgaW9fa2lvY2IgKnJlcSwgaW50IGZkLA0KPiA+IMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25l
ZCBsb25nIGZpbGVfcHRyOw0KPiA+IMKgDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlvX3Jpbmdfc3Vi
bWl0X2xvY2soY3R4LCBpc3N1ZV9mbGFncyk7DQo+ID4gLQ0KPiA+IC3CoMKgwqDCoMKgwqDCoGlm
ICh1bmxpa2VseSgodW5zaWduZWQgaW50KWZkID49IGN0eC0+bnJfdXNlcl9maWxlcykpDQo+ID4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Ow0KPiA+IC3CoMKgwqDCoMKg
wqDCoGZkID0gYXJyYXlfaW5kZXhfbm9zcGVjKGZkLCBjdHgtPm5yX3VzZXJfZmlsZXMpOw0KPiA+
IC3CoMKgwqDCoMKgwqDCoGZpbGVfcHRyID0gaW9fZml4ZWRfZmlsZV9zbG90KCZjdHgtPmZpbGVf
dGFibGUsIGZkKS0NCj4gPiA+ZmlsZV9wdHI7DQo+ID4gK8KgwqDCoMKgwqDCoMKgZmlsZV9wdHIg
PSBfX2lvX2ZpbGVfcGVla19maXhlZChyZXEsIGZkKTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgZmls
ZSA9IChzdHJ1Y3QgZmlsZSAqKSAoZmlsZV9wdHIgJiBGRlNfTUFTSyk7DQo+ID4gwqDCoMKgwqDC
oMKgwqDCoGZpbGVfcHRyICY9IH5GRlNfTUFTSzsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyogbWFz
ayBpbiBvdmVybGFwcGluZyBSRVFfRiBhbmQgRkZTIGJpdHMgKi8NCj4gPiDCoMKgwqDCoMKgwqDC
oMKgcmVxLT5mbGFncyB8PSAoZmlsZV9wdHIgPDwgUkVRX0ZfU1VQUE9SVF9OT1dBSVRfQklUKTsN
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaW9fcmVxX3NldF9yc3JjX25vZGUocmVxLCBjdHgsIDApOw0K
PiA+IC1vdXQ6DQo+ID4gK8KgwqDCoMKgwqDCoMKgV0FSTl9PTl9PTkNFKGZpbGUgJiYgIXRlc3Rf
Yml0KGZkLCBjdHgtDQo+ID4gPmZpbGVfdGFibGUuYml0bWFwKSk7DQo+ID4gKw0KPiA+IMKgwqDC
oMKgwqDCoMKgwqBpb19yaW5nX3N1Ym1pdF91bmxvY2soY3R4LCBpc3N1ZV9mbGFncyk7DQo+ID4g
wqDCoMKgwqDCoMKgwqDCoHJldHVybiBmaWxlOw0KPiA+IMKgfQ0KPiANCj4gSXMgdGhpcyBXQVJO
X09OX09OQ0UoKSBhIGxlZnRvdmVyIGZyb20gYmVpbmcgb3JpZ2luYWxseSBiYXNlZCBvbiBhDQo+
IHRyZWUNCj4gYmVmb3JlOg0KPiANCj4gY29tbWl0IDRkNTA1OTUxMmQyODNkYWI3MzcyZDI4MmMy
ZmJkNDNjN2Y1YTI0NTYNCj4gQXV0aG9yOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4NCj4gRGF0ZTrCoMKgIFN1biBPY3QgMTYgMjE6MzA6NDkgMjAyMiArMDEwMA0KPiAN
Cj4gwqDCoMKgIGlvX3VyaW5nOiBraWxsIGhvdCBwYXRoIGZpeGVkIGZpbGUgYml0bWFwIGRlYnVn
IGNoZWNrcw0KPiANCj4gZ290IGFkZGVkPyBTZWVtcyBub3QgcmVsYXRlZCB0byB0aGUgY2hhbmdl
cyBoZXJlIG90aGVyd2lzZS4NCj4gDQoNCkFoIHllcy4gVGhhdCB3YXMgYSBiYWQgbWVyZ2UgaW4g
dGhhdCBjYXNlIHdpdGggdGhlICJvdXQ6IiBsYWJlbC4NCkknbGwgZml4IHRoYXQgaW4gdjIuIEkg
YW0gYXNzdW1pbmcgdGhlcmUgd2lsbCBiZSBzb21lIG1vcmUgY29tbWVudHMuDQpUaGFua3MgZm9y
IHBvaW50aW5nIHRoaXMgb3V0Lg0KDQoNCkR5bGFuDQo=
