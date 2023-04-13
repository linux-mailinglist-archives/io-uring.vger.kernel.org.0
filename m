Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77676E0A29
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 11:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjDMJ0C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 05:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDMJZ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 05:25:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853AB1BE6;
        Thu, 13 Apr 2023 02:25:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FY5j2JqPa1YACABRn7gabhqXxm3Frd1i38pitSONfeU2Pi55NNQZ2/ffuDtgjuhTNnaf545UmnUf01lzBjGy7apU6TBYNViVKU4ZKiqdKudnPTYDCU9TuRE/Vf2IsDVKYFpKw5mYMUuxYEu9E6Beil8CPt8wVkNdsYipJenhMS/BQu5GEWdmuZEdwcqSLTxGj6aV4MYroEoZstCevuwcF03vtwfU5S2vKeBfi9NOKAuvIjgEpniO3eHtvFRs2azaZg670RRzi5MsHTR+8cuYJO4ovspox69500RSXoeqgJJtMGYch0INE2aJRYyrO1AJw/gdA6WrOHPkX8ZvSgCu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mROjC+SK0wdbErTvTfinSyQ0L1ISJbx/LRWxkwaRsmU=;
 b=kziznF2Le9RLbxmJ19iJvIB++ZVod2cNA3vTSmA20swtdsVPAQKIjao60AGb3OfkuXAfOZlbRKzVy9T0IsXxosH4YBKVk2MNyO2l3m+B3o4rp4DWWCN9Bk+O5JA4Qumm5JdfAEwLA0louE4QD52fDgEYMXXKmiunU5/q9gRWWaHPy3cc9Yj1rzFCoqARESmeCl6E77K8NfiYl6YdTRLs9Pl2fZuAMppYqyWWQGXJ0XsmQSXSNzpRCqN3NwldkGe27AlYxDeHJr6CJhquYo8I9ql791e6zjy5X5qa27iEaOqb7mKmddDtHgwrPhZRxqNEqMkaKD1f+wjuuMXngrp54w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mROjC+SK0wdbErTvTfinSyQ0L1ISJbx/LRWxkwaRsmU=;
 b=gw//T2jpTxZFW/oId+BZDQ+p5e3vUBNdN43hSr1MVQ6A2pkBHF4j7MRW1WvKHtAbDBw+ZwdwNETmOO5ip9ZiLCo7GlDxU+cZqVnb/GnniN6XSVzhP70qFJWqt9H0ERiupCkrqcMZg+RfOY2dAdGZNHy1yr8Bl5fzA0UA8gvl57s=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by MN2PR19MB3822.namprd19.prod.outlook.com (2603:10b6:208:1f1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 09:25:55 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%6]) with mapi id 15.20.6277.031; Thu, 13 Apr 2023
 09:25:54 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Thread-Topic: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Thread-Index: AQHZbUSFJ5BWwL3ovkmLZXgJpNfXLq8o2+eAgAAddAA=
Date:   Thu, 13 Apr 2023 09:25:54 +0000
Message-ID: <ed4ab2bb-4e77-cf31-a035-741efc12d544@ddn.com>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
In-Reply-To: <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|MN2PR19MB3822:EE_
x-ms-office365-filtering-correlation-id: ce2fd164-b52a-479f-276a-08db3c0114ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J5KJgUgJFeh7lH/3zGhHhIu0TeFcw/fZ5vpDnVJbWQJjsvP0SqeXb9HE72FD4A0i5FTEN0UK/BvvmyToC45kzqNTHC56gzK7AoreR9H56+LoeGvOpmaBiyX4X5NI4vxSj6WocGOeJeg8ofsDL0sqJuPM24x3+6LEDEB3Q3yusk86avGX7FSaVGnRa1RetKYwyIaBVnCBQA3f1MMb9QX4bBfo7W4gKpQJfvRPpj/YpbZPs6Yu4x5RFgK3H2Si6g4O8tK561sPZxtCbI1JJd5Y6/gU97dWaMTkqmxdki30+5wryf41XG5KTA3NsGccCHZVNB6X78hJxmzWjY3Fk12IcH0Wa5VOYLdwh0gTcmkIgM225HshhBZ8ZdJa/Ufc9HrHRwbDG8LliU9Q1S9o14o6hEQQ5i7DjzoEflUWXPPzDqFsDygL1QAtYjGlhwpyOx2XCkyYcJIjmH/b9nwAd80GCDYeQaMctsPJKbca+tTONLUCG1lofaXkjZxEfiK3wFx3rLHG4LkygTWWfmAkcTsoUBqA5zgTwEPxD89t+C2afTSopqob83yd2SZQNfLET0QGMHX5Vgc7yZ7Untta2WOkDwSEmAxDLMfYX/i89FVJq1OKfXq3qDSX2v/yVtkuVdMNL63I8du2ll4jSJ0Z+NL3HgU1/CIyPBNvyMnHavgr0nI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39850400004)(366004)(451199021)(478600001)(54906003)(5660300002)(8676002)(8936002)(36756003)(38070700005)(2906002)(86362001)(31696002)(6916009)(4326008)(316002)(66556008)(66476007)(66946007)(64756008)(66446008)(91956017)(76116006)(41300700001)(38100700002)(122000001)(186003)(6512007)(6506007)(53546011)(966005)(2616005)(31686004)(83380400001)(71200400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVVrdGRwc29YUnZYR3crVXpuSXRYem1GTjZxbkVCdCtMY1BIQ2l0ZFRwb21F?=
 =?utf-8?B?cHk3aUV2L3hzR1NTZG9kSFlzN2ovWjRkQ2hEWkZYdklzbFBCNDBaUGZjb1VY?=
 =?utf-8?B?d3E4WUNJdFY5RW5hOGtzM1dyd3V2UnZTSnYrSDBZUW0rZXVkWkN3L2ZkSWdC?=
 =?utf-8?B?ZmFOT1lBbnI3NzBFRjFBcTdkNVR6NVNpVlM2akZYL0lHd2pRQ0djc3VUUzVL?=
 =?utf-8?B?dGFJbWk5V3A1UlJ3a3ZCN3VQZjJOYW9LY09jRWVrRENEMTQrdWR0RC8zZ0JK?=
 =?utf-8?B?clQvZkFFUS9kMVFySnE1K0svR1BqaWJaK1NmQ3BoWEdXRUxaci9tOVVsMy9x?=
 =?utf-8?B?Mk1EUFRPOWZyZm1HZW9mN0kvY1FndEU4cG4relhnN2xNcXlHTlJuQlIxUmEx?=
 =?utf-8?B?eXRacTFPUWdPNCtCbHYxS0RNZFNOR2xrQXNoV2ErblE1M21lMlZ3MWFiM1Bu?=
 =?utf-8?B?SzBxQS9IVnYycFpSLy9SaDh5MVRIajBhRmx1WGQ5MTArcXpEQTVBTlB0eU15?=
 =?utf-8?B?MllyTTdrdlU3K1BDU3Bhb05XRFE2OXg3NlpoVUpyUy9OeU5EaFFCUG90Ni9p?=
 =?utf-8?B?UGJVUmFocEpGNzV5UlBidjFDRUdieTAxUS9GUW0zeGV2My9jaHlOUmpNUjlz?=
 =?utf-8?B?UUN6bEp4blk3azVxNUIrMnpZN294bEZncEYzQklpaFhPZGVTKzhSM0ZNTk92?=
 =?utf-8?B?QzZjeXRidmVZZGQzREhNaGRUd0MyeDdsdVpoU3puTmJFOUVlTVlWUXRycldB?=
 =?utf-8?B?UUo0MFlqeDUyM0FhbGxKUVNvQUVmeFQ0amtCMjlyRUVjVVdCMHFyeFBad0hI?=
 =?utf-8?B?alBUMUs1TFJVSy9FRXJ3UUIxT2Y0b1VRS2poK2NnR3JydTl6aFNDNm16NHV1?=
 =?utf-8?B?UHJnT2FrQVNGNVhqTUJKS1p0YS90M0VSMjQwcTMzeVRnRFFRd3pvM2Q2TEhR?=
 =?utf-8?B?SW4zS21CdENpRWg0ZFJHcTh5aWdFL0JQQUJPQTdyQUxVWnl0UGEyeHFudjhH?=
 =?utf-8?B?RE9LREsxOHBNeVpyOFd0ZlI0MTcxNmE3Z2tkT1psQ3BkN0R3aGtLTGlmOFVG?=
 =?utf-8?B?MWpINkRZQ2tsL0U4TG0zdnJFeVFtbzEweXZEL0drSmVsU0ZQbE05aUZEblc4?=
 =?utf-8?B?aGxXaXQvYXIwNXY1SHpEaGR4TmFkaUVXM0N1MDVyRHNvdG0wSWl3Y3NBblhK?=
 =?utf-8?B?bWoyZ3VDSFluejUxUnh2SSt5QSt0YW1JZU41dTRGM1BxYjRwUnJuQjdWM0lY?=
 =?utf-8?B?ckhWcC9IN1Y3TGw3ZkE3L3dOdVZQVHQvU3RsQUNIbUUzb1VYdndnRkFsck5Y?=
 =?utf-8?B?K0NRY1ZBN3dySXZndFRPa2twVnBUcUFMR2tseDVvYkxvRlF6dHEvQ1hUTmg4?=
 =?utf-8?B?KzB0SzFnQW01ckhrRENSNVBIZ3k5aGN4RjIvNVlXQ0xRVFVXdDJocVhlVGFs?=
 =?utf-8?B?TitCaEM4alhSaWREWEJLK0c2RjBKdnJMdmd0bTk3V1I3bVk2QjVTTW1qMHM2?=
 =?utf-8?B?WVE3bWNNcmZCU0RaTG1WRklwR3pSaHpJcjQvMExyTFBwM2lKU0RmY0ZybzFz?=
 =?utf-8?B?Rnp1OFdlTFZXYURNckNPWnhGN0ViOGlrdGZ6bjk0MFhQMldMYzNCaldJc1U3?=
 =?utf-8?B?UkR0VzF4U1pzVUljQndMRjluSDdnSVVUalVyK01QY1dmbmxGZzlzdk1IZ2lx?=
 =?utf-8?B?ZFpIMGoyYmJJeEE1NVB1bWtPbzVGc2I5dU01MWZ6Q0ZHRXNyY214TUM4b3A3?=
 =?utf-8?B?aWhKcDB6bERlZm9jcGhxd2tiQmNDYk1PbHlVZ05FQUExbWZ3OUFVYm9aT3ZV?=
 =?utf-8?B?YUNrZ3pjL3hQV3hHLzZpZE00NUJTU3UxR3lFOEYyVStkMUFBMTJrZzZ0SjJp?=
 =?utf-8?B?YW1OYm5EQndXaTd4YnJhS0FnNisvdzljdjhLWXFFckQ3dHZOTHJvakMyMUtw?=
 =?utf-8?B?Ty9hUzg1K1dtMGZOMEpFZTdicXU0ZXQ4UTFvcTdQckplSFl5bTNrKzRhWHUw?=
 =?utf-8?B?b3ZYaWV5VVBCaVdVbUYyT0RVRUd6ZEt1Wm82bUxST2hQYXVGQXJrUE14cCsw?=
 =?utf-8?B?M21IU2o1WXNrMGFDRnFXTkNkSnNrcEJoWmZjUWdkL2dvNGpudVJSZVVHUG1j?=
 =?utf-8?B?SE9sRmVJemt6QkVjSkdYZUtDVFJSdG1nUHgzR2ZGRVlCUTRrTUJ5elU0SFgy?=
 =?utf-8?Q?uYL0xTxMTseBJdhFaOxXubQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE0CE3AB3BEC9F40A23D1662BCE43AED@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2fd164-b52a-479f-276a-08db3c0114ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 09:25:54.7332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W1K+u72GhLpy1JYWPfFsaluG7QWDcJ0DttBjV/v9BwCqTKQ/VsZtZzq3K9PGphWjYN6lp480YSE3JCRFjc9Bxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB3822
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC8xMy8yMyAwOTo0MCwgTWlrbG9zIFN6ZXJlZGkgd3JvdGU6DQo+IE9uIFdlZCwgMTIgQXBy
IDIwMjMgYXQgMTU6NDIsIEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRAZGRuLmNvbT4gd3JvdGU6
DQo+Pg0KPj4gTWlrbG9zLCBKZW5zLA0KPj4NCj4+IGNvdWxkIHdlIHBsZWFzZSBhbHNvIHNldCB0
aGlzIGZsYWcgZm9yIGZ1c2U/DQo+Pg0KPj4NCj4+IFRoYW5rcywNCj4+IEJlcm5kDQo+Pg0KPj4N
Cj4+IGZ1c2U6IFNldCBGTU9ERV9ESU9fUEFSQUxMRUxfV1JJVEUgZmxhZw0KPj4NCj4+IEZyb206
IEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRAZGRuLmNvbT4NCj4+DQo+PiBGdXNlIGNhbiBhbHNv
IGRvIHBhcmFsbGVsIERJTyB3cml0ZXMsIGlmIHVzZXJzcGFjZSBoYXMgZW5hYmxlZCBpdC4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBCZXJuZCBTY2h1YmVydCA8YnNjaHViZXJ0QGRkbi5jb20+DQo+
PiAtLS0NCj4+ICAgZnMvZnVzZS9maWxlLmMgfCAgICAzICsrKw0KPj4gICAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZmlsZS5jIGIv
ZnMvZnVzZS9maWxlLmMNCj4+IGluZGV4IDg3NTMxNGVlNmY1OS4uNDZlN2YxMTk2ZmQxIDEwMDY0
NA0KPj4gLS0tIGEvZnMvZnVzZS9maWxlLmMNCj4+ICsrKyBiL2ZzL2Z1c2UvZmlsZS5jDQo+PiBA
QCAtMjE1LDYgKzIxNSw5IEBAIHZvaWQgZnVzZV9maW5pc2hfb3BlbihzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4+ICAgICAgICAgIH0NCj4+ICAgICAgICAgIGlmICgo
ZmlsZS0+Zl9tb2RlICYgRk1PREVfV1JJVEUpICYmIGZjLT53cml0ZWJhY2tfY2FjaGUpDQo+PiAg
ICAgICAgICAgICAgICAgIGZ1c2VfbGlua193cml0ZV9maWxlKGZpbGUpOw0KPj4gKw0KPj4gKyAg
ICAgICBpZiAoZmYtPm9wZW5fZmxhZ3MgJiBGT1BFTl9QQVJBTExFTF9ESVJFQ1RfV1JJVEVTKQ0K
Pj4gKyAgICAgICAgICAgICAgIGZpbGUtPmZfbW9kZSB8PSBGTU9ERV9ESU9fUEFSQUxMRUxfV1JJ
VEU7DQo+IA0KPiBmdXNlX2RpcmVjdF93cml0ZV9pdGVyKCk6DQo+IA0KPiBib29sIGV4Y2x1c2l2
ZV9sb2NrID0NCj4gICAgICAhKGZmLT5vcGVuX2ZsYWdzICYgRk9QRU5fUEFSQUxMRUxfRElSRUNU
X1dSSVRFUykgfHwNCj4gICAgICBpb2NiLT5raV9mbGFncyAmIElPQ0JfQVBQRU5EIHx8DQo+ICAg
ICAgZnVzZV9kaXJlY3Rfd3JpdGVfZXh0ZW5kaW5nX2lfc2l6ZShpb2NiLCBmcm9tKTsNCj4gDQo+
IElmIHRoZSB3cml0ZSBpcyBzaXplIGV4dGVuZGluZywgdGhlbiBpdCB3aWxsIHRha2UgdGhlIGxv
Y2sgZXhjbHVzaXZlLg0KPiBPVE9ILCBJIGd1ZXNzIHRoYXQgaXQgd291bGQgYmUgdW51c3VhbCBm
b3IgbG90cyBvZiAgc2l6ZSBleHRlbmRpbmcNCj4gd3JpdGVzIHRvIGJlIGRvbmUgaW4gcGFyYWxs
ZWwuDQo+IA0KPiBXaGF0IHdvdWxkIGJlIHRoZSBlZmZlY3Qgb2YgZ2l2aW5nIHRoZSAgRk1PREVf
RElPX1BBUkFMTEVMX1dSSVRFIGhpbnQNCj4gYW5kIHRoZW4gc3RpbGwgc2VyaWFsaXppbmcgdGhl
IHdyaXRlcz8NCg0KSXQgdXNlZCBoZXJlDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2lvLXVy
aW5nLzIwMjMwNDAzLXdvdW5kLXJvdW5kd29ybS1jMTY2MGUwNTliOGNAYnJhdW5lci9ULyNtNWY4
Njk4NWQ2YzY3ZGQxZDAxYTk3NzQ3NWRhYjU0MmMzMzgzNzJkZA0KDQoNCmZ1c2VfZmluaXNoX29w
ZW4gaGFzIGl0cyBvd24gbG9jaywgc28gbGV0dGluZyB1cmluZyBoYW5kbGUgcmVxdWVzdHMgaW4g
DQpwYXJhbGxlbCBzaG91bGQgbm90IGh1cnQ/IElzIHRoaXMgZ29pbmcgbGlrZQ0KDQphcHBsaWNh
dGlvbiAtPiB1cmluZyBkb2VzIHBhcmFsbGVsIHJlcXVlc3RzIC0+IGZ1c2Uua28gLT4gZnVzZS1k
ZWFtb24NCg0KU28gd2hlbiBmdXNlLWRlYW1vbiBzaWduYWxzIHRoYXQgaXQgY2FuIGhhbmRsZSBw
YXJhbGxlbCBESU8sIGl0IGlzIGp1c3QgDQpmdXNlLmtvIHRoYXQgbWlnaHQgbmVlZCBpdHMgb3du
IGxvY2sgdG8gZXh0ZW5kIHRoZSBmaWxlPw0KDQoNClRoYW5rcywNCkJlcm5kDQo=
