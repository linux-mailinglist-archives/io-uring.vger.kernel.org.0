Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39855552B6F
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 09:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiFUHD1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 03:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346667AbiFUHDY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 03:03:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD66D13CF2
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 00:03:22 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25L1LAun009158
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 00:03:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=w3t24nC9nmHmQcAYO4lgfKvKvbAbGGgUbffvd2ob+T8=;
 b=Ui+q0lwBly9qyFJdUsB2gaoiEoppK3/NpdgdE3Q8S22P2L4TVYx+DPIYsHlefrsuSERf
 E0wFiqOdFpJb+jI2LT7pdC4XSvXaH8WqfWU65rhsUAbu/gMj0diI15vFTgp6QAz81ATg
 56HA3XlOKfVQRLQ+r8I4iYWrrzz2zr4p0zI= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gsacvx612-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 00:03:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aat+/Zs7YUF8Do5frdo1+PW7n/P+EBLkbebQmDpYMQkFiOhKQhkEKXC2B9giBpCYFAnexX2S7OgStYWoa4sdIcnBUbzqvcGt+99ZaEQl2fV14Kyjl253uB6LnyJFHyTCpbS98/wezw3AfzlkR0U8q6LNZffT/r09/C2DfEf2DkRROyUdwivlZYGu8c9kqSVkoRGNSC6kA1LBnxBacCZdeP7Bc5h7K4y8r2qoaugfv09Rov9/OcyD04UIIkIqsi1jm/FAVE9DTk1eA92ycedulPtst04IgMXeue4jHx8nl00JZWs0XNBJR6XzKTFWeXVONDv4mbk7C2eINWxCn9j6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3t24nC9nmHmQcAYO4lgfKvKvbAbGGgUbffvd2ob+T8=;
 b=k0HJYqbiW6VQ5MQYf0DjNEDkln3NJhL+25HB7m8UtW3iKrVeWMectBZKtv7DWeVQsQ/nn3sLBqLt4LSiXq9bQX8+l0c+RS+b9y0s8Yco2KnVTzyLZBxf4ZWOOvjwGSqvifdebBeuux6mgJl5Y2gd1NxvW6Y4NkD4MvALk4ooMmnj/51kblzi9KX/cb/5HirvwQERvfR7oQ1YLS5bn7TDSc4y+801ElByUScFRq0i2XqfOijStGdJ97vTz/tQIKEYVikkTGJXK1rowSMTrlczPQ2E9AgnZvXOqgOgW67VfVXiutqi16nMOJSpExxKhKeF4HNvBQ6oXzXlSw7rbDS37A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM6PR15MB2284.namprd15.prod.outlook.com (2603:10b6:5:8c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.21; Tue, 21 Jun
 2022 07:03:19 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::f0a8:296c:754f:2369]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::f0a8:296c:754f:2369%7]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 07:03:19 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "hao.xu@linux.dev" <hao.xu@linux.dev>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Thread-Topic: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Thread-Index: AQHYhMF7oWPfkzp4hU2ITxG7G8J9C61ZURGAgAAfZAA=
Date:   Tue, 21 Jun 2022 07:03:19 +0000
Message-ID: <f8c8e52996aaa8fb8c72ae46f0e87e733a9053aa.camel@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
         <15e36a76-65d5-2acb-8cb7-3952d9d8f7d1@linux.dev>
In-Reply-To: <15e36a76-65d5-2acb-8cb7-3952d9d8f7d1@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6851b530-71b9-422c-b849-08da53541f38
x-ms-traffictypediagnostic: DM6PR15MB2284:EE_
x-microsoft-antispam-prvs: <DM6PR15MB2284C6A11E2B3C65F3AC678BB6B39@DM6PR15MB2284.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oEL2kSgF8qIm/UGM+KdAo4x0+iaq7InwrzrtWFGJxiFOY7Qdj5nmjj2Nlu2BloQvnO9U9N6XRB4vwTNDyn64YRFYS4ql9A19aAFELtyFBPkTZG+89uCizMVmMOL0IQ38JsnY2zhnq8Uv/r38/03wGcyquXB1MY81FYNzYeCBI3YMbBayqmKKVFRQRYhxDh+tgTLvQQPsF12m6Rn3JvGJGLoH15K+cqaiJoaH90lqTh7t26qw6HrmJrpgHvdYHIUGl7QNOl8XXqGGg2Oh6Nnxw6x3k3w+5eyuN1c/vJb/UAQpWkFSyQNosAZ1drEJcL79PAu8sEYY7b/Ed6fSOpAYRE8fHjbBox2Pyp1OU5o4T/HpkMkt+4i/sJ1cocNxZ+slguBp7JuM11jrDGz3vEhqhtbPmwjIAuf/0PdvJMcUJFMDOFELqLl8XM+p5CdOkEoQalCvfd0JLoOgz2ujfSHUgrIc8jybC11aGfpsBwP6R5u6iFOY2Yuqcga+GjBUg1vxL39kge7Of6LGua7O/+pDXkZ6ILSLWHViD/KLR6Ik40Tc3a1ysXf6WVmVQ4rRgRHgCGra4NtHECQsrPuplV+yhkLoO2qkJ+CSdHzqWAiwGvDWd+RQShD75do1fFSzD8fQ23xpu6lw7tfuYxbHWh+DNTbBAXPoHm/y5ukzmruzyreMjyVO56DbmEqnH2ZzgwjF8csB+uOS+73wxkjKdzt62H3FPD3NFt6EpQ/jJv4j9ME4vKQ0moRrU/vXrehc1F9o8PsmmlcKonhqwKS3hTZ6re/FgY8M6BrUfQipngFmgJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(38070700005)(86362001)(71200400001)(91956017)(66556008)(6486002)(122000001)(76116006)(966005)(4326008)(66476007)(41300700001)(66946007)(66446008)(110136005)(8676002)(478600001)(316002)(64756008)(38100700002)(2616005)(83380400001)(6512007)(186003)(6506007)(2906002)(5660300002)(53546011)(36756003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckVPOElxUVQ1S0tISVAza0FDeExOQU5FdGJXQklYVG9EWk1KblAzSWJ3djNs?=
 =?utf-8?B?eUxNQkI1QVlESm1jeVhtbytldFIxclB2SXM0Rk5sbnJVRWRMamttaVpjUkdq?=
 =?utf-8?B?TzM3dU1SRm5OMEROWmFudDJSQ1E4Y2V6eGphODVzcHZ2Q005L3dSTXRZeUcz?=
 =?utf-8?B?R1gxaVRndS9hZGJzdDg0OEF2aE9aOGN2d0JSUG1mVndjS2pQeHF6ZWxoZkpH?=
 =?utf-8?B?TzdKUE8yak9zNnB3dVhtQi9RZmQyUndpeE1QaHYrRkovNHp4NzAzOWtnTjNJ?=
 =?utf-8?B?amFhaFlYd09Nd3RzaFJ2QXJoV0VKUCtzWXFEVHNCa2FKc1M5SkRkS1RmUWM5?=
 =?utf-8?B?Q2pyQzRsQVdQMzh0RmttN0s2SmZwSHBLTk85TmludlhDeXBGQy84R2NPRjZt?=
 =?utf-8?B?VllIQWw2U2p4ZHN1NzNFdEVySC8zK3RkOWl2UmxQUm9iS0l1S2d3ZFk1azRp?=
 =?utf-8?B?SUVQcUtrbWxwNVZpR3ZUV0RWYzlQQkNEdmtndSt0VmNqdFMreU5aZStGcDZl?=
 =?utf-8?B?SWM4emM5ME5PM0FjcXRUVllkN3dYYXgvaFVUUUtUQ1VpdkQ4akZMUE1uN0NZ?=
 =?utf-8?B?OUdseWVndVlmZ0Z1a0d2dld3aE9GOFNWbVJxNUJJaEZCMDNMc2FwYkhjM08z?=
 =?utf-8?B?ZlZEUFlTZk84YW10Mlg0dnNsRFkxNGtDZjZ3MTkrcEpmekFWSk9qQmtHSWE0?=
 =?utf-8?B?QXk4U1loUUEyNWZqaUR4dEc5NXB5T2dtL2hGSm1vUXpKbU8xNk0ySC91TUdG?=
 =?utf-8?B?L2IxWGxhVkhIN3ErK09OQVV5WTdEU0dYbndQZlh1UUtOR1p5RDF2UUIwMFMr?=
 =?utf-8?B?akJ3TlYxZi9ITDU3ZGcwTzFIdGI2REZ3U2V0WWZWUE5DdWFpMHhRUy90Wk9L?=
 =?utf-8?B?TEU1QXVNNXlNOHRDZlhPeng5Q042VEJqcUNwMzVZeEZLMWRaTWYrZVI3dUJa?=
 =?utf-8?B?YWkrN1ZCS3FwM3hCdEoxS0RrczdYZkpYbXY4dTU0R2Z2dHErRUlWbHloU3lt?=
 =?utf-8?B?cnREWEhJcCtjMFRIVURxMGtUOE9wNjF2Ty9XcnVNejRoMm1SN2ROcVBiVHNp?=
 =?utf-8?B?bmV4UWpoNXEwa2VLUWxSd1p0MnVRRkV4MXVJMmIxR05JeWlhVVhQTEY2R09M?=
 =?utf-8?B?eWRtUXlQS1ZLY01kVGJzZnF5WFJ5YXh1TDltVFhVemQrbU1HOVEza3l3VGJ5?=
 =?utf-8?B?NzVaTVBHclk5UFdRS1E2MDRIcW1rMTJJNnFPOHYzd3JOWHlqOFZjcVltaGxJ?=
 =?utf-8?B?cGxKMVozZmpUaU1HNTFNQjZJQThrdVVONTRMZ0xGeENVenphVThGVHV5K016?=
 =?utf-8?B?enpoZ05pN2Z4Zk0xUzJRV01QS1BBeVlEMTFIczhlc1lTZTBVWDZYOXZ2Snhq?=
 =?utf-8?B?Mkx1Q0VCa0tVeUJYTHdYbE5TeTk1TUtBTERzK1NDSmJkUGUvTE95aE9OYy9a?=
 =?utf-8?B?REk0bEZSZ1ZHWmpkY0RGbHY4alh1cVA5SEVNZXFLTTY1K1JRR2FRSE1DMGJY?=
 =?utf-8?B?aEthbjRHaFIzdkZ1SkVDeHR3c0wvVWd2NXg1LzRyVUlXZFRjRnl0ckltTVJ0?=
 =?utf-8?B?dHhReEFvNWRFN3FvN2xiOVg2L3FJQTJBdlNsRlhOYTRmM0VlVVl0Y1VycDNV?=
 =?utf-8?B?U0JlZDdISlg3Z0xrMm1QOVpiUy9mMWF0MEE4TFpUVldrb1JWUXRhM3plQWVz?=
 =?utf-8?B?YzV2amllSjVQcGhRQlFucUtmR3d1bExhRnRHNWhoRmlMdWJRYS9WUzVCeE8r?=
 =?utf-8?B?cW41MkR4YVI2KzBjMm9oa2UxQWNuUVVHSU5YRTQrdEZKRnRHYTNseFA2T0ZW?=
 =?utf-8?B?KzAwSGJHMVhtL2d4R3p5R0dvYUYxcmd0aEU5OGVOQWJMbWszMytIc1ZRK0pD?=
 =?utf-8?B?LzBpSkVTZ0pjWi9Qc3NrdkF2MldONDFITzlSVmxKNGc3TWRJVXVPUjBKR3FN?=
 =?utf-8?B?U0xCcFNPME5IQlpteXlFMytFSnBYQmV4SDN1eDdnaHZhTlpyc1ltUDhVLzRY?=
 =?utf-8?B?aFcxU1NScjAvc29zRFlOYnBROGRNdWRGY0VFQU9DYW8yRlIvQUZGL3g5bURQ?=
 =?utf-8?B?aTFBaXMydzlOdkNzTTlVc3BzYU04TVByMytQN0dNdnJaYmpPUVFUdWVkSW1F?=
 =?utf-8?B?WWxWL1lVM1QxQm9GeVdnbmZvRGdNWkJPVEhvc0pJY3RxTUVFL3dNTEd2Q1h5?=
 =?utf-8?B?QnV1SmFnWHl5WWtQZlJDM3o3clhSSjhzcmFsZE1oTTA0S1VlcGF3NllSbGFN?=
 =?utf-8?B?NlorMmpBcmpWeXc2K2tpZ2JmZmxCVWdvMkRCaXltVGNpR2xWV2RvYzNPRkJv?=
 =?utf-8?B?aTA4Y1ZBeDl3c2xSRjk4UXpWTTdKZGJGeWUxWkhiN2Q4anVRdkpYYkdGSmhI?=
 =?utf-8?Q?lr92Fr0rfklzCfFw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DAB512A8C31DC4E9D485D1C2870272F@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6851b530-71b9-422c-b849-08da53541f38
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 07:03:19.1890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3K9ppacoeDFeHoHpQwDssR0UIKdWsCbwgy9WxlrSLl+Tl9NOsGnFUyCC7oogipiy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2284
X-Proofpoint-ORIG-GUID: 9aeZKUQ07Tn2p30pED2LKpkioTgQEMk2
X-Proofpoint-GUID: 9aeZKUQ07Tn2p30pED2LKpkioTgQEMk2
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_03,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTIxIGF0IDEzOjEwICswODAwLCBIYW8gWHUgd3JvdGU6DQo+IE9uIDYv
MjEvMjIgMDA6MTgsIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gVGFzayB3b3JrIGN1cnJlbnRs
eSB1c2VzIGEgc3BpbiBsb2NrIHRvIGd1YXJkIHRhc2tfbGlzdCBhbmQNCj4gPiB0YXNrX3J1bm5p
bmcuIFNvbWUgdXNlIGNhc2VzIHN1Y2ggYXMgbmV0d29ya2luZyBjYW4gdHJpZ2dlcg0KPiA+IHRh
c2tfd29ya19hZGQNCj4gPiBmcm9tIG11bHRpcGxlIHRocmVhZHMgYWxsIGF0IG9uY2UsIHdoaWNo
IHN1ZmZlcnMgZnJvbSBjb250ZW50aW9uDQo+ID4gaGVyZS4NCj4gPiANCj4gPiBUaGlzIGNhbiBi
ZSBjaGFuZ2VkIHRvIHVzZSBhIGxvY2tsZXNzIGxpc3Qgd2hpY2ggc2VlbXMgdG8gaGF2ZQ0KPiA+
IGJldHRlcg0KPiA+IHBlcmZvcm1hbmNlLiBSdW5uaW5nIHRoZSBtaWNybyBiZW5jaG1hcmsgaW4g
WzFdIEkgc2VlIDIwJQ0KPiA+IGltcHJvdm1lbnQgaW4NCj4gPiBtdWx0aXRocmVhZGVkIHRhc2sg
d29yayBhZGQuIEl0IHJlcXVpcmVkIHJlbW92aW5nIHRoZSBwcmlvcml0eSB0dw0KPiA+IGxpc3QN
Cj4gPiBvcHRpbWlzYXRpb24sIGhvd2V2ZXIgaXQgaXNuJ3QgY2xlYXIgaG93IGltcG9ydGFudCB0
aGF0DQo+ID4gb3B0aW1pc2F0aW9uIGlzLg0KPiA+IEFkZGl0aW9uYWxseSBpdCBoYXMgZmFpcmx5
IGVhc3kgdG8gYnJlYWsgc2VtYW50aWNzLg0KPiA+IA0KPiA+IFBhdGNoIDEtMiByZW1vdmUgdGhl
IHByaW9yaXR5IHR3IGxpc3Qgb3B0aW1pc2F0aW9uDQo+ID4gUGF0Y2ggMy01IGFkZCBsb2NrbGVz
cyBsaXN0cyBmb3IgdGFzayB3b3JrDQo+ID4gUGF0Y2ggNiBmaXhlcyBhIGJ1ZyBJIG5vdGljZWQg
aW4gaW9fdXJpbmcgZXZlbnQgdHJhY2luZw0KPiA+IFBhdGNoIDctOCBhZGRzIHRyYWNpbmcgZm9y
IHRhc2tfd29ya19ydW4NCj4gPiANCj4gDQo+IENvbXBhcmVkIHRvIHRoZSBzcGlubG9jayBvdmVy
aGVhZCwgdGhlIHByaW8gdGFzayBsaXN0IG9wdGltaXphdGlvbiBpcw0KPiBkZWZpbml0ZWx5IHVu
aW1wb3J0YW50LCBzbyBJIGFncmVlIHdpdGggcmVtb3ZpbmcgaXQgaGVyZS4NCj4gUmVwbGFjZSB0
aGUgdGFzayBsaXN0IHdpdGggbGxpc3kgd2FzIHNvbWV0aGluZyBJIGNvbnNpZGVyZWQgYnV0IEkN
Cj4gZ2F2ZQ0KPiBpdCB1cCBzaW5jZSBpdCBjaGFuZ2VzIHRoZSBsaXN0IHRvIGEgc3RhY2sgd2hp
Y2ggbWVhbnMgd2UgaGF2ZSB0bw0KPiBoYW5kbGUNCj4gdGhlIHRhc2tzIGluIGEgcmV2ZXJzZSBv
cmRlci4gVGhpcyBtYXkgYWZmZWN0IHRoZSBsYXRlbmN5LCBkbyB5b3UNCj4gaGF2ZQ0KPiBzb21l
IG51bWJlcnMgZm9yIGl0LCBsaWtlIGF2ZyBhbmQgOTklIDk1JSBsYXQ/DQo+IA0KDQpEbyB5b3Ug
aGF2ZSBhbiBpZGVhIGZvciBob3cgdG8gdGVzdCB0aGF0PyBJIHVzZWQgYSBtaWNyb2JlbmNobWFy
ayBhcw0Kd2VsbCBhcyBhIG5ldHdvcmsgYmVuY2htYXJrIFsxXSB0byB2ZXJpZnkgdGhhdCBvdmVy
YWxsIHRocm91Z2hwdXQgaXMNCmhpZ2hlci4gVFcgbGF0ZW5jeSBzb3VuZHMgYSBsb3QgbW9yZSBj
b21wbGljYXRlZCB0byBtZWFzdXJlIGFzIGl0J3MNCmRpZmZpY3VsdCB0byB0cmlnZ2VyIGFjY3Vy
YXRlbHkuDQoNCk15IGZlZWxpbmcgaXMgdGhhdCB3aXRoIHJlYXNvbmFibGUgYmF0Y2hpbmcgKHNh
eSA4LTE2IGl0ZW1zKSB0aGUNCmxhdGVuY3kgd2lsbCBiZSBsb3cgYXMgVFcgaXMgZ2VuZXJhbGx5
IHZlcnkgcXVpY2ssIGJ1dCBpZiB5b3UgaGF2ZSBhbg0KaWRlYSBmb3IgYmVuY2htYXJraW5nIEkg
Y2FuIHRha2UgYSBsb29rDQoNClsxXTogaHR0cHM6Ly9naXRodWIuY29tL0R5bGFuWkEvbmV0YmVu
Y2gNCg==
