Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A722AA6D6
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 18:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgKGRMi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 12:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgKGRMi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 12:12:38 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BB0C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 09:12:37 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so6354403ejb.7
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 09:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mefBCqtt+AEGxXX9UVnBVdHPsMILydjJdZ3QzZN04CU=;
        b=gisTDcJsYWPLfxyV9BmUquXkH7fFjDUesxvWnku6NwopCeJBiLHugYlDn3n+tS1hTZ
         6S75aoyKYBbI4r3mFUPZcUGVSNtMssdF/ytEs/9c1aBXk1C4jj7h+BYT/Sm4ODPEvEYr
         CgCGPQeyswU7Ihs+NhLGEhueNAZ7O5kB3akc8K9C29TT0Pcz7YSnjjbJtMGkkojX/9/q
         dfub03Gq3tS2aItFJyyQP9BoIUZIlvSTYlsLGYPEltt+BxEF2pshpLl/VQBSgFQWFY7v
         c01olaX5kDgvKTvPaBs9Ma2EkrJ8dhFKi1pgIQbN/ADRgYEeLwjxtogAKnmpT6HF8JQx
         s3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mefBCqtt+AEGxXX9UVnBVdHPsMILydjJdZ3QzZN04CU=;
        b=smKPDQ/YB/MLyd2S7bgj1zSuflDdgALNkx6XlliP7bEVleAnXtqD14p4gGeb9OtJhr
         ycixuv+xwa7CXhimUG/mkLgpBWZ3AqTnVPFUWQm1XeW2EbIrRHi8fFCMhI0H/KOaRSRB
         9fzA6vuAHSrFrFnuxIBOVELBOjg9+CUXKtJgyDOig2JA8nb4OgvuengWpBbmZb0KT329
         L9NfFBDKfxFtIDfCNVY8Ehd+TkxGJ2HM33wQ2ESV8BlCn32iuFu3k8GlfVttMT8Kdeg9
         mdTdmGbmjYG9zXk5IuHlf4qd7e486kdtuXeFdN9mhz+A8oA6PumpyiSsKsTWRrMw5YgB
         4iqg==
X-Gm-Message-State: AOAM531fI3MLLPJwCFih414Yo7pylWN3OjvzBlVYczU7Ekf4UFbD9/qm
        kBEuhfH8ucFjkJzRhXhTJbfuNjAo2HSU2VgWd18Ldg==
X-Google-Smtp-Source: ABdhPJx1EudOHPaWX7bWuO6My+BsLy4ZVihCQK/3vTw7jbuy1zeoR8GHBMcEbBBFN8aOr5mAqzsUcMj5fJRutbWnWcQ=
X-Received: by 2002:a17:906:c407:: with SMTP id u7mr7577889ejz.261.1604769156364;
 Sat, 07 Nov 2020 09:12:36 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhuVfkofDXKaeW4J6Khy2Jp3UcXALQ4SdP9Okk_w7zjNg@mail.gmail.com>
 <7da29ea8-47b6-a122-c16e-83a052e4d0d9@gmail.com>
In-Reply-To: <7da29ea8-47b6-a122-c16e-83a052e4d0d9@gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 7 Nov 2020 17:12:25 +0000
Message-ID: <CAM1kxwhUve61-6L=Vb40xXWip8m578ZYO-Mpb6Ys9x5aiK6LPg@mail.gmail.com>
Subject: Re: allowing msg_name and msg_control
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Nov 7, 2020 at 4:24 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 07/11/2020 14:22, Victor Stewart wrote:
> > RE Jen's proposed patch here
> > https://lore.kernel.org/io-uring/45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk/
>
> Hmm, I haven't seen this thread, thanks for bringing it up
>
> >
> > and RE what Stefan just mentioned in the "[PATCH 5.11] io_uring: don't
> > take fs for recvmsg/sendmsg" thread a few minutes ago... "Can't we
> > better remove these checks and allow msg_control? For me it's a
> > limitation that I would like to be removed."... which I coincidentally
> > just read when coming on here to advocate the same.
> >
> > I also require this for a few vital performance use cases:
> >
> > 1) GSO (UDP_SEGMENT to sendmsg)
> > 2) GRO (UDP_GRO from recvmsg)
>
> Don't know these you listed, may read about them later, but wouldn't [1]
> be enough? I was told it's queued up.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/net/socket.c?id=583bbf0624dfd8fc45f1049be1d4980be59451ff
>

Hadn't seen [1], but yes as long as the same were also implemented for
__sys_sendmsg_sock(). Queued up for.. 5.11?

UDP_SEGMENT allows you to sendmsg a UDP message payload up to ~64K
(Max IP Packet size - IPv4(6) header size - UDP header size).. in
order to obey the existing network stack expectations/limitations).
That payload is actually a sequence of DPLPMTUD sized packets (because
MTU size is restricted by / variable per path to each client). That
DPLPMTUD size is provided by the UDP_SEGMENT value, with the last
packet allowed to be a smaller size.

So you can send ~40 UDP messages but only pay the cost of network
stack traversal once. Then the segmentation occurs in the NIC (or in
the kernel with the NIC has no UDP GSO support, but most all do).

There's also a pacing patch in the works for UDP GSO sends:
https://lwn.net/Articles/822726/

Then UDP_GRO is the exact inverse, so when you recvmsg() you receive a
giant payload with the individual packet size notified via the UDP_GRO
value, then self segment.

These mimic the same optimizations available without configuration for
TCP streams.

Willem discusses all in the below paper (and there's a talk on youtube).
http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf

oh and sorry the title of this should have been sans msg_name.

> >
> > GSO and GRO are super important for QUIC servers... essentially
> > bringing a 3-4x performance improvement that brings them in line with
> > TCP efficiency.
> >
> > Would also allow the usage of...
> >
> > 3) MSG_ZEROCOPY (to receive the sock_extended_err from recvmsg)
> >
> > it's only a single digit % performance gain for large sends (but a
> > minor crutch until we get registered buffer sendmsg / recvmsg, which I
> > plan on implementing).

and i just began work on fixed versions of sendmsg / recvmsg. So i'll
distribute that patch for initial review probably this week. Should be
fairly trivial given the work exists for read/write.

> >
> > So if there's an agreed upon plan on action I can take charge of all
> > the work and get this done ASAP.
> >
> > #Victor
> >
>
> --
> Pavel Begunkov
