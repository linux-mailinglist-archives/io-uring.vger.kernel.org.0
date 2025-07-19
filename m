Return-Path: <io-uring+bounces-8729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB1DB0B08E
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 17:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D3C25674CD
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 15:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CF91A8F97;
	Sat, 19 Jul 2025 15:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fu0Fx07c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f68.google.com (mail-lf1-f68.google.com [209.85.167.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B232AE7F;
	Sat, 19 Jul 2025 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752937223; cv=none; b=TS57jcoa39hT/efM4Ke+oy/0TMT3E+O3OFjtofGIRgsKe/uqZV/wdi5VxwyekZy4eRIi/DdkpWjms+djq8poL5esWlrb4aWe5TsKlfWdeSms621V2l3sgADX8i9rN59GxroUn8PvRuXMGFVILWe2LiKbGB2M8upOve+JEogaKNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752937223; c=relaxed/simple;
	bh=fi13vCqJEGd137tgEmMNHiaDda2oZede3aS/KHWlgI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=INB0fjsPpSHQY3WitpQl8xwu6xMiMb4ovN1OjHoDXke1i4t4f+N3IdaiQ6BYLIY4au7/pVOOguZsUnsKYmEamK7GiyvkZTRFL/+lMuQe+zBmxk74CZgcjgg44WcXO3iq8Gabj4JIeCXBcYEtoFlYNd+2rAkPxjt/gy/xZzTIPcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fu0Fx07c; arc=none smtp.client-ip=209.85.167.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f68.google.com with SMTP id 2adb3069b0e04-5550dca1241so2695035e87.0;
        Sat, 19 Jul 2025 08:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752937220; x=1753542020; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OTmoQbpjm8KqAhEFENOq9qOlhu9S1c9X+cCKPZNoork=;
        b=Fu0Fx07c+WC2UkYMDLrLZe5tOOlf1AdgQAwCrU627R7eBcigIPCS6K8l2hk2h/IusH
         q8wcLaGyI0xrfQXXor8+g1X1hlL42nLqcvrIq0LXBRz+eRdNQq5ObYYZZRXyhKiRb1/h
         byT0yjOLLz0pZfn8A8RhrIN+y+3dSGPtsQFSaNZ/exrXGrtKSxZI7NEiyyFV6V3UcKwF
         KvHNkLkUE+5kr1ZqkWiX1F+bqfMEKj1V/mRWEcEjENZqJzNBM5ZIGRHIEfHeEJ8fRduq
         9nU9aUihm1eaToC2kqVlSlVqdKoEvMP4lpMb7oseMX1Xqgfg1Z5zO9uXl1Fbs1MT6Z7d
         m5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752937220; x=1753542020;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OTmoQbpjm8KqAhEFENOq9qOlhu9S1c9X+cCKPZNoork=;
        b=IPbM59Qbt09iWHN/7561CfCKJdkfK5Zx5DsVINUthxw4DfOcblhlwXe/joIEbCZg5k
         t1zDEYpnwzFRWFIN2F22Oj1OcB1/BU7+jwIb0K0xWMCKqn/fF/MOMgEf7SI6b5FgxtQG
         HXH6um8dsjWnOo2ZMUuuIMZKCeqofdFV+l5kVoqrcsYrbPx9B2i0XZ0G9q2kXEuab8sQ
         x/CDMru2QYCr78RpC3Y5RVnbNqM7sQ2m3v87HbQfEnAIVnuURqhOfP0/KdRkM19Rk0TW
         tmZugHgt07exjKdyl8954oyhth6l+uJBg7OZh3tWoSOHYzbDWYLvdzwYa7fjz9O6x3q5
         h+cg==
X-Forwarded-Encrypted: i=1; AJvYcCVP5Mj516uFCJSuNSUDckdRwCyI8RqrNYY98k/4miZNd4Gvqm5GXyT1NNF8mrXqI9S6bxVUA3ytkTAbtuJe@vger.kernel.org, AJvYcCVqhMZB/JwysC3lI0TJgVqv1FHMwlawK14pHrFdas66XF9ILA/0c7Uk2RbstLgD8y12H6/vow2vdw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzXaRRcobm5H60VBfHu3bLqIQbAs9J/IUhPbZaVnBVuI0dZzVi
	CBta58sDXOjM9Vkg9zi5ktRMr+3KHmNNnsd/XdENG4Uhnxvv2lcX/2Pk5X1y5OACLp/koDU4
X-Gm-Gg: ASbGncurNZ6/Zkhq4kKd3BnP6eY9HuT/PGIfLjsORZDucLos+BN19yX7oLdbMv7F3hE
	4UiO9M73M2xpOr/FUBHcwSCYxcUlyZk7CzG9IJ+KRtOECU0CFCK0RorsKhiEhRZPWJ59PU6Jzln
	rrfvIpP6oUT8hUf+Hek7w+BX825SsffZJCqjQHG15RulCymDy9EiPtWI9IOHrCwzN7hOh2nnWSg
	CSuUAwL+LohyDFccIUtlmOI6yaZzYn/S+Yc/ARbwO02DuT3ssp19QfQG6+nXett/yeCXzRyiHo8
	cHj6i+bq0s6n8UFOl8HbqS50OJN/TEKZp4kEwPWIqxYjXRMSeKMsXC4281HdmjJVFkuBKVLji1u
	XjxKwJrXjMudRC225VhHpj94UFhcXANa+ta8OdJ04bdLqw/X5iV9MRx/RncxwjliViohoOAae0u
	c85d0=
X-Google-Smtp-Source: AGHT+IFjiYtW6BUQkvjPZxuXS0Om3ywQ0wpR3E7fNdCJf/ZDKnDiF4HHCCtnJnFsF93hJbKIceGOkQ==
X-Received: by 2002:a05:6512:39c7:b0:553:2868:635e with SMTP id 2adb3069b0e04-55a23f03c38mr3699636e87.23.1752937219411;
        Sat, 19 Jul 2025 08:00:19 -0700 (PDT)
Received: from [192.168.0.122] (broadband-5-228-80-49.ip.moscow.rt.ru. [5.228.80.49])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55a31da58bcsm745119e87.197.2025.07.19.08.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jul 2025 08:00:18 -0700 (PDT)
Message-ID: <43e162e8-aa22-40d0-93cb-4a83e7995877@gmail.com>
Date: Sat, 19 Jul 2025 18:00:18 +0300
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
To: Sidong Yang <sidong.yang@furiosa.ai>, Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
Content-Language: en-US, ru
From: Nikita Krasnov <nikita.nikita.krasnov@gmail.com>
Autocrypt: addr=nikita.nikita.krasnov@gmail.com; keydata=
 xsDNBGf4964BDADGr5n+p1Sr7slmHHMPvp2/dLz0H0qkw1EcdWyX0EP3wlmBcWL5LVYjxO6O
 m/32hF2WeIYHYU9KZYfhraKCNicilz6HZQV31/ALNahNA5XuZYW9TXvdBpMfqYP8SpHOJZ3B
 oAMBCt1wi9gv+zVDgOPBkPeY5SbwhnvbAiXjI/gQ5XsTH8Pp9PCQxXz9DZclCr/i7lzSUIBX
 bdISZXXZPeS1E6qp/cM8Wanv+gE3fS5t5gq0EgNS4pUDaw0VOdl9YsqL4KLD1ItMZh9v58bk
 9sfUNEB9Brbxp4NuL2FVKabqVgdmuNnivaU3FrQ2GFQ4gVNJuaBu6G+2wKUwSI8MVK5pl4Py
 XPFXFhluQnsS2NsjFV4kAIhwpcYzBugBsslL7ivQd873pjmBmGlp73NT8zGpMd8NjmFghC9y
 UXlZn9veJBGnSBp/3J0bOWREB7uPSebO0cMVxFUBN+V48XL9LwSOG1yl4DNPWlA6KLuS9naE
 +9AIo8nO0FnzF9wClWJY2fUAEQEAAc0wTmlraXRhIEtyYXNub3YgPG5pa2l0YS5uaWtpdGEu
 a3Jhc25vdkBnbWFpbC5jb20+wsEOBBMBCgA4FiEEBJPdYgH3VqDBfY4FlxlNs6THfzEFAmf4
 964CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQlxlNs6THfzFkswv/SoHGPp8hEKTa
 OnBMQb7UVHMSpuZShOo8axS2b80R0ZbVq7YDB3kSXTVc1IQQAstTrIN6/Bx4yubFrtXl1rvl
 9pEg7BkiABkc0zY1OWN+K8qDkBBMSAx1ICmXkFvfSEYbH3kJqwyhQxJE8fvUL6V/0adU4cDB
 EL1BB9FQ4yA8JCekepRA9TNbeCpyRikOF9AtaiiH452WNHmumJQNsHOerDEhxMrQ4wovClDv
 ae+s5tjsBv91r6fB3x2Fg0Q3iLpWMO4trexaK1eqj9Q3JonDcRPxM55Fpi9VmnA6yI3FOSkG
 v3FxKMfakz3VBK4sO+YvqJ8abacGnDqjeQAwfOp6XF52o4CkOaiNhfiPf180xza2D/fx3tEX
 q9E7cvmycfpNyD+yxTSovsRr0LP8J1lpH5EY3ItYTvJpxo5CWN5pJ3RT1gf2gt8IHRIeLmDb
 uJ3hP3XavkATqCvm9HY2yTVpDNWE52EikI/eRPFounq0uBr2Sr9jgRQAdUHS4pFO61FGzsDN
 BGf4964BDADNEi4JnZfOWq6egCtMDIuUUXbCxo2Yk1myK/RSr88yAlKO+g9abvt1rp3iR/mK
 fTtfnBcqoN7S/WVSZqJQhdlg9JzH++xFx3RVHawe/tLZRYvdFgQXUbO+cfBzBcI4CB2UTNpA
 YVtQDDFZN9G83+G0ANYjBdVHIgGflJfSofc39pvtwNtEmjXcpOjbwCQiWNKsB9etlz0zVMaD
 ZhxTXOctUu6QBlQO2tuhlGKm9Czb3nxSh5tJmc4+pmv4EKRqJPVETcvEtbTTdr+xWBJss9Fo
 z2nc/+a+muLoBFA07RtfWnvRpP9jy5JrruZ6qsuZw2+nFigbB+1q2Fv/lFEWYVd8lJAGGvUx
 aqB5AKyQb8aokQZtnlgvSUtV7c54nlPvUpekPXTH7joUAsYgtH0ypc3G+bCOiF66zzlwzeyF
 BG1H634mKewODmgchl2nO+M4nza0WWdpHFN23mqcOz0baOsuUu5/bBXwhiZgopRKf8GPKeBq
 iy6qCualwWVnVDN6B3sAEQEAAcLA9gQYAQoAIBYhBAST3WIB91agwX2OBZcZTbOkx38xBQJn
 +PeuAhsMAAoJEJcZTbOkx38x+jwMALZM+6Mt9k+6Zz17moqJFy2X7lYFN65DJ4K2Bax6l+CQ
 hc1ZyJyuBDqZZumfY3uiIrwUBhYVUQzSGHjBKs/IqOkad7fqq+76YE8bI/KNkEJOtsy77G+J
 LempwVk7vOw1U2p6Eh6j/5AzyMsPsiT0XEHtfO0Vvivc1jSODtkU+ZqoNEMddAUhDUcACsA5
 iDsJ8WjCbY/Qy+5BFu+JAdIutf17CKQiUAcAABYqbuIuYg1QkCJYAv3kQV90qx+h+9o64ULl
 TtuWnCp43ub6V583oFhL9MrmOkixJNpTU50QjabvhT3663DSYTlcWJKFt/Yd4eScqdvQXE/B
 lrxXFC/a8iQWvTxGBEPBzaSxx8+sybTS5uzrafFidLI0J1WwraAuhxi3BDIdqFBn0T+GtWNw
 4i4kR6ebfAnsAucg3zT3mGc8d3bDrqEFDQHnzQE14t44tLim6PjGq7S0B0lwT3JaF4sT1k1d
 sXwISql2dLWvF4EeopUcuqEmcKFKXR+Ifbxj7A==
In-Reply-To: <20250719143358.22363-1-sidong.yang@furiosa.ai>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------XdbBg46w0jl7w0rF9ILsV4fh"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------XdbBg46w0jl7w0rF9ILsV4fh
Content-Type: multipart/mixed; boundary="------------zNyjZw7WoN7lR0SVHmhLHTXt";
 protected-headers="v1"
From: Nikita Krasnov <nikita.nikita.krasnov@gmail.com>
To: Sidong Yang <sidong.yang@furiosa.ai>, Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Message-ID: <43e162e8-aa22-40d0-93cb-4a83e7995877@gmail.com>
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
In-Reply-To: <20250719143358.22363-1-sidong.yang@furiosa.ai>

--------------zNyjZw7WoN7lR0SVHmhLHTXt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 05:33:54PM +0300 Sidong Yang wrote:
> This patch series implemens an abstraction for io-uring sqe and cmd and=

> adds uring_cmd callback for miscdevice. Also there is an example that u=
se
> uring_cmd in rust-miscdevice sample.
>=20
> Sidong Yang (4):
>   rust: bindings: add io_uring headers in bindings_helper.h
>   rust: io_uring: introduce rust abstraction for io-uring cmd
>   rust: miscdevice: add uring_cmd() for MiscDevice trait
>   samples: rust: rust_misc_device: add uring_cmd example
>=20
>  rust/bindings/bindings_helper.h  |   2 +
>  rust/kernel/io_uring.rs          | 114 +++++++++++++++++++++++++++++++=

>  rust/kernel/lib.rs               |   1 +
>  rust/kernel/miscdevice.rs        |  34 +++++++++
>  samples/rust/rust_misc_device.rs |  30 ++++++++
>  5 files changed, 181 insertions(+)
>  create mode 100644 rust/kernel/io_uring.rs
>=20

Is it just me or did the [PATCH 2/4] get lost? I only see=20
[RFC PATCH 0/4], [PATCH 1/4], [PATCH 3/4] and [PATCH 4/4].

--=20
Nikita Krasnov

--------------zNyjZw7WoN7lR0SVHmhLHTXt--

--------------XdbBg46w0jl7w0rF9ILsV4fh
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEpkOhtFujpzRWyb0a4A5zBMF+d4YFAmh7swIFAwAAAAAACgkQ4A5zBMF+d4ZG
4g//dtsBQ5ABpmCT96JLoZQ4t08xAbTQMvI+FVkNJp2hA4J76Pl0O7acF94UHeK0IVjEGPECAj4l
2WnDDPYY5o6rcZpv7MIpcrUGYVTap8i1idRiSdjl8krFS7yZWFG9NGKQUNEw9jJnrGhM/5AOi5QB
QKP/9zXOQ2fL2xSigPGpoW9TN+7XzPOBVk1kAUgAiILrXeW3WyfGCUP9hyW5dSfmtwC8Xz1aHL/e
Cb1Xja8KGjrG1o3G4IcfLOyrrPVrELN7gzG/J7TX/CLhnwIK7iXeySi+vhZshHSABI4efY6hLsbB
3On45fQRmjBd3cXO0fdoQnxhHdLAXnYzLFOzoDnPWgtlTZP/eYmTVn2xxDTuX/zEcW8CzGBrf5ox
aRGDSUTsdcruGUzeysYAwleEe4IFCL5k6hcfLXnsULkn22g8kBBubn1RDvovb/Ze972S4gDnAd91
21zd4DlFmX9m9o1LBg15mQp0oPKflbmuPI8Xa3dmE2Z5FFoVtbz4/Rblm144mmj+0FaoJJKLPb8J
ZKnYcCGEXfrSmKmNqlH0sqVgWtUX8rb2EcW6izZTHLE/Os1SBK/L4Y97mlPkHfyX61YCzNJcMLLt
xX//UQukamA5rYNSIlkebuHNEGrELuQ2A/PhWe6qNpKoGVxoor/8ogys2TjzuTfNSssxUYvMXS42
pg4=
=rNmn
-----END PGP SIGNATURE-----

--------------XdbBg46w0jl7w0rF9ILsV4fh--

