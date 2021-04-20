Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025F3365D7F
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhDTQhv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 12:37:51 -0400
Received: from mail-eopbgr670115.outbound.protection.outlook.com ([40.107.67.115]:6069
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232901AbhDTQhu (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 20 Apr 2021 12:37:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYLC3WPene5Zk+WY6RKpjgFUc2Z4RhaG7YMpdm00GUbIjgAeXKEL+9oErjeEekeDyqxv1GYPBKNk23eBDZwCe8Bxe3o/oSwy7HChype3Nsm37ira8OsAx/Tfp1h8JMVE1KagJA3oIBnelLQSXmdf4UhbizUraQ0FyCxRKdjy/SPMhV4NMu2FSnhpoB9MK8yVA+0lvZpoKcHW7wkkigfJEJK6aY/Qnh6UGLwdytVNGwzUNqsWf8XonhlveBoQhuDXP+KGvIsqr4pABvYGbblieabBQ+ITGXFkZYphI6g1TPVJf0RrAI8WY6oLH3w5IxAfixbZxtiQ/cvwquEkmM2Bqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0VlpvXMgrBktGz7KVPe3pf398KsxvdkWDnLOMJ6qdg=;
 b=RRmySZooYn38l2bL41vKN11I8AIRZwsdaUUSa2F6AWMXauIeOPyniIGaFmO9U2torMjuqkMEz4gqr1Y5Ta0JcOpCVcTWOWYs5k3c58PQulh/8MKmJ4tLaEO9okPiLiL2yqqESog3wiOjH1v1/MoLZELFWCK1cHkXVLBLpxIyALPYKKf6i0RoVkauQ291H9fj7oBXMBLkSQxQa9wc60lqRgODsYYc5olx7hCJdxJ94432k7AvVNVi3cBAQ8haKTdMPMONaMTS/krOhKqpun8/6eD1pkHO77zuu2LKuoWxvSKSghe3mzKFIhP7P+USLa+AodcatSiGUpdlCgDpL+oLCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eqalpha.com; dmarc=pass action=none header.from=eqalpha.com;
 dkim=pass header.d=eqalpha.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=csquaremfg.onmicrosoft.com; s=selector2-csquaremfg-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0VlpvXMgrBktGz7KVPe3pf398KsxvdkWDnLOMJ6qdg=;
 b=KmGUOYnCcRbyyQpAwhPPiqfuo+mNtUl1t2A+VNwPPcIdjAZtUFOyEkswz5muqgkeg1oqvvqce7NpQROXfAhjbpdSAFU2AYob5l8qf0zYrNAA+17sPOoqeD4JGdyhmAU8kgdq3VSrecKkP/nsBFsBiNb3+WbmExLdld/8MMw+2QE=
Received: from YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::31)
 by YT3PR01MB5025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:48::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Tue, 20 Apr
 2021 16:37:17 +0000
Received: from YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a3:bb7:6229:147b]) by YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a3:bb7:6229:147b%5]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 16:37:17 +0000
From:   Jesse Hughes <jesse@eqalpha.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     John <john@eqalpha.com>
Subject: Emulating epoll
Thread-Topic: Emulating epoll
Thread-Index: AQHXNgKeA6wGUR0R8UaY2Dy58MZDZA==
Date:   Tue, 20 Apr 2021 16:37:17 +0000
Message-ID: <YTBPR01MB2798B37324ED46A33DCD21B0BF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=eqalpha.com;
x-originating-ip: [2001:569:fb57:d900:8470:78bc:670d:bd9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 039dba1e-2b89-4884-90aa-08d9041a8fde
x-ms-traffictypediagnostic: YT3PR01MB5025:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <YT3PR01MB50251A87377A74585567ABBDBF489@YT3PR01MB5025.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cN86hnft1j9/Wt4iU1KDfTj7GxH5pjvTHuqp6AdypXpl37w0rZlkuFQtYVIsH80xFYWqIKfJ+kO98oLQN7pcMBrYmifHVBF/m7WhD3fdTR8SOwKr0T1V2XW7TP7wSZ9K5ggUab9yUgRldxO2L7egZxAxcwdT2FPlNSSpE9CtO4XND9GIUkBF4u59NINOxUUqxG8MahB7svcB4SULwCTaeQ9E9bEYky1MIEVVIKmVLbMS9ujV8yW+WUifz6QXeIOZ5dAExAZ9JPCRCfaQ+kXqrP8+cXmMwPdkaaX1AfnzP2qTvhgXYZ7veu+9kA0/b22c6nxDBq4GZA4aPm5hDq7w0Ox9pavaPawfAiXl2nkj3XfQpbqYeRujvTlKdwWJ6MsybEzZhAQn0ed8dO9MOmkXSBWe00EaAGlApJnfVN2RacdujeDrL2vHa0lr+sLmX2zIG7McxUC63V9DMmR0TaBlkkIpXHEohSoX9w0CV2lYSGpd6sX5CeBAavPe1EfddpKy/srR9SqH7u+w8g6AtJjwCIsqUWkV/LG6QY6HyEBnVE420GV3Dap2EuDN+0CyFHLTvblfOse5gq1TD6vHMZgqpvi0paEsVYud6wk2beq99uuwaNpd+7z4YNmpok0dOwhUcv5ap+RiTkb1YlKAnWJes3X5mJ5iRZxwi01HxNh/PHsOBbJVMy3dz2CNK1YAQnWw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39830400003)(346002)(71200400001)(66556008)(66476007)(91956017)(76116006)(4744005)(7116003)(86362001)(3480700007)(55016002)(9686003)(66446008)(7696005)(316002)(64756008)(6506007)(52536014)(66946007)(2906002)(5660300002)(122000001)(8936002)(186003)(4326008)(6916009)(478600001)(8676002)(38100700002)(966005)(33656002)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YUszVDMzdG1NWmREd2tEZHh3QmZmTTN3NFhFMkkyd1hrMVJkWTZ0ay8weU9Q?=
 =?utf-8?B?NUFmdFNPVzNKci9pNjd2RUhhVzZHb3lzQTcrRnAwcUN1ZVgzT1ZEOWNHdEEw?=
 =?utf-8?B?WkVhQXR0aTZidmhuS25ScEtwMS9HY0JHWDF5ZTVnekU1bStBQlp5Vk5NRkFR?=
 =?utf-8?B?VmRHMjdsZnNiLzNiaWJBY2RiMmZmdE5SNStLVUdOLzU3d09kTzkvd1F1dmwx?=
 =?utf-8?B?MGRjdXlDMVZhc3A3MTVOU2hMUnVoSU9EUnF1OEtBT1p4VDJBdWtJeW1Kck43?=
 =?utf-8?B?cUc1eHkyWHllUVd2MGpXcVRsZ2dSZlhweThiTGlhUnRDc3AzR3pzbStaL1p2?=
 =?utf-8?B?UnVoeGRjZGViSlR3MjExdGkweHlQWngwcEF6WWdsdTJqQmJQN1ZJUDJNVTNm?=
 =?utf-8?B?K0ZEbi9LYVN3ZERxUFI4bkcwdVdPWU1idmE3OUxXUGQ0YVI1T1VnUWtoNHBY?=
 =?utf-8?B?QmJDWDB4OGZ5QWd4T3BhVWFVZHM0c3pIeFJWbmVLaWJLY1FnbXllYTU3ekQ5?=
 =?utf-8?B?cm5TcTBwd2xnSHZpMlF4QmttUGNKWVFSVGM0aXI4QWxpM1hoRHMxeXhzVUs4?=
 =?utf-8?B?aytFQlY3NEpYVnJOeVo5MExLR1pSdUl0SExYQUNTYVphZjhwY0N0MUdnTGRm?=
 =?utf-8?B?cmN0U0hxZUhKWTEvRFdlUzN4QzYxMmNPWXlDaCs2UTh4VUxvdFJ6S0lPRURY?=
 =?utf-8?B?WjU1WFY3cHJkTm5waFI0amdTV3E1NWpOeGFyeWgxNVNxdlp6MVM4dzQ0cGF6?=
 =?utf-8?B?djFmQUwyM002STkwVkNBdlN3ZXBkWWI2TjB0VXlFZ3NnamVkYWhiSngvc0F1?=
 =?utf-8?B?YUZlanIrNytZSm5BcjNZRGFML25JTzQ4K1NqWVFYdXRtNm1PTHpzdDFNMDh5?=
 =?utf-8?B?OFRBQ00rS2RJa3lWZ1pFL3BGVUhZRFpxMkxGbHJ3OVFNK2RFL3J6WFlvcTFQ?=
 =?utf-8?B?VFdzTENOdWtNSnBHeWk3STRYTjVkRkFkSVcyWUdmMWVETHZMV01qVUVRMndl?=
 =?utf-8?B?SjRtR0s1TE9GMCt5ZEtsZTRsWGh5TVRva21nTGZ2Rk5rZkRMeUk1NUJLeXRP?=
 =?utf-8?B?VlNCRGNYUStZSHhObE9FejlZdTFGbWp0eXdCS2hIeGZoUzg4ZitPV3E5QjRW?=
 =?utf-8?B?RjMrSXhOWC81MHdUVjFDdmQ2VENUa1NGTE10cXh6MlFRTjkrdUtFaUF0bnFq?=
 =?utf-8?B?ak1FcmFWS1huU24wUEsvUDdoSDdhYWZYQWw4OVFuMTZ6NjRxVFBmdlVYNHV6?=
 =?utf-8?B?U29jZ05SQjFpUStRTmhUN3NTcVlzN0U0SnY3ZEloSGcvbGcvUlRzTkFrVEF3?=
 =?utf-8?B?WVBMalNTbXhidTdsdzlmWm5HU1hSa1NRM0RLZHEwVk9FcmJ3QVAwMVdhRExI?=
 =?utf-8?B?d29QeDVKRGY3OWxUa0grY21JMHlrMlU1c2t5eEVyd3QyVUx0RzhwNVowTUR3?=
 =?utf-8?B?NWZjSDhkVzZLSU5kU3FmTjFWbjY4RE5EZjR1Wld0MVgrMklJZ255WS9UT25T?=
 =?utf-8?B?d05reFY2azBZNUVhQjR1cXcrei9ZRFZTK2MwSnR5Yk1oc2xSQm8wTU50VWJ6?=
 =?utf-8?B?bFAxTUZuL2p6NFBzNDBTZmR3WW9oNnY5RG9IWTFhaWtxU0VEeGFoTXdmTFhw?=
 =?utf-8?B?cEszQjN6M0RjcmY4Y25lRHhOZG0zQXg4RHBlUTUwTFdSQmIzZ3VxVnA2K241?=
 =?utf-8?B?bkkrbzNjMHpHSC93Y2R0L3JURnAwV096c2dmMjBMSFNTRS9nMk9ySnJkaW9Z?=
 =?utf-8?B?amgrMXhnUC9RaXVSbXVtdFc3VTdXK0hLVXNEYWNxelJsOG9ZdXhWZHRNcTZH?=
 =?utf-8?Q?ic/D06RHV6bTzsCd6beV1bRcQYOXFf06HLeCg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eqalpha.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 039dba1e-2b89-4884-90aa-08d9041a8fde
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 16:37:17.8544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 25e0269f-f34c-4b1c-9d3f-7df00678a65b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anu+HtXETeSRrco2CktdmGWpYxU4VhR+h3QVwEQWnJLFW9J2RP8lmLZDJKZ1dwqS2EDJkzg+zYMauF0LZKQe2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5025
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGVsbG8sCgpJIHdhbnQgdG8gc3RhcnQgYnkgc2F5aW5nIHRoYW5rLXlvdSBmb3Igd29ya2luZyBv
biBpb191cmluZy7CoCBNeSBleHBlcmllbmNlIHVzaW5nIGl0IHRodXMgZmFyIGhhcyBiZWVuIGdy
ZWF0LgoKSSdtIHdvcmtpbmcgb24gYW4gb3Blbi1zb3VyY2UgZGF0YWJhc2UgcHJvZHVjdCAoS2V5
REIsIGEgbXVsdGktdGhyZWFkZWQgcmVkaXMgZm9yaykgYW5kIHdlJ3JlIGNvbnNpZGVyaW5nIHJl
d3JpdGluZyBvdXIgSU8gdG8gdXNlIGlvX3VyaW5nLsKgIE91ciBjdXJyZW50IGltcGxlbWVudGF0
aW9uIHVzZXMgZXBvbGwsIGFuZCBwcm9jZXNzZXMgSU8gb24gKG1haW5seSkgc29ja2V0cyBhcyB0
aGV5IGJlY29tZSByZWFkeS4KCklmIEknbSB1bmRlcnN0YW5kaW5nIHRoZSBsaXRlcmF0dXJlIGNv
cnJlY3RseSwgdG8gZW11bGF0ZSBlcG9sbCwgd2Ugc2hvdWxkIGJlIGFibGUgdG8gc2V0IHVwIGEg
dXJpbmcsIHB1dCBpbiBhIHJlYWQgc3FlIGZvciBlYWNoIGluY29taW5nIHNvY2tldCBjb25uZWN0
aW9uLCB0aGVuICh1c2luZyBsaWJ1cmluZykgY2FsbMKgaW9fdXJpbmdfd2FpdF9zcWXigIsuwqAg
Q29ycmVjdD/CoCBJcyB0aGVyZSBhIGJldHRlciB3YXkgb2YgZG9pbmcgdGhhdD8KCk91ciBlbmQt
Z29hbCBpcyBub3QgdG8gZW11bGF0ZSBlcG9sbCwgYnV0IHRoYXQgc2VlbXMgbGlrZSB0aGUgcXVp
Y2tlc3Qgd2F5IG9mIGdldHRpbmcgc29tZXRoaW5nIHdvcmtpbmcgdGhhdCB3ZSBjYW4gZG8gZnVy
dGhlciBleHBlcmltZW50cyB3aXRoLgoKRm9yIHJlZmVyZW5jZSwgaWYgYW55b25lJ3MgaW50ZXJl
c3RlZCwgb3VyIHNvdXJjZSByZXBvIGlzIGF0IDogaHR0cHM6Ly9naXRodWIuY29tL0VRLUFscGhh
L0tleURCCgpDaGVlcnMsCkplc3Nl
