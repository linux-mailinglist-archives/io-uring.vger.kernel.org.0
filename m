Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E944FE585
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiDLQI1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiDLQI0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:08:26 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78240522FE
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:06:06 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id h126-20020a1c2184000000b0038eb17fb7d6so2120442wmh.2
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=HIp+HBYo5UFn7aEcYfB9jcbAw1kgJ4tnwsuWiRR/VZA=;
        b=ItQRDUam7ANotnUjPPGKhr67m1U+Dv5p6tegDhoy1lyr5lRZO6eGTREzCeTxvmzl+a
         CgkZMw7QByA5sjbkV0MVZw6REDYJwaz0kVPH5qoHa4ouImUZw6DqqYD0KRPku1IlUPOv
         6iz6S6soIgSZC0Fdqcg2AK9pTOB/qzRqu4GgQ3hAMIDvUlEtuq21DzeRF/SCnXPTQgG4
         e4wN7+aRh9oHDKSG01dWYJ7jw1VM99tAYK0xwhIlCFJGMo4Wk/pIJvxU5vIPoA8LQVV8
         BmTmvzl6CPNdhEOyy2nasqnGVRQaPiQu/WNHYPd2Y7+x6IQA53gyjiwdpadih7wbCnAX
         AW8Q==
X-Gm-Message-State: AOAM533fWHRSqj+kVvAr+NI9LHOVU2CVD2+bC0iVPlAAl5ZjG+A08WHh
        tAyh/M9Li3n7ThZ5OMiAsno=
X-Google-Smtp-Source: ABdhPJyrnpjEt3RzeIBVm8UZCB197Xjvnva+giHAEVyKCf2nnieyyY6na3a8krnSx3TemInFAiFysQ==
X-Received: by 2002:a05:600c:4ece:b0:38c:7938:d73c with SMTP id g14-20020a05600c4ece00b0038c7938d73cmr4677317wmq.165.1649779564653;
        Tue, 12 Apr 2022 09:06:04 -0700 (PDT)
Received: from [192.168.188.10] (55d4d7c6.access.ecotel.net. [85.212.215.198])
        by smtp.gmail.com with ESMTPSA id 20-20020a05600c22d400b0038c8dbdc1a3sm2661242wmg.38.2022.04.12.09.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 09:06:03 -0700 (PDT)
Message-ID: <49f6ed82-0250-bb8c-d12a-c8cce1f72ad2@geekplace.eu>
Date:   Tue, 12 Apr 2022 18:06:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 9/9] io_uring: optimise io_get_cqe()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1649771823.git.asml.silence@gmail.com>
 <487eeef00f3146537b3d9c1a9cef2fc0b9a86f81.1649771823.git.asml.silence@gmail.com>
From:   Florian Schmaus <flo@geekplace.eu>
In-Reply-To: <487eeef00f3146537b3d9c1a9cef2fc0b9a86f81.1649771823.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------UUkTXSZqsxnKu6aomxG6QA0n"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------UUkTXSZqsxnKu6aomxG6QA0n
Content-Type: multipart/mixed; boundary="------------wVVSPI0qRX1gpXmvwXRE1zTi";
 protected-headers="v1"
From: Florian Schmaus <flo@geekplace.eu>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Message-ID: <49f6ed82-0250-bb8c-d12a-c8cce1f72ad2@geekplace.eu>
Subject: Re: [PATCH 9/9] io_uring: optimise io_get_cqe()
References: <cover.1649771823.git.asml.silence@gmail.com>
 <487eeef00f3146537b3d9c1a9cef2fc0b9a86f81.1649771823.git.asml.silence@gmail.com>
In-Reply-To: <487eeef00f3146537b3d9c1a9cef2fc0b9a86f81.1649771823.git.asml.silence@gmail.com>

--------------wVVSPI0qRX1gpXmvwXRE1zTi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTIvMDQvMjAyMiAxNi4wOSwgUGF2ZWwgQmVndW5rb3Ygd3JvdGU6DQo+IGlvX2dldF9j
cWUoKSBpcyBleHBlbnNpdmUgYmVjYXVzZSBvZiBhIGJ1bmNoIG9mIGxvYWRzLCBtYXNraW5n
LCBldGMuDQo+IEhvd2V2ZXIsIG1vc3Qgb2YgdGhlIHRpbWUgd2Ugc2hvdWxkIGhhdmUgZW5v
dWdoIG9mIGVudHJpZXMgaW4gdGhlIENRLA0KPiBzbyB3ZSBjYW4gY2FjaGUgdHdvIHBvaW50
ZXJzIHJlcHJlc2VudGluZyBhIHJhbmdlIG9mIGNvbnRpZ3VvdXMgQ1FFDQo+IG1lbW9yeSB3
ZSBjYW4gdXNlLiBXaGVuIHRoZSByYW5nZSBpcyBleGhhdXN0ZWQgd2UnbGwgZ28gdGhyb3Vn
aCBhIHNsb3dlcg0KPiBwYXRoIHRvIHNldCB1cCBhIG5ldyByYW5nZS4gV2hlbiB0aGVyZSBh
cmUgbm8gQ1FFcyBhdmFsaWFibGUsIHBvaW50ZXJzDQo+IHdpbGwgbmF0dXJhbGx5IHBvaW50
IHRvIHRoZSBzYW1lIGFkZHJlc3MuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1
bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICAgZnMvaW9fdXJpbmcu
YyB8IDQ2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0N
Cj4gICAxIGZpbGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMNCj4g
aW5kZXggYjM0OWEzYzUyMzU0Li5mMjI2OWZmZTA5ZWIgMTAwNjQ0DQo+IC0tLSBhL2ZzL2lv
X3VyaW5nLmMNCj4gKysrIGIvZnMvaW9fdXJpbmcuYw0KPiBAQCAtNDE2LDYgKzQxNiwxMyBA
QCBzdHJ1Y3QgaW9fcmluZ19jdHggew0KPiAgIAl1bnNpZ25lZCBsb25nCQljaGVja19jcV9v
dmVyZmxvdzsNCj4gICANCj4gICAJc3RydWN0IHsNCj4gKwkJLyoNCj4gKwkJICogV2UgY2Fj
aGUgYSByYW5nZSBvZiBmcmVlIENRRXMgd2UgY2FuIHVzZSwgb25jZSBleGhhdXN0ZWQgaXQN
Cj4gKwkJICogc2hvdWxkIGdvIHRocm91Z2ggYSBzbG93ZXIgcmFuZ2Ugc2V0dXAsIHNlZSBf
X2lvX2dldF9jcWUoKQ0KPiArCQkgKi8NCj4gKwkJc3RydWN0IGlvX3VyaW5nX2NxZQkqY3Fl
X2NhY2hlZDsNCj4gKwkJc3RydWN0IGlvX3VyaW5nX2NxZQkqY3FlX3NhbnRpbmVsOw0KDQpJ
IHRoaW5rIHRoaXMgc2hvdWxkIHMvc2FudGluZWwvc2VudGluZWwuDQoNCi0gRmxvdw0K

--------------wVVSPI0qRX1gpXmvwXRE1zTi--

--------------UUkTXSZqsxnKu6aomxG6QA0n
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEl3UFnzoh3OFr5PuuIjmn6PWFIFIFAmJVo2oFAwAAAAAACgkQIjmn6PWFIFLm
kQf8CgEDVg2fP4Ab2b5reAIGgapdTLeBPgV1iHrhzEnlB7wGBQRaQWz5zMB1b93kx/RFvRlE3lVX
eyQpjj0mEfYNbkV2zWMCsI50HsJyOdlKIlH3WsLnrF4y6jacoTYw83vz3PKndEH11pjZzLIOxPHn
aJluTZX+CKbSHaDfgWzq5+JKPeLNycAzsqnlTqTdAcO/E9qCE8sGrtkh3lA8lR51frhXr2idb4EH
cDfZPK/C+Aqyz+lwNkSkVtXYyBHNLZ1SzWwE0I1GzEGf8jCDgZQizDVjRADZEeHkLO2brD125N3N
VSMpElwbzRsU4oXW9x8BLaQa7UL1nrMzRwIFDbxbcA==
=hdtA
-----END PGP SIGNATURE-----

--------------UUkTXSZqsxnKu6aomxG6QA0n--
