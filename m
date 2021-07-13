Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDF73C7048
	for <lists+io-uring@lfdr.de>; Tue, 13 Jul 2021 14:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhGMMbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jul 2021 08:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhGMMbh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Jul 2021 08:31:37 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A61C0613DD;
        Tue, 13 Jul 2021 05:28:47 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g5so34419094ybu.10;
        Tue, 13 Jul 2021 05:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NbsMhqjJgHfV91bYAqk7q9Rvxgr1PS+ipCrllwrhurM=;
        b=BKV9wk4KmXvnZx/mPFrF78qZGP+BI46ZR174ivRhP+vZki30rqkR0YJySkOoC2Njxa
         wGU4n+wRgaYrm6MYBUCcP/zRTrfhAI979byMZAKfsAlM8IN/ElQG+suBKuyTrgHqZH8g
         UMMkmgf0w5qzrarjpao9ruK0DuO6e6Z5+4/0dfFLa40M3gWrSoCXIUjLAS5yq6xzOsXu
         7L/5UHKIwzAvvI8W/qnvCz15p2Z3+bCyvTv0aP0WX5ysN/ZoKCXWGh3Rc0RuZb/14wqj
         2M+gyyV3qgzhUpv7Ctlxi/ea2JmMBulQ2fSOhozlmE6EBJHqod0rgnmvEFSTduFqtEHx
         Wryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NbsMhqjJgHfV91bYAqk7q9Rvxgr1PS+ipCrllwrhurM=;
        b=b1SLO5JO4bVlJjPgx8YDRZTw8B3oHWBMUtTnNCtuAD0+aBWwKrKo53iXKJr04wWsN8
         5HSQA8/kVaBf7xol2l92xuifjh/9vK63eRxeg+vR8IEOIhobV2ZWSVxbWWiXvYQJFn87
         Mb9w51KAlK6/cCsqiXVk1Yn278QDkwKtAa9483JCcIeG+w9Ua094tuB+78J3jb3XmTer
         FYAFGdXI9RlBW21fH/iIj2St+WFwnRpAUSqeWLaQSUVPdQazB7zKUPlpAkowAWTIpf5/
         QbDSN80XEP+TcjGSSYHHT63RfWxA7LLGkuTE32e/uIgEZQO7F9LnzkeHNXr3kT1sTKMB
         PdJg==
X-Gm-Message-State: AOAM5301HQ18HqWT2msBjAnI/jnkgZKHjLxPLHM2sl0QlH1YvV76SefN
        c8YauW1G8au1pLEuVGCRBwdU3R1nDY/BT3Z3Mrw=
X-Google-Smtp-Source: ABdhPJzx6bGvlP5XhDHFndFuWjAkhlUAx4uZzbrEuj6dr+sXicq6CCjwk9C2OIf78JHOxnlxof1d8qBSBfa3ntxyWc0=
X-Received: by 2002:a25:9d0f:: with SMTP id i15mr5491795ybp.311.1626179326735;
 Tue, 13 Jul 2021 05:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com> <CAOKbgA4EqwLa3WDK_JcxFAU92pBw4hS8vjQ9p7B-w+5y7yX5Eg@mail.gmail.com>
 <CAHk-=wiGH-bYqLvjMOv2i48Wb1FQaAj8ukegSMLNbW0yri05rA@mail.gmail.com> <YOylTZ3u0AVidHe2@zeniv-ca.linux.org.uk>
In-Reply-To: <YOylTZ3u0AVidHe2@zeniv-ca.linux.org.uk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 13 Jul 2021 19:28:35 +0700
Message-ID: <CAOKbgA7-yZJShsyQd2QAjBWEpuz8VRuZ_hLBATCVFtMED2h-MQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] namei: clean up retry logic in various do_* functions
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 13, 2021 at 3:28 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Jul 12, 2021 at 12:01:52PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 12, 2021 at 5:41 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> > >
> > > Since this is on top of the stuff that is going to be in the Jens' tree
> > > only until the 5.15 merge window, I'm assuming this series should go
> > > there as well.
> >
> > Yeah. Unless Al wants to pick this whole series up.
> >
> > See my comments about the individual patches - some of them change
> > code flow, others do. And I think changing code flow as part of
> > cleanup is ok, but it at the very least needs to be mentioned (and it
> > might be good to do the "move code that is idempotent inside the
> > retry" as a separate patch from documentation purposes)
>
> TBH, my main problem with this is that ESTALE retry logics had never
> felt right.  We ask e.g. filename_create() to get us the parent.  We
> tell it whether we want it to be maximally suspicious or not.  It
> still does the same RCU-normal-LOOKUP_REVAL sequence, only for "trust
> no one" variant it's RCU-LOOKUP_REVAL-LOOKUP_REVAL instead.

Regardless of the bigger changes discussed below, should we change
direct comparison to ESTALE to retry_estale(retval, lookup_flags) in
filename_lookup() and filename_parentat() (and probably also
do_filp_open() and do_file_open_root())? At least it won't do two
consecutive LOOKUP_REVAL lookups and the change is trivial.

> We are
> *not* told how far in that sequence did it have to get.  What's more,
> even if we had to get all way up to LOOKUP_REVAL, we ignore that
> when we do dcache lookup for the last component - only the argument
> of filename_create() is looked at.
>
> It really smells like the calling conventions are wrong.  I agree that
> all of that is, by definition, a very slow path - it's just that the
> logics makes me go "WTF?" every time I see it... ;-/

The current series does not make it worse though. I'm happy to work on
further improvements with some guidance, but hopefully in a separate
patchset?

> Hell knows - perhaps the lookup_flags thing wants to be passed by
> reference (all the way into path_parentat()) and have the "we had
> to go for LOOKUP_REVAL" returned that way.  Not sure...

Will that allow to get rid of the retries completely? I'm not sure I
understand all the code paths that can return ESTALE, I'd assume we'd
still have to keep the whole retry logic.

-- 
Dmitry Kadashev

On Tue, Jul 13, 2021 at 3:28 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Jul 12, 2021 at 12:01:52PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 12, 2021 at 5:41 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> > >
> > > Since this is on top of the stuff that is going to be in the Jens' tree
> > > only until the 5.15 merge window, I'm assuming this series should go
> > > there as well.
> >
> > Yeah. Unless Al wants to pick this whole series up.
> >
> > See my comments about the individual patches - some of them change
> > code flow, others do. And I think changing code flow as part of
> > cleanup is ok, but it at the very least needs to be mentioned (and it
> > might be good to do the "move code that is idempotent inside the
> > retry" as a separate patch from documentation purposes)
>
> TBH, my main problem with this is that ESTALE retry logics had never
> felt right.  We ask e.g. filename_create() to get us the parent.  We
> tell it whether we want it to be maximally suspicious or not.  It
> still does the same RCU-normal-LOOKUP_REVAL sequence, only for "trust
> no one" variant it's RCU-LOOKUP_REVAL-LOOKUP_REVAL instead.  We are
> *not* told how far in that sequence did it have to get.  What's more,
> even if we had to get all way up to LOOKUP_REVAL, we ignore that
> when we do dcache lookup for the last component - only the argument
> of filename_create() is looked at.
>
> It really smells like the calling conventions are wrong.  I agree that
> all of that is, by definition, a very slow path - it's just that the
> logics makes me go "WTF?" every time I see it... ;-/
>
> Hell knows - perhaps the lookup_flags thing wants to be passed by
> reference (all the way into path_parentat()) and have the "we had
> to go for LOOKUP_REVAL" returned that way.  Not sure...
>
> Al, still crawling out of the bloody ptrace/asm glue horrors at the moment...
