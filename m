Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A5815672B
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 19:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHSmP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 13:42:15 -0500
Received: from mail-lf1-f45.google.com ([209.85.167.45]:42874 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBHSmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 13:42:15 -0500
Received: by mail-lf1-f45.google.com with SMTP id y19so1462749lfl.9
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 10:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dTN5asbuLmjOCGk1ftMo2pAG8oxcb0hwfMkVR4m1Xr4=;
        b=gktp3m/pa08siEipEnaCxBdlDPMgQ4CYQg2HidNf2K3JGElwngryH6eXPiXODLAV74
         KcvVQ6UMh6Yh0weFGkiRi35Kmy8iVIq0S9E8i6njLVlP21pqn1X0urhRl7zn7ziB3y/u
         uX7Qi6AMm4eeZC5MoVQxyj46kL0gryJmnnjA/mssnsapqxlGXGpEpsCX1pKUJzDhO55B
         Rcnl3O/ELDXmI+cdlBkhlg0PVzjs8tJ0eomCFeOG6AyI66T9hFwtR2ukzzyhK5yP9PY5
         N82Y+VQzhUnpfl83EBRpoV1F2fn6YPEu1KoSw5n3LLuTQhfpzn9rqYew9hn3D/RCfGHM
         1mSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dTN5asbuLmjOCGk1ftMo2pAG8oxcb0hwfMkVR4m1Xr4=;
        b=U2E/+DAV3tkxMwoJjSjpA0xk+vwOzhw55mWzGfm9WaXIr8MnL40DZ3N2JQLv4WimJT
         ZAtdJ2eDqj2Vs+AsqjSbxkJLNfEBAGCoiO1VdXhR92BEsYKEu0NGtc/Apklgy8yDj++I
         9/iukTYXa8qFTwP4HIFoB/lxN/d4vIWtCKtJKhNGhoNpE1STXMTKBDIFsC7O5OgOptf1
         A0a4eR5SBgeIqoaSZPhyrJ88MRa505O1DbQRIpZTqOigZFZxo+2J4lwmTl4M7E/fu66q
         SeZ8kfnAcI+Dne7ldCdvRZJz/v+8UvefsxH1mHthLW+uzLufX7VL4s5CA+4IGF/NCbZX
         nkAA==
X-Gm-Message-State: APjAAAWwA6bLjPalVIOTnW6d7FV74aUaaN+zRhlHbcNHfh8ylTRou1uL
        q9DojnLdAf0/tKIIfiwno0hyP3/uP5nl7xVFjqrrqQ==
X-Google-Smtp-Source: APXvYqyufMv/qPhpR/xahYrf5XrnXRSXbxu0u5xMjsJD+iMcGU+z3WLJTcLKOPbsiZKylSrBQOsHal0TW8Y0UhbmocA=
X-Received: by 2002:a19:c210:: with SMTP id l16mr2421034lfc.35.1581187333396;
 Sat, 08 Feb 2020 10:42:13 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
 <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com>
In-Reply-To: <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Sat, 8 Feb 2020 13:42:02 -0500
Message-ID: <CAD-J=zbMcPx1Q5PTOK2VTBNVA+PQX1DrYhXvVRa2tPRXd_2RYQ@mail.gmail.com>
Subject: Re: shutdown not affecting connection?
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi

BTW, my apologies but I should have specified the kernel I am running:
90206ac99c1f25b7f7a4c2c40a0b9d4561ffa9bf

On Sat, Feb 8, 2020 at 9:26 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Hi
>
> On 2/8/2020 4:55 PM, Glauber Costa wrote:
> > Hi
> >
> > I've been trying to make sense of some weird behavior with the seastar
> > implementation of io_uring, and started to suspect a bug in io_uring's
> > connect.
> >
> > The situation is as follows:
> >
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
> > - if the SQE *does not* have the IOSQE_ASYNC flag on, then most of the
> > time the test works as intended and connect() returns 104, but
> > occasionally it hangs too. Note that, seastar may choose not to call
> > io_uring_enter immediately and batch sqes.
> >
> > Sounds like some kind of race?
> >
> > I know C++ probably stinks like the devil for you guys, but if you are
> > curious to see the code, this fails one of our unit tests:
> >
> > https://github.com/scylladb/seastar/blob/master/tests/unit/connect_test.cc
> > See test_connection_attempt_is_shutdown
> > (above is the master seastar tree, not including the io_uring implementation)
> >
> Is this chaining with connect().then_wrapped() asynchronous? Like kind
> of future/promise stuff?

Correct.
then_wrapped executes eventually when connect returns either success or failure

> I wonder, if connect() and shutdown() there may
> be executed in the reverse order.

The methods connect and shutdown will execute in this order.
But connect will just queue something that will later be sent down to
the kernel.

I initially suspected an ordering issue on my side. What made me start
suspecting a bug
are two reasons:
- I can force the code to grab an sqe and call io_uring_enter at the
moment the connect()
call happens : I see no change.
- that IOSQE_ASYNC changes this behavior, as you acknowledged yourself.

It seems to me that if shutdown happens when the sqe is sitting on a
kernel queue somewhere
the connection will hang forever instead of failing right away as I would expect
- if shutdown happens after the call to io_uring_enter
>
> The hung with IOSQE_ASYNC sounds strange anyway.
>
>
> > Please let me know if this rings a bell and if there is anything I
> > should be verifying here
> >
>
> --
> Pavel Begunkov
