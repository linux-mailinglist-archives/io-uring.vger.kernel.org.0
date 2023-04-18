Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE58D6E6511
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 14:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjDRMzt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 08:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjDRMzr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 08:55:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE03615600;
        Tue, 18 Apr 2023 05:55:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuMuo5oD6pIVumjH+KBZYL1suB99wt80mpJvq5lIX0TJ2L62vrhvdRGMUqwvYLylpipK6CNu5PQshZzpKNpCoQE8zgiVWDv/+jg1Asrz9k6EzGoDwwHiZrIywBAwkGYrS4PDSMF/kYluDUe4MTH3bRptcdxjXtXA1kguBIiLew1BrBZTxtB9DzgpoRA8OLQDuH++MgVM6UVzGcNbss+0XHyoPRrjXOCq0kYfod/zVx711Y92UfaLlKIchOA7cnd76aeshcBBkZGiNeL/stZIClKzrcF4bQKJGFlnpdsiXkuV39K1zie2gImiH0PdOxrg1JB49wkVqLExG/3h9FxiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCV82di+9P7zs/mroLltwFHIbqU1OKMsaJgOSXh8XDA=;
 b=RlPcnOI644oeXCMfWXkeiD8SGco1+9LNHrY1AIptGzjksU4JRiDYYHImFMT6+XFN4RkcREvc+61l7gWuD6gkMSIiTupuakvHaPGkD8Isn2PPOhWpO68l+uigfCsTz6ePSF3NCjna386WzjulGRaixjzyJ7m+djVz2/fUiZF/Bpa0G8xGnzh7864kJtaMQP17doat2QJqVnGaB35jQtkjnbpPIuzgS8dm1NjODlxkLoyC/VZ6A0KXOsNpv/7Un29sUoJw7LcfjpvPDCGJi67LOVJH0yoeki/aFf3+CB6Z01RgI++NbXZZoiDjJDSdh/Kh5yESOapc4yTSOXkymNQjGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCV82di+9P7zs/mroLltwFHIbqU1OKMsaJgOSXh8XDA=;
 b=tvWU1sc6MHO+Z+kInuXaSVnhlCJBXJ6tDuuWHQqV80EuxIcxivJayMuLpSIaPPUVoRiV8TJHRZyzolYmRJ4fDYERmG81XtDvWTrFGStGvy91UZ30Mns7A43StM2zM30BgqoGALSm+CPbafKlut2kzzzQCY6nywYDgWOKvtnMetQ=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by PH7PR19MB7098.namprd19.prod.outlook.com (2603:10b6:510:209::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 18 Apr
 2023 12:55:40 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%6]) with mapi id 15.20.6277.031; Tue, 18 Apr 2023
 12:55:40 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Thread-Topic: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Thread-Index: AQHZbUSFJ5BWwL3ovkmLZXgJpNfXLq8o2+eAgAFosgCAAK6MAIABaxyAgAStj4CAAAPNgA==
Date:   Tue, 18 Apr 2023 12:55:40 +0000
Message-ID: <e4855cfa-3683-f12c-e865-6e5c4d0e5602@ddn.com>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
 <ZDjggMCGautPUDpW@infradead.org> <20230414153612.GB360881@frogsfrogsfrogs>
 <cfeade24-81fc-ab73-1fd9-89f12a402486@kernel.dk>
 <CAJfpegvv-SPJRjWrR_+JY-H=xmYq0pnTfAtj-N8kG7AnQvWd=w@mail.gmail.com>
In-Reply-To: <CAJfpegvv-SPJRjWrR_+JY-H=xmYq0pnTfAtj-N8kG7AnQvWd=w@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|PH7PR19MB7098:EE_
x-ms-office365-filtering-correlation-id: 9e28eaf3-d75a-41cd-ad40-08db400c3695
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F4j65jfIO3gonrJ0Of7VTnOJaFNWhx/w6TDCLJMacPpRJ6EF+OWjjxBkJlOdITWb1rIcf9mZ4vJCXCrGuqfCkRwf87nu4BCp6vlUlquEbdkFQCB9JWvFNMQo+a6S5AtrbIpLiMiImcq2JiABssyHr7z6nmdWmhXKzJQqXpMXyhhBgAQnkOM/puoQu7Yz6294pL1A7BCK07OSoGrHGGA6F4TGwORQvVwICPGutWAaZgJNhfYOe7gyRCA3gURu6szI6NjzJXWH26qrezASjM0v1OIqoSwPRfLq9wife7ezhynPn5bIimXqn5Kboqea3JnTRWG/3qeutWpf0gIveONDqlq0otzzdb7/iEACe1YiFyykxSOrq0d4GYRdkBGttusxRHgFzCduD30PT8cd420I3K6S3YQgLNdjRyxa+yip29edfaiWm3k63fzWZS46qNbCbZeLA8TjTzJIBaF+bp1BwYaAA/EAxCj3ICpld8rICyUB5ytXwRH+Aa6jBsYAO9NXQuP3t/jjcfx/ZM2Qw84nMa9REz9eUhnbWvxfwKI7ez3wHvahTQ/uso+ttCcfJSM+6tUFeBpKY+o8PQtTY/6/r1LY+nLqWTzhEhk8a2sb0OEq1CjiGTtqHk4CbzlQzTp+DhfIW8XOWXq9DAjrLCzJn+R5GTtFSRKRwGA6HLAtrmVywqHkrfTcOh/Khk8S/Tx+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39850400004)(376002)(366004)(346002)(396003)(451199021)(2616005)(36756003)(91956017)(6486002)(71200400001)(86362001)(31686004)(5660300002)(83380400001)(2906002)(38070700005)(110136005)(6512007)(54906003)(6506007)(186003)(38100700002)(478600001)(53546011)(31696002)(122000001)(76116006)(64756008)(4326008)(66556008)(66946007)(66476007)(66446008)(8936002)(316002)(41300700001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTNKU2pKaW1wa0cyQW5hT2VTK1kwbHhDdDNJTlpWU3ExakplbHRkQVhvditR?=
 =?utf-8?B?YVBTZUpFZGpsQ2F1aXBWMWtJYjllNHlCVDNWdlFscE5BbC9zZWVYaHF4NVV2?=
 =?utf-8?B?cWRabWNqMXBKTGdud1pjeTA0SmJvYm9EMFRoQy9oeU0vRlBScjV5YTJ6Q1lm?=
 =?utf-8?B?VVRvSEFxK2FJSGViZGpuSWNzekRpODQwT3pJWXZQQlJYNDFKN0QremllMi9t?=
 =?utf-8?B?WkhXVVVsaG90UFg2RGZCaG9hNThwL2JTakJoTTNERmY2QklxWTBnSEdvNS85?=
 =?utf-8?B?Rmt6YVZWamlVY2xpOEN2bVVkTzZGUVF1c1dKbEx4c0FYWUo2cWFSL2J5aU9u?=
 =?utf-8?B?em5xTmIxbmtiL2ZXcEJnekRWTTd2ZEh4M0JzamZ4YnFrRVEvNzdlKzhWMVpr?=
 =?utf-8?B?bVMrUWFCbjNnMEFQcEh5eExWQ3Y1WmU5QW1GY2JUc0UzSWdkendVVTlFNW5a?=
 =?utf-8?B?cVhOOUo3d09vRE8rMFAwYUJFY1ZnS0RmVnFWWEJLaWNIeFREb0psbnd1Wkl1?=
 =?utf-8?B?dG9xbEs2ejVCb3hmMkdWNVJqZjkyN1VQbks0NlpRK2RvanE0NlFUQkZDQUk0?=
 =?utf-8?B?WkZ5OFNvQTNYdXdGTXBNOEUvd1pNS29iczJNbStybFJOMFgzUDdLMGdkWG5a?=
 =?utf-8?B?K3puWXdPT1E2MlFEUG9DekdBNzVmU3VaMnBxV29DQ2FWcXEvUnpTNFIrWTFo?=
 =?utf-8?B?M29uWXlVeFhSQ0d6T29Td0k3c25hN2dqanl2ZFZrRHhOZnpUQWFJVDArRUgr?=
 =?utf-8?B?UXQrcy8zaERJcnNtU0hMeEwwaEhNblg4TFdUTVl5djVjdmpXaU1DU1FMQmJ4?=
 =?utf-8?B?S3JxQU5yTFg5N2ZRcWNNWEVQMElZNnlud3hQajBlOEhQSXQ5US9MZE1kRnNS?=
 =?utf-8?B?NjZaMW5PbUg4a1VOZThid2VVMHhnVmN1L04zV1JJOEhzaGxBbjRML2x1M00y?=
 =?utf-8?B?YmUwK3N2T2pVTVVtVzJVcURybWlQQ3lSYlc5M3hGRVlXaW0rdnZzbE9VRnpR?=
 =?utf-8?B?UFpIK1NaT05qRHhqSzc2WllQUFJWc1ZwbXBjWFBMc1JBNGd6NjVBelBadlov?=
 =?utf-8?B?UUFZYUQ1QkFlaE5vaFNwOUpHUUZ4WVJzdjZjeGJXakVyY0lwV01YbFRDcE81?=
 =?utf-8?B?N1BWQ1ZzWElYd3hZb1ArZVM1VCtzS3VJSTZPemM3emJadllocGlST25kUGFl?=
 =?utf-8?B?QzNzQUcrQk9OaDJSNzI4WVdqS2U1cFZGS0JqR2Vlclp5Y2N2UGZUQ09YaFhx?=
 =?utf-8?B?dGVNRjQ0U3JGM0krQ1AwbEE1bUIzUmNsa3pnWHo1cC80QWVTMGVmc0lwSGto?=
 =?utf-8?B?aWY2OTkxSFd5aHpJdVNzVTRGaHJtVlRna2diK2JLdG9BSUp3MS92ZU1NZnl6?=
 =?utf-8?B?c2wvMU44a3NpaUVmUVdKR3RteTMyT0JIUVljTE1xVE5zOGd1Q3RLYmc0Q2lF?=
 =?utf-8?B?d1VOQXZjdktaaU8wbEZWS01hcUoxSXRPVVBXYmNoeTJzaStSS3IyQXd1V3Mv?=
 =?utf-8?B?aGpBaDJ3aDduaTk2bnVFQlRTZGFtN3pLUlRLUUVPaVZ1TWlDM2s3a25pbVc1?=
 =?utf-8?B?a2Fob1ZtWVBWNTlCWnkvb2p4V0JUcWtucFFYcTNHRElhT0VFUDVTTjROWU5O?=
 =?utf-8?B?T0dIUjNQZkFjOTRNM3pDbDZNYWdGZ0QrZnVBL3RiTDVjbHZiVW5oR3Z6STY3?=
 =?utf-8?B?emNkRlJyZ0E2ZXl4S1d5VXJWMTdKZkRhRUxGd1IxWEpRMlhnUTdGa3pmS2Z1?=
 =?utf-8?B?YzFTQjRDNE5Ud0RWOTNxM0lvQnFQUzJPWFhITnNoeDRuVElSdmZzcGh0WUFw?=
 =?utf-8?B?bW16d0ZqbVlOaWVzQzYxVm1HY3MzUkY2UjE2QnlHN0dnZjRjZUJaYVBtc2NV?=
 =?utf-8?B?RU1tZmgzdEZkVk51bVZxdlhDNk1MU3Q2QjB6UmV5eGtaVDNLM0Yrc2xWQXk4?=
 =?utf-8?B?Rm9BTEw4TlhleDE5M1phK0ZONUljSnB0cXlqa082d3J4WXZDWnR3ckN3TDlZ?=
 =?utf-8?B?N0J1aWpueURVL1JTRW1tUlNDa2JLNjRFSFNnblBlSTFGREphYm91VFVQVFVa?=
 =?utf-8?B?MWwrd3RPZnA4ejFiZTFGMm9rQXJNdGhscFBGUDVUaE9XRkltRUxQdlZObUJW?=
 =?utf-8?B?S040NzZRbVo2TmE1d1huUFkzRlpuZTdhS3dKQXpUQXljcmxFTkhpb1BCQ0Nj?=
 =?utf-8?Q?IIa9C/Phzu52j3nwLgduHlE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71752716967B454DBBC5499EAF99A7A6@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e28eaf3-d75a-41cd-ad40-08db400c3695
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 12:55:40.2465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iT0KS5NvbYwskuPksNP0/czuw0m6lJ3Ud+nvehob9vxxO5mdgEaye72KIlwDbbIVcRR8t+Dlqrp4EKGmqr1GRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7098
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC8xOC8yMyAxNDo0MiwgTWlrbG9zIFN6ZXJlZGkgd3JvdGU6DQo+IE9uIFNhdCwgMTUgQXBy
IDIwMjMgYXQgMTU6MTUsIEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4gd3JvdGU6DQo+IA0K
Pj4gWWVwLCB0aGF0IGlzIHByZXR0eSBtdWNoIGl0LiBJZiBhbGwgd3JpdGVzIHRvIHRoYXQgaW5v
ZGUgYXJlIHNlcmlhbGl6ZWQNCj4+IGJ5IGEgbG9jayBvbiB0aGUgZnMgc2lkZSwgdGhlbiB3ZSds
bCBnZXQgYSBsb3Qgb2YgY29udGVudGlvbiBvbiB0aGF0DQo+PiBtdXRleC4gQW5kIHNpbmNlLCBv
cmlnaW5hbGx5LCBub3RoaW5nIHN1cHBvcnRlZCBhc3luYyB3cml0ZXMsIGV2ZXJ5dGhpbmcNCj4+
IHdvdWxkIGdldCBwdW50ZWQgdG8gdGhlIGlvLXdxIHdvcmtlcnMuIGlvX3VyaW5nIGFkZGVkIHBl
ci1pbm9kZSBoYXNoaW5nDQo+PiBmb3IgdGhpcywgc28gdGhhdCBhbnkgcHVudCB0byBpby13cSBv
ZiBhIHdyaXRlIHdvdWxkIGdldCBzZXJpYWxpemVkLg0KPj4NCj4+IElPVywgaXQncyBhbiBlZmZp
Y2llbmN5IHRoaW5nLCBub3QgYSBjb3JyZWN0bmVzcyB0aGluZy4NCj4gDQo+IFdlIGNvdWxkIHN0
aWxsIGdldCBhIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24gaWYgdGhlIG1ham9yaXR5IG9mIHdyaXRl
cw0KPiBzdGlsbCB0cmlnZ2VyIHRoZSBleGNsdXNpdmUgbG9ja2luZy4gIFRoZSBxdWVzdGlvbnMg
YXJlOg0KPiANCj4gICAtIGhvdyBvZnRlbiBkb2VzIHRoYXQgaGFwcGVuIGluIHJlYWwgbGlmZT8N
Cg0KQXBwbGljYXRpb24gZGVwZW5kaW5nPyBNeSBwZXJzb25hbCBvcGluaW9uIGlzIHRoYXQgDQph
cHBsaWNhdGlvbnMvZGV2ZWxvcGVycyBrbm93aW5nIGFib3V0IHVyaW5nIHdvdWxkIGFsc28ga25v
dyB0aGF0IHRoZXkgDQpzaG91bGQgc2V0IHRoZSByaWdodCBmaWxlIHNpemUgZmlyc3QuIExpa2Ug
TVBJSU8gaXMgZXh0ZW5kaW5nIGZpbGVzIA0KcGVyc2lzdGVudGx5IGFuZCBpdCBpcyBoYXJkIHRv
IGZpeCB3aXRoIGFsbCB0aGVzZSBkaWZmZXJlbnQgTVBJIHN0YWNrcyANCihJIGNhbiB0cnkgdG8g
bm90aWZ5IG1waWNoIGFuZCBtdmFwaWNoIGRldmVsb3BlcnMpLiBTbyBiZXN0IHdvdWxkIGJlIHRv
IA0KZG9jdW1lbnQgaXQgc29tZXdoZXJlIGluIHRoZSB1cmluZyBtYW4gcGFnZSB0aGF0IHBhcmFs
bGVsIGV4dGVuZGluZyANCmZpbGVzIG1pZ2h0IGhhdmUgbmVnYXRpdmUgc2lkZSBlZmZlY3RzPw0K
DQoNCj4gICAtIGhvdyBiYWQgdGhlIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24gd291bGQgYmU/DQoN
CkkgY2FuIGdpdmUgaXQgYSB0cnkgd2l0aCBmaW8gYW5kIGZhbGxvY2F0ZT1ub25lIG92ZXIgZnVz
ZSBkdXJpbmcgdGhlIA0KbmV4dCBkYXlzLg0KDQo+IA0KPiBXaXRob3V0IGZpcnN0IGF0dGVtcHRp
bmcgdG8gYW5zd2VyIHRob3NlIHF1ZXN0aW9ucywgSSdkIGJlIHJlbHVjdGFudA0KPiB0byBhZGQg
IEZNT0RFX0RJT19QQVJBTExFTF9XUklURSB0byBmdXNlLg0KPiANCg0KDQpCZXJuZA0K
