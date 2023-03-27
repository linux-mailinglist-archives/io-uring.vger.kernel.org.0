Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AD66CA6B8
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjC0OCw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 10:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjC0OCa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 10:02:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A554E40C6;
        Mon, 27 Mar 2023 07:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMW+m7uw20s6veENaG26SINmPyNnqyk/lcLKMGZoq4HWH7rubbeUnWLYzCxDoQ+tCZs0bjsOFOhjSKQWxsu1D2Faz6zLQhmPiqHkPuEPT/p6NP3gTir59rEyOqj6CkS997ufzssFkHgJYZtdoSe5CtQd3dxqPb68fhh08CH0R/I2fUwKG6XBchToKCzMtH1ysASlKqd5s7xYUcrrVOXmAP06wKOnLtAYhcaTj9awMdP4Qz8RSefgxNOiVJT52elLUb/ST3k64fuhXD+u7OFKQln0ZKIxX+8rMeOl1UUZ1W9KVVc7yT+L0neeom3vIB9NZ7+7wskXHv8lgRvWOPCdrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dILuHyoWYX2l6p2hBfDYhqU3K8eF/AmEM+J7gFm7FeY=;
 b=MT8CrMD1GMVHv5daV/Oo8dOa4Gsx8ey5UU2xgo7P38yr8cZq6qvteyiAXGEEFHQ78phMvpmv/20/i5MYCDKdAf6VUTqEaF0nfL07Bh0NCa0oQ/PVD363OkJFb7Jec19cdhYhEcHDB1ulhzpDcfq2Ol0GWxOZvBTa3QvKYkdLM7SQ/ILV6w4anSE3dl8/ETrwVWyFHNcHdvMyidrypYH70mh1u/O1EOW5aK2XxRa7vyIvVJqLQqI8KGwjD9AO5wMf3fJ8MNE2BXlqhIZR7p311TsqTt2lat2Av8+uYfmc6UyYhFSZ62XUenROeRir1JZyoeL3zf6t6dJfprF26MX/0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dILuHyoWYX2l6p2hBfDYhqU3K8eF/AmEM+J7gFm7FeY=;
 b=WdmIaZHwPTmJGYJ84EN5O4UGd/so9mVf06IlbfsymLzVMWjFdcXPaf5gM82b9g8kbd+HfL8Xq7vD8tmMbuiTo6rHazLcuoSVXirBsBXdla3NQBgNx2CvpYQczV5+U1bKJNT3xzM5Xv86kpFrhgnwD9/bLEupsfZhSRA2x3F2L1Y=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by PH0PR19MB5426.namprd19.prod.outlook.com (2603:10b6:510:fc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 27 Mar
 2023 14:02:08 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::e6d4:29f7:2077:bd69]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::e6d4:29f7:2077:bd69%4]) with mapi id 15.20.6086.024; Mon, 27 Mar 2023
 14:02:08 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
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
Thread-Index: AQHZW5INP1WhR4AlW0WGDgYwsBdWma8ILRSAgAAKLQCAABl7AIAAC/8AgAB+uYCABcuugIAACyiA
Date:   Mon, 27 Mar 2023 14:02:08 +0000
Message-ID: <ddf58eb0-10c6-3554-5619-16152b0a4ff5@ddn.com>
References: <20230321011047.3425786-1-bschubert@ddn.com>
 <20230321011047.3425786-7-bschubert@ddn.com>
 <CAJfpegs6z6pvepUx=3zfAYqisumri=2N-_A-nsYHQd62AQRahA@mail.gmail.com>
 <28a74cb4-57fe-0b21-8663-0668bf55d283@ddn.com>
 <CAJfpeguvCNUEbcy6VQzVJeNOsnNqfDS=LyRaGvSiDTGerB+iuw@mail.gmail.com>
 <e0febe95-6d35-636d-1668-84ef16b87370@ddn.com>
 <a1b51f8c-06b9-8f89-f60e-ee2051069a51@ddn.com>
 <a2fbe689-40e6-c01f-3616-4f42ae14347b@gmail.com>
In-Reply-To: <a2fbe689-40e6-c01f-3616-4f42ae14347b@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|PH0PR19MB5426:EE_
x-ms-office365-filtering-correlation-id: 4a63f191-162e-4c3e-2a8a-08db2ecbdab7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AJrC9s9hcv95s9KvxjnVk4SKVIdmQQQPcXmCTkFp7sFwiIUbaeLxPgyusq1c1ErE4vjIPDyUjIxSKvu4UOyBZNseolKjyJDVgm+k07fPLHBVErlMP1Tm4lOp7JB57sI0QzcuS/CBP/YPnTgMpNw+aNLctwpnCkC9s8UH/NZeRywsl9DEB2kPYOYF0eqEuh1XoQvzR0bZd+dbTbzJoNCy9CKj3X+C8YXHiMEcnh9IGPFprFahEvfZWWjZ31l6S71N4uxKho6NL9d5EQ58B2K4f2/Zhiwy3YudritSPszuFOjUJCIo+l3zR+saqUriwkMP4yiTreTtVi7+nfFkrvXqjba6tkhGgzx0OTMaO74KdxmFgcO/y26hsBukivijxRsnYOC/qZaJco2FUTZx8jko86Tuu9h2a/KTjgTDitC/9Cej7K6QWUxX3bQ5foGiPL6bAAL84ikJfsSJogauFJTl+qQ1lDpRJfeJm5bQnt7bLNwbXKJZqQSb2QiTFXnNJyLf21rhYIWUs0XuB6o7JIu4Y4NDM8vCfbdMdvUAxJCjQ6J4eseJCoFX2MExbxfec+x4fMVCP1ngMByZGxWFfact44G7Yg/WPHoSsFoCJ5cfo/9oLR4JL9E+cxUVf6KIjPkRXA6bk01Kmiwa48R3wWnOVEhUjdcYqGElbWDF5gFde9QHsr69MyJ8+pL81bA7KJ/a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39850400004)(346002)(376002)(366004)(451199021)(8676002)(316002)(122000001)(66446008)(31686004)(8936002)(66556008)(2906002)(36756003)(6506007)(54906003)(6486002)(38100700002)(66946007)(38070700005)(71200400001)(53546011)(110136005)(2616005)(478600001)(186003)(76116006)(66476007)(31696002)(64756008)(5660300002)(4326008)(41300700001)(91956017)(6512007)(83380400001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2NCeTVXTEhuM1F2RXhlSHBzYXNobnkreVgrNzN4NHB5cHRzQWxJaTVkRlFP?=
 =?utf-8?B?YUhFeDE5V1dKMDZKZGIxT2hrblRvK1YxcHZ3Ykttc0QzMlhrTG1WWm1kVzJE?=
 =?utf-8?B?L1N3YUZoWjRRMUNCTENLTUtHOENFZGRtd09hdXpmMUtoY2YycG9CUzh1K3By?=
 =?utf-8?B?T0NpMGJZMmdCTXNsRE1XcUsxOGtWV2RtckVLMGdiSWJrUGkydXFTYzhFcDlO?=
 =?utf-8?B?Sml3ajNMVm50R1hodUJBbDFvY0ZHQXFRZnpJWGNCdFJKalFyVTl2TFM5QW0v?=
 =?utf-8?B?aHJzQ2FNVnBLWFBLalZBbmlSVUdJRHg5VXF1Y1BvUG8vRHB5a2NxdDhQOFdp?=
 =?utf-8?B?QUJ2NkF0aUFrMC83azJ4MnBQaE1BenNnT2pkcldFMHVubVF5SWxEaXlLajIx?=
 =?utf-8?B?RmUyMmIxKy9iQlhjeERnZWdnMjViV00raWd6MEp0UEQ1VVh1aC9GVTFOdUpx?=
 =?utf-8?B?YmJFSHJBVEp3V2FORWoyUG9LdDJxVTNPRWx4T1RzL1J1blYxdC9JYzczR2l4?=
 =?utf-8?B?YlRVSE5RNlVFVmpXeEpKWUQ3aklURDIrRmF4bStMaEVNRUhmVE90eW9ZZ3Fj?=
 =?utf-8?B?clJOV01yVnF2WGQwOFphNlVlRzM0L0orNnFEN3RhelJldTVoOHJJd0xsQzFw?=
 =?utf-8?B?TWQ3YmxCSHd3RVo1MXNXU2Y0ZWlWem85NkU2VkVxSkhsMlhSUm1xSXRKVkNi?=
 =?utf-8?B?MDQ1LzZUWlg3d1laTnpKYkRQbW9OU2dzeDJqa0lxMDJnbndnU25DOEVXOUFl?=
 =?utf-8?B?TCtMbmN6aXU2QURBblgvSFVRSTNIKzJJcGJOcDIxa0VsQkoybUFXdWQ5U0Fm?=
 =?utf-8?B?RTRZdHR4NkpEcytvcTI4NWJMdVJzelp1cHB1Q3haTUxvRkxzWlRTanhpbFE1?=
 =?utf-8?B?RldkZWtiTUtyQm5DY1puRzY1cjBJYktFZHBhQ3R0Y25zaEdQQ3RFbjRHellY?=
 =?utf-8?B?eVNTNFdsak1YVmVFalF5T3psMjd4K090c0tMZXJ3QXdnN0lWVTNHdzFzQ1Vu?=
 =?utf-8?B?RFVzK0pDcFZ5aVdDRHBGcTdXb1hZdjNFNFhVenZ0ZFpLcFg5cENRd29GSSty?=
 =?utf-8?B?WWFjS3FXNTgyRWZEZkEwV0RNcDFIMXNXdFd5bXFFN04vQjFLWjhsSjNPUXpu?=
 =?utf-8?B?VEUzZFJPOGxYV082cmM4QlRtNTJtSUk3NkRzci9mNXNEODVBb002UjBRbFA1?=
 =?utf-8?B?TnIvZ2M1SisyQTNsanRCVHg3ZmdxaEVHWGdseEJ3Q2Z5Sks4WTdUeHEzbStY?=
 =?utf-8?B?VUgxRlZHZXJSZlZGOHhCVktvUURLV2tQdHlDSHFrdG93Vm1RQkhxR3BhS2ky?=
 =?utf-8?B?S0huYXp3a09Cb1hZVGVaR2hvKzhWblNtdEY3UHZBdE14Ti9oOWtWR3lhRWxF?=
 =?utf-8?B?M01mc2RmbGcvVmRERDFCcHNFY0xmK3hHcVhuaXppL2tLT0ZTc2FhalpEWnUv?=
 =?utf-8?B?TXFKOEJmZXMvRUtVM1FDdnVsbDJ3bUJLa1lzdmU2UWhQTmFSSTBPRnhPS3Ew?=
 =?utf-8?B?djM0YlFoRTFFQ2hKS0ZickluaFJJVzU2QkxIZGFSWXNrMThhTFVKZi9CM1Vy?=
 =?utf-8?B?SjQ3KzF3VjlwOE0zclNXbzZUU1JwaDk4emdoM2NyUXVwekZFcTY0QzVmYWxO?=
 =?utf-8?B?cW1VKy83Q1IxWVc0Y3VIOUpLY1pzaHZtaks2bi84SVErWTRBUVB5S2g3M3By?=
 =?utf-8?B?WDNJalFPc1NoaU1idnk3RWozWHBvQlp0OGJjNFhLRGRIMWRnaWlzdlhGYTM0?=
 =?utf-8?B?SzFvRlF5NTdMZ1ZENm9EUktGM3NKZlllTkkvNUxSdTJDWUVIUlhyMkpWdEdY?=
 =?utf-8?B?UDVtL2NRTjNoRk9sNGxOQ2ExTkhlSW4wbWJKV1RieU00bU9xQm0xMm9IRE8w?=
 =?utf-8?B?bTZKL1NFOW9KWVJJRUNSekUyWEF6emlRQ3JhaUt1cWVaSjh5RWQrZ3BJYVM3?=
 =?utf-8?B?UTMzQW1YaFlIRE1SZ1kzZnZjQTRSUk95OEwyQmU4U2NpaDM0MWVIK25ST3FY?=
 =?utf-8?B?RG11RU10bHZlVVpNc0ZxMnI3TTU1WDVlRjZpaXdaSk5YemwvOGxHMlNmN2dj?=
 =?utf-8?B?SU9lTWN5TUh6S1V5VFJsbXU2cGhBMldLanlVNFFHbzNLcXR4a25hRGtEanJm?=
 =?utf-8?B?d0xBVjBUZlpxVnZMMUlFZ2F4RC95MGlHOWFsVWY4azhqWmF6Q0c3TzJUTHNa?=
 =?utf-8?Q?CUH0mX8N3i+XggBiao/nNmc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA8FBB2AC2B7314AA7FE066502AB2A69@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a63f191-162e-4c3e-2a8a-08db2ecbdab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2023 14:02:08.5108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bOUxE01klAQobJQYQ4zPty+vx2ziFMHknEGJBMtqY0sz8lw8/q0DOE8CdsaVuM3eVOKlzxHcQobR+SWhWsDx5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5426
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gMy8yNy8yMyAxNToyMiwgUGF2ZWwgQmVndW5rb3Ygd3JvdGU6DQo+IE9uIDMvMjMvMjMgMjA6
NTEsIEJlcm5kIFNjaHViZXJ0IHdyb3RlOg0KPj4gT24gMy8yMy8yMyAxNDoxOCwgQmVybmQgU2No
dWJlcnQgd3JvdGU6DQo+Pj4gT24gMy8yMy8yMyAxMzozNSwgTWlrbG9zIFN6ZXJlZGkgd3JvdGU6
DQo+Pj4+IE9uIFRodSwgMjMgTWFyIDIwMjMgYXQgMTI6MDQsIEJlcm5kIFNjaHViZXJ0IDxic2No
dWJlcnRAZGRuLmNvbT4gd3JvdGU6DQo+IFsuLi5dDQo+PiBGb3VuZCB0aGUgcmVhc29uIHdoeSBJ
IGNvbXBsZXRlIFNRRXMgd2hlbiB0aGUgZGFlbW9uIHN0b3BzIC0gb24gZGFlbW9uDQo+PiBzaWRl
IEkgaGF2ZQ0KPj4NCj4+IHJldCA9IGlvX3VyaW5nX3dhaXRfY3FlKCZxdWV1ZS0+cmluZywgJmNx
ZSk7DQo+Pg0KPj4gYW5kIHRoYXQgaGFuZ3Mgd2hlbiB5b3Ugc3RvcCB1c2VyIHNpZGUgd2l0aCBT
SUdURVJNL1NJR0lOVC4gTWF5YmUgdGhhdA0KPj4gY291bGQgYmUgc29sdmVkIHdpdGggaW9fdXJp
bmdfd2FpdF9jcWVfdGltZW91dCgpIC8NCj4+IGlvX3VyaW5nX3dhaXRfY3FlX3RpbWVvdXQoKSwg
YnV0IHdvdWxkIHRoYXQgcmVhbGx5IGJlIGEgZ29vZCBzb2x1dGlvbj8NCj4gDQo+IEl0IGNhbiBi
ZSBzb21lIHNvcnQgb2YgYW4gZXZlbnRmZCB0cmlnZ2VyZWQgZnJvbSB0aGUgc2lnbmFsIGhhbmRs
ZXINCj4gYW5kIHdhaXRlZCB1cG9uIGJ5IGFuIGlvX3VyaW5nIHBvbGwvcmVhZCByZXF1ZXN0LiBP
ciBtYXliZSBzaWduYWxmZC4NCj4gDQo+PiBXZSB3b3VsZCBub3cgaGF2ZSBDUFUgYWN0aXZpdHkg
aW4gaW50ZXJ2YWxzIG9uIHRoZSBkYWVtb24gc2lkZSBmb3Igbm93DQo+PiBnb29kIHJlYXNvbiAt
IHRoZSBtb3JlIG9mdGVuIHRoZSBmYXN0ZXIgU0lHVEVSTS9TSUdJTlQgd29ya3MuDQo+PiBTbyBh
dCBiZXN0LCBpdCBzaG91bGQgYmUgdXJpbmcgc2lkZSB0aGF0IHN0b3BzIHRvIHdhaXQgb24gYSBy
ZWNlaXZpbmcgYQ0KPj4gc2lnbmFsLg0KPiANCj4gRldJVywgaW9fdXJpbmcgKGkuZS4ga2VybmVs
IHNpZGUpIHdpbGwgc3RvcCB3YWl0aW5nIGlmIHRoZXJlIGFyZSBwZW5kaW5nDQo+IHNpZ25hbHMs
IGFuZCB3ZSdkIG5lZWQgdG8gY2hlY2sgbGlidXJpbmcgdG8gaG9ub3VyIGl0LCBlLmcuIG5vdCB0
byByZXRyeQ0KPiB3YWl0aW5nLg0KPiANCg0KSSdtIGdvaW5nIHRvIGNoZWNrIHdoZXJlIGFuZCB3
aHkgaXQgaGFuZ3MsIGJ1c3kgd2l0aCBzb21ldGhpbmcgZWxzZSANCnRvZGF5IC0gYnkgdG9tb3Jy
b3cgSSBzaG91bGQga25vdyB3aGF0IGhhcHBlbnMuDQoNCg0KVGhhbmtzLA0KQmVybmQNCg==
