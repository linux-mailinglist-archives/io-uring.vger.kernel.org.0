Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCB924CD2A
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 07:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHUFRY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Aug 2020 01:17:24 -0400
Received: from mail-shaon0138.outbound.protection.partner.outlook.cn ([42.159.164.138]:24153
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbgHUFRX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Aug 2020 01:17:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/i5B7C4bgP5Q2CCcW5wSc4PuqEZl3atVGNpdsbSKCK8ujlpXRHu1/PaYaMJVNPwzSNXLyWM2nxPmtWhycgP2H8zgLg8OvUDPXXZDbjtURH417nir2NUear4Z8zSCpLoi9WliDlo54yVfIqsn9AagRKmy9+Gl7AKJIdt6fpHgKxBqRvH41WXztePaol1Zq8CwtYF8FGR3mktaay1e/FgEhxtx5GWUwZVeK29GvrHWMgsupzFZnb3XPdvAOx4Gen3j/yQvp9M+TJFOR54mYv8IXVPdpHywKQQO7gK9/c81nRPwwiae/fiKHLFVc8CYkKJoQZYfaR5wptMhoaZsfxK4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xy9tvRLyQQy9J88K4caz2CdP335WpvYh0bUwr0gdTk4=;
 b=EheOeyuZyVBa2WlTF2brg44+XQpLYiuCA5ya4RZt5n6j8TOfr0A7I70mmAbmS+n2ZSSPiMtiWlHqXW0epVbc4/RpKMSaxn//fiaAMGbGDPxR05XCvg9TdpcNvJcilPFzNxWXBnsVGqMedM/R8VmxjMFTTO8sWzfU56OFpHPi/TObuMUkxj+FrZVOXudhzCm8FbB7lNnDwvo/htkn23ZQwtZ7OJcYiDbhcj5vbCsRsyKNue6qhvzy4UPnsZ1/iDpElyxgpzvIhuI2VpB95WLRbkDGGjb2cel1SrVy/lBmgLoVWDHvD4y375uC/H6Cc6WluTd77AGg2iC1pWPxZFSnwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xy9tvRLyQQy9J88K4caz2CdP335WpvYh0bUwr0gdTk4=;
 b=KVDw99+dxtSZl/c1mRTVAi6wV3fLue3HIzMbaGhBBcH278R2d7+dEOIRk7erXpHw2setFTwh1rJCoc/5BMVo7r7/ELA0pw5+RnkLtU2nOpDCUNszGiglMErg3J/cG9U+n7WLt23BZmbq5dkedfUWsq4bI3ARzSfp12F8qB+Pl6E=
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn (10.43.110.79) by
 SHXPR01MB0765.CHNPR01.prod.partner.outlook.cn (10.43.107.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Fri, 21 Aug 2020 05:17:18 +0000
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79])
 by SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79]) with mapi
 id 15.20.3305.027; Fri, 21 Aug 2020 05:17:18 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Questions about IORING_OP_ASYNC_CANCEL usage
Thread-Topic: Questions about IORING_OP_ASYNC_CANCEL usage
Thread-Index: AQHWd3pWtdRamV9vkEugq7CZih+wGQ==
Date:   Fri, 21 Aug 2020 05:17:17 +0000
Message-ID: <1B338A13-1D60-4E7A-94C4-BDF06F20975B@eoitek.com>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
 <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
 <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
 <56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk>
 <1e733dd7-acd4-dde6-b3c5-c0ee0fbeda2a@gmail.com>
 <be37a342-9768-5d1e-8d80-6d3d28f236e8@kernel.dk>
 <9271f312-4863-fd3b-5ced-d200d68cfe22@gmail.com>
In-Reply-To: <9271f312-4863-fd3b-5ced-d200d68cfe22@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=eoitek.com;
x-originating-ip: [180.167.157.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 228dfe2e-291c-4c98-c597-08d845917944
x-ms-traffictypediagnostic: SHXPR01MB0765:
x-microsoft-antispam-prvs: <SHXPR01MB076550E90A6C61CE7DEE3C57945B0@SHXPR01MB0765.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:534;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTleAQj5tETEXVzhRb9YdMZOPufIgxl/K4Ssq5HYCOsbUwIhMo+ka3jViuKj/DRxCIFeaq+uF7R5XfIE3K7MzxUntJObBxNcjFLUlOUnWMMmBiPNTQH9nTPS+mW3ObI4fcIfl3ppeFSptdf89izZbVb+rEbArnrklpTA0yJnkLcMZ9c0vy+zqpe8+OB669Rl6hgvmxoaHvld3xouuDctm6EfbnI6Szx1diIqSWEFZ+ianuiHYN83WNCc610UHIa+mNaH6q8zG13GLYnxkbYZ8vVkN47FTMZI8IA31vYoQMD6wyVVZyvf3c1UMeS1H7R9vpGrdz+anJrI0oFvs+q3Lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(329002)(328002)(2906002)(63696004)(71200400001)(5660300002)(4744005)(33656002)(508600001)(86362001)(6916009)(4326008)(186003)(26005)(2616005)(85182001)(8676002)(8936002)(76116006)(66476007)(66556008)(66946007)(36756003)(64756008)(83380400001)(59450400001)(95416001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gKT+XI638FxNoQNrWe6dIf151tJnt/N9IK7KLCenb7+pSjyyNPyAUWqutbsNlU9d4FgSv3N4jVLqF7RuFw9UO4CTzTGEZXuYh39J02Pjw9Bbjp6MDK14coMCLz1tNZbSvwFovrp5GqgFGqmFGVVYga5izlULDSeJtdmC5Ygxb7ENHp58H92dMFkaUY8c4KNiYW8Q1LDr7mvEdoHJyBO4jH+Lon6zsYD5ZMWKY8EukUFTdJ7DIw9b3FqdBO9B0tzv49xoefW36OU7ooXGsMmyPpfgFUheAhGcU06/V89UMR1hne9q3GzWKWUOpn+Btx1dscABo4Dm2yQE58jitw3faChrb9WHwoPeDcZ+CK25bwkOr/yUa2Eo282UoUfxwgLgvZswFPnqklMx/KNCBN/mxpV4cEAT3GdD2uDQ8V/322jB+kSFcFLbhrVip5fS7wUkjOS2etQZmVAnfFjG2dq/44FHzdvD1/eHxkM+/TNMcDec8D5UiTtQwpaDogrmO/nMqrUeBWa/0LNAO8htfrC5UtC+17eM0clTMd8r0v/Zcd0th7+4t+hadCdaz1uB7bnpbfgWuRfsYRZGqVqPy2gXPw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2C3B7B76712774E85D33E725571DD55@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: 228dfe2e-291c-4c98-c597-08d845917944
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 05:17:17.9000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EE8d7kaMXV7E9rMFHUBlF5zuy5g58SjABOtuQuLDcGGLNKElqYgtaTJ6WVWeo6dpsxzYUHlu/sXkznYJfxsXuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0765
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGkgSmVucywNCg0KSSBoYXZlIHNvbWUgKCBtYXliZSBzdHVwaWQgKSBxdWVzdGlvbnMgYWJvdXQg
SU9SSU5HX09QX0FTWU5DX0NBTkNFTDoNCg0KMS4gRG9lcyBJT1JJTkdfT1BfQVNZTkNfQ0FOQ0VM
IGFsd2F5cyBjb21wbGV0ZSBpbmxpbmUgKCBpLmUuIGZpbmlzaGVzIGJlZm9yZSB0aGUgaW9fdXJp
bmdfZW50ZXIgc3lzY2FsbCByZXR1cm5zICk/DQoNCjIuIERvZXMgcmVjZW50IGNoYW5nZXMgb2Yg
YXN5bmMgYnVmZmVyZWQgcmVhZHMgaGF2ZSBhbnkgaW1wYWN0IHdpdGggY2FuY2VsYXRpb24/IENh
biB3ZSBjYW5jZWwgYSBidWZmZXJlZCBJT1JJTkdfT1BfUkVBRFYgb3BlcmF0aW9uIGFmdGVyIGl0
4oCZcyBzdGFydGVkPyBBbHRob3VnaCB0aGUgZGlzay0+a2VybmVsIERNQSBvcGVyYXRpb24gaXMg
bm90IGNhbmNlbGFibGUsIGNhbiB3ZSBjYW5jZWwgdGhlIGtlcm5lbC0+dXNlcmxhbmQgZGF0YSBj
b3B5Pw0KDQozLiBJIGhlYXJkIHRoYXQgYWxsIGJ1ZmZlcmVkIHdyaXRlcyBhcmUgc2VyaWFsaXpl
ZCBvbiB0aGUgaW5vZGUgbXV0ZXguIElmIGEgYnVmZmVyZWQgSU9SSU5HX09QX1dSSVRFViBpcyBi
bG9ja2VkIG9uIHRoZSBub2RlIG11dGV4LCBjYW4gd2UgY2FuY2VsIGl0Pw0KDQpUaGFua3MgaW4g
YWR2YW5jZSwNCkNhcnRlcg==
