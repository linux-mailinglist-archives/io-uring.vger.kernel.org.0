Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6050416AA54
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgBXPlJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:41:09 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35386 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgBXPlJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:41:09 -0500
Received: by mail-wr1-f67.google.com with SMTP id w12so10928053wrt.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=WsorB5vWWvp3FN18bZLzd2tF/W1D1iRWl5fkxAjyCqY=;
        b=nGG+ayN/4FAAJ+OzsDA6xPmt4YqKozwY7t6FRYMdkqwkc0B8bjnyxVF0m/kaQ/mIW5
         eiwDl7o29YWgbq8Qi17f4TkjVd7Py50Il5oNZwHJ6/v86RB9N+bUUwEkB4wK6yzFr24L
         MlN55D9NX3Hg96JBw3VPDW3+6j83NjpGeoCJcBYHdDnhKARm1y040MXQZLHhgIgw5yJ1
         +x57VZATO2oQdby01Kh5e/TGxGZs+IJGcZqxXl1UgsNuhQPYlegVK8A4Nkggdz7x/UvJ
         9/jxf4V8WFlhCOBDkOXDvl8bWJRYEUWcsqGII7M3VE/8HeopIGDgR7Uvumq85DVl7djH
         VVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=WsorB5vWWvp3FN18bZLzd2tF/W1D1iRWl5fkxAjyCqY=;
        b=kJMix3yWdDkSIG7/ak0Sbzu1b7c5uh5xPiEw+N1p3uoSEJkKu4Dr8UnIs6NIly+Bkd
         hVT4hOwyShZne1RtVz1pJSSIoZED/Nw/nnrpcpYRnfoYpIk+JajDM8Piw1rtUEa14dRS
         Al64cn4dpZPw7n7412jwDOZ5DAoJqHR0T+7iQKcpw6l5/bBz439Fb56HqoDBba8M1lrR
         dEsIK4b0l5WRrn21jyg1tnXiNmKrWll6vbsqs9cx+eJMDREdtTwxcIL4M2mV/f5L4LZg
         H2AE3krBOQGYSY6LpmebL7kmqJwgb883SyEM7PNXTJUFPzqOhQTYg87oVnhs+0PkQxZ4
         s7XQ==
X-Gm-Message-State: APjAAAXByAcijZMSwBmH6bI9cys2wkdMhUSklgeNEYui+8XjO2VnqwDE
        QNLmvC2EoqtdpJ3MVWiNksPDE5mO
X-Google-Smtp-Source: APXvYqxDTtaSseNHPJGIRUMUxN1tKi6ppYo/Vf398vTz0J8niuQySxtiidxzwpcv4unGdetq5sDH2w==
X-Received: by 2002:adf:cd03:: with SMTP id w3mr68597916wrm.191.1582558866778;
        Mon, 24 Feb 2020 07:41:06 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id n13sm19146602wmd.21.2020.02.24.07.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:41:05 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
 <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
Message-ID: <f880f914-8fd4-2f11-a859-a78148915699@gmail.com>
Date:   Mon, 24 Feb 2020 18:40:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2Y3IsaPFIoarmMDg6dRt1ldJ9bE5svX9u"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Y3IsaPFIoarmMDg6dRt1ldJ9bE5svX9u
Content-Type: multipart/mixed; boundary="FmouyxkJODbrNHOd3uHMMDmYGrvdHcHXu";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <f880f914-8fd4-2f11-a859-a78148915699@gmail.com>
Subject: Re: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
References: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
 <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
In-Reply-To: <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>

--FmouyxkJODbrNHOd3uHMMDmYGrvdHcHXu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 18:27, Jens Axboe wrote:
> On 2/24/20 2:15 AM, Pavel Begunkov wrote:
>> It seems no opcode may return -EAGAIN for non-blocking case and expect=

>> to be reissued. Remove retry code from io_wq_submit_work().
>=20
> There's actually a comment right there on how that's possible :-)

Yeah, I saw it and understand the motive, and how it may happen, but can'=
t
find a line, which can actually return -EAGAIN. Could you please point to=
 an
example?

E.g. I suppose for io_read() it may happen in call_read_iter(), but its r=
esult
(i.e. res2) will be written to cqe, but not returned.
> Normally, for block IO, we can wait for request slots if we run out.
> For polled IO, that isn't possible since the task itself is the one
> that will find completions and hence free request slots as well. If
> the submitting task is allowed to sleep waiting for requests that it
> itself are supposed to find and complete, then we'd hang. Hence we
> return -EAGAIN for that case, and have no other choice for polled
> IO than to retry.


--=20
Pavel Begunkov


--FmouyxkJODbrNHOd3uHMMDmYGrvdHcHXu--

--2Y3IsaPFIoarmMDg6dRt1ldJ9bE5svX9u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5T7mYACgkQWt5b1Glr
+6UylQ/+NgYSCltfm9PIAYiAmAEx4tEznpjOgTlAA+lU5oto/IjRtKVJgD+IvpxN
QTv7BUGl+kNg+kOB0RTdCwOjIDxeAmb1fmebkQsMesJpHJAsef+xTTYQS/XjSVmP
WhhzQ1POPs2mkmAIXebhJicv+Kqsha4YipCgzvRhapeWkqm/gXMjmOPQcZ3pVEwc
jXLIw9w1qliXjmKG8wBoewN6Ru5Nr2uedQ4CrLM98Jp6s5D9uumF8fC/xVhJ6la8
AZglPULaACcf3tyEaMTHroYYJr9v6EZrjrv7j0J7Yx4rHmIHaCQ5YTQtV8I71FXk
Zh8CGTJa5oEoj5jEyHQSJrCuwVqtPK1ewbCmGIRKJYPgoSGjbsg9+2s5LIUw4SLK
TzdsK5a4/Ol4NoB6Y893Q49H999LrpBGc0tE0dCF6CLK5cYZR/VAPJbN8nzoFktq
oVTA7ksAnF2ZCrSC2Z5daofV6y/bCRnHLSDUopK6TMcE6Gm51Zsl1/1otm0EnfuH
y9X26z+qMxA1u6Rh9daEPPWDr/DxDNEKPF6IaFMWLigi0DwPn06gdBf+dmWxgDpw
5T4c8/WGep+y9APcbDEfemwRR7qR73O93hGS1JbdKhtmfW0NctJRX5Ss2r4Rju0m
eAxK/ZzDLo15E8LUndHYLqYp9XCKtmeLrHEg9yu6ZP9h/h93c98=
=QM5M
-----END PGP SIGNATURE-----

--2Y3IsaPFIoarmMDg6dRt1ldJ9bE5svX9u--
