Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3631743E0
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 01:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgB2AoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 19:44:21 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53203 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgB2AoV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 19:44:21 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so5321042wmc.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 16:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=mrg/y38IEivx8fSJK1OeRVWONtSzc6LRZeIpepzj5xI=;
        b=ErT5/y89dkht1Y/bz6Z7r20tK7MNmgVB2M3q8wpMhVTvtjoU8XanNKGhaOOwS1ppC5
         v50YQJBfntsPCLQa2VfC6bBzua5rnSx0eO2+3YDAXcly65grFekvx2YXOnihkvQ3Farc
         cpH/mDqIO7hx3AuID5us38g05twDBG28jQuq1zxeIRRPbZJ+v4E2WDSTQPuIORGjhWSQ
         dmsitkB+hn4bYSmQmDLoDeyOm3S8YvvZEHel+jdWxjWec4pvt5eNqyIzQe6Yvn3tGC/Q
         5Y/gl6djTVOXN/o6b32ztVUFDzb1wpaJdCkCn/GXMMt8iZzHI4u5YfXNAG41Zz0FaaE6
         G55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=mrg/y38IEivx8fSJK1OeRVWONtSzc6LRZeIpepzj5xI=;
        b=kEOSGtHapNkDDAKKt1sMk/Z3ctXScApf3/uStbs6Ig/9nuDjfKhmajPD1dkDIE0IrG
         LIemTrwYU6fAlBxAf7oEYLqJkXztMqQ6l8OiaCsoOFNvxZaUzPnc80QElu3a/qau8cwq
         FJmPk6Sim/ycSiIaZaBuljjkYPoWmEhDMmLpa1oT1pw5J574s6z+0S0FOrcvpS9RCeq7
         Wj2H7gDxwGxtMDdTyDZQLGO8YSlOJJ39y0epUt5dG5K0PZguRRtjHg9GVpFwkmwpNzXC
         xQWQUdwR6RctlGMZZ1vk8X+QvWvUFHxeSaUrddmL5260o6POFMcgiE69rK8ztJiEKpSW
         rrYg==
X-Gm-Message-State: APjAAAVHogGW0eeFXsmavti5njQ8L0L3ByZaDoT5H1V4awIidFau8nzH
        cuFKuEqxPaxNYlR3FxBNWfA=
X-Google-Smtp-Source: APXvYqyWQLx6m69VSPbAcNwqC9IhfRoHSWmpWUAOgWR/+Mhzi0IxvzMR01WI4qUd8QvHWLZ1XKtKeQ==
X-Received: by 2002:a7b:ce0b:: with SMTP id m11mr7282793wmc.4.1582937056980;
        Fri, 28 Feb 2020 16:44:16 -0800 (PST)
Received: from [192.168.43.79] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id r30sm4286042wrc.34.2020.02.28.16.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 16:44:16 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
Message-ID: <7671b196-99cc-d0a9-3b7e-86769c304b10@gmail.com>
Date:   Sat, 29 Feb 2020 03:43:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200228203053.25023-3-axboe@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LEOHR2eu8yoA0oFNpuKHVaTpwoS9asdc5"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LEOHR2eu8yoA0oFNpuKHVaTpwoS9asdc5
Content-Type: multipart/mixed; boundary="356vW6CkIAHNBM5vE8YoUz3l5pTd18Tda";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: andres@anarazel.de
Message-ID: <7671b196-99cc-d0a9-3b7e-86769c304b10@gmail.com>
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
In-Reply-To: <20200228203053.25023-3-axboe@kernel.dk>

--356vW6CkIAHNBM5vE8YoUz3l5pTd18Tda
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 28/02/2020 23:30, Jens Axboe wrote:
> IORING_OP_PROVIDE_BUFFERS uses the buffer registration infrastructure t=
o
> support passing in an addr/len that is associated with a buffer ID and
> buffer group ID. The group ID is used to index and lookup the buffers,
> while the buffer ID can be used to notify the application which buffer
> in the group was used. The addr passed in is the starting buffer addres=
s,
> and length is each buffer length. A number of buffers to add with can b=
e
> specified, in which case addr is incremented by length for each additio=
n,
> and each buffer increments the buffer ID specified.
>=20
> No validation is done of the buffer ID. If the application provides
> buffers within the same group with identical buffer IDs, then it'll hav=
e
> a hard time telling which buffer ID was used. The only restriction is
> that the buffer ID can be a max of 16-bits in size, so USHRT_MAX is the=

> maximum ID that can be used.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>


> +
> +static int io_add_buffers(struct io_provide_buf *pbuf, struct list_hea=
d *list)
> +{
> +	struct io_buffer *buf;
> +	u64 addr =3D pbuf->addr;
> +	int i, bid =3D pbuf->bid;
> +
> +	for (i =3D 0; i < pbuf->nbufs; i++) {
> +		buf =3D kmalloc(sizeof(*buf), GFP_KERNEL);
> +		if (!buf)
> +			break;
> +
> +		buf->addr =3D addr;
> +		buf->len =3D pbuf->len;
> +		buf->bid =3D bid;
> +		list_add(&buf->list, list);
> +		addr +=3D pbuf->len;

So, it chops a linear buffer into pbuf->nbufs chunks of size pbuf->len.
Did you consider iovec? I'll try to think about it after getting some sle=
ep

> +		bid++;
> +	}
> +
> +	return i;
> +}
> +
> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **=
nxt,
> +			      bool force_nonblock)
> +{
> +	struct io_provide_buf *p =3D &req->pbuf;
> +	struct io_ring_ctx *ctx =3D req->ctx;
> +	struct list_head *list;
> +	int ret =3D 0;
> +
> +	/*
> +	 * "Normal" inline submissions always hold the uring_lock, since we
> +	 * grab it from the system call. Same is true for the SQPOLL offload.=

> +	 * The only exception is when we've detached the request and issue it=

> +	 * from an async worker thread, grab the lock for that case.
> +	 */
> +	if (!force_nonblock)
> +		mutex_lock(&ctx->uring_lock);

io_poll_task_handler() calls it with force_nonblock=3D=3Dtrue, but it doe=
sn't hold
the mutex AFAIK.

> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	list =3D idr_find(&ctx->io_buffer_idr, p->gid);
> +	if (!list) {
> +		list =3D kmalloc(sizeof(*list), GFP_KERNEL);
> +		if (!list) {
> +			ret =3D -ENOMEM;
> +			goto out;
> +		}
> +		INIT_LIST_HEAD(list);
> +		ret =3D idr_alloc(&ctx->io_buffer_idr, list, p->gid, p->gid + 1,
> +					GFP_KERNEL);
> +		if (ret < 0) {
> +			kfree(list);
> +			goto out;
> +		}
> +	}
> +
> +	ret =3D io_add_buffers(p, list);

Isn't it better to not do partial registration?
i.e. it may return ret < pbuf->nbufs

> +	if (!ret) {
> +		/* no buffers added and list empty, remove entry */
> +		if (list_empty(list)) {
> +			idr_remove(&ctx->io_buffer_idr, p->gid);
> +			kfree(list);
> +		}
> +		ret =3D -ENOMEM;
> +	}
> +out:
> +	if (!force_nonblock)
> +		mutex_unlock(&ctx->uring_lock);
> +	if (ret < 0)
> +		req_set_fail_links(req);
> +	io_cqring_add_event(req, ret);
> +	io_put_req_find_next(req, nxt);
> +	return 0;
> +}
> +
--=20
Pavel Begunkov


--356vW6CkIAHNBM5vE8YoUz3l5pTd18Tda--

--LEOHR2eu8yoA0oFNpuKHVaTpwoS9asdc5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5Zs7QACgkQWt5b1Glr
+6UCvBAAiH0euzxJUzW6M8vjZR0Mo0tduhsFdx3lk1NaWDpj4lZvJ19Odjw/nZ64
z4/WkEIijCeOCvdK3AIH7hC1/o7ZF+fnFHpAAbmyjE32ayAuEvtbVLj+8oUwhQNY
CSiNva8fJUp9YY4luOJ8zwOQ2VY34BrYZxhZJVmzDkYtyOno68fXk4t/IxBMTkM6
4ZNk9iryhSGSLC2BvrcPfGMK0AO3ANAM7DxXvfOJ1+eLHaWyQdW3+lz1nUjN8Q6b
ZCc9v/7+c8qNhq3fVSsizEpeETwK6hSgIsiCg8SACKKxyvBAVuaf0cEsxQXr27PE
hqgwxwzoD2KwbDjxFWVtHBMDGq59JUtffTzavXLqQT7wZNepneYjgZIx/KxovBim
eZF6xquGBWkr/b19XRX4gEdFdlbnBdmdQ6hA5ZqhSNsOycMVWKiKoG59ldFCrBHV
wEPc5XJVc0LM+jUCnz8Hp8/G3C9waThl8gLdKK/jwZovuD33QwaSvYmSZ8E2FIf8
RJ4XoSvC3aA1VxcEHwXNC96QWaFwBesk80Wv5xjBo7OEVQf/5kGglcqZSSH1dTlb
V5mOoOq1t9M0f96tUg9j/q+/bRugahpmrlDcCrvmuZFWNl2BMPNp82kF3+FdqHrq
793r1iJCBcq2NByPj5CTplqWBiv1HBb865rB8iVnxzL6mhBayaw=
=ywtm
-----END PGP SIGNATURE-----

--LEOHR2eu8yoA0oFNpuKHVaTpwoS9asdc5--
