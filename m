Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A72365ECC
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhDTRsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 13:48:43 -0400
Received: from mail-eopbgr670114.outbound.protection.outlook.com ([40.107.67.114]:27968
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231549AbhDTRsn (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 20 Apr 2021 13:48:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXt0vvgK4LOFXQCYGObyTQcrPJUQUEJbKxXW3AaEBeozfD+KWLzk5x9L4M2avzvnSbFtsx9vznYsxT6yiJo+pGoc+8JLiLNyW144imPt92I3wmuOMVCSzghl9y0YCQXz+eUJH+3iHR5gRV6N5huhTRMTxULDkvUAaJJyPooOgJx8Yd3nCSum8VXYaiTV1kfiGDM21FnjdahByWK/iy7alycy+t7sPWKgPpSY/mW4x/4p5vNe8fPJUcq7FEhQyda68GU18VqbgyXjzvcu8jMrEF8biGA625WmSTg7SnyA/CmRPYKYf3+sn5Qa0XMl7Neze3NKx2XHAqtwz6+sJlt1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfsYXzH7SS9YxiwEQ7tfPpjMioq+9818/om+5bzcank=;
 b=cm962FMkXuBgFHBujpLUBqKfshEsxS7KG43NwKv8+Wt+jcXmQJp5DvD0zZZAzM2r2/KzyOyiJtTe+H1miNabk6jY1PHpfhELIxkCPJ7sc/envEQAKC0JKltxlDoBafJJP5nm8Wc/2Y8AhZmtQibjk1q5HtyxnETNS3xeHIn9x/XaxTNlpCClkvg0Wwdge0/1Wk8f8aO73QnzjTz8/tqvb+f4R3ZEchU3ZuOxtqoTYGkQB/ewwwf6A1PHerd11bOrfcOm3EhDSwo8z8m0cmtYDFxNjFkp9z55pkv2i2C6I4E9uIpeZtjNKZhhnojYvfnl9qzbIEh03PYy3kngU8JQCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eqalpha.com; dmarc=pass action=none header.from=eqalpha.com;
 dkim=pass header.d=eqalpha.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=csquaremfg.onmicrosoft.com; s=selector2-csquaremfg-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfsYXzH7SS9YxiwEQ7tfPpjMioq+9818/om+5bzcank=;
 b=op6Ae6ZXcdmYVtJlXxENslCXpS94oQCKkGq8MQybpv/xJqepbAgrbiPyMSuq1yPea221HVRgYrE72f8DdHzfpcKQ0OySpPGxY4lMO96vyMo3fq8XCrc6zO1VQ3xrDycsDL5RrLVJhO38VZHSqWNgRPaEoGqeOUlPVOTbM6nKmyQ=
Received: from YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::31)
 by YTOPR0101MB2203.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Tue, 20 Apr
 2021 17:48:09 +0000
Received: from YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a3:bb7:6229:147b]) by YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a3:bb7:6229:147b%5]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 17:48:09 +0000
From:   Jesse Hughes <jesse@eqalpha.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     John <john@eqalpha.com>
Subject: Re: Emulating epoll
Thread-Topic: Emulating epoll
Thread-Index: AQHXNgKeA6wGUR0R8UaY2Dy58MZDZKq9oQiAgAANgKM=
Date:   Tue, 20 Apr 2021 17:48:09 +0000
Message-ID: <YTBPR01MB2798DCE96EF944CDB61D844DBF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>
References: <YTBPR01MB2798B37324ED46A33DCD21B0BF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>,<98e1c6bb-1706-e1b3-b7f1-c5418ee880be@gmail.com>
In-Reply-To: <98e1c6bb-1706-e1b3-b7f1-c5418ee880be@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=eqalpha.com;
x-originating-ip: [2001:569:fb57:d900:8470:78bc:670d:bd9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49459e14-7c20-4491-eb20-08d9042475ce
x-ms-traffictypediagnostic: YTOPR0101MB2203:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <YTOPR0101MB2203F569335D46C35C89207DBF489@YTOPR0101MB2203.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FvQbBF3+ZMh28+Q/5JCZOBHFt7MbAWX+4/2k5IBvQL2zMXLKIMDYSvCa72KIjs+qPOlwcSnlIGpSzzeCOjuDVaLLieHw/X3uUUgoI5ksUtYVnh9VgtsX3ildkPKVJ4WHw4sNI2Tk7VMPZoedy8DLxyUWiuSB/LydkiGMitQHusstCqB9v4iAMuLi1x+T873Q4qQxjVQ0V3eB7fN7owjoItsCmDLk+pVYPVCt3I92s8/iv0T5UfIVeMSy7kmFs4mbT1yESW34/aX32YQc/O0xrRiyUlnFPSkP84MfHIb8qWJP991wOlSsny9v3mHSD13QWgqmml86nxfYCvtR2VSWb23e+uWYlDsC7yJdmKN+WfpYaNRQ1Yf9TKbeS91PK5evi6nXJptPOZowxs4oXUhrgcy6qOjnfGxicS8lLDqj0l4vG+s8RfwRAcQxUnvZNXNEA+J/8Ufy2kI/PO1qUQiUDsOjh+iIfZ4wSjqdn9D0yIimTrBnpPzIE3TLis0rxjp6JFkd36vLeWD+vLlceF6CbtM2uDzTKRlOaDwOeXToEajoS9VUFZjENL8DCeFGwhhJ9eHSQpDSCjcqlR3K0Bjf9hvX9nDRtsgqUazrG4KoJUwSIRSoWaVl863A7V3pMUG6kCn+GgfH1GR4K9iN4YaAx4/JoUfozk9DwJXQOOGFz2wK4TvUfRDgkVbm+aIsgxpz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39830400003)(346002)(66446008)(66556008)(64756008)(66476007)(91956017)(66946007)(8936002)(76116006)(8676002)(478600001)(3480700007)(316002)(2906002)(83380400001)(966005)(71200400001)(86362001)(107886003)(5660300002)(6506007)(186003)(53546011)(4326008)(122000001)(7696005)(55016002)(38100700002)(9686003)(110136005)(7116003)(33656002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RUNvL25UUE5HZUZrU252WC90WEYyeFlBcEZMamRVRHkyck1JYXpyeE1SaXk5?=
 =?utf-8?B?cUJyMUFqSS9ZWU8vOTlYZlovbVB3MGV1cUEwb3dUMGJDcUJTZ1pSK0VLSnpo?=
 =?utf-8?B?K0tiTzM1eU5uS3RNcFFaOVhxMTBwT01rV1lKaEhrVWlwVHNuQU9VMytPRGxh?=
 =?utf-8?B?SU9Lb1hCMEVtOEZwd3JaU2ZyMmd2NGhoMWdzL0Z4dVp4K1pzbUxNTlhmM1Yv?=
 =?utf-8?B?K3ZKYTdoZUVPdklHVXpNMlJBczNJMXRPSC9EWmQyaEVpNlNGZnpFbHUrMTV2?=
 =?utf-8?B?YVVjZEFCZnRvLzZtOVNraElJQXljZWFhNEVxY1owRzVRbDczWG5vdGdaYXZW?=
 =?utf-8?B?NVZOZTlPTWxsUWRSaWdmdmZicVA2MFFIRGp6aTFzOVNleTJ2STlQbHIvZTVo?=
 =?utf-8?B?MW5vUXdVS1R6bjlSUnBCd3NlT0pGUUZxZHBETFNLM3NtcW5kYTJ2L0FDN1J1?=
 =?utf-8?B?TjZibHVhcG5EUXMxcXRXTUpmMnByS3VYL044VlNoM3BKV2paV05zRkgzUzFq?=
 =?utf-8?B?dlRsMWVtQjVWUHZYUmVqZmE0c0VhaFc5ZFVKcmFZYjVxaHcxRklhWG9vVVNx?=
 =?utf-8?B?aE0rWGU0YjdkMVdtRWhpS1AwcGJHM25zY0loaU9wWmJFMTRDcjg0MkFqNVVl?=
 =?utf-8?B?a0duRjl5Q1l1YVgxYVVYRWViYjhwc3NSYkxNdG82S1lsZmVWaU5aZFI2cU05?=
 =?utf-8?B?M1RSRERYN1g1dXdYekxlRFNLdWJxdlNyTWtyb0dYNDhPd1dtNnpVY2pYeXl2?=
 =?utf-8?B?c1FQK1ppTUw0TVBNV3N4QXhDeU1LRDlxbjF4SW5lT2FUM0txenRhT1ROcDR4?=
 =?utf-8?B?cGdpQ3FVSlExNDRqVjBKOSs5Zm9uTmw3L2x3MW0zK054ZW1VZmVid0NlOFVW?=
 =?utf-8?B?aDhaOGtpc1JUOUViNUhEdjhLWkRGNDc0UEt3NlJaV3ZvS20wT2RZRmNPdmFt?=
 =?utf-8?B?THUxYll6aXE1R1NSditEZExLc2laZ2E1a2p2S2pUR1Z2aDdvWUFORnkxSTBh?=
 =?utf-8?B?Y080OWthc3NxUkZ0WUxLRjAyZlJaNFJDajBSdEtFMHBJT2RMNkZlNmkzL0xz?=
 =?utf-8?B?c296N0dBNkFTM2ZWL0xaRld2bUovdHNHS2RqbExVWkZDSi9reVhhbmtwQ2dE?=
 =?utf-8?B?cXM3dHhCN1pPUHRxazZoYVBtMWVab2xGRm5wT1E2UjlKT2RWTUx6TVJlSHFm?=
 =?utf-8?B?VzNLK0Z3VEhwUHh1SndDTnF1cEVKcVRvamV4TzdoZ0xkc0hxWkUwdnJJeDZO?=
 =?utf-8?B?OEdZckVVNk02NzJRQk1kaUVPenZXdktlSW4wbVU1QSsvYTBLaUsxeHRxVnE0?=
 =?utf-8?B?TCs4eE5sS1RYSWFvSTIyTDhVc3dSQTVrdnhGMmFmNUVXVHRwSHFOdXo5eDJw?=
 =?utf-8?B?ME9EdXovYTdVdndEU1M5NUtvQ1dlV2JkbitjeFI4UDljMXNBSTNMY2NUMDBr?=
 =?utf-8?B?RGhnanFCSDVuWHdwb2hKcWp3bko1cmF0S2Q0QnpKYW1BTzgzbm9XQ2dEMWRR?=
 =?utf-8?B?dDFZdFJSZ0t3OW53WFg0Yi9yU3JtTk5lMlZVYVhDL2NjaHhuOFlCS3hRT1Fk?=
 =?utf-8?B?MEM4RWFUOUozcWNjb1NpQWd3c3hpNzluR1I1M0ZQS1pZcFBtMWhBY3E5RG83?=
 =?utf-8?B?U2FNR0Vtcmk5c0FRYnRuUzlRbzEzWGdEbnQvQWhkbVkvY1ZuQTFlQzFzenNC?=
 =?utf-8?B?d2tzOHJJR0cwSzZWQm42UUpnS2VWei92OCtkdHVROS9zNUhPanc4UUZveEpF?=
 =?utf-8?B?WTFzaEg3bjRoZlNMYWhlNjA3UW1rT0x3ejFqc24xMlhLZ2RleHZ6dDRYMGxB?=
 =?utf-8?B?cnVBS2t3TkZMVUsways3S1NxQ05FbGtlcGlablA0eng0d1NYK3Y4czFldm1m?=
 =?utf-8?Q?WkPE6qBypeneN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eqalpha.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 49459e14-7c20-4491-eb20-08d9042475ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 17:48:09.0824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 25e0269f-f34c-4b1c-9d3f-7df00678a65b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sB4PQPG0YvKuth30LQMqrXV4Rv9chTKHYf5Ln788W3aBoJlzkW2Gz1UaeqtACaA839b1WwnYIVC+KJPfdvc9Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB2203
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

QXdlc29tZSwgdGhhbmtzIGZvciB0aGUgaW5mbyBhbmQgeW91ciBoYXJkIHdvcmsgUGF2ZWwhDQoN
CkNoZWVycywNCkplc3NlDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18NCkZyb206IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPg0KU2VudDog
VHVlc2RheSwgQXByaWwgMjAsIDIwMjEgOTo1OSBBTQ0KVG86IEplc3NlIEh1Z2hlczsgaW8tdXJp
bmdAdmdlci5rZXJuZWwub3JnDQpDYzogSm9obg0KU3ViamVjdDogUmU6IEVtdWxhdGluZyBlcG9s
bA0KDQpPbiA0LzIwLzIxIDU6MzcgUE0sIEplc3NlIEh1Z2hlcyB3cm90ZToNCj4gSGVsbG8sDQo+
DQo+IEkgd2FudCB0byBzdGFydCBieSBzYXlpbmcgdGhhbmsteW91IGZvciB3b3JraW5nIG9uIGlv
X3VyaW5nLiAgTXkgZXhwZXJpZW5jZSB1c2luZyBpdCB0aHVzIGZhciBoYXMgYmVlbiBncmVhdC4N
Cj4NCj4gSSdtIHdvcmtpbmcgb24gYW4gb3Blbi1zb3VyY2UgZGF0YWJhc2UgcHJvZHVjdCAoS2V5
REIsIGEgbXVsdGktdGhyZWFkZWQgcmVkaXMgZm9yaykgYW5kIHdlJ3JlIGNvbnNpZGVyaW5nIHJl
d3JpdGluZyBvdXIgSU8gdG8gdXNlIGlvX3VyaW5nLiAgT3VyIGN1cnJlbnQgaW1wbGVtZW50YXRp
b24gdXNlcyBlcG9sbCwgYW5kIHByb2Nlc3NlcyBJTyBvbiAobWFpbmx5KSBzb2NrZXRzIGFzIHRo
ZXkgYmVjb21lIHJlYWR5Lg0KDQpXb25kZXJmdWwsIGFsd2F5cyBpbnRlcmVzdGluZyB0byBsZWFy
biBhYm91dCBlbWVyZ2luZyB1c2UgY2FzZXMNCmFuZCBuZXcgYXBwcyB1c2luZyBpdC4NCg0KPg0K
PiBJZiBJJ20gdW5kZXJzdGFuZGluZyB0aGUgbGl0ZXJhdHVyZSBjb3JyZWN0bHksIHRvIGVtdWxh
dGUgZXBvbGwsIHdlIHNob3VsZCBiZSBhYmxlIHRvIHNldCB1cCBhIHVyaW5nLCBwdXQgaW4gYSBy
ZWFkIHNxZSBmb3IgZWFjaCBpbmNvbWluZyBzb2NrZXQgY29ubmVjdGlvbiwgdGhlbiAodXNpbmcg
bGlidXJpbmcpIGNhbGwgaW9fdXJpbmdfd2FpdF9zcWXigIsuICBDb3JyZWN0PyAgSXMgdGhlcmUg
YSBiZXR0ZXIgd2F5IG9mIGRvaW5nIHRoYXQ/DQoNCkluIGdlbmVyYWwsIHRoZSBiZXN0IHdheSB0
byBkbyBJL08gaXMgdG8gaXNzdWUgYSByZWFkL3dyaXRlL2V0Yy4gc3FlDQpkaXJlY3RseSBhcyB5
b3UndmUgbWVudGlvbmVkLiBpb191cmluZyB3aWxsIHRha2UgY2FyZSBvZiBkb2luZyBwb2xsaW5n
DQppbnRlcm5hbGx5IG9yIGZpbmRpbmcgYSBiZXR0ZXIgd2F5IHRvIGV4ZWN1dGUgaXQuDQoNCkhv
d2V2ZXIsIHRvIHNpbXBseSBlbXVsYXRlIGVwb2xsIElPUklOR19PUF9QT0xMX0FERCByZXF1ZXN0
cyBjYW4gYmUNCnVzZWQgVGhlcmUgaXMgc3VwcG9ydCBmb3IgbXVsdGktc2hvdCBwb2xsIHJlcXVl
c3RzLCB3aGljaCBKZW5zIGFkZGVkDQpmb3IgY29taW5nIGxpbnV4IDUuMTMNCg0KPg0KPiBPdXIg
ZW5kLWdvYWwgaXMgbm90IHRvIGVtdWxhdGUgZXBvbGwsIGJ1dCB0aGF0IHNlZW1zIGxpa2UgdGhl
IHF1aWNrZXN0IHdheSBvZiBnZXR0aW5nIHNvbWV0aGluZyB3b3JraW5nIHRoYXQgd2UgY2FuIGRv
IGZ1cnRoZXIgZXhwZXJpbWVudHMgd2l0aC4NCj4NCj4gRm9yIHJlZmVyZW5jZSwgaWYgYW55b25l
J3MgaW50ZXJlc3RlZCwgb3VyIHNvdXJjZSByZXBvIGlzIGF0IDogaHR0cHM6Ly9naXRodWIuY29t
L0VRLUFscGhhL0tleURCDQoNCi0tDQpQYXZlbCBCZWd1bmtvdg0K
