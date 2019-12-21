Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28EF128A79
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 17:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfLUQtG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 11:49:06 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38349 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfLUQtF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 11:49:05 -0500
Received: by mail-wm1-f66.google.com with SMTP id u2so12197961wmc.3;
        Sat, 21 Dec 2019 08:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=hjMIRLRAM/NMpanWcFOG7qiDu+/VOyuqj9MGQeyaI5A=;
        b=KZEQRUoC1JIQ9NQ9YwawWTz19iFrn2A0XRmTZEP8HukBiqxH1+VjZqlaS+qmAl5hlp
         1qIxN3hc7bsa3muzUaxRYt77/d9ooKzrUTc1xExDBBAcFgOv1+HG2SvgVtPqldFdydWr
         TpX5ftxyQbixWOoXszU92N8e+lHZWOtia0DXu1Rjf1SoDnEptgSE7xa3hFI6SlXr6Oo+
         RXYu6o57/+eZs504UYtHXojk5yr960jJ8b4B/tR1nZak+vCZzH5kH/g/saCcw2IkZwy/
         l4kDiNpHNKlezE/4dWFC3e+O4OONE00flpVYmu1pWnhYxvEtIWEZ0XqmhBmq3Q3eIvBm
         QjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=hjMIRLRAM/NMpanWcFOG7qiDu+/VOyuqj9MGQeyaI5A=;
        b=YsHDXBz3xi2FSR/3mHp02V30ufrTmUT2j1RK1a4dYERh3Ybp0hYD5621mrg3IO0gIM
         F4y5CrSZLiYVFV+uoSldgC/Jf2nRfIRf8JMC+1rZsA4NSIfU3e3SvoQNagVYSRYE7s4V
         L4hR2cc2kyv7RAtCr95Aut199KoUmq3C3jGSIrN5y34/iE6HssSJR9X5+JnMc3Lt2gPT
         sJTCcYgaw4rKAVyGM61LbnDx12NCJyRdEkZ1bKf58s5cQvyp4gby2N+Rv77mHAQ4rmKd
         KQGrR4tsono/QJkRackuUygdnGkEkFVEnQiT7uzMrpYG7hcgA/8vqGj14UYjM8Yw6GpI
         ar8A==
X-Gm-Message-State: APjAAAWtn1qrhE4C49OhoEpPDgCQNnFHdQVm/NoMa3WCUqID6UuPcilq
        CgdaHO9m04AkxOc/K7sQTLk=
X-Google-Smtp-Source: APXvYqxHuQ1jUCfSxaLM9i3sWThNmD2XE/GpDo7Ez8DLbDLuuhACDyRtDjmjrDhLmZ5phYFfgBnsFw==
X-Received: by 2002:a1c:1d8c:: with SMTP id d134mr23559049wmd.16.1576946942455;
        Sat, 21 Dec 2019 08:49:02 -0800 (PST)
Received: from [192.168.43.10] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id m10sm13717615wrx.19.2019.12.21.08.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 08:49:01 -0800 (PST)
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
 <da858877-0801-34c3-4508-dabead959410@gmail.com>
 <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <fef4b765-338b-d3b0-7fd5-5672b92fd3e8@gmail.com>
Date:   Sat, 21 Dec 2019 19:48:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9OMwmuozE4Gp1nHufQBI4FT89goyhidhO"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9OMwmuozE4Gp1nHufQBI4FT89goyhidhO
Content-Type: multipart/mixed; boundary="j85p1FNl4i4XH9zZ9Y2HE9moNGqQYOdrE";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>
Message-ID: <fef4b765-338b-d3b0-7fd5-5672b92fd3e8@gmail.com>
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
 <da858877-0801-34c3-4508-dabead959410@gmail.com>
 <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>
In-Reply-To: <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>

--j85p1FNl4i4XH9zZ9Y2HE9moNGqQYOdrE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 21/12/2019 19:38, Jens Axboe wrote:
> On 12/21/19 9:20 AM, Pavel Begunkov wrote:
>> On 21/12/2019 19:15, Pavel Begunkov wrote:
>>> Double account ctx->refs keeping number of taken refs in ctx. As
>>> io_uring gets per-request ctx->refs during submission, while holding
>>> ctx->uring_lock, this allows in most of the time to bypass
>>> percpu_ref_get*() and its overhead.
>>
>> Jens, could you please benchmark with this one? Especially for offload=
ed QD1
>> case. I haven't got any difference for nops test and don't have a dece=
nt SSD
>> at hands to test it myself. We could drop it, if there is no benefit.
>>
>> This rewrites that @extra_refs from the second one, so I left it for n=
ow.
>=20
> Sure, let me run a peak test, qd1 test, qd1+sqpoll test on
> for-5.6/io_uring, same branch with 1-2, and same branch with 1-3. That
> should give us a good comparison. One core used for all, and we're goin=
g
> to be core speed bound for the performance in all cases on this setup.
> So it'll be a good comparison.
>=20
Great, thanks!

--=20
Pavel Begunkov


--j85p1FNl4i4XH9zZ9Y2HE9moNGqQYOdrE--

--9OMwmuozE4Gp1nHufQBI4FT89goyhidhO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl3+TOMACgkQWt5b1Glr
+6UykRAAsUMaF0VfI2CGF0QW8ySHMJN3je/qs+86s8bZDaCFeMv/2B4oFU2/68QL
BWy8zKYprWMBM44ITcRtytX38G6ZPjBbOzBywM/FbLIuET7WSxfgAQYS0K05Y4jv
Z7fH2SzKJ2kD87RNk+v6B516wNJnjxmyMg6+wX+Gp86EoELBolY+XhRKiYyiXidw
Iy/QufKhf99YAJfJkIHLbZjKWwOykV67sSSOC7+tOzmIyQQtxnVXez6ta/JAleTM
Fi+Wib/P4DLDKBVSj2gBERzhzfb+vEVxJMD0jD/L76TPKZ27qWw4Ejmw4vNa5uv+
PZ874tC8TJZqOSoHtCIlHJ6wKn0m0BfrnyWMFg0GZZdPdHdWyfIyCzPz0O/dVoyX
ZWQQpIr+ftnSkNMkJjQ/eNmCiW8lrkkR2xYdBIM5KDOiM9gEEn5rXAHt+fyoCULd
tPRpHG3gFHdveXDx4iYkSBpBrlAxTpXKn+5g1At/uvjqVBQfpHwfLPFcSAptgK8i
QsTbLjWq63o7H5pplkNJEN/oNEMrkbePXVUKQAjzVF1KIklQw6SfRmhS30Uq9Es4
unlhtGPNL+EcGqIcCdIxdLZxnrTdPQAdMjXtizQffCMADxCT51vnDbEDPlMcU/pP
kh37EtFY7toRZIt7MixcZnBUE7HaKg9etHos/3pG04rmD4csulM=
=IVXG
-----END PGP SIGNATURE-----

--9OMwmuozE4Gp1nHufQBI4FT89goyhidhO--
