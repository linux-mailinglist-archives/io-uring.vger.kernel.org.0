Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCEA36FD38
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 17:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhD3PDY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 11:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3PDX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 11:03:23 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFE2C06174A;
        Fri, 30 Apr 2021 08:02:35 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id u20so81173981lja.13;
        Fri, 30 Apr 2021 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0037Jf1ObgVnWJX3giHmaVlY4h3vdc7P44Jc0d03qY=;
        b=l+7pA/sTRV5Tya+cXRjZYJbBVBrn7NPzPJZRWLrdPSjuak9PKrv3GGp7pBkcyBU+0H
         NncCDbb13A3P1IpPztCi29rWDOtqDSVSGRJUi3gZZVBxSmRwlBjPrkivz/GvxOolZfm2
         uvcBV7ekYUqgKnriu1IWenBux+nbLZa8yqN+dF3hm79o8cWFrVbnXAvKrkGTC6GEDawH
         9+ZkS/EJreYgbXYu9E6GdHAyvdkm2M0zPH/CTSxGMdlT+ThMWNdU1gbOf31V3YRZmq16
         QWRY5QOhq44IG7eUh+SDVrMbfch7eNuOTdQJvihSWaYeyQ8STzGRSKnyzyzrXvcYSCTR
         GuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0037Jf1ObgVnWJX3giHmaVlY4h3vdc7P44Jc0d03qY=;
        b=VS6tgXT4uLg6C7t7jnCN68VyFYrC0enD262M2hCgn+pmAzHDGdxoQSXbFFbTTJtn7l
         9y9+zT6n5LJ70DBENlaNVZDjz0g6DstaBI7oZmGCi9hjPsaWAfGqQNHx0o0hRdy5AyyH
         75hLlv3Wpu2y/T4bbH6+29LhxDLs6RzhDZ89cRaxPwYScIt6m54InlPmw1Fk4ukOfmDo
         mgrxd0+Skhos/PrQ381uiKvmbZ0TwPgTw1uDXLAvc35o8Clte3OyE8uHEdnWFeip92YF
         10unTrxM4t9K6ykYeZFoOQGGg9QcledzvIumPt9OI4JHx8FZQAE31KWF00DaOD0yJ2Gq
         8eYw==
X-Gm-Message-State: AOAM532XT0IW2u1OJzcEYYMbmnALxo7XI1aeJ6j4AzpJL4rOI4/phIqw
        oBvHOn6cSyuQXutHsVknYwrPMoct61lujRLmTXA=
X-Google-Smtp-Source: ABdhPJzzRoiphDcV4Xb+RnsfSFP2UaDKR4I7TM3sTpQ4SJXRK/Adr0+lnKDKVxJhT/yhizd9ezEVGZgTS4wboajtAfE=
X-Received: by 2002:a2e:a7cc:: with SMTP id x12mr4098497ljp.473.1619794953707;
 Fri, 30 Apr 2021 08:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000c97e505bdd1d60e@google.com> <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com> <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <a6ce21f4-04e7-f34c-8cfc-f8158f7fe163@gmail.com>
In-Reply-To: <a6ce21f4-04e7-f34c-8cfc-f8158f7fe163@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Fri, 30 Apr 2021 20:32:22 +0530
Message-ID: <CAGyP=7czG1nmzpM5T784iBdApVL14hGoAfw-nhS=tNH5t9C79g@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 30, 2021 at 8:03 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 4/30/21 3:21 PM, Palash Oswal wrote:
> > On Thursday, March 18, 2021 at 9:40:21 PM UTC+5:30 syzbot wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit: 0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> >> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=12dde5aed00000
> >> kernel config: https://syzkaller.appspot.com/x/.config?x=81c0b708b31626cc
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=11bf59db879676f59e52
> >> userspace arch: riscv64
> >> CC: [asml.s...@gmail.com ax...@kernel.dk io-u...@vger.kernel.org linux-...@vger.kernel.org]
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
>
> There was so many fixes in 5.12 after this revision, including sqpoll
> cancellation related... Can you try something more up-to-date? Like
> released 5.12 or for-next
>

The reproducer works for 5.12.

I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
commit on for-next tree
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
and the reproducer fails.


Palash
