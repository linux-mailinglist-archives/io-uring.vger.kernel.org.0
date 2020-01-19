Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A705D141CE1
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2020 08:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgASHrs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jan 2020 02:47:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39232 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgASHrs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jan 2020 02:47:48 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so11559926wmj.4;
        Sat, 18 Jan 2020 23:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=ZdTtfQVuHvdEL4UQw11xgr14W3xtiJpjbhtmCMFPdM4=;
        b=ZteUC5ZuvcQrWAdchXPAT4ofARr0gBkRwcw4DKJ3W5Ga7tPs83td3dAMLM8j917DXQ
         tNjMpQaugkch9P/Qs9eIJirHbpRe0zlmeg7oxY3UnwxxFg+g3EuDc5RATJbQlHtgWCNk
         KO210662y7ExD5JgX7eMjM7iUrrTgCYXJzNAVGvgFCqtwOa0mBELf98Ri3m7G+ZGy+Zv
         1HUZHhiawqX6472FMoZxl/NMdcJWFGuvSdL1clJo9L8aYfoDaRS/ptsAOvBE83oG5Zs/
         I2Zc5e54FbwAMauq7Li9Od7oN17hD5M1iN8ip0whqMPY5FeCjqlZ2i8W2jMT/qN8Wxnr
         pQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=ZdTtfQVuHvdEL4UQw11xgr14W3xtiJpjbhtmCMFPdM4=;
        b=NpGS+dWvmugMhua1RSusVYm8BTzZtyXAedhTj9afNAeqfkGxS7w62g8SibhEWdvnnJ
         UuLpkZNswzKtQGh3eYa7r8pyum6mQApphrpbtsp1pO7nL1u/E0NZkYMjGKeVhR80wnHB
         LsYyP7gp7sNaP/tqmKFfx2e6UbJg+T6XdOxBPOsywv/48hUYLatFrPHZPyVWpev0YLQ3
         z6h+ZMC4f/IOplXNLmvKurDdvhZKtWPQLnLRRsHngA+QG+7cQ1m4F+Gk7BnDcOnH6J0r
         bBGwtkf+ev6u9vni3rALaVHB66qS0AYSl/Z0YLfDqUCBHsBlDATZPNb5G1pmPrPxYMkl
         4qCQ==
X-Gm-Message-State: APjAAAU5+JhIaDaNIGSEm25Viu6ld34QjBZcMJ0qM4Qbkw00a+C6fAgS
        Sku5mJygmQCEXLAbrq7yj+/69zi9
X-Google-Smtp-Source: APXvYqw+q0oCoUjwTZDRggGJCE71c7ko+reslC2zjQK3LMJod4PkCm57/xGpd6/8ozSpM1xn9QkgcA==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr13351827wmm.85.1579420065974;
        Sat, 18 Jan 2020 23:47:45 -0800 (PST)
Received: from [192.168.43.33] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id l18sm17182154wme.30.2020.01.18.23.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 23:47:45 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
 <648dbd08d8acb9c959acdd0fc76e8482d83635dd.1579368079.git.asml.silence@gmail.com>
 <7197ccc8-6fe2-3405-c88d-95bcb909d55a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 1/1] io_uring: optimise sqe-to-req flags translation
Message-ID: <8ce8fffb-f02c-8d0d-4b22-626742f1a852@gmail.com>
Date:   Sun, 19 Jan 2020 10:46:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7197ccc8-6fe2-3405-c88d-95bcb909d55a@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wIprS74pF2WrG2uF3M4lxRGPvl3MB2g8T"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wIprS74pF2WrG2uF3M4lxRGPvl3MB2g8T
Content-Type: multipart/mixed; boundary="jysOBnbY2cAkKbL8L89UxxuVivPAXvycG";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <8ce8fffb-f02c-8d0d-4b22-626742f1a852@gmail.com>
Subject: Re: [PATCH v3 1/1] io_uring: optimise sqe-to-req flags translation
References: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
 <648dbd08d8acb9c959acdd0fc76e8482d83635dd.1579368079.git.asml.silence@gmail.com>
 <7197ccc8-6fe2-3405-c88d-95bcb909d55a@kernel.dk>
In-Reply-To: <7197ccc8-6fe2-3405-c88d-95bcb909d55a@kernel.dk>

--jysOBnbY2cAkKbL8L89UxxuVivPAXvycG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 18/01/2020 23:46, Jens Axboe wrote:
> On 1/18/20 10:22 AM, Pavel Begunkov wrote:
>> For each IOSQE_* flag there is a corresponding REQ_F_* flag. And there=

>> is a repetitive pattern of their translation:
>> e.g. if (sqe->flags & SQE_FLAG*) req->flags |=3D REQ_F_FLAG*
>>
>> Use same numeric values/bits for them and copy instead of manual
>> handling.

I wonder, why this isn't a common practice around the kernel. E.g. I'm lo=
oking
at iocb_flags() and kiocb_set_rw_flags(), and their one by one flags copy=
ing is
just wasteful.

>=20
> Thanks, applied.
>=20

--=20
Pavel Begunkov


--jysOBnbY2cAkKbL8L89UxxuVivPAXvycG--

--wIprS74pF2WrG2uF3M4lxRGPvl3MB2g8T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4kCXwACgkQWt5b1Glr
+6Xu7xAAn+IsaML7CmUyRRd5yodndu0S0X4E1pwF8QVkAJ4LZMF5LNBnbBSiLTxI
5MnWy/Itmx5l8m4kUmJDIs+xoVe9++8y4FbiwV/+Jri/loRVLa0Mhua+SHOu3DSa
mBrqRtcJ24+nzRAPeNNhB5w/q6eHseUAt6KdswoVj1S1UhN4w3BAcSk+golDyk/e
q9bX0RzQnZOu2U3pB9imRe7Eg4LH3s1Oau4zSB2tQiO1uct7NORyvci9cfsyjmZe
DcypkytClPXWuaQtcV+JlG4qVxEZ9yGa8bmQ6biq15Bc7mDts1wB1svD9HUENQxn
0X+eYmHCPXlcx1fJPFdi5cfybtpo5uONkkT6PP0O3HcrMcrd8fbs/AaYCqawbl67
vHtVa5VHpoyAkYcKF5bmr0ianyN3BTGrTzMRauxqgrtdm8icSFmVvERbvi4HpYJc
DHdGVt7mIcYTRU4Zl4IMrzB1j3t3iEZpsqyR1NNExikMA/TGUJVSgcm1H0/SxQGW
4bVExVMfVYkvlHIXuzxyC0JyakrixixMQaIwqKsPCIX8JYAAu36uuUdWbBsnqKex
JOtTzWs7IZEK5gjwxsH/4EGnmnuW0g9GmMPI9MQG3Na2kknIQTJKS6i66ej4KRyz
R3B56caeUDIrXEWVqqtn4qajXPIpuGl/0UGWy7Z635fxT+iW/JA=
=Ftfh
-----END PGP SIGNATURE-----

--wIprS74pF2WrG2uF3M4lxRGPvl3MB2g8T--
