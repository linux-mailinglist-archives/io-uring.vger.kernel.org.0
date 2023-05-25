Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09354710C2C
	for <lists+io-uring@lfdr.de>; Thu, 25 May 2023 14:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbjEYMdz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 May 2023 08:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbjEYMdy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 May 2023 08:33:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C6C12F;
        Thu, 25 May 2023 05:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4281760B70;
        Thu, 25 May 2023 12:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F38C433EF;
        Thu, 25 May 2023 12:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685018030;
        bh=WwuJIMk0ASgoxwnOktjJhHCWL86S4p4sEIeupWlyQeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SDBX1zmYPcqsRMMCAemYBOSVgszCtQonTA8o1DAdib8QXlakORJDRYus5rZ/EwuKr
         ijRsGYc5cteo7Tj0F7NrSUDpEa7n1Sw4Hc3whujqhje7DkYPRtcY9j3VWqNJnLj3Bf
         AlVy16XSemuyg3rRTEdCIJnyf2hlABBiMW746UIGGO44p6dItFydqjr7eElN04lAgY
         q8u3rWzIE9k1GyODSdf5Daf4IdjpcrvXjmoHvCGkUBBKoXCaQpj2nsQEgIszQ0n2mi
         jVrJAVWdyx5zIkKMadEPWy6Q/XteRfGZUMk8rOBUqQ6JUm73YCbhK4wCe1vWrwxTn3
         Ob4HwfF6npgPQ==
Date:   Thu, 25 May 2023 14:33:44 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <20230525-ziellinie-dachten-3eaa30a89e6f@brauner>
References: <ZG0slV2BhSZkRL_y@codewreck.org>
 <ZG0qgniV1DzIbbzi@codewreck.org>
 <20230524-monolog-punkband-4ed95d8ea852@brauner>
 <ZG6DUfdbTHS-e5P7@codewreck.org>
 <20230525-funkanstalt-ertasten-a43443d045c8@brauner>
 <ZG8_su9Pq1oI-t5s@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZG8_su9Pq1oI-t5s@codewreck.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 25, 2023 at 08:00:02PM +0900, Dominique Martinet wrote:
> Christian Brauner wrote on Thu, May 25, 2023 at 11:22:08AM +0200:
> > > What was confusing is that default_llseek updates f_pos under the
> > > inode_lock (write), and getdents also takes that lock (for read only in
> > > shared implem), so I assumed getdents also was just protected by this
> > > read lock, but I guess that was a bad assumption (as I kept pointing
> > > out, a shared read lock isn't good enough, we definitely agree there)
> > > 
> > > 
> > > In practice, in the non-registered file case io_uring is also calling
> > > fdget, so the lock is held exactly the same as the syscall and I wasn't
> > 
> > No, it really isn't. fdget() doesn't take f_pos_lock at all:
> > 
> > fdget()
> > -> __fdget()
> >    -> __fget_light()
> >       -> __fget()
> >          -> __fget_files()
> >             -> __fget_files_rcu()
> 
> Ugh, I managed to not notice that I was looking at fdget_pos and that
> it's not the same as fdget by the time I wrote two paragraphs... These
> functions all have too many wrappers and too similar names for a quick
> look before work.
> 
> > If that were true then any system call that passes an fd and uses
> > fdget() would try to acquire a mutex on f_pos_lock. We'd be serializing
> > every *at based system call on f_pos_lock whenever we have multiple fds
> > referring to the same file trying to operate on it concurrently.
> > 
> > We do have fdget_pos() and fdput_pos() as a special purpose fdget() for
> > a select group of system calls that require this synchronization.
> 
> Right, that makes sense, and invalidates everything I said after that
> anyway but it's not like looking stupid ever killed anyone.

I strongly disagree with the looking stupid part. These callchains are
quite unwieldy and it's easy to get confused. Usually if you receive a
long mail about the semantics involved - as in the earlier thread - it
means there's landmines all over.

> 
> Ok so it would require adding a new wrapper from struct file to struct
> fd that'd eventually take the lock and set FDPUT_POS_UNLOCK for... not
> fdput_pos but another function for that stopping short of fdput...
> Then just call that around both vfs_llseek and vfs_getdents calls; which
> is the easy part.
> 
> (Or possibly call mutex_lock directly like Dylan did in [1]...)
> [1] https://lore.kernel.org/all/20220222105504.3331010-1-dylany@fb.com/T/#m3609dc8057d0bc8e41ceab643e4d630f7b91bde6

We'd need a consistent story whatever it ends up being.

> I'll be honest though I'm thankful for your explanations but I think
> I'll just do like Stefan and stop trying for now: the only reason I've
> started this was because I wanted to play with io_uring for a new toy
> project and it felt awkward without a getdents for crawling a tree; and
> I'm long past the point where I should have thrown the towel and just
> make that a sequential walk.
> There's too many "conditional patches" (NOWAIT, end of dir indicator)
> that I don't care about and require additional work to rebase
> continuously so I'll just leave it up to someone else who does care.
> 
> So to that someone: feel free to continue from these branches (I've
> included the fix for kernfs_fop_readdir that Dan Carpenter reported):
> https://github.com/martinetd/linux/commits/io_uring_getdents
> https://github.com/martinetd/liburing/commits/getdents
> 
> Or just start over, there's not that much code now hopefully the
> baseline requirements have gotten a little bit clearer.
> 
> 
> Sorry for stirring the mess and leaving halfway, if nobody does continue
> I might send a v3 when I have more time/energy in a few months, but it
> won't be quick.

It's fine.
