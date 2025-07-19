Return-Path: <io-uring+bounces-8730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF132B0B0EC
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 18:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7AAA172225
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 16:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305752874ED;
	Sat, 19 Jul 2025 16:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2ft299x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com [209.85.208.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676133FE4;
	Sat, 19 Jul 2025 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752942809; cv=none; b=AtoWFS+/HTZxY61pLTVkxMlTm/awbhrb8scGxp3hGdu2sx2wblAaS1EApnGGnNurLbVQStJ63eO/33YKmBwoCPu/TOtccObkX8gkwCYTt3cltYP8BfAAMlpy5Lo/XeBXK+/xmVfC64pQpL/+0rlJoxLigQx4LigZvfvWJMJeu4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752942809; c=relaxed/simple;
	bh=H69+Qb0RjbhbD3usDIEtZepk26ILf+XJr0yH+gN3IKc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QDPu79z4nllmWGf52Hl52331b0MxxFJLSUdMoWRs0BBMhOEa5wYqMWZgTfZDfhMgQA0w8saOeWOFZn5L3QcKAEmTEvhGtcMKHHhHoN8jjb/pJJPLeJrlWU5dBx5UQVvRMP/eGRp7EmGDQieMK6Z3MhKM/b+lD3NMRBLGYVaFsNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2ft299x; arc=none smtp.client-ip=209.85.208.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f195.google.com with SMTP id 38308e7fff4ca-32ac42bb4e4so27853441fa.0;
        Sat, 19 Jul 2025 09:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752942805; x=1753547605; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:content-language:references:cc:to:from
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eus8JC3eLmukQys43o2t7vBpweYjiLr1zvoFngiCEYU=;
        b=R2ft299x03mmeoKbCfFEqCM3+9AXA5lJeMA6A7EefBw6jiamIDH3dfUsIiUTpl7rzI
         IMaJx2wS8LLRZLTiAtu2bpK+/uwrXO4OeLckZ8uktXe9J7SDQonwYxuVYkdixQ6Z28rX
         ftsUYUXRG5KDYy5hfMW6P+KYw+Y6ihpB+S6axLbvfdC3146f8LCmeij7S0GIUG0lTabs
         frv2ZG1tBijV3IM9Kix80tdZAJQYx4iEzYVNuxGEaVi9+707REEnqKueSHNmR79jtnGt
         e7a9N7uvkY3xoa0y0yVd7uE7Lf3QHyWhDl4eABsGJfKobX2lp/MSJTi1sZ0L2JvRDMA1
         GGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752942805; x=1753547605;
        h=in-reply-to:autocrypt:content-language:references:cc:to:from
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eus8JC3eLmukQys43o2t7vBpweYjiLr1zvoFngiCEYU=;
        b=HxQ1tipr7mH8keD9AWa/ItoqZHKuNoRr+Y565CC61TeqMhb6bQ3Av5ZRQLTx68aUnl
         TW6Jwtp+T1DxZFKAA+tRS/weTai0jaESoiSepseHPr54xc0kmM3zRoYitDTFJBPK0ZYg
         dKg6dpcmi1xpxBsbHTjLgVp2gjQLbCeGJR76Agszf+7VJgblSslA10pFYQoPDWTL0xfK
         sFCO2oW8sP5uCP9WOeF4kDlXJF914K+gyQpkUZMaif8YF9hepmyKMeUQmzhnJmQ51b7M
         2Ly+p6U/Nc8zAYZ2SV1W657Jkq/ekQAUFaEzhtKpapwZSaEA6P7VrGAiyg6RMT4vw2l8
         1VkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkGkWlMmkTUUXsgnmBrPl5pQ0cqPRdVFchl7J0xcxKbyyguFr4PpWL3R2dsnUgFeEaIpya53VjOQ==@vger.kernel.org, AJvYcCX7O5An9m+gpfxBuCLxxy7gGl/czo07V6gWJLOsGJaxWRYEMhd3Xt+0hnLF4VOGTRiMUD6OU6PueOChGcRp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+FavaVYoMb/GXeWCEQZfO5Mmcqn8ECcye0UEITM8FAvGIM0gF
	JxZSB6pt5oyctanN4h3ntecOG/LAjfNHw7XJn72UEf/ECqcsicb3p/dDpiliutX1DwEm35it
X-Gm-Gg: ASbGncu/N01A7c+VbscBRO55bKhFuc8zxjlFBLb6FywdHo7KxZvC/fsvbNiIvrrl3iJ
	U9LsAIKIs09qauCnBeyBgbe467Z2F4Levlu2wuHcyAZTqot7KWvoFGdkXM82KJgZlEBaCcYhxQw
	75HVkF/IqX5wDWIf29HwElRamZKs2uDGaIuwkfrkdK1CEF96M15Aq8MQ2jVl6/B3I33YlEB6zjF
	EWyiiQKzj6oqbL8gyBfxfdIJ3urUbahhv6ns93vfyLDipJF+4iAxTTnXJgMdSPisjdy+BxNf7Zr
	z0lP5UHNRRc4U3vUEylVHorhaYOTiVpTza18Ym7el5Y59o8lTlugYMEcd8Kvxj0sqqSjk5gMEoy
	H2ZDfUyaapJgLqu4SiftFi7+p7QzGXZrYskGI5Dt6PO/wM4SFeqfWn/QUoXKo7YtcvRgDyqnPAJ
	8sMkBGoZEU9FfCAg==
X-Google-Smtp-Source: AGHT+IFhRTZScwyncdRgLSz7mKqGmOsIOdaP+bqge111lth8nSCfjWGoskCguXa4CBcZUOeFcZmD2g==
X-Received: by 2002:a05:6512:6c5:b0:554:f76a:bac2 with SMTP id 2adb3069b0e04-55a23f1efacmr4288779e87.17.1752942805115;
        Sat, 19 Jul 2025 09:33:25 -0700 (PDT)
Received: from [192.168.0.122] (broadband-5-228-80-49.ip.moscow.rt.ru. [5.228.80.49])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55a31aacb2csm770225e87.64.2025.07.19.09.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jul 2025 09:33:24 -0700 (PDT)
Message-ID: <811cdd7f-6ab9-4ff4-9017-5162565fb1d7@gmail.com>
Date: Sat, 19 Jul 2025 19:33:23 +0300
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
From: Nikita Krasnov <nikita.nikita.krasnov@gmail.com>
To: Sidong Yang <sidong.yang@furiosa.ai>, Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <43e162e8-aa22-40d0-93cb-4a83e7995877@gmail.com>
Content-Language: en-US, ru
Autocrypt: addr=nikita.nikita.krasnov@gmail.com; keydata=
 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
 sXwISql2dLWvF4EeopUcuqEmcKFKXR+Ifbxj7A==
In-Reply-To: <43e162e8-aa22-40d0-93cb-4a83e7995877@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------5By74vaeqFHeqgYqOBCC1fCc"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------5By74vaeqFHeqgYqOBCC1fCc
Content-Type: multipart/mixed; boundary="------------tRpyyLBGeWNGMHsvQ4EnCaNL";
 protected-headers="v1"
From: Nikita Krasnov <nikita.nikita.krasnov@gmail.com>
To: Sidong Yang <sidong.yang@furiosa.ai>, Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Message-ID: <811cdd7f-6ab9-4ff4-9017-5162565fb1d7@gmail.com>
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <43e162e8-aa22-40d0-93cb-4a83e7995877@gmail.com>
In-Reply-To: <43e162e8-aa22-40d0-93cb-4a83e7995877@gmail.com>

--------------tRpyyLBGeWNGMHsvQ4EnCaNL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 06:00:18PM +0300 Nikita Krasnov wrote:
> On Sat, Jul 19, 2025 at 05:33:54PM +0300 Sidong Yang wrote:
>> This patch series implemens an abstraction for io-uring sqe and cmd an=
d
>> adds uring_cmd callback for miscdevice. Also there is an example that =
use
>> uring_cmd in rust-miscdevice sample.
>>=20
>> Sidong Yang (4):
>>   rust: bindings: add io_uring headers in bindings_helper.h
>>   rust: io_uring: introduce rust abstraction for io-uring cmd
>>   rust: miscdevice: add uring_cmd() for MiscDevice trait
>>   samples: rust: rust_misc_device: add uring_cmd example
>>=20
>>  rust/bindings/bindings_helper.h  |   2 +
>>  rust/kernel/io_uring.rs          | 114 ++++++++++++++++++++++++++++++=
+
>>  rust/kernel/lib.rs               |   1 +
>>  rust/kernel/miscdevice.rs        |  34 +++++++++
>>  samples/rust/rust_misc_device.rs |  30 ++++++++
>>  5 files changed, 181 insertions(+)
>>  create mode 100644 rust/kernel/io_uring.rs
>>=20
>=20
> Is it just me or did the [PATCH 2/4] get lost? I only see=20
> [RFC PATCH 0/4], [PATCH 1/4], [PATCH 3/4] and [PATCH 4/4].

Never mind, there it is. Sorry for noise.

--=20
Nikita Krasnov

--------------tRpyyLBGeWNGMHsvQ4EnCaNL--

--------------5By74vaeqFHeqgYqOBCC1fCc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEpkOhtFujpzRWyb0a4A5zBMF+d4YFAmh7yNMFAwAAAAAACgkQ4A5zBMF+d4a2
yhAAnvXAMfqGUrly+ircAGDN8e+TE2mfNbub+z1X1tk3CQybqUZOvhouH7/8LiLtPVAhqXjoamp6
wgv2B9ECo2Yd2ftbRyhpBLq5POAgw8X1pagPt0ChFyOLC94NEN8AiT0EmsHbSBMBMERSfrgDYgVr
W/JzT5qLquei1fVBrNB5qLKGXpn1AE1YvC6b55FTXlm6Ki5IBiCCiDJCKJ1x85BwAraC/ebNWi8L
HQE4YX/POejp12RaKsk7u9JCuXAQVnTiITnzrVurWgug8v/O0foiMz0YJuKHPygcKvpll6av1mka
1nz/aCuAIrQ45MmutaMDgrW/d6jUXNy/uLnpd7fnqKfYT98ZdLt3/YL584SuWLf/UIDnsrugBFXs
ALaKdZkALtwWgj8tZ5s1ZoGYRjrvDakvD4QH7XfQJ4xDSEIpvOUVYJwa0SyZrksXJkDUtOIvrACM
sDTEazyZz/XaQ4rM2iQcIjfs6pHTFRQWI5K2ydzSXSrVdfxxRVNLdBeQvJ+B0JHiPUMLQ0QSVX0A
vxWGaoc+pjnrjhBH0ZIx5ViTbOMUlZbJz4ynIqij/sx1+uG44R/5ZTfn4RUIFUWmEg0q+AbyxdQ7
7zilz+tVTynw7Duz8VEz0bKzP5q8JbVkubcqtkFxnqwFxl7VkycCgxdPMKQ4B5sGm1jYrIT9oOsa
OKU=
=QEOo
-----END PGP SIGNATURE-----

--------------5By74vaeqFHeqgYqOBCC1fCc--

