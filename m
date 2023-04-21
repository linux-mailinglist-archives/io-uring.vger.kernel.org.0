Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073336EB50A
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 00:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbjDUWjI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 18:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjDUWjB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 18:39:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BB13C11;
        Fri, 21 Apr 2023 15:38:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhY7rbPpHqht/oF5Iglj3R2rGyrFawUXp/vgB8eIQFA6+KKG5qLCLnPq36GMHChaoAW5u1z2m0GRofmxfLuvY58lk1OCInNNnAUmCqM5R+k8iU4fiYpgUDM9NR/UDYZSy9R/WvyEXNMoCg3Ok9ECbX+Y9iYY/FiVLkGDTTDcvVluLFGkEGBhg+u/qTIB5zyAKoqv+ZEjY1u5y6oBqXdPw1R5YansH7eS55f1CkbJ500pmUnIePCy8sbYM8J7lxULb1t+y+dQT36FUMifeLxyPclXlDfzZSTs9AMCA/BF9xqUuE/YjTn/gctPW3Vjc5TzZ44Zf3k2oqZZIt0NXrXzNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nb5z5Yt3g8tmPZoCLKvv47mlalyTfgMxE8LAwmMAwrs=;
 b=GFMKpHMjfQf5c12lmhh2ScdwtAsm8NOHdiyx3ob9pdXt3OMXBn79Tdm3pXUlWowRcGGfEBDuF5AQqhZq0sJ7YU5+5OoHTmzkfedMX3+X7GJqUfSX7nDwHPsF9Da5veJUdR0FNTXTVwYVd5/lZcefrLpTZZz28+iAOuxusn9eA1kHbIDlOYMfvmJ5cpy3wX1AgcFu5ZjEh7KI2LNS9HB7gltYH5tSxj6pgsns4tgIlInM96cJPtGwfrc/gy9qt0Kiwwy/i5GDEoM6hur7x7T48zNXLOpISstbfyOZGfU0uSzQrnt12yOWB4Tz/ErztxQwV5izYYLU0eBGxXNVLASrsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb5z5Yt3g8tmPZoCLKvv47mlalyTfgMxE8LAwmMAwrs=;
 b=pz1EKXvf0hrYt+1ySpVs+ekAiIEud1OLCE4rU7bK2NCwvfyfQs0A/eQLyupCLtNVmHeE9QP+3dZ6H4DBFw9tiUoTf2P4swNwQqdhkCxj3SSS2xbSiw8+TOv+VYf+RGoKqLkNOm8TrVbQrbkDbBFganw3ociyutXYD/IV+ZD+bWs=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by SJ0PR19MB5432.namprd19.prod.outlook.com (2603:10b6:a03:3e1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 21 Apr
 2023 22:38:10 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 22:38:09 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Thread-Topic: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Thread-Index: AQHZYvvtPs9fEeQCFke4YxV9Vaxbbq8xlJqAgABoW4CAAIeQgIAAFxAAgABJl4CAAKZqAIAC8lUA
Date:   Fri, 21 Apr 2023 22:38:09 +0000
Message-ID: <0b191493-d3cb-dce5-81d1-2d54f8cadfb6@ddn.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <78fe6617-2f5e-3e8e-d853-6dc8ffb5f82c@ddn.com>
 <ZD9JI/JlwrzXQPZ7@ovpn-8-18.pek2.redhat.com>
 <b6188050-1b12-703c-57e8-67fd27adb85c@ddn.com>
 <ZD/ONON4AzwvtlLB@ovpn-8-18.pek2.redhat.com>
 <6ed5c6f4-6abe-3eff-5a36-b1478a830c49@ddn.com>
 <ZECXiJ5aO/7tLshr@ovpn-8-16.pek2.redhat.com>
In-Reply-To: <ZECXiJ5aO/7tLshr@ovpn-8-16.pek2.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|SJ0PR19MB5432:EE_
x-ms-office365-filtering-correlation-id: 46233d31-5753-4f9f-efc2-08db42b91526
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C5S5KkuQETq5HS0AF/wyxoEdNFuh3Nd6zQIm+VjSmUPU9K/ePdEwJFEqeoCGYn/TxM7XRvTN22RSDbtvw3z84wcJNxVe7pSGMPBY7Eu4p8Cx91ru24xi1XygkgKqgRUqYP4kOypIr+0B/Yz9lQMsb0J1YS96UKbOktTPJgTc/jRDctB+Sw5rGWfjnC6deAsEC2HGca3MFEeqYYtDHbAVl+8PcMOXA97+aOQHemvRrcdSLdXUM//qKW/QWSJ5HFk5iC/9IY6bJxJg9udS3EBj7gqqckyh1laPQQ76e6nyiQn/rXfuflFmCCPtyjGbrQkE3CCun4evQ7ukLID1ByNfXkJPgOi49o+luSomR3YNi1IMZfvWD+mj8ep8Znveldj9nGeSJ1qjKqmt8fcn+DIz2eSJ26XC+hbnexKxv/DcjEB8MqBIGQX4ZM2r+tk/GyhN4faxlFQ+7Surd+TutXyiYhpphL2y7DchUPAoJSvoOgRyJfCJvFMbw0fMDLlddpG/StyBfWHpYfmFIZbdGCjQJ7GDSRUh0xFWc4AfB8lEskOYMarZT72nL7s9vmxiF04sDxnfAfr+jV9tJeYccu3K0BgWXGPsw4difnD2atJF+/UUgbYHbRRbM764Iou2NgqzLqH2vcOJ9GWw84c60jBGywK5NMR4kujxt9gKQCDhmyMc80dP5AZYuZSwQ5PUmsJziuzEutWylTtIOBZFZhNASg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39850400004)(366004)(376002)(451199021)(5660300002)(6486002)(71200400001)(64756008)(4326008)(2906002)(66556008)(66476007)(66946007)(66446008)(76116006)(36756003)(91956017)(6916009)(38100700002)(7416002)(122000001)(41300700001)(38070700005)(8936002)(8676002)(316002)(31696002)(86362001)(478600001)(54906003)(6506007)(31686004)(53546011)(6512007)(186003)(2616005)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXJMRlNHWTJ5c0lVYmlRckFnL3BHay9PVHh0c1ByZHpmVlBHenZldjlHOWdG?=
 =?utf-8?B?VXhQanpmRUhjZHFvZXFrOVFMU2Y3WjNjRVNLcEE2ZDdCaUVZWGRFMnZraThL?=
 =?utf-8?B?b1pvcEUyVXB3Nm8zSWNubThBWm90b1dpckI0WE5waklDWHFRTnpFa2J5WU4w?=
 =?utf-8?B?SFN5WnNRSFZrTjVlZCt6a0ZwWmlDN3NyK3lMRjkweHBVdnl4eEZ0bVFabFRW?=
 =?utf-8?B?dWg4Qk9FVkJzV1BldVF3WGNTa2VoRm90TENndEQrczk4b21Yd1BXZHRHck5n?=
 =?utf-8?B?cFNTZmQ0dFpKamhQY2pzeHBRMjJuaWRTM0N5VEkzcUEzcUdVY3BlUmtqQjBI?=
 =?utf-8?B?b1g2OXBGbkltTXd2RUIydFJPSXBiZ0ZqaFZkVGdlYjE5Z2VkZHRnTWlEM1hQ?=
 =?utf-8?B?YXRUZnBpQitFNHRQUlhGNytudnhiK2JRZDQ3aUdKMjJoNjcxamg1T1k0ZEZp?=
 =?utf-8?B?T1pmRUdPTy9mZ2tNOWxldjh2aDVlQnV3MGo2eFVwSmszUUpIS1VhWEtLY1Rh?=
 =?utf-8?B?NFA1cE1nZE40K3NhT0VYaHlTRFIraTVueXJReEJ3L2xtMWcwTFRqUXJ1V21X?=
 =?utf-8?B?ZGt1RWhaSGVtbGVaVnpIdlZGMVE0WGQvdkEvWmhKb0IxS3lTdjhiM1VRVnZj?=
 =?utf-8?B?M1lOWCtRRWVTS0lkemNvNHdJc2Fmc0d1aDR5T3FqeFAyMk50M3hTN1VOU0Zo?=
 =?utf-8?B?bFNjRHBWZXk5MUdReEpvYWNnYU11Y1Q2ZGlTR0pQUGtkdWJ0UVUxU0hUVkw3?=
 =?utf-8?B?SHFnVC9KZWlrTlQ3VFZNUkEyaXRXb1hlTU50R2wzMmxESVpxNjhaSzZ5VzZu?=
 =?utf-8?B?MkJXWkZxNmdadk9SUGFFdGtQclVxTHVRQ09oaWxYVC9HWWVzbUlYL2NVUDRG?=
 =?utf-8?B?QTRXMTZpWTN0cGJaeG1EdlRXSFpTM3oxMW01MVVSQTg2M2x0QzRCSlJ6OXpY?=
 =?utf-8?B?OEJoVE0yMHhNM2dTdThHWHpqMTUwTnU4QmttejUvNndsSXgrMUZSeEZ3dkJa?=
 =?utf-8?B?c3hoTjJJZ0xod2ZzeDRYWFQ1ekcxbVdXZ09sSGl3SVdRY2h3Y21VYi83ODVI?=
 =?utf-8?B?ZlpwSDdDazB5d242dDlEUkNMa21Pa29aMG5KbVBJU2prK01lZUFyd25HOVc4?=
 =?utf-8?B?ajdDK1ZMVVRzUGw0d2ZpaFVBZVhwa09QTTJsKzRYZ3d3VWxEbytKNHltT3h2?=
 =?utf-8?B?U2VKUUxHOE01eVRwMnc1Umk5NWVBd1lPQ1ljTUFqMmtCNVI5UU5nMEZNQlNS?=
 =?utf-8?B?WCtXejA4OGxqejQxbHpLbGdpOEJBYUMrd3lkbW9aQk9aZGpOT2VkdllnYjZp?=
 =?utf-8?B?dVJQaHVVeWR0S3Zja3J4MmdYTER6Ym0zRzNZMTRyNGpBTzhNMmROYWcySmJk?=
 =?utf-8?B?R1paVVVyc2RDNHFwR1JlbkRiaDBZSytHZ2kyRkdHb1J0ankzdDZhVllIclZI?=
 =?utf-8?B?K2tsWEhPVklSVVNwK0x3UWdSdEk5eC9leTNxSjZGUWFrTjI4SDBIbDFKVXRY?=
 =?utf-8?B?bXNZY2tKNWQrV2JyZWcyS3dVV1ZaZ3dwK1lkM3gzNkN2Wkw5WFYyaVVIbU82?=
 =?utf-8?B?eWRNUzV0YlZ4Y0MwWjJHWGZGWkV5VFVxY2VVNC9jczdmL0cwSGdUWEE4amk4?=
 =?utf-8?B?WHk0Rjd0SHZmU0crZ3N3QVVQVkhYcE9HZGh0REJucklzaVFPOC9kU2dTQzFC?=
 =?utf-8?B?NUI3MWtMM0MybTJVeEJuLzZUM2sxUVh5R21OV1F6NDlTb1A5VFMvb21UbWlT?=
 =?utf-8?B?Ukk2RnByVTN1ZUtZSFNUOGY4L05nc3VtdWJhSWNNdEo5TzRac2h4RUd1VVBQ?=
 =?utf-8?B?UnBsS3FyTFJWQlBGZ3oxRCtVMXZiYXI4d3R0akhKZWdGSUlpMjRkZ2NNSFEw?=
 =?utf-8?B?QjRyTnVaRDVLZnVsTkxuWGRoSElzUFU0MGhnK2ZLazJ3MTBWNCtFNFNienpE?=
 =?utf-8?B?VkdkYTJFUW83NmRnU3l2Q08wbTNuUUFjT3BKcGUwS0h0R2M5aXlONFlrcThl?=
 =?utf-8?B?WjZaS25PbG5XTnBaU0xZU3p6b3plNEM1RWN3MkhTcVJDbEIzc3krZTRYRVZx?=
 =?utf-8?B?WFNWU2pSRHZ2M0lTbnRBcW5OQkJDc2Y3cXI0OTBJN3hjSzkxbGk1K0ZwbEVB?=
 =?utf-8?B?elh4N2lpZUZMbS82Z0VnbWU2Q1gyVUFTcytJYzU4cnlVQUJMVVhJaVo3N2Fy?=
 =?utf-8?Q?PqaC7EYWPQk23Jag6czVb/E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB9580FBE0B7A945A9877AAF701CE099@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46233d31-5753-4f9f-efc2-08db42b91526
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 22:38:09.3844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2D+D3Lx0SBm7BUovi/VrKPB9XGV3bqacSJBELpe30+mwUr/LyRNzK+I6/6v/K53N/k+P52+p1BUJdyqiHcXelg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB5432
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC8yMC8yMyAwMzozOCwgTWluZyBMZWkgd3JvdGU6DQo+IE9uIFdlZCwgQXByIDE5LCAyMDIz
IGF0IDAzOjQyOjQwUE0gKzAwMDAsIEJlcm5kIFNjaHViZXJ0IHdyb3RlOg0KPj4gSSB2ZXJ5IG11
Y2ggc2VlIHRoZSB1c2UgY2FzZSBmb3IgRlVTRURfQ01EIGZvciBvdmVybGF5IG9yIHNpbXBsZSBu
ZXR3b3JrDQo+PiBzb2NrZXRzLiBOb3cgaW4gdGhlIEhQQyB3b3JsZCBvbmUgdHlwaWNhbGx5IHVz
ZXMgSUIgIFJETUEgYW5kIGlmIHRoYXQNCj4+IGZhaWxzIGZvciBzb21lIHJlYXNvbnMgKGxpa2Ug
Y29ubmVjdGlvbiBkb3duKSwgdGNwIG9yIG90aGVyIGludGVyZmFjZXMNCj4+IGFzIGZhbGxiYWNr
LiBBbmQgdGhlcmUgaXMgc2VuZGluZyB0aGUgcmlnaHQgcGFydCBvZiB0aGUgYnVmZmVyIHRvIHRo
ZQ0KPj4gcmlnaHQgc2VydmVyIGFuZCBlcmFzdXJlIGNvZGluZyBpbnZvbHZlZCAtIGl0IGdldHMg
Y29tcGxleCBhbmQgSSBkb24ndA0KPj4gdGhpbmsgdGhlcmUgaXMgYSB3YXkgZm9yIHVzIHdpdGhv
dXQgYSBidWZmZXIgY29weS4NCj4gDQo+IEFzIEkgbWVudGlvbmVkLCBpdChjaGVja3N1bSwgZW5j
cnlwdCwgLi4uKSBiZWNvbWVzIG9uZSBnZW5lcmljIGlzc3VlIGlmDQo+IHRoZSB6ZXJvIGNvcHkg
YXBwcm9hY2ggaXMgYWNjZXB0ZWQsIG1lYW50aW1lIHRoZSBwcm9ibGVtIGl0c2VsZiBpcyB3ZWxs
LWRlZmluZWQsDQo+IHNvIEkgZG9uJ3Qgd29ycnkgbm8gc29sdXRpb24gY2FuIGJlIGZpZ3VyZWQg
b3V0Lg0KPiANCj4gTWVhbnRpbWUgYmlnIG1lbW9yeSBjb3B5IGRvZXMgY29uc3VtZSBib3RoIGNw
dSBhbmQgbWVtb3J5IGJhbmR3aWR0aCBhDQo+IGxvdCwgYW5kIDY0ay81MTJrIHVibGsgaW8gaGFz
IHNob3duIHRoaXMgYmlnIGRpZmZlcmVuY2Ugd3J0LiBjb3B5IHZzLg0KPiB6ZXJvIGNvcHkuDQoN
CkkgZG9uJ3QgaGF2ZSBhbnkgZG91YnQgYWJvdXQgdGhhdCwgYnV0IEkgYmVsaWV2ZSB0aGVyZSBp
cyBubyBjdXJyZW50IHdheSANCnRvIHN1cHBvcnQgaXQgaW4gYWxsIHVzZSBjYXNlcy4gQXMgZXhh
bXBsZSwgbGV0J3MgY29uc2lkZXIgd2Ugd291bGQgbGlrZSANCnRvIGV4dGVuZCBuYmQgd2l0aCB2
ZXJicy9yZG1hIGluc3RlYWQgb2YgcGxhaW4gdGNwICAtIHZlcmJzL3JkbWEgbmVlZHMgDQpyZWdp
c3RlcmVkIG1lbW9yeSBhbmQgZG9lcyBub3QgdGFrZSBhIHNpbXBsZSBzb2NrZXQgZmQgdG8gc2Vu
ZCBidWZmZXJzIHRvLg0KDQoNClRoYW5rcywNCkJlcm5kDQo=
