Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035C85B08A0
	for <lists+io-uring@lfdr.de>; Wed,  7 Sep 2022 17:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiIGPcc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 11:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiIGPcb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 11:32:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7288785AA;
        Wed,  7 Sep 2022 08:32:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9Veh29qxKH1GVe97QW0Y799TLudR1DRLiIeUuQfrTvDFuxVZjunbfSOF3FOdH7PVsNAXXdnrT+lgscDgdCxfYzULLHKUMwmk382bxQo0LZGY505PoGJjasJ6zhzQYZf32Bsp8cgD3VE6fU2UNa0vLO11eer/vxYpHp6cICf3DUTZdCRTFtQNLcs7yDzM1YvYCKBdyd+hRYPr/WUuQOdQUglf6Zm8+cW57BE23WlnclTk/xgBaWpFVFthkgvOuKFYYw6nc6UY225JFWR0YhJ3ahY2nbG1FXKjre/a+b4mQAcinYT6zelJ08lIh4QdC1vGY05cHIGow9TLK8uCvc0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Alf+8CZCjhV0HGeGiHV8jpUx5QBaUfpe32VeV4/jCbY=;
 b=i0pygi4R5n1yDdGCTZ9Oy33aI9cqsn3luj1lv3xX4kKB+HQz99cEwDUKjhREYu/kZXACqJw8ZRn3id1+kum/lYNxbvM4+G+7w8Ik6UTig6ul5HwAvwXYmXNvsTLcRmIALpZEbyYvjNi/A4LqsjNBgQI24whb9PGaEfwlHpxoJ7LCj8fgWSJvGqFay1PxSy/vsaEhFNReyJ/RJ76fXRMuUWvJ8rMTuGBOh37Dwa16jejmZ25jUEURxoHMX/MXcZDTLJ+GFlepY8LC73N2hqWIfDYsYHzZ3MBp4Et71jayw5PbtkNB9taTggL0p9axTk9WUSqbbxzsR2Bz3w30yuU6Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Alf+8CZCjhV0HGeGiHV8jpUx5QBaUfpe32VeV4/jCbY=;
 b=f+UG/Ak6zIvbVLlPWpk5/39PrtQ5QgOEa0np6s/96B9KnOxPjkC2qGJkgmFjyVuwbZz8xy9oQ+XT4vOtuXyZYrSOXpn/TgKnzPnW330zPf667+7X8HX5Tt649LQULXXq3xU2P3X+9oWDPUoyNgoATejZ+14nk+i12M8UpsXnnavdtkbDRbKCYBGMxJO8Su0vK7tLpLj/EyPvE7NCp5txap53XvtQ6BNUkgCCKl+BYwNnsBzc5lr/s8V+NDfHK/yM/9PDYhFEARGTPbZ6TXWmW8yZmQacK+Vjlaq2dIlG23zG464JPqJQgPUGa4jtQS80DE0Yacye3K08WlyvbwjJMA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Wed, 7 Sep
 2022 15:32:26 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c04:1bde:6484:efd2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c04:1bde:6484:efd2%4]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 15:32:26 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v5 3/4] block: add helper to map bvec iterator
 for passthrough
Thread-Topic: [PATCH for-next v5 3/4] block: add helper to map bvec iterator
 for passthrough
Thread-Index: AQHYwbsq/Fgbo8VM+Ua6bmFFCF9qW63UGpoA
Date:   Wed, 7 Sep 2022 15:32:26 +0000
Message-ID: <81816f51-e720-4f9c-472f-17882f70b4f9@nvidia.com>
References: <20220906062721.62630-1-joshi.k@samsung.com>
 <CGME20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9@epcas5p1.samsung.com>
 <20220906062721.62630-4-joshi.k@samsung.com>
In-Reply-To: <20220906062721.62630-4-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BL1PR12MB5048:EE_
x-ms-office365-filtering-correlation-id: 021bc937-c7ab-4066-a21a-08da90e62b13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F4TVA6ghF4WMoKrjCR1+RT0y09koo1bMNCxr3Yf6HCnYuIlhLRf8+mcaifWWNnfkjeaWdSoBTlwsruZ6rM755WpqrYyxpILARGcdZ+2fDKLt3zNv7HMBEBbY7ygqOevBJyMwJfTYbytJ7sUZqYwa0FH7guyzQ2xkHLFPJze2ZUsFKzFALoP6xZb5/asJr80i5uVT+KD/CZSp0MnD7W4kz0pGMB7ZMZIOm+pv0d9Gp9n0X5oYr38VeCXxSZPPCFs0tbUY1h/hlh87puAWRvBW7JEgflcoFmi+nyKCeGPg41/1TFi21ve2+2vkcmRa+D2QAaJo/am00GSQZBJpKQMzzKaHQsm5hzMEb46pbw4eR1DMwleRSOclP8Jf5LJaYtcl38MpFgGILD0Y7Kzdrpk9KLake3jpMUvv5gQKCcKVK4BUc5uQK9F+KR0YMaQxbD1UxaooTlp1qQMQ3vwwjEVwBV0YcpJkVNmoWTTrInvFjuziS+xATAhnQ/oCHusENaakvZGG3dBnREzwG2idhx0TD95Wkqo1r3rpV4B/kvK2RQfk4hcf0h87OJlzjzwvaXp5gU/kqkOsElVQTvxSDG5XAofvgMKIv93yqA98IEDxa1MpFyay3JEC7syJ7gWL5x30RKsW6pmVTIIAgozW+EHgxb/eK5uKfYvVGKlVEgRM3vjnf35VnGvbGSSHgM74LCNKkffQR1qY8UqT9zLqRnzMUwQu2ozBh6XTBgwXWHXFkCcAv1fPEi/PwadeMu0rz94TiSKK+HC8R2lddBa6c7FoEp7ALf9EItmtD+qxbHoSoeF4f6u7hbqC8yQcXwmW1tg1YV5KCCQ2vvADGqikaNjWsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(2616005)(53546011)(478600001)(83380400001)(6512007)(8936002)(5660300002)(7416002)(2906002)(86362001)(31696002)(36756003)(31686004)(41300700001)(186003)(71200400001)(6486002)(6506007)(38070700005)(66946007)(91956017)(66476007)(66556008)(8676002)(6916009)(316002)(54906003)(66446008)(76116006)(38100700002)(4326008)(64756008)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnBKNks2VmRNU0hscjY2L1pXSkhSaEh0TnRwaWswOXpvUmo5N1lSbHpiRXZh?=
 =?utf-8?B?eDNDclFhSGJQaWlIWDJ2aUdGRkNCQzRiZk5mbmVwOE1RQ2lCR1ZHVzNpbzRY?=
 =?utf-8?B?NUhpdGZNT0FnU1FBbmJPdS9sSUJFTE1XUE8rc05EVWxMbnp0K2NCNTlBamcv?=
 =?utf-8?B?aVkyQVNhZXFXREdSaU5jdUxBMlpXK08rUmRkN283T295bUlyUU54d08yT0tU?=
 =?utf-8?B?WkFFWnJ6VFpmSk5VMGJTbzc3amVWQmgzWjN4V1NnUFlvZTh5ZGI0d052anFL?=
 =?utf-8?B?ZkN3TlRzTjRHNnhJY0svQ2JZbCtkOVdKbnkvOEJjcUowUVplbzRhenFUd2I0?=
 =?utf-8?B?bjU0bTdVVVM0RkZYWk5PeEZwcjgwTU9uRHZYcjVYQUFHTnNlTWE5czhTd3Rp?=
 =?utf-8?B?Z0VFNW1hb3h1TFYyOTlxOGpiWjJEN0dlb21kUU5sZGw1emVvUFNwaVNUQjdT?=
 =?utf-8?B?eG9MRFFUcGFWVkFNeU9tTTRLWGFUbWpDQlIzMWdFcVVYNHkyNk9QZUZiQmR0?=
 =?utf-8?B?Qm1iOS9HL3FKOGUvVURYM3Rjc0xyQjV2TC9IbHBkVlF1MVIyQWZYelhYMHZu?=
 =?utf-8?B?Q0J0UDJBcFdMSlRKNTcwcVc0TnpRZWdkb0lyMjJVZDdQWHhNVExFSFJwTDkz?=
 =?utf-8?B?a0VrYmE2UlozTTZ3aHV3b0VZR29ESHRwYXZ0a3FlLzJ4VENIVWNUVCtDa2ZV?=
 =?utf-8?B?VzFCVXQ1eVh6MzVnWnRnb2tKRVg1TFY2TmhiWmdaSk15Z1lTcFBTZVd1Zjh3?=
 =?utf-8?B?ZEFIVXIyT3NxRTZRTjFZdStUOFN0cXlHeC83VXRTL0RERnFtMUpkdXZmbXFK?=
 =?utf-8?B?c2lQQlhRRE5SbFZBUG1QS0t0UE42RDN5MExNdDJSWm1XUkxVRHM5ZjFGckxO?=
 =?utf-8?B?eS9IRmZyM0ZHS0JUU2o3b2ZmdXFsY0FPRXFCcXBDS2xyK1hNQ0FsMUE5WlVP?=
 =?utf-8?B?YnpXZHZRdi9zK3dYVC83QTdFdzRRdW5qWHNNd1hnZ1FqUW95ZDBVQU9QL2Fi?=
 =?utf-8?B?U041U3lnWk12WjVXdWdYejduZDdtdkROMWFsSk1rSjVDcmtCRzFHSzFlOWEr?=
 =?utf-8?B?K2VFOVdKWkZNN05XRy9RZzVzMUR1cFY3aEM5OG9DdVc3Z3FXNjZ6QkxJdW9u?=
 =?utf-8?B?NExxNjdEcXkrZitZUjk5TU1OYXNWRHcwL2dIeFRHYmprQ25GNnVadGYrRE5t?=
 =?utf-8?B?ZEFMYm9VODZaeGlSTUtPNStCak5hVG5RSnNHalp1OC8xekl0TUw2ZnJib0pK?=
 =?utf-8?B?QkJxeG5tN0VIUit0RGdNZ0JjSU1kUlcwQm00U1g3WWJnNWNQclluK1JVR0sx?=
 =?utf-8?B?bGVWK3RQMnNDYmd6VDEzcEtYQTRYT2QvMHgrQVI0NVpFRWUzMmV0dmErek5R?=
 =?utf-8?B?WktmUXhpWEtPTm5Xd3FXR1h6Ui9tMFZ5aTMxMFJCWSt4c2dTZ1V2YWdOb1oz?=
 =?utf-8?B?ZWkvbGxnb1I4LzZvZG0zMUpzTmlYSFNPNmEzMlRJMk93ZHZlcDBDdTFaMEYx?=
 =?utf-8?B?V1I3aXRBRzRWRmxrUk9PRTFlODYvS29abGhZUnRnSDZaWDRMdFFHSXJvYjRK?=
 =?utf-8?B?NXFhcFkvaXJxYkFsODRQKy9PeFZtZ1dHTEVNbno5d29UYThsRldZaUxMZ3E4?=
 =?utf-8?B?QlJpblpPS1gvVTY4Szl2UWZyY2dMY3N3eTF2MjB5QmE4THUrVXNGTlNKWi9G?=
 =?utf-8?B?cFVodFRTL2YzZWV6R2FhOVVqcXRWQmIvc3Fpb0c0c0FhcjFyQTRWbjlDbEVG?=
 =?utf-8?B?K2ozZmE2TzRVRVZUV0x4eldidnBBZ0kweGc5TXlkVUtlQUUwUlg1MXMyemY3?=
 =?utf-8?B?eDJFU3dkNzEzalFYQi9LVGRxOWhDdlhXUXJBOWZyNTBhOXJ4azVnMUkvR0pW?=
 =?utf-8?B?R1YrRmphNnJ5VllLVnVweWFIajlsMGNqRVNEbXZ2aEpUSmxlaFlkM1gyZ1ZR?=
 =?utf-8?B?ZnJiWDFuK2l4Wnd3MG5mTmNjOERHdzQ4YVVyVS9lYUV1TlhacUtTRGNabWpV?=
 =?utf-8?B?bTl2ZmlOSVFRSEEvNHdNdGhUZ2hQYVJWRkFQd24rcjMrSVg0Zm90T0ExZm5E?=
 =?utf-8?B?UGRKSzlkOWl0Vy8rQmhaZmZiR1hHb1FMb0VPRGdaYkNNQ1JDYTB0SHBhbTkz?=
 =?utf-8?B?KzYrb25QVHBzZXFGTEJvclA4bnowR2QxUFlPaVNFRkZSa3NrYjZudFQ1M21Z?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AB7B4D7CE6B1B4FB9602A93588AD624@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 021bc937-c7ab-4066-a21a-08da90e62b13
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 15:32:26.5462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cEQpHxvW0qyR4gpdmTHZX5TL7cS55bkOaFuD4+7FzNHCQwMWvbxMcDbCzM3Fn1XPWiq8LfiJm58fsrpkQwKNHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gOS81LzIyIDIzOjI3LCBLYW5jaGFuIEpvc2hpIHdyb3RlOg0KPiBBZGQgYmxrX3JxX21hcF91
c2VyX2J2ZWMgd2hpY2ggbWFwcyB0aGUgYnZlYyBpdGVyYXRvciBpbnRvIGEgYmlvIGFuZA0KPiBw
bGFjZXMgdGhhdCBpbnRvIHRoZSByZXF1ZXN0LiBUaGlzIGhlbHBlciB3aWxsIGJlIHVzZWQgaW4g
bnZtZSBmb3INCj4gdXJpbmctcGFzc3Rocm91Z2ggd2l0aCBmaXhlZC1idWZmZXIuDQo+IFdoaWxl
IGF0IGl0LCBjcmVhdGUgYW5vdGhlciBoZWxwZXIgYmlvX21hcF9nZXQgdG8gcmVkdWNlIHRoZSBj
b2RlDQo+IGR1cGxpY2F0aW9uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2FuY2hhbiBKb3NoaSA8
am9zaGkua0BzYW1zdW5nLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQW51aiBHdXB0YSA8YW51ajIw
LmdAc2Ftc3VuZy5jb20+DQo+IC0tLQ0KPiAgIGJsb2NrL2Jsay1tYXAuYyAgICAgICAgfCA5NCAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4gICBpbmNsdWRlL2xp
bnV4L2Jsay1tcS5oIHwgIDEgKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgODUgaW5zZXJ0aW9ucygr
KSwgMTAgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLW1hcC5jIGIv
YmxvY2svYmxrLW1hcC5jDQo+IGluZGV4IGYzNzY4ODc2ZDYxOC4uZTJmMjY4MTY3MzQyIDEwMDY0
NA0KPiAtLS0gYS9ibG9jay9ibGstbWFwLmMNCj4gKysrIGIvYmxvY2svYmxrLW1hcC5jDQo+IEBA
IC0yNDEsMTcgKzI0MSwxMCBAQCBzdGF0aWMgdm9pZCBiaW9fbWFwX3B1dChzdHJ1Y3QgYmlvICpi
aW8pDQo+ICAgCX0NCj4gICB9DQo+ICAgDQo+IC1zdGF0aWMgaW50IGJpb19tYXBfdXNlcl9pb3Yo
c3RydWN0IHJlcXVlc3QgKnJxLCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIsDQo+ICtzdGF0aWMgc3Ry
dWN0IGJpbyAqYmlvX21hcF9nZXQoc3RydWN0IHJlcXVlc3QgKnJxLCB1bnNpZ25lZCBpbnQgbnJf
dmVjcywNCj4gICAJCWdmcF90IGdmcF9tYXNrKQ0KPiAgIHsNCj4gLQl1bnNpZ25lZCBpbnQgbWF4
X3NlY3RvcnMgPSBxdWV1ZV9tYXhfaHdfc2VjdG9ycyhycS0+cSk7DQo+IC0JdW5zaWduZWQgaW50
IG5yX3ZlY3MgPSBpb3ZfaXRlcl9ucGFnZXMoaXRlciwgQklPX01BWF9WRUNTKTsNCj4gICAJc3Ry
dWN0IGJpbyAqYmlvOw0KPiAtCWludCByZXQ7DQo+IC0JaW50IGo7DQo+IC0NCj4gLQlpZiAoIWlv
dl9pdGVyX2NvdW50KGl0ZXIpKQ0KPiAtCQlyZXR1cm4gLUVJTlZBTDsNCj4gICANCj4gICAJaWYg
KHJxLT5jbWRfZmxhZ3MgJiBSRVFfUE9MTEVEKSB7DQo+ICAgCQlibGtfb3BmX3Qgb3BmID0gcnEt
PmNtZF9mbGFncyB8IFJFUV9BTExPQ19DQUNIRTsNCj4gQEAgLTI1OSwxMyArMjUyLDMxIEBAIHN0
YXRpYyBpbnQgYmlvX21hcF91c2VyX2lvdihzdHJ1Y3QgcmVxdWVzdCAqcnEsIHN0cnVjdCBpb3Zf
aXRlciAqaXRlciwNCj4gICAJCWJpbyA9IGJpb19hbGxvY19iaW9zZXQoTlVMTCwgbnJfdmVjcywg
b3BmLCBnZnBfbWFzaywNCj4gICAJCQkJCSZmc19iaW9fc2V0KTsNCj4gICAJCWlmICghYmlvKQ0K
PiAtCQkJcmV0dXJuIC1FTk9NRU07DQo+ICsJCQlyZXR1cm4gTlVMTDsNCj4gICAJfSBlbHNlIHsN
Cj4gICAJCWJpbyA9IGJpb19rbWFsbG9jKG5yX3ZlY3MsIGdmcF9tYXNrKTsNCj4gICAJCWlmICgh
YmlvKQ0KPiAtCQkJcmV0dXJuIC1FTk9NRU07DQo+ICsJCQlyZXR1cm4gTlVMTDsNCj4gICAJCWJp
b19pbml0KGJpbywgTlVMTCwgYmlvLT5iaV9pbmxpbmVfdmVjcywgbnJfdmVjcywgcmVxX29wKHJx
KSk7DQo+ICAgCX0NCj4gKwlyZXR1cm4gYmlvOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IGJp
b19tYXBfdXNlcl9pb3Yoc3RydWN0IHJlcXVlc3QgKnJxLCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIs
DQo+ICsJCWdmcF90IGdmcF9tYXNrKQ0KPiArew0KPiArCXVuc2lnbmVkIGludCBtYXhfc2VjdG9y
cyA9IHF1ZXVlX21heF9od19zZWN0b3JzKHJxLT5xKTsNCj4gKwl1bnNpZ25lZCBpbnQgbnJfdmVj
cyA9IGlvdl9pdGVyX25wYWdlcyhpdGVyLCBCSU9fTUFYX1ZFQ1MpOw0KPiArCXN0cnVjdCBiaW8g
KmJpbzsNCj4gKwlpbnQgcmV0Ow0KPiArCWludCBqOw0KPiArDQo+ICsJaWYgKCFpb3ZfaXRlcl9j
b3VudChpdGVyKSkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsNCj4gKwliaW8gPSBiaW9fbWFw
X2dldChycSwgbnJfdmVjcywgZ2ZwX21hc2spOw0KPiArCWlmIChiaW8gPT0gTlVMTCkNCj4gKwkJ
cmV0dXJuIC1FTk9NRU07DQo+ICAgDQo+ICAgCXdoaWxlIChpb3ZfaXRlcl9jb3VudChpdGVyKSkg
ew0KPiAgIAkJc3RydWN0IHBhZ2UgKipwYWdlcywgKnN0YWNrX3BhZ2VzW1VJT19GQVNUSU9WXTsN
Cj4gQEAgLTYxMiw2ICs2MjMsNjkgQEAgaW50IGJsa19ycV9tYXBfdXNlcihzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxLA0KPiAgIH0NCj4gICBFWFBPUlRfU1lNQk9M
KGJsa19ycV9tYXBfdXNlcik7DQo+ICAgDQo+ICsvKiBQcmVwYXJlIGJpbyBmb3IgcGFzc3Rocm91
Z2ggSU8gZ2l2ZW4gYW4gZXhpc3RpbmcgYnZlYyBpdGVyICovDQo+ICtpbnQgYmxrX3JxX21hcF91
c2VyX2J2ZWMoc3RydWN0IHJlcXVlc3QgKnJxLCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIpDQo+ICt7
DQo+ICsJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBycS0+cTsNCj4gKwlzaXplX3QgaXRlcl9j
b3VudCwgbnJfc2VnczsNCj4gKwlzdHJ1Y3QgYmlvICpiaW87DQo+ICsJc3RydWN0IGJpb192ZWMg
KmJ2LCAqYnZlY19hcnIsICpidnBydnAgPSBOVUxMOw0KPiArCXN0cnVjdCBxdWV1ZV9saW1pdHMg
KmxpbSA9ICZxLT5saW1pdHM7DQo+ICsJdW5zaWduZWQgaW50IG5zZWdzID0gMCwgYnl0ZXMgPSAw
Ow0KPiArCWludCByZXQsIGk7DQo+ICsNCg0KY29uc2lkZXIgdGhpcyAodW50ZXN0ZWQpLCBpdCBh
bHNvIHNldHMgdGhlIHZhcmlhYmxlIGkgZGF0YSB0eXBlIHNhbWUNCmFzIGl0IGNvbXBhcmlzb24g
dmFyaWFibGUgaW4gbnJfc2VncyB0aGUgbG9vcCBpLmUuIHNpemVfdCA6LQ0KDQorICAgICAgIHN0
cnVjdCBiaW9fdmVjICpidiwgKmJ2ZWNfYXJyLCAqYnZwcnZwID0gTlVMTDsNCisgICAgICAgc3Ry
dWN0IHJlcXVlc3RfcXVldWUgKnEgPSBycS0+cTsNCisgICAgICAgc3RydWN0IHF1ZXVlX2xpbWl0
cyAqbGltID0gJnEtPmxpbWl0czsNCisgICAgICAgdW5zaWduZWQgaW50IG5zZWdzID0gMCwgYnl0
ZXMgPSAwOw0KKyAgICAgICBzaXplX3QgaXRlcl9jb3VudCwgbnJfc2VncywgaTsNCisgICAgICAg
c3RydWN0IGJpbyAqYmlvOw0KKyAgICAgICBpbnQgcmV0Ow0KDQoNCj4gKwlpdGVyX2NvdW50ID0g
aW92X2l0ZXJfY291bnQoaXRlcik7DQo+ICsJbnJfc2VncyA9IGl0ZXItPm5yX3NlZ3M7DQo+ICsN
Cj4gKwlpZiAoIWl0ZXJfY291bnQgfHwgKGl0ZXJfY291bnQgPj4gOSkgPiBxdWV1ZV9tYXhfaHdf
c2VjdG9ycyhxKSkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQoNCmNhbiB3ZSByZW1vdmUgYnJhY2Vz
IGZvciBpdGVyX2NvdW50ID4+IDkgd2l0aG91dCBpbXBhY3RpbmcgdGhlIGludGVuZGVkDQpmdW5j
dGlvbmFsaXR5Pw0KDQo+ICsJaWYgKG5yX3NlZ3MgPiBxdWV1ZV9tYXhfc2VnbWVudHMocSkpDQo+
ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJLyogbm8gaW92ZWNzIHRvIGFsbG9jLCBhcyB3
ZSBhbHJlYWR5IGhhdmUgYSBCVkVDIGl0ZXJhdG9yICovDQo+ICsJYmlvID0gYmlvX21hcF9nZXQo
cnEsIDAsIEdGUF9LRVJORUwpOw0KPiArCWlmIChiaW8gPT0gTlVMTCkNCj4gKwkJcmV0dXJuIC1F
Tk9NRU07DQo+ICsNCj4gKwliaW9faW92X2J2ZWNfc2V0KGJpbywgaXRlcik7DQo+ICsJYmxrX3Jx
X2Jpb19wcmVwKHJxLCBiaW8sIG5yX3NlZ3MpOw0KPiArDQo+ICsJLyogbG9vcCB0byBwZXJmb3Jt
IGEgYnVuY2ggb2Ygc2FuaXR5IGNoZWNrcyAqLw0KPiArCWJ2ZWNfYXJyID0gKHN0cnVjdCBiaW9f
dmVjICopaXRlci0+YnZlYzsNCj4gKwlmb3IgKGkgPSAwOyBpIDwgbnJfc2VnczsgaSsrKSB7DQo+
ICsJCWJ2ID0gJmJ2ZWNfYXJyW2ldOw0KDQpJJ2QganVzdCBjYWxsIGJ2ZWNzIGluc3RlYWQgb2Yg
YnZlY19hcnIsIGp1c3QgcGVyc29uYWwgcHJlZmVyZW5jZS4NCg0KPiArCQkvKg0KPiArCQkgKiBJ
ZiB0aGUgcXVldWUgZG9lc24ndCBzdXBwb3J0IFNHIGdhcHMgYW5kIGFkZGluZyB0aGlzDQo+ICsJ
CSAqIG9mZnNldCB3b3VsZCBjcmVhdGUgYSBnYXAsIGRpc2FsbG93IGl0Lg0KPiArCQkgKi8NCj4g
KwkJaWYgKGJ2cHJ2cCAmJiBidmVjX2dhcF90b19wcmV2KGxpbSwgYnZwcnZwLCBidi0+YnZfb2Zm
c2V0KSkgew0KPiArCQkJcmV0ID0gLUVJTlZBTDsNCj4gKwkJCWdvdG8gb3V0X2ZyZWU7DQo+ICsJ
CX0NCj4gKw0KPiArCQkvKiBjaGVjayBmdWxsIGNvbmRpdGlvbiAqLw0KPiArCQlpZiAobnNlZ3Mg
Pj0gbnJfc2VncyB8fCBieXRlcyA+IFVJTlRfTUFYIC0gYnYtPmJ2X2xlbikgew0KPiArCQkJcmV0
ID0gLUVJTlZBTDsNCj4gKwkJCWdvdG8gb3V0X2ZyZWU7DQo+ICsJCX0NCj4gKw0KPiArCQlpZiAo
Ynl0ZXMgKyBidi0+YnZfbGVuIDw9IGl0ZXJfY291bnQgJiYNCj4gKwkJCQlidi0+YnZfb2Zmc2V0
ICsgYnYtPmJ2X2xlbiA8PSBQQUdFX1NJWkUpIHsNCj4gKwkJCW5zZWdzKys7DQo+ICsJCQlieXRl
cyArPSBidi0+YnZfbGVuOw0KPiArCQl9IGVsc2Ugew0KPiArCQkJcmV0ID0gLUVJTlZBTDsNCj4g
KwkJCWdvdG8gb3V0X2ZyZWU7DQoNCnlvdSBhcmUgb25seSBjYWxsaW5nIGdvdG8gb3V0X2ZyZWU7
IGZyb20gbG9vcCB3aXRoIHJldCA9IC1FSU5WQUwuDQp5b3UgY2FuIHJlbW92ZSByZWR1bmRhbnQg
cmV0ID0gLUVJTlZBTCBhc3NpZ25tZW50IGluIHRoZSBsb29wIGFuZA0KY2FsbCByZXR1cm4gLUVJ
TlZBTCBmcm9tIHRoZSBvdXRfZnJlZTogbGFiZWwgaW5zdGVhZCByZXR1cm4gcmV0Lg0KVGhhdCB3
aWxsIGFsc28gYWxsb3cgdXMgdG8gcmVtb3ZlIGJyYWNlcyBpbiB0aGUgbG9vcC4NCg0KVGhpcyB3
aWxsIGFsc28gYWxsb3cgdXMgdG8gcmVtb3ZlIHRoZSByZXQgdmFyaWFibGUgb24gdGhlDQpzaW5j
ZSBJIGd1ZXNzIHdlIGFyZSBpbiB0aGUgZmFzdCBwYXRoLg0KDQo+ICsJCX0NCj4gKwkJYnZwcnZw
ID0gYnY7DQo+ICsJfQ0KPiArCXJldHVybiAwOw0KPiArb3V0X2ZyZWU6DQo+ICsJYmlvX21hcF9w
dXQoYmlvKTsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTChibGtfcnFf
bWFwX3VzZXJfYnZlYyk7DQoNCndoeSBub3QgdXNlIEVYUE9SVF9TWU1CT0xfR1BMKCkgZm9yIG5l
dyBhZGRpdGlvbj8NCg0KSSdtIGF3YXJlIHRoYXQgYmxrLW1hcC5jIG9ubHkgdXNlcyBFWFBPUlRf
U1lNQk9MKCkuDQoNCj4gKw0KPiAgIC8qKg0KPiAgICAqIGJsa19ycV91bm1hcF91c2VyIC0gdW5t
YXAgYSByZXF1ZXN0IHdpdGggdXNlciBkYXRhDQo+ICAgICogQGJpbzoJICAgICAgIHN0YXJ0IG9m
IGJpbyBsaXN0DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsay1tcS5oIGIvaW5jbHVk
ZS9saW51eC9ibGstbXEuaA0KPiBpbmRleCBiNDNjODFkOTE4OTIuLjgzYmVmMzYyZjBmOSAxMDA2
NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9ibGstbXEuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4
L2Jsay1tcS5oDQo+IEBAIC05NzAsNiArOTcwLDcgQEAgc3RydWN0IHJxX21hcF9kYXRhIHsNCj4g
ICAJYm9vbCBmcm9tX3VzZXI7DQo+ICAgfTsNCj4gICANCj4gK2ludCBibGtfcnFfbWFwX3VzZXJf
YnZlYyhzdHJ1Y3QgcmVxdWVzdCAqcnEsIHN0cnVjdCBpb3ZfaXRlciAqaXRlcik7DQo+ICAgaW50
IGJsa19ycV9tYXBfdXNlcihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqLCBzdHJ1Y3QgcmVxdWVzdCAq
LA0KPiAgIAkJc3RydWN0IHJxX21hcF9kYXRhICosIHZvaWQgX191c2VyICosIHVuc2lnbmVkIGxv
bmcsIGdmcF90KTsNCj4gICBpbnQgYmxrX3JxX21hcF91c2VyX2lvdihzdHJ1Y3QgcmVxdWVzdF9x
dWV1ZSAqLCBzdHJ1Y3QgcmVxdWVzdCAqLA0KDQo=
