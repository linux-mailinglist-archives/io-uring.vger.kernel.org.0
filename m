Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F786C71DE
	for <lists+io-uring@lfdr.de>; Thu, 23 Mar 2023 21:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjCWUwB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Mar 2023 16:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjCWUwA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Mar 2023 16:52:00 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7541F90B;
        Thu, 23 Mar 2023 13:51:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5I4oNjTv7NCAFmFX7rWjr2gjOMJxiNumIJSwQPDuHwQunVxKJXoSTd2wSi7eNeA7wdKhILZWVylLXaQZ7iEGp4reihT3SiD8x3NNNKwFeyK459W8GlNBCNjFSs43WaB8nOHKJ4PRd1sZTbR3l6LUrawLaSga11N8dD5bkXPq8JbrFaYxa6wAaDG+n14aieZmUprzz1vmXH3AwQEKliZaxl4+e/JD7j3JQx/1+fv8eo1gGAQhdDtlflsp9wgvGuBpfdb+r0Udatxw2O1auLXrgFklMtqUPv0p9bEz/wmt/ExY15ZvHrZcaNv1NNDwxCm2aRqXGb4nD6iF5JL4kkA7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TD3onTVqdhOj4TWBUSjFWYzv6uxqZ/TOMbqKvs/PRtA=;
 b=GfRzUPhsZn9tpBi13xT/3SvLEQtLNxh2ytu4xYWGT6V32bzzLGZNMxg9ouogAahq4Wg74e2PoeM+0oihTtCcDwBhvpqylI9VptTQc51oYLmsOxui+UIE+fKYou+ztXBis54733I0G+Zj+Mliu5VXd1QeKt1cDHcgLBof6jZCoUBCPN6+lkiUw+iKUNfBt9+2ZkciUh2tyyuXrITJkFHAMdQTCmjBlY3iav70OTq4oj47Zw7/Cvj9BlIunPqOS3Fr76xry2gQXAF7sJ+5qpoEbrya/lbeSoPktkN2hwc8hb0Kymv4e7lzJLaPDsiro8LatbKHsmdZft3sL2xIrrF+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD3onTVqdhOj4TWBUSjFWYzv6uxqZ/TOMbqKvs/PRtA=;
 b=hrNg+Y/lhNA7bBU41PwoH7yRUNK4otL2xKYzbgtB1ceZ8pqEm5IE3ho0cuXdqv11ZfB0N4+floSWVd3HKR0c2lu+7VL/Mx+oAcixZpDPeZ90r2RLapMrdm8RZke0FmvpP1b+kqo4u3vjAHoEqWAzSljsdBK2dCIvLpccaemxmtI=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by DS0PR19MB7646.namprd19.prod.outlook.com (2603:10b6:8:f4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Thu, 23 Mar 2023 20:51:54 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::e6d4:29f7:2077:bd69]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::e6d4:29f7:2077:bd69%4]) with mapi id 15.20.6086.024; Thu, 23 Mar 2023
 20:51:54 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>,
        Amir Goldstein <amir73il@gmail.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Ming Lei <ming.lei@redhat.com>,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/13] fuse: Add an interval ring stop worker/monitor
Thread-Topic: [PATCH 06/13] fuse: Add an interval ring stop worker/monitor
Thread-Index: AQHZW5INP1WhR4AlW0WGDgYwsBdWma8ILRSAgAAKLQCAABl7AIAAC/8AgAB+uYA=
Date:   Thu, 23 Mar 2023 20:51:53 +0000
Message-ID: <a1b51f8c-06b9-8f89-f60e-ee2051069a51@ddn.com>
References: <20230321011047.3425786-1-bschubert@ddn.com>
 <20230321011047.3425786-7-bschubert@ddn.com>
 <CAJfpegs6z6pvepUx=3zfAYqisumri=2N-_A-nsYHQd62AQRahA@mail.gmail.com>
 <28a74cb4-57fe-0b21-8663-0668bf55d283@ddn.com>
 <CAJfpeguvCNUEbcy6VQzVJeNOsnNqfDS=LyRaGvSiDTGerB+iuw@mail.gmail.com>
 <e0febe95-6d35-636d-1668-84ef16b87370@ddn.com>
In-Reply-To: <e0febe95-6d35-636d-1668-84ef16b87370@ddn.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|DS0PR19MB7646:EE_
x-ms-office365-filtering-correlation-id: 60d37753-0e85-4431-de0c-08db2be06f14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tL9c+2uQFu5QCTJHNhYJ4LAjXATygN6wnhgXBptlLxS7z0Als74j2WcEh7QahS9nrRcWo9U8n+/MdAIXW70gMBfsJs4FzUnVWp6LbOa64CjwXh8POPRgAzLou/yppvly0Zk1gF52JDnQESuamOzzhstS9KBTeyHDLMza8bBYKheGQhOQj6cFG2ieGpxYjwwhjD7J551AqTEaJO5FHe7SPnPgBGmw66RH6n9vy0OAuTpmWZ9qeHQ9eR0d4bwWLxv/Gw2MNeKH4c9asdDEndkCNI6eUE9btLSVUSS4S7c2LPg9XYylCLZZHR2WWZSmKN68uIQP3tVoslSV/4wFBAkkZNptv69fJ/mforB/RfPkA3nIwHbRTN4HKMYhcxvkUd2hsoNVcof5pPUOyk+2F2Yy4oIEUSW4xD2phDLSKn+SkkB9FPplGF+mCGR1RviTMkKBXIESWPQxD5RY478rMdYh/AaA0k5faP/10WRZngwgV8H604ujwBdtWtAHVvAhEVCfPu3hQTerSzDaVIwAPQZljeVznuUL7U5pxeLZPZW53O9bALK1NjhfYjdlOonjshg+SQF4JZH2+HRHOn+80UPegc+IxnNxC3HvyL1qRStw4I83vAyGBGAax6PNjEdsMa6CpTEAxnsFvDSMMD+qOUc1O7RJ3xbuUIsorQ9cklH3DZgLMpLVPinVhCjTOSC0/tNlIOy6HX39XWjsOE9LABjyq5JBXwkQ6suZp80A6F2ct6Vjmqk9u8gb6PpHlktIxzVwr1oa8mtoLEn/9ao82b0XBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199018)(36756003)(316002)(76116006)(71200400001)(38100700002)(6486002)(122000001)(2616005)(186003)(6512007)(83380400001)(6506007)(53546011)(8936002)(5660300002)(41300700001)(478600001)(2906002)(8676002)(66476007)(66446008)(64756008)(66556008)(54906003)(66946007)(4326008)(91956017)(38070700005)(86362001)(31696002)(6916009)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mlc4dDVWMzNnOGh4VVhaVURjWTJXVnBzOGxRQUMrZkkzNlB4MDFXQm40T0lU?=
 =?utf-8?B?OVNUM3h0dnB6dEFqMlNqOHcydExwT0J4ZVZqSGlDWHh2WE05b29TbEpSUmpE?=
 =?utf-8?B?Z2wyZkVKcTVkUWxTVGJEMVdLNGNrZmpLU0RaNW1SNDQ3V1NrR1NOOUhQamhJ?=
 =?utf-8?B?VEdERThqSlUzYkZpVEpXb3BZNGJlc1l3TzVyNGxhc2UxS0hzRlo1aHZpL3Uv?=
 =?utf-8?B?UGRMSFFBN2FteHJ3Z0JOOElYMUtKbStiU0JBRTUzdE13TEsyQ1l6a2tZUUVW?=
 =?utf-8?B?RzUyY3hhSGhYcHBUdXJDR3gvdmhqRU1nc1FxYnIwUElkS0VHQnFHTkRNN0pj?=
 =?utf-8?B?akRPOHhORnQ4NXNCMmxvUkVTZmhZV0QwSjl5Vk5LTk5HZnJwRGxqcDlkL1ll?=
 =?utf-8?B?ZlY1Ujg5UkRFdGdYNG5Ma1ZPNk02UUpGRDN1M2VPa1BaZlNYRzluTXRtZnRr?=
 =?utf-8?B?WUx0TjErTVFHRHd6ejhPSXJjV0pkd3J1RkUyV2c0bGdXcmVJSWlzNkhWeTJi?=
 =?utf-8?B?aFZOc0NIUk5MV3Nzb0dWYVJibkFROVM3WisrM2JGQU5keWtPWkxPM3dIdG1p?=
 =?utf-8?B?bDZJOU52OTNDeWw3L1JhTE9XUjM5OWNVUnlSd1pNQkwxem81Ukhycm9jMkhZ?=
 =?utf-8?B?SWE3ZFB1dTZpMHpWMWxyci9tdGErVXlBUGVnVmw3UXR3dWp6K2hvaGNROEtu?=
 =?utf-8?B?WDNGUUdoMXZtNUgxOE52NWtlMWN2STYzM1F0SklmYmdNbkxQYkdVajcrUWd0?=
 =?utf-8?B?RVZGOWJ5SG9FVXVNTExKQ0RmZDNvbGtaUDYyS2ZyT2d5K1U0WHc5eTlFbmhp?=
 =?utf-8?B?Vm05UEdaSklyQWZyYjQ0TFkyd1VaVndkUTBlQVZWeVVqZ0VydDR5S1BlcXp6?=
 =?utf-8?B?K1dXZEFmUEZMQjBxN0Q4Q1JMSm5mcDVvd1BNNlFTa1QzTmFLZWRjbDJiWTN4?=
 =?utf-8?B?THovZGdma1c1bjJNSXM5NUQrS3FaejFoK0k1ejlLRy9nWVB4QUZjbnJ0d0M0?=
 =?utf-8?B?dExuOXNtMGFNcG9YU0EwUHpUVGtITHNjVUZmZXlqQktjUzYyZURRWThHa2Ro?=
 =?utf-8?B?WVc2aytUcFVodk5ja2JmYTRYZzRxNDUxaFFDdE41dEZWQ1hXQmxNb3RqTVh0?=
 =?utf-8?B?N0MyN1ZqUktrNU90bFdKVHArUVpvTXhmMGhTOEp3dkJ1SGZXQms3SUNNby9L?=
 =?utf-8?B?MzNpbW8wSmZkK0JUc0lkMTFVZkZRVUZmdE0wQjRYdDlCY3Q0RXY5WGZjLzEy?=
 =?utf-8?B?dkNiWE9zd0V2K3RWUU5PTUc2RzJQb09ic09OR1JCNEhpWXBMZnNpaEE0Z2V2?=
 =?utf-8?B?SFBXaENxQUtJRG1HdXNqVTVuQjM0ZGJNQmw3aEk3cVl2VzVReG9CQ2RuV2kv?=
 =?utf-8?B?WUxOclhYblUwKzRaTG5jYXM3ZUlUQ2prOGJJallsQyt0SmZCUWZmODJjUkdW?=
 =?utf-8?B?Uy9JSHRJdUZ1d0l2cjJLektpQ1JwZVArb0xzQmJtSmtvbGMzWVlTK09JdkFZ?=
 =?utf-8?B?L3pqcFA2dHc0bmFDNzZGWnlwS3N1ckdEYjcxNU4wMWNSQmJTWHdncERMSUZP?=
 =?utf-8?B?VkRxZ1VmS2FFME5vcklUaG9TQzBUN1Y3ZmtTS2dYb0xMQkxML3ZBWDRYN2pZ?=
 =?utf-8?B?U0tEdVd0YzVIV0kxZStVUS9FbUxwMjhPazhCTTBwc1h0SjNJZlBaMGZhbHlS?=
 =?utf-8?B?RHB0T3QxMXpGTzRuUGF5a0xyOVB1VERCQlB4eWNnYWRMMDd3NFpKTERkU1Mz?=
 =?utf-8?B?Nkh1OTBRSGh3enVTd2pUbVVuUjJOL2Z0OTFyaFVGaFpJSFFYZG9qY0RsdENY?=
 =?utf-8?B?cStzN3ZkMUhoaW9rNE9MZWRPeC9EL2FxMTdPSk9lODFUelUxVmVlR0p5Tlpp?=
 =?utf-8?B?cTF1VkEwZldCUmxvOWR3dktrOXNZZXZ5M2llRkt3Rml1R2lIZGdEQWFXTm9h?=
 =?utf-8?B?cldvK1VISnBPQ2NuSzdDZjJQdm5XbDZ1bEFPOENaT2pGanQzUThuT29wZU1k?=
 =?utf-8?B?VUN3RXN6ZjVVRWxIZ2Q0Zm9ZSUtHMEowdk4vNVIrV0pYd0pSZmdUa0J6cStr?=
 =?utf-8?B?SDdsQ1AvMjdxZFQxYm5XcmVXQUJHY3Y3NWZBMmxscXFPaVd3bGVDUUR2VnJH?=
 =?utf-8?B?WHRXZkNLbjlrWlVZaDYzdU5pQ0h1aVRyR0MxZ3F5RDM3b1dSQkN0V0NPdzNF?=
 =?utf-8?Q?JnfVDnoncEob1kp6SFpxbAk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29F2777C0B441F48905F346E0D127A74@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d37753-0e85-4431-de0c-08db2be06f14
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 20:51:53.9208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mgzeH+HhEq7mDsMPvmwQASZ/pE9jQzi6C2XCCisSh4u8n/VIU3MgxE2fLBm3rfF9fEqHr6Q2FH/X3b+SseM3Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB7646
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gMy8yMy8yMyAxNDoxOCwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+IE9uIDMvMjMvMjMgMTM6
MzUsIE1pa2xvcyBTemVyZWRpIHdyb3RlOg0KPj4gT24gVGh1LCAyMyBNYXIgMjAyMyBhdCAxMjow
NCwgQmVybmQgU2NodWJlcnQgPGJzY2h1YmVydEBkZG4uY29tPiB3cm90ZToNCj4+Pg0KPj4+IFRo
YW5rcyBmb3IgbG9va2luZyBhdCB0aGVzZSBwYXRjaGVzIQ0KPj4+DQo+Pj4gSSdtIGFkZGluZyBp
biBNaW5nIExlaSwgYXMgSSBoYWQgdGFrZW4gc2V2ZXJhbCBpZGVhcyBmcm9tIHVibGttIEkgZ3Vl
c3MNCj4+PiBJIGFsc28gc2hvdWxkIGFsc28gZXhwbGFpbiBpbiB0aGUgY29tbWl0IG1lc3NhZ2Vz
IGFuZCBjb2RlIHdoeSBpdCBpcw0KPj4+IGRvbmUgdGhhdCB3YXkuDQo+Pj4NCj4+PiBPbiAzLzIz
LzIzIDExOjI3LCBNaWtsb3MgU3plcmVkaSB3cm90ZToNCj4+Pj4gT24gVHVlLCAyMSBNYXIgMjAy
MyBhdCAwMjoxMSwgQmVybmQgU2NodWJlcnQgPGJzY2h1YmVydEBkZG4uY29tPiB3cm90ZToNCj4+
Pj4+DQo+Pj4+PiBUaGlzIGFkZHMgYSBkZWxheWVkIHdvcmsgcXVldWUgdGhhdCBydW5zIGluIGlu
dGVydmFscw0KPj4+Pj4gdG8gY2hlY2sgYW5kIHRvIHN0b3AgdGhlIHJpbmcgaWYgbmVlZGVkLiBG
dXNlIGNvbm5lY3Rpb24NCj4+Pj4+IGFib3J0IG5vdyB3YWl0cyBmb3IgdGhpcyB3b3JrZXIgdG8g
Y29tcGxldGUuDQo+Pj4+DQo+Pj4+IFRoaXMgc2VlbXMgbGlrZSBhIGhhY2suwqDCoCBDYW4geW91
IGV4cGxhaW4gd2hhdCB0aGUgcHJvYmxlbSBpcz8NCj4+Pj4NCj4+Pj4gVGhlIGZpcnN0IHRoaW5n
IEkgbm90aWNlIGlzIHRoYXQgeW91IHN0b3JlIGEgcmVmZXJlbmNlIHRvIHRoZSB0YXNrDQo+Pj4+
IHRoYXQgaW5pdGlhdGVkIHRoZSByaW5nIGNyZWF0aW9uLsKgIFRoaXMgYWxyZWFkeSBsb29rcyBm
aXNoeSwgYXMgdGhlDQo+Pj4+IHJpbmcgY291bGQgd2VsbCBzdXJ2aXZlIHRoZSB0YXNrICh0aHJl
YWQpIHRoYXQgY3JlYXRlZCBpdCwgbm8/DQo+Pj4NCj4+PiBZb3UgbWVhbiB0aGUgY3VycmVudGx5
IG9uZ29pbmcgd29yaywgd2hlcmUgdGhlIGRhZW1vbiBjYW4gYmUgcmVzdGFydGVkPw0KPj4+IERh
ZW1vbiByZXN0YXJ0IHdpbGwgbmVlZCBzb21lIHdvcmsgd2l0aCByaW5nIGNvbW11bmljYXRpb24s
IEkgd2lsbCB0YWtlDQo+Pj4gY2FyZSBvZiB0aGF0IG9uY2Ugd2UgaGF2ZSBhZ3JlZWQgb24gYW4g
YXBwcm9hY2guIFtBbHNvIGFkZGVkIGluIA0KPj4+IEFsZXhzYW5kcmVdLg0KPj4+DQo+Pj4gZnVz
ZV91cmluZ19zdG9wX21vbigpIGNoZWNrcyBpZiB0aGUgZGFlbW9uIHByb2Nlc3MgaXMgZXhpdGlu
ZyBhbmQgYW5kDQo+Pj4gbG9va3MgYXQgZmMtPnJpbmcuZGFlbW9uLT5mbGFncyAmIFBGX0VYSVRJ
TkcgLSB0aGlzIGlzIHdoYXQgdGhlIHByb2Nlc3MNCj4+PiByZWZlcmVuY2UgaXMgZm9yLg0KPj4N
Cj4+IE9rYXksIHNvIHlvdSBhcmUgc2F5aW5nIHRoYXQgdGhlIGxpZmV0aW1lIG9mIHRoZSByaW5n
IGlzIGJvdW5kIHRvIHRoZQ0KPj4gbGlmZXRpbWUgb2YgdGhlIHRocmVhZCB0aGF0IGNyZWF0ZWQg
aXQ/DQo+Pg0KPj4gV2h5IGlzIHRoYXQ/DQo+Pg0KPj4gSSd0cyBtdWNoIG1vcmUgY29tbW9uIHRv
IGJpbmQgYSBsaWZldGltZSBvZiBhbiBvYmplY3QgdG8gdGhhdCBvZiBhbg0KPj4gb3BlbiBmaWxl
LsKgIGlvX3VyaW5nX3NldHVwKCkgd2lsbCBkbyB0aGF0IGZvciBleGFtcGxlLg0KPj4NCj4+IEl0
J3MgbXVjaCBlYXNpZXIgdG8gaG9vayBpbnRvIHRoZSBkZXN0cnVjdGlvbiBvZiBhbiBvcGVuIGZp
bGUsIHRoYW4NCj4+IGludG8gdGhlIGRlc3RydWN0aW9uIG9mIGEgcHJvY2VzcyAoYXMgeW91J3Zl
IG9ic2VydmVkKS4gQW5kIHRoZSB3YXkNCj4+IHlvdSBkbyBpdCBpcyBldmVuIG1vcmUgY29uZnVz
aW5nIGFzIHRoZSByaW5nIGlzIGRlc3Ryb3llZCBub3Qgd2hlbiB0aGUNCj4+IHByb2Nlc3MgaXMg
ZGVzdHJveWVkLCBidXQgd2hlbiBhIHNwZWNpZmljIHRocmVhZCBpcyBkZXN0cm95ZWQsIG1ha2lu
Zw0KPj4gdGhpcyBhIHRocmVhZCBzcGVjaWZpYyBiZWhhdmlvciB0aGF0IGlzIHByb2JhYmx5IGJl
c3QgYXZvaWRlZC4NCj4+DQo+PiBTbyB0aGUgb2J2aW91cyBzb2x1dGlvbiB3b3VsZCBiZSB0byBk
ZXN0cm95IHRoZSByaW5nKHMpIGluDQo+PiBmdXNlX2Rldl9yZWxlYXNlKCkuwqAgV2h5IHdvdWxk
bid0IHRoYXQgd29yaz8NCj4+DQo+IA0KPiBJIF90aGlua18gSSBoYWQgdHJpZWQgaXQgYXQgdGhl
IGJlZ2lubmluZyBhbmQgcnVuIGludG8gaXNzdWVzIGFuZCB0aGVuIA0KPiBzd2l0Y2hlZCB0aGUg
dWJsayBhcHByb2FjaC4gR29pbmcgdG8gdHJ5IGFnYWluIG5vdy4NCj4gDQoNCkZvdW5kIHRoZSBy
ZWFzb24gd2h5IEkgY29tcGxldGUgU1FFcyB3aGVuIHRoZSBkYWVtb24gc3RvcHMgLSBvbiBkYWVt
b24gDQpzaWRlIEkgaGF2ZQ0KDQpyZXQgPSBpb191cmluZ193YWl0X2NxZSgmcXVldWUtPnJpbmcs
ICZjcWUpOw0KDQphbmQgdGhhdCBoYW5ncyB3aGVuIHlvdSBzdG9wIHVzZXIgc2lkZSB3aXRoIFNJ
R1RFUk0vU0lHSU5ULiBNYXliZSB0aGF0IA0KY291bGQgYmUgc29sdmVkIHdpdGggaW9fdXJpbmdf
d2FpdF9jcWVfdGltZW91dCgpIC8gDQppb191cmluZ193YWl0X2NxZV90aW1lb3V0KCksIGJ1dCB3
b3VsZCB0aGF0IHJlYWxseSBiZSBhIGdvb2Qgc29sdXRpb24/IA0KV2Ugd291bGQgbm93IGhhdmUg
Q1BVIGFjdGl2aXR5IGluIGludGVydmFscyBvbiB0aGUgZGFlbW9uIHNpZGUgZm9yIG5vdyANCmdv
b2QgcmVhc29uIC0gdGhlIG1vcmUgb2Z0ZW4gdGhlIGZhc3RlciBTSUdURVJNL1NJR0lOVCB3b3Jr
cy4NClNvIGF0IGJlc3QsIGl0IHNob3VsZCBiZSB1cmluZyBzaWRlIHRoYXQgc3RvcHMgdG8gd2Fp
dCBvbiBhIHJlY2VpdmluZyBhIA0Kc2lnbmFsLg0KDQoNClRoYW5rcywNCkJlcm5kDQo=
