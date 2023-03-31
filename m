Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600D36D2575
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjCaQ2T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 12:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjCaQ2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 12:28:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4799727827;
        Fri, 31 Mar 2023 09:23:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auIyC0NWA/JKImOerF94bmV6ZEcjs6PfNwJG5XTpiyOKabg9WN/03KyIySNzwhl9cAGObBPSK6j0vamBiTgPRY72w9Nq/qyMexHrr7xCZ58umaX1A9RTRUrelI29A1Tz24+yLbAOivRDjm+cM4vO74yVJcuvy/+pq6A8f1qYvsZe01N7qY48PMddVIXb6jhTSR+kDJHHxbU+uJG9QH2A8HP9Zi1z7EuIiS5zPm1Zzdr4Qw6oLhnpkzXc7JLeSOJ1qA9LrVHJJtcT2tGKPRhydsrayu6y6qt91N2BuRqduWgzoY73ie4ofXGcrCWL9RTcOcFTh3VRm6rwZswwZ6oHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1m2yrD2BTsvQCzkLLpqh5zTMXggL42POcYYjoLEjm8=;
 b=RwZ2+RvD0Qb/nHBNNJSAIp0SkalNzzTnLCLV530YCINezOW0bqW/oPxWotobqZZ7zlRtuVwUyr52jJAH5p/xk8NvpEJEA83JjWK5np5p0qEf/eVbESSHCUClJYtQKC5vuyO5/83VAYau11juLII+s9XPxlJWLYEEry0B9iGfqch3YMFGb/V5CZH28NX+whZsp3RwM+ZZZtxhenPCm/IF8Tmk2E/bCDrHS6GdjltwIVnvjhV68JDOwPaMbJiDrLG2KvSK8KlyfCPun3pj0k5W9suVWxXtpKxnguktXJ3h1yMTB7ys/yKPX0iw6O61pUkC3bQIJ4FefcRUBrH7wowTkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1m2yrD2BTsvQCzkLLpqh5zTMXggL42POcYYjoLEjm8=;
 b=KgHKNPiuKrflqDQcT1cbvBh9aXET+nUAw/g7/lBywgsxIC0TA+SbLXx+UWhvf2RvtjF0IO/hoO45mhbhmKh/OZEgZCCNHk6JRSzVSOkXerGhBbxIYm2bQvYRRqJ0t37PKZ/D9jOsT4XzZ36dZGe8M32I4LBAnvnUiJBYKF2aZDg=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by CH2PR19MB3847.namprd19.prod.outlook.com (2603:10b6:610:a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 16:22:26 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::e6d4:29f7:2077:bd69]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::e6d4:29f7:2077:bd69%4]) with mapi id 15.20.6086.024; Fri, 31 Mar 2023
 16:22:26 +0000
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
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH V6 12/17] block: ublk_drv: cleanup ublk_copy_user_pages
Thread-Topic: [PATCH V6 12/17] block: ublk_drv: cleanup ublk_copy_user_pages
Thread-Index: AQHZYvwH/7QI8JjTYkiLLb86hx7DEa8VE/yA
Date:   Fri, 31 Mar 2023 16:22:26 +0000
Message-ID: <c40b04ac-408c-5575-e028-6a60ccb3430a@ddn.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <20230330113630.1388860-13-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-13-ming.lei@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|CH2PR19MB3847:EE_
x-ms-office365-filtering-correlation-id: 0c11de73-fef6-44db-6dd6-08db32041dac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y4fojep41rrJr7JFD+Qp+Xk6DWvUml2WtiPFpdOaDQxfBI5TToWm/Hz5x7AiqEtjzgan6CaelCZp3HrwEHCDFW6kQ14gZFN3YOdDhACYoWZKL8WSXjt5/3cqFdcnFA0Xct+pC6vkSyitJJtNLduWAzudpPkKdQVSK9aR/LjUwS+pG7WSB1qcu84D7MKReQ6aiyqVPGbbLoNRQao8odO/hYGu2tjJpj6KBSfDZmM8mfztaEdxhL8kfxuFP68uxqqa8F3fNRbfpymgeCM5xBciL8pXWmbcQ1DMi5aBb1vK8cTU1atj/tVh0ZbVM8jQ5r0q0qlEHNqp7xB+49aqeO/JUvPoAMVwQQGKj/8rcxt12aqCjeJbPy+9o82402UXUtT4xSmyEaGvVx6t2jcuHqyAHs+f+4hERQfs8lmJfDXddOotkla2pNsyCvXfT8ZnOCm83SIoK6h4s5o1GxePiB0k9QboBRa0ADulxtjzxkUBQRNkgh8KAlNQRTTQlYiKGhQZNcWBWgphZw/9l51sBFri0b7RehK3jL2d0VHjIslkKnR+L2FpSe9hvoi3wmktsfx/DteWrNas1ZLiFWLu+RdjqoVaw6AZQ0XJJo2ZTM++lgYWGuJcN0scjw4WzYNFoTeRdubCswNajksd0LkHji2Nli+W6sqDQE0P/F4EoW47pCr9MdtruxK2ePqfvTVOS4HN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(396003)(136003)(39850400004)(451199021)(31686004)(122000001)(83380400001)(7416002)(8936002)(5660300002)(2616005)(6506007)(186003)(2906002)(316002)(71200400001)(86362001)(31696002)(91956017)(53546011)(41300700001)(54906003)(66946007)(66556008)(36756003)(76116006)(478600001)(64756008)(66446008)(66476007)(8676002)(4326008)(6486002)(110136005)(6512007)(38100700002)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFhPK1lZT2R6NFFMVDNqbkZSd3J3bHF6elVEQWp1QkVKeXRmVmJUVUFZRjNI?=
 =?utf-8?B?SE84NmRTT01rcERFUHB1bCsyTng3cVZ6bHhBNDAzeUd5NEZZaGttV3JWQUc0?=
 =?utf-8?B?dXFiSzhmeU92dnIzWXFXZFB2QWtrenNZZXM1RFNUK1gzNDVKS2dRZjlQaHJs?=
 =?utf-8?B?czVSU1BpdksvaDdEY2ROc1RselErdnI0QmtEaEoxYmFmbVd1aWtiWWdKSDl4?=
 =?utf-8?B?S1BZVzFCL3J2bm4vNTBkVXI1MFFRdzU1ZlYxanJreHl5NERWd3FUd1pMVFVZ?=
 =?utf-8?B?ZzhUWnJabFNqNy8xMVJPQ0lhZTQwWnNwSDNmMmdmcmdsQWtwYzkxZUFPdUtK?=
 =?utf-8?B?RzdkMjlNbWJ1UCt5QktNdnk1amtIWGd4Wm51a0NveWNnN3J2dTI0ZkZiZ2gw?=
 =?utf-8?B?WnFjd3VhdXBpT0MyMExmMkIvb1ZHeHBIbkVHQkRVUEVJWGVlNk12WlFhVmRk?=
 =?utf-8?B?bUl0RGVrUjA0c2JVWGovUFdrQWkvRXBtek9KQTV1RlZXS2M1YTRUM1V6Nm5X?=
 =?utf-8?B?L1ltcHVwNG9Nb1hWWWdlTjlXUmxFVEkyTXp3UWlHcC9ORjRtUWRSd3RNNUhZ?=
 =?utf-8?B?eGFxTmtwU0Vaa2J4a3V0S0RhSnJnZEVBZnRpakVlUmFHZU1PMG0waUx0NGtr?=
 =?utf-8?B?WllTcDYyUGltMmg4d3NaMUFFOUdhZGl3dXpxQmphNXo4cWxHNS9QazUwZWlG?=
 =?utf-8?B?ZGpvTmZWb3MvMlhuTVJjUTQ4QkdTa1FTUHl2L3BuNHlVcU95bVJwOGlXc2JO?=
 =?utf-8?B?YXZmVlZVaEkwd3Rscm5DNmhDWkd1TjFQOTdHdWVtdjl6N0l0OUVtOHl4Q1Fs?=
 =?utf-8?B?WHc5OXdxN1FCdDV1UjZSVTlSODB2UFFhT2FkS0lsZFJzbWJmRzU1Tjhqemh3?=
 =?utf-8?B?NkZUZDNpeC9uWXI4c1RPeTRwSDV4UGVsZU44QWhGdGlCNnBNamRFeWV1enVu?=
 =?utf-8?B?aW1RUnlnaVZ2NFcrMndEanZ2Mkp0c3dVcGYzZk5nczZqUS90NzJlQkswQ0NI?=
 =?utf-8?B?WlFwTVRsK0x5NDF2bDI2MGs1OUdhemxGdWVhSkJHYzVUM25LQldzdVFuRTVM?=
 =?utf-8?B?SWlnSHMyZ3VaWFMzY0RWR0ZuamlmUmNTZHVWQ0tUUUtleW53bXFKZ0xnSzJJ?=
 =?utf-8?B?aFpGMm0xOEJjSC9jV3lLWVpIWXZDMGh4Y2ZWL2prNXJqOGRsMjIzcm1IdEQ5?=
 =?utf-8?B?SzJrRjl2ZnVUeDAzSENVbEkyclgwSVlzNzNTM2hWU3hOOEFYY0kvelk1RThs?=
 =?utf-8?B?bm1sd3pNWDJLVFNjNmF2aFRzUHAzL0ZjcXFOK3RtOHpROXJ0ZnBFYXVVVGxF?=
 =?utf-8?B?Y2lhd1NiYVZaVmg2cWdPalUwcXpPMnlIanV6bjg3aEVyK0VZRlczY3BmK3gw?=
 =?utf-8?B?d1VoUDFheWhFL3Ryc0JtNUlBY1YyRXQrWGNNYkZHL2lVcUJLeEZQRUljelN6?=
 =?utf-8?B?akZHVlIwb1RROHg4SDdVZS9JZGdTSGN5Ym9HN0hhaTBKUERLcjFCZXh3MWpG?=
 =?utf-8?B?ZzU3VjBmQS9YK3NRaUR2S1NoSzIrTU9iQWlDekxFVnFaMjZ2UUpFSy8xQ05C?=
 =?utf-8?B?aTE0bjh4RDVIdXlicUJ6OWQvcVk0TWFYSjhVQ0o4TnpZSy9tKzU3UTBESDNm?=
 =?utf-8?B?MTAvc2pWdzNzMW1YdkkyaXJ2cVdjdXBzOEg0emZQRHZvY01iNWVPZmJXYWR5?=
 =?utf-8?B?MHpjQk1xd1lzWFVLVm1xc3l1Z3hrRndydm95Wm15VHkyOGxNc3drajJnTDVQ?=
 =?utf-8?B?L2ttVVNXTDBVaFV5Q0VvMkd3bkcxMlUvTmFJM05QeWFjdjIrTkk2N3dnUWhS?=
 =?utf-8?B?bEU2NGJ4ZnBzMldmV2FtdjgyT055T1I0THVaTStzYnJsRDU5V1pMK0UrVzhL?=
 =?utf-8?B?M0xWNkpvWHloa3NYRGZXWGllOWNEalVBVlpMUWF5NTdxZU00VkE2VldxTUVI?=
 =?utf-8?B?ZnBhdXpVNVhyVkNvSmVyL2Uxb1NWRlhhOERjN3hnbnJQYU5YeTlldDZwVnVy?=
 =?utf-8?B?Rm55UGpsQWdmT3NjR0FOSG03Uk5SRVZScURuVWkxSTZrZ0ZNT2pDTUxWSzY1?=
 =?utf-8?B?TUE2OVhnS29mdzRBelo1dnZFV24yYU5XMUw3QnJJYmhiTWZmcmhDcGFIN1Fj?=
 =?utf-8?B?M2FSQkRDR2o0MmhxeGxKNXF4T2p4aGM2ZzhUbUNZR0RtT3p2bVJmcTdOVjV0?=
 =?utf-8?Q?sqaXMZN86VQXCxstITGZgHs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C3EADECDB15BA4CA1BCCCF50D321B05@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c11de73-fef6-44db-6dd6-08db32041dac
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 16:22:26.1842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yleRPsy63aKENpPkm3cudhsVmnKAuV9X2nl6v8f004MCFMeRdK4RDrTy5+7B9hvJWfvsEOC5XEMuayIpC/+X2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR19MB3847
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gMy8zMC8yMyAxMzozNiwgTWluZyBMZWkgd3JvdGU6DQo+IENsZWFuIHVwIHVibGtfY29weV91
c2VyX3BhZ2VzKCkgYnkgdXNpbmcgaW92IGl0ZXIsIGFuZCBjb2RlDQo+IGdldHMgc2ltcGxpZmll
ZCBhIGxvdCBhbmQgYmVjb21lcyBtdWNoIG1vcmUgcmVhZGFibGUgdGhhbiBiZWZvcmUuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBNaW5nIExlaSA8bWluZy5sZWlAcmVkaGF0LmNvbT4NCj4gLS0tDQo+
ICAgZHJpdmVycy9ibG9jay91YmxrX2Rydi5jIHwgMTEyICsrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA0OSBpbnNlcnRpb25zKCspLCA2
MyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL3VibGtfZHJ2
LmMgYi9kcml2ZXJzL2Jsb2NrL3VibGtfZHJ2LmMNCj4gaW5kZXggZmRjY2JmNWZkYWExLi5jY2Ew
ZTk1YTg5ZDggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvYmxvY2svdWJsa19kcnYuYw0KPiArKysg
Yi9kcml2ZXJzL2Jsb2NrL3VibGtfZHJ2LmMNCj4gQEAgLTQxOSw0OSArNDE5LDM5IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgYmxvY2tfZGV2aWNlX29wZXJhdGlvbnMgdWJfZm9wcyA9IHsNCj4gICAN
Cj4gICAjZGVmaW5lIFVCTEtfTUFYX1BJTl9QQUdFUwkzMg0KPiAgIA0KPiAtc3RydWN0IHVibGtf
bWFwX2RhdGEgew0KPiAtCWNvbnN0IHN0cnVjdCByZXF1ZXN0ICpycTsNCj4gLQl1bnNpZ25lZCBs
b25nCXVidWY7DQo+IC0JdW5zaWduZWQgaW50CWxlbjsNCj4gLX07DQo+IC0NCj4gICBzdHJ1Y3Qg
dWJsa19pb19pdGVyIHsNCj4gICAJc3RydWN0IHBhZ2UgKnBhZ2VzW1VCTEtfTUFYX1BJTl9QQUdF
U107DQo+IC0JdW5zaWduZWQgcGdfb2ZmOwkvKiBvZmZzZXQgaW4gdGhlIDFzdCBwYWdlIGluIHBh
Z2VzICovDQo+IC0JaW50IG5yX3BhZ2VzOwkJLyogaG93IG1hbnkgcGFnZSBwb2ludGVycyBpbiBw
YWdlcyAqLw0KPiAgIAlzdHJ1Y3QgYmlvICpiaW87DQo+ICAgCXN0cnVjdCBidmVjX2l0ZXIgaXRl
cjsNCj4gICB9Ow0KPiAgIA0KPiAtc3RhdGljIGlubGluZSB1bnNpZ25lZCB1YmxrX2NvcHlfaW9f
cGFnZXMoc3RydWN0IHVibGtfaW9faXRlciAqZGF0YSwNCj4gLQkJdW5zaWduZWQgbWF4X2J5dGVz
LCBib29sIHRvX3ZtKQ0KPiArLyogcmV0dXJuIGhvdyBtYW55IHBhZ2VzIGFyZSBjb3BpZWQgKi8N
Cj4gK3N0YXRpYyB2b2lkIHVibGtfY29weV9pb19wYWdlcyhzdHJ1Y3QgdWJsa19pb19pdGVyICpk
YXRhLA0KPiArCQlzaXplX3QgdG90YWwsIHNpemVfdCBwZ19vZmYsIGludCBkaXIpDQo+ICAgew0K
PiAtCWNvbnN0IHVuc2lnbmVkIHRvdGFsID0gbWluX3QodW5zaWduZWQsIG1heF9ieXRlcywNCj4g
LQkJCVBBR0VfU0laRSAtIGRhdGEtPnBnX29mZiArDQo+IC0JCQkoKGRhdGEtPm5yX3BhZ2VzIC0g
MSkgPDwgUEFHRV9TSElGVCkpOw0KPiAgIAl1bnNpZ25lZCBkb25lID0gMDsNCj4gICAJdW5zaWdu
ZWQgcGdfaWR4ID0gMDsNCj4gICANCj4gICAJd2hpbGUgKGRvbmUgPCB0b3RhbCkgew0KPiAgIAkJ
c3RydWN0IGJpb192ZWMgYnYgPSBiaW9faXRlcl9pb3ZlYyhkYXRhLT5iaW8sIGRhdGEtPml0ZXIp
Ow0KPiAtCQljb25zdCB1bnNpZ25lZCBpbnQgYnl0ZXMgPSBtaW4zKGJ2LmJ2X2xlbiwgdG90YWwg
LSBkb25lLA0KPiAtCQkJCSh1bnNpZ25lZCkoUEFHRV9TSVpFIC0gZGF0YS0+cGdfb2ZmKSk7DQo+
ICsJCXVuc2lnbmVkIGludCBieXRlcyA9IG1pbjMoYnYuYnZfbGVuLCAodW5zaWduZWQpdG90YWwg
LSBkb25lLA0KPiArCQkJCSh1bnNpZ25lZCkoUEFHRV9TSVpFIC0gcGdfb2ZmKSk7DQo+ICAgCQl2
b2lkICpidl9idWYgPSBidmVjX2ttYXBfbG9jYWwoJmJ2KTsNCj4gICAJCXZvaWQgKnBnX2J1ZiA9
IGttYXBfbG9jYWxfcGFnZShkYXRhLT5wYWdlc1twZ19pZHhdKTsNCj4gICANCj4gLQkJaWYgKHRv
X3ZtKQ0KPiAtCQkJbWVtY3B5KHBnX2J1ZiArIGRhdGEtPnBnX29mZiwgYnZfYnVmLCBieXRlcyk7
DQo+ICsJCWlmIChkaXIgPT0gSVRFUl9ERVNUKQ0KPiArCQkJbWVtY3B5KHBnX2J1ZiArIHBnX29m
ZiwgYnZfYnVmLCBieXRlcyk7DQo+ICAgCQllbHNlDQo+IC0JCQltZW1jcHkoYnZfYnVmLCBwZ19i
dWYgKyBkYXRhLT5wZ19vZmYsIGJ5dGVzKTsNCj4gKwkJCW1lbWNweShidl9idWYsIHBnX2J1ZiAr
IHBnX29mZiwgYnl0ZXMpOw0KPiAgIA0KPiAgIAkJa3VubWFwX2xvY2FsKHBnX2J1Zik7DQo+ICAg
CQlrdW5tYXBfbG9jYWwoYnZfYnVmKTsNCj4gICANCj4gICAJCS8qIGFkdmFuY2UgcGFnZSBhcnJh
eSAqLw0KPiAtCQlkYXRhLT5wZ19vZmYgKz0gYnl0ZXM7DQo+IC0JCWlmIChkYXRhLT5wZ19vZmYg
PT0gUEFHRV9TSVpFKSB7DQo+ICsJCXBnX29mZiArPSBieXRlczsNCj4gKwkJaWYgKHBnX29mZiA9
PSBQQUdFX1NJWkUpIHsNCj4gICAJCQlwZ19pZHggKz0gMTsNCj4gLQkJCWRhdGEtPnBnX29mZiA9
IDA7DQo+ICsJCQlwZ19vZmYgPSAwOw0KPiAgIAkJfQ0KPiAgIA0KPiAgIAkJZG9uZSArPSBieXRl
czsNCj4gQEAgLTQ3NSw0MSArNDY1LDQwIEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgdWJsa19j
b3B5X2lvX3BhZ2VzKHN0cnVjdCB1YmxrX2lvX2l0ZXIgKmRhdGEsDQo+ICAgCQkJZGF0YS0+aXRl
ciA9IGRhdGEtPmJpby0+YmlfaXRlcjsNCj4gICAJCX0NCj4gICAJfQ0KPiAtDQo+IC0JcmV0dXJu
IGRvbmU7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIGludCB1YmxrX2NvcHlfdXNlcl9wYWdlcyhz
dHJ1Y3QgdWJsa19tYXBfZGF0YSAqZGF0YSwgYm9vbCB0b192bSkNCj4gKy8qDQo+ICsgKiBDb3B5
IGRhdGEgYmV0d2VlbiByZXF1ZXN0IHBhZ2VzIGFuZCBpb19pdGVyLCBhbmQgJ29mZnNldCcNCj4g
KyAqIGlzIHRoZSBzdGFydCBwb2ludCBvZiBsaW5lYXIgb2Zmc2V0IG9mIHJlcXVlc3QuDQo+ICsg
Ki8NCj4gK3N0YXRpYyBzaXplX3QgdWJsa19jb3B5X3VzZXJfcGFnZXMoY29uc3Qgc3RydWN0IHJl
cXVlc3QgKnJlcSwNCj4gKwkJc3RydWN0IGlvdl9pdGVyICp1aXRlciwgaW50IGRpcikNCj4gICB7
DQo+IC0JY29uc3QgdW5zaWduZWQgaW50IGd1cF9mbGFncyA9IHRvX3ZtID8gRk9MTF9XUklURSA6
IDA7DQo+IC0JY29uc3QgdW5zaWduZWQgbG9uZyBzdGFydF92bSA9IGRhdGEtPnVidWY7DQo+IC0J
dW5zaWduZWQgaW50IGRvbmUgPSAwOw0KPiAgIAlzdHJ1Y3QgdWJsa19pb19pdGVyIGl0ZXIgPSB7
DQo+IC0JCS5wZ19vZmYJPSBzdGFydF92bSAmIChQQUdFX1NJWkUgLSAxKSwNCj4gLQkJLmJpbwk9
IGRhdGEtPnJxLT5iaW8sDQo+IC0JCS5pdGVyCT0gZGF0YS0+cnEtPmJpby0+YmlfaXRlciwNCj4g
KwkJLmJpbwk9IHJlcS0+YmlvLA0KPiArCQkuaXRlcgk9IHJlcS0+YmlvLT5iaV9pdGVyLA0KPiAg
IAl9Ow0KPiAtCWNvbnN0IHVuc2lnbmVkIGludCBucl9wYWdlcyA9IHJvdW5kX3VwKGRhdGEtPmxl
biArDQo+IC0JCQkoc3RhcnRfdm0gJiAoUEFHRV9TSVpFIC0gMSkpLCBQQUdFX1NJWkUpID4+IFBB
R0VfU0hJRlQ7DQo+IC0NCj4gLQl3aGlsZSAoZG9uZSA8IG5yX3BhZ2VzKSB7DQo+IC0JCWNvbnN0
IHVuc2lnbmVkIHRvX3BpbiA9IG1pbl90KHVuc2lnbmVkLCBVQkxLX01BWF9QSU5fUEFHRVMsDQo+
IC0JCQkJbnJfcGFnZXMgLSBkb25lKTsNCj4gLQkJdW5zaWduZWQgaSwgbGVuOw0KPiAtDQo+IC0J
CWl0ZXIubnJfcGFnZXMgPSBnZXRfdXNlcl9wYWdlc19mYXN0KHN0YXJ0X3ZtICsNCj4gLQkJCQko
ZG9uZSA8PCBQQUdFX1NISUZUKSwgdG9fcGluLCBndXBfZmxhZ3MsDQo+IC0JCQkJaXRlci5wYWdl
cyk7DQo+IC0JCWlmIChpdGVyLm5yX3BhZ2VzIDw9IDApDQo+IC0JCQlyZXR1cm4gZG9uZSA9PSAw
ID8gaXRlci5ucl9wYWdlcyA6IGRvbmU7DQo+IC0JCWxlbiA9IHVibGtfY29weV9pb19wYWdlcygm
aXRlciwgZGF0YS0+bGVuLCB0b192bSk7DQo+IC0JCWZvciAoaSA9IDA7IGkgPCBpdGVyLm5yX3Bh
Z2VzOyBpKyspIHsNCj4gLQkJCWlmICh0b192bSkNCj4gKwlzaXplX3QgZG9uZSA9IDA7DQo+ICsN
Cj4gKwl3aGlsZSAoaW92X2l0ZXJfY291bnQodWl0ZXIpICYmIGl0ZXIuYmlvKSB7DQo+ICsJCXVu
c2lnbmVkIG5yX3BhZ2VzOw0KPiArCQlzaXplX3QgbGVuLCBvZmY7DQo+ICsJCWludCBpOw0KPiAr
DQo+ICsJCWxlbiA9IGlvdl9pdGVyX2dldF9wYWdlczIodWl0ZXIsIGl0ZXIucGFnZXMsDQo+ICsJ
CQkJaW92X2l0ZXJfY291bnQodWl0ZXIpLA0KPiArCQkJCVVCTEtfTUFYX1BJTl9QQUdFUywgJm9m
Zik7DQo+ICsJCWlmIChsZW4gPD0gMCkNCj4gKwkJCXJldHVybiBkb25lOw0KPiArDQo+ICsJCXVi
bGtfY29weV9pb19wYWdlcygmaXRlciwgbGVuLCBvZmYsIGRpcik7DQo+ICsJCW5yX3BhZ2VzID0g
RElWX1JPVU5EX1VQKGxlbiArIG9mZiwgUEFHRV9TSVpFKTsNCj4gKwkJZm9yIChpID0gMDsgaSA8
IG5yX3BhZ2VzOyBpKyspIHsNCj4gKwkJCWlmIChkaXIgPT0gSVRFUl9ERVNUKQ0KPiAgIAkJCQlz
ZXRfcGFnZV9kaXJ0eShpdGVyLnBhZ2VzW2ldKTsNCj4gICAJCQlwdXRfcGFnZShpdGVyLnBhZ2Vz
W2ldKTsNCj4gICAJCX0NCj4gLQkJZGF0YS0+bGVuIC09IGxlbjsNCj4gLQkJZG9uZSArPSBpdGVy
Lm5yX3BhZ2VzOw0KPiArCQlkb25lICs9IGxlbjsNCj4gICAJfQ0KPiAgIA0KPiAgIAlyZXR1cm4g
ZG9uZTsNCj4gQEAgLTUzNiwxNSArNTI1LDE0IEBAIHN0YXRpYyBpbnQgdWJsa19tYXBfaW8oY29u
c3Qgc3RydWN0IHVibGtfcXVldWUgKnVicSwgY29uc3Qgc3RydWN0IHJlcXVlc3QgKnJlcSwNCj4g
ICAJICogY29udGV4dCBpcyBwcmV0dHkgZmFzdCwgc2VlIHVibGtfcGluX3VzZXJfcGFnZXMNCj4g
ICAJICovDQo+ICAgCWlmICh1YmxrX25lZWRfbWFwX3JlcShyZXEpKSB7DQo+IC0JCXN0cnVjdCB1
YmxrX21hcF9kYXRhIGRhdGEgPSB7DQo+IC0JCQkucnEJPQlyZXEsDQo+IC0JCQkudWJ1Zgk9CWlv
LT5hZGRyLA0KPiAtCQkJLmxlbgk9CXJxX2J5dGVzLA0KPiAtCQl9Ow0KPiArCQlzdHJ1Y3QgaW92
X2l0ZXIgaXRlcjsNCj4gKwkJc3RydWN0IGlvdmVjIGlvdjsNCj4gKwkJY29uc3QgaW50IGRpciA9
IElURVJfREVTVDsNCg0KTWF5YmUgYSBjb21tZW50IGhlcmUgdGhhdCB0aGlzIG1lYW5zICJjb3B5
IHRvIGRhZW1vbiI/DQoNCj4gICANCj4gLQkJdWJsa19jb3B5X3VzZXJfcGFnZXMoJmRhdGEsIHRy
dWUpOw0KPiArCQlpbXBvcnRfc2luZ2xlX3JhbmdlKGRpciwgdTY0X3RvX3VzZXJfcHRyKGlvLT5h
ZGRyKSwgcnFfYnl0ZXMsDQo+ICsJCQkJJmlvdiwgJml0ZXIpOw0KPiAgIA0KPiAtCQlyZXR1cm4g
cnFfYnl0ZXMgLSBkYXRhLmxlbjsNCj4gKwkJcmV0dXJuIHVibGtfY29weV91c2VyX3BhZ2VzKHJl
cSwgJml0ZXIsIGRpcik7DQo+ICAgCX0NCj4gICAJcmV0dXJuIHJxX2J5dGVzOw0KPiAgIH0NCj4g
QEAgLTU1NiwxNyArNTQ0LDE1IEBAIHN0YXRpYyBpbnQgdWJsa191bm1hcF9pbyhjb25zdCBzdHJ1
Y3QgdWJsa19xdWV1ZSAqdWJxLA0KPiAgIAljb25zdCB1bnNpZ25lZCBpbnQgcnFfYnl0ZXMgPSBi
bGtfcnFfYnl0ZXMocmVxKTsNCj4gICANCj4gICAJaWYgKHVibGtfbmVlZF91bm1hcF9yZXEocmVx
KSkgew0KPiAtCQlzdHJ1Y3QgdWJsa19tYXBfZGF0YSBkYXRhID0gew0KPiAtCQkJLnJxCT0JcmVx
LA0KPiAtCQkJLnVidWYJPQlpby0+YWRkciwNCj4gLQkJCS5sZW4JPQlpby0+cmVzLA0KPiAtCQl9
Ow0KPiArCQlzdHJ1Y3QgaW92X2l0ZXIgaXRlcjsNCj4gKwkJc3RydWN0IGlvdmVjIGlvdjsNCj4g
KwkJY29uc3QgaW50IGRpciA9IElURVJfU09VUkNFOw0KDQpBbmQgaGVyZSAiZnJvbSBkYWVtb24i
Pw0KPiAgIA0KPiAgIAkJV0FSTl9PTl9PTkNFKGlvLT5yZXMgPiBycV9ieXRlcyk7DQo+ICAgDQo+
IC0JCXVibGtfY29weV91c2VyX3BhZ2VzKCZkYXRhLCBmYWxzZSk7DQo+IC0NCj4gLQkJcmV0dXJu
IGlvLT5yZXMgLSBkYXRhLmxlbjsNCj4gKwkJaW1wb3J0X3NpbmdsZV9yYW5nZShkaXIsIHU2NF90
b191c2VyX3B0cihpby0+YWRkciksIGlvLT5yZXMsDQo+ICsJCQkJJmlvdiwgJml0ZXIpOw0KPiAr
CQlyZXR1cm4gdWJsa19jb3B5X3VzZXJfcGFnZXMocmVxLCAmaXRlciwgZGlyKTsNCj4gICAJfQ0K
PiAgIAlyZXR1cm4gcnFfYnl0ZXM7DQo+ICAgfQ0KDQo=
