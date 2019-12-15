Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDCC11F88B
	for <lists+io-uring@lfdr.de>; Sun, 15 Dec 2019 16:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfLOPkd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Dec 2019 10:40:33 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45540 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbfLOPkd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Dec 2019 10:40:33 -0500
Received: by mail-lj1-f195.google.com with SMTP id d20so3960306ljc.12;
        Sun, 15 Dec 2019 07:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=CTZ2pZB2wNwDLvTFUV0MMSr69q6DfDDe++sL8bn33HM=;
        b=qQFUiJgE6rjoBLHuWl4eu+rn6IaW2QxlyU1wVQ4jjLF0yGStOGgdJb8cnK+jCDb3Mk
         JqxZlAt/qkSLdpzaMhLYSSHzJUFOw9n+dagHB421JEKJqyGEpAQOfMhDEo4RMzhTJ/lt
         6faNql1ibTpWGkztGsUOzCm8RZELLoVdNdBTo9OL2pqtJnOyjZRCrKnsJRkg+OQnlmXg
         FeieohYlgInz5xtgCgN9bM++ZWkDZewgag5HsjbDdvTVGlC9G5i+yFcO3CAj/tpCesnF
         ddI+/O47Dy5goWCVKZepxMm2p+lfEp7DKtlImNIZbLZ0942usgMZepXgufFBLYr5kAuH
         TsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=CTZ2pZB2wNwDLvTFUV0MMSr69q6DfDDe++sL8bn33HM=;
        b=plHaWCWwpahJQwsPfEW1ZnUbOU+QOOvkl/UVacuJJWM2zF92Z2zu1xXB6fFMp6Cgju
         nQTEx37yB8Mb4+9pK+ENLT42XWqtPctCq6Tg5+w+28Pr4sOWWJ4JfFsN139ItxnAybnM
         AkWCOVz6qpB7YyUiV8ivmxo5BVn0NAws3pzmrvcjmWb5lSk8wQ41B2xxz6hjHjL0uoUp
         9fYnrFXij5ieTZcUfFYvc6FB0i30jpZdbB36S+34Uu3oNskvS8+2sYIAEgNvjAN9i662
         HE0iWUkrPTQQMpKbk0FtnWq0Tnaim/0deCwGNI4h99FWsBxbD7nHnAWF0voNPYqBi4QC
         fKZg==
X-Gm-Message-State: APjAAAVZpiS9Attgf52ZM28d9tlbk3ZxkMDHg6F8HyVwk9TMqnrdRTHd
        QWUa4OJN1yfIL4Q+XozvSj2uNLshOHs=
X-Google-Smtp-Source: APXvYqybnVrDTZjwzdrCgVJb1SxcS98yw+tEPW8P7wT5WT/Bay7xwwFdYuOb46kLGzeQflMirC44KA==
X-Received: by 2002:a05:651c:204f:: with SMTP id t15mr17318041ljo.240.1576424429552;
        Sun, 15 Dec 2019 07:40:29 -0800 (PST)
Received: from [192.168.72.83] (h-235-202.litrail.lt. [109.205.235.202])
        by smtp.gmail.com with ESMTPSA id t27sm8635967ljd.26.2019.12.15.07.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 07:40:28 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
 <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>
 <9b4f56c1-dce9-1acd-2775-e64a3955d8ee@gmail.com>
 <1f995281-4a56-a7de-d20b-14b0f64536c0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_IOCTL
Message-ID: <3757f227-6ed9-b140-e367-69387f966874@gmail.com>
Date:   Sun, 15 Dec 2019 18:40:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1f995281-4a56-a7de-d20b-14b0f64536c0@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kd9uO3yyLTv5jAxAnQUrOTu0ZpLvd4uqK"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kd9uO3yyLTv5jAxAnQUrOTu0ZpLvd4uqK
Content-Type: multipart/mixed; boundary="NVRCSdkBgmwp8MM6y3E5YDSTAHw0M4qas";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>
Message-ID: <3757f227-6ed9-b140-e367-69387f966874@gmail.com>
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_IOCTL
References: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
 <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>
 <9b4f56c1-dce9-1acd-2775-e64a3955d8ee@gmail.com>
 <1f995281-4a56-a7de-d20b-14b0f64536c0@kernel.dk>
In-Reply-To: <1f995281-4a56-a7de-d20b-14b0f64536c0@kernel.dk>

--NVRCSdkBgmwp8MM6y3E5YDSTAHw0M4qas
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 14/12/2019 21:52, Jens Axboe wrote:
> On 12/14/19 10:56 AM, Pavel Begunkov wrote:
>>
>> On 14/12/2019 20:12, Jann Horn wrote:
>>> On Sat, Dec 14, 2019 at 4:30 PM Pavel Begunkov <asml.silence@gmail.co=
m> wrote:
>>>> This works almost like ioctl(2), except it doesn't support a bunch o=
f
>>>> common opcodes, (e.g. FIOCLEX and FIBMAP, see ioctl.c), and goes
>>>> straight to a device specific implementation.
>>>>
>>>> The case in mind is dma-buf, drm and other ioctl-centric interfaces.=

>>>>
>>>> Not-yet Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>
>>>> It clearly needs some testing first, though works fine with dma-buf,=

>>>> but I'd like to discuss whether the use cases are convincing enough,=

>>>> and is it ok to desert some ioctl opcodes. For the last point it's
>>>> fairly easy to add, maybe except three requiring fd (e.g. FIOCLEX)
>>>>
>>>> P.S. Probably, it won't benefit enough to consider using io_uring
>>>> in drm/mesa, but anyway.
>>> [...]
>>>> +static int io_ioctl(struct io_kiocb *req,
>>>> +                   struct io_kiocb **nxt, bool force_nonblock)
>>>> +{
>>>> +       const struct io_uring_sqe *sqe =3D req->sqe;
>>>> +       unsigned int cmd =3D READ_ONCE(sqe->ioctl_cmd);
>>>> +       unsigned long arg =3D READ_ONCE(sqe->ioctl_arg);
>>>> +       int ret;
>>>> +
>>>> +       if (!req->file)
>>>> +               return -EBADF;
>>>> +       if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>> +               return -EINVAL;
>>>> +       if (unlikely(sqe->ioprio || sqe->addr || sqe->buf_index
>>>> +               || sqe->rw_flags))
>>>> +               return -EINVAL;
>>>> +       if (force_nonblock)
>>>> +               return -EAGAIN;
>>>> +
>>>> +       ret =3D security_file_ioctl(req->file, cmd, arg);
>>>> +       if (!ret)
>>>> +               ret =3D (int)vfs_ioctl(req->file, cmd, arg);
>>>
>>> This isn't going to work. For several of the syscalls that were added=
,
>>> special care had to be taken to avoid bugs - like for RECVMSG, for th=
e
>>> upcoming OPEN/CLOSE stuff, and so on.
>>>
>>> And in principle, ioctls handlers can do pretty much all of the thing=
s
>>> syscalls can do, and more. They can look at the caller's PID, they ca=
n
>>> open and close (well, technically that's slightly unsafe, but IIRC
>>> autofs does it anyway) things in the file descriptor table, they can
>>> give another process access to the calling process in some way, and s=
o
>>> on. If you just allow calling arbitrary ioctls through io_uring, you
>>> will certainly get bugs, and probably security bugs, too.
>>>
>>> Therefore, I would prefer to see this not happen at all; and if you d=
o
>>> have a usecase where you think the complexity is worth it, then I
>>> think you'll have to add new infrastructure that allows each
>>> file_operations instance to opt in to having specific ioctls called
>>> via this mechanism, or something like that, and ensure that each of
>>> the exposed ioctls only performs operations that are safe from uring
>>> worker context.
>>
>> Sounds like hell of a problem. Thanks for sorting this out!
>=20
> While the ioctl approach is tempting, for the use cases where it makes
> sense, I think we should just add a ioctl type opcode and have the
> sub-opcode be somewhere else in the sqe. Because I do think there's
> a large opportunity to expose a fast API that works with ioctl like
> mechanisms. If we have
>=20
> IORING_OP_IOCTL
>=20
> and set aside an sqe field for the per-driver (or per-user) and
> add a file_operations method for sending these to the fd, then we'll
> have a much better (and faster + async) API than ioctls. We could
> add fops->uring_issue() or something, and that passes the io_kiocb.
> When it completes, the ->io_uring_issue() posts a completion by
> calling io_uring_complete_req() or something.
>=20
> Outside of the issues that Jann outlined, ioctls are also such a
> decade old mess that we have to do the -EAGAIN punt for all of them
> like you did in your patch. If it's opt-in like ->uring_issue(), then
> care could be taken to do this right and just have it return -EAGAIN
> if it does need async context.

Right. But there is an overhead within io_uring, small but still. IMHO,
there won't be much merit unless utilising batching/async. From my
perspective, to justify the work there should be such a user (or one
should be created) with a prototype and performance numbers.
Any ideas where to look?

>=20
> ret =3D fops->uring_issue(req, force_nonblock);
> if (ret =3D=3D -EAGAIN) {
> 	... usual punt ...
> }
>=20
> I think working on this would be great, and some of the more performanc=
e
> sensitive ioctl cases should flock to it.
>=20

--=20
Pavel Begunkov


--NVRCSdkBgmwp8MM6y3E5YDSTAHw0M4qas--

--kd9uO3yyLTv5jAxAnQUrOTu0ZpLvd4uqK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl32U9YACgkQWt5b1Glr
+6WdMQ/8CEzenz+hQrPakd0yL0Ku17zrTUgliZqFnLtDh1b+utEIrgcZdb7P7Kb4
A/7fUSPfg+pH+E20waT/VitqEeJBJmozsXdRDYl515B+d9Ug7G0cLuSEy7cAPvIh
UmpeUFakLsvncrxh8wOWW8aun50MKPp1Skj0S5bTibzoPw6qaR1r1p0CsTF5cdgC
HUAgPIJRLZylVabRvJCFxwPI1R8HEvidHzURZhd6JsQk8OmYnTSYobGT/k5ox2XJ
sBZuPRmoPF5qwfTJaQwfoZ4NBWI/ce1oqEhvW6k5OV0+ThCc2Nz14eHegU9NDL5M
X/Y3SaMWuJFEdanuaP+AHgWxzsIqfDmPTWK5W4ZWkvrJ5vN+E8pZm5EKTohJoX+7
2RWX/TVX6wv6CJ9YOHpwdGf/MZ79tAFpUjcbVkW16i/EGfU77EYBLJNa+ANr7cqI
CaO71Il7ol2nN+G8iIb0szt3FlxKAPAD+P9jzMOpQV9ITQT6yeGYGCBnlMrnTkks
Wk5LlSqfuNG1WpGwfxelBnMHh76M08/450D8Q16iEX+u1Eu6fTwrQ0/A3o3OMnwP
vsUJf+l1Ebe8zsHDXfoDTwyX47BdXMWs3j7iqyGHUJoEzoocByzZA/wyb78j96hS
WsHJvVxr/GULTzqanzUl99JSE2zuIHbXbWTTL/eG9wrUCYypfl0=
=hMqm
-----END PGP SIGNATURE-----

--kd9uO3yyLTv5jAxAnQUrOTu0ZpLvd4uqK--
