Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A0C2DFB16
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 11:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgLUKcn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 05:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgLUKcm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 05:32:42 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C24C0613D3
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 02:32:02 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id q137so8362738iod.9
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 02:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x2HHeAi0kSMAt1nx+ypQxUJBzptxM5Oe50KiiJTBx7k=;
        b=BuHG8JUIUQbKaQjeBaOi+sb+KDz+nMT1ISN+k1nCmmoa8GDHZxTGS3Ed53YpT/nv9b
         T1XSMTniYPx72nyLsdXcNfszIC0MMqOFMkHaiOpBpW48xLpkzHw6puJuyuCSU+ShfzoO
         qTlFd/N0S9Akub+9bFON8hvdCCTTSdNbM8hr/yJA75w4Z7VSH6oOWwE97yXocUBWSu+Y
         f6YkSX8FUqlX5zEEiJO1CFVVB++R8yW5HVLRg9SEPxYHXS2eylTerOw6sZljEMEGM/Tk
         JmBgCeat44m21PVNyp9hpihcBC5pXs0yukiHSQpdLWgFjRyrlF/tU1vyFz4nsrxs1LQv
         Ftwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x2HHeAi0kSMAt1nx+ypQxUJBzptxM5Oe50KiiJTBx7k=;
        b=m1mm8FdBFXG6z0c7kH3FGgfgSA6gRmrrRMR4qABtIqUhgdgi8I/W2MrJtcXPDgsdqE
         Qinn/exdBahwyN4ix0gxtyBK8LXKwpWSJbq7b1mh6pzP7OXd00paeFspGN8lzLZm695Q
         87BvEA9VRbNTBdzfq2bwssA60Szzc9P3wTatplsciQMJGI/fL6SSLzRKChryGkoDKBrp
         fCNg203gueJNgGPAMx50saENgsMHZNVJlKzVjgeVsXdtJbDWXKu3CidoVPi94VuieGNW
         MQakqd2lLH737VeUcBzHNDK5z7kqPEkTYPH9TzqqDYg4dap/B2RZjkZZSES7TLw+A7Mw
         bsXg==
X-Gm-Message-State: AOAM530CvknJDH/ExQiTLqqdaBdypye6bOBORVoHEgHjvZyC3X2AZvuz
        yMoZJ1Ws7CIiORCbaGcRzzu90pV2WllsnBkPG28=
X-Google-Smtp-Source: ABdhPJxA0hFUKmikLOw2MDvo+2BmZDI9HsVnfVLcJTSpMaKXcYlsXqi13yMc8zLveSwYaO/p8VVt9jPZqsFQj7r3f3M=
X-Received: by 2002:a5d:9d42:: with SMTP id k2mr13446393iok.151.1608546721789;
 Mon, 21 Dec 2020 02:32:01 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk> <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
 <caca825c-e88c-50a6-09a8-c4ba9d174251@kernel.dk> <CAAss7+rwgjo=faKi2O7mUSJTWrLWcOrpyb7AESzaGw+_fWq1xQ@mail.gmail.com>
 <159a8a38-4394-db3b-b7f2-cc26c39caa07@kernel.dk> <37d4d1fa-a512-c9d0-eaa6-af466adc2a4e@kernel.dk>
 <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
In-Reply-To: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 21 Dec 2020 17:31:51 +0700
Message-ID: <CAOKbgA7NAFcrELjX0A5aE9X7MHgSVeOZuvHywGB_oCHs=C-Hxw@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josef <josef.grieb@gmail.com>, io-uring <io-uring@vger.kernel.org>,
        Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Dec 20, 2020 at 12:11 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/19/20 9:29 AM, Jens Axboe wrote:
> > On 12/19/20 9:13 AM, Jens Axboe wrote:
> >> On 12/18/20 7:49 PM, Josef wrote:
> >>>> I'm happy to run _any_ reproducer, so please do let us know if you
> >>>> manage to find something that I can run with netty. As long as it
> >>>> includes instructions for exactly how to run it :-)
> >>>
> >>> cool :)  I just created a repo for that:
> >>> https://github.com/1Jo1/netty-io_uring-kernel-debugging.git
> >>>
> >>> - install jdk 1.8
> >>> - to run netty: ./mvnw compile exec:java
> >>> -Dexec.mainClass="uring.netty.example.EchoUringServer"
> >>> - to run the echo test: cargo run --release -- --address
> >>> "127.0.0.1:2022" --number 200 --duration 20 --length 300
> >>> (https://github.com/haraldh/rust_echo_bench.git)
> >>> - process kill -9
> >>>
> >>> async flag is enabled and these operation are used: OP_READ,
> >>> OP_WRITE, OP_POLL_ADD, OP_CLOSE, OP_ACCEPT
> >>>
> >>> (btw you can change the port in EchoUringServer.java)
> >>
> >> This is great! Not sure this is the same issue, but what I see here is
> >> that we have leftover workers when the test is killed. This means the
> >> rings aren't gone, and the memory isn't freed (and unaccounted), which
> >> would ultimately lead to problems of course, similar to just an
> >> accounting bug or race.
> >>
> >> The above _seems_ to be related to IOSQE_ASYNC. Trying to narrow it
> >> down...
> >
> > Further narrowed down, it seems to be related to IOSQE_ASYNC on the
> > read requests. I'm guessing there are cases where we end up not
> > canceling them on ring close, hence the ring stays active, etc.
> >
> > If I just add a hack to clear IOSQE_ASYNC on IORING_OP_READ, then
> > the test terminates fine on the kill -9.
>
> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
> file descriptor.

In our case - unlike netty - we use io_uring only for disk IO, no eventfd. And
we do not use IOSQE_ASYNC (we've tried, but this coincided with some kernel
crashes, so we've disabled it for now - not 100% sure if it's related or not
yet).

I'll try (again) to build a simpler reproducer for our issue, which is probably
different from the netty one.

-- 
Dmitry Kadashev
