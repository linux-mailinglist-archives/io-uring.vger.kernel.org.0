Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28B1144A38
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 04:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgAVDMM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 22:12:12 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53381 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgAVDMM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 22:12:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id m24so5285545wmc.3;
        Tue, 21 Jan 2020 19:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=1BVzpWHJzPeOvi4CZ1Q3Hz4I3KovNebvVdfsMJTDsfU=;
        b=SIkXC4tKpbEJ3PzQ+OcB9TVuS3WRNt+JqXTKzFmxBiackrEKYZdgCn+S3do1qDVPKy
         XRFbnEGYkJWGDniD8LtDhTu0lw+1hFJG3D25noF+1PfEVPIhB/V1hee2wjZaqYSRLAgV
         2XCr3UcxV0wQLyg4hxYBaX02F7DAJYPm4lpdqiHhx/E9qy4yuKXsDkVn9yjzjb4iTmfo
         futapoJSyD3lbQaO2w580/ck9vktD39qgogT/xmFlAywWEqFCnyxZ16yn5ky7Tkl51lL
         BdFEftfxIlMaLzlg1V+Lr+OienYW4kJPuKKTUB0Ek98Lu3QnfHXtUlB387cOXKK3n0oO
         9e5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=1BVzpWHJzPeOvi4CZ1Q3Hz4I3KovNebvVdfsMJTDsfU=;
        b=uD837xjeHu5r2I7v8D3ROPrCAJJ9JnYmk5ReBBMkJtWH3mhiNber5laO3Y1WFjdm8v
         zxe3jLZpVWOnqWHJWxi368ewzyJwEOjEUJf+Nn9nPL5a6jjy3yzMqdArkrKVQSi/blw8
         JiGlrFM7j5DCGJU3d7RRhCaSxYAVpVswKwZ2NQksNA+0ZCuAASxFJiKOmIE3cEf3epfT
         ARVa2lAF1GXTNq0F83OmTi1lQNG9Ci1gPAexaDyTxaBLeScd+OhZ37FTMXPEBfMHdF9O
         40h52n/Ng+GJbcb0JPHgX3NDci2K2qH7cWAYcoizveHBpsFA9jmvNK8ScMkN1eq/zMP7
         0S8A==
X-Gm-Message-State: APjAAAXlMEDhH6nTCD9EBb628itTL76ejvLHLQwRWhlQ+Wq+lk/JrhLv
        JkWDfZgQI7HneAheB7tCHm0=
X-Google-Smtp-Source: APXvYqzvtuXRbVIzXqwp5PVuu7Gnq4U2PWJPmUC3aH5OtxRp1XV+niaX4ENSfTT2mSX8MuKFGd4Nlg==
X-Received: by 2002:a1c:1d02:: with SMTP id d2mr264695wmd.185.1579662728737;
        Tue, 21 Jan 2020 19:12:08 -0800 (PST)
Received: from [192.168.43.234] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id q3sm56270381wrn.33.2020.01.21.19.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:12:08 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
References: <cover.1579649589.git.asml.silence@gmail.com>
 <63119dd6-7668-a7bc-ea24-1db4909762bb@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [POC RFC 0/3] splice(2) support for io_uring
Message-ID: <45f0b63b-e3e7-ba71-d037-9af1db7bbd98@gmail.com>
Date:   Wed, 22 Jan 2020 06:11:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <63119dd6-7668-a7bc-ea24-1db4909762bb@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ir6uQ8kmMcOcEUhuO6HLX6yuWsMNYgzNE"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ir6uQ8kmMcOcEUhuO6HLX6yuWsMNYgzNE
Content-Type: multipart/mixed; boundary="x0tm5hLtcuaId6zzrES9YU9sroBKl5WwS";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Message-ID: <45f0b63b-e3e7-ba71-d037-9af1db7bbd98@gmail.com>
Subject: Re: [POC RFC 0/3] splice(2) support for io_uring
References: <cover.1579649589.git.asml.silence@gmail.com>
 <63119dd6-7668-a7bc-ea24-1db4909762bb@kernel.dk>
In-Reply-To: <63119dd6-7668-a7bc-ea24-1db4909762bb@kernel.dk>

--x0tm5hLtcuaId6zzrES9YU9sroBKl5WwS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/01/2020 04:55, Jens Axboe wrote:
> On 1/21/20 5:05 PM, Pavel Begunkov wrote:
>> It works well for basic cases, but there is still work to be done. E.g=
=2E
>> it misses @hash_reg_file checks for the second (output) file. Anyway,
>> there are some questions I want to discuss:
>>
>> - why sqe->len is __u32? Splice uses size_t, and I think it's better
>> to have something wider (e.g. u64) for fututre use. That's the story
>> behind added sqe->splice_len.
>=20
> IO operations in Linux generally are INT_MAX, so the u32 is plenty big.=

> That's why I chose it. For this specifically, if you look at splice:
>=20
> 	if (unlikely(len > MAX_RW_COUNT))
> 		len =3D MAX_RW_COUNT;
>=20
> so anything larger is truncated anyway.

Yeah, I saw this one, but that was rather an argument for the future. It'=
s
pretty easy to transfer more than 4GB with sg list, but that would be the=
 case
for splice.

>=20
>> - it requires 2 fds, and it's painful. Currently file managing is done=

>> by common path (e.g. io_req_set_file(), __io_req_aux_free()). I'm
>> thinking to make each opcode function handle file grabbing/putting
>> themself with some helpers, as it's done in the patch for splice's
>> out-file.
>>     1. Opcode handler knows, whether it have/needs a file, and thus
>>        doesn't need extra checks done in common path.
>>     2. It will be more consistent with splice.
>> Objections? Ideas?
>=20
> Sounds reasonable to me, but always easier to judge in patch form :-)
>=20
>> - do we need offset pointers with fallback to file->f_pos? Or is it
>> enough to have offset value. Jens, I remember you added the first
>> option somewhere, could you tell the reasoning?
>=20
> I recently added support for -1/cur position, which splice also uses. S=
o
> you should be fine with that.
>=20

I always have been thinking about it as a legacy from old days, and one o=
f the
problems of posix. It's not hard to count it in the userspace especially =
in C++
or high-level languages, and is just another obstacle for having a perfor=
mant
API. So, I'd rather get rid of it here. But is there any reasons against?=


--=20
Pavel Begunkov


--x0tm5hLtcuaId6zzrES9YU9sroBKl5WwS--

--Ir6uQ8kmMcOcEUhuO6HLX6yuWsMNYgzNE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4nvV8ACgkQWt5b1Glr
+6VkCA//aCNZp/ksciDSAOD11wim450Ov9jYZXPNn6fFmerie3+01DMZUUE2Zqs0
rsS7FDTQbRECrH9TrVzVFikNjOrHR1p8nXaarZHHt27w8OWajke+pHXDpz3WZo3C
rutnN62fK5+P/zYewibsZwSwwXOzZJPwaEXV8ykcUc2IoR2OU+vgVNvggChOChTV
QJ8FmsACeZte8CPXjv4wfcJxUc98r4qwCN7rp8//BdUYwQu9QLvCQlbinTeNhO0/
D1vZEFVpEf0bzCj5jQrYDgL/v69CHMiFKHtvxkhe+jVlTgMrogYALeSbFEWhH64w
OQZY1iZv1hTACSi8DBAzbN25OgYCLvfvMZck4fQTJfdTbwvPuJ/bPpudyHcNyNvi
bpm/Sa08NZWpas6qO5u3jv2hBNBfID7bRBWtXH/5a2v4qcmo/qrQbKVqNasoUTqi
L+ZD5yQfq/y9zfm8DyVTbLZEHR8tBh9252A+4asg/Xt6swofMhHQL0nmhB9IEkAf
yj3PefJJ5HA46qVoPwl3h0rKo/S/mzMqnwIihHluJjihhX6eMjJXx28zhS1puO12
/v59PNCvSgaiPTqUBiE9wPX+DkYmGWYE98g2Ubx5gohaAQKdFAyRVZ+jbpd9qLUv
2LEUfXzwGuFcFZdOi9Fe4V8WpA74tobjrpBHKcS0g/giKylA7A4=
=VszQ
-----END PGP SIGNATURE-----

--Ir6uQ8kmMcOcEUhuO6HLX6yuWsMNYgzNE--
