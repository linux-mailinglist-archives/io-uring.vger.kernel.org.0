Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2866E76E5
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 11:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjDSJ4u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 05:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDSJ4s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 05:56:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9C21992;
        Wed, 19 Apr 2023 02:56:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFJ9Jnzq1TOgMZ1neCmj2wO65dJurjOXw62RoamzK5jDYegpfUoF6iqLpCKDPYYQQcJt6XT36wevys55VgFuUml2NR26piZbkLkQq+Jrt6v/lAZVBta64O65jSxahvD8SK2uSaWz65dI2smuRnJM3hA8YF6NvF+K+R4opAHGOMUYpnZ5vCSYOzxhLutNHKQ//iN9EQi692PwTyB8y3pI+fO7y4Bh8s1aYYLEffmm1/ybGSrSmVTL1r8mulpwZCFJPQGYVS739XiXU82GXdfQ7yZZZms2iOHTN7v8iicsFPvXWuZOyagHjdDs6EE5djUP7rUjb1unIAmYq0caZHL/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Btq2fPMEM7/g4uTzPbTK9bDd2Zre5Y+HioxoCtyodFM=;
 b=mzd9kgpHoWp/31glRTEBj+1R7O6jbj0plN1jvB+oxLnmK2DyMmkT00mJbN4YBiEhSu4C1dxRBYt1/eyhL9gqwPhpdmCJ1rF5BnifQBD3OQirm2mI4JtPaG3h+b8vn/isFduzFBBHv/YegN8ittyaueUfhiIQM7CVYJd7P76yd2lkt4aHT6mTjTt+chvKRAACfORdpQBlifIv1OUeiEAWuSWJ462wYsc3C0oJitRoBJQcz7OCWFgCmIaAKeL9/8iVCDdx0CPwpg0APejDfYpbr8WxF3owwCnOva/R+V3n58WkKoRxuYCcPraUwDal31dGV4oQq7OeR0vnakaXvXjZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Btq2fPMEM7/g4uTzPbTK9bDd2Zre5Y+HioxoCtyodFM=;
 b=T6DTzNeRFjedPGp6SAaNcNQuw3TBNxqK9VCwXQQ4/GllGXmJcbvPBMVwE8cLlp+v3dy8mtBq5WcAwsSTKNlVsV7yKIgJGO9OrQg9r2NipvpZjPlc0FsVQtNTExpGjmyryEJiZJWtW3bFutKHEEPaoD9hBTSkcgaY/lXUveh2eGA=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by SA0PR19MB4334.namprd19.prod.outlook.com (2603:10b6:806:8f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 09:56:43 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%6]) with mapi id 15.20.6277.031; Wed, 19 Apr 2023
 09:56:43 +0000
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
Thread-Index: AQHZYvvtPs9fEeQCFke4YxV9Vaxbbq8xlJqAgABoW4CAAIeQgA==
Date:   Wed, 19 Apr 2023 09:56:43 +0000
Message-ID: <b6188050-1b12-703c-57e8-67fd27adb85c@ddn.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <78fe6617-2f5e-3e8e-d853-6dc8ffb5f82c@ddn.com>
 <ZD9JI/JlwrzXQPZ7@ovpn-8-18.pek2.redhat.com>
In-Reply-To: <ZD9JI/JlwrzXQPZ7@ovpn-8-18.pek2.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|SA0PR19MB4334:EE_
x-ms-office365-filtering-correlation-id: 2c7aed22-1fcd-4a4a-5c97-08db40bc617e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IKANquDs3WxlD3+ZUm6p8oAu50HEYn7b08mowIu0hWmA+OIP93Yo0ioXZIhTX8i/MG05U8imdb6daBfGCrL7Y1nqGpN4TT2Gcu6wC+RpvIJpkwLW9gwUreGvbEsSqrYxxY26KWjCkbnUvPceFPRCWbNJSyXQBQ1qfJnEHtmDi9u0+fK/VojUXYcgKfhNFetb9XP35QzSVfS5Uy5xbVhZkphZGeHzPM+7w89a4FgvGNXSnGK2cznOs5nXj8NdJ+6HXcARWD9kUEDd7Qj45gaUMq80pC3d2TAzXjrTd2ARtd57oHOFwlBtukSfj6/nW3bDnSORTV6TsDkuwr3Pzo4PIFGkjEhYvfBfKuPITELG/ll0jj0B4lDwOQihH/dYcfdnpx/F0AFJjOsTLwoIU9Vkz4r+f0dFPbSMCn7SXARgjLj2ed7QNBDvFBgYWmxFhTa3HmLMXTK6MxdYHhD99IWPcE5KeTurN9ryAN7bJkO3CFzj0PqeOdY9bSaY0DgIKUEkXWTrrG8jevPn75cN9O7AUqDVLK6VaQJGWUYxwc1n202c4bZcIk63lRB7hyHm7B06C/EbfJMJ4AcHHO0a3MXSeZQ4zt7vXXn0gWUs2KVoC5CY9yDM1Yb6IPLZZCxJOjmMQZqeb+ZPnlex9HHq2LFXCuZqevZbk9DAnmV/asokr0K8kTrGUE2v3KXSQ2IXJpqJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39850400004)(136003)(376002)(366004)(451199021)(66899021)(2616005)(186003)(36756003)(478600001)(2906002)(7416002)(6486002)(71200400001)(38070700005)(45080400002)(6916009)(4326008)(76116006)(66946007)(64756008)(66446008)(66556008)(66476007)(91956017)(8676002)(8936002)(38100700002)(316002)(5660300002)(83380400001)(122000001)(54906003)(41300700001)(31686004)(6512007)(6506007)(53546011)(966005)(86362001)(31696002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WC82M21YdWFVWUY5blc2L1I5akRudWw2dE04dWsycDdtdXFaUkpGR3dLR3JJ?=
 =?utf-8?B?eWMyN0s2amNYUi9Id0lCeDNKR3B2c3p3bCtuNm44Mzk4UTZ0eTFzY0pPTzZw?=
 =?utf-8?B?bWVSNlFZMnBYZzlha2Z0MTVQL21OY2lsSkUrTTFEQWtGeWNWTHcvdmRkNjVZ?=
 =?utf-8?B?RzRDWStlOU5iYThUb1Vnbk9FM3E1Q1VDSUhDa1d6UFU0OEJxMFAyZHdxWGZj?=
 =?utf-8?B?K1ZSZ1RpSWgvSk5pak1UWEE4dDZ3UnVQbHREQ2ptZlpxMmR3bmZWVDluemI0?=
 =?utf-8?B?M2JBN1kyeFhNb045TU93UVZuS3F5WlFvVWx5T0FvSFZHeXhSS1VMaTlYSnhH?=
 =?utf-8?B?TkRGV0RMcVhzQjJ5U0d6QloxR1JOenV3Wld6akJndUtKLzMxSEpuTi84SVhi?=
 =?utf-8?B?a3UxelNlVXcyK2VkSzEyTlkzQm84Yk9ucllvbFd2bEVVeW14RTlwY05HaGhx?=
 =?utf-8?B?ZE9XdHhEWDdyUXZNZm1GMkZNazRJSnJacHYzNUZkYWFrbGlpdEJLMy81R0xC?=
 =?utf-8?B?WmI4TkNyRTR4clhwaUJOb2gzNHVMZ2FFaWZMaGNqSno0WXpZemZ4T1ROVXlG?=
 =?utf-8?B?Sm54NEtGRVBSQUQxYlFBQnd3aDF3ai82bCtyTHBtRzF3dmlmMW01RlZvd3V2?=
 =?utf-8?B?K1ZHVnQzOFZQbk13c0tNZlI3a2d1eHhXUWY1b29DUlIzcERnS295ZmNLbXI1?=
 =?utf-8?B?dWR1WnZjVmJLVUZqZnpwMEh3cm9NV1lOR2NibW8xRGVZcXhsVGhrNjRmb2R3?=
 =?utf-8?B?OWNua3hQN3hBMVkrK2FuY3JiV1l4Tnd3N21BKys5Uml0QU9ucHJMSGZlMXRS?=
 =?utf-8?B?Y1lOaCtQT0NBMENVdlBEL0E3L3BiTmhaL0JVczFLU2s0TithS2d2L0F4dGts?=
 =?utf-8?B?anAyWmduSEdDYTZvYUtXYi9PeFdnb0NJN0QrTEcrcE1tMzlySERVOGlNVUJB?=
 =?utf-8?B?MW5IY1FFak5ueWxCUlZxRzd4VGtWeUU3MldUNWxWWkhrNmphY05nd1F0aXZa?=
 =?utf-8?B?dUw0Sk02ODdHc0pMUkc3SmJ0UjQyNXZyeW93bzZKR0FSQnJtUUlRVk8xSzRi?=
 =?utf-8?B?SXplSHpXdndvcEhTVjcwRzlmNU5hQWtLRWk5SlRpZUFhWUk5YXJpNGxubHRB?=
 =?utf-8?B?Vlk1eU5DdXEzcGR6TWZScmZDN2RPU3hDdnRjcTN5MW5ueVNzNUZyWmFjMzJR?=
 =?utf-8?B?OTR5c3EzbU1rVjdMOVZUUmFpVElaTVJUcFlURWNBNnR0VHRLKy9PNjVSQU1v?=
 =?utf-8?B?WHJ2VjFjU2dFMkVPcEMvYnFzNHhhTWdyTlZXRVhBdUNxcGhmMVB1MDlqb0JW?=
 =?utf-8?B?amhBUVVJRXYzUVErTFFobVBQcU1uUFdpU2pnQ3NXZUwxaVFFWVJxS1JXeTdR?=
 =?utf-8?B?dzUrUlBCbGJ6ekdTT0F4eDV5a1E1UmUyaHJIVDc0M1NRK3Z2aWR1NGVDd1dC?=
 =?utf-8?B?QVZLMllwTXQ4eDRkS3RmOGxmcHlWTk90Vi9ROUdad0QwMGovaTFUNzIxb3Yw?=
 =?utf-8?B?YVhCS1VNa1YyRWRYZEpVU1RKSGtUZkJSQ3JicWJqblZCTkRNTUVnY2J3K0Nh?=
 =?utf-8?B?MWlsd1BCKzNpVlRwdWdNTkFrSk41ZTB1K2s2UVduZzNWdnhmYjFPcmxNU1Vp?=
 =?utf-8?B?MmM0RGNOOHFBeHZOdjJyYlluY3hQOXdnOGJYNDQraHI2azZSTWZzcXQ2aTl3?=
 =?utf-8?B?NytmcWZRRlRwWEltTTVqUGxqUnFLZ0s5MjR3K1ZEMUUwT2JkMFM2Z1hZcnZE?=
 =?utf-8?B?TWU2WC95MFZPODVXS0ZtUWIvYmtWZzZyZnFpN0lwZk9xYWpmVEsrbmJlWHlC?=
 =?utf-8?B?ZXpFU2p2cGdZUXROL2dmZXg3ZWpJQzF0VFNHRk9QR2hXMTlwTnNoNWNqL0lZ?=
 =?utf-8?B?dmZIeHVrTWdvMkhwQktRaElpTVBZY0ZiOWlQYUNCclo1Vy8yUUJEZ0ZXZmZP?=
 =?utf-8?B?S2MwdTU1REEza3NvaklNekd4emNmeEl4Vmd1WWJlYzcvTEtaSDR1WjQ4OGNL?=
 =?utf-8?B?Wmd5ZXVBMVJUenF2bldHQkwyUy9JaWxJeWFmSSs1VThsOXJyVVM4d1dWUVBu?=
 =?utf-8?B?L1lrdWtxZUF6b20zL1ZlYmk1Y1oyVUZhRHlIYm4rQVl6c2Q2WEhRcW5QQ0RK?=
 =?utf-8?B?bW9OTjhlZ3NHSVB6NklHWFgwT3BvcVpLZUJ1czVGck5pVHBnRXVYdTNZam94?=
 =?utf-8?Q?uehUV6gVGtQ5GqGJfr3dn6Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D02FB77B6BF5F0488A311FFE7E6B9F97@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c7aed22-1fcd-4a4a-5c97-08db40bc617e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 09:56:43.6132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TVoVJFnIGhJ/3jfTupV5GtbJhgOfJY+il/Uy4+8w6WTm3oxwuC7o74WAUW8TuPyQlrTTT93mrldWjZFEkdvWPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR19MB4334
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC8xOS8yMyAwMzo1MSwgTWluZyBMZWkgd3JvdGU6DQo+IE9uIFR1ZSwgQXByIDE4LCAyMDIz
IGF0IDA3OjM4OjAzUE0gKzAwMDAsIEJlcm5kIFNjaHViZXJ0IHdyb3RlOg0KPj4gT24gMy8zMC8y
MyAxMzozNiwgTWluZyBMZWkgd3JvdGU6DQo+PiBbLi4uXQ0KPj4+IFY2Og0KPj4+IAktIHJlLWRl
c2lnbiBmdXNlZCBjb21tYW5kLCBhbmQgbWFrZSBpdCBtb3JlIGdlbmVyaWMsIG1vdmluZyBzaGFy
aW5nIGJ1ZmZlcg0KPj4+IAlhcyBvbmUgcGx1Z2luIG9mIGZ1c2VkIGNvbW1hbmQsIHNvIGluIGZ1
dHVyZSB3ZSBjYW4gaW1wbGVtZW50IG1vcmUgcGx1Z2lucw0KPj4+IAktIGRvY3VtZW50IHBvdGVu
dGlhbCBvdGhlciB1c2UgY2FzZXMgb2YgZnVzZWQgY29tbWFuZA0KPj4+IAktIGRyb3Agc3VwcG9y
dCBmb3IgYnVpbHRpbiBzZWNvbmRhcnkgc3FlIGluIFNRRTEyOCwgc28gYWxsIHNlY29uZGFyeQ0K
Pj4+IAkgIHJlcXVlc3RzIGhhcyBzdGFuZGFsb25lIFNRRQ0KPj4+IAktIG1ha2UgZnVzZWQgY29t
bWFuZCBhcyBvbmUgZmVhdHVyZQ0KPj4+IAktIGNsZWFudXAgJiBpbXByb3ZlIG5hbWluZw0KPj4N
Cj4+IEhpIE1pbmcsIGV0IGFsLiwNCj4+DQo+PiBJIHN0YXJ0ZWQgdG8gd29uZGVyIGlmIGZ1c2Vk
IFNRRSBjb3VsZCBiZSBleHRlbmRlZCB0byBjb21iaW5lIG11bHRpcGxlDQo+PiBzeXNjYWxscywg
Zm9yIGV4YW1wbGUgb3Blbi9yZWFkL2Nsb3NlLiAgV2hpY2ggd291bGQgYmUgYW5vdGhlciBzb2x1
dGlvbg0KPj4gZm9yIHRoZSByZWFkZmlsZSBzeXNjYWxsIE1pa2xvcyBoYWQgcHJvcG9zZWQgc29t
ZSB0aW1lIGFnby4NCj4+DQo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL0NBSmZwZWd1
c2k4QmpXRnpFaTA1OTI2ZDRSc0VRdlBuUlctdzdNeT1pYkJIUThOZ0N1d0BtYWlsLmdtYWlsLmNv
bS8NCj4+DQo+PiBJZiBmdXNlZCBTUUVzIGNvdWxkIGJlIGV4dGVuZGVkLCBJIHRoaW5rIGl0IHdv
dWxkIGJlIHF1aXRlIGhlbHBmdWwgZm9yDQo+PiBtYW55IG90aGVyIHBhdHRlcm5zLiBBbm90aGVy
IHNpbWlsYXIgZXhhbXBsZXMgd291bGQgb3Blbi93cml0ZS9jbG9zZSwNCj4+IGJ1dCBpZGVhbCB3
b3VsZCBiZSBhbHNvIHRvIGFsbG93IHRvIGhhdmUgaXQgbW9yZSBjb21wbGV4IGxpa2UNCj4+ICJv
cGVuL3dyaXRlL3N5bmNfZmlsZV9yYW5nZS9jbG9zZSIgLSBvcGVuL3dyaXRlL2Nsb3NlIG1pZ2h0
IGJlIHRoZQ0KPj4gZmFzdGVzdCBhbmQgY291bGQgcG9zc2libHkgcmV0dXJuIGJlZm9yZSBzeW5j
X2ZpbGVfcmFuZ2UuIFVzZSBjYXNlIGZvcg0KPj4gdGhlIGxhdHRlciB3b3VsZCBiZSBhIGZpbGUg
c2VydmVyIHRoYXQgd2FudHMgdG8gZ2l2ZSBub3RpZmljYXRpb25zIHRvDQo+PiBjbGllbnQgd2hl
biBwYWdlcyBoYXZlIGJlZW4gd3JpdHRlbiBvdXQuDQo+IA0KPiBUaGUgYWJvdmUgcGF0dGVybiBu
ZWVkbid0IGZ1c2VkIGNvbW1hbmQsIGFuZCBpdCBjYW4gYmUgZG9uZSBieSBwbGFpbg0KPiBTUUVz
IGNoYWluLCBmb2xsb3dzIHRoZSB1c2FnZToNCj4gDQo+IDEpIHN1cHBvc2UgeW91IGdldCBvbmUg
Y29tbWFuZCBmcm9tIC9kZXYvZnVzZSwgdGhlbiBGVVNFIGRhZW1vbg0KPiBuZWVkcyB0byBoYW5k
bGUgdGhlIGNvbW1hbmQgYXMgb3Blbi93cml0ZS9zeW5jL2Nsb3NlDQo+IDIpIGdldCBzcWUxLCBw
cmVwYXJlIGl0IGZvciBvcGVuIHN5c2NhbGwsIG1hcmsgaXQgYXMgSU9TUUVfSU9fTElOSzsNCj4g
MykgZ2V0IHNxZTIsIHByZXBhcmUgaXQgZm9yIHdyaXRlIHN5c2NhbGwsIG1hcmsgaXQgYXMgSU9T
UUVfSU9fTElOSzsNCj4gNCkgZ2V0IHNxZTMsIHByZXBhcmUgaXQgZm9yIHN5bmMgZmlsZSByYW5n
ZSBzeXNjYWxsLCBtYXJrIGl0IGFzIElPU1FFX0lPX0xJTks7DQo+IDUpIGdldCBzcWU0LCBwcmVw
YXJlIGl0IGZvciBjbG9zZSBzeXNjYWxsDQo+IDYpIGlvX3VyaW5nX2VudGVyKCk7CS8vZm9yIHN1
Ym1pdCBhbmQgZ2V0IGV2ZW50cw0KDQpPaCwgSSB3YXMgbm90IGF3YXJlIHRoYXQgSU9TUUVfSU9f
TElOSyBjb3VsZCBwYXNzIHRoZSByZXN1bHQgb2Ygb3BlbiANCmRvd24gdG8gdGhlIG90aGVycy4g
SG1tLCB0aGUgZXhhbXBsZSBJIGZpbmQgZm9yIG9wZW4gaXMgDQppb191cmluZ19wcmVwX29wZW5h
dF9kaXJlY3QgaW4gdGVzdF9vcGVuX2ZpeGVkKCkuIEl0IHByb2JhYmx5IGdldHMgb2ZmIA0KdG9w
aWMgaGVyZSwgYnV0IG9uZSBuZWVkcyB0byBoYXZlIHJpbmcgcHJlcGFyZWQgd2l0aCANCmlvX3Vy
aW5nX3JlZ2lzdGVyX2ZpbGVzX3NwYXJzZSwgdGhlbiBtYW51YWxseSBtYW5hZ2VzIGF2YWlsYWJs
ZSBpbmRleGVzIA0KYW5kIGNhbiB0aGVuIGxpbmsgY29tbWFuZHM/IEludGVyZXN0aW5nIQ0KDQo+
IA0KPiBUaGVuIGFsbCB0aGUgZm91ciBPUHMgYXJlIGRvbmUgb25lIGJ5IG9uZSBieSBpb191cmlu
ZyBpbnRlcm5hbA0KPiBtYWNoaW5lcnksIGFuZCB5b3UgY2FuIGNob29zZSB0byBnZXQgc3VjY2Vz
c2Z1bCBDUUUgZm9yIGVhY2ggT1AuDQo+IA0KPiBJcyB0aGUgYWJvdmUgd2hhdCB5b3Ugd2FudCB0
byBkbz8NCj4gDQo+IFRoZSBmdXNlZCBjb21tYW5kIHByb3Bvc2FsIGlzIGFjdHVhbGx5IGZvciB6
ZXJvIGNvcHkoYnV0IG5vdCBsaW1pdGVkIHRvIHpjKS4NCg0KWWVhaCwgSSBoYWQganVzdCB0aG91
Z2h0IHRoYXQgSU9SSU5HX09QX0ZVU0VEX0NNRCBjb3VsZCBiZSBtb2RpZmllZCB0byANCnN1cHBv
cnQgZ2VuZXJpYyBwYXNzaW5nLCBhcyBpdCBraW5kIG9mIGhhbmRzIGRhdGEgKGJ1ZmZlcnMpIGZy
b20gb25lIHNxZSANCnRvIHRoZSBvdGhlci4gSS5lLiBpbnN0ZWFkIG9mIGJ1ZmZlcnMgaXQgd291
bGQgaGF2ZSBwYXNzZWQgdGhlIGZkLCBidXQgDQppZiB0aGlzIGlzIGFscmVhZHkgcG9zc2libGUg
LSBubyBuZWVkIHRvIG1ha2UgSU9SSU5HX09QX0ZVU0VEX0NNRCBtb3JlIA0KY29tcGxleC5tYW4N
Cg0KPiANCj4gSWYgdGhlIGFib3ZlIHdyaXRlIE9QIG5lZWQgdG8gd3JpdGUgdG8gZmlsZSB3aXRo
IGluLWtlcm5lbCBidWZmZXINCj4gb2YgL2Rldi9mdXNlIGRpcmVjdGx5LCB5b3UgY2FuIGdldCBv
bmUgc3FlMCBhbmQgcHJlcGFyZSBpdCBmb3IgcHJpbWFyeSBjb21tYW5kDQo+IGJlZm9yZSAxKSwg
YW5kIHNldCBzcWUyLT5hZGRyIHRvIG9mZmV0IG9mIHRoZSBidWZmZXIgaW4gMykuDQo+IA0KPiBI
b3dldmVyLCBmdXNlZCBjb21tYW5kIGlzIHVzdWFsbHkgdXNlZCBpbiB0aGUgZm9sbG93aW5nIHdh
eSwgc3VjaCBhcyBGVVNFIGRhZW1vbg0KPiBnZXRzIG9uZSBSRUFEIHJlcXVlc3QgZnJvbSAvZGV2
L2Z1c2UsIEZVU0UgdXNlcnNwYWNlIGNhbiBoYW5kbGUgdGhlIFJFQUQgcmVxdWVzdA0KPiBhcyBp
b191cmluZyBmdXNlZCBjb21tYW5kOg0KPiANCj4gMSkgZ2V0IHNxZTAgYW5kIHByZXBhcmUgaXQg
Zm9yIHByaW1hcnkgY29tbWFuZCwgaW4gd2hpY2ggeW91IG5lZWQgdG8NCj4gcHJvdmlkZSBpbmZv
IGZvciByZXRyaWV2aW5nIGtlcm5lbCBidWZmZXIvcGFnZXMgb2YgdGhpcyBSRUFEIHJlcXVlc3QN
Cj4gDQo+IDIpIHN1cHBvc2UgdGhpcyBSRUFEIHJlcXVlc3QgbmVlZHMgdG8gYmUgaGFuZGxlZCBi
eSB0cmFuc2xhdGluZyBpdCB0bw0KPiBSRUFEcyB0byB0d28gZmlsZXMvZGV2aWNlcywgY29uc2lk
ZXJpbmcgaXQgYXMgb25lIG1pcnJvcjoNCj4gDQo+IC0gZ2V0IHNxZTEsIHByZXBhcmUgaXQgZm9y
IHJlYWQgZnJvbSBmaWxlMSwgYW5kIHNldCBzcWUtPmFkZHIgdG8gb2Zmc2V0DQo+ICAgIG9mIHRo
ZSBidWZmZXIgaW4gMSksIHNldCBzcWUtPmxlbiBhcyBsZW5ndGggZm9yIHJlYWQ7IHRoaXMgUkVB
RCBPUA0KPiAgICB1c2VzIHRoZSBrZXJuZWwgYnVmZmVyIGluIDEpIGRpcmVjdGx5DQo+IA0KPiAt
IGdldCBzcWUyLCBwcmVwYXJlIGl0IGZvciByZWFkIGZyb20gZmlsZTIsIGFuZCBzZXQgc3FlLT5h
ZGRyIHRvIG9mZnNldA0KPiAgICBvZiBidWZmZXIgaW4gMSksIHNldCBzcWUtPmxlbiBhcyBsZW5n
dGggZm9yIHJlYWQ7ICB0aGlzIFJFQUQgT1ANCj4gICAgdXNlcyB0aGUga2VybmVsIGJ1ZmZlciBp
biAxKSBkaXJlY3RseQ0KPiANCj4gMykgc3VibWl0IHRoZSB0aHJlZSBzcWUgYnkgaW9fdXJpbmdf
ZW50ZXIoKQ0KPiANCj4gc3FlMSBhbmQgc3FlMiBjYW4gYmUgc3VibWl0dGVkIGNvbmN1cnJlbnRs
eSBvciBiZSBpc3N1ZWQgb25lIGJ5IG9uZQ0KPiBpbiBvcmRlciwgZnVzZWQgY29tbWFuZCBzdXBw
b3J0cyBib3RoLCBhbmQgZGVwZW5kcyBvbiB1c2VyIHJlcXVpcmVtZW50Lg0KPiBCdXQgaW9fdXJp
bmcgbGlua2VkIE9QcyBpcyB1c3VhbGx5IHNsb3dlci4NCj4gDQo+IEFsc28gZmlsZTEvZmlsZTIg
bmVlZHMgdG8gYmUgb3BlbmVkIGJlZm9yZWhhbmQgaW4gdGhpcyBleGFtcGxlLCBhbmQgRkQgaXMN
Cj4gcGFzc2VkIHRvIHNxZTEvc3FlMiwgYW5vdGhlciBjaG9pY2UgaXMgdG8gdXNlIGZpeGVkIEZp
bGU7IEFsc28geW91IGNhbg0KPiBhZGQgdGhlIG9wZW4vY2xvc2UoKSBPUHMgaW50byBhYm92ZSBz
dGVwcywgd2hpY2ggbmVlZCB0aGVzZSBvcGVuL2Nsb3NlL1JFQUQNCj4gdG8gYmUgbGlua2VkIGlu
IG9yZGVyLCB1c3VhbGx5IHNsb3dlciB0bmFuIG5vbi1saW5rZWQgT1BzLg0KDQoNClllcyB0aGFu
a3MsIEknbSBnb2luZyB0byBwcmVwYXJlIHRoaXMgaW4gYW4gYnJhbmNoLCBvdGhlcndpc2UgY3Vy
cmVudCANCmZ1c2UtdXJpbmcgd291bGQgaGF2ZSBhIFpDIHJlZ3Jlc3Npb24gKGFsdGhvdWdoIG15
IHRhcmdldCBkZG4gcHJvamVjdHMgDQpjYW5ub3QgbWFrZSB1c2Ugb2YgaXQsIGFzIHdlIG5lZWQg
YWNjZXNzIHRvIHRoZSBidWZmZXIgZm9yIGNoZWNrc3VtcywgZXRjKS4NCg0KDQpUaGFua3MsDQpC
ZXJuZA0KDQo=
