Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8414732D15
	for <lists+io-uring@lfdr.de>; Fri, 16 Jun 2023 12:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245465AbjFPKJG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Jun 2023 06:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245519AbjFPKIb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Jun 2023 06:08:31 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33D12D6B
        for <io-uring@vger.kernel.org>; Fri, 16 Jun 2023 03:07:40 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-62ff6cf5af0so5784126d6.0
        for <io-uring@vger.kernel.org>; Fri, 16 Jun 2023 03:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686910060; x=1689502060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rX1gvzyEya/uOPcDeC+15t9Pczr3MTyuuFUiLbYTj08=;
        b=hWxs9abze3s9dxRv2LaxkefzxFqlUwsHLpdgLpft5lK+fM+oK4gCZC+jOZyyyGugIF
         x2IyzzI3A1DBRnJ4bh4AWnAHl7vuAYB9CFxLndn+EdnFNsV7cVe+twrl5GisdSPjmVqI
         LHAticZm2O9PhH8B/o11MBo2RkXpacQMHnkR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686910060; x=1689502060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rX1gvzyEya/uOPcDeC+15t9Pczr3MTyuuFUiLbYTj08=;
        b=Z+iOWVeOqcD15X8reHDTJCLDNojPpsOKJr/p5PsKms6lP0c0L/fjAQjm3QDSQ3w3IL
         uLvDxLk9OQ5zYahd2yJXDAIzfdwtnET1pm4ube3yHioB1quTj2IBqSbx+WJnBej7YqXW
         kakQwW3B47VdkghoI2k/nmD+AYPk9EdfpYKGQ8/ZwR7Ez935Llo9kvrmd7m5S345f/TF
         Xzgi/SJKeKJAVH32Wo04L6GTiq3dwecV1qepuMFwoDMf387muU65ZXoO7KRnT4y+f5I9
         BDUb+HJVxz3zHCU1koQvIU0SGzTRddsiiHsGstFcE3ZB1Q8z72x82UDmqyBFi/ziaIF3
         SgRg==
X-Gm-Message-State: AC+VfDwAbzeWNBhr5FS9CRG9Q4rtGHerUt0xNEhqkFm+O2ZDaoywgeud
        awvbS7YTT6zD6kC9i1r90/jLGj8NWEG4/j/5Idi/vg==
X-Google-Smtp-Source: ACHHUZ5YuQe4oAP1+oLSzDEVeAoZLTzwIC0lcbbmELcqZR2kp1drTxRYh7feqi1uDvd2UBBm2L7/h6jCahVgv+HbS7g=
X-Received: by 2002:a05:6214:e8a:b0:621:331b:f55d with SMTP id
 hf10-20020a0562140e8a00b00621331bf55dmr2129088qvb.19.1686910059929; Fri, 16
 Jun 2023 03:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAJPywTLDhb5MkYS7PTi7=sXwm=5r9AbPKz3fDq4XGbqKvA-g=A@mail.gmail.com>
 <fee91f15-ad08-1687-3f3e-43a91ec45d40@kernel.dk>
In-Reply-To: <fee91f15-ad08-1687-3f3e-43a91ec45d40@kernel.dk>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Fri, 16 Jun 2023 12:07:29 +0200
Message-ID: <CAJPywTKxfVo2x6X6DQr5prdE=3TpVwz_cB8pcDGKaJGNU5orNQ@mail.gmail.com>
Subject: Re: io-wrk threads on socket vs non-socket
To:     Jens Axboe <axboe@kernel.dk>,
        kernel-team <kernel-team@cloudflare.com>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 14, 2023 at 6:03=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/14/23 8:09?AM, Marek Majkowski wrote:
> > Hi!
> >
> > I'm playing with io-uring, and I found the io-wrk thread situation conf=
using.
> >
> > (A) In one case, I have a SOCK_DGRAM socket (blocking), over which I
> > do IORING_OP_RECVMSG. This works well, and unless I mark the sqe as
> > IOSQE_ASYNC, it doesn't seem to start an io-wrk kernel thread.
> >
> > (B) However, the same can't be said of another situation. In the
> > second case I have a tap file descriptor (blocking), which doesn't
> > support "Socket operations on non-socket", so I must do
> > IORING_OP_READV. This however seems to start a new io-wrk for each
> > readv request:
> >
> > $ pstree -pt `pidof tapuring`
> > tapuring(44932)???{iou-wrk-44932}(44937)
> >                 ??{iou-wrk-44932}(44938)
> >                 ??{iou-wrk-44932}(44939)
> >                 ??{iou-wrk-44932}(44940)
> >                 ??{iou-wrk-44932}(44941)
> >                 ??{iou-wrk-44932}(44942)
> >
> > I would expect both situations to behave the same way.
> >
> > The manpage for IOSQE_ASYNC:
> >
> >        IOSQE_ASYNC
> >               Normal operation for io_uring is to try and issue an sqe
> >               as non-blocking first, and if that fails, execute it in a=
n
> >               async manner. To support more efficient overlapped
> >               operation of requests that the application knows/assumes
> >               will always (or most of the time) block, the application
> >               can ask for an sqe to be issued async from the start. Not=
e
> >               that this flag immediately causes the SQE to be offloaded
> >               to an async helper thread with no initial non-blocking
> >               attempt.  This may be less efficient and should not be
> >               used liberally or without understanding the performance
> >               and efficiency tradeoffs.
> >
> > This seems to cover the tap file descriptor case. It tries to readv
> > and when that fails a new io-wrk is spawned. Fine. However, as I
> > described it seems this is not true for sockets, as without
> > IOSQE_ASYNC the io-wrk thread is _not_ spawned there?
> >
> > Is the behaviour different due to socket vs non-socket or readv vs
> > recvmsg?
>
> What kernel are you using? tap just recently got FMODE_NOWAIT support,
> which should trigger poll instead of needing to spawn an io worker.
>
> Also, as usual, a test case would be appreciated. Particularly if this
> is on a current kernel where we would not expect to see io-wq activity
> for a read of tap.


After two days I think I finally have some repro. Let's track this
particular tap io-wrk issue under
https://github.com/axboe/liburing/issues/886

I can confirm that indeed (apart form the mentioned bug) tap is going
into poll mode, and doesn't launch io-wrk.

However, I still miss a piece of the puzzle about io-wrk polling.

Let's assume a different situation, let's say I have a dozen of
sockets, and do a recvmsg on each of them, with IOSQE_ASYNC flag set.

I would expect to see a dozen of io-wrk threads, however I'm not fully
understanding what will they do. Will each do a full poll() over all
the sockets? If a packet arrives to one socket, will all the io-wrk
threads wakeup? What if there is a limit of 2 io-wrk threads and there
are more sockets?

I think I'm asking about the relationship between SQE's / sockets and
io-wrk poller.

Marek
