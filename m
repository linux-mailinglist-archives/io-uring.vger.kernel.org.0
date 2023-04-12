Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE6C6DF78C
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 15:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjDLNoM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 09:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjDLNoG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 09:44:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017741999;
        Wed, 12 Apr 2023 06:43:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4Oi55OrZRhcCjPtLUR432i2o/uv4lC3vRcwSS122MhDnR+O0+mVlmuBk/cGzmwdSdTtxD2d0WR4Yef0Y+5pPG9S4k414uAmWSdJiGLrT4KX6RetWOvxSAj+m7UvqyLrkHnyJAxkN9HTJLpcNkPCArH0UQctJzJ+JdwcmbXPxMdaWLpvmdOdUyFgK7kIvwJp+5A9g8Lav1Ei4KflcGa2qa2zhXYTJlfQ7g82+Yc0XSRpV8iwluY19Ocj3sdLFcG914YZWk8zU/ag6Y10zboLJ5gHfLpy9YU0fX7M7BuPc/j6vc4BevRNf9QfwC3HXyPpNmdJJ84rm7lgdWbu6qNTkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nidC+OKf/1XvO+vLNCElNiUe9DtqMxrT50NUgecVVk=;
 b=KrBN/eWEQ+24Y+HTSisiLkpMMd9ATF1aXq+0aV4vZJTrCV2ndFN5fAQBWiyAPk7EQCYp/0hisSOtULcjfow/GRQo8DHVLjfo4lQjjkm4in03Jt+Ob5eZaqBm/hEl65FwW0i0dpcLxllBJtbpxTCMXKFM/LrYOU/xyBnB5QQ0PcW8xnD8z+X6p3Mn6ClMVSqvfsy90mh3qV8nHiVTEq4O31RYhurHpjZkUgcFCjt3Sle+9+0EoNfXFyrXqV5VX2AEAaDfVh5Z5GfROP1uCsSBUrxlro28Cd2SxiTBO5U5JSYrwSy06PmHIH3+LpfOhsNIYqCmhAPYcp68rYznzN6rHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nidC+OKf/1XvO+vLNCElNiUe9DtqMxrT50NUgecVVk=;
 b=d+h+550jckK0YGyzvo7/ZGLwHJZwXfQo0fgTzJNW2F/0aqx/tl4rbZIgpsPLH/tRP/62KkH14zbeo7WpWLmmvjn/OcOXVrc3JUTmujaq3+tS/vyxN2vVwnKkuHdH6DIn4MLrpbNnozorRJjtOXXPj6nV45urnCAhMtJ9WGJPvjc=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by DM4PR19MB6221.namprd19.prod.outlook.com (2603:10b6:8:ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 13:43:56 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%6]) with mapi id 15.20.6277.031; Wed, 12 Apr 2023
 13:43:55 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Thread-Topic: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Thread-Index: AQHZbUSFJ5BWwL3ovkmLZXgJpNfXLq8nrx2A
Date:   Wed, 12 Apr 2023 13:43:55 +0000
Message-ID: <9ca0d307-5b44-eb9c-3061-421b48f066e7@ddn.com>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
In-Reply-To: <20230412134057.381941-1-bschubert@ddn.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|DM4PR19MB6221:EE_
x-ms-office365-filtering-correlation-id: e7b601ab-64da-4fcd-8f6d-08db3b5bf601
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jW2SPxIt/N9lLlM2E19ThJiFXG2ouxwAZQLz9bDkEB/gbV6gGxZPDLAEU3rgQKP6tvsA8zSQfF67MDL2gQQNazovTqZ7q8D5KMWGz68dVeZ37gYLux/MJrPIEuaUf5ncv/qR3gxcLDT0OoZb/GLPngwTLscHp5SNIozgwLd3c+ru5ICWGxV42d5qe5pjuLiM29LoCihRSq7LhoFyw2uJaSuGZCFQnr/FK3h1PHYXwEwUWYTJV5lsziK58aNW1mJlIVSl5ycF0Z/WN+kroLvup8E2dQ8BMCs/wdavMl2MwnzvAh01+mo+GD2TkrQVk8RBjn+k7mDS17T5U7sbEFV3vUGRI1cOA+J9bfZxnOxYwubzHHT2IQaA9vclEW0pwFNYw235i8BHB6/jRj+nQ8JFBMuGKFidVEYNTDmYfEu40szclejmLyEpptMgxbzy9aspT6jk8aYSZnPhxC8OQhc3z6rbLC5qVegK3mXgtb/uoB7FfYU11jDKcZDvrBpUvIvfX9zWShq5tacr4oJ3+MQHjBONYlrqNOFktvN1RwzNYkvjdjr5Fc0uorxk3YCd4SL0M1Afze79TxHQmwYOlVFCch+YlQPHTnYMHb6h7lw1hyzMRvYq8c9F6BS+mqQUcj67DzhP1gHmuDAxZh37m3aPsKtiUwSlW0/tJNiq/zmzHDFf89QjmXdtlpJE7R+k0ytY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(451199021)(66556008)(8676002)(38100700002)(71200400001)(8936002)(316002)(91956017)(41300700001)(76116006)(66946007)(6916009)(66476007)(66446008)(4326008)(64756008)(478600001)(54906003)(122000001)(31696002)(186003)(36756003)(2906002)(53546011)(6512007)(4744005)(6506007)(31686004)(2616005)(38070700005)(5660300002)(6486002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eG9BMUJGY3BtdXlFNmh6TXQvRTROaHFMbWMxR21lTzRxS2wzLytlZGVEa3oz?=
 =?utf-8?B?NjBDZGQxOEcwc1F3WVNpNmphOG5hSjNmRFJrRFlhSTZmMldvQzBKUEF5eTN1?=
 =?utf-8?B?VXRaQ3NESTRlcDZCcWZxRHBVY2hoSFBDLzgweXJVS0IybmVjTXU0dmZla2dQ?=
 =?utf-8?B?bzJTNkxmVWlVQ3VnT0VHcktleWphODY0UVBaUkc0bDJ5SmhUeko5bk4reFpG?=
 =?utf-8?B?SEYxYllQY2lKVDc5SHNTZGFsSHM3eXRybnVDTUhncTNHQ1JGR08rN3QrVHF5?=
 =?utf-8?B?aW4zbnFWbWk2cGZ5K1ZkSkY1eWZKYVJKMzFyemRBUE5ObjJGeEIvSXU5MXE0?=
 =?utf-8?B?WDFnL01pVE5aYlF6NkRyMk96ejY5MW1QcVViQzdORC9RZ0p4M0U4U1JrYWFv?=
 =?utf-8?B?cVFkRUdhMlo4MXlGZk5Bazh3UWUzWW9ZMERCdjV6bHBMdjMrSFk2dHQ4bnBa?=
 =?utf-8?B?SGtOVTNsUStMc0s4dTE0SGNzREVKUS9YNTkvNmMxaDM0UEw4RllvQ3phQTlz?=
 =?utf-8?B?K3lTOU5oZjhVMTJjL0V4U25Qa0ZpeHRpRHM5NzJYYlhSaDNuZzY0ekNSS3p2?=
 =?utf-8?B?OHJSeC9zWTNJZmdnQ0FLbVVJcHhCOGZ3MHpkWXU5NmVldk54WjRwNzJSWEly?=
 =?utf-8?B?VGJKVUEweFZkSis4TVo2UXRUV3MweXVkSWJBZ2xEcm1mc29QOTE5ZlpTT044?=
 =?utf-8?B?Wm9TZWlLRmMxNlIvUWc5QzV1Z2dhbUxzbld1bWVoZDU5RTEvVGJ2YlY3b0pH?=
 =?utf-8?B?VnhrdEtmU1FRMXNBM3ZjU3RBQzRUNURlWmZaNHpqd3BVSkxCRGQ0TytqZmtl?=
 =?utf-8?B?M2lhSVN4cm9pZmpWSExXUTdKTlRoKzNaNWx0R2lyMnlSdTgzMjAvOUUxZnNh?=
 =?utf-8?B?SG9PM3NoT3pqbGJLNC9wN3YwdnJUMEUzaXJCbXlaQ0RaUGZEczhnVDgzYTUw?=
 =?utf-8?B?NVpYSDgxalJ0cGh2SjFNRGRXMW1JNGhHYUVkTmQ4ZUNhV2ZiMjJSNzJ3citI?=
 =?utf-8?B?b20yUm1va0RxcXFGb0xBWlR3dW52dnBuQVZTU25UMWoyZFRsWm9jUjlMZjhO?=
 =?utf-8?B?YXN6YWw2TEZJQUFVYSs0Q3JibGVQbURjRStoV0EwTnlHeWx6NEpvQXFSb01K?=
 =?utf-8?B?SHA0NHlBTFFKMVV6Z1dhdDVHRWt2d3VJWEZpb0RHTFlXY1BydUV4WkJVUVFq?=
 =?utf-8?B?YlB4ck95ekMxQTdvY2h5ZnZkemlEQ3pSWmRHbEY3azdXbkNOOVpVSXJreTh4?=
 =?utf-8?B?ZmF2cU9UaGlISTZMc0RkNnpGT2R5MGYrVXJ4bVFDNUJqZG9seGZlZE81aFMx?=
 =?utf-8?B?VDBvT3RIZ2h6UWpjaEZvZUpRYkw2NURTUVF0WFkrYkk5ejBhV3A3RXVUSVZj?=
 =?utf-8?B?cUtMTm54UXFiMXp6d1BSdG4wWWhkZE9jWDRHM0dJMjJVT1ZoRUlLVmQyN3Q1?=
 =?utf-8?B?M3c5Vk5oTHV5WEM2VUJvSkJzdzM0ZGVVT0V0M2pOOVR2TmxPRzFmNGtlLysx?=
 =?utf-8?B?OUgzdHR3NmNaSGIxQW1icWJvMFkrV2lEbU5HTGtlMjcvQWtNbVo2NlpEUUo1?=
 =?utf-8?B?a1RRT25PK1E1b3hmTmFrYWxwR1hKTEhoMi9LVUIva3d2SFdKWEl3VkJrTHRt?=
 =?utf-8?B?azNKak5rUnYvNElrNk9KOEI0bHhKUUZLSzA1aVJMZzhXZDIwM2dLaGJuRzlp?=
 =?utf-8?B?VUowcjRJUlZBSVNLNFFML1J1L3lZeWw2MnBSbzNZSXpVZ0MzTUhxZmVhREsr?=
 =?utf-8?B?L0NRN3VmNFhSNVNWeHdmWUlLQzlsaGNNUU1EQzVtM1VvQ3FyZ2dLNDJDZlhQ?=
 =?utf-8?B?OFhNZC9WdEpJV09mLzJ0NUs1RUVrOXliR2xWMmx0QWxyU3Z0ZHFieldVdWZ3?=
 =?utf-8?B?NGZTZEFGWlRzdGZ1bkhNRnk2ZW40KzI0Tm1MbjA4L05KMC9yVHlYMGpaOXFF?=
 =?utf-8?B?RHZLbnp5Wld1K3drTHh4dU5CTG1mL1RBcEZJQXRQYXAyRmxySCs4WXcvQ2Nh?=
 =?utf-8?B?RHZ0WC9uZDZqQ1NOZFkwaHFZTks1dk00OEJ3RHVkbDJuTnRzWWVucHhrNU9N?=
 =?utf-8?B?V3BZT2YvblQvcS9GR2g0MzI5SkVVREg2c2k4VVU0ajZsYVpoZFB5L0Y3cDdN?=
 =?utf-8?B?OVNYQktocnkvSkhlQmFIdldJcGZyWjBOQmF1S0prL2hNRjNGd3dwZnhJbmxo?=
 =?utf-8?Q?WzL6hGajei/wbzYwJbCABaM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF475EFFC568CA41A931949D0FF2A340@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b601ab-64da-4fcd-8f6d-08db3b5bf601
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 13:43:55.8261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JWT4AztlsoKRcUZVLcgzPESlgftWnMeBgAFwcv2dowMfGsa0jpkRQFcxzcBuYA6Uo6vTwG4Oi5L57OA5mMSmZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB6221
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

U29ycnksIGhhZCBmb3Jnb3R0ZW4gdG8gQ0MgTWlrbG9zLg0KDQpPbiA0LzEyLzIzIDE1OjQwLCBC
ZXJuZCBTY2h1YmVydCB3cm90ZToNCj4gTWlrbG9zLCBKZW5zLA0KPiANCj4gY291bGQgd2UgcGxl
YXNlIGFsc28gc2V0IHRoaXMgZmxhZyBmb3IgZnVzZT8NCj4gDQo+IA0KPiBUaGFua3MsDQo+IEJl
cm5kDQo+IA0KPiANCj4gZnVzZTogU2V0IEZNT0RFX0RJT19QQVJBTExFTF9XUklURSBmbGFnDQo+
IA0KPiBGcm9tOiBCZXJuZCBTY2h1YmVydCA8YnNjaHViZXJ0QGRkbi5jb20+DQo+IA0KPiBGdXNl
IGNhbiBhbHNvIGRvIHBhcmFsbGVsIERJTyB3cml0ZXMsIGlmIHVzZXJzcGFjZSBoYXMgZW5hYmxl
ZCBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRAZGRu
LmNvbT4NCj4gLS0tDQo+ICAgZnMvZnVzZS9maWxlLmMgfCAgICAzICsrKw0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9mdXNlL2ZpbGUu
YyBiL2ZzL2Z1c2UvZmlsZS5jDQo+IGluZGV4IDg3NTMxNGVlNmY1OS4uNDZlN2YxMTk2ZmQxIDEw
MDY0NA0KPiAtLS0gYS9mcy9mdXNlL2ZpbGUuYw0KPiArKysgYi9mcy9mdXNlL2ZpbGUuYw0KPiBA
QCAtMjE1LDYgKzIxNSw5IEBAIHZvaWQgZnVzZV9maW5pc2hfb3BlbihzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gICAJfQ0KPiAgIAlpZiAoKGZpbGUtPmZfbW9kZSAm
IEZNT0RFX1dSSVRFKSAmJiBmYy0+d3JpdGViYWNrX2NhY2hlKQ0KPiAgIAkJZnVzZV9saW5rX3dy
aXRlX2ZpbGUoZmlsZSk7DQo+ICsNCj4gKwlpZiAoZmYtPm9wZW5fZmxhZ3MgJiBGT1BFTl9QQVJB
TExFTF9ESVJFQ1RfV1JJVEVTKQ0KPiArCQlmaWxlLT5mX21vZGUgfD0gRk1PREVfRElPX1BBUkFM
TEVMX1dSSVRFOw0KPiAgIH0NCj4gICANCj4gICBpbnQgZnVzZV9vcGVuX2NvbW1vbihzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSwgYm9vbCBpc2RpcikNCg0K
