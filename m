Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A83710A6D
	for <lists+io-uring@lfdr.de>; Thu, 25 May 2023 13:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjEYLAv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 May 2023 07:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbjEYLA1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 May 2023 07:00:27 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFB990;
        Thu, 25 May 2023 04:00:25 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D04E3C01E; Thu, 25 May 2023 13:00:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1685012423; bh=JQDvJGpr01tErYOWTD112V7qZmWwoz3rxBUiJkx/XY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XVbiXntQJQAB9jBeMjoIxh15L/J9no3h7Q5iaUpPiL7SdjGK9UM4ESTVUMkA7m7n1
         H7luhdpum0LXIg+4aePf2w/UaRRCnHRBn0/eCCadCPsfLjY4BgphNuvGkRAieuDB9i
         U0Q1op1WOleHf/aeIs5LWJdU9ZJAmHv96g+DAGDZco+NFcLaVJKRxF0k5SsENjK9fw
         384xheiykSYqUuT1nTXpxIDNq/EEEbPDYdNH5TpSzF2UDke10p6GlnEVLWOlzDn6rG
         TZSToZV6Tx0ToBvVsdvOCoVbG15iNvmrtAxiCChY0QtrH1L/SvUwSxeU7BNz8RQ8L+
         hYgh/Rn6F/QZQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 1D5D8C009;
        Thu, 25 May 2023 13:00:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1685012422; bh=JQDvJGpr01tErYOWTD112V7qZmWwoz3rxBUiJkx/XY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=23R92lXpFU6Ei2o2sHaoHlMJu0YJRpJSoXlNQHKa+MEW3T1Ie4+5Jq9f0f3lTVfpf
         tw08T6kgwMKrNb8+qMJaMIUNFGn9sd+0mxYcu/9cxdzUCT+R77I96oIH8lqO1dCQzq
         Q/sxi/RRwQsTB567v50h0701MhoiIHoPqpwV4Wznu1JmkaK2cc2o83Ui6AnJ3MFFw0
         mu1QBwVe1vALHgwB6gC9vqTbu4rQ6ajxRFiak5NP/uEhtfJS1M3LbQ5+XD52kDu7GU
         CBpk5myFtJzFM0Jd1lCStsajpiSqLHyeQpesSqC8LafounMb/XaNOTjulaSDf/Tr/P
         FMy4Xq8L9m5yg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id fb0c6ca8;
        Thu, 25 May 2023 11:00:17 +0000 (UTC)
Date:   Thu, 25 May 2023 20:00:02 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <ZG8_su9Pq1oI-t5s@codewreck.org>
References: <ZG0slV2BhSZkRL_y@codewreck.org>
 <ZG0qgniV1DzIbbzi@codewreck.org>
 <20230524-monolog-punkband-4ed95d8ea852@brauner>
 <ZG6DUfdbTHS-e5P7@codewreck.org>
 <20230525-funkanstalt-ertasten-a43443d045c8@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230525-funkanstalt-ertasten-a43443d045c8@brauner>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Christian Brauner wrote on Thu, May 25, 2023 at 11:22:08AM +0200:
> > What was confusing is that default_llseek updates f_pos under the
> > inode_lock (write), and getdents also takes that lock (for read only in
> > shared implem), so I assumed getdents also was just protected by this
> > read lock, but I guess that was a bad assumption (as I kept pointing
> > out, a shared read lock isn't good enough, we definitely agree there)
> > 
> > 
> > In practice, in the non-registered file case io_uring is also calling
> > fdget, so the lock is held exactly the same as the syscall and I wasn't
> 
> No, it really isn't. fdget() doesn't take f_pos_lock at all:
> 
> fdget()
> -> __fdget()
>    -> __fget_light()
>       -> __fget()
>          -> __fget_files()
>             -> __fget_files_rcu()

Ugh, I managed to not notice that I was looking at fdget_pos and that
it's not the same as fdget by the time I wrote two paragraphs... These
functions all have too many wrappers and too similar names for a quick
look before work.

> If that were true then any system call that passes an fd and uses
> fdget() would try to acquire a mutex on f_pos_lock. We'd be serializing
> every *at based system call on f_pos_lock whenever we have multiple fds
> referring to the same file trying to operate on it concurrently.
> 
> We do have fdget_pos() and fdput_pos() as a special purpose fdget() for
> a select group of system calls that require this synchronization.

Right, that makes sense, and invalidates everything I said after that
anyway but it's not like looking stupid ever killed anyone.

Ok so it would require adding a new wrapper from struct file to struct
fd that'd eventually take the lock and set FDPUT_POS_UNLOCK for... not
fdput_pos but another function for that stopping short of fdput...
Then just call that around both vfs_llseek and vfs_getdents calls; which
is the easy part.

(Or possibly call mutex_lock directly like Dylan did in [1]...)
[1] https://lore.kernel.org/all/20220222105504.3331010-1-dylany@fb.com/T/#m3609dc8057d0bc8e41ceab643e4d630f7b91bde6



I'll be honest though I'm thankful for your explanations but I think
I'll just do like Stefan and stop trying for now: the only reason I've
started this was because I wanted to play with io_uring for a new toy
project and it felt awkward without a getdents for crawling a tree; and
I'm long past the point where I should have thrown the towel and just
make that a sequential walk.
There's too many "conditional patches" (NOWAIT, end of dir indicator)
that I don't care about and require additional work to rebase
continuously so I'll just leave it up to someone else who does care.

So to that someone: feel free to continue from these branches (I've
included the fix for kernfs_fop_readdir that Dan Carpenter reported):
https://github.com/martinetd/linux/commits/io_uring_getdents
https://github.com/martinetd/liburing/commits/getdents

Or just start over, there's not that much code now hopefully the
baseline requirements have gotten a little bit clearer.


Sorry for stirring the mess and leaving halfway, if nobody does continue
I might send a v3 when I have more time/energy in a few months, but it
won't be quick.

-- 
Dominique
