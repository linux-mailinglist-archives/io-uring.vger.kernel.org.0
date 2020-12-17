Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBD42DCD9D
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 09:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgLQI1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 03:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbgLQI1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 03:27:42 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9128C0617B0
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:27:01 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q18so18147520wrn.1
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=3Xgjy8ZnYjodrBr9uJot0i+teSDpfRVqCqsyqo0v45M=;
        b=pNoVnCrOaaCb7XSFRWj0PuQZfY7WziHE5wXcq/EbNd1BFTr/eWVUY0A56GsUUoUQxW
         PzAXVN7Jlr+XXUXoqSkJtZABAgWHoUVmyZELWdwNMQpeQBMrXGyAKCBcgsh5GLCsMGAE
         wlkKLfbvoWOMEsZkHBSWX4Q/TW9N1dBgJ0mkMoHxDTQrQ2L1oqOOOkVLfLtFoPN25hHF
         YC5lb/+3KKj+7GnKt3nk60Xsm0bGT16phMhAYYQ8OlOT4eL3UJboWXHWNZtGelFsDga4
         WxJcDQGjWTEUG6we1LCOxT3NH71/2dgxVhRthqEhn9DTUcYX3zxnMZf2N4QoqufDPS0e
         5X7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=3Xgjy8ZnYjodrBr9uJot0i+teSDpfRVqCqsyqo0v45M=;
        b=aImp1PE8JzuL/y701t1EaGv8w+7AoRITh7C2PQ+CbZkwpSZ4AlOXveHd6RnudBNDoK
         6jaNrIzBc6fCjX8CkpUsHRmijRzd/haQU2oWBZ7P3famgX/vf34jLUnuE8olCsvsCZfY
         ar4BdNsn36nr6+Aux0lJfq9BKxnUNgpXMnHkKsle7Po8ZuXkMp8qYhtvwmXiHHbk2t/W
         iwEcBb6BQ/M7TJpOOdm6c0Xsm6ZV3wZY1gX3WBi+qfss1AJduLyh5NHoJxeWe3IHRcMe
         fofMjAE8lqvWDAKL27meCL997KG+1zNg9XgxdyNVWB3hJwg3ksH/rjvZ5kccAW0FF+1O
         YbHQ==
X-Gm-Message-State: AOAM5325JK4XmK4gAD3q5Y8nq7gwEUeMqgSjJbdhaeF6YAtH+8cWNrAz
        lYxpkvTdvtalkmGVth5gvYo=
X-Google-Smtp-Source: ABdhPJwfP+unrSdCupd1RdxsCwF/vCm2Ck+VucMA29kpsTaqrUWhyOfQcVjhP1mPWVMwnks6T/Xe6A==
X-Received: by 2002:adf:84c1:: with SMTP id 59mr27263729wrg.409.1608193620454;
        Thu, 17 Dec 2020 00:27:00 -0800 (PST)
Received: from macbook-pro.lan (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.googlemail.com with ESMTPSA id c1sm6405986wml.8.2020.12.17.00.26.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Dec 2020 00:26:59 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
From:   Norman Maurer <norman.maurer@googlemail.com>
In-Reply-To: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
Date:   Thu, 17 Dec 2020 09:26:58 +0100
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com>
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I wonder if this is also related to one of the bug-reports we received:

https://github.com/netty/netty-incubator-transport-io_uring/issues/14


> On 17. Dec 2020, at 09:19, Dmitry Kadashev <dkadashev@gmail.com> =
wrote:
>=20
> Hi,
>=20
> We've ran into something that looks like a memory accounting problem =
in the
> kernel / io_uring code. We use multiple rings per process, and =
generally it
> works fine. Until it does not - new ring creation just fails with =
ENOMEM. And at
> that point it fails consistently until the box is rebooted.
>=20
> More details: we use multiple rings per process, typically they are =
initialized
> on the process start (not necessarily, but that is not important here, =
let's
> just assume all are initialized on the process start). On a freshly =
booted box
> everything works fine. But after a while - and some process restarts -
> io_uring_queue_init() starts to fail with ENOMEM. Sometimes we see it =
fail, but
> then subsequent ones succeed (in the same process), but over time it =
gets worse,
> and eventually no ring can be initialized. And once that happens the =
only way to
> fix the problem is to restart the box.  Most of the mentioned restarts =
are
> graceful: a new process is started and then the old one is killed, =
possibly with
> the KILL signal if it does not shut down in time.  Things work fine =
for some
> time, but eventually we start getting those errors.
>=20
> Originally we've used 5.6.6 kernel, but given the fact quite a few =
accounting
> issues were fixed in io_uring in 5.8, we've tried 5.9.5 as well, but =
the issue
> is not gone.
>=20
> Just in case, everything else seems to be working fine, it just falls =
back to
> the thread pool instead of io_uring, and then everything continues to =
work just
> fine.
>=20
> I was not able to spot anything suspicious in the /proc/meminfo. We =
have
> RLIMIT_MEMLOCK set to infinity. And on a box that currently =
experiences the
> problem /proc/meminfo shows just 24MB as locked.
>=20
> Any pointers to how can we debug this?
>=20
> Thanks,
> Dmitry

