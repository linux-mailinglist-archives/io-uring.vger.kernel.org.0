Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74159156BE0
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgBIRyA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:54:00 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:37187 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbgBIRyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:54:00 -0500
Received: by mail-ed1-f45.google.com with SMTP id cy15so5983216edb.4
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=xl4dm8ZfjMprt0bSA25UxTZiV4P5FcGuUHuCYSbVL2g=;
        b=f5DaPtYZwdHG+B0SJRhlAHmyPX0qK7Eb2B1Ngq8FXUhCJUBoOZQxrHOlhkZOt4NcL7
         hmRNqzE/qK7RRWpPezO5ANU34fGceToKqrJLSi6mLOt8GRG+f5FtL/AUYF3anvAEuagB
         LOUWx4Hy5AP3U6VfdmN3JhiWf7Iw3/HTFXvZYuQR6XdVdrvpb8HbYUxypzp7sgP7YP+r
         sCx2C+QyBGwbWWDzXDNBncA3sYLDkUv5IY1RD2XzKNvqMIbEnXHGjPI9hQpIbkiZPgcH
         ujlaQGWA+DAjYHqm3LcubeHD0RZKQ5mBGsLmlDyx6Cf3IzigU1xPL/VK8S10Zvi02UwK
         MaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=xl4dm8ZfjMprt0bSA25UxTZiV4P5FcGuUHuCYSbVL2g=;
        b=d5jWvAe1CNEMvhvWNjfWSS8cRWJU6GfFN8ymllAGivBGGmNswbhP4bj7upBBRqwyiK
         ouYazSCxasoODPotvpc301fGmpcDn2kEAovUKSZD7BBd40S7t9z511gPVgJfmtI4G4Bi
         MqY8K+1EobV1xhX8pxo30p3b+0cLjWvYDwFuxrzkIPtjtPUaJ/EHJPV/vH2Jq0/dWqg8
         cHwQi8b1pFn9xv6ELjYnSNnoUz1RZ3wPjbptSvZBXwNu4zHSZ2W+FZY6uQb8JA0siSWV
         euxJOya0Hl8djV0qXdZZJyTCqzPvWAwTgANy2Q7SWAw/eXDXthcwyoVDEOKRAlwn06TC
         Ndrw==
X-Gm-Message-State: APjAAAUCq5j8wLe+EAq++pAAZbPNsKmw5/abS2QMOkhc4pO2WwoWxJQs
        6xL6BiH7gwv9MuP9/LZlV/DaDqHo
X-Google-Smtp-Source: APXvYqxI4OQA1eQiA+twDhj8ySd7Eu3nhTqirfkP6yQJ7dAysphcpgl6kepbCIWRZS81LSWEWlBj1Q==
X-Received: by 2002:a17:906:49c4:: with SMTP id w4mr8243324ejv.158.1581270836748;
        Sun, 09 Feb 2020 09:53:56 -0800 (PST)
Received: from [192.168.43.63] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id cf5sm1385148ejb.60.2020.02.09.09.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 09:53:56 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ace72a3f-0c25-5d53-9756-32bbdc77c844@gmail.com>
 <ea5059d0-a825-e6e7-ca06-c4cc43a38cf4@kernel.dk>
 <8ac7e520-c94e-22e1-3518-db8432debb6b@gmail.com>
 <f4956223-0aa0-5157-6964-28e934595d20@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] fixed files
Message-ID: <4b898e0a-f178-a3ab-b6a1-efb43e27db52@gmail.com>
Date:   Sun, 9 Feb 2020 20:53:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f4956223-0aa0-5157-6964-28e934595d20@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bFO9PIXkG4sufcpyozwAoRmER3uxix6PS"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bFO9PIXkG4sufcpyozwAoRmER3uxix6PS
Content-Type: multipart/mixed; boundary="U8vxAav3OPFFm48tidYpdEgdG5qXqK1lk";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <4b898e0a-f178-a3ab-b6a1-efb43e27db52@gmail.com>
Subject: Re: [RFC] fixed files
References: <ace72a3f-0c25-5d53-9756-32bbdc77c844@gmail.com>
 <ea5059d0-a825-e6e7-ca06-c4cc43a38cf4@kernel.dk>
 <8ac7e520-c94e-22e1-3518-db8432debb6b@gmail.com>
 <f4956223-0aa0-5157-6964-28e934595d20@kernel.dk>
In-Reply-To: <f4956223-0aa0-5157-6964-28e934595d20@kernel.dk>

--U8vxAav3OPFFm48tidYpdEgdG5qXqK1lk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 09/02/2020 20:04, Jens Axboe wrote:
> On 2/9/20 5:18 AM, Pavel Begunkov wrote:
>> On 2/8/2020 11:15 PM, Jens Axboe wrote:
>>> On 2/8/20 6:28 AM, Pavel Begunkov wrote:
>>>> Hi,
>>>>
>>>> As you remember, splice(2) needs two fds, and it's a bit of a pain
>>>> finding a place for the second REQ_F_FIXED_FILE flag. So, I was
>>>> thinking, can we use the last (i.e. sign) bit to mark an fd as fixed=
? A
>>>> lot of userspace programs consider any negative result of open() as =
an
>>>> error, so it's more or less safe to reuse it.
>>>>
>>>> e.g.
>>>> fill_sqe(fd) // is not fixed
>>>> fill_sqe(buf_idx | LAST_BIT) // fixed file
>>>
>>> Right now we only support 1024 fixed buffers anyway, so we do have so=
me
>>> space there. If we steal a bit, it'll still allow us to expand to 32K=
 of
>>> fixed buffers in the future.
>>>
>>> It's a bit iffy, but like you, I don't immediately see a better way t=
o
>>> do this that doesn't include stealing an IOSQE bit or adding a specia=
l
>>> splice flag for it. Might still prefer the latter, to be honest...
>>
>> "fixed" is clearly a per-{fd,buffer} attribute. If I'd now design it
>> from the scratch, I would store fixed-resource index in the same field=

>> as fds and addr (but not separate @buf_index), and have per-resource
>> switch-flag somewhere. And then I see 2 convenient ways:
>>
>> 1. encode the fixed bit into addr and fd, as supposed above.
>>
>> 2. Add N generic IOSQE_FIXED bits (i.e. IOSQE_FIXED_RESOURSE{1,2,...})=
,
>> which correspond to resources (fd, buffer, etc) in order of occurrence=

>> in an sqe. I wouldn't expect having more than 3-4 flags.
>>
>> And then IORING_OP_{READ,WRITE}_FIXED would have been the same opcode =
as
>> the corresponding non-fixed version. But backward-compatibility is a p=
ain.
>=20
> It's always much easier looking back, hindsight is much clearer. I'd al=
so
> expand the sqe flags bits to 16 at least, but oh well.

Totally agree. And I didn't meant I could have done better

BTW, we can extend sqe flags into free bits at the end of sqe, would need=
 a bit
of packing/unpacking though.
e.g. int flags =3D sqe1_flags | (sqe2_flags << 8)

> I do think that for this particular case we add a SPLICE_F_FD1_FIXED an=
d
> ditto for fd2, and just have the direct splice/vmsplice syscalls reject=

> them as invalid. Both splice and vmsplice -EINVAL for unknown flags,
> which makes this possible.

Yes, I remember that from the splice thread.

> That seems cleaner to me than trying to shoe-horn this information into=

> the sqe itself, and it can easily be done as a prep patch to adding
> splice support.
>=20

--=20
Pavel Begunkov


--U8vxAav3OPFFm48tidYpdEgdG5qXqK1lk--

--bFO9PIXkG4sufcpyozwAoRmER3uxix6PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5ARw0ACgkQWt5b1Glr
+6ViIw//cPRxa4bXfENan13w3LM32HRsmValywsG0RZC29DveE1mtr5Kkynvd59B
h/lmrhajrv1GQsi32XjQcAsYXobw2hABWZoVH4QRjPPqxcNqZGljPCFukW1gsmoX
M0ZNrEgZDmrU1GiZ2Bf85toERvPL0j3jdlZGdNXBo/zcIXj3+rD6i9xmoF4eM/r2
J4qoahZN1pGOtW3jO6iJt2hHTbeFZEyvaj2qNu6vYpx834MEtUsc5czu8lA3bAxS
rcSfI+mAC0MPrmgB+iQDZ/bJOuUy8aTmMhJs1ngMXC1NQhnn1DZKJe84yA5zO/fR
d1gQg6YvU9qVJZ0+d6VC2cv+qRIzjd4n+n9smYpHvNVFoOzjS/Or/oyYMDlvObWF
JbMQPGjEuSbMvIAW70jbo6qD+ORijpPke0sfyWNHdwbT5GZEsFwLhEGwkp8jfoQn
iIGJS4zOIMgVxJ9jQS3HDC5BqX08vY0Ag/pq9kRZs1Cf7gRACpBAoBna/gbMES7G
Ffwd63JzA+KY73DMiAMNL70D7sWggQ0DvpecsjrUTFSxHKH8KLiQJFMiAQwJ7X0Z
nOExw8cWM55WR1V2NExOVHqcU3mwhz7Tk72ydt3PlFamOIynyiBRh6F7+AvBIklp
8CoafWhFtU6IHXTa9wM4/YRxSU92BcLOSH2jnLYO/GHcq1p+JRw=
=wRtw
-----END PGP SIGNATURE-----

--bFO9PIXkG4sufcpyozwAoRmER3uxix6PS--
