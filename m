Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D701593192
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 17:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243231AbiHOPRG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 11:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242945AbiHOPQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 11:16:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3222E2714B
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 08:16:37 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FEq19k005247
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 08:16:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8cr+pCxp8d+Mt993ukSRdlbG9Swnxmm/OibVGSd+Vkc=;
 b=XNtEWOpIQd2XV56biWJlTNtUQJvBaKHoj9kkHmZFKdEvtDYYm6t+4gtONFHc012nd/Nk
 osTMtpwQuZGs2qzG6vy5xo1E5gPET/mWtwRmh5FJ5/BuAv4eALaxeuFwJf5+ATRBHAJi
 m9/npVKrdU5TLbszKzBGffTI0CJpGy3zk9E= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hyr9dg6ef-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 08:16:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W62E0HvncrO3QqlUsG7VXm6lmKnpOPL/PEoFx+IxuC53x1k6eOupUSZIek8CFmQJBnWpMGrL3fW/lyRblCp8uEhuXrauHq7YZkbHZtaPd8R+fasmAs+m7OJSG/nogA+9lRIHaz7f7xV1dSw82mkKSr9EbwbL+872zBbrFrC8+4v+qKkZreH2q6aYD+XC6AgLkNWaP2v38Av7X/gNorKFVSsCYGTPWHYHCBEvQoIXIUrUOhGtXF82hvehiwM3wlaIzyL/E/T86YztUQU4HGDZzDVTHNq7Iya89h4YOGKRAft6G0E6Kx0Nh7g7Ey3YOmL1E4/K4oklZeXLXs+5p2gWcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8cr+pCxp8d+Mt993ukSRdlbG9Swnxmm/OibVGSd+Vkc=;
 b=aHzeb2SDpk5AcVgIauxKCOmHCHkfaM1aVdgd6SmiFSVZIIU7ioRCJPooSuTDSfSgwxQtKWaNHh2Q0cIuHPD3TbuYqzGBkJiijMIhhrnuFsJZPhBLMNzq6/by8fJbJbjvPIEHu0FUFrSO+h1NvibhzB0iOAirIQXryBusx8hLUuQGjCVungj/LJXVzzelrHJusc1i7EtWYQDxV4QK35TLQo0ae29Gi8BiYMXGR2DPM6NBFfLed9c7vLeg90kXn3RZ0GmbYYiWaY0d6XSwWrrxaJ0w2l2I5Hn+VoqTDukx8snaNv0qeMyiEBWnTIL72HBO5vRMtLuDYzmZ2TC5AlS89A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SJ0PR15MB4504.namprd15.prod.outlook.com (2603:10b6:a03:379::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 15:16:33 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::57e:a3a7:f16e:d3a3]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::57e:a3a7:f16e:d3a3%2]) with mapi id 15.20.5525.010; Mon, 15 Aug 2022
 15:16:33 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH for-next 1/7] io_uring: use local ctx variable
Thread-Topic: [PATCH for-next 1/7] io_uring: use local ctx variable
Thread-Index: AQHYsKimguC5n3S3jEuAYtn2vNw0xK2v+WuAgAAZQwA=
Date:   Mon, 15 Aug 2022 15:16:33 +0000
Message-ID: <6b55004f46f973788b88a7c3d4fd19eeef20ce0c.camel@fb.com>
References: <20220815130911.988014-1-dylany@fb.com>
         <20220815130911.988014-2-dylany@fb.com>
         <119c96ef-5231-7576-e92f-62b9b35e2f8c@gmail.com>
In-Reply-To: <119c96ef-5231-7576-e92f-62b9b35e2f8c@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ba7af3d-1948-4b27-8451-08da7ed12378
x-ms-traffictypediagnostic: SJ0PR15MB4504:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bzlo+wTNthq2BYgpUyehFEt+0GY5kqtCq6PNsCh3uXBMYfP/3ISqMUC3pndVKmxwK4hJaA/qOb/9Oxzizzpsrb29bygrGx3xRQhwOyyZajyS405VGRHFUxiMIVB4fbggcxCxp7NjCD7xMzMD2baNL7x4mZppmHj6mU+TIGuh8NJTqrQ6mrxtcjj8AIqBcWsVgX/vgd39116n1hpTsehCAjDEDifLLb1h45Yd6baBkBGzNArlJJ8DkB+ZQRv94IgEceF4tu+uZFtO1YvAmssHPg2pIZLLid1XkOiy9v3MKl1SOz1Y+en9mlF8dwHjzRNHmTtVa+yyd1vUZ609UlOZ4xtf5906jslR7OCamQDA/1eA/sxYcrWvDrdMRIV+kWFeEszxkDBiR2/jTveE/W3KUcCx8iMqyxH7/AfiK/N9WVsvhm5f5M6KEwlMxzSxEMRC1xuCwjGGbu3oXuFxL9ZztDuwPf4ir7IejRa4qq0e5ObZiP9trH+Cu/1ldLRnM53DZpBxa7YJecdF8SCNdJIlncsKI3/bvHMnxTkL6ZcJEYawXKIM7M2HM2gHSg/137Mp2YW3zLY4jZbPu1oYt3rzNyAHP678HVX87OmPgwuvVwFEQKipDMvtijFWeXHvIYAk1oaZNAmZoD6l+PuSuPoAvZm/Lx19Kn1A6V4O0UsjKTZwtOJc1HyrahyvDim1W0fT1aELaZcErgALSTs8SF9CYgkOWOdaJZ3nnru0MoobgNEH/CVTJQH9GZCkdxbhgqbzth4Xs//1lpGLSQYimDCj/34CvvpGM0yEfCYdTaneUuyxNwD38PmPfFZ7Mt2xlZUJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(76116006)(66556008)(71200400001)(4744005)(91956017)(5660300002)(2906002)(8936002)(110136005)(4326008)(186003)(6512007)(41300700001)(478600001)(316002)(2616005)(8676002)(64756008)(6506007)(66946007)(66476007)(53546011)(66446008)(38070700005)(86362001)(83380400001)(122000001)(36756003)(38100700002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RHpFWjdhY2R2MjJGT0hiaFVGNFpqVEQ2dVpQRTU4VGtjRVo3NlJwWlJKOVhJ?=
 =?utf-8?B?bjBKbkh5RlgwQ0Z2b3dLM0o4RUV1ZWZzRnFBUTl6dWQ4aW4wWjk2dW0rbVhD?=
 =?utf-8?B?djdzRE5ZMEFHR2NaOTU3NldFNjFSWEVseUt3bWRyMDBmYTBuZmRQLzY3TU1E?=
 =?utf-8?B?SURmT1FqTGFiUGs3ZWFsQlA5djg3U0pBRkpMMjhyd2I1MGpFU1Q4RFVJSUtU?=
 =?utf-8?B?eE10Q1FVVExwWHl1UFZ0eUxjVnIvYmZIMDhpZVRTUGJEeEhDc2ZEWUU0U3Y3?=
 =?utf-8?B?TFlkSDJxQURHcXZhSFRleGNpNUYrWFp3NFNHVWRodEwyOEY1eG5wNHRZMXZR?=
 =?utf-8?B?ZWc1aEgxNHdOenk0Nmd5SFZ3WStVSTVnTXZ6cTZhS3pXd3pVVHhTUTV6cUsr?=
 =?utf-8?B?VE54ZzFkMjJMbTF6T3hzelVrekhRcEJNZjViMnIyN1lkYmtLUkNWMTNKUlNQ?=
 =?utf-8?B?UTNmd3dVNGc2SUszWVgwRDUwVjY2aCtkSHByNDd2bVJlUXMvQ0RiVTQ5M0s2?=
 =?utf-8?B?dXpTSGE4Z2thL1Q1U20vZTNROFBETk9lSFVWOWhMOUVQYmxlUHA4Q1NLMGI4?=
 =?utf-8?B?OWk3SnZWc2FQRXk5MVdtTHptWW9VTUtHTFI0dGxQaXY1bitQZ2dyelNsTTF3?=
 =?utf-8?B?RE01cWZkNVFmbVJRMWY2NER1RTN2dHZSYzF6N3c4ZFVGY2lzSEYrZnA2YWNk?=
 =?utf-8?B?WUZwSUhYZ0tjZnRTdUh3dDNZS2JGME1uekV5bjZjaDNYMko3Q3NjVkNRRTVy?=
 =?utf-8?B?MkJONmFYRUFtYVFRZUdOOGFFRDAwQlA4SEFnVGhydTdWdHExWWhZRm4xc1Bo?=
 =?utf-8?B?MDYxVUMvYXhLbHFScmJUWStON1M5d2RLRXVBUGFBYmtSckMwN2RMYTVFSFBM?=
 =?utf-8?B?VmVFS21KVndnTTBRcXYxamhIMmE2Z1NPSU84Z2RxREQwcXU2Ylg3ZFQzNHZI?=
 =?utf-8?B?aU1pcFVrQVRDa3VEaUFDMzl0NjFsN0taRlM2MmFYUkdveDhBbkdxTXhWdVpM?=
 =?utf-8?B?cmk1ajU1TmdYSGhXcjJmK1VEb0Vtd0NlTXpuUnF5akRhL0h4T2JqZXE3ek53?=
 =?utf-8?B?aVJhRVMvRnVUZ05FMmpnZTdMN0EvRURLU0FnT29PRHBNaDA0WlZhdzRhMmQz?=
 =?utf-8?B?Vlc0K25MWEczS1dQaDg2WUFVR0VJdXU1UDZ0bTJjU0tESVpOMFZFdVdRRExT?=
 =?utf-8?B?OHE3MDQzVmNza3FWT1BJMjN6Nk1CTEtRNHJNbVNSeEdjdU9SUXRYeXY4TFVx?=
 =?utf-8?B?OFNvV0VUdWR2d2Z5NUg2RXNFUkZGRDltZjR1ZThhY2IrdCtVVEl0OGVZS05p?=
 =?utf-8?B?OHExRFd0c2ZZQTkyQXI5eFAxRTYxM1NTR1cwekFBV1oveVpTbVlWbk5JSTc3?=
 =?utf-8?B?QXdCd2ZsbnYyVmdITnI3WmZFTlptTWNlTFVyRU9NQmNxVHNYYmhpcUFQUXdU?=
 =?utf-8?B?MHJrb1c0US96RjlBNmVrU2t1QmtncWt0QnZ3Z2hRWkk4TlJMVFFVOGRZbGVG?=
 =?utf-8?B?OSszQUhVL3JobmtPaHR5MTdUUnlRNDZrcmZub3BhNDc0Y3k0ZGF2SnVXSHZi?=
 =?utf-8?B?MWwrWUx3Z3UveTl5MzVCU0ozeTdYZ1lrQitDV0trRUdpSlplNFpIRThiU3l6?=
 =?utf-8?B?VDBYMlFISURrMWZpMWlvclZnc2tudm9lOElhMUhNZ2UrOE5jaXp1T1Qrcm1y?=
 =?utf-8?B?VURkSEdnYUpHaFh5aGY5MTJ1OENFTVJOcnR5NGxRTjZGM0FFQ1NaVG5saXM5?=
 =?utf-8?B?dFJ2VjEySXZWWkhqbDIyM2t3MklpSUZUMmdtc0FPUXQ5emNWNTdsOExiMWJj?=
 =?utf-8?B?dTRJZ2NZQ2ZqRVh6MjBoOEJ6MFY2bzNGMkpLSFZXdmIvRlFETy90b3VLakl3?=
 =?utf-8?B?S29rVWIxK2M2ZWdvY1duTFhoQytsS2FLVlFPNzFqQ2krS1VUYW00UEo2WXlT?=
 =?utf-8?B?QkhzdzFrVFduRnJJQVd2cmVTaSt0NExCcGxKZjVDc3NXYWxyY2JGQzh5Ry9n?=
 =?utf-8?B?QlBYSVFETWxsQ2RqU0hWUWpUbm9qWDNSaTlqNk03QXFXMnZ4MWpzeXZRczFr?=
 =?utf-8?B?MmpaMmU4OU1rWmNHdWZjcmw3TkhMZTdRZ21TRXhOMm1wWHg2SFEyRDJXVndF?=
 =?utf-8?B?TTB2blB0N0NGSTc3VE5BL1FpMXF2YWZFUnpQMlJONlM2dUFROVFGU0ZGUitp?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A1F7AC0591E6941B2DD13D33CB6BF3D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba7af3d-1948-4b27-8451-08da7ed12378
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 15:16:33.4087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yvaovXUKMTRTd2F395S7Zq5RZ009PtFUs8eAKKpTp1qoVhN8F4Q770MgS/G+fKUd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4504
X-Proofpoint-GUID: ZNUfUq3ZjuvVu-Sz9YDoKdy0NBKSbAGR
X-Proofpoint-ORIG-GUID: ZNUfUq3ZjuvVu-Sz9YDoKdy0NBKSbAGR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA4LTE1IGF0IDE0OjQ2ICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToK
PiBPbiA4LzE1LzIyIDE0OjA5LCBEeWxhbiBZdWRha2VuIHdyb3RlOgo+ID4gc21hbGwgY2hhbmdl
IHRvIHVzZSB0aGUgbG9jYWwgY3R4Cj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IER5bGFuIFl1ZGFr
ZW4gPGR5bGFueUBmYi5jb20+Cj4gPiAtLS0KPiA+IMKgIGlvX3VyaW5nL2lvX3VyaW5nLmMgfCA0
ICsrLS0KPiA+IMKgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9pb191cmluZy9pb191cmluZy5jIGIvaW9fdXJpbmcv
aW9fdXJpbmcuYwo+ID4gaW5kZXggZWJmZGIyMjEyZWMyLi5hYjNlM2Q5ZTlmY2QgMTAwNjQ0Cj4g
PiAtLS0gYS9pb191cmluZy9pb191cmluZy5jCj4gPiArKysgYi9pb191cmluZy9pb191cmluZy5j
Cj4gPiBAQCAtMTA3Miw4ICsxMDcyLDggQEAgdm9pZCBpb19yZXFfdGFza193b3JrX2FkZChzdHJ1
Y3QgaW9fa2lvY2IKPiA+ICpyZXEpCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJlcSA9IGNvbnRhaW5lcl9vZihub2RlLCBzdHJ1Y3QgaW9fa2lvY2IsCj4gPiBpb190YXNrX3dv
cmsubm9kZSk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5vZGUgPSBub2Rl
LT5uZXh0Owo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAobGxpc3RfYWRk
KCZyZXEtPmlvX3Rhc2tfd29yay5ub2RlLAo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICZyZXEtPmN0eC0+ZmFsbGJhY2tfbGxpc3Qp
KQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzY2hl
ZHVsZV9kZWxheWVkX3dvcmsoJnJlcS0+Y3R4LQo+ID4gPmZhbGxiYWNrX3dvcmssIDEpOwo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICZjdHgtPmZhbGxiYWNrX2xsaXN0KSkKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgc2NoZWR1bGVfZGVsYXllZF93b3JrKCZjdHgtPmZhbGxiYWNrX3dv
cmssCj4gPiAxKTsKPiAKPiBSZXF1ZXN0cyBoZXJlIGNhbiBiZSBmcm9tIGRpZmZlcmVudCByaW5n
cywgeW91IGNhbid0IHVzZSBAY3R4Cj4gZnJvbSBhYm92ZQo+IAoKQWggLSB0aGF0cyBhIGNvbXBs
ZXRlbHkgbWlzcyBieSBtZS4gSSdsbCByZW1vdmUgdGhpcyBwYXRjaCBmcm9tIHRoZQpzZXJpZXMu
Cg==
