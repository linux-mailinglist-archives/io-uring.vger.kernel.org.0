Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E58215AE03
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 18:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgBLRFE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 12:05:04 -0500
Received: from mail-shaon0139.outbound.protection.partner.outlook.cn ([42.159.164.139]:22052
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727111AbgBLRFD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 12 Feb 2020 12:05:03 -0500
X-Greylist: delayed 2002 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 12:05:01 EST
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VThbg9h3EGH2ZOAaBE2Hq3SiCkliyRgNaG2dZyk9ZId5XAS7wYSB/E/3buJ+c+9Yw2kczC3St9PGsIWgccramebJtNa1P3POWEA3PSkseYsErNoHFfgTts53WQZzmkCHVXlqFUGeSRxFHuyFPL6KW0SsTBWnNADvpil6MO16zVNc3daWUBKLBMdE7OSDwuqPwTBgSRusTk0eVw0fEXru482UHduMh3poQZLyaF5KasNS+whB59TPogDnU12Wt+rVUGa1XNV/mNyPdL2CQwk8C5Tbir+Yxdu9dOprR1TD0pYcocbjPks6/gpSL0OLNVyZo5qOhY36gHZHwub4FRzKGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlO3oLqt8XFFBkLaJ3y20gPol0WLJw2NTrjw74GiOuA=;
 b=debxOcYL4bA3MTVedA2+pRtrrmD2QXfbp3YI4N1sHRrsO+ipYQz67GmOeySnOaRy34/md+Lg2psTBZxUeI2/fYYHK8ArZOGhsvifkav6PmLz0lO3IOu6ynEBBIKvhLe6ZC7qJUXJqR3VXKVt+kyexi/SPU+PPH3+FQQuADRjLCV3QUHFQg/LGOiAc1QyBSSxgbhq9SVnNiuI+Ytv+slPG7w7ypnOVmmDkWcJQ0sXlKOGpbSdJKztdzOyC2i+1T7sIfmSn3L3fZeXA0fMqT9nk+DKzLFYGpYyzDei0Bn8JfGKcubB+cwRMsu8rU1ZTBkijkVsRk7Fhm8hmTXGIoelfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlO3oLqt8XFFBkLaJ3y20gPol0WLJw2NTrjw74GiOuA=;
 b=ZKeiW6ssWD8yKBvC0XzaGxy+1HwvhvA+FgXOrUH3aTj9zv4kSXblM+nnNp2SIzqwn8F3GZRk5k4jh33CC85wRaUldWvZeH3lCuPuiAfoD5pWkrLWFLbXwv0lPK+RqwvyT4QR+YkHy8Em2JHGPDNe2hKUJ1HuYoKczWQYSf0n9m8=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0492.CHNPR01.prod.partner.outlook.cn (10.43.108.21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23; Wed, 12 Feb
 2020 16:31:31 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Wed, 12 Feb 2020 16:31:31 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     io-uring <io-uring@vger.kernel.org>
Subject: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Topic: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Index: AQHV4cHhpj4vlwaolEOmZJk1sNu8qw==
Date:   Wed, 12 Feb 2020 16:31:31 +0000
Message-ID: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [111.68.10.170]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2127b471-55d3-4de5-e5bf-08d7afd90490
x-ms-traffictypediagnostic: SH0PR01MB0492:
x-microsoft-antispam-prvs: <SH0PR01MB049202B06A5A0724376A056A941B0@SH0PR01MB0492.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(189003)(199004)(328002)(329002)(76116006)(2616005)(63696004)(71200400001)(86362001)(95416001)(2906002)(8676002)(66476007)(66556008)(81166006)(81156014)(186003)(66946007)(5660300002)(64756008)(26005)(66446008)(508600001)(36756003)(8936002)(6916009)(85182001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0492;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2efC0d9nYHSzszYKya+7zcuwMgll2DWDtUF2pNMkUUcymET1fzCsW0+KrPodGGaz+lVBXIQrh9oRxwPLza74JFjcUda5q3pM1sL5ZRRm/ALwP4u8ZnY6k3qcItAz+vEvTzxDovFFRMAHfRMv5A2ScwaXiPCwsgFjZV94/5m+G+xravydNd248mDl5JWt5Q8+/qPie94YVy2ZKi1pjptqceRTmZHULv0uBCA7LBpUdSHFj7HRHoHZzz0/JfymMV+gNlCnPAa26n9Ga72w2+c9rKaf+N8xH4G88jyfqP2yRvhkWAOTCyvLjwIclSTO48txUvnp8PdVvx1W/WHs89X8PgphME9mnYvrx/158QTnME7p38CNRR59bh6CNPwcWAxlfN/IvCHLsA8ou2BWYk2tR0DCc+QvO8kN15Vl+wyhSuVwnuKDdl4KpV6KBsPMbG+7
x-ms-exchange-antispam-messagedata: SD6COzCDgIJQJFKEsuBhXF4uSfGgYdesRK5RNLg2rLxjqM12CuvosR3O1NVdyKm6BFJ5QVhru4HWDk68lHKENW8inuhXmDWYxv74TciHEqVqgRc3NrsNWh1lIJuBNvEnH3wsZ5TWwYou3vS4TA15hA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBC04BEA6C992744A9EF8C9348AC288A@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2127b471-55d3-4de5-e5bf-08d7afd90490
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 16:31:31.3424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4Gqv7NyDqtGJY+V7Xlm6ACbOiKR4lpMGnI7sTI5Mk3EcPHg8quN55ZaeiiRtU7B8DZa4phdbSHHFp77P2wJyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0492
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGkgZXZlcnlvbmUsDQoNCklPU1FFX0lPX0xJTksgc2VlbXMgdG8gaGF2ZSB2ZXJ5IGhpZ2ggY29z
dCwgZXZlbiBncmVhdGVyIHRoZW4gaW9fdXJpbmdfZW50ZXIgc3lzY2FsbC4NCg0KVGVzdCBjb2Rl
IGF0dGFjaGVkIGJlbG93LiBUaGUgcHJvZ3JhbSBjb21wbGV0ZXMgYWZ0ZXIgZ2V0dGluZyAxMDAw
MDAwMDAgY3Flcy4NCg0KJCBnY2MgdGVzdC5jIC1sdXJpbmcgLW8gdGVzdDAgLWcgLU8zIC1EVVNF
X0xJTks9MA0KJCB0aW1lIC4vdGVzdDANClVTRV9MSU5LOiAwLCBjb3VudDogMTAwMDAwMDAwLCBz
dWJtaXRfY291bnQ6IDE1NjI1MDANCjAuOTl1c2VyIDkuOTlzeXN0ZW0gMDoxMS4wMmVsYXBzZWQg
OTklQ1BVICgwYXZndGV4dCswYXZnZGF0YSAxNjA4bWF4cmVzaWRlbnQpaw0KMGlucHV0cyswb3V0
cHV0cyAoMG1ham9yKzcybWlub3IpcGFnZWZhdWx0cyAwc3dhcHMNCg0KJCBnY2MgdGVzdC5jIC1s
dXJpbmcgLW8gdGVzdDEgLWcgLU8zIC1EVVNFX0xJTks9MQ0KJCB0aW1lIC4vdGVzdDENClVTRV9M
SU5LOiAxLCBjb3VudDogMTAwMDAwMTEwLCBzdWJtaXRfY291bnQ6IDc5OTU4NA0KMC44M3VzZXIg
MTkuMjFzeXN0ZW0gMDoyMC45MGVsYXBzZWQgOTUlQ1BVICgwYXZndGV4dCswYXZnZGF0YSAxNjMy
bWF4cmVzaWRlbnQpaw0KMGlucHV0cyswb3V0cHV0cyAoMG1ham9yKzcybWlub3IpcGFnZWZhdWx0
cyAwc3dhcHMNCg0KQXMgeW91IGNhbiBzZWUsIHRoZSBgLURVU0VfTElOSz0xYCB2ZXJzaW9uIGVt
aXRzIG9ubHkgYWJvdXQgaGFsZiBpb191cmluZ19zdWJtaXQgY2FsbHMNCm9mIHRoZSBvdGhlciB2
ZXJzaW9uLCBidXQgdGFrZXMgdHdpY2UgYXMgbG9uZy4gVGhhdCBtYWtlcyBJT1NRRV9JT19MSU5L
IGFsbW9zdCB1c2VsZXNzLA0KcGxlYXNlIGhhdmUgYSBjaGVjay4NCg0KVGhhbmtzLA0KQ2FydGVy
IExpDQoNCi0tLQ0KDQojaW5jbHVkZSA8bGlidXJpbmcuaD4NCiNpbmNsdWRlIDxzdGRpby5oPg0K
DQojZGVmaW5lIEVOVFJZX1NJWkUgMTI4DQojZGVmaW5lIE1BWF9DT1VOVCAxMDAwMDAwMDANCg0K
I2lmbmRlZiBVU0VfTElOSw0KIwlkZWZpbmUgVVNFX0xJTksgMA0KI2VuZGlmDQoNCmludCBtYWlu
KHZvaWQpIHsNCglzdHJ1Y3QgaW9fdXJpbmcgcmluZzsNCgl1bnNpZ25lZCBpLCBoZWFkOw0KCXVu
c2lnbmVkIGNvdW50ID0gMCwgY3FlX2NvdW50ID0gMCwgc3VibWl0X2NvdW50ID0gMDsNCglzdHJ1
Y3QgaW9fdXJpbmdfc3FlICpzcWU7DQoJc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlOw0KDQoJaWYg
KGlvX3VyaW5nX3F1ZXVlX2luaXQoRU5UUllfU0laRSwgJnJpbmcsIDApIDwgMCkgew0KCQlyZXR1
cm4gLTE7DQoJfQ0KDQoJZm9yIChpID0gMDsgaSA8IEVOVFJZX1NJWkUgLyAyOyArK2kpIHsNCgkJ
c3FlID0gaW9fdXJpbmdfZ2V0X3NxZSgmcmluZyk7DQoJCWlvX3VyaW5nX3ByZXBfbm9wKHNxZSk7
DQojaWYgVVNFX0xJTksNCgkJaW9fdXJpbmdfc3FlX3NldF9mbGFncyhzcWUsIElPU1FFX0lPX0xJ
TkspOw0KCQlzcWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsNCgkJaW9fdXJpbmdfcHJlcF9u
b3Aoc3FlKTsNCgkJc3FlLT51c2VyX2RhdGEgPSAxOw0KI2VuZGlmDQoJfQ0KDQoJd2hpbGUgKGNv
dW50IDwgTUFYX0NPVU5UKSB7DQoJCWlvX3VyaW5nX3N1Ym1pdF9hbmRfd2FpdCgmcmluZywgMSk7
DQoJCSsrc3VibWl0X2NvdW50Ow0KDQoJCWlvX3VyaW5nX2Zvcl9lYWNoX2NxZSgmcmluZywgaGVh
ZCwgY3FlKSB7DQoJCQkrK2NxZV9jb3VudDsNCgkJCSsrY291bnQ7DQojaWYgVVNFX0xJTksNCgkJ
CWlmIChjcWUtPnVzZXJfZGF0YSkgew0KCQkJCXNxZSA9IGlvX3VyaW5nX2dldF9zcWUoJnJpbmcp
Ow0KCQkJCWlvX3VyaW5nX3ByZXBfbm9wKHNxZSk7DQoJCQkJaW9fdXJpbmdfc3FlX3NldF9mbGFn
cyhzcWUsIElPU1FFX0lPX0xJTkspOw0KCQkJCXNxZSA9IGlvX3VyaW5nX2dldF9zcWUoJnJpbmcp
Ow0KCQkJCWlvX3VyaW5nX3ByZXBfbm9wKHNxZSk7DQoJCQkJc3FlLT51c2VyX2RhdGEgPSAxOw0K
CQkJfQ0KI2Vsc2UNCgkJCXNxZSA9IGlvX3VyaW5nX2dldF9zcWUoJnJpbmcpOw0KCQkJaW9fdXJp
bmdfcHJlcF9ub3Aoc3FlKTsNCgkJCXNxZS0+dXNlcl9kYXRhID0gIWNxZS0+dXNlcl9kYXRhOw0K
I2VuZGlmDQoJCX0NCgkJaW9fdXJpbmdfY3FfYWR2YW5jZSgmcmluZywgY3FlX2NvdW50KTsNCgkJ
Y3FlX2NvdW50ID0gMDsNCgl9DQoNCglwcmludGYoIlVTRV9MSU5LOiAlZCwgY291bnQ6ICV1LCBz
dWJtaXRfY291bnQ6ICV1XG5cbiIsDQoJCVVTRV9MSU5LLCBjb3VudCwgc3VibWl0X2NvdW50KTsN
Cn0NCg0KDQo=
