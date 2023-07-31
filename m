Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715117689A6
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 03:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjGaBdN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Jul 2023 21:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGaBdM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Jul 2023 21:33:12 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B40A1
        for <io-uring@vger.kernel.org>; Sun, 30 Jul 2023 18:33:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-686f38692b3so3800947b3a.2
        for <io-uring@vger.kernel.org>; Sun, 30 Jul 2023 18:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690767190; x=1691371990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zCSMs5I0LdE6oxgRjJSMvJRUSRIfqnXQCQ7i3MIqWyo=;
        b=JUy0vPTZSDasYdc8rwQNkqYiGfaqxZRL8N7NDbhmfwbudqgRPhwh7r7cL6i1Sh9zz6
         fPItunonZmaXfY7oUAVvHO5gG0TIJT3iXi03V2+KtyOPwDo8m06Qmv2upsxqmSOMqobr
         x+pgy0ki4e6bqyyrHP7oBTC4zoWSfiFZtuwZyjNu3ZVFWsLRtLllkfQWPTJGCcQH0IIY
         GLhkHAS2JSd7Vu8jowxC1jCI167ktQAlJ05lnFmsjWPNAaTD/xLizM5Vwzd8LclLvacS
         dVZjlDcPgdeWkeclqKIZmFvx8phY28J/sKlbnTQRu+3/KeI3JHySjIYurhS/BVx1045O
         1eAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690767190; x=1691371990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCSMs5I0LdE6oxgRjJSMvJRUSRIfqnXQCQ7i3MIqWyo=;
        b=Cg0LpAPjNJF8vJbQVQowdcVASTcl8hmN8/VEZ7UTar7I7cZr9Mwv6LgmYrs4rx2NxZ
         omPWzOAwJjT2MACrcnFmD+dxenoqD7bbKh9DY/8iBRBxWU6fl5pIQCfhbo3FAV8HBpNd
         4TDOxjDgsgfhIcBFLm2heppQnpM4kc85Zmyn9wn0a5niOWhFMNAhTjmvuo826xstm64i
         FLOorRvg4Uo882u+q9sbwxcb/77Tm2c1AyWeFN8nJBgOTmrE8TdV3qJSumxOrwqTaNvR
         oWVsg8mllapTamuudTVbY9fQc2pdJ8Q2laCKNKgZpou0w00EBnFF4g6tVGHKhKNk2pZo
         qCHg==
X-Gm-Message-State: ABy/qLaKAocpzVgeNAJo95TsmB8y+wQv1toqbxZpMAar2NACOzGWmSqQ
        5K5EUDaVeoLrBK+ur2jG/RvQJ2RLI/4J/VU/gkY=
X-Google-Smtp-Source: APBJJlGYJO/faS080eGTYkh6D5uQek1bH5LJ9rsSao4U4EWnmL6ks0qX4Neci2c5beo2g6Mvoz+9uA==
X-Received: by 2002:a05:6a20:105a:b0:133:f0b9:856d with SMTP id gt26-20020a056a20105a00b00133f0b9856dmr8702045pzc.17.1690767190579;
        Sun, 30 Jul 2023 18:33:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id e23-20020a62ee17000000b006827d86ca0csm6353364pfi.55.2023.07.30.18.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jul 2023 18:33:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qQHmT-00CYPz-2y;
        Mon, 31 Jul 2023 11:33:05 +1000
Date:   Mon, 31 Jul 2023 11:33:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Hao Xu <hao.xu@linux.dev>, djwong@kernel.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <ZMcPUX0lYC2nscAm@dread.disaster.area>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727-salbe-kurvigen-31b410c07bb9@brauner>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 27, 2023 at 04:27:30PM +0200, Christian Brauner wrote:
> On Thu, Jul 27, 2023 at 07:51:19PM +0800, Hao Xu wrote:
> > I actually saw this semaphore, and there is another xfs lock in
> > file_accessed
> >   --> touch_atime
> >     --> inode_update_time
> >       --> inode->i_op->update_time == xfs_vn_update_time
> > 
> > Forgot to point them out in the cover-letter..., I didn't modify them
> > since I'm not very sure about if we should do so, and I saw Stefan's
> > patchset didn't modify them too.
> > 
> > My personnal thinking is we should apply trylock logic for this
> > inode->i_rwsem. For xfs lock in touch_atime, we should do that since it
> > doesn't make sense to rollback all the stuff while we are almost at the
> > end of getdents because of a lock.
> 
> That manoeuvres around the problem. Which I'm slightly more sensitive
> too as this review is a rather expensive one.
> 
> Plus, it seems fixable in at least two ways:
> 
> For both we need to be able to tell the filesystem that a nowait atime
> update is requested. Simple thing seems to me to add a S_NOWAIT flag to
> file_time_flags and passing that via i_op->update_time() which already
> has a flag argument. That would likely also help kiocb_modified().

Wait - didn't we already fix this for mtime updates on IOCB_NOWAIT
modification operations? Yeah, we did:

kiocb_modified(iocb)
  file_modified_flags(iocb->ki_file, iocb->ki_flags)
    ....
    ret = inode_needs_update_time()
    if (ret <= 0)
	return ret;
    if (flags & IOCB_NOWAIT)
	return -EAGAIN;
    <does timestamp update>

> file_accessed()
> -> touch_atime()
>    -> inode_update_time()
>       -> i_op->update_time == xfs_vn_update_time()

Yeah, so this needs the same treatment as file_modified_flags() -
touch_atime() needs a flag variant that passes IOCB_NOWAIT, and
after atime_needs_update() returns trues we should check IOCB_NOWAIT
and return EAGAIN if it is set. That will punt the operation that
needs to the update to a worker thread that can block....

> Then we have two options afaict:
> 
> (1) best-effort atime update
> 
> file_accessed() already has the builtin assumption that updating atime
> might fail for other reasons - see the comment in there. So it is
> somewhat best-effort already.
> 
> (2) move atime update before calling into filesystem
> 
> If we want to be sure that access time is updated when a readdir request
> is issued through io_uring then we need to have file_accessed() give a
> return value and expose a new helper for io_uring or modify
> vfs_getdents() to do something like:
> 
> vfs_getdents()
> {
> 	if (nowait)
> 		down_read_trylock()
> 
> 	if (!IS_DEADDIR(inode)) {
> 		ret = file_accessed(file);
> 		if (ret == -EAGAIN)
> 			goto out_unlock;
> 
> 		f_op->iterate_shared()
> 	}
> }

Yup, that's the sort of thing that needs to be done.

But as I said in the "llseek for io-uring" thread, we need to stop
the game of whack-a-mole passing random nowait boolean flags to VFS
operations before it starts in earnest.  We really need a common
context structure (like we have a kiocb for IO operations) that
holds per operation control state so we have consistency across all
the operations that we need different behaviours for.

> It's not unprecedented to do update atime before the actual operation
> has been done afaict. That's already the case in xfs_file_write_checks()
> which is called before anything is written. So that seems ok.

Writes don't update atime - they update mtime, and there are other
considerations for doing the mtime update before the data
modification. e.g. we have to strip permissions from the inode prior
to any changes that are going to be made, so we've already got to do
all the "change inode metadata" checks and modifications before the
data is written anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
