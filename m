Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3CC15B5DD
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2020 01:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgBMAdl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 19:33:41 -0500
Received: from mail-bjbon0135.outbound.protection.partner.outlook.cn ([42.159.36.135]:15220
        "EHLO CN01-BJB-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729152AbgBMAdl (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 12 Feb 2020 19:33:41 -0500
X-Greylist: delayed 28033 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 19:33:34 EST
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXKun2L3iZNFea/ti0kWFxcVK6soNW+obW6b9rGCauJfbTZrJfu3TJCjRDS1eaHqj6C3V/+SjlzeQe4Ht2Sw1prhraK3rP2AHGpefoUPD8iPUAlRlwoEm2C9DcVe4Q+f+JmvO0sOblPthGzfgfUaxbXtlosfvFtlXGstnZMuwD47xQcq+HL40Zps0cHbIJGuwhH8cJ+4CFcIdzQKRKw8LRCKmrF52CC1rwlLAZhYCMl/0H2jF/0k2bStbWFDJbXP6E7WbC9v80jBEPBT89/nJZZ3gseoFB1OSs2wwmvKjO9MUAD2Rk/6JifsP8KiB1jC3DnpzvLyG4G5V3fum0GQtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHuL9EC4+kvYj95L40swOThSWcIsmLX2JvDC/1Yh0Bs=;
 b=GqNW7OA9UibYZ5XjjD/RSv35JmoBDd5BtRbf1dboyyaOUAgIEyRB53GOsrO+Na1iPzjCPoga6zp/3TUBIh+G3n5DkYzGWyb+S1BgX8h4lI0paIZf2L7IlOkPIWFx1RRZuy6ELvXOYCv4vdRWuykdUqGOW0TsktEK0EtETqDK8Gpqyq/spYbnIGVAwDaa1hLwUVlobyUmanDlyrnsHmPWDr4LCJo7cCuOR0ChvYg0QsfkS6t9vqoaDDMKaBu218BlWv2qxqQm+Si20kOLLMuj6awtJNu6MGXljxcY721cOsu/gwUMMANVRxE6F8sgZDPPP0qlPCJpRs7Szy1UQrdDCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHuL9EC4+kvYj95L40swOThSWcIsmLX2JvDC/1Yh0Bs=;
 b=RUgAG1HApGIlHwcZnhwUuLkAbk1s8ys9z8KUknppnrGySPJOI3fHTsgEfL9/p3qLYCzkLhVyPfYY5KQepY+CBwEFqarRUyv/B6cjWfLx7/vtv9hQINPTUY/kROth5qk66+R5hoGK5behZpGY8Pz18+FzVXV+3j/iQJX46zEAMGw=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0539.CHNPR01.prod.partner.outlook.cn (10.43.108.82) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23; Thu, 13 Feb
 2020 00:33:30 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Thu, 13 Feb 2020 00:33:29 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Topic: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Index: AQHV4cHhpj4vlwaolEOmZJk1sNu8q6gXy2CAgAB7iIA=
Date:   Thu, 13 Feb 2020 00:33:29 +0000
Message-ID: <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
In-Reply-To: <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [183.202.132.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd9c5b37-22e7-4960-96b4-08d7b01c594a
x-ms-traffictypediagnostic: SH0PR01MB0539:
x-microsoft-antispam-prvs: <SH0PR01MB0539DF1BF716CAE152CE9435941A0@SH0PR01MB0539.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(189003)(199004)(328002)(329002)(76116006)(2616005)(63696004)(71200400001)(86362001)(95416001)(2906002)(8676002)(66476007)(66556008)(81166006)(81156014)(53546011)(186003)(66946007)(5660300002)(59450400001)(64756008)(966005)(26005)(66446008)(508600001)(36756003)(8936002)(4326008)(6916009)(85182001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0539;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7eTLk1apMLqlpzp5PElTOZdswiXcbQCxplCJobrub6Qawhc1ZzRxV+0SvbACU+SLdX3fJ7quPZyx8PSnV+voAjxKuptc7+R3ZxL7cVnLc1TLz8ET2BrkoUNa4nmYDwaGoiMyTsHIviWzc/ISbSBbFpYzn4rQ1vLcGUuFjNzjLL3lCeWqaX5iZgtcPL72cHxMM9Ey78f0VfNgso2p0mL4q8MKoLxU8oBTLBdQlLIoEDCWtzE0EmuwSEtzddYXPyVC9RVimj7AKnouCxrAPc8jETTRgmSciGviCqBiU/Q6QSV9qs0x9IfkvY2Bcyfhz78L9aYufXPctldgL66jJ+vzYRhHUhAKhpH3Hpl2uQVlhQzqKSqk0kJ848HPMi4tIv2jItuna5ihLb4vhQ1mhE4DJH8z46XPdhUg8Je9oPWkc9GQTXTp/cdHJ8ckktmp3bAhJKv2GOx3xhka4NQJsVcOFsNjJvVCtGkRYmwsiReWHnDDwRSeVtt1gt9MIddrhFOS1KipBMUv7TRwRS4fUNQLjw==
x-ms-exchange-antispam-messagedata: MenGgxuIzWWWPqF2KGP6uTZjQidlTwtMr2gNfNzzGYKbbbyU3ZLjfetpQDpw/cVuqYLsTTmJpFPOuPjHz5UmbmY9m1FOctucyo9dFA7k2fejUNVrwdoxYmHCruCygKyW2746HJGXBHQK8M2CZ8vdeg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCA0126B6312F04F8AA4F634C4005370@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9c5b37-22e7-4960-96b4-08d7b01c594a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 00:33:29.9268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zZjQg7keN38DvuizakzEfseYZqdrxGCAz8W3rURpZTm8P1CNyN0xxpXwPXGTf/dMM90Y/01+C5vdP7iU1kJYlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0539
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHJlcGx5Lg0KDQpZb3UgYXJlIHJpZ2h0IHRoZSBub3AgaXNuJ3QgcmVh
bGx5IGEgZ29vZCB0ZXN0IGNhc2UuIEJ1dCBJIGFjdHVhbGx5DQpmb3VuZCB0aGlzIGlzc3VlIHdo
ZW4gYmVuY2htYXJraW5nIG15IGVjaG8gc2VydmVyLCB3aGljaCBkaWRuJ3QgdXNlDQpOT1Agb2Yg
Y291cnNlLg0KDQpUZXN0IGNhc2UgYXR0YWNoZWQgYmVsb3cuIFVzZSBydXN0X2VjaG9fYmVuY2gg
Zm9yIGJlbmNobWFya2luZy4NCmh0dHBzOi8vZ2l0aHViLmNvbS9oYXJhbGRoL3J1c3RfZWNob19i
ZW5jaA0KDQoNCiQgZ2NjIGxpbmtfcmVjdi5jIC1vIGxpbmtfcmVjdiAtbHVyaW5nIC1PMyAtRFVT
RV9MSU5LPTANCiQgLi9saW5rX3JlY3YgMTIzNDUNCiQgY2FyZ28gcnVuIC0tcmVsZWFzZSAjIE9u
IGFub3RoZXIgY29uc29sZQ0KQmVuY2htYXJraW5nOiAxMjcuMC4wLjE6MTIzNDUNCjUwIGNsaWVu
dHMsIHJ1bm5pbmcgNTEyIGJ5dGVzLCA2MCBzZWMuDQoNClNwZWVkOiAxNjgyNjQgcmVxdWVzdC9z
ZWMsIDE2ODI2NCByZXNwb25zZS9zZWMNClJlcXVlc3RzOiAxMDA5NTg0Ng0KUmVzcG9uc2VzOiAx
MDA5NTg0NA0KDQokIGdjYyBsaW5rX3JlY3YuYyAtbyBsaW5rX3JlY3YgLWx1cmluZyAtTzMgLURV
U0VfTElOSz0xDQokIC4vbGlua19yZWN2IDEyMzQ1DQokIGNhcmdvIHJ1biAtLXJlbGVhc2UgIyBP
biBhbm90aGVyIGNvbnNvbGUNCkJlbmNobWFya2luZzogMTI3LjAuMC4xOjEyMzQ1DQo1MCBjbGll
bnRzLCBydW5uaW5nIDUxMiBieXRlcywgNjAgc2VjLg0KDQpTcGVlZDogMTEyNjY2IHJlcXVlc3Qv
c2VjLCAxMTI2NjYgcmVzcG9uc2Uvc2VjDQpSZXF1ZXN0czogNjc2MDAwOQ0KUmVzcG9uc2VzOiA2
NzU5OTc1DQoNCg0KSSB0aGluayBgUE9MTF9BREQoUE9MTElOKS1SRUNWYCBhbmQgYFBPTExfQURE
KFBPTExPVVQpLVNFTkRgIGFyZSBjb21tb24gdXNlIGNhc2VzIGZvciBuZXR3b3JraW5nICggZm9y
IHNvbWUgcmVhc29uIGEgc2hvcnQgcmVhZCBmb3IgU0VORCBpcyBub3QgY29uc2lkZXJlZCBhbiBl
cnJvciwgYFJFQ1YtU0VORGAgY2Fubm90IGJlIHVzZWQgaW4gYSBsaW5rIGNoYWluICkuIFJFQ1Yv
U0VORCB3b24ndCBibG9jayBhZnRlciBwb2xsZWQuIEkgZXhwZWN0IGJldHRlciBwZXJmb3JtYW5j
ZSBmb3IgZmV3ZXIgaW9fdXJpbmdfZW50ZXIgc3lzY2FsbHMuIENvdWxkIHlvdSBwbGVhc2UgaGF2
ZSBhIGNoZWNrIHdpdGggaXQ/DQoNCkFub3RoZXIgbW9yZSBjb21wbGV4IHRlc3QgY2FzZSBgUE9M
TF9BREQtUkVBRF9GSVhFRC1XUklURV9GSVhFRGAgSSBoYXZlIHBvc3RlZCBvbiBHaXRodWIsIHdo
aWNoIGN1cnJlbnRseSByZXN1bHRzIGluIGZyZWV6ZS4NCg0KaHR0cHM6Ly9naXRodWIuY29tL2F4
Ym9lL2xpYnVyaW5nL2lzc3Vlcy83MQ0KDQpDYXJ0ZXINCg0KLS0tDQoNCiNpbmNsdWRlIDxzdGRp
by5oPg0KI2luY2x1ZGUgPHN0ZGxpYi5oPg0KI2luY2x1ZGUgPHN0cmluZy5oPg0KI2luY2x1ZGUg
PHVuaXN0ZC5oPg0KDQojaW5jbHVkZSA8c3lzL3NvY2tldC5oPg0KI2luY2x1ZGUgPHN5cy9wb2xs
Lmg+DQojaW5jbHVkZSA8bmV0aW5ldC9pbi5oPg0KDQojaW5jbHVkZSA8bGlidXJpbmcuaD4NCg0K
I2RlZmluZSBCQUNLTE9HIDEyOA0KI2RlZmluZSBNQVhfTUVTU0FHRV9MRU4gMTAyNA0KI2RlZmlu
ZSBNQVhfQ09OTkVDVElPTlMgMTAyNA0KI2lmbmRlZiBVU0VfTElOSw0KIyAgIGRlZmluZSBVU0Vf
TElOSyAwDQojZW5kaWYNCg0KZW51bSB7IEFDQ0VQVCwgUE9MTCwgUkVBRCwgV1JJVEUgfTsNCg0K
c3RydWN0IGNvbm5faW5mbyB7DQogICAgX191MzIgZmQ7DQogICAgX191MzIgdHlwZTsNCn07DQoN
CnR5cGVkZWYgY2hhciBidWZfdHlwZVtNQVhfQ09OTkVDVElPTlNdW01BWF9NRVNTQUdFX0xFTl07
DQoNCnN0YXRpYyBzdHJ1Y3QgaW9fdXJpbmcgcmluZzsNCnN0YXRpYyB1bnNpZ25lZCBjcWVfY291
bnQgPSAwOw0KDQppbnQgaW5pdF9zb2NrZXQoaW50IHBvcnRubykgew0KICAgIGludCBzb2NrX2xp
c3Rlbl9mZCA9IHNvY2tldChBRl9JTkVULCBTT0NLX1NUUkVBTSwgMCk7DQogICAgaWYgKHNvY2tf
bGlzdGVuX2ZkIDwgMCkgew0KICAgICAgICBwZXJyb3IoInNvY2tldCIpOw0KICAgICAgICByZXR1
cm4gLTE7DQogICAgfQ0KDQogICAgc3RydWN0IHNvY2thZGRyX2luIHNlcnZlcl9hZGRyID0gew0K
ICAgICAgICAuc2luX2ZhbWlseSA9IEFGX0lORVQsDQogICAgICAgIC5zaW5fcG9ydCA9IGh0b25z
KHBvcnRubyksDQogICAgICAgIC5zaW5fYWRkciA9IHsNCiAgICAgICAgICAgIC5zX2FkZHIgPSBJ
TkFERFJfQU5ZLA0KICAgICAgICB9LA0KICAgIH07DQoNCiAgICBpZiAoYmluZChzb2NrX2xpc3Rl
bl9mZCwgKHN0cnVjdCBzb2NrYWRkciAqKSZzZXJ2ZXJfYWRkciwgc2l6ZW9mKHNlcnZlcl9hZGRy
KSkgPCAwKSB7DQogICAgICAgIHBlcnJvcigiYmluZCIpOw0KICAgICAgICByZXR1cm4gLTE7DQog
ICAgfQ0KDQogICAgaWYgKGxpc3Rlbihzb2NrX2xpc3Rlbl9mZCwgQkFDS0xPRykgPCAwKSB7DQog
ICAgICAgIHBlcnJvcigibGlzdGVuIik7DQogICAgICAgIHJldHVybiAtMTsNCiAgICB9DQoNCiAg
ICByZXR1cm4gc29ja19saXN0ZW5fZmQ7DQp9DQoNCnN0YXRpYyBzdHJ1Y3QgaW9fdXJpbmdfc3Fl
KiBnZXRfc3FlX3NhZmUoKSB7DQogICAgc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlID0gaW9fdXJp
bmdfZ2V0X3NxZSgmcmluZyk7DQogICAgaWYgKF9fYnVpbHRpbl9leHBlY3QoISFzcWUsIDEpKSB7
DQogICAgICAgIHJldHVybiBzcWU7DQogICAgfSBlbHNlIHsNCiAgICAgICAgaW9fdXJpbmdfY3Ff
YWR2YW5jZSgmcmluZywgY3FlX2NvdW50KTsNCiAgICAgICAgY3FlX2NvdW50ID0gMDsNCiAgICAg
ICAgaW9fdXJpbmdfc3VibWl0KCZyaW5nKTsNCiAgICAgICAgcmV0dXJuIGlvX3VyaW5nX2dldF9z
cWUoJnJpbmcpOw0KICAgIH0NCn0NCg0Kc3RhdGljIHZvaWQgYWRkX2FjY2VwdChpbnQgZmQsIHN0
cnVjdCBzb2NrYWRkciAqY2xpZW50X2FkZHIsIHNvY2tsZW5fdCAqY2xpZW50X2xlbikgew0KICAg
IHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSA9IGdldF9zcWVfc2FmZSgpOw0KICAgIHN0cnVjdCBj
b25uX2luZm8gY29ubl9pID0gew0KICAgICAgICAuZmQgPSBmZCwNCiAgICAgICAgLnR5cGUgPSBB
Q0NFUFQsDQogICAgfTsNCg0KICAgIGlvX3VyaW5nX3ByZXBfYWNjZXB0KHNxZSwgZmQsIGNsaWVu
dF9hZGRyLCBjbGllbnRfbGVuLCAwKTsNCiAgICBtZW1jcHkoJnNxZS0+dXNlcl9kYXRhLCAmY29u
bl9pLCBzaXplb2YoY29ubl9pKSk7DQp9DQoNCnN0YXRpYyB2b2lkIGFkZF9wb2xsKGludCBmZCwg
aW50IHBvbGxfbWFzaywgdW5zaWduZWQgZmxhZ3MpIHsNCiAgICBzdHJ1Y3QgaW9fdXJpbmdfc3Fl
ICpzcWUgPSBnZXRfc3FlX3NhZmUoKTsNCiAgICBzdHJ1Y3QgY29ubl9pbmZvIGNvbm5faSA9IHsN
CiAgICAgICAgLmZkID0gZmQsDQogICAgICAgIC50eXBlID0gUE9MTCwNCiAgICB9Ow0KDQogICAg
aW9fdXJpbmdfcHJlcF9wb2xsX2FkZChzcWUsIGZkLCBwb2xsX21hc2spOw0KICAgIGlvX3VyaW5n
X3NxZV9zZXRfZmxhZ3Moc3FlLCBmbGFncyk7DQogICAgbWVtY3B5KCZzcWUtPnVzZXJfZGF0YSwg
JmNvbm5faSwgc2l6ZW9mKGNvbm5faSkpOw0KfQ0KDQpzdGF0aWMgdm9pZCBhZGRfc29ja2V0X3Jl
YWQoaW50IGZkLCBzaXplX3Qgc2l6ZSwgYnVmX3R5cGUgKmJ1ZnMpIHsNCiAgICBzdHJ1Y3QgaW9f
dXJpbmdfc3FlICpzcWUgPSBnZXRfc3FlX3NhZmUoKTsNCiAgICBzdHJ1Y3QgY29ubl9pbmZvIGNv
bm5faSA9IHsNCiAgICAgICAgLmZkID0gZmQsDQogICAgICAgIC50eXBlID0gUkVBRCwNCiAgICB9
Ow0KDQogICAgaW9fdXJpbmdfcHJlcF9yZWN2KHNxZSwgZmQsICgqYnVmcylbZmRdLCBzaXplLCBN
U0dfTk9TSUdOQUwpOw0KICAgIG1lbWNweSgmc3FlLT51c2VyX2RhdGEsICZjb25uX2ksIHNpemVv
Zihjb25uX2kpKTsNCn0NCg0Kc3RhdGljIHZvaWQgYWRkX3NvY2tldF93cml0ZShpbnQgZmQsIHNp
emVfdCBzaXplLCBidWZfdHlwZSAqYnVmcywgdW5zaWduZWQgZmxhZ3MpIHsNCiAgICBzdHJ1Y3Qg
aW9fdXJpbmdfc3FlICpzcWUgPSBnZXRfc3FlX3NhZmUoKTsNCiAgICBzdHJ1Y3QgY29ubl9pbmZv
IGNvbm5faSA9IHsNCiAgICAgICAgLmZkID0gZmQsDQogICAgICAgIC50eXBlID0gV1JJVEUsDQog
ICAgfTsNCg0KICAgIGlvX3VyaW5nX3ByZXBfc2VuZChzcWUsIGZkLCAoKmJ1ZnMpW2ZkXSwgc2l6
ZSwgTVNHX05PU0lHTkFMKTsNCiAgICBpb191cmluZ19zcWVfc2V0X2ZsYWdzKHNxZSwgZmxhZ3Mp
Ow0KICAgIG1lbWNweSgmc3FlLT51c2VyX2RhdGEsICZjb25uX2ksIHNpemVvZihjb25uX2kpKTsN
Cn0NCg0KaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkgew0KICAgIGlmIChhcmdjIDwg
Mikgew0KICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIlBsZWFzZSBnaXZlIGEgcG9ydCBudW1iZXI6
ICVzIFtwb3J0XVxuIiwgYXJndlswXSk7DQogICAgICAgIHJldHVybiAxOw0KICAgIH0NCg0KICAg
IGludCBwb3J0bm8gPSBzdHJ0b2woYXJndlsxXSwgTlVMTCwgMTApOw0KICAgIGludCBzb2NrX2xp
c3Rlbl9mZCA9IGluaXRfc29ja2V0KHBvcnRubyk7DQogICAgaWYgKHNvY2tfbGlzdGVuX2ZkIDwg
MCkgcmV0dXJuIC0xOw0KICAgIHByaW50ZigiaW9fdXJpbmcgZWNobyBzZXJ2ZXIgbGlzdGVuaW5n
IGZvciBjb25uZWN0aW9ucyBvbiBwb3J0OiAlZFxuIiwgcG9ydG5vKTsNCg0KDQogICAgaW50IHJl
dCA9IGlvX3VyaW5nX3F1ZXVlX2luaXQoQkFDS0xPRywgJnJpbmcsIDApOw0KICAgIGlmIChyZXQg
PCAwKSB7DQogICAgICAgIGZwcmludGYoc3RkZXJyLCAicXVldWVfaW5pdDogJXNcbiIsIHN0cmVy
cm9yKC1yZXQpKTsNCiAgICAgICAgcmV0dXJuIC0xOw0KICAgIH0NCg0KICAgIGJ1Zl90eXBlICpi
dWZzID0gKGJ1Zl90eXBlICopbWFsbG9jKHNpemVvZigqYnVmcykpOw0KDQogICAgc3RydWN0IHNv
Y2thZGRyX2luIGNsaWVudF9hZGRyOw0KICAgIHNvY2tsZW5fdCBjbGllbnRfbGVuID0gc2l6ZW9m
KGNsaWVudF9hZGRyKTsNCiAgICBhZGRfYWNjZXB0KHNvY2tfbGlzdGVuX2ZkLCAoc3RydWN0IHNv
Y2thZGRyICopJmNsaWVudF9hZGRyLCAmY2xpZW50X2xlbik7DQoNCiAgICB3aGlsZSAoMSkgew0K
ICAgICAgICBpb191cmluZ19zdWJtaXRfYW5kX3dhaXQoJnJpbmcsIDEpOw0KDQogICAgICAgIHN0
cnVjdCBpb191cmluZ19jcWUgKmNxZTsNCiAgICAgICAgdW5zaWduZWQgaGVhZDsNCg0KICAgICAg
ICBpb191cmluZ19mb3JfZWFjaF9jcWUoJnJpbmcsIGhlYWQsIGNxZSkgew0KICAgICAgICAgICAg
KytjcWVfY291bnQ7DQoNCiAgICAgICAgICAgIHN0cnVjdCBjb25uX2luZm8gY29ubl9pOw0KICAg
ICAgICAgICAgbWVtY3B5KCZjb25uX2ksICZjcWUtPnVzZXJfZGF0YSwgc2l6ZW9mKGNvbm5faSkp
Ow0KICAgICAgICAgICAgaW50IHJlc3VsdCA9IGNxZS0+cmVzOw0KDQogICAgICAgICAgICBzd2l0
Y2ggKGNvbm5faS50eXBlKSB7DQogICAgICAgICAgICBjYXNlIEFDQ0VQVDoNCiNpZiBVU0VfTElO
Sw0KICAgICAgICAgICAgICAgIGFkZF9wb2xsKHJlc3VsdCwgUE9MTElOLCBJT1NRRV9JT19MSU5L
KTsNCiAgICAgICAgICAgICAgICBhZGRfc29ja2V0X3JlYWQocmVzdWx0LCBNQVhfTUVTU0FHRV9M
RU4sIGJ1ZnMpOw0KI2Vsc2UNCiAgICAgICAgICAgICAgICBhZGRfcG9sbChyZXN1bHQsIFBPTExJ
TiwgMCk7DQojZW5kaWYNCiAgICAgICAgICAgICAgICBhZGRfYWNjZXB0KHNvY2tfbGlzdGVuX2Zk
LCAoc3RydWN0IHNvY2thZGRyICopJmNsaWVudF9hZGRyLCAmY2xpZW50X2xlbik7DQogICAgICAg
ICAgICAgICAgYnJlYWs7DQoNCiNpZiAhVVNFX0xJTksNCiAgICAgICAgICAgIGNhc2UgUE9MTDoN
CiAgICAgICAgICAgICAgICBhZGRfc29ja2V0X3JlYWQoY29ubl9pLmZkLCBNQVhfTUVTU0FHRV9M
RU4sIGJ1ZnMpOw0KICAgICAgICAgICAgICAgIGJyZWFrOw0KI2VuZGlmDQoNCiAgICAgICAgICAg
IGNhc2UgUkVBRDoNCiAgICAgICAgICAgICAgICBpZiAoX19idWlsdGluX2V4cGVjdChyZXN1bHQg
PD0gMCwgMCkpIHsNCiAgICAgICAgICAgICAgICAgICAgc2h1dGRvd24oY29ubl9pLmZkLCBTSFVU
X1JEV1IpOw0KICAgICAgICAgICAgICAgIH0gZWxzZSB7DQogICAgICAgICAgICAgICAgICAgIGFk
ZF9zb2NrZXRfd3JpdGUoY29ubl9pLmZkLCByZXN1bHQsIGJ1ZnMsIDApOw0KICAgICAgICAgICAg
ICAgIH0NCiAgICAgICAgICAgICAgICBicmVhazsNCg0KICAgICAgICAgICAgY2FzZSBXUklURToN
CiNpZiBVU0VfTElOSw0KICAgICAgICAgICAgICAgIGFkZF9wb2xsKGNvbm5faS5mZCwgUE9MTElO
LCBJT1NRRV9JT19MSU5LKTsNCiAgICAgICAgICAgICAgICBhZGRfc29ja2V0X3JlYWQoY29ubl9p
LmZkLCBNQVhfTUVTU0FHRV9MRU4sIGJ1ZnMpOw0KI2Vsc2UNCiAgICAgICAgICAgICAgICBhZGRf
cG9sbChjb25uX2kuZmQsIFBPTExJTiwgMCk7DQojZW5kaWYNCiAgICAgICAgICAgICAgICBicmVh
azsNCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KDQogICAgICAgIGlvX3VyaW5nX2NxX2FkdmFu
Y2UoJnJpbmcsIGNxZV9jb3VudCk7DQogICAgICAgIGNxZV9jb3VudCA9IDA7DQogICAgfQ0KDQoN
CiAgICBjbG9zZShzb2NrX2xpc3Rlbl9mZCk7DQogICAgZnJlZShidWZzKTsNCn0NCg0KDQoNCj4g
MjAyMOW5tDLmnIgxM+aXpSDkuIrljYgxOjEx77yMSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRr
PiDlhpnpgZPvvJoNCj4gDQo+IE9uIDIvMTIvMjAgOTozMSBBTSwgQ2FydGVyIExpIOadjumAmua0
siB3cm90ZToNCj4+IEhpIGV2ZXJ5b25lLA0KPj4gDQo+PiBJT1NRRV9JT19MSU5LIHNlZW1zIHRv
IGhhdmUgdmVyeSBoaWdoIGNvc3QsIGV2ZW4gZ3JlYXRlciB0aGVuIGlvX3VyaW5nX2VudGVyIHN5
c2NhbGwuDQo+PiANCj4+IFRlc3QgY29kZSBhdHRhY2hlZCBiZWxvdy4gVGhlIHByb2dyYW0gY29t
cGxldGVzIGFmdGVyIGdldHRpbmcgMTAwMDAwMDAwIGNxZXMuDQo+PiANCj4+ICQgZ2NjIHRlc3Qu
YyAtbHVyaW5nIC1vIHRlc3QwIC1nIC1PMyAtRFVTRV9MSU5LPTANCj4+ICQgdGltZSAuL3Rlc3Qw
DQo+PiBVU0VfTElOSzogMCwgY291bnQ6IDEwMDAwMDAwMCwgc3VibWl0X2NvdW50OiAxNTYyNTAw
DQo+PiAwLjk5dXNlciA5Ljk5c3lzdGVtIDA6MTEuMDJlbGFwc2VkIDk5JUNQVSAoMGF2Z3RleHQr
MGF2Z2RhdGEgMTYwOG1heHJlc2lkZW50KWsNCj4+IDBpbnB1dHMrMG91dHB1dHMgKDBtYWpvcis3
Mm1pbm9yKXBhZ2VmYXVsdHMgMHN3YXBzDQo+PiANCj4+ICQgZ2NjIHRlc3QuYyAtbHVyaW5nIC1v
IHRlc3QxIC1nIC1PMyAtRFVTRV9MSU5LPTENCj4+ICQgdGltZSAuL3Rlc3QxDQo+PiBVU0VfTElO
SzogMSwgY291bnQ6IDEwMDAwMDExMCwgc3VibWl0X2NvdW50OiA3OTk1ODQNCj4+IDAuODN1c2Vy
IDE5LjIxc3lzdGVtIDA6MjAuOTBlbGFwc2VkIDk1JUNQVSAoMGF2Z3RleHQrMGF2Z2RhdGEgMTYz
Mm1heHJlc2lkZW50KWsNCj4+IDBpbnB1dHMrMG91dHB1dHMgKDBtYWpvcis3Mm1pbm9yKXBhZ2Vm
YXVsdHMgMHN3YXBzDQo+PiANCj4+IEFzIHlvdSBjYW4gc2VlLCB0aGUgYC1EVVNFX0xJTks9MWAg
dmVyc2lvbiBlbWl0cyBvbmx5IGFib3V0IGhhbGYgaW9fdXJpbmdfc3VibWl0IGNhbGxzDQo+PiBv
ZiB0aGUgb3RoZXIgdmVyc2lvbiwgYnV0IHRha2VzIHR3aWNlIGFzIGxvbmcuIFRoYXQgbWFrZXMg
SU9TUUVfSU9fTElOSyBhbG1vc3QgdXNlbGVzcywNCj4+IHBsZWFzZSBoYXZlIGEgY2hlY2suDQo+
IA0KPiBUaGUgbm9wIGlzbid0IHJlYWxseSBhIGdvb2QgdGVzdCBjYXNlLCBhcyBpdCBkb2Vzbid0
IGNvbnRhaW4gYW55IHNtYXJ0cw0KPiBpbiB0ZXJtcyBvZiBleGVjdXRpbmcgYSBsaW5rIGZhc3Qu
IFNvIGl0IGRvZXNuJ3Qgc2F5IGEgd2hvbGUgbG90IG91dHNpZGUNCj4gb2YgIndlIGNvdWxkIG1h
a2Ugbm9wIGxpbmtzIGZhc3RlciIsIHdoaWNoIGlzIGFsc28ga2luZCBvZiBwb2ludGxlc3MuDQo+
IA0KPiAiTm9ybWFsIiBjb21tYW5kcyB3aWxsIHdvcmsgYmV0dGVyLiBXaGVyZSB0aGUgbGluayBp
cyByZWFsbHkgYSB3aW4gaXMgaWYNCj4gdGhlIGZpcnN0IHJlcXVlc3QgbmVlZHMgdG8gZ28gYXN5
bmMgdG8gY29tcGxldGUuIEZvciB0aGF0IGNhc2UsIHRoZQ0KPiBuZXh0IGxpbmsgY2FuIGV4ZWN1
dGUgZGlyZWN0bHkgZnJvbSB0aGF0IGNvbnRleHQuIFRoaXMgc2F2ZXMgYW4gYXN5bmMNCj4gcHVu
dCBmb3IgdGhlIGNvbW1vbiBjYXNlLg0KPiANCj4gLS0gDQo+IEplbnMgQXhib2UNCj4gDQoNCg==
