Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CB55AD5A1
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbiIEPAK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 11:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238362AbiIEPAJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 11:00:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7AD62CF
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 08:00:07 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 285D6PDb011639
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 08:00:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gbdBZcnm0fu0oHWpbhJKsWTvKgZjxoZswRAw+yfsJnA=;
 b=F3HOyK1rsUpxKJqTbO8o6nWZGeFoCGcYJuyqmy8vJR88bTqDZIr/cDRVgVkGuRg9d1js
 D9FIpT0THkVo6Vl+FMTl5mxkCK5oGxzTQ9UYhgVtEPRRota29ySEgob7MazsMR1uo4dv
 vahnMl2eS82kX/QFt+Bkf/1gQj1Iis+Zvos= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jc41th527-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 08:00:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PW7iPOZ37Dmni6FIMZVD+YBawIbChMA93+ylbN3SJ2/8w8B4+nadWdTzDYEIDPiegYplIlxQfeeLsNla483XoDlaP2GKh4pihnCimLWvjWehbikFrZgfg9KHHPqYg+PPNf1BWXVoS47+Vj4ZBKByEhYyTPNye5dUpX2JiHgd34YDBswS/0BedNhRZbYc7QPKc0TlJIZ6ZayfoyfVcbiLNmItGsTfEjb3d0hicY6Vf/TAqYWNbVxtOeilLtqtbo9HkbwyKiw3OtutRlt5xsqbSsxhxTuc0PToeaZu//VyLHzjcx7VHWYxqdCv3WELzZqXR2e6XHBllptIR7IElrfc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbdBZcnm0fu0oHWpbhJKsWTvKgZjxoZswRAw+yfsJnA=;
 b=L/b42cyWPqSbTr9+vonJedD4xvDf8V/fBRAa0XMw2cZkLcikL6izkpAAfCaKjsPuMTmj2PJuDy9cecuZdJnsRUC9UVf4LerGL4fj9rFP/qZfQl8cg4H9KhnNJUJvrfNQg1qrzuyLmhHNtLeoRbuyVHJcQSkGUL6Fh4sLs80QbK+IcVI7oq/MZ0gZ9kW5Zqlfl59+lvHXpuCEKxg1JBNSowNP4litsh0nldGwnhmzxqVhKcdb2VQrj9EExZYe0chYupRR2nP6d4vBzW7B98Y9TiRYdaTLBs294GIOPXRV+A7zwjGQ//XWC9yXrseqAoAy6HQAS+A9lK8jMnagEWg8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN6PR15MB1252.namprd15.prod.outlook.com (2603:10b6:404:ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 15:00:05 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%5]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 15:00:05 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH liburing 4/4] tests/zc: name buffer flavours
Thread-Topic: [PATCH liburing 4/4] tests/zc: name buffer flavours
Thread-Index: AQHYwTMZxYsZ6xWGsUaIBLBzAOHA2a3Q7fSA
Date:   Mon, 5 Sep 2022 15:00:05 +0000
Message-ID: <87e297ef0a2bef869c890bda92c0a07fee171f43.camel@fb.com>
References: <cover.1662387423.git.asml.silence@gmail.com>
         <f4ceecede6399ba722c8e73312e0e0755f53a8a6.1662387423.git.asml.silence@gmail.com>
In-Reply-To: <f4ceecede6399ba722c8e73312e0e0755f53a8a6.1662387423.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2daaa4dc-6149-4235-5141-08da8f4f5114
x-ms-traffictypediagnostic: BN6PR15MB1252:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8sGp6YkLFg3Bp5cYq9fq7mqrNKUJBnC2sDf7Ayr4rvBpzGptByEFa0WLSZ2o8w2hGMrwG8WXpde+Vl22jdu0Gas97dkoGVmf1zyA1ByHWsAtA/2Gq/lZBaXXgez4Mxt0/nQwQoJn1+VppseMoSsV1le2e3bBxq6p9CRVw0xhNz6YRwiNQihn27Ni3CJwj2N+lZVlAkGg1s6qshJfTI9bwbCz1rGcAR6IW7wRWJKriaOe8ik4p2pFf3O2RAa/M4ANZnoyYFWpK8NDCPrD2wGn0vjcCnILkOUWI4ceWZJzUPQDplMxKqkGedSSl1g4XFipgXgOifxu7qIuEwuUuXB9Qp4pksNHlrZSOKw+KmcfCCTLBQvR+VX1WDbz3Xo45Br4olw4h4LAINkdX/naNDMzH2+uNfTytpVaBOyR9ZqPOa+mEPfjorkkygVWPWpPKsT48LKP6WkeKlNFNXTYzNBKp2uPUThPY0X5u6n9AqMfSNr1emqDmpiETaQ8xnW2b30HSed22oe2u3ybxRHYDBYQ/gJuof0HjdE6Hv6YQcg4o+53paz5EKoBcEm63yPoE24IDXBifDPGa6ben5pHbn5r7rEkUHGfo+tDntXC/tq63gUJAGa58LHeoxhwM9e+yjfDwb8bLt8zEl6pgOdlrl5QM5jzexovr3qgwQIZUsP52tu7+SAXzp+rKJeoZs4m4AHEVTpOwDMYLGEqTKW5SiuzvTrD511ank8OSM8dbI2My1FcpC1np509khqnnU2h6oLB54JaTxYFYsh54NO5PlhvnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(2906002)(36756003)(38070700005)(83380400001)(186003)(2616005)(8676002)(66476007)(66946007)(66446008)(91956017)(64756008)(66556008)(76116006)(5660300002)(8936002)(4326008)(4744005)(110136005)(316002)(71200400001)(6512007)(41300700001)(6486002)(6506007)(478600001)(122000001)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3dRSVlza2pnMzNlSUxETmRBbmsvTGVpcGYyUkdxcDB1bDQvNHBFb2tmUEUr?=
 =?utf-8?B?TERxY0p3Qi85c1hEV01BVFl3TUd4THZwRHYxdy95TjFLYnZ5VjZTeUV3bzBU?=
 =?utf-8?B?THgydnFVSk5VR1hScWpIbHdPd1VhOFhtdjdTSFpkSTYvSWlTVlpUSUk2TXBo?=
 =?utf-8?B?cjBFamN6alVWMXprM3cydVdpamR4M25nNGxjc1ZhYVh5WDE0Y3BkTjU3dXov?=
 =?utf-8?B?ZFpxcDVQeklrRC9iRzBDN2VwN3BadmxpRVRzWlhvLzU1VnIxRTN3RGpTWEpM?=
 =?utf-8?B?STg0ay9OWDR5WGl3VVpNYW9tWEhVNTJlUDdNTEFKRFdSV0JQcnpKZk5wM2RV?=
 =?utf-8?B?Wm5ub2FycnE3emdGRkZuTzVjVHczQ2oweVI3U3I1WlZyRUNNYTVrTnJwa3Rm?=
 =?utf-8?B?ZTNhRDlVdVd3cEN1djVWZ3JvSm9WMHZjVUptRTBWM20zYTQ5NnFpWDhWcEhZ?=
 =?utf-8?B?dUhONDFmM0I5WmxYeGRsMGpseE5HVjdlWURnaElVampCYzB0SStaOGQvckxY?=
 =?utf-8?B?a2FQb2RqcFNudEt3eHVtS0RFSmNmRVZRcGdLQktPZXFYTzcxdE5nWXFpVitw?=
 =?utf-8?B?TXV1QWJQRUdnMWwxTXZRc09QQUlMdFd3ZkRnZ29EQ3FhbzlJZndZVklJNlcv?=
 =?utf-8?B?cGdlcDhYd3N2bGxRVWRGYjhPNW5PL1FMSVlqZlMzU1FqN1A2MnhhQW9keWNT?=
 =?utf-8?B?R1RSc0xHTnlNWnFpNnFEaVE4R0FKUldGVjFxWVdmcVNDbmhheG5QVWM5RzMr?=
 =?utf-8?B?RXd5OENqYlFHcW11RjBaLzkyaEJFQ292NVdOcWFwZ1A4eXEyVDRJaWFrU2px?=
 =?utf-8?B?dW1pRzRycURWcy9FUjhOSDRxVlc3YXpFanNWb0ZzVEltdXlIc2J1eG5Zdk5R?=
 =?utf-8?B?azdpb2cyWmhkL2ptR2ltdkxSYVdxYnlHZkg5bk9xbFJpZUVSZFFJbkwzWWM2?=
 =?utf-8?B?ZnNaTGhkWUpCUktxazgzMmdWam1tamhWQjlPWkltcGNZcEN3R1dZdExLUzVr?=
 =?utf-8?B?RHhHaGpsUWpNN1BmTmJYbkZQaHhaRkdLMDJLRHJQRzNpTEFmQmhuaUlwaXJv?=
 =?utf-8?B?ZzZFWGFCNzBxK1NpRVFwdlFmWW5DbnpiMWFrVjMzR1RGYzVENldMTkdDNlND?=
 =?utf-8?B?bDlhTGQ0NnpScGRNY1RIeUo3L0thQVNiSWl4dGc5TGo2bjc5TVMycksyMlJO?=
 =?utf-8?B?YXlFVXRnZXY0KzdxQlJYN09RN1ZBL096NWNSYVMramxNa2gra2NqdXljTzNW?=
 =?utf-8?B?VC9jbDQ3eGZhTTVXbmVIcmJnS1Bna3FvalJmbjhndnA3QU4wQnNKTXBvRmla?=
 =?utf-8?B?Zkc0MTh1UXpSMUFiZVFjd0FLNmRTK3V2dUo3OG1mNjR4V3BOMEdEZFJJNHh5?=
 =?utf-8?B?WkVqbi9KaGp5SmpjY1NkMEoxN3huWjY5SjM0bkFrUHQ4S2M5UVZHQjhvM29S?=
 =?utf-8?B?VGZjSGFsOW52dnhRWlE2end2U1RVTlA5dGJweHZIdnd1TzUrdmxBUjVZeDlv?=
 =?utf-8?B?U3hqVjUzZmRXUFM0Z3VKQ1VrZDhjbE5CVDA2Sm9XUllVUjZWc2tnTmNTVDNN?=
 =?utf-8?B?dmp6N1lZSElPOVl5SWhZV2xaa2tkWGdMSHltVXA1UUJIYWlieFd6NkdJSzUy?=
 =?utf-8?B?UDAwMklORzJvdzBLMmw4RGRNUVpkVy8xdFVGU1FoODIwR3BSZGJnUDBaRVBk?=
 =?utf-8?B?a2h6VHo2VDJCOFNpWVdIcVFtREhTbjBaRjFtSkwydjFIREJOaEZPUFJVY0dJ?=
 =?utf-8?B?ampIYXlNQzgrQ0grVTFBdnZBTUFUMGY5a24vTkR3Sm53U0RDbnlsMkw1YXpq?=
 =?utf-8?B?cm5nc0FuQ3dHZDhWR0RDK0RWQzQvNm9nVHA5U296c2dab3h5aFRmMFhiNU9k?=
 =?utf-8?B?OXdkZVFTSzRDeUl4QW9iVWZuOEw3T3FWK0tjdm01N2U3Q2FTZXc4M1VTaVFt?=
 =?utf-8?B?RXN0R2pmSlVvb3pqY0xub3ZEbkY5b0tzQ21xSDFiRzNIdWRTL3JnTXM4QVhH?=
 =?utf-8?B?Z2ppQ0RqaDMrRHFHeGptdlQxMVZ3L3AxSVd5dVZySHE3NVozcGljQlZSOUI3?=
 =?utf-8?B?U1NCWkF2U1I5b1YwUG9hMmhRTnBLZ1A5N1EySldvQXB0azV4UE9NTTNZTDNq?=
 =?utf-8?B?d2xYTmVaaDdzcjBTY0NZQ0FRdjF1NGFoaHJOYjZ6ekQvWGptNUlXcWd2ZVVK?=
 =?utf-8?B?bFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AF66589031D17408F5605EC05B1B627@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2daaa4dc-6149-4235-5141-08da8f4f5114
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 15:00:05.1508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RAcjqOmedajS4ZZIWAAolI5PhQ82877QMVgyse+rQLjFAFxVfT4UBs1KyXsnttKl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1252
X-Proofpoint-GUID: 2kp6ofeMOojBnl8Sv_4UxJoTw8G2uexF
X-Proofpoint-ORIG-GUID: 2kp6ofeMOojBnl8Sv_4UxJoTw8G2uexF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA5LTA1IGF0IDE1OjIxICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gUmVtb3ZlIGR1cGxpY2F0aW5nIHRlc3RzIGFuZCBwYXNzIGEgYnVmIGluZGV4IGluc3RlYWQg
b2YgZG96ZW5zIG9mDQo+IGZsYWdzIHRvIHNwZWNpZnkgdGhlIGJ1ZmZlciB3ZSB3YW50IHRvIHVz
ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21h
aWwuY29tPg0KPiAtLS0NCj4gwqB0ZXN0L3NlbmQtemVyb2NvcHkuYyB8IDYwICsrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAtLQ0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCAzMiBpbnNlcnRpb25zKCspLCAyOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90
ZXN0L3NlbmQtemVyb2NvcHkuYyBiL3Rlc3Qvc2VuZC16ZXJvY29weS5jDQo+IGluZGV4IGJmZTRj
ZjcuLjJlZmJjZjkgMTAwNjQ0DQo+IC0tLSBhL3Rlc3Qvc2VuZC16ZXJvY29weS5jDQo+ICsrKyBi
L3Rlc3Qvc2VuZC16ZXJvY29weS5jDQo+IEBAIC01MSw4ICs1MSwxNiBAQA0KPiDCoMKgwqDCoMKg
wqDCoMKgI2RlZmluZSBBUlJBWV9TSVpFKGEpIChzaXplb2YoYSkvc2l6ZW9mKChhKVswXSkpDQo+
IMKgI2VuZGlmDQo+IMKgDQo+ICtlbnVtIHsNCj4gK8KgwqDCoMKgwqDCoMKgQlVGX1RfTk9STUFM
LA0KPiArwqDCoMKgwqDCoMKgwqBCVUZfVF9TTUFMTCwNCj4gK8KgwqDCoMKgwqDCoMKgQlVGX1Rf
Tk9OQUxJR05FRCwNCj4gK8KgwqDCoMKgwqDCoMKgQlVGX1RfTEFSR0UsDQo+ICvCoMKgwqDCoMKg
wqDCoF9fQlVUX1RfTUFYLA0KDQpfX0JVRl9UX01BWD8NCg0KDQo=
