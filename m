Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A22B36FD68
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 17:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhD3PMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 11:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhD3PMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 11:12:46 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6AEC06174A;
        Fri, 30 Apr 2021 08:11:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x2so4680465lff.10;
        Fri, 30 Apr 2021 08:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4XAE3TlEyF9fA4m3YMw+2jvC4+14CWS6gkqAplYmdk=;
        b=kgb5MnVXCrQeptQyCf2PPt/HryccLSOVl5xJax2QZe2DvhmR53i+WAw6ZhidJ6KWvz
         Zirmc299HvsXIOP4kKoZI+jgIaqB9zvhQJlCLqWG8Bv/k6cos2zcVk0FBVzgMm1IBNYb
         2rAS5aAgWKFTvQhBM9ml6t6M84eRLtbjLz3j5EgZjm9fBWu7u7JXzJC+8CGnziYbvJee
         TaFjA5HrepyE4xNAPDyULQ/4YyL4YgM1RnAgsO+DpirxQ3w8Ngaclhxv+etPOLksNMCd
         zbIC4YKoTzfHmk6svVcGn8HntNXriwNvO7uZBElaw9EcZ4/iuv4RzcYIKQ7f30PKfVp8
         3M1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4XAE3TlEyF9fA4m3YMw+2jvC4+14CWS6gkqAplYmdk=;
        b=HmPbyCpKemyGUhTbOWfnzHFbkuJpWx5PfHjPIczBbf1YhtAg9rRprihUb8ITgBf9EI
         OxgVWiOxym9vc0VlrSlTVFzhVwetI5xkQaYFy4lF3BcfNUn6DRdzz3MgIHHnNAX+gavB
         pWU+YFWqQJj8PfrFkbWvD68kmB8zmT1qevwXfO+eOucXvuRilEXvn6D3XGG9939tCsFh
         TBujwu5Z4m3ZcxTifQJQujGfz0BhYu/KB8g+fS8L3ess4z0ijRQQ1LcWgPXc2V04DZ3a
         sCADKIkl8kP220D764Te48pMlpXFW3WP+AuaXraCo/1GO3o6Mh8NNLyxRFxwwJzAR6cB
         Sa1g==
X-Gm-Message-State: AOAM533GN5dSABnasLqBTLqmRccGfKQOBelroxVkxbJNsp69M9SWPgz5
        5d3k8Rr0aYvcbxnRtKHFqHt2KfkTNSNN32WXJaE=
X-Google-Smtp-Source: ABdhPJzvAMchvkMNSOX0H33boDmHIaru7yPnDVUZBiHyXTzdfHbssplJZIqibTS4TmDKn2pQ96Z6GY8+N92dbMf0uAs=
X-Received: by 2002:a05:6512:3b07:: with SMTP id f7mr3724203lfv.470.1619795516626;
 Fri, 30 Apr 2021 08:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000c97e505bdd1d60e@google.com> <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com> <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <a6ce21f4-04e7-f34c-8cfc-f8158f7fe163@gmail.com> <CAGyP=7czG1nmzpM5T784iBdApVL14hGoAfw-nhS=tNH5t9C79g@mail.gmail.com>
 <6d682c9d-a3ec-ec74-c8be-89e1ea5e24ca@gmail.com>
In-Reply-To: <6d682c9d-a3ec-ec74-c8be-89e1ea5e24ca@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Fri, 30 Apr 2021 20:41:45 +0530
Message-ID: <CAGyP=7eN4Eu2RwUQvXOYwaXAfYmxhU1gmQ9adSVUOmJNE+=teQ@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 30, 2021 at 8:37 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 4/30/21 4:02 PM, Palash Oswal wrote:
> > On Fri, Apr 30, 2021 at 8:03 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 4/30/21 3:21 PM, Palash Oswal wrote:
> >>> On Thursday, March 18, 2021 at 9:40:21 PM UTC+5:30 syzbot wrote:
> >>>>
> >>>> Hello,
> >>>>
> >>>> syzbot found the following issue on:
> >>>>
> >>>> HEAD commit: 0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> >>>> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> >>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12dde5aed00000
> >>>> kernel config: https://syzkaller.appspot.com/x/.config?x=81c0b708b31626cc
> >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=11bf59db879676f59e52
> >>>> userspace arch: riscv64
> >>>> CC: [asml.s...@gmail.com ax...@kernel.dk io-u...@vger.kernel.org linux-...@vger.kernel.org]
> >>>>
> >>>> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> There was so many fixes in 5.12 after this revision, including sqpoll
> >> cancellation related... Can you try something more up-to-date? Like
> >> released 5.12 or for-next
> >>
> >
> > The reproducer works for 5.12.
>
> Ok, any chance you have syz repro as well? it's easier to read
>
> >


Syzkaller reproducer:
# {Threaded:false Collide:false Repeat:true RepeatTimes:0 Procs:1
Slowdown:1 Sandbox: Fault:false FaultCall:-1 FaultNth:0 Leak:false
NetInjection:false NetDevices:false NetReset:false Cgroups:false
BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false
VhciInjection:false Wifi:false IEEE802154:false Sysctl:false
UseTmpDir:false HandleSegv:false Repro:false Trace:false}
r0 = syz_io_uring_setup(0x7987, &(0x7f0000000200)={0x0, 0x0, 0x2},
&(0x7f0000400000/0xc00000)=nil, &(0x7f0000ffd000/0x3000)=nil,
&(0x7f00000000c0)=<r1=>0x0, &(0x7f00000001c0)=<r2=>0x0)
syz_io_uring_submit(r1, r2, &(0x7f0000000180)=@IORING_OP_TIMEOUT={0xb,
0x1, 0x0, 0x0, 0x4, &(0x7f0000000140)={0x77359400}}, 0x1)
syz_io_uring_setup(0x4bf1, &(0x7f0000000540)={0x0, 0x0, 0x36, 0x0,
0x0, 0x0, r0}, &(0x7f0000ffd000/0x2000)=nil,
&(0x7f0000ffc000/0x1000)=nil, 0x0, 0x0)
