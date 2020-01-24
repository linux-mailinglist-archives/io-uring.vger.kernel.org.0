Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0F4148F69
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 21:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbgAXUfR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 15:35:17 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:36651 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387548AbgAXUfR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 15:35:17 -0500
Received: by mail-wr1-f47.google.com with SMTP id z3so3586567wru.3
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 12:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=cUdWDBpJeGo2Y7nNITKHJsxtw5+FIgIy6Z/MnLA1GwI=;
        b=MHylwb0BSi3QCMgbgHRj8pBg6yo8PxArAXj8HUOYT254GyFYohHdqJRcW8ZgnpsiZp
         5KCOvRz/cyElFG3Rfp+/5g9wEoIMtsptZ+YFpoPgP0TQJ/RHjdS+ERWD+TJCRT8mwmVw
         Ca7tw4rt/LqeUSxgEVG/dtg1ZiXeJAuWmLfs6frR8fRluhv/YIlmPX2/n8H44NvanhGq
         Uh7CIe8aQxWQEaghz07IyjSnm+PuUfyKorzDrf5v3G0kPunt9WpKzEhYiM0dJhnZqbjG
         yyhk060g6yTf10scppuHYOIkQwOERsEo9aXG0swA3OuoofG2QGc4DzvwRLJ5bqpQU7qv
         qbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=cUdWDBpJeGo2Y7nNITKHJsxtw5+FIgIy6Z/MnLA1GwI=;
        b=ryEkXtQ2FWcJk8/k1SGZQ+zD7EJRGL7aSgr/s11W7AOppnWIClxaw7w8RLhKI8SBPe
         ife4qVKxFiP/NdRjbzNOYMA4YWL2YGZG9Y817wNgUQuLRBydnB6mHSo30i5292YNIEwJ
         Hl7q7w7DpThm8+FPfatxFGZLpQiiomqeqaB7OIjQtQpyuLJKMGz+1eROSb77HwRweni7
         NDwqzYlw8LnzjdExZN1aQ3/CmrMjRPHA2RSf/sPp2NeRMAgNPv+EbqjWnkURWtjQ9fC8
         QTrmQn+xElfiZcUnRwNUQ1OWHsZjsIlMM9cvMy1hBUGRp1aPjs3PDolaQCff9BtIP+p4
         +xHQ==
X-Gm-Message-State: APjAAAUcxb3w1tOpCQC2m959sfUmPpM3jd/z2qchE6fRAWRIeW9Ifc6r
        COQFFHJ567UOh6FraNzq6fwTl6mq
X-Google-Smtp-Source: APXvYqwjsfONC6ONAChkjPHN+mkmuzKF4UwoMgbAt8P2lYYtDvC/ri6GwGwMgk0C0jhuVl7vKiIlGA==
X-Received: by 2002:adf:fcc4:: with SMTP id f4mr6578503wrs.247.1579898114872;
        Fri, 24 Jan 2020 12:35:14 -0800 (PST)
Received: from [192.168.43.32] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id q6sm9573618wrx.72.2020.01.24.12.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 12:35:14 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
Message-ID: <0bbc7cb3-6e04-d18c-4646-6886d02e5a87@gmail.com>
Date:   Fri, 24 Jan 2020 23:34:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200123231614.10850-1-axboe@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kGfK4IX0z8BblHdG1bsUF7NXVMaejGfLm"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kGfK4IX0z8BblHdG1bsUF7NXVMaejGfLm
Content-Type: multipart/mixed; boundary="kG7qAlVZVGt1dJlfdnoLQEh5aMZFqfvks";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <0bbc7cb3-6e04-d18c-4646-6886d02e5a87@gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
References: <20200123231614.10850-1-axboe@kernel.dk>
In-Reply-To: <20200123231614.10850-1-axboe@kernel.dk>

--kG7qAlVZVGt1dJlfdnoLQEh5aMZFqfvks
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/01/2020 02:16, Jens Axboe wrote:
> Sometimes an applications wants to use multiple smaller rings, because
> it's more efficient than sharing a ring. The downside of that is that
> we'll create the io-wq backend separately for all of them, while they
> would be perfectly happy just sharing that.
>=20
> This patchset adds support for that. io_uring_params grows an 'id' fiel=
d,
> which denotes an identifier for the async backend. If an application
> wants to utilize sharing, it'll simply grab the id from the first ring
> created, and pass it in to the next one and set IORING_SETUP_SHARED. Th=
is
> allows efficient sharing of backend resources, while allowing multiple
> rings in the application or library.
>=20
> Not a huge fan of the IORING_SETUP_SHARED name, we should probably make=

> that better (I'm taking suggestions).
>=20

Took a look at the latest version (b942f31ee0 at io_uring-vfs-shared-wq).=

There is an outdated commit message for the last patch mentioning renamed=

IORING_SETUP_SHARED, but the code looks good to me.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

--=20
Pavel Begunkov


--kG7qAlVZVGt1dJlfdnoLQEh5aMZFqfvks--

--kGfK4IX0z8BblHdG1bsUF7NXVMaejGfLm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4rVN0ACgkQWt5b1Glr
+6USWBAArUtBOWrCNOHvDB8OlVLGdwzEkcgPjFOI9rIOpEtToQ6+eX/rEb54wkfh
+3xs4yntvV4hqCBU0U7iFMw2VwaqtScloGwftmAjhL6s34i0c16IBGKNh9jK+/V9
DsTm27RM0mDbdGHN6SL7mvcV6fmihjtgtgJP6BIsMxBjl5iZO+Nxlvmv5J3kAEUS
UfB0MWKV0tTATjHuVO4/sCA7723WPIhhs8UJynMKqyvDwT9Pd80UQXH49jgvShEj
6o2x/OZbXtLycy8lBsMX/hM6hpFynJ14AwpxXCjllzDwXzbSpeyjdHdK5I7WH7Qi
NFLWQBEP4PaPbtVB+goWDDLOgoXXE27vIZc0syEVmDB2VGXKp2qiV08t7QdoYJJj
gAymQ2Nsho9MCQykGrwDkSdiTMDmJjJERxFwLBUn7aOs8Ajd14rxgDfRe9k+3DDR
y+uuUl8uz/L0WHerVw9u27md61uCOBMNkHkY/GWOWZmDMJzqjylnew5aCGgd+nI3
6e3P5z9zsFtOVlpOaL+kfDgTogwSpaFfPgiBuB15+r5zE8H/2mq83L4kXXa2lmy/
ALu6t2tM6KzFnJtRWTYyvGttmQQ/JdtEoiqBrx9UR+UOAtkilO6a9CjgBqHYft86
/h0oBLVuBTtp/h5sbI4ZfNu3MvuiMU4S6gcCgy6gCQ/B5VD0OD4=
=FMLv
-----END PGP SIGNATURE-----

--kGfK4IX0z8BblHdG1bsUF7NXVMaejGfLm--
