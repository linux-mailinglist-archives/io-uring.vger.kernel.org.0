Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF5D6EB96A
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 15:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDVNkc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 09:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDVNkb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 09:40:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F318E10F0
        for <io-uring@vger.kernel.org>; Sat, 22 Apr 2023 06:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzaExowi0Qrro+Y9kR00wZkkOF/yp5ayxc1PMGdt7OdvvXWUhmAzJFJ9JXqZr+d5sTv6LB0R+un1Tuiaoqk3kLxlDkRDTmGd9u2D+2ob9zJ4QucP8NSDRcBk0PRj6slcqr8YkKEtQO1jRHX+4VlG69sI5gxiRylXW1TR3+WBfiSgouZo+AMUwxzC1FqDkIMCNfAgYju7DQX69x7tEdSshL8Lwjq0vGmKPqXRXgvbMWSMRgWqEL2njEkAtSA3Q6+0FjDemNN/jDU4huW/wtuQl5Ht0zfBGSlHUKujtRcoOlaYMLEX05fFAMveHq8UBwgdakJ635aa0OvmUNU+CLuYkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tsDo8TdCNN8jiCe0CJxNGuUflkJ6rfUaIWBA7fZq0w=;
 b=YTagQFCDCRgPoAv8Qzx1Zj78covNbWfXXEHPrmV6L1ckao/JMRjvaK8JAWUkfpaZ1+SiZcILjr0KJpqus0JV2lLfF5030AYaZ46YKMpBl845yWnc0xgBxhcfFI/ddmVslkMxisWIIOOkfw+a+5ahfP5z1mf8NIDq23g8Myf4C6Jdqm+MIFGt39f/JvxX3eeKLY/vA5bxr3TDzOIAgPRJEJD95XqNlPI4dZmtJ5NqYYejllC1Zkx+2wNx/l9/il1+1SFGxuV6eSIknC1ybPRJf4zlLkNnoZ6MlFLomBB8tVoFB8ozjedjmnIjktuTMCm78yf6IYFSRWEgkwDhRiEXbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tsDo8TdCNN8jiCe0CJxNGuUflkJ6rfUaIWBA7fZq0w=;
 b=onALMtwmUwtxLxPBpt0RUOUcxqhihX+NCrNorlI6vzF3lkayYTbUBOFrGOQs9qIrLCjv0bmrdYv+Goy3uK8oNQnTnNtd2VzUse7reqDkKHjXVR5TYc6nT9ovA+Ft6H4wJOAiy+R6h7E3Ka+ujTBEMb6OzDZdZyg5RAwj3YkDGAo=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by MW5PR19MB5626.namprd19.prod.outlook.com (2603:10b6:303:1a1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 13:40:25 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%4]) with mapi id 15.20.6319.022; Sat, 22 Apr 2023
 13:40:25 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Ming Lei <ming.lei@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: SQPOLL / uring_cmd_iopoll
Thread-Topic: SQPOLL / uring_cmd_iopoll
Thread-Index: AQHZdJ31NW7cB5aBVU+6YmLVne2Nba82lucAgAC/1wA=
Date:   Sat, 22 Apr 2023 13:40:24 +0000
Message-ID: <7a9525cd-a0b0-e23c-d0ff-a9f010f009ba@ddn.com>
References: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
 <749cda6f-9e64-f89b-9d1d-e1943d7b339a@kernel.dk>
In-Reply-To: <749cda6f-9e64-f89b-9d1d-e1943d7b339a@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|MW5PR19MB5626:EE_
x-ms-office365-filtering-correlation-id: acb68ff8-40f7-479c-5638-08db43372056
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pQiPDPtIGWpFyBj6v4LWFrbMr/p+S9YSpnQuSBsW9meYw5PNT+P/+yTmLvoiSHLF6bk+piZAc1jIcuP8lwfweuFzikLsQyVSnTfUSjbE4q92TkjCgyUZVmNApO0O3/7/ElNHXLVRw0QwRg57hXW2zjcrPORuBougWLNLKW41e5/lP0p457fy9NXkS5nUEdGz8JEB5Ave/ST68BU4qIRaQnlHLz0zsvbTBTgS+0GCy49zEYvxWuAFYafAlHjeUb7XTa1y0lXGu5BLQzxNuMCApqEgBtxKtybl4qq34EBv+j6OUd6WhVXx9uqYtreMbt6kN9rBKfgPdS+mt6V8njpVSGe20AqwHj5hsoyZ9EbnkooNs3Wo5eNvvuxx5mlO89Vd9XNmYDmU6Ce9Whhi9S87NawdYDnbTiVTHYuEgKATv16yH2kmhFijVPY9w5HLKGOQ55KO9nDP6Mu1cAcTytS4xoitgl3GjTptV+WBTyDQztCB+Ir/lT8iU9Zon9KnwmpOQsIZ2EIxSggjrK5O/s4wJhduRC31fm0TNL9L/6M2JP8s2pUF+BsXvENrxZA7JPEg1LKiz0y/WYpcAQvVEZpUja9HLG8X9Nk9g6CvCvUAeItGExnNPaXFyYI8uAJ4M3/fP09mieZVimlxMhRFnUJGPOxC/n9AOmPo9rdqeZkHveV7Xr9MfceMSEKBP3VJHKT8mwCCzGGN/sb5wGZOwftaug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39850400004)(396003)(366004)(136003)(451199021)(478600001)(54906003)(110136005)(83380400001)(36756003)(2616005)(53546011)(6506007)(6512007)(186003)(38070700005)(31696002)(86362001)(38100700002)(122000001)(966005)(6486002)(71200400001)(76116006)(8936002)(316002)(8676002)(41300700001)(91956017)(4326008)(66476007)(66446008)(66556008)(64756008)(66946007)(5660300002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aStGQldwM0V3QmZBOGk4aHFpOUtsUzFOMk0wc2sxL3NvdVZZSWVYenhySG1Q?=
 =?utf-8?B?MlA4SUJ4N1B0ZWptYndnRTdHKytWeU9sZW9YT0NlenJBQTJINC83MFUySjRz?=
 =?utf-8?B?MXJFVUVMR1J3Z0kwa2FXczZNUFJPKzZSM2pwYXFFUTRjU0lkaFNJVUx6RDUx?=
 =?utf-8?B?VzN5cEUveUZCNnUzUHppdlVvV2p1bzFtd093enZHdDJEai9CTTdBNzN1L3Mx?=
 =?utf-8?B?RXNkSXcrWU9GaFJ4VGc3TzBvSGZLdWVUd2dGSmdvK3FMaGF1TGE4Zm9YZkoy?=
 =?utf-8?B?V2lHTGk5N2VFcDhXMG1aaEZtZGRmY1B5ZktOOTJySlNrdEsvUVlFQklVblgw?=
 =?utf-8?B?dTdBdXhQZXpDSWJtenRnMEplWXh4cVF2L2xEeko1QS90U2hUSXhGZm9reGJS?=
 =?utf-8?B?VllKbE9US2IzbDhyOXJxaDhKTTVyNkpqaWI3Nk5zWWxneExkUTNGdm1jL0Zl?=
 =?utf-8?B?Q1Z0OFBkb1BZaXU0M3ZXcXdBVEtQeHR1VjFmSUMwUUxKMElhTHp2b0owV2tP?=
 =?utf-8?B?aXlBK1R3Z0lYM3AyMW5iUlB1c1d6SFVGZmVncHRyOXBHUDJSc1o3aFpZUGRa?=
 =?utf-8?B?YlJKNzVBZDJtcHZJbHlkaEZkS0M2N0thRzRhM2h0aWRVTElDeXhLa2NLeTU5?=
 =?utf-8?B?SXdyYzhJdFZsU2JQa0Fxc2N5TmFlWWM3d0lrYzV3eGtjSVhBSDBFaDZydTBu?=
 =?utf-8?B?MDFMYXFMWXd1V2l5K2V3RjBER05udTlwVHphbklZL05TSXZ6dzR5TTlLL2lw?=
 =?utf-8?B?SnNQbXNZdkJQbkpnODhFdlE1TDMyYnB5dFdZVVpkR2JDaXBIQUZlVHZYMWZu?=
 =?utf-8?B?ZjVmRkNjREFZTjBWS2p3WFZ6QmNGV1d6S3o3V2dlSjllVVVPUWlaeHFsbUlv?=
 =?utf-8?B?Mm9SaUJ4T0UrM0t4MkdGdmVYcjZXMmhTRFpvaXB3Y1ZaUXRJaEZYMDFrRHI1?=
 =?utf-8?B?Uy9DWWZocWN4Yk1pR2RHUStRR3poTHgrL1Ywb3FRV1lqaEh6YXpvM21pRmxk?=
 =?utf-8?B?R29VMml1NnNZbHNMUGFVZnFyS0RyVTgxZ3ZjTXpnS1VaQ3d4aGZTbzJnbk9o?=
 =?utf-8?B?SHU1WHdaeCsrYS9UQllDc2ZKUU0ydDRRa3gwenpLRHNOcGRRVmdoZEJtRVkw?=
 =?utf-8?B?V1VPamlrdGlzNjN0eS9UM0NFR1NRWU9qYUlLUWlpMlBzVUlzaFFHSGoveWhB?=
 =?utf-8?B?QzBGYTZ5VkdJN0d4VGJ4dW15WkFvcjlZZHRSendOOU1vUmozcXpKRGtVU0VV?=
 =?utf-8?B?OXh6blBaemFXd2VlSVJ5dHArWnMwU1BhODlORmF4YVJsMHV4RkRPNWcwQnlN?=
 =?utf-8?B?Zit2Q2VZNS95amJ2Q0F4b1g4UHdjYTBHdGxnZko3NHoyZytHT0hpVlBwYUoz?=
 =?utf-8?B?TnRyeFk4Rzc3OC8wK1B2UXBZSHNydnlpd3dYc0YzQUNpb2RSWkFsYk43cTIx?=
 =?utf-8?B?VklWdy9HRDhZa2pOQ3pkRU1sUGsreTNDdGxHMDNSMUppa0R5Rm1nd2k4UW1S?=
 =?utf-8?B?dDc5RFYwR0FGQ0lPK2RnbldNdGxLNTdPbVJFUGZCaTBQdUdhV3N4TXF1eFVh?=
 =?utf-8?B?eGQ4WE8vSG0wSkxHWk4rbVRWUWxPOGw3WXhENU1GU2w2UUlyVkh6dms2V3d4?=
 =?utf-8?B?M3BsNzBDS25VUkdXdlU2QXByeENyRml2ekNiSVVWZEhiUm9PdDg0NnJEamxx?=
 =?utf-8?B?SEtPemZmTkEzTWtSNHFUMW50bmJwZDNRZWlxTzQyUjRhdkNsZnp5Uk9UUURQ?=
 =?utf-8?B?V2RGKy9ZVkNORUVUNnB1dThNeWpFMnQvZUhwbWd5NVI4bURTeVY1RS8yTmNM?=
 =?utf-8?B?U1hTYy9ETm1OOU4wMTFYdTlvbmtqTHQzZ1pLODM5a2NwNWpvTmhzWDlONGsx?=
 =?utf-8?B?SThLRVpoblRQVENMT1hzMHRSV3owTGNyN25LZS9TanFqTk9vZnpBRG92T1Qr?=
 =?utf-8?B?T0pubXo3SnpEaHB2MVdVb21KZzFFcUJOT3gyK3ZFUXAzREJ1WWRidUVOTjJO?=
 =?utf-8?B?dzVYMTR0N0lZVUp3M3h0UUpXWThSM0doUG1NMGw5NVhOZW4rVzVhVXBjVXV4?=
 =?utf-8?B?clpMVkdhYzl0SXNqbWM3ZWdEdTU5UFo3eGRyR2Q2TmlXSS8vcEJhOUFzTzB2?=
 =?utf-8?B?V096YklDdjRkbmFqUlVsTENwL3NJTWZWemdQYUQ5cmZkUHRGMGZWcDNDVzNj?=
 =?utf-8?Q?r4ga2YwgWBaiKzc57diBTX4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F81F355D932B7D469708EA6DAABA123E@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb68ff8-40f7-479c-5638-08db43372056
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2023 13:40:24.7223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5G22ok4z8R50FEmBvVwlzcBYoEp2tZElVE4baaCIno8HfqjX6JAMFPCQqyATzku1SE2VDWgVrqMC0MASrF/6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR19MB5626
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC8yMi8yMyAwNDoxMywgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gNC8yMS8yMyA0OjA5P1BN
LCBCZXJuZCBTY2h1YmVydCB3cm90ZToNCj4+IEhlbGxvLA0KPj4NCj4+IEkgd2FzIHdvbmRlcmlu
ZyBpZiBJIGNvdWxkIHNldCB1cCBTUVBPTEwgZm9yIGZ1c2UvSU9SSU5HX09QX1VSSU5HX0NNRA0K
Pj4gYW5kIHdoYXQgd291bGQgYmUgdGhlIGxhdGVuY3kgd2luLiBOb3cgSSBnZXQgYSBiaXQgY29u
ZnVzZWQgd2hhdCB0aGUNCj4+IGZfb3AtPnVyaW5nX2NtZF9pb3BvbGwoKSBmdW5jdGlvbiBpcyBz
dXBwb3NlZCB0byBkby4NCj4gDQo+IENlcnRhaW5seSwgeW91IGNhbiB1c2UgU1FQT0xMIHdpdGgg
YW55dGhpbmcuIFdoZXRoZXIgb3Igbm90IGl0J2QgYmUgYQ0KPiB3aW4gZGVwZW5kcyBhIGxvdCBv
biB3aGF0IHlvdSdyZSBkb2luZywgcmF0ZSBvZiBJTywgZXRjLg0KPiANCj4gSU9QT0xMIGFuZCBT
UVBPTEwgYXJlIHR3byBkaWZmZXJlbnQgdGhpbmdzLiBTUVBPTEwgaGFzIGEga2VybmVsIHNpZGUN
Cj4gc3VibWlzc2lvbiB0aHJlYWQgdGhhdCBwb2xscyBmb3IgbmV3IFNRIGVudHJpZXMgYW5kIHN1
Ym1pdHMgdGhlbSB3aGVuIGl0DQo+IHNlZXMgdGhlbS4gSU9QT0xMIGlzIGEgbWV0aG9kIGZvciBh
dm9pZGluZyBzbGVlcGluZyBvbiB3YWl0aW5nIG9uIENRDQo+IGVudHJpZXMsIHdoZXJlIGl0IHdp
bGwgaW5zdGVhZCBwb2xsIHRoZSB0YXJnZXQgZm9yIGNvbXBsZXRpb24gaW5zdGVhZC4NCj4gVGhh
dCdzIHdoZXJlIC0+dXJpbmdfY21kX2lvcG9sbCgpIGNvbWVzIGluLCB0aGF0J3MgdGhlIGhvb2sg
Zm9yIHBvbGxpbmcNCj4gZm9yIHVyaW5nIGNvbW1hbmRzLiBGb3Igbm9ybWFsIGZzIHBhdGggcmVh
ZC93cml0ZSByZXF1ZXN0cywNCj4gLT51cmluZ19pb3BvbGwoKSBpcyB0aGUgaG9vayB0aGF0IHBl
cmZvcm1zIHRoZSBzYW1lIGtpbmQgb2YgYWN0aW9uLg0KPiANCj4+IElzIGl0IGp1c3QgdGhlcmUg
dG8gY2hlY2sgaWYgU1FFcyBhcmUgY2FuIGJlIGNvbXBsZXRlZCBhcyBDUUU/IEluIHJ3LmMNCj4g
DQo+IE5vdCBzdXJlIEkgZm9sbG93IHdoYXQgeW91J3JlIHRyeWluZyB0byBjb252ZXkgaGVyZSwg
bWF5YmUgeW91IGNhbg0KPiBleHBhbmQgb24gdGhhdD8gQW5kIG1heWJlIHNvbWUgb2YgdGhlIGNv
bmZ1c2lvbiBoZXJlIGlzIGJlY2F1c2Ugb2YNCj4gbWl4aW5nIHVwIFNRUE9MTCBhbmQgSU9QT0xM
Pw0KDQpUaGFua3MgYSBsb3QgZm9yIHlvdXIgaGVscCENCg0KSSB3YXMgY29uZnVzZWQgd2hlbiBm
X29wLT51cmluZ19jbWRfaW9wb2xsIGdldHMgY2FsbGVkIC0gaWYgSSBuZWVkZWQgdG8NCmNoZWNr
IG15c2VsZiBpZiB0aGUgU1FFIHdhcyBzdWJtaXR0ZWQgb3IgaWYgdGhpcyBmb3IgQ1FFIHN1Ym1p
c3Npb24uDQpZb3UgYWxyZWFkeSByZXNvbHZlZCBteSBjb25mdXNpb24gd2l0aCB5b3VyIGNvbW1l
bnRzIGJlbG93LiBUaGFua3MgYQ0KbG90IGZvciB5b3VyIGhlbHAhDQoNCj4gDQo+PiBpb19kb19p
b3BvbGwoKSBpdCBsb29rcyBsaWtlIHRoaXMuIEkgZG9uJ3QgZm9sbG93IGFsbCBjb2RlIHBhdGhz
IGluDQo+PiBfX2lvX3NxX3RocmVhZCB5ZXQsIGJ1dCBpdCBsb29rcyBhIGxpa2UgaXQgYWxyZWFk
eSBjaGVja3MgaWYgdGhlIHJpbmcNCj4+IGhhcyBuZXcgZW50cmllcw0KPj4NCj4+IHRvX3N1Ym1p
dCA9IGlvX3NxcmluZ19lbnRyaWVzKGN0eCk7DQo+PiAuLi4NCj4+IHJldCA9IGlvX3N1Ym1pdF9z
cWVzKGN0eCwgdG9fc3VibWl0KTsNCj4+DQo+PiAgICAgLS0+IGl0IHdpbGwgZXZlbnR1YWxseSBj
YWxsIGludG8gLT51cmluZ19jbWQoKSA/DQo+IA0KPiBUaGUgU1FQT0xMIHRocmVhZCB3aWxsIHB1
bGwgb2ZmIG5ldyBTUUVzLCBhbmQgdGhvc2Ugd2lsbCB0aGVuIGF0IHNvbWUNCj4gcG9pbnQgaGl0
IC0+aXNzdWUoKSB3aGljaCBpcyBhbiBvcGNvZGUgZGVwZW5kZW50IG1ldGhvZCBmb3IgaXNzdWlu
ZyB0aGUNCj4gYWN0dWFsIHJlcXVlc3QuIE9uY2UgaXQncyBiZWVuIGlzc3VlZCwgaWYgdGhlIHJp
bmcgaXMgSU9QT0xMLCB0aGVuDQo+IGlvX2lvcG9sbF9yZXFfaXNzdWVkKCkgd2lsbCBnZXQgY2Fs
bGVkIHdoaWNoIGFkZHMgdGhlIHJlcXVlc3QgdG8gYW4NCj4gaW50ZXJuYWwgcG9sbCBsaXN0LiBX
aGVuIHNvbWVvbmUgZG9lcyBpb191cmluZ19lbnRlcigyKSB0byB3YWl0IGZvcg0KPiBldmVudHMg
b24gYSByaW5nIHdpdGggSU9QT0xMLCBpdCB3aWxsIGl0ZXJhdGUgdGhhdCBsaXN0IGFuZCBjYWxs
DQo+IC0+dXJpbmdfY21kX2lvcG9sbCgpIGZvciB1cmluZ19jbWQgcmVxdWVzdHMsIGFuZCAtPnVy
aW5nX2lvcG9sbCgpIGZvcg0KPiAibm9ybWFsIiByZXF1ZXN0cy4NCg0KVGhhbmtzLCB0aGF0IGJh
c2ljYWxseSBhbnN3ZXJlZCBteSBTUUUgY29uZnVzaW9uIC0gaXQgZG9lcyBhbGwgaXRzZWxmLg0K
DQo+IA0KPiBJZiB0aGUgcmluZyBpcyB1c2luZyBTUVBPTEx8SU9QT0xMLCB0aGVuIHRoZSBTUVBP
TEwgdGhyZWFkIGlzIGFsc28gdGhlDQo+IG9uZSB0aGF0IGRvZXMgdGhlIHBvbGxpbmcuIFNlZSBf
X2lvX3NxX3RocmVhZCgpIC0+IGlvX2RvX2lvcG9sbCgpLg0KPiANCj4+IEFuZCB0aGVuIGlvX2Rv
X2lvcG9sbCAtPiAgZmlsZS0+Zl9vcC0+dXJpbmdfY21kX2lvcG9sbCBpcyBzdXBwb3NlZCB0bw0K
Pj4gY2hlY2sgZm9yIGF2YWlsYWJsZSBjcSBlbnRyaWVzIGFuZCB3aWxsIHN1Ym1pdCB0aGVzZT8g
SS5lLiBJIGp1c3QgcmV0dXJuDQo+PiAxIGlmIHdoZW4gdGhlIHJlcXVlc3QgaXMgcmVhZHk/IEFu
ZCBhbHNvIGVuc3VyZSB0aGF0DQo+PiByZXEtPmlvcG9sbF9jb21wbGV0ZWQgaXMgc2V0Pw0KPiAN
Cj4gVGhlIGNhbGxiYWNrIHBvbGxzIGZvciBhIGNvbXBsZXRpb24gb24gdGhlIHRhcmdldCBzaWRl
LCB3aGljaCB3aWxsIG1hcmsNCj4gaXMgYXMgLT5pb3BvbGxfY29tcGxldGVkID0gdHJ1ZS4gVGhh
dCBzdGlsbCBsZWF2ZXMgdGhlbSBvbiB0aGUgaW9wb2xsDQo+IGxpc3QsIGFuZCBpb19kb19pb3Bv
bGwoKSB3aWxsIHNwb3QgdGhhdCBhbmQgcG9zdCBDUUVzIGZvciB0aGVtLg0KPiANCj4+IEknbSBh
bHNvIG5vdCBzdXJlIHdoYXQgSSBzaG91bGQgZG8gd2l0aCBzdHJ1Y3QgaW9fY29tcF9iYXRjaCAq
IC0gSSBkb24ndA0KPj4gaGF2ZSBzdHJ1Y3QgcmVxdWVzdCAqcmVxX2xpc3QgYW55d2hlcmUgaW4g
bXkgZnVzZS11cmluZyBjaGFuZ2VzLCBzZWVtcw0KPj4gdG8gYmUgYmxrLW1xIHNwZWNpZmljPyBT
byBJIHNob3VsZCBqdXN0IGlnbm9yZSB0aGF0IHBhcmFtZXRlcj8NCj4gDQo+IEhhcmQgdG8gc2F5
IHNpbmNlIHRoZSBhYm92ZSBpcyBhIGJpdCBjb25mdXNpbmcgYW5kIEkgaGF2ZW4ndCBzZWVuIHlv
dXINCj4gY29kZSwgYnV0IHlvdSBjYW4gYWx3YXlzIHN0YXJ0IG9mZiBqdXN0IHBhc3NpbmcgTlVM
TC4gVGhhdCdzIGZpbmUgYW5kDQo+IGp1c3QgZG9lc24ndCBkbyBhbnkgY29tcGxldGlvbiBiYXRj
aGluZy4gVGhlIGxhdHRlciBtYXkgb3IgbWF5IG5vdCBiZQ0KPiB1c2VmdWwgZm9yIHlvdXIgY2Fz
ZSwgYnV0IGluIGFueSBjYXNlLCBpdCdzIGZpbmUgdG8gcGFzcyBOVUxMLg0KDQpJIGhhZCBzZW5k
IHBhdGNoZXMgdG8gZnNkZXZlbCBhbmQgZ2l2ZW4gaXQgaXMgbW9zdGx5IGZ1c2UgcmVsYXRlZCwg
ZGlkbid0DQphZGQgeW91IHRvIENDDQpodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvOTI2NzczLw0K
DQpUaGUgY29kZSBpcyBhbHNvIGhlcmUNCg0KaHR0cHM6Ly9naXRodWIuY29tL2JzYmVybmQvbGlu
dXgvdHJlZS9mdXNlLXVyaW5nLWZvci02LjINCmh0dHBzOi8vZ2l0aHViLmNvbS9ic2Jlcm5kL2xp
YmZ1c2UvdHJlZS91cmluZw0KDQoNCkkgZ290IFNRUE9MTCB3b3JraW5nIHVzaW5nIHRoaXMgc2lt
cGxlIGZ1bmN0aW9uDQoNCi8qKg0KICAqIFRoaXMgaXMgY2FsbGVkIGZvciByZXF1ZXN0cyB3aGVu
IHRoZSByaW5nIGlzIGNvbmZpZ3VyZWQgd2l0aA0KICAqIElPUklOR19TRVRVUF9JT1BPTEwuDQog
ICovDQppbnQgZnVzZV91cmluZ19jbWRfcG9sbChzdHJ1Y3QgaW9fdXJpbmdfY21kICpjbWQsIHN0
cnVjdCBpb19jb21wX2JhdGNoICppb2IsDQoJCQl1bnNpZ25lZCBpbnQgcG9sbF9mbGFncykNCnsN
Cg0KCS8qIE5vdCBtdWNoIHRvIGJlIGRvbmUgaGVyZSwgd2hlbiBJT1JJTkdfU0VUVVBfSU9QT0xM
IGlzIHNldA0KCSAqIGlvX3VyaW5nX2NtZF9kb25lKCkgYWxyZWFkeSBzZXRzIHJlcS0+aW9wb2xs
X2NvbXBsZXRlZC4NCgkgKiBUaGUgY2FsbGVyIChpb19kb19pb3BvbGwpIGFscmVhZHkgY2hlY2tz
IHRoaXMgZmxhZw0KCSAqIGFuZCB3b24ndCBlbnRlciB0aGlzIGZ1bmN0aW9uIGF0IGFsbCB0aGVu
Lg0KCSAqIFdoZW4gd2UgZ2V0IGNhbGxlZCB3ZSBqdXN0IG5lZWQgdG8gcmV0dXJuIDAgYW5kIHRl
bGwgdGhlDQogICAgICAgICAgKiBjYWxsZXIgdGhhdCB0aGUgY21kIGlzIG5vdCByZWFkeSB5ZXQu
DQoJICovDQoJcmV0dXJuIDA7DQp9DQoNCg0KSnVzdCBnYXZlIGl0IGEgcXVpY2sgZmlsZSBjcmVh
dGlvbi9yZW1vdmFsIHJ1biB3aXRoIHNpbmdsZSB0aHJlYWRlZCBib25uaWUrKw0KYW5kIHBlcmZv
cm1hbmNlIGlzIGFjdHVhbGx5IGxvd2VyIHRoYW4gYmVmb3JlIChhcm91bmQgODAwMCBjcmVhdGVz
L3Mgd2l0aG91dA0KSU9SSU5HX1NFVFVQX1NRUE9MTCAoYWRkaW5nIElPUklOR19TRVRVUF9JT1BP
TEwgZG9lc24ndCBoZWxwIGVpdGhlcikgYW5kDQphYm91dCA1MDAwIGNyZWF0ZXMvcyB3aXRoIElP
UklOR19TRVRVUF9TUVBPTEwpLiBXaXRoIHBsYWluIC9kZXYvZnVzZQ0KaXQgaXMgYWJvdXQgMjAw
MCBjcmVhdGVzL3MuDQpNYWluIGltcHJvdmVtZW50IGNvbWVzIGZyb20gZW5zdXJpbmcgcmVxdWVz
dCBzdWJtaXNzaW9uDQooYXBwbGljYXRpb24pIGFuZCByZXF1ZXN0IGhhbmRsaW5nIChyaW5nL3Ro
cmVhZCkgYXJlIG9uIHRoZSBzYW1lIGNvcmUuDQpJJ20gcnVubmluZyBpbnRvIHNvbWUgc2NoZWR1
bGVyIGlzc3Vlcywgd2hpY2ggSSB3b3JrIGFyb3VuZCBmb3Igbm93IHVzaW5nDQptaWdyYXRlX2Rp
c2FibGUoKS9taWdyYXRlX2VuYWJsZSgpIGluIGJlZm9yZS9hZnRlciBmdXNlIHJlcXVlc3Qgd2Fp
dHEsDQp3aXRob3V0IHRoYXQgcGVyZm9ybWFuY2UgZm9yIG1ldGFkYXRhIHJlcXVlc3RzIGlzIHNp
bWlsYXIgdG8gcGxhaW4NCi9kZXYvZnVzZS4NCg0KSSB3aWxsIHNvb24gcG9zdCBhbiBSRkMgdjIg
c2VyaWVzIHdpdGggbW9yZSBiZW5jaG1hcmsgcmVzdWx0cyBpbmNsdWRpbmcNCnJlYWQgYW5kIHdy
aXRlLg0KDQoNCj4gDQo+PiBCdHcsIHRoaXMgbWlnaHQgYmUgdXNlZnVsIGZvciB1YmxrIGFzIHdl
bGw/DQo+IA0KPiBOb3Qgc3VyZSB3aGF0ICJ0aGlzIiBpcyA6LSkNCg0KTWluZyBhbHJlYWR5IHJl
cGxpZWQuDQoNCg0KDQpUaGFua3MsDQpCZXJuZA0KDQoNCg==
