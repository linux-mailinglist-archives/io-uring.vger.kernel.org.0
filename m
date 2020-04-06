Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE25319FEAA
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 22:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgDFUCv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 16:02:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44966 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFUCv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 16:02:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id c15so978180wro.11;
        Mon, 06 Apr 2020 13:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=zgQ7IMlDvdLY8o7/vd2Yy6fwTd5gBIx7KrgVafEc9Oo=;
        b=OBh8Kkf4LPGLPG5SmdCVdAKorJI8dxKJlcGW7uIBmeIUM+eYZL9CKh9YxVkE1Q9ttB
         Jdj5UaKJQbAmMUKH8GwTbKzX4BJ9p2mRyvvOKU49mJ2njVHCsgT2tbzN67azYiJX3oKp
         se3OD7AxXp9WhDIx7lILXcOMirZ3dQ6AdGyone1faGVdiZATb5LtifxGd6Bi6PGHGX4w
         EzLbifqspLJ8KVin1UvJ0zYo+QzaHfUyTtGlytuf4KPpT5EIsXRUZp51I3z2mW/7b9Tn
         K0EAmjJf7eYaC+lCRobCsR9gyR//8P1u7NwIrSVWlLGvLcBOCoy32ntXAb/PUyQ5AqN2
         52iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=zgQ7IMlDvdLY8o7/vd2Yy6fwTd5gBIx7KrgVafEc9Oo=;
        b=lsGKBwwx0NnaBrNhtgkIADDmJjqWKQ2MS6qtfifwzVM+2iA7qnAS/Pce0CBxhr4K6Q
         7pqJr7/yJtsV8OGJIVKZ3JdhbzTl5JJrMSnvK+jj+B4Ct6kNpQTOxY0xrQz4nE0Gue3d
         EBGSI+MACuqdHJ7CbWBD67qfRZMvolc4ZLR8cbparZMLWTaOf/iV6yG7dlr39Fe194ng
         bsQv8Ex7r+m8gr6EKEhN0V9Md2QeD4zEG7koonkPXxVkQpgRO8pfgHJHTicFVQSbS4wd
         40ULJ4k9/GR+oyn3gSJrVuolvhDScnnkDGDFuBxF9ePGZtjxGua2hA0BNM8itgoOcgqh
         4/nQ==
X-Gm-Message-State: AGi0Puagqi7F9VBzJNZXulG97G6RTaz9p6+FJEb+L8/i2NLQZagt/3Cv
        4yFoagtw6GwfHuerl1Hb1oc=
X-Google-Smtp-Source: APiQypK0S9LYB8vFy7yVLl49eYP7gZFUI6QgnPbAuNfXv++iU/nyJwzwwz6bF0Fcz/PzXVqvkl5r5g==
X-Received: by 2002:a5d:484b:: with SMTP id n11mr972832wrs.110.1586203369487;
        Mon, 06 Apr 2020 13:02:49 -0700 (PDT)
Received: from [192.168.43.134] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id t2sm9596367wrs.7.2020.04.06.13.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 13:02:48 -0700 (PDT)
To:     Askar Safin <safinaskar@mail.ru>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <1586200181.435329676@f412.i.mail.ru>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [POC RFC 0/3] splice(2) support for io_uring
Message-ID: <59c447cb-46b5-ac9d-3fdd-94d029e7f5dc@gmail.com>
Date:   Mon, 6 Apr 2020 23:01:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1586200181.435329676@f412.i.mail.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XeXf2vlNfgg9vaeMUWcOxYZdYkCoLmWN3"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XeXf2vlNfgg9vaeMUWcOxYZdYkCoLmWN3
Content-Type: multipart/mixed; boundary="J7LH82WWimjZtr0j91XWX2urDE1jPHLqz";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Askar Safin <safinaskar@mail.ru>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-ID: <59c447cb-46b5-ac9d-3fdd-94d029e7f5dc@gmail.com>
Subject: Re: [POC RFC 0/3] splice(2) support for io_uring
References: <1586200181.435329676@f412.i.mail.ru>
In-Reply-To: <1586200181.435329676@f412.i.mail.ru>

--J7LH82WWimjZtr0j91XWX2urDE1jPHLqz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/04/2020 22:09, Askar Safin wrote:
> Hi. Thanks for your splice io_uring patch. Maybe it will be good idea t=
o add uring operation, which will unify splice, sendfile and copy_file_ra=
nge instead of just IORING_OP_SPLICE?

It doesn't have to follow splice(2) semantics, so can be extended, in the=
ory.

Though I don't see much profit in doing that for now. sendfile(2) is done=
 by
splicing through an internal pipe, and this pipe will complicate things f=
or
io-wq (i.e. io_uring's thread pool). On the other hand, it'd be of the sa=
me
performance and even more flexible to send 2 linked splice requests with =
a
pre-allocated pipe from the userspace.

--=20
Pavel Begunkov


--J7LH82WWimjZtr0j91XWX2urDE1jPHLqz--

--XeXf2vlNfgg9vaeMUWcOxYZdYkCoLmWN3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl6Liq0ACgkQWt5b1Glr
+6V/Cg/8DGMAtp8WL98iaVAYYfHeJZ7g4Rr/XylbWMSHl1gDBvYgdz5tItBu1XJn
V890nJDW+pvpMKVPc6wg5f0zEEnpFa6+sLOiyZzNYxvqRcO/Dq2mTNHXWa2A4v1F
xlcagtY9QmKE6mp8IOQMQGLhvdacqEMY36h9qzb7l0m9ZYkWDy0UgHvKtWxc5m2Z
jPjH8983jqhYZJnjkHtpeOzDWcn8+g3YB4rwwo/npqxtfkEL0YsH53Og3/ryVFbE
saSVNmtVGKV3bYh4DnWySU4KDI26DxqJnZgDBC9VlpCssQFkBSphwJzoaf2HbQFe
/2cS3kIb4t1UKwj3bYLML2gNSy7iMqdx/DPzhGvpEVK+DQxmvMPEXDNe39xNdSDU
u0SWAOLi3hbSdWYPGtrHkLHGPPmXvtg4p1nTNO3bD+tqkZyDZiKw0Ma5XnqodS43
TFGHpfqQMyI/S/siGt1Zf0Lrm85inT4uNf0i54hhH4hLJz3YP9vZ56T9VPJ3u1E3
WI6rFeFNRJLpPVRelVWyv/xD8SCPd3ok+pLBK3UYMVa2mIX7d/KqhfDKf9iIARtA
W15K4olNf8NwSsqNsODjYkVX5imlZkmELNS4I/Fpo4iEk37EfJ5gOCOtE+xr//G1
H5Q9hmqtyXu119/phXApZSWO6t7XgSMUAgzVpIz/eondEvTg31k=
=R4jo
-----END PGP SIGNATURE-----

--XeXf2vlNfgg9vaeMUWcOxYZdYkCoLmWN3--
