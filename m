Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248066F8BB5
	for <lists+io-uring@lfdr.de>; Fri,  5 May 2023 23:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjEEV57 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 May 2023 17:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjEEV56 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 May 2023 17:57:58 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA7B270C;
        Fri,  5 May 2023 14:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD8rPUSZTrlp3d4eGW6AuAdkH04X2fTYzX1JvXke6fTMz10wxZMVLJQGY5baMmHiMChF5GbhudwMhJnOA8If6CiqDQWg2g1Aw52kDzpMmgZpQTnKqsvgwtOm9qjBzEqNf7dxTc/UZdBcGp+4cdDTcaJ7jSs9Yq0akw+39RdWw+oOy0ff7J78SNC6RWb3P8Lyhsj1026LgoYC+xTFY57LQ8KY5ZVOnLRwLifLQO5jD/pTtPdmK4++1lpYk2amHYXq4uUxttrlrphikQEZr4RPQiyk1PkG/tnnnJZnAs7d+9BFxbe06xsqKY/z/h7gk8KDYWvvEYWQ24HiHJk+0p4K2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWHb5DpfHjo5KxRaDjK7kwqPkL0pncG9Mp/GqHjmnD0=;
 b=VoLqKbmZZxtcFX+8XXIvOBPslLWGhg749G0Fh57C+UZXzFc6wb0luOJpcRIWfDm89KOvrV9cBEBeQeHogb/r0TMHX4OU1SMIGZ1GGfJkHAMREWeJNsQ73XeBLVT7dfahzSnGKbT8Xlmkjoj9lfC6nbMsGme28d/UYBCZWwSznIabXxf6EZUbUMZgdwFaTGWQr1s/oA9NpCyEtJ4GbKZWSOVNdSgnlHkoshmIMyOdDWnHwmiFFRfTHiGma00PZ/qT4+Ys184IHkFoUrrUKHTW+Psz99UXuDs465SE8MNPHV0IHUXcSVHhebg19VizQbFMszHitxk4IZq2fyZBvlY7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWHb5DpfHjo5KxRaDjK7kwqPkL0pncG9Mp/GqHjmnD0=;
 b=ZOIXSAsfl2MvdpZyihWaQCP9v9no9JV/CLS9ULAcaI9QZNM9qhPXQtBW0e8zmtBcUmRq/0vdlbuQ7Gq6URopchWgO+XmnbRo5m2T+JdJZEYPZhEgF8CIDjIl4XGOGOwCDE8ZBaxvShGWMEEypN4YlgyrqZV80k28Fkb272ODpjM=
Received: from MW2PR1901MB2041.namprd19.prod.outlook.com
 (2603:10b6:302:12::15) by CY8PR19MB6940.namprd19.prod.outlook.com
 (2603:10b6:930:5f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.11; Fri, 5 May
 2023 21:57:48 +0000
Received: from MW2PR1901MB2041.namprd19.prod.outlook.com
 ([fe80::70cb:42fc:67e4:9760]) by MW2PR1901MB2041.namprd19.prod.outlook.com
 ([fe80::70cb:42fc:67e4:9760%4]) with mapi id 15.20.6387.011; Fri, 5 May 2023
 21:57:47 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
CC:     "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] ublk & io_uring: ublk zero copy support
Thread-Topic: [LSF/MM/BPF TOPIC] ublk & io_uring: ublk zero copy support
Thread-Index: AQHZekD8AQGxov3NO0Gxx1s78qdhgq9MRL4A
Date:   Fri, 5 May 2023 21:57:47 +0000
Message-ID: <41cfb9c2-9774-e9e1-d8e7-4999a710f2e7@ddn.com>
References: <ZEx+h/iFf46XiWG1@ovpn-8-24.pek2.redhat.com>
In-Reply-To: <ZEx+h/iFf46XiWG1@ovpn-8-24.pek2.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR1901MB2041:EE_|CY8PR19MB6940:EE_
x-ms-office365-filtering-correlation-id: aaf1ef33-0880-4770-cba0-08db4db3c350
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OhGL4Zug5q/D5EVH8ZbYTd1X5yBCgd1CAQuYoJoJGjLBoPC8uQjWdxOOBJ791btGQ2AfYAN0oXOHDQgYV/DycJLuvysdXl7XOKfGMNYq9OrF89xFDkpKbmGFlTstLrE4lGWb9YwAW/OsGjnM/7sXbHRWPjOEJt5QK5n/rTXfuMx0NTq86yDC77dtvCWS/UirgrloNlvCQeB/+5dwiVSHKkhgkJBH4GxOD6JSEdSysxivkujAdOLPhOlfG09s0r9iwzcQR0Q4Tzt5MaXIXGHVk9Enm+LMzTbog18lsgZf0rNp1Kj45HRcgZHyMDSZm/4q59QS7YPHm8SwOPyXYOrIN6B+MAr6BcAGL/RNhYAHlqP8Vnr6DUYDrTtIjKVi9ag1P1PGmNe3Z9/YnkP/NSa6tzypJ6uKstrlUnI5cOnzCFz/UZ1OicrJ6jWdOySnSR9CC+ELCO3HI+Y+ZeqSgGd1fC3B1i2KXkF6DayCh+m1gHAw/d3IoJP2lJ2hlCDqeDNzBsEJ//ZaB6yi5lbPDoUUG7EzIi9sRS+sSW94DthbJcvHr7MjxuImTAoyoJOMUs+Dm9BXxjNhkku+/y+C79Ow28byFRLF4CSzAFVjypk51z+3NXlkPCxPcQTyvpPrZHhenhWT+iJ+NhkOTwiWagRpcyK1GjIvF3EGlGdZCjlZ+fr+m7GVMTF6LSSxx1ggSURrImzAdqAqvax/mlOK8ywcGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR1901MB2041.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39850400004)(346002)(366004)(376002)(396003)(451199021)(5660300002)(8936002)(8676002)(7416002)(83380400001)(6512007)(2616005)(186003)(31696002)(122000001)(53546011)(38100700002)(86362001)(38070700005)(6506007)(66556008)(66476007)(64756008)(66446008)(76116006)(36756003)(91956017)(4326008)(316002)(66946007)(41300700001)(966005)(71200400001)(6486002)(478600001)(54906003)(2906002)(110136005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTdDK2VhWUFSM08yblh4R29NQlNDTjRyS0hnZmtPWWhxNUhCNDBzK2NudGYr?=
 =?utf-8?B?d3pXaWljVlUzMEFKQjdydnV5d2tzc2FYQUx0UHBkVlVvTXpzUkFXSml1elR1?=
 =?utf-8?B?eXNFVGJnVGVvMmxxS1lRWFYrTWNKRzUzVmo2c0ZyY3BpMFo3WHpKT0ZSTGRQ?=
 =?utf-8?B?eCtjOWhPMU5kTG0ydUk1azQ3Q3JwWTNQQmNMMG9MWDhFaEIySEFRZVZGb0ZC?=
 =?utf-8?B?eWpEN2FrVUtvZjBick4wb0E2L2FHNFI1dUtXZ20vZ3pRQ296Y0Z0cjVYZzg3?=
 =?utf-8?B?RHMzQkJscGpWMzFEOEVpY0Y1L3QzVHNId091YTNydzhWLys2VXFsTUNnV3Zz?=
 =?utf-8?B?N0hTczZhRjRxOWNodnlaVTY4cytCcTVPVGJ4UGdMK1hEQWhnejJZSEJiM2Vh?=
 =?utf-8?B?NFJaYjFXSkFkK280NE9SbmFHRTFoZGI2RXpzT2RiQ0I5UFo5K0xyeTIzTHFL?=
 =?utf-8?B?T1FZR1A1akludmlMUVlvRzd2djZwbXBJT3NrTUZhdmJHbFRpQk5lNE5VeTFz?=
 =?utf-8?B?Y0FUcWNUUzBtV0JPZ3o0aE9pZDcxR1hTcC9rUGZ5L245MDg5TDI0a3dJY1Zs?=
 =?utf-8?B?bHF3NDJhR3RabmhPUksrOFhtaGh5M1hkdjl1N0x1NnVhdWlMZzd3VW5UTnRR?=
 =?utf-8?B?cUJjSTE2bkVMTFpQcWdHZDIxYnIvbFk4VzdQVkNLVFl2MkZ0ZGdKV05LN04r?=
 =?utf-8?B?VHpmVTA4VlEyeUtIak9uOFp6L2ZNb21MejRoNU10bFU5S3ZJQ0lWc0RGNkg0?=
 =?utf-8?B?eXpBU2xlcTNITExJdktON2hEZk9WY2tuRDVLR1dEOFB3NTl0YkpRbFU1c0hl?=
 =?utf-8?B?cERiV3BiaCtVQjd5b0JIU3FacTg4clpSMk1CYy9JUjN1ZkkyUFgycmI2ZjJz?=
 =?utf-8?B?VkNGWU5tWThsQU44YnJHRFJJUTNndXpVQit3SUJJd3JscWNKZ2tNRm1DTVFV?=
 =?utf-8?B?KzROK3V5TnhNVEx6bW0vZnVrKzNwZkRUTzBiTW9ic0k0dm1RSWlibDdRSHM0?=
 =?utf-8?B?OGZXYmlFNng1RnZ2LzBneGdZa3ZyTUJ0ekJMTDl3Sml1dkxJTVVkV1lFcWxZ?=
 =?utf-8?B?QWY1aHlUeVRPUm1HU2phMDU1WVVXNGJZU2RhU1UyZWt0NXYvWXJZak52VCtk?=
 =?utf-8?B?Wnk5UEpicTU3S2JxV2dPVXhpcUY3ejNkTURBLzQwLzdYUktZZW1NZ3ltSzc4?=
 =?utf-8?B?OGFKWENmcEhvcS94QzUvbmMycTFEK21lSlp6K0p3VmIwSnFTTFhva3pXamJK?=
 =?utf-8?B?b3BmZ2hMWEV3OGREVENGaC9XUXg3dTd4R0RFMWZ3Um0rZ0dWWWtITThHbWNZ?=
 =?utf-8?B?MzlBZ1QxUGloUE1XVVhWUzg0S1RjcDNOajVFTXk3WTRtYnRwUDYzczNkdURY?=
 =?utf-8?B?VXJ4QVNCUWxoakVKb1ByeVA1ZzNhMUpJdE5YV2ZLLzlOUGxHYzg0bURzZmdo?=
 =?utf-8?B?ZHNwUVVsWFZRWEExbk1HdlgzQ1l2TDltaXJKQkM5TThtUTZLdzIrZTV0SjY3?=
 =?utf-8?B?MEt4SFhBNmxid1V0WlFkaEc2TThuZE4vKzV3bXRVNVZRc3RYaGRVSVpQRDAx?=
 =?utf-8?B?czVZMlJVL1RNd2NPdStuZkx0NGkwNllCeVUxSENIMjZEeXBsQW8vMVVKa0VQ?=
 =?utf-8?B?MEdIbkhLaTMyZFNnbzFlWkxqWFZGd3hBRFNSWTh2bmdGVzFaYXBsV0o3VnlQ?=
 =?utf-8?B?YmpYQTFrRkprWmhGZGpGRVZhQXEyK2NZTXdsWFoxUmg3cGx5NWtFL2dsZTRr?=
 =?utf-8?B?MFZ2Z01zOVN6bVZjcmQvczdjYUNPT2RqZW9UQktvQlJBUm5sTENsbFJDbW92?=
 =?utf-8?B?Ty9sREFTemlReU40MjVUN2RCcStnMkdROEpTQzZtUWg5ZVpmSmFsTklnV3Jk?=
 =?utf-8?B?YlUySmdYRndoODRUTTd0MVExb09QekVWQWpxV2FTZlJOamV3UG8yenkrU0VB?=
 =?utf-8?B?VXRTUjdUYVRuQzJLOHZnUld0c1huRDNpelQ2TXZoRkN2VVMvWmp1YkZxWkc0?=
 =?utf-8?B?Szg2YlVPd3d5N3hKSVdQaWU1NWJWKzdnOHNpbG5vNFgzbWVoN3o3N3lmUHBi?=
 =?utf-8?B?SkFudmlXUEErK3FpT1VTd1RzVGtIOFo5Ky94YTluVmZ0djBRbjZ1eTZmVHc3?=
 =?utf-8?B?VEtxdFdLTFdveWxkc3Q3RGJyL2xqMlVoTmJFNjRHbWlQeUtZbjZjNUR2MHZu?=
 =?utf-8?Q?M/o47Cf5cy42ZjCzgn8kWe8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CC6BF464C40C946A119AF029022FB4E@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR1901MB2041.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf1ef33-0880-4770-cba0-08db4db3c350
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 21:57:47.3925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y++SE6NOrvzB8tO9BtvjRM1FJH+bmM99QEPqNVpARLSJdj56pMeE9pYyCrJBqWiQGV7LU9YC/IprZKVAsEnHsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR19MB6940
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGkgTWluZywNCg0KT24gNC8yOS8yMyAwNDoxOCwgTWluZyBMZWkgd3JvdGU6DQo+IEhlbGxvLA0K
PiANCj4gdWJsayB6ZXJvIGNvcHkgaXMgb2JzZXJ2ZWQgdG8gaW1wcm92ZSBiaWcgY2h1bmsoNjRL
QispIHNlcXVlbnRpYWwgSU8gcGVyZm9ybWFuY2UgYQ0KPiBsb3QsIHN1Y2ggYXMsIElPUFMgb2Yg
dWJsay1sb29wIG92ZXIgdG1wZnMgaXMgaW5jcmVhc2VkIGJ5IDF+MlhbMV0sIEplbnMgYWxzbyBv
YnNlcnZlZA0KPiB0aGF0IElPUFMgb2YgdWJsay1xY293MiBjYW4gYmUgaW5jcmVhc2VkIGJ5IH4x
WFsyXS4gTWVhbnRpbWUgaXQgc2F2ZXMgbWVtb3J5IGJhbmR3aWR0aC4NCj4gDQo+IFNvIHRoaXMg
aXMgb25lIGltcG9ydGFudCBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudC4NCj4gDQo+IFNvIGZhciB0
aGVyZSBhcmUgdGhyZWUgcHJvcG9zYWw6DQoNCmxvb2tzIGxpa2UgdGhlcmUgaXMgbm8gZGVkaWNh
dGVkIHNlc3Npb24uIENvdWxkIHdlIHN0aWxsIGhhdmUgYSANCmRpc2N1c3Npb24gaW4gYSBmcmVl
IHNsb3QsIGlmIHBvc3NpYmxlPw0KDQpUaGFua3MsDQpCZXJuZA0KDQoNCj4gDQo+IDEpIHNwbGlj
ZSBiYXNlZA0KPiANCj4gLSBzcGxpY2VkIHBhZ2UgZnJvbSAtPnNwbGljZV9yZWFkKCkgY2FuJ3Qg
YmUgd3JpdHRlbg0KPiANCj4gdWJsayBSRUFEIHJlcXVlc3QgY2FuJ3QgYmUgaGFuZGxlZCBiZWNh
dXNlIHNwbGljZWQgcGFnZSBjYW4ndCBiZSB3cml0dGVuDQo+IHRvLCBhbmQgZXh0ZW5kaW5nIHNw
bGljZSBmb3IgdWJsayB6ZXJvIGNvcHkgaXNuJ3Qgb25lIGdvb2Qgc29sdXRpb25bM10NCj4gDQo+
IC0gaXQgaXMgdmVyeSBoYXJkIHRvIG1lZXQgYWJvdmUgcmVxdWlyZW1lbnRzICB3cnQuIHJlcXVl
c3QgYnVmZmVyIGxpZmV0aW1lDQo+IA0KPiBzcGxpY2UvcGlwZSBmb2N1c2VzIG9uIHBhZ2UgcmVm
ZXJlbmNlIGxpZmV0aW1lLCBidXQgdWJsayB6ZXJvIGNvcHkgcGF5cyBtb3JlDQo+IGF0dGVudGlv
biB0byB1YmxrIHJlcXVlc3QgYnVmZmVyIGxpZmV0aW1lLiBJZiBpcyB2ZXJ5IGluZWZmaWNpZW50
IHRvIHJlc3BlY3QNCj4gcmVxdWVzdCBidWZmZXIgbGlmZXRpbWUgYnkgdXNpbmcgYWxsIHBpcGUg
YnVmZmVyJ3MgLT5yZWxlYXNlKCkgd2hpY2ggcmVxdWlyZXMNCj4gYWxsIHBpcGUgYnVmZmVycyBh
bmQgcGlwZSB0byBiZSBrZXB0IHdoZW4gdWJsayBzZXJ2ZXIgaGFuZGxlcyBJTy4gVGhhdCBtZWFu
cw0KPiBvbmUgc2luZ2xlIGRlZGljYXRlZCBgYHBpcGVfaW5vZGVfaW5mb2BgIGhhcyB0byBiZSBh
bGxvY2F0ZWQgcnVudGltZSBmb3IgZWFjaA0KPiBwcm92aWRlZCBidWZmZXIsIGFuZCB0aGUgcGlw
ZSBuZWVkcyB0byBiZSBwb3B1bGF0ZWQgd2l0aCBwYWdlcyBpbiB1YmxrIHJlcXVlc3QNCj4gYnVm
ZmVyLg0KPiANCj4gSU1PLCBpdCBpc24ndCBvbmUgZ29vZCB3YXkgdG8gdGFrZSBzcGxpY2UgZnJv
bSBib3RoIGNvcnJlY3RuZXNzIGFuZCBwZXJmb3JtYW5jZQ0KPiB2aWV3cG9pbnQuDQo+IA0KPiAy
KSBpb191cmluZyByZWdpc3RlciBidWZmZXIgYmFzZWQNCj4gDQo+IC0gdGhlIG1haW4gaWRlYSBp
cyB0byByZWdpc3RlciBvbmUgcnVudGltZSBidWZmZXIgaW4gZmFzdCBpbyBwYXRoLCBhbmQNCj4g
ICAgdW5yZWdpc3RlciBpdCBhZnRlciB0aGUgYnVmZmVyIGlzIHVzZWQgYnkgdGhlIGZvbGxvd2lu
ZyBPUHMNCj4gDQo+IC0gdGhlIG1haW4gcHJvYmxlbSBpcyB0aGF0IGJhZCBwZXJmb3JtYW5jZSBj
YXVzZWQgYnkgaW9fdXJpbmcgbGluayBtb2RlbA0KPiANCj4gcmVnaXN0ZXJpbmcgYnVmZmVyIGhh
cyB0byBiZSBvbmUgT1AsIHNhbWUgd2l0aCB1bnJlZ2lzdGVyaW5nIGJ1ZmZlcjsgdGhlDQo+IGZv
bGxvd2luZyBub3JtYWwgT1BzKHN1Y2ggYXMgRlMgSU8pIGhhdmUgdG8gZGVwZW5kIG9uIHRoZSBy
ZWdpc3RlcmluZw0KPiBidWZmZXIgT1AsIHRoZW4gaW9fdXJpbmcgbGluayBoYXMgdG8gYmUgdXNl
ZC4NCj4gDQo+IEl0IGlzIG5vcm1hbCB0byBzZWUgbW9yZSB0aGFuIG9uZSBub3JtYWwgT1BzIHdo
aWNoIGRlcGVuZCBvbiB0aGUgcmVnaXN0ZXJpbmcNCj4gYnVmZmVyIE9QLCBzbyBhbGwgdGhlc2Ug
T1BzKHJlZ2lzdGVyaW5nIGJ1ZmZlciwgbm9ybWFsIChGUyBJTykgT1BzIGFuZA0KPiB1bnJlZ2lz
dGVyaW5nIGJ1ZmZlcikgaGF2ZSB0byBiZSBsaW5rZWQgdG9nZXRoZXIsIHRoZW4gbm9ybWFsKEZT
IElPKSBPUHMNCj4gaGF2ZSB0byBiZSBzdWJtaXR0ZWQgb25lIGJ5IG9uZSwgYW5kIHRoaXMgd2F5
IGlzIHNsb3csIGJlY2F1c2UgdGhlcmUgaXMNCj4gb2Z0ZW4gbm8gZGVwZW5kZW5jeSBhbW9uZyBh
bGwgdGhlc2Ugbm9ybWFsIEZTIE9Qcy4gQmFzaWNhbGx5IGlvX3VyaW5nDQo+IGxpbmsgbW9kZWwg
ZG9lcyBub3Qgc3VwcG9ydCB0aGlzIGtpbmQgb2YgMTpOIGRlcGVuZGVuY3kuDQo+IA0KPiBObyBv
bmUgcG9zdGVkIGNvZGUgZm9yIHNob3dpbmcgdGhpcyBhcHByb2FjaCB5ZXQuDQo+IA0KPiAzKSBp
b191cmluZyBmdXNlZCBjb21tYW5kWzFdDQo+IA0KPiAtIGZ1c2VkIGNvbW1hbmQgZXh0ZW5kIGN1
cnJlbnQgaW9fdXJpbmcgdXNhZ2UgYnkgYWxsb3dpbmcgc3VibWl0dGluZyBmb2xsb3dpbmcNCj4g
RlMgT1BzKGNhbGxlZCBzZWNvbmRhcnkgT1BzKSBhZnRlciB0aGUgcHJpbWFyeSBjb21tYW5kIHBy
b3ZpZGVzIGJ1ZmZlciwgYW5kDQo+IHByaW1hcnkgY29tbWFuZCB3b24ndCBiZSBjb21wbGV0ZWQg
dW50aWwgYWxsIHNlY29uZGFyeSBPUHMgYXJlIGRvbmUuDQo+IA0KPiBUaGlzIHdheSBzb2x2ZXMg
dGhlIHByb2JsZW0gaW4gMiksIGFuZCBtZWFudGltZSBhdm9pZHMgdGhlIGJ1ZmZlciByZWdpc3Rl
ciBjb3N0IGluDQo+IGJvdGggc3VibWlzc2lvbiBhbmQgY29tcGxldGlvbiBJTyBmYXN0IGNvZGUg
cGF0aCBiZWNhdXNlIHRoZSBwcmltYXJ5IGNvbW1hbmQgd29uJ3QNCj4gYmUgY29tcGxldGVkIHVu
dGlsIGFsbCBzZWNvbmRhcnkgT1BzIGFyZSBkb25lLCBzbyBubyBuZWVkIHRvIHdyaXRlL3JlYWQg
dGhlDQo+IGJ1ZmZlciBpbnRvIHBlci1jb250ZXh0IGdsb2JhbCBkYXRhIHN0cnVjdHVyZS4NCj4g
DQo+IE1lYW50aW1lIGJ1ZmZlciBsaWZldGltZSBwcm9ibGVtIGlzIGFkZHJlc3NlZCBzaW1wbHks
IHNvIGNvcnJlY3RuZXNzIGdldHMgZ3VhcmFudGVlZCwNCj4gYW5kIHBlcmZvcm1hbmNlIGlzIHBy
ZXR0eSBnb29kLCBhbmQgZXZlbiBJT1BTIG9mIDRrIElPIGdldHMgYSBsaXR0bGUNCj4gaW1wcm92
ZWQgaW4gc29tZSB3b3JrbG9hZHMsIG9yIGF0IGxlYXN0IG5vIHBlcmYgcmVncmVzc2lvbiBpcyBv
YnNlcnZlZA0KPiBmb3Igc21hbGwgc2l6ZSBJTy4NCj4gDQo+IGZ1c2VkIGNvbW1hbmQgY2FuIGJl
IHRob3VnaHQgYXMgb25lIHNpbmdsZSByZXF1ZXN0IGxvZ2ljYWxseSwganVzdCBpdCBoYXMgbW9y
ZQ0KPiB0aGFuIG9uZSBTUUUoYWxsIHNoYXJlIHNhbWUgbGluayBmbGFnKSwgdGhhdCBpcyB3aHkg
aXMgbmFtZWQgYXMgZnVzZWQgY29tbWFuZC4NCj4gDQo+IC0gdGhlIG9ubHkgY29uY2VybiBpcyB0
aGF0IGZ1c2VkIGNvbW1hbmQgc3RhcnRzIG9uZSB1c2UgdXNhZ2Ugb2YgaW9fdXJpbmcsIGJ1dA0K
PiBzdGlsbCBub3Qgc2VlIGNvbW1lbnRzIHdydC4gd2hhdC93aHkgaXMgYmFkIHdpdGggdGhpcyBr
aW5kIG9mIG5ldyB1c2FnZS9pbnRlcmZhY2UuDQo+IA0KPiBJIHByb3Bvc2UgdGhpcyB0b3BpYyBh
bmQgd2FudCB0byBkaXNjdXNzIGFib3V0IGhvdyB0byBtb3ZlIG9uIHdpdGggdGhpcw0KPiBmZWF0
dXJlLg0KPiANCj4gDQo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1ibG9jay8y
MDIzMDMzMDExMzYzMC4xMzg4ODYwLTEtbWluZy5sZWlAcmVkaGF0LmNvbS8NCj4gWzJdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWJsb2NrL2IzZmM5OTkxLTRjNTMtOTIxOC1hOGNjLTVi
NGRkMzk1MjEwOEBrZXJuZWwuZGsvDQo+IFszXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51
eC1ibG9jay9DQUhrLT13Z0pzaTd0N1lZcHVvNmV3WEduSHoybm1qNjdpV1I2S1BHb3o1VEJ1MzRt
V1FAbWFpbC5nbWFpbC5jb20vDQo+IA0KPiANCj4gVGhhbmtzLA0KPiBNaW5nDQo+IA0KDQo=
