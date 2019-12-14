Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD6811F333
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 18:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLNR4j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 12:56:39 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32876 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfLNR4j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 12:56:39 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so1506988lfl.0;
        Sat, 14 Dec 2019 09:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Fa8lw02ivhbwAMD/0kKb4b8FWTP4Fni72JISw89p08E=;
        b=KTa/A2vD2Upgn3m+UwRD3/KqhsjhdnZTWGijuOeGaKM7zEvS4zHZhoxT88SUJpvSAM
         coSZM7fMn8U4Ve2ZV3WUUTekuQvLhEc8xfXOs105/YWxPvILEG+GoeUcpnKTDWChVtsH
         0vJxXemQY2w6xO+Acqnb4aYAvVBMs4Yt7x47iAlsU2QCnLot0UbScFWQ0sXJO1kyvH/D
         eN2VUOxAM1DewzjApZBtXIAzGAHdP5rtYAVJ3MtksC7BEo3QyIpCFSVrHq0uDpRebwom
         RUCE8cGqDHwHHhi2c6gKn6G5BtutkW7nbhRfTm38mnplBbLdx7pfUY6VzWylTCJmNfsD
         bAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=Fa8lw02ivhbwAMD/0kKb4b8FWTP4Fni72JISw89p08E=;
        b=qLJ2dSyYF/l5KdGyjt7rzuAZNBG6ebZFhBcRzwvG1B/aVMX2G6EiBVWxhpX4xzmvaB
         cY8AONtnanmlONEXmZ5OAjp4v+kilp/xlX63I8FHle57lOiKDyb7ia/5dNcy97IDJJH8
         ws/M88OwQ8IRL8SKgt4Zah3jNoI9HsfUdavfSNJMpFpn/EbMLxWZnkmyEth0ZVYtQjad
         UnIWYZOpMKOYLNw43bt1cPgyJr8QGKVuwZp9cHzqKoPe81iu5LCrgyd6UvT4Mf3xE5xb
         26Dd8GdRJ6cTTwZm1PDBwBUa8q3wZhEOm5pd/Y4wme6J1w+ndWahspWiEb598L/1C71b
         BvuQ==
X-Gm-Message-State: APjAAAXeJyxYizzmweqjmatxViweVRuU0Qb2dpIH+1ySWckAJgEidDwX
        KQql+lhUxEt7EjGwSjJLbmOkKlJL87k=
X-Google-Smtp-Source: APXvYqznIvGNCl59IIk8njEjrcNTb18ZdErSx6ZEHF8I+tJgTQBfysa8ANH0HLN72dh8aOAs7SvW+w==
X-Received: by 2002:a19:5007:: with SMTP id e7mr12186382lfb.153.1576346196178;
        Sat, 14 Dec 2019 09:56:36 -0800 (PST)
Received: from [192.168.1.66] (88-119-143-153.static.zebra.lt. [88.119.143.153])
        by smtp.gmail.com with ESMTPSA id 22sm7976110ljw.9.2019.12.14.09.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 09:56:35 -0800 (PST)
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_IOCTL
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
 <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <9b4f56c1-dce9-1acd-2775-e64a3955d8ee@gmail.com>
Date:   Sat, 14 Dec 2019 20:56:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4YB4m92gfg19Nx3WrZ9JrMujaIA3FhllQ"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4YB4m92gfg19Nx3WrZ9JrMujaIA3FhllQ
Content-Type: multipart/mixed; boundary="sNXDW8RANKm4Uql8TTvlqedYda3jQiFlf";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>
Message-ID: <9b4f56c1-dce9-1acd-2775-e64a3955d8ee@gmail.com>
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_IOCTL
References: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
 <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>
In-Reply-To: <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>

--sNXDW8RANKm4Uql8TTvlqedYda3jQiFlf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 14/12/2019 20:12, Jann Horn wrote:
> On Sat, Dec 14, 2019 at 4:30 PM Pavel Begunkov <asml.silence@gmail.com>=
 wrote:
>> This works almost like ioctl(2), except it doesn't support a bunch of
>> common opcodes, (e.g. FIOCLEX and FIBMAP, see ioctl.c), and goes
>> straight to a device specific implementation.
>>
>> The case in mind is dma-buf, drm and other ioctl-centric interfaces.
>>
>> Not-yet Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> It clearly needs some testing first, though works fine with dma-buf,
>> but I'd like to discuss whether the use cases are convincing enough,
>> and is it ok to desert some ioctl opcodes. For the last point it's
>> fairly easy to add, maybe except three requiring fd (e.g. FIOCLEX)
>>
>> P.S. Probably, it won't benefit enough to consider using io_uring
>> in drm/mesa, but anyway.
> [...]
>> +static int io_ioctl(struct io_kiocb *req,
>> +                   struct io_kiocb **nxt, bool force_nonblock)
>> +{
>> +       const struct io_uring_sqe *sqe =3D req->sqe;
>> +       unsigned int cmd =3D READ_ONCE(sqe->ioctl_cmd);
>> +       unsigned long arg =3D READ_ONCE(sqe->ioctl_arg);
>> +       int ret;
>> +
>> +       if (!req->file)
>> +               return -EBADF;
>> +       if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>> +               return -EINVAL;
>> +       if (unlikely(sqe->ioprio || sqe->addr || sqe->buf_index
>> +               || sqe->rw_flags))
>> +               return -EINVAL;
>> +       if (force_nonblock)
>> +               return -EAGAIN;
>> +
>> +       ret =3D security_file_ioctl(req->file, cmd, arg);
>> +       if (!ret)
>> +               ret =3D (int)vfs_ioctl(req->file, cmd, arg);
>=20
> This isn't going to work. For several of the syscalls that were added,
> special care had to be taken to avoid bugs - like for RECVMSG, for the
> upcoming OPEN/CLOSE stuff, and so on.
>=20
> And in principle, ioctls handlers can do pretty much all of the things
> syscalls can do, and more. They can look at the caller's PID, they can
> open and close (well, technically that's slightly unsafe, but IIRC
> autofs does it anyway) things in the file descriptor table, they can
> give another process access to the calling process in some way, and so
> on. If you just allow calling arbitrary ioctls through io_uring, you
> will certainly get bugs, and probably security bugs, too.
>=20
> Therefore, I would prefer to see this not happen at all; and if you do
> have a usecase where you think the complexity is worth it, then I
> think you'll have to add new infrastructure that allows each
> file_operations instance to opt in to having specific ioctls called
> via this mechanism, or something like that, and ensure that each of
> the exposed ioctls only performs operations that are safe from uring
> worker context.

Sounds like hell of a problem. Thanks for sorting this out!

>=20
> Also, I'm not sure, but it might be a good idea to CC linux-api if you
> continue working on this.
>=20

--=20
Pavel Begunkov


--sNXDW8RANKm4Uql8TTvlqedYda3jQiFlf--

--4YB4m92gfg19Nx3WrZ9JrMujaIA3FhllQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl31IkAACgkQWt5b1Glr
+6Wx0xAApGN9Sj0cskefxpiPHW2GqjOD9alNmMPvEZxEtN3uZ6RFpdqWosyRKzPj
6MY8PUr8CyELb9K+kVPba5Z2Pm7AFYzNO8fPM9PyoRLaYS0Y+6dCZqsc+RnH6iPj
iIuPuiSTFSipbbguQqXF90EbFlHQqLpDjZm2c5zKZXe7pE+H0c6Kz590rbpT0LUh
rnyExBS3eL/WoB0CX9ICYWe78c8x+RF2b4c79l6UwzkqmTY1PtZ4DPKbnNJK8kwj
Z/u5nGTS2FBZO/TYOrbxhzr26pLykBY8bGlGNlfgmHRQqy23yUngnliE4KD7gWh3
SAVyfOpT6ma8WvhReKfN2AtPM7Ci3c+3ff+/Cd+yBtjK6iN2JHZnYzYdMNwIywwc
gEFu8Y7Wolvt3kGm/BGSGAAEMVQrVOCkbJDrTUofltJCA5+dhr7sDTJfFLT7Gs2p
puGbN/Ga7+aLgrECUSDW5/s6lcrQRJt1zTvl2vuyJw/OX/Yiu9OM8VHmIVtu0ivP
d5JJOHBcmEOxvdwPe7ETyc02FtPSSd4AUVgmVvOOkiDO30LKHaRPkqin6n0cmOi0
NQJHp9cB3Mr9CqC0K5slpq+yfWDzR4FI9oa+zqzCvh61YYvifXukXWCWgSjnSTS/
r7c99Xk9QWfoyadt3O1WDGT1MpNdmlb3MnmntXXHRmD8wCWuXoM=
=80hD
-----END PGP SIGNATURE-----

--4YB4m92gfg19Nx3WrZ9JrMujaIA3FhllQ--
