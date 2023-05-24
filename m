Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0F2710019
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 23:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbjEXVgv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 17:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbjEXVgo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 17:36:44 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24302FC;
        Wed, 24 May 2023 14:36:42 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 82F68C021; Wed, 24 May 2023 23:36:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1684964200; bh=yrpXMUqAGp5oyUvzDl3QkfpAYUk5X23ovRaf0BC/DY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q8c8AFZuTz+kvioFyFxziJpfPFV1ZxhngrealEWWTvTmybbhje/mnZqid6WR4dgms
         qA8dNB8MszRwHTMnqfEZC2vYEJCUlc8iw1hOaltviXNAjzK5SnC+XbCP3FJGs83STA
         f8Eu65q21KnrRVRa1NB0xoHTCswWy4gX59+7RZB2OY55lTXBtNNlI544SHqQpzaLI5
         ACdc5fMzzEI4eRWGAaLjcg+kqia2ArDk8HduFYi3MY9yN6bSUIK8o4kwF4Di5oqn8U
         3J56rwNT/zfVJwZrly7KkRwd4OpKNbsFmU3usnBTwp/eqYmhxWAUoiD1+VKa3mANV0
         EolySEU28Tb4w==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 76195C009;
        Wed, 24 May 2023 23:36:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1684964198; bh=yrpXMUqAGp5oyUvzDl3QkfpAYUk5X23ovRaf0BC/DY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zhZEAhayVDmsW4Tz0Sh9flNnfBzGkRuV4XRVAiMhfrC7O3ljD1T9WGGwhZ/P8G8JS
         2K3pWt6Q/5Ar9ESDxVzq9wNyYXHopA7WIau76JTHDspNoW9RePb7tBya6AlKD1kHq8
         e75Jc58nRsNTQBpVk5X2NMvDa/wjQCnt+47qOm3zNDVbMX52UNfcv4J2HOfxD2Yk9H
         Qqb3r5QXAKF9eQlUjfNfL6qdlE4OW3295JntKQRuUdpOHLmVYWxJetPzUlVqZGNAYT
         tcibgTyEXrmw+4/eQtEYEcHsE5q5Yu6DKA6c0ODguzlz1aRqFm5I6iNFR2djGoDFSA
         1Ziwk97KZMEKg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id ec1cb997;
        Wed, 24 May 2023 21:36:32 +0000 (UTC)
Date:   Thu, 25 May 2023 06:36:17 +0900
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
Message-ID: <ZG6DUfdbTHS-e5P7@codewreck.org>
References: <ZG0slV2BhSZkRL_y@codewreck.org>
 <ZG0qgniV1DzIbbzi@codewreck.org>
 <20230524-monolog-punkband-4ed95d8ea852@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230524-monolog-punkband-4ed95d8ea852@brauner>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Christian Brauner wrote on Wed, May 24, 2023 at 03:52:45PM +0200:
> The main objection in [1] was to allow specifying an arbitrary offset
> from userspace. What [3] did was to implement a pread() variant for
> directories, i.e., pgetdents(). That can't work in principle/is
> prohibitively complex. Which is what your series avoids by not allowing
> any offsets to be specified.

Yes.

> However, there's still a problem here. Updates to f_pos happen under an
> approriate lock to guarantee consistency of the position between calls
> that move the cursor position. In the normal read-write path io_uring
> doesn't concern itself with f_pos as it keeps local state in
> kiocb->ki_pos.
> 
> But then it still does end up running into f_pos consistency problems
> for read-write because it does allow operating on the current f_pos if
> the offset if struct io_rw is set to -1.
> 
> In that case it does retrieve and update f_pos which should take
> f_pos_lock and a patchset for this was posted but it didn't go anywhere.
> It should probably hold that lock. See Jann's comments in the other
> thread how that currently can lead to issues.

Assuming that is this mail:
https://lore.kernel.org/io-uring/CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com/

So, ok, I didn't realize fdget_pos() actually acted as a lock on the
file's f_pos_lock (apparently only if FMODE_ATMOIC_POS is set? but it
looks set on most if not all directories through finish_open(), that
looks called consistently enough)

What was confusing is that default_llseek updates f_pos under the
inode_lock (write), and getdents also takes that lock (for read only in
shared implem), so I assumed getdents also was just protected by this
read lock, but I guess that was a bad assumption (as I kept pointing
out, a shared read lock isn't good enough, we definitely agree there)


In practice, in the non-registered file case io_uring is also calling
fdget, so the lock is held exactly the same as the syscall and I wasn't
so far off -- but we need to figure something for the registered file
case.
openat variants don't allow working with the registered variant at all
on the parent fd, so as far as I'm concerned I'd be happy setting the
same limitation for getdents: just say it acts on fd and not files, and
call it a day...
It'd also be possible to check if REQ_F_FIXED_FILE flag was set and
manually take the lock somehow but we don't have any primitive that
takes f_pos_lock from a file (the only place that takes it is fdget
which requires a fd), so I'd rather not add such a new exception.
I assume the other patch you mentioned about adding that lock was this
one:
https://lore.kernel.org/all/20220222105504.3331010-1-dylany@fb.com/T/#m3609dc8057d0bc8e41ceab643e4d630f7b91bde6
and it just atkes the lock, but __fdget_pos also checks for
FMODE_ATOMIC_OPS and file_count and I'm not sure I understand how it
sets (f.flags & FDPUT_POS_UNLOCK) (for fdput_pos) so I'd rather not add
such a code path at this point..


So, ok, what do you think about just forbidding registered files?
I can't see where that wouldn't suffice but I might be missing something
else.

> For getdents() not protecting f_pos is equally bad or worse. The patch
> doesn't hold f_pos_lock and just updates f_pos prior _and_ post
> iterate_dir() arguing that this race is fine. But again, f_version and
> f_pos are consistent after each system call invocation.
> 
> But without that you can have a concurrent seek running and can end up
> with an inconsistent f_pos position within the same system call. IOW,
> you're breaking f_pos being in a well-known state. And you're not doing
> that just for io_uring you're doing it for the regular system call
> interface as well as both can be used on the same fd simultaneously.
> So that's a no go imho.

(so seek is fine, but I agree two concurrent getdents on registered
files won't have the required lock)

-- 
Dominique Martinet | Asmadeus
