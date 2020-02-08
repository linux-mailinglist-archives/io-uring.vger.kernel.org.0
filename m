Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F381156737
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 19:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBHS5y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 13:57:54 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32956 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbgBHS5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 13:57:54 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so1508050lfl.0
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 10:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LxhpoQ2YPpKmA0zdfCoNLIQWTM0Kd5Y9+NxWuo++B4c=;
        b=bQVeEz/mwhThuSosv2jCGjBSfDcLawBiv4EI8z9xO/mMw8rbsam2ndC1IOejbQzZDc
         1MQjkWvENmQ9LKldC/AgvapZf9gTqbe7b/7b+pFIpsW4bDVwIVc8NPhXgB9XZHJV6NKV
         Fbn0PNeEx3Li5ewhvahUpsbZQOxBZjdYveuFgKZUB9U4vczDZ/ZYCT5YBgZzQU4dnI/z
         jmI10315RBGldbfqZPWkt7TOoo+2Dt9qowKbfdLkMfKFSXkMFU0IsuSKDCIM3gClM0hv
         YS/gPrBY+j7azKUnqMiBi7NPP4xMHia/h3WAsurcBummO2kFYQDlvQ83/8n8dnoVpUCp
         a4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LxhpoQ2YPpKmA0zdfCoNLIQWTM0Kd5Y9+NxWuo++B4c=;
        b=dR5Wy5M4kymjnegsRVFj3MOD4J6TUPvvi+Zkn27hSiysIe95P1uBZekX9vNT3g9sxW
         Z6pNOHo+bWHP32dJijhySuNPYa5gx36ANgK7ES8w8Wd5IPmEJueF+DGJAsbS2145VF/R
         dqvAmEVHMXmV+0NTndAbyyHnzzafBClNBTtiL3YQ9W4Sjht5a0KNbpy2p5WhpzoevEdG
         kBAohn1Eoj/N6+tmCqcH0pyVfs71cZ3ZTT5yVwPaiPrID8doMMaSwfGPM7V+iHO37dsH
         sa6Jc9KfDh3HIdq7b58pVpKCNsdcxmcwDMPydZh8AjDCgb8yqBJJLxkCjEr2yhI4pQoG
         8Zhw==
X-Gm-Message-State: APjAAAUgatyKE69IUOMhIRYZQ+7XmzWljo0xMvCV7hNj7g79Hm4SnZHt
        8SQuh7rdL4lpXvsBZ23ZjkTNUd1O4EeOKfFwUSk40Q==
X-Google-Smtp-Source: APXvYqyt42phEuadX3RdCPs6GqV0jKR97Vt9OqUic/RAHpiarDh0yTVaBbXBxoLJ1BfEG27Tkntp0pyYa6ByVljXJGg=
X-Received: by 2002:a19:9d5:: with SMTP id 204mr2460090lfj.120.1581188269931;
 Sat, 08 Feb 2020 10:57:49 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
 <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com> <CAD-J=zbMcPx1Q5PTOK2VTBNVA+PQX1DrYhXvVRa2tPRXd_2RYQ@mail.gmail.com>
 <9ec6cbf7-0f0b-f777-8507-199e8837df94@scylladb.com>
In-Reply-To: <9ec6cbf7-0f0b-f777-8507-199e8837df94@scylladb.com>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Sat, 8 Feb 2020 13:57:38 -0500
Message-ID: <CAD-J=zZm2B8-EXiX8j2AT5Q0zTCi5rB1gQzzOaYi3JoO1jcqOw@mail.gmail.com>
Subject: Re: shutdown not affecting connection?
To:     Avi Kivity <avi@scylladb.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 8, 2020 at 1:48 PM Avi Kivity <avi@scylladb.com> wrote:
>
> On 2/8/20 8:42 PM, Glauber Costa wrote:
> > Hi
> >
> > BTW, my apologies but I should have specified the kernel I am running:
> > 90206ac99c1f25b7f7a4c2c40a0b9d4561ffa9bf
> >
> > On Sat, Feb 8, 2020 at 9:26 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> Hi
> >>
> >> On 2/8/2020 4:55 PM, Glauber Costa wrote:
> >>> Hi
> >>>
> >>> I've been trying to make sense of some weird behavior with the seastar
> >>> implementation of io_uring, and started to suspect a bug in io_uring's
> >>> connect.
> >>>
> >>> The situation is as follows:
> >>>
> >>> - A connect() call is issued (and in the backend I can choose if I use
> >>> uring or not)
> >>> - The connection is supposed to take a while to establish.
> >>> - I call shutdown on the file descriptor
> >>>
> >>> If io_uring is not used:
> >>> - connect() starts by  returning EINPROGRESS as expected, and after
> >>> the shutdown the file descriptor is finally made ready for epoll. I
> >>> call getsockopt(SOL_SOCKET, SO_ERROR), and see the error (104)
> >>>
> >>> if io_uring is used:
> >>> - if the SQE has the IOSQE_ASYNC flag on, connect() never returns.
> >>> - if the SQE *does not* have the IOSQE_ASYNC flag on, then most of the
> >>> time the test works as intended and connect() returns 104, but
> >>> occasionally it hangs too. Note that, seastar may choose not to call
> >>> io_uring_enter immediately and batch sqes.
> >>>
> >>> Sounds like some kind of race?
> >>>
> >>> I know C++ probably stinks like the devil for you guys, but if you are
> >>> curious to see the code, this fails one of our unit tests:
> >>>
> >>> https://github.com/scylladb/seastar/blob/master/tests/unit/connect_test.cc
> >>> See test_connection_attempt_is_shutdown
> >>> (above is the master seastar tree, not including the io_uring implementation)
> >>>
> >> Is this chaining with connect().then_wrapped() asynchronous? Like kind
> >> of future/promise stuff?
> > Correct.
> > then_wrapped executes eventually when connect returns either success or failure
> >
> >> I wonder, if connect() and shutdown() there may
> >> be executed in the reverse order.
> > The methods connect and shutdown will execute in this order.
> > But connect will just queue something that will later be sent down to
> > the kernel.
> >
> > I initially suspected an ordering issue on my side. What made me start
> > suspecting a bug
> > are two reasons:
> > - I can force the code to grab an sqe and call io_uring_enter at the
> > moment the connect()
> > call happens : I see no change.
> > - that IOSQE_ASYNC changes this behavior, as you acknowledged yourself.
> >
> > It seems to me that if shutdown happens when the sqe is sitting on a
> > kernel queue somewhere
> > the connection will hang forever instead of failing right away as I would expect
> > - if shutdown happens after the call to io_uring_enter
>
>
>
> You can try to cancel the sqe before you shutdown the socket. This will
> flush the queue (even if the cancellation fails).
>
>
> However, if you io_uring_enter before calling shutdown and connect does
> not return, I'd consider that a kernel bug.

That is very definitely what it happens, since I've changed the code
to do it synchronously
(with our flush() implementation, which will loop until an sqe can be
acquired and io_uring_enter
returns success), so at this point I am sure this is in the kernel.




> Perhaps you can reduce the
> problem to a small C reproducer?
>
That was my intended next step, yes
>
