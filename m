Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DBC73660D
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjFTI0R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 04:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjFTI0O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 04:26:14 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FF7127
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 01:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=VFPzARwqn8nEqf1DaCc2+EIZl65hVp6IKm+UjmCiVXk=; b=NvqI+xXDzmToVT5BnMUqPJ0q31
        UGqNaEwdT7JG88QnG5m/WGsZvHvSlJBPvje013L4WVwjT1d6z4FTq8JogvL9ViIvE2fk77/OUYth/
        sbY0SVtkMvzx8Lz1vdCXqEHNEdhcE6SGhHasZBK4D0S1Z1pCIrC6jBh7Ej50VTTGI5ZVvBev6NAjP
        7l/ubdX3bUqGfbFLEPuah9sWXdgbJm68/YbroUe4sSZOC1rDAwxDt4DGEUzEj0mj0xsJ0+TnF9N/m
        10Xr6tp3qhv3aYe8Qu9XuHjs3TjWaXNoEflqd3Jp1zKNEfw8vw0CGILUkSkc4nwT968Auz1fg8p53
        BovsPHr0yKErptGlkvig3KLQoV2g0s/vAwOee8eRiPC2PaHLx0pNkYXigEQWXTLF4zWblpiTUJ043
        65psiRWZTDDRCOuio/GwTnGFkAv0wVCx7e4MpJMl9LZUYX5PnMbYEEkrwXIj4HMMLbc5VkbBnffQ1
        IQAODTxyxbZA2H3L209Fv3x8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBWgk-003CtV-1A;
        Tue, 20 Jun 2023 08:26:10 +0000
Message-ID: <2a7309e2-1f1e-f1a5-0b89-2b1431fc331c@samba.org>
Date:   Tue, 20 Jun 2023 10:26:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: disable partial retries for recvmsg with
 cmsg
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <472c1b08-0409-bd55-7c4a-6d33f07efced@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <472c1b08-0409-bd55-7c4a-6d33f07efced@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGkgSmVucywNCg0KPiBXZSBjYW5ub3Qgc2FuZWx5IGhhbmRsZSBwYXJ0aWFsIHJldHJpZXMg
Zm9yIHJlY3Ztc2cgaWYgd2UgaGF2ZSBjbXNnDQo+IGF0dGFjaGVkLiBJZiB3ZSBkb24ndCwg
dGhlbiB3ZSdkIGp1c3QgYmUgb3ZlcndyaXRpbmcgdGhlIGluaXRpYWwgY21zZw0KPiBoZWFk
ZXIgb24gcmV0cmllcy4gQWx0ZXJuYXRpdmVseSB3ZSBjb3VsZCBpbmNyZW1lbnQgYW5kIGhh
bmRsZSB0aGlzDQo+IGFwcHJvcHJpYXRlbHksIGJ1dCBpdCBkb2Vzbid0IHNlZW0gd29ydGgg
dGhlIGNvbXBsaWNhdGlvbi4NCj4gDQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2lvLXVyaW5nLzBiMGQ0NDExLWM4ZmQtNDI3Mi03NzBiLWUwMzBhZjY5MTlhMEBrZXJuZWwu
ZGsvDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNS4xMCsNCj4gUmVwb3J0ZWQt
Ynk6IFN0ZWZhbiBNZXR6bWFjaGVyIDxtZXR6ZUBzYW1iYS5vcmc+DQo+IFNpZ25lZC1vZmYt
Ynk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gDQo+IC0tLQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2lvX3VyaW5nL25ldC5jIGIvaW9fdXJpbmcvbmV0LmMNCj4gaW5kZXggZmUx
YzQ3OGM3ZGVjLi42Njc0YTA3NTkzOTAgMTAwNjQ0DQo+IC0tLSBhL2lvX3VyaW5nL25ldC5j
DQo+ICsrKyBiL2lvX3VyaW5nL25ldC5jDQo+IEBAIC03ODgsNyArNzg4LDggQEAgaW50IGlv
X3JlY3Ztc2coc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFn
cykNCj4gICAJZmxhZ3MgPSBzci0+bXNnX2ZsYWdzOw0KPiAgIAlpZiAoZm9yY2Vfbm9uYmxv
Y2spDQo+ICAgCQlmbGFncyB8PSBNU0dfRE9OVFdBSVQ7DQo+IC0JaWYgKGZsYWdzICYgTVNH
X1dBSVRBTEwpDQo+ICsJLyogZGlzYWJsZSBwYXJ0aWFsIHJldHJ5IGZvciByZWN2bXNnIHdp
dGggY21zZyBhdHRhY2hlZCAqLw0KPiArCWlmIChmbGFncyAmIE1TR19XQUlUQUxMICYmICFr
bXNnLT5jb250cm9sbGVuKQ0KPiAgIAkJbWluX3JldCA9IGlvdl9pdGVyX2NvdW50KCZrbXNn
LT5tc2cubXNnX2l0ZXIpOw0KDQpJc24ndCBrbXNnLT5jb250cm9sbGVuIG9ubHkgdXNlZCBm
b3IgUkVRX0ZfQVBPTExfTVVMVElTSE9UPw0KDQpJIGd1ZXNzIHRoZSBjb3JyZWN0IHZhbHVl
IHdvdWxkIGJlIGttc2ctPm1zZy5tc2dfY29udHJvbGxlbj8NCg0KTWF5YmUgdGhlIHNhZmVz
dCBjaGFuZ2Ugd291bGQgYmUgc29tZXRoaW5nIGxpa2UgdGhpcyAoY29tcGxldGVseSB1bnRl
c3RlZCEpOg0KDQpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvbmV0LmMgYi9pb191cmluZy9uZXQu
Yw0KaW5kZXggODllODM5MDEzODM3Li4xZGQ1MzIyZmI3MzIgMTAwNjQ0DQotLS0gYS9pb191
cmluZy9uZXQuYw0KKysrIGIvaW9fdXJpbmcvbmV0LmMNCkBAIC03ODEsMTQgKzc4MSwxNCBA
QCBpbnQgaW9fcmVjdm1zZyhzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50IGlz
c3VlX2ZsYWdzKQ0KICAJZmxhZ3MgPSBzci0+bXNnX2ZsYWdzOw0KICAJaWYgKGZvcmNlX25v
bmJsb2NrKQ0KICAJCWZsYWdzIHw9IE1TR19ET05UV0FJVDsNCi0JaWYgKGZsYWdzICYgTVNH
X1dBSVRBTEwpDQotCQltaW5fcmV0ID0gaW92X2l0ZXJfY291bnQoJmttc2ctPm1zZy5tc2df
aXRlcik7DQoNCiAgCWttc2ctPm1zZy5tc2dfZ2V0X2lucSA9IDE7DQogIAlpZiAocmVxLT5m
bGFncyAmIFJFUV9GX0FQT0xMX01VTFRJU0hPVCkNCiAgCQlyZXQgPSBpb19yZWN2bXNnX211
bHRpc2hvdChzb2NrLCBzciwga21zZywgZmxhZ3MsDQogIAkJCQkJICAgJm1zaG90X2Zpbmlz
aGVkKTsNCiAgCWVsc2UNCisJCWlmIChmbGFncyAmIE1TR19XQUlUQUxMICYmICFrbXNnLT5t
c2cubXNnX2NvbnRyb2xsZW4pDQorCQkJbWluX3JldCA9IGlvdl9pdGVyX2NvdW50KCZrbXNn
LT5tc2cubXNnX2l0ZXIpOw0KICAJCXJldCA9IF9fc3lzX3JlY3Ztc2dfc29jayhzb2NrLCAm
a21zZy0+bXNnLCBzci0+dW1zZywNCiAgCQkJCQkga21zZy0+dWFkZHIsIGZsYWdzKTsNCg0K
DQptZXR6ZQ0K
