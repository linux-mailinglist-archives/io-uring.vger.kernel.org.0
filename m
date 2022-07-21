Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B7D57C988
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 13:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiGULGj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 07:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiGULGi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 07:06:38 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EAA82FB9;
        Thu, 21 Jul 2022 04:06:37 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KNbFvF011311;
        Thu, 21 Jul 2022 04:06:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jXLR63N5kKHyKvwUR670khzRcYB7acyPvfVekzFeSJ4=;
 b=TCqznL5wl0J7MIlyWwRHJvAQ/6TFNO732mzGLY3CK2lfFk3r9Vu3U8lZbPZXJIyJwanq
 FIBmPQddyemuBSrXDyImkqXoTlxPfb1xBniMuiSeNjAhRmhAzgYz3fEkPxhuewVekWFI
 8e7iVI34bRL/+gjy55iy2dFO2i9VvoeVCAM= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3he82dsba3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 04:06:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXys17kSJrKEaCJK5rs+FdIgbr7KHiw6PENBGLbguivOyukRAAQi/C8mY4GfcVe+A1Zil4Nyq5sih40zfEypysxiJ91LY0wB8moeAPFPFPDAL6OytjXlWLa4FLmgzA7VUptPr+axApYSlHdv7kCwIvnCpBP9J1Fc++sOTm+eB2hJOpc0l25LwCL9Af538t8KvOm/QS2GbZ9Wk/4odSxXCCKBKnF5WBIaWNEwfKrp1woM7j706kQR8rEt3U2WDTL2mLFXGf3socEEe376MhNGzHSYDejKHE4xdCQVeIlokh9bBGtKh8Os+NuEHr9RG7u2kMV4Wyta1H9AkHZG7SKI/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXLR63N5kKHyKvwUR670khzRcYB7acyPvfVekzFeSJ4=;
 b=AKXq3RIOBzW0zJ0xi0S1u5VtTlLw6YPeWS8qroPN9gigfg5DHud8y666Zm6/yK2ZMHUsfMJU5HKpo7zgT24en8hvm68s7zAYk1Q2pk5IihraNaFV/SDSKLaj219wu8+ZfoB3Zz2OwFz+ewzRXhM7PQDXpNiszPGeOqf+Yk9eSV5apA8a0Vpk1dUpotGDySEvWipTrsg+GhFxxvf8r5NJkuKWvxN4o01SwJET7+wnenX6lXsuhi1rhoDOwIlfXWO6pwwnNwb9DPPM4EmB0EsLmjRr2PNiBLsyN9qoUzevD87/rmeIv1+sU5azyDPAZtl+jaApfcdHOWa4m3owQztzBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN8PR15MB3217.namprd15.prod.outlook.com (2603:10b6:408:aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 11:06:33 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 11:06:33 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mail.dipanjan.das@gmail.com" <mail.dipanjan.das@gmail.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     "fleischermarius@googlemail.com" <fleischermarius@googlemail.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "its.priyanka.bose@gmail.com" <its.priyanka.bose@gmail.com>
Subject: Re: KASAN: use-after-free Read in __io_remove_buffers
Thread-Topic: KASAN: use-after-free Read in __io_remove_buffers
Thread-Index: AQHYnKMMh/zxMjVYwUGeiFeZyBTdAK2IqpmA
Date:   Thu, 21 Jul 2022 11:06:33 +0000
Message-ID: <e21e651299a4230b965cf79d4ae9efd1bc307491.camel@fb.com>
References: <CANX2M5YiZBXU3L6iwnaLs-HHJXRvrxM8mhPDiMDF9Y9sAvOHUA@mail.gmail.com>
In-Reply-To: <CANX2M5YiZBXU3L6iwnaLs-HHJXRvrxM8mhPDiMDF9Y9sAvOHUA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1edef618-bb56-48fb-0986-08da6b0912a2
x-ms-traffictypediagnostic: BN8PR15MB3217:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eyTIrJ05Udt4Cj5DVclPscLsaXyFxlEu3y1TYKtJUO5kof/af927suAYqJK2uLgeS9FsO26nsqer94EWvJZLgHsU49wOb+PA1IUv61pJrvRqvz2g2pm5DqMRGHZ2Na4Jji3c6htvnKvV31Hs4BriUYdq0S8q9kVMMfdB+l9CQRNdodigj/f3yfi1caqvz+D/mhGJGs4D07uRYCmI1xk4C2jRXpJ9YBBId6d1DlrHgedbPOLxtFvH2XaTMZ0uKAKzqa7tEVA7SBegCQ176PuNQn4y1CU5UpO4jf1115VGweP1gOKY7xZjjqb3iLx0l8K/mfq1ZiZmraj5GNuOSGsLfIusUXFxmK8Ui8NR79PVtFspchS6ADWqy6lKNvqp5h5gPkXg7JmHmy6TuWAF4wedcLCy6PA4o2+qTbEfsRvapPNpFfsMOZ38SLom41OQZ+D/VRE7ZZolB9jl4hwKGjDZ8+MqjxF9uAx1SxNTqVB19kO6Va0C4ymqwelI35EykGWOamVVE9GVRvmej5efoJcpCyaZrKQz7nrvy6RLYl6Nu5+1bniYV/RZNk9VAL23a4uIx0Stk0ombFlG7J82kfRWybSMErzUKdpbksl7VaOjFcp7Ll2YVc9UbxoLZZM/d1RCLRyeD+xt1zPluwq4Tzv2hNgcdcnE5uHfQu7AhbFI5GLV65g4EGHjNSmHTjJGhEG5tvZo3sqgUsPXv95+fbSDUv/bQYfGLbi46w75KS5w4OHa7dPoG97H3cEjm+zfFjLEnGrl4LyKWoBsTxGLbS883hNM3yq5lJOn4pDRGxaIbWAM20pKtc9T2Q/bl7H8kGlH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(6506007)(6512007)(2616005)(186003)(5660300002)(4744005)(2906002)(478600001)(6486002)(36756003)(54906003)(41300700001)(71200400001)(316002)(110136005)(122000001)(86362001)(8936002)(66946007)(66556008)(66476007)(91956017)(76116006)(4326008)(38100700002)(8676002)(66446008)(64756008)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmUyWUNTakRPcDI5cGo2Vzk4MmR0ZlJNSlVaYmVEYzE2a29JeVBrMTdkQWgw?=
 =?utf-8?B?TVlvaWdkVWI0NFNKVnZraHFmNTlEa3FyRzd6RGQ2TktKNFlTQmxtWWR1QVU1?=
 =?utf-8?B?VVJ1T2dxTGd1T1kzRHppd0VROUpQVlRMZmpmVzFLVDIxTFV5S3lCTFNaYmRE?=
 =?utf-8?B?Vm5DRFdKT2MwK3FKZkQvSGV0T3FWUlFDZm8xM1Q3dEtiZjlxbnF2Nzc2VUxG?=
 =?utf-8?B?dHQyZlNxRkRvVGhUNG9qRHlnS3p6dkZ0UHJtVkU0blVqNDIzeFUvemt5dFhG?=
 =?utf-8?B?RXFGang0dzhCc2hTWGtGbGUvRVRZOFFGQ0dtakJmdUZZRVFMNUpmd2NHait5?=
 =?utf-8?B?TjRNaEJTbUJ0ZTl0WGNFVDBldk4rL2o4b1JGeTNDMUNnQXhVbnBtdEJJeWd6?=
 =?utf-8?B?aktaVlJsdW0wN0tCV20zUlR4WkU2RFU0VDZ2d0Nnb1pTZ05vOCtRdU1KZ2d6?=
 =?utf-8?B?WG4xRHpZMEV6QVlZRDd0ZFNDckh6K09CZ1VZVWppZFVyQkRZN0xjWFltRFc2?=
 =?utf-8?B?RmR5Y2RNMXlZSXI4cWhJbEhsNlRHd0hyU3BWTHpRZ1NuMkMzTCtkdUxFaHh1?=
 =?utf-8?B?NnN6Sy9lWHVjbVRmU1NPVktiZEZaOGJOTkZmSnFINFBqSkFYbEF4UHNLVkRy?=
 =?utf-8?B?bTF6TXFPSDJZWXVhelBOalBnTVNRd09ibE85bmxBRTc2Rlp2RWJRekZYYXg2?=
 =?utf-8?B?dVNGYkRWb043dDFvU29rb0dqVGVtaEhENUpacjc2aStYU2xPeDcxM3VzSTFs?=
 =?utf-8?B?ZE9SSC9acmFndnpubm9haHJaQkxZbFlGSTRvU1haU0VEOE1sRVUveHZ3QlFG?=
 =?utf-8?B?b1NOVTI4dXRiV05qYit1TmIrajV3NjZLOXdRYm5UUW82U3lEaGRVd0NzMG0z?=
 =?utf-8?B?VGFkMnBQc3Rnc3p4UG9zWkNld2VWak1Uc0daQXZQWFl3cW93Qk42SjdGTFY2?=
 =?utf-8?B?c3ZrMHgxT1BRZm5vOU9lZFlsbVdaSEg2cTZVWVYrbmFzYnhRbEJITmoyU0hF?=
 =?utf-8?B?aTcwRlFjMDA5d3ZlTjhQQ0JlTllUY0FYcXRzT0FzNXgzN0FlSm9hZDlla3RR?=
 =?utf-8?B?M25LQWg3SWZsUkVBdmF3SEVkTENlZzJkUHNhSS9oRll3bm10Y2UxRFhrblNj?=
 =?utf-8?B?a00reGdxeHlBYm13U1FnazdLSlo5Z1g2QkxPZFlsTFdiYjNwZC8zMlMwQmdS?=
 =?utf-8?B?dW9jb2dGRjZJRmtaZWFOaExJeG9WSnpvaWdrYjY3YzRaMlJDbE8yNkxmQVN4?=
 =?utf-8?B?OUZaSVNod3ZiWHI5czMvTnlubEszcnBLd0lPZnoxaVdsdnZ3YnlteTkrNW9a?=
 =?utf-8?B?UjRGRjAxdVB2NEV0VXQ0MC9laitPODZzc2x5NENHT2xyK2NZM3EvTWpBbTVj?=
 =?utf-8?B?cnlYK3V1dXlzcjZwYm05aUpvWm14OW84SXNzOXV4WlVYRzVXODAzNktKZ1d2?=
 =?utf-8?B?WkJUd25MTk9JaHgzTk9CeWE2bHNVc2Nua3Z1SXdDam84aTV6a2x3NFNzN2t1?=
 =?utf-8?B?OVluWVp3YUtxbjZaUml1SG5BajNSUGh0M29uYmhSOTNiUEcyMVdCajI1bFow?=
 =?utf-8?B?cENZRVZJY1QzYk03RFo2YkVEelo0bkluaitINUdlenI0TzdtaUZ2andFSjlk?=
 =?utf-8?B?a05PSnVFb3IrN281Nmh5OXNKRmRaZFg3SzVrL3NtWDhzZWlLbGVwdEQva1ZF?=
 =?utf-8?B?d1JxT1d1SDhhU2tSZ3FNQ0dabkw1bW9pQ0tlSmZNOHEvaGFhOUhuVDc5R2hl?=
 =?utf-8?B?R01Kam9qT2c4aElnTUo0c2hMeHppK1pFckNmbStJUkRxVnF3RHJZNWxLU3Jq?=
 =?utf-8?B?U2IvZmlrYzdVYkNFQTlmZkx0VzUzY0ZjMUR6dWJlWStnbGRaRHBHb2p3SWdE?=
 =?utf-8?B?LzRLT2VjQkcvWXI1djBTQi9tajRwbnFXN0NMRDBKeVNjRWdVMnFQYnBMeGVR?=
 =?utf-8?B?b3VxZFlMd0xMdnN6eS9Cd09McmxYU0xSandaMmx0aTAyK3ZMTjY5S2dTM1Jp?=
 =?utf-8?B?M292cytxSVQ1bFh4RGt2M09Jc0hLL1lvVjNjSUltUjRuNEJ0Y2xQdmNrMTZY?=
 =?utf-8?B?bmRNNXlKZUU2bkRVMktTVWppcS9iZis1OG9GYys4RGtDZGtjWFRmZVJUMDBz?=
 =?utf-8?B?czlpelQxOGNOMUF1MEN4VHh0aDR3c0RySFZiUDFvUXRiS0pNMzU5ZGFEcVFP?=
 =?utf-8?B?VkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FBC177D6A2A7F4082BCA04B845F3CC9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edef618-bb56-48fb-0986-08da6b0912a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 11:06:33.7363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vn3lqVUnyz/TGOMobdZwsDAhtdIiA7cDSfEWwBxOBWcULBrQ797snBhlIDpL8vgg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3217
X-Proofpoint-ORIG-GUID: 7wJssg5RaFi8bMw9ceTypNwE9OPsvd-4
X-Proofpoint-GUID: 7wJssg5RaFi8bMw9ceTypNwE9OPsvd-4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_14,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTA3LTIwIGF0IDE4OjQxIC0wNzAwLCBEaXBhbmphbiBEYXMgd3JvdGU6DQo+
IEhpLA0KPiANCj4gV2Ugd291bGQgbGlrZSB0byByZXBvcnQgdGhlIGZvbGxvd2luZyBidWcgd2hp
Y2ggaGFzIGJlZW4gZm91bmQgYnkgb3VyDQo+IG1vZGlmaWVkIHZlcnNpb24gb2Ygc3l6a2FsbGVy
Lg0KDQpIaSwNCg0KQm90aCBvZiB0aGUgYnVnIHJlcG9ydHMgeW91IHNlbnQgc2VlbSB0byBiZSBm
aXhlZCBieSB0aGUgcGF0Y2ggSSBqdXN0DQpzZW50Lg0KDQpUaGlzIG9uZSBob3dldmVyIGRvZXMg
bm90IHNlZW0gdG8gdGVybWluYXRlIG9uY2UgZml4ZWQuIElzIHRoZXJlIGFuDQpleHBlY3RlZCBy
dW4gdGltZT8NCg0KVGhhbmtzIQ0K
