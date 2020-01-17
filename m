Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6992A1412AC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 22:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgAQVP1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 16:15:27 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:46312 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQVP1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 16:15:27 -0500
Received: by mail-ed1-f45.google.com with SMTP id m8so23564352edi.13
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 13:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version;
        bh=uOm3im0OSQzZ1RymlypgvRNFuHmxXaWo8nMfWlFAdso=;
        b=V2sLiWAX+7GTOPfErF9wSXWCfkVQ6TbvkuEylli9F+aYd/pYQzMj1gXVDQ3Z5YEFYC
         OvAY+uJVN2p83cbM9irp7ghRu7/TK3AlJmQRDSyp5TvL6TsQU9IqQWpeHHP+JtwaWwzT
         v+DauSj4NNHcYAJYc9P81219hz/F17O1UgZltmDz41l/nneHTjZAQCoOjRfJWaW2HJfB
         YPa9obc3dPxN/2ohqAi4H/lAtUYfbzLlC/KRpTJ4JDMELu+3/vX34w+ErbCfm0FMdNuq
         Pq4IXl9BJpW0GhptoS6osLctdx+vP11P14w3rlTSJNnW0Bxatk3HjswC46DOkLTNKefo
         VMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version;
        bh=uOm3im0OSQzZ1RymlypgvRNFuHmxXaWo8nMfWlFAdso=;
        b=cyjrfBgjm/fOpggpDYtQm3gdxGngMjaMTkb/nd3+UIdd59otn18PD/A5djFPGGp+Ze
         YxCOi97SsfvXz7ggsh8DRU2VoOFtQg6mY4aQZev56H9cfsqA/OzRN8bVO2/ga0troZz6
         5HnBBNt2iYY05gmajZ6Elq7jcd+BPwr9gGFLdKPXYBv54+qmgcy/wNQR7MBV/V70qBu6
         65pTUZOgsnRtSdIfKsW4/ifANKReGIDsEFtZXg0O7KAiAI5hnJkZJd5UUFcI0nVbaq/1
         5aBUN704JWbElD7RRGbOBvatUM0IHlmP034lGL0XA6XwTHoy+nl18b6SSAyd/I0sEFII
         y0fA==
X-Gm-Message-State: APjAAAW4ybvAGtgeOgERX6IACi5arPtGaG6baOgqrDAU5nUvnyX+146N
        8Na7BZ8bg3ArGDB3B+qe/7U851lq
X-Google-Smtp-Source: APXvYqwaNbsqOvFBiCc6uTqxntWiDMfm3BcGWYS39J52V4U555g5RiVv+avp3r1ZrhDXGII6pR6Qhg==
X-Received: by 2002:a17:906:b850:: with SMTP id ga16mr9769504ejb.232.1579295724796;
        Fri, 17 Jan 2020 13:15:24 -0800 (PST)
Received: from [192.168.43.147] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id l26sm999694edq.5.2020.01.17.13.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 13:15:24 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: [RFC] io-uring madvise
Message-ID: <69c3d3e4-8ed2-3925-b109-04318a8f97a7@gmail.com>
Date:   Sat, 18 Jan 2020 00:14:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SlHZZNMhzcMNR76o8VMmyu0lknjL7S3fR"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SlHZZNMhzcMNR76o8VMmyu0lknjL7S3fR
Content-Type: multipart/mixed; boundary="zCgVas3ThmYVouZskXuBJJleGG4bltQmJ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Message-ID: <69c3d3e4-8ed2-3925-b109-04318a8f97a7@gmail.com>
Subject: [RFC] io-uring madvise

--zCgVas3ThmYVouZskXuBJJleGG4bltQmJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

FYI, liburing tests showed the results below for yesterday's for-next ker=
nel,
though it's not reproducible.

Running test ./madvise
Suspicious timings
Test ./madvise failed with ret 1

--=20
Pavel Begunkov


--zCgVas3ThmYVouZskXuBJJleGG4bltQmJ--

--SlHZZNMhzcMNR76o8VMmyu0lknjL7S3fR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4iI8sACgkQWt5b1Glr
+6VJ5A//azl3nWucYSxyPQZErkVNMOGPyGq9O8MBTvXaRcIDIIEmGQxgrPWga2Sw
5LxBkqzcr2syXWNwxrtJ5bPqwaalcb0/BraLBHjGDrJQGZBv8sGH9DLAnDexsIvS
/LB1SAepVZL3lon8pkL7EvZ4Bb++6sjMdD6v0FSfFo9dHLz/19oYibPem9VFsU0Y
2FWElE75h21Rl8tt4tNed0SuDHKxZIHlBgJuK7im2GPuQXHaoPm7vQJcGN8Klo6x
vmQ+qka8BV17FMXFtNTKakmcXw+KzyPAWbRbexpo022AoRQXsRnh2Dp/i0znRdz3
b9k6luN/NS1sy14JX02Eb5U6wpilHS6cps6g7EFHiY4uypPkOX4WaFefO8Cqj7N6
wuAXcqYMfPGjfTzz6UPewMvUvAhJN21mIAC+q/FTwFfbnLrX0UBhtE5I01Jb2GiU
5qHlmwX17JPfZDuPzEGRVtI8G3gxzA3YXyQypEgoTWez02wmyO2LotIInGkTn5cG
5yB3hK11FSvth7iD9nqb1Q/HTsCWw95EAMdXeaKw8dit7LGATqm/7AzT6+kXsYEk
82Sz1HVWmdAtbsDmL5DEi4/TbgXElkC0wWzPU7QQ4PnkKj0a6w/oSZES2ew960zc
bm5RExzzoP4M2N8G/4q5eZafyZV9g7Q7K5corblTcj4+Aryl5PU=
=wDuL
-----END PGP SIGNATURE-----

--SlHZZNMhzcMNR76o8VMmyu0lknjL7S3fR--
