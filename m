Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED9E6E6CFF
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 21:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbjDRTiN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 15:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjDRTiM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 15:38:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20621.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FF886AD;
        Tue, 18 Apr 2023 12:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxc1WaPBRRvlQWBDC/DiYoi+ON4dakhVAVqK+/0ZX0voHoTuzzgbLbQuhWw4mS4EvqPYvyO0C8IHgN5ptssP4GWS7VHT37TuHToV4mbObCd8RBAiV1OP9Rqpk4+73ABRPrTnkDIZDDGiimmkoavcZY04Q/mI28IWqZkkHcQgXwGVd/9pGZjkdcd0pjm4IW/7nO/Xbacky30WVRl1k7T5tdwc4OkAXbCcsZ0H67D53Ntv9+A7izUTlOnnuHO/v/5pcqgTfe2xEpXTMkVKT0FAOJkuV+cA1rzGo2GHBKbbw5p1PGIJl5DiCXmKqwB8AyhaEXRSLyXau3CK9sLwHhj9tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmxpsCQHH5hIVkJ048fWe4bUx/xXbD/LKOp+6mNXEnQ=;
 b=LgW5URh7AhxM4D1DVQdZeSWJI/vnzB2tf9eqfwhvJHF6kkAdqgI5yu0kVk/LJwowdzD+OU766RcARBIfiv4dLXCeGqeVNVdmqWa6vGuQXDCWr8eQldO5vUTBjYQHt905I/M4P8hx+Ip96ChzhfyqTQAmJlxmSSxScsB4ljbfafXOg7RJErY5s2iKLodBUvaIKaZG+nlSgg5gWekgzKGo4C1f60FxgFBbmyWkULjIoTaiQSTy08oLIl/2xgDy9bPz4kMtSqUM3iPtwF90E6TtnPlMI1SnS/JFQlTgvJiuE88tbotfX7DOMYCQ/0Rvh63YToapYU6jgbAwA/X4GNxM2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmxpsCQHH5hIVkJ048fWe4bUx/xXbD/LKOp+6mNXEnQ=;
 b=e0bg6COgDnkEhWWt+O4aac7ldRNkekCoolva+7ad9XieK+sBFW0xkeGQqq8Gi6K7rCydeXZdkrpn+cWgWrNIuZz4Mwoz0JsPWeIzO6ODO3phddIn4GHzFIayXfkB5I94MbxhRuGPJZmDHdn/fT02/mNb/Cg8VgXXIWUkvou9Jgw=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by SJ0PR19MB4591.namprd19.prod.outlook.com (2603:10b6:a03:279::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 19:38:04 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%6]) with mapi id 15.20.6277.031; Tue, 18 Apr 2023
 19:38:03 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Thread-Topic: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Thread-Index: AQHZYvvtPs9fEeQCFke4YxV9Vaxbbq8xlJqA
Date:   Tue, 18 Apr 2023 19:38:03 +0000
Message-ID: <78fe6617-2f5e-3e8e-d853-6dc8ffb5f82c@ddn.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|SJ0PR19MB4591:EE_
x-ms-office365-filtering-correlation-id: ea7cba09-ee61-4f33-6661-08db40446d2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b2Vun8NhWdndO9msWLbIfn4NtnL5/Axgi+ASZJW1vDEAnf2FbZANONq9/8clFieFqAdRNKN07JY8TQ0rvotm/E1OhcUChZQCorbmCNdI3TTRHQZ/6I5Tb2gAOzBuLRO0UR4aXKoFq7+9J353Skj6olf5lIejUZ5GhPCdWCD4pNEnoczVDSQ9GZRhIu8UqYwp+L9I0HLTVsucRuDzLjEXbwoOHmd30xeYD8su5UsG8ReUNl0u/KX2pxvSProqsN58aoYMA1bKOWseT78UYJXqz7Y4YoP+JdCFQhnQvqj3aItkzd+QvjrZBVF8sgYlMEW2kffUVKe1adl17JOSrfAhYiRdk7/C7P0VJsenollg93bL8avtRw1RfFOu2Wt6mUke7cesuVaOpzK8TqlfY2fU7tepyFpRWyJkyC9+g8ep1uKM6uNHz3dVeTd9XxLjtCKshg5DbmL5bBltlzcbebV8PKX0NW56VCxNOdDUhuv4r75152YhZx6VQ/7GRRMGsgksmYjatlYY4sokYoH12EhSCB7d6ZU0Lq41kk7syk8R6xW1L3lTDsWpvwGkTCnymQTjhtF6ueRFZ3lTIc9kVfPpZSWPIjWfv8stOTGqAD0H0OZVCThHRrcxXCJdXlXjZxE9HV6+Hr7DepnrB6hXjaB2WoegrjBwMgVmXqJe4edf4QI9cRikN45fqS/p7En8L66C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(136003)(376002)(366004)(346002)(396003)(451199021)(186003)(66899021)(6512007)(53546011)(6506007)(316002)(41300700001)(110136005)(122000001)(2616005)(66556008)(31696002)(66476007)(91956017)(64756008)(4326008)(66446008)(66946007)(7416002)(83380400001)(38100700002)(2906002)(38070700005)(86362001)(76116006)(5660300002)(31686004)(8936002)(8676002)(71200400001)(36756003)(6486002)(966005)(54906003)(478600001)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amg1Nys3VUxiWDBkcXVSWWd5ODh6TU9jTEdQN2hzQit0ZFhJcm95WHd4Sk80?=
 =?utf-8?B?SWZOZUFXa1NHQ0lLQXJHZkR3ek9yc2c3dzluektCQStxNm5YNkFTUnh1alJO?=
 =?utf-8?B?VGIzZnNtako5V0k4Ujh1ZlRmL1NrakQrdjNmVWp5bHJTTmd3b3pZdFFlbmlJ?=
 =?utf-8?B?dnE2K0ZVUVFrUE1PUVNaMUtHSGFWRTZwc2hoT3NWQnVYRW04WGZaNWgwWnFn?=
 =?utf-8?B?VldFbXBVZ3JjTkxuSllpOHcwRzA5aUhtK2FLQ3B1Q2hLTktBT0ZKcmxGUHVT?=
 =?utf-8?B?d2FTVldQY2NYR3pHZGhiU0FRUE4wS1JCZ0NqcXBhODYvbTNkbklRSzFCVHho?=
 =?utf-8?B?ME0wOEFJRGxsd1EyTDVHR2NjSi8xb0JjRGlqSnhFOXJkK1FLV2l5Skx0bWpr?=
 =?utf-8?B?OS94M2hOMnkxZ1NvNmV0dDlQSHArdTNqdlpMZjlVVnN0amRSZlBxNjR5YjRT?=
 =?utf-8?B?UnlQSkE0UDVQc1B0RHBwRmpoeDM1QmFzTGY3V3k2QjlKZUhOTExrd0hHNFlQ?=
 =?utf-8?B?SXpmeDZYM1NIdXpyam9vNEg0WG9SaXhvbmNONy95d2FUNnFYZE81SlBWOC9T?=
 =?utf-8?B?YlhHQXpwdjlJZVFwQlZPVXBOdjVwaENod3pvMmplQmliRXUzVG1PcUkxYUxC?=
 =?utf-8?B?WENpMTU5eHF3VFAwdFI0TGN2UG0vMjhSK3hMODlFamhOeVBVM2UvVHRLSjh1?=
 =?utf-8?B?UnN5ZUtNc3ZHZEVubVJHRDhLY1ZQc3o1VTlHTnlKQlhtWlY5ZWRZWHJVd2h0?=
 =?utf-8?B?OUxXT3pIQkh5UTdFdy92VjFBZ20rNnVpeEdIbHdEdVQ1TDNsYnkzM0RMcHU1?=
 =?utf-8?B?S3c5c3M4L2NHRmcwcWw2RlpEcWVWMXFMQXkrSGllWkpvUXh4MkZ1WnRJUmdK?=
 =?utf-8?B?bm5yeGhrb3FPMTdMTGV4dTg4NkFkajR0cGgzOWNPZ01ndi82NXdhY3FuT0hi?=
 =?utf-8?B?VlQrWnlDSVV3UTNHZVVCUnd5K2wyK0FhSThKQWhvOHFvemVDVmkwTFQvcmNk?=
 =?utf-8?B?dFFvczZnTU9iYklFM3NNcVhnRU9JRmVVM2xIbUkvMUN6MCtWNFJhQTRXKzVM?=
 =?utf-8?B?R0dsaDdUUytMckNwNzRFSzFoN2NUUVJYYkVhbFk1dlVBbGp4OThqOVZCdEwy?=
 =?utf-8?B?a1BrQklzZ09rTWpTcEtPcFp4K0dBdlBoRDR0cnRmYnFxUnpCM1dwTGYvTWo3?=
 =?utf-8?B?aEdtekt1TzJyVFh1VFpCTDBmM0pkMFBrRlY5QklsTkJ3MHBReEZ0SHBMMC9y?=
 =?utf-8?B?amVHUE5UY2szcGdvbVh1WGk5SFhVM2hTM0xYOEwrVStHSFo0VE8rM0hzYWZj?=
 =?utf-8?B?Y0VUUFFCSkZmaXFjV09nVmthZ0ZqM3p2YXJUT3JFVFdjUFVHZndjMEl5Q2hk?=
 =?utf-8?B?VW5QMjJHNVA5SWNrOGVyTm9uejhYSXlubjRMdlVBYnJXdjN6c3k2UldIYkdH?=
 =?utf-8?B?R1ZxaGEzKy96bDZHUFk4WHBhM0NDVGhIYWZhOGdZT21uOXROamdEdGZGMjVT?=
 =?utf-8?B?ZUxtQjdHNzdUWlVWQmhhTE1KT1J1MW10NXU1VjRZUHJSK1hSck0valhzR2k5?=
 =?utf-8?B?VHpMMGtzcW1KWXVsWmIyMEJGT0dIM0ZQTTZaSXBSc25LZjE2UHQ2WXIwQkEy?=
 =?utf-8?B?OGpiNWZ4YXQ4U04yQUoyTG9ydDU5YWVDWU1yWjUrVGMzSmRtR3NYUGFBckZM?=
 =?utf-8?B?ejdieWs2bnVEbGlyRzNNVXhEb3RQRjkzV0l4emZVaVd2K3poYmJJbjA3czZ6?=
 =?utf-8?B?OURpb3VCbFh1K0FacHdGeG81QnpTdnNXNmNQYnFsd2xlR2xqT21wanltN25V?=
 =?utf-8?B?eTdnZms2dDQvay9FUnR5ZVVKNXpaOVpra2IxS2t4VlF3K0NUM0pmd011eS9v?=
 =?utf-8?B?bXVLQkJuMlkyQVVoRW4rMjBmN01qSjlEUmVmTWx3QkxkT0ZySDZjdjJ6djNq?=
 =?utf-8?B?M2dvVmkydjVmb1JwY0dGTDRTOWo4S0hRSkhwTGM0dWU4TFBQcXB0cmNZdzEv?=
 =?utf-8?B?Nk9MdmpOQm5Rc3pIQ05MMndwNGFXZGQ5Nkg0OW1abEEwN21MdkRlb2x3M1By?=
 =?utf-8?B?K0JHVUNzQU5zam1YZE5oV2hWOGtJMjhxYkZFdzdKSFdYREpLOVM3UVkxSWJH?=
 =?utf-8?B?UldicVA2OUNjWi9aZlVOMGd1WTJvOGxDeHB3cTJYZ3hONitOdnJvQTdqUWZS?=
 =?utf-8?Q?gEHDuxL8CziegzVgm5RZPww=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A6E531BF29B544D85B6A0DE2F41C6B9@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7cba09-ee61-4f33-6661-08db40446d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 19:38:03.6324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wJmQZrIhFw3Ypvhzszgx2r+Wa5j82bFki56LRVWocxD/JfF/OLX+/ZHfELOoyZ0XTOgOKm6fCAYoydd1fVVMEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4591
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gMy8zMC8yMyAxMzozNiwgTWluZyBMZWkgd3JvdGU6DQpbLi4uXQ0KPiBWNjoNCj4gCS0gcmUt
ZGVzaWduIGZ1c2VkIGNvbW1hbmQsIGFuZCBtYWtlIGl0IG1vcmUgZ2VuZXJpYywgbW92aW5nIHNo
YXJpbmcgYnVmZmVyDQo+IAlhcyBvbmUgcGx1Z2luIG9mIGZ1c2VkIGNvbW1hbmQsIHNvIGluIGZ1
dHVyZSB3ZSBjYW4gaW1wbGVtZW50IG1vcmUgcGx1Z2lucw0KPiAJLSBkb2N1bWVudCBwb3RlbnRp
YWwgb3RoZXIgdXNlIGNhc2VzIG9mIGZ1c2VkIGNvbW1hbmQNCj4gCS0gZHJvcCBzdXBwb3J0IGZv
ciBidWlsdGluIHNlY29uZGFyeSBzcWUgaW4gU1FFMTI4LCBzbyBhbGwgc2Vjb25kYXJ5DQo+IAkg
IHJlcXVlc3RzIGhhcyBzdGFuZGFsb25lIFNRRQ0KPiAJLSBtYWtlIGZ1c2VkIGNvbW1hbmQgYXMg
b25lIGZlYXR1cmUNCj4gCS0gY2xlYW51cCAmIGltcHJvdmUgbmFtaW5nDQoNCkhpIE1pbmcsIGV0
IGFsLiwNCg0KSSBzdGFydGVkIHRvIHdvbmRlciBpZiBmdXNlZCBTUUUgY291bGQgYmUgZXh0ZW5k
ZWQgdG8gY29tYmluZSBtdWx0aXBsZSANCnN5c2NhbGxzLCBmb3IgZXhhbXBsZSBvcGVuL3JlYWQv
Y2xvc2UuICBXaGljaCB3b3VsZCBiZSBhbm90aGVyIHNvbHV0aW9uIA0KZm9yIHRoZSByZWFkZmls
ZSBzeXNjYWxsIE1pa2xvcyBoYWQgcHJvcG9zZWQgc29tZSB0aW1lIGFnby4NCg0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGttbC9DQUpmcGVndXNpOEJqV0Z6RWkwNTkyNmQ0UnNFUXZQblJXLXc3
TXk9aWJCSFE4TmdDdXdAbWFpbC5nbWFpbC5jb20vDQoNCklmIGZ1c2VkIFNRRXMgY291bGQgYmUg
ZXh0ZW5kZWQsIEkgdGhpbmsgaXQgd291bGQgYmUgcXVpdGUgaGVscGZ1bCBmb3IgDQptYW55IG90
aGVyIHBhdHRlcm5zLiBBbm90aGVyIHNpbWlsYXIgZXhhbXBsZXMgd291bGQgb3Blbi93cml0ZS9j
bG9zZSwgDQpidXQgaWRlYWwgd291bGQgYmUgYWxzbyB0byBhbGxvdyB0byBoYXZlIGl0IG1vcmUg
Y29tcGxleCBsaWtlIA0KIm9wZW4vd3JpdGUvc3luY19maWxlX3JhbmdlL2Nsb3NlIiAtIG9wZW4v
d3JpdGUvY2xvc2UgbWlnaHQgYmUgdGhlIA0KZmFzdGVzdCBhbmQgY291bGQgcG9zc2libHkgcmV0
dXJuIGJlZm9yZSBzeW5jX2ZpbGVfcmFuZ2UuIFVzZSBjYXNlIGZvciANCnRoZSBsYXR0ZXIgd291
bGQgYmUgYSBmaWxlIHNlcnZlciB0aGF0IHdhbnRzIHRvIGdpdmUgbm90aWZpY2F0aW9ucyB0byAN
CmNsaWVudCB3aGVuIHBhZ2VzIGhhdmUgYmVlbiB3cml0dGVuIG91dC4NCg0KDQpUaGFua3MsDQpC
ZXJuZA0K
