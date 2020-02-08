Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8C156736
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 19:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHSyP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 13:54:15 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:43519 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBHSyP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 13:54:15 -0500
Received: by mail-lj1-f174.google.com with SMTP id a13so2713034ljm.10
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 10:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KLkeUcmb5oRgUpWnIoszsWdN6wwn8czYyV/+X8vTzhQ=;
        b=Uh+R2vZ8C5+2wsx/CgHMlB2Rxba3TtFW9VPRE4BxmKzYrUWmb+9wrFndVKE2C2YfwH
         bcfJK/pXEzmC+/q+OoftDpgjg7kXnz6AmQvcusN+emGJUrMWJ67RZaQg1FcYLrf5sFUP
         4EUHIkiyQ1he2+exu8TKwS0G0ZirFVXEql15NGX81VFtsIc8h/2l92DUQ+j4jhGMTGdL
         /3Us2zWvqQa8qEfBJ8yr2mMoiPdDXJ/g9EoUJGy04fiQkkQb48LNHuXEynPYIiqsuP9B
         9DiL5ub5iH7CEjAh0BYJDTQVZ7eO/jaiFlsoeOfTwhqP7AnwfVqN/Gos32jDL8uA2HIK
         ZP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KLkeUcmb5oRgUpWnIoszsWdN6wwn8czYyV/+X8vTzhQ=;
        b=muJUENYfYnKLCrsSgJW02MJPgM/3QSDVgGknzmpFm+0O84hArDMQPkw1zO7FBYabY1
         AcYa4YKV5iO5nxbOah6/ZBArhRQlMuMux58Bx0AaCiVOsKjxLsG3qpC8fJL4y9J4h/md
         Rvdd12dI+DYi42vEw+N7sSx7268fB6TYHiL8h6/z0JAchVUG4sWH2ZVKDGARTE6Sq6S9
         Nhy21BchSB+IUDMOwNAcX7hVxdsDEU6H15oHS8FJGbb2cge3DeoNucCUJYgvt1NT62jL
         0CT7CsF4drJ2hyr2s9fIX7Q7va+6WRcoI8M+zPVF6kbpCTVRfh2Js1PNnOE4NohYc1Jq
         ofmA==
X-Gm-Message-State: APjAAAUrh2O5gp7VL5Qh+DX1RG8sVKSm7Lka8xn9Sck19eSuaytr1kXr
        61tR6GxK+olsz926kzjEyvoIDr6eAcdbrWjpSLCRaQ==
X-Google-Smtp-Source: APXvYqwFh7J8iFBPw+5gw3LVb+rVRW+9pGIuBAmB4807i9xZLlMNicH1px7L9HLu2E2u9CSbXncJWeTNHXkaB7JqM5U=
X-Received: by 2002:a2e:3514:: with SMTP id z20mr3279834ljz.261.1581188052955;
 Sat, 08 Feb 2020 10:54:12 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
 <20200208184808.jxrnsl3xyoj7io6c@alap3.anarazel.de>
In-Reply-To: <20200208184808.jxrnsl3xyoj7io6c@alap3.anarazel.de>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Sat, 8 Feb 2020 13:54:01 -0500
Message-ID: <CAD-J=zZUqy1+szg9TyqJzRXg_wPYWWtfYKL3t03S0-Jzi3RJdQ@mail.gmail.com>
Subject: Re: shutdown not affecting connection?
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 8, 2020 at 1:48 PM Andres Freund <andres@anarazel.de> wrote:
>
> Hi,
>
> On 2020-02-08 08:55:25 -0500, Glauber Costa wrote:
> > - A connect() call is issued (and in the backend I can choose if I use
> > uring or not)
> > - The connection is supposed to take a while to establish.
> > - I call shutdown on the file descriptor
> >
> > If io_uring is not used:
> > - connect() starts by  returning EINPROGRESS as expected, and after
> > the shutdown the file descriptor is finally made ready for epoll. I
> > call getsockopt(SOL_SOCKET, SO_ERROR), and see the error (104)
> >
> > if io_uring is used:
> > - if the SQE has the IOSQE_ASYNC flag on, connect() never returns.
>
> That should be easy enough to reproduce without seastar as it sounds
> deterministic - how about modifying liburing's test/connect.c test to
> behave this way?

My plan was to work on that on Monday, but I wanted to get the message
earlier in case it was a known issue or rang an obvious bell. It seems like it's
not, so I'll stick to my plan.

>
> Hm, any chance you set O_NONBLOCK on the fd, before calling the async
> connect?
>
In fact I do the opposite, and I force-remove the O_NONBLOCK flag.

But I actually played around with it while chasing this, and I did, at
some point
set O_NONBLOCK.

This is what the seastar code for connect (without uring) looks like:

// socket is non-block here
    pfd->get_file_desc().connect(sa.u.sa, sa.length());
    return pfd->writeable().then([pfd]() mutable {
        auto err = pfd->get_file_desc().getsockopt<int>(SOL_SOCKET, SO_ERROR);
        if (err != 0) {
            throw std::system_error(err, std::system_category());
        }
        return make_ready_future<>();
    });

So it essentially issues a nonblock connect, writes for the fd to be
writeable, and then uses getsockopt to figure out what happened.

With io_uring, what I see on an unblocked socket is:
- it returns EINPROGRESS as I would expect
- it is not ever made writeable.




> Wonder if io_connect()
>         file_flags = force_nonblock ? O_NONBLOCK : 0;
>
>         ret = __sys_connect_file(req->file, &io->connect.address,
>                                         req->connect.addr_len, file_flags);
>         if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
> fully takes into account that __sys_connect_file
>         err = sock->ops->connect(sock, (struct sockaddr *)address, addrlen,
>                                  sock->file->f_flags | file_flags);
> appears to leave O_NONBLOCK set on the file in place, which'd then
> not block in the wq?
>

Isn't not-block the exact opposite of I am seeing ?
If this was really not blocking, I'd expect that to return me
something immediately, even if it was the wrong thing

> Greetings,
>
> Andres Freund
