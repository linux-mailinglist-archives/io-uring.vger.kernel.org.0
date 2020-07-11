Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC3021C4E5
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 17:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgGKPwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 11:52:31 -0400
Received: from mtel-bg02.venev.name ([77.70.28.44]:37644 "EHLO
        mtel-bg02.venev.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgGKPwb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 11:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
         s=default; h=MIME-Version:Content-Type:References:In-Reply-To:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rEPqBCwZONQ6AYSXcYS8o2o8OQwz8FfbDMCeocDNvWQ=; b=tZYX4iWC40Qvfm5tkYTqhEFWIE
        icFUCUVWLizCLw6W3wmkgZ8ncj0je3r7tzlFOGZmdQQU3YGmK8NfVDaTevq1rdXQUZJaxiqYdpbOf
        iUbWp/4smWmv9TEGpTB6byQ7O0VieS3rFv9EhznH3jguIQBiVmKgBba/j7QeCcx0teO0Rtk2qjTFw
        Cba74xef6A0/1xonWKUlZAxNfE7Pvb3myjgPk9Vl3QPqJo4IE9wgeIbfvEi5RpRPaHkOkEArFUv7M
        PmPqBWKtaXfXPypoNC1+c5CQ8JoBoES5hCx0juDPc7a/lKg42EYMmwI5LAylkWyWkh+av2u/cMOxk
        3kpvXgCY9OAcE37PeXMPVgykVg9vgvUUDgBnF7SSJdeov3aDTenatyoN9BblYF2Tul2J35LGMqscG
        IE3ffX0HA9xF5xFU90WU7CXCME8TrtcpnuqzcmxKF44MiX9XNw21CWxgcfIfi/ckAJA9BV44fCZrI
        sC6JVPH4xZL2xl/wArkR6/mYQr3PM9KHrJxV8lqjP3c18jEn+e+8H20c9XKjsF3TIsv5VqWBR8zjA
        1+IFphL6QQ/KRhiKLezhG0oBBODZ9nF7S32jp5R0b9qGgXVbPlDRIw9pZS1i7XSShqPyaLtgSGsCd
        mIyFs+dO2VgmENYWF0fvXcDRPztMTm+yA2JhEquAE=;
X-Check-Malware: ok
Received: from mtel-bg02.venev.name
        by mtel-bg02.venev.name with esmtpsa
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>)
        id 1juHnc-000bGq-UY; Sat, 11 Jul 2020 15:52:25 +0000
Message-ID: <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
From:   Hristo Venev <hristo@venev.name>
To:     Dmitry Vyukov <dvyukov@google.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org
Date:   Sat, 11 Jul 2020 18:52:19 +0300
In-Reply-To: <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
References: <20200711093111.2490946-1-dvyukov@google.com>
         <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
         <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-7aVTSutN4x7dkjL4pPhK"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--=-7aVTSutN4x7dkjL4pPhK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-07-11 at 17:31 +0200, Dmitry Vyukov wrote:
> Looking at the code more, I am not sure how it may not corrupt
> memory.
> There definitely should be some combinations where accessing
> sq_entries*sizeof(u32) more memory won't be OK.
> May be worth adding a test that allocates all possible sizes for
> sq/cq
> and fills both rings.

The layout (after the fix) is roughly as follows:

1. struct io_rings - ~192 bytes, maybe 256
2. cqes - (32 << n) bytes
3. sq_array - (4 << n) bytes

The bug was that the sq_array was offset by (4 << n) bytes. I think
issues can only occur when

    PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
    !=3D
    PAGE_ALIGN(192 + (32 << n) + (4 << n))

It looks like this never happens. We got lucky.

--=-7aVTSutN4x7dkjL4pPhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJGBAABCgAwFiEEWGQszEdDPeR3PQQhxqlBR4WW3HoFAl8J4DMSHGhyaXN0b0B2
ZW5ldi5uYW1lAAoJEMapQUeFltx6BRgQAI98gSXP66zxBGMu4WxCd1Nl2gcO/LXa
koEsg+Kyq2STWgQ3ySk0wwrZ79ZRqZWbqosZQ5oii8DaobgAg2ob04l2U7XhlJfv
Q/eU/qjKrWt3ZzeLvVi8WQNXA0RbDBwUtjtrRm+aQ8IKoctZclr9/n1jFsgsbSjk
22eU7FNiGbZ5jj6sA/qccRjn83teTsJJC9MBIweV1opY9lCxbSFdiShWTQCO2Q8m
CmacbquwBXiQTcYkY4q61x+qdZRjU77nB/E4q5Tk2Ep42BD2TeosViuaxNsQ8fi1
O4HinD1L9POkcZUS1kvmqKE7E3oLDW0jIdPQDfSvndqhZhOOXGrepY4QR5Hk9D+T
rAbUIYr2l0kbqsJ98Cg1r/mx1VI4+/hTvgLLpyWaNtHykjtPkHPK0l+RSMtUGkZ5
uqngt59PU7gIecAHhf5Ozv5A9aX9uWiXpnzF6TNQoRhmczifE1be2UXPTQPA1HZo
mIkxD3D0DNLadZY0b4D9dWtWaR740+ICDza3oXu0YbFK+SJf8josFnu4+Ialioo9
eWOkWD3F8fD2x3zNk0sXOlQcmhUu2Pj5W6l8wxiQeOn6JApi4e7+nMZN4Su2fzhh
vxEtIUByoE7LCEphHMj8Ixe8ysuMNcttLYubW2KaOFYlv8xJM6IreRKzm7cA9hVO
ch0ynFIma+pS
=CeTe
-----END PGP SIGNATURE-----

--=-7aVTSutN4x7dkjL4pPhK--

