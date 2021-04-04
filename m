Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FD43536F1
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 06:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhDDEuA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 00:50:00 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:22967 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhDDEuA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 00:50:00 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 16BFB1E211B;
        Sun,  4 Apr 2021 04:42:22 +0000 (UTC)
Received: from pdx1-sub0-mail-a40.g.dreamhost.com (100-96-16-41.trex.outbound.svc.cluster.local [100.96.16.41])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id B85241E1F8F;
        Sun,  4 Apr 2021 04:42:19 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a40.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.16.41 (trex/6.1.1);
        Sun, 04 Apr 2021 04:42:21 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Trade-Lettuce: 7d3518032b9af67c_1617511341842_3188806789
X-MC-Loop-Signature: 1617511341842:92390533
X-MC-Ingress-Time: 1617511341842
Received: from pdx1-sub0-mail-a40.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a40.g.dreamhost.com (Postfix) with ESMTP id 7F69A89AB8;
        Sun,  4 Apr 2021 04:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=E5OLbiFYgXBHGri/cGg/775OEgs=; b=
        ZIq0sNam0rewSjmjF99WJqlJ0utjyCssgwwYW9Fongg+RfiH6A8OX2IaBt7PzGa+
        R5QcIn/Rg/b9l3Lp5dPzVi/nVHYnjWwxyHs9eyqOe2DF3mue+Pv+HaIy9pOZ8ac3
        GxX6/UsxNg5Zj6Jk/IhaD6rkNQl4W1gURpFiECvlbn4=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a40.g.dreamhost.com (Postfix) with ESMTPSA id E513C89AB5;
        Sun,  4 Apr 2021 04:42:18 +0000 (UTC)
Date:   Sat, 3 Apr 2021 23:42:16 -0500
X-DH-BACKEND: pdx1-sub0-mail-a40
From:   Clay Harris <bugs@claycon.org>
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     io-uring@vger.kernel.org,
        Tavian Barnes <tavianator@tavianator.com>,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: Re: [PATCH v5 0/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210404044216.w7dqrioahqvbg4dz@ps29521.dreamhostps.com>
References: <YGMIwcxAIJPAWGLu@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGMIwcxAIJPAWGLu@wantstofly.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 30 2021 at 14:17:21 +0300, Lennert Buytenhek quoth thus:

> (These patches depend on IORING_OP_MKDIRAT going in first.)
> 
> These patches add support for IORING_OP_GETDENTS, which is a new io_uring
> opcode that more or less does an lseek(sqe->fd, sqe->off, SEEK_SET)
> followed by a getdents64(sqe->fd, (void *)sqe->addr, sqe->len).
> 
> A dumb test program which recursively scans through a directory tree
> and prints the names of all directories and files it encounters along
> the way is available here:
> 
>         https://krautbox.wantstofly.org/~buytenh/uringfind-v3.c
> 
> Changes since v4:
> 
> - Make IORING_OP_GETDENTS read from the directory's current position
>   if the specified offset value is -1 (IORING_FEAT_RW_CUR_POS).
>   (Requested / pointed out by Tavian Barnes.)

This seems like a good feature.  As I understand it, this would
allow submitting pairs of IORING_OP_GETDENTS with IOSQE_IO_HARDLINK
wherein the first specifies the current offset and the second specifies
offset -1, thereby halfing the number of kernel round trips for N getdents64.

If the entire directory fits into the first buffer, the second would
indicate EOF.  This would certainly seem like a win, but note there
are diminishing returns as the directory size increases, versus just
doubling the buffer size.


An alternate / additional idea you may wish to consider is changing
getdents64 itself.

Ordinary read functions must return 0 length to indicate EOF, because
they can return arbitrary data.  This is not the case for getdents64.

1) Define a struct linux_dirent of minimum size containing an abnormal
value as a sentinel.  d_off = 0 or -1 should work.

2) Implement a flag for getdents64.

IF
	the flag is set AND
	we are returning a non-zero length buffer AND
	there is room in the buffer for the sentinel structure AND
	a getdents64 call using the d_off of the last struct in the
		buffer would return EOF
THEN
	append the sentinel struct to the buffer.


Using the arrangement, we would still handle a 0 length return as an
EOF, but if we see the sentinel struct, we can skip the additional call
altogether.  The saves all of the pairing of buffers and extra logic,
and unless we're unlucky and the sentinel structure did not fit in
the buffer at EOF, would always reduce the number of getdents64
calls by one.

Moreover, if the flag was available outside of io_uring, for smaller
directories, this feature would cut the number of directory reads
of readdir(3) by up to half.

> - Rebase onto for-5.13/io_uring as of 2021/03/30 plus v3 of Dmitry
>   Kadashev's "io_uring: add mkdirat support".
> 
> Changes since v3:
> 
> - Made locking in io_getdents() unconditional, as the prior
>   optimization was racy.  (Pointed out by Pavel Begunkov.)
> 
> - Rebase onto for-5.13/io_uring as of 2021/03/12 plus a manually
>   applied version of the mkdirat patch.
> 
> Changes since v2 RFC:
> 
> - Rebase onto io_uring-2021-02-17 plus a manually applied version of
>   the mkdirat patch.  The latter is needed because userland (liburing)
>   has already merged the opcode for IORING_OP_MKDIRAT (in commit
>   "io_uring.h: 5.12 pending kernel sync") while this opcode isn't in
>   the kernel yet (as of io_uring-2021-02-17), and this means that this
>   can't be merged until IORING_OP_MKDIRAT is merged.
> 
> - Adapt to changes made in "io_uring: replace force_nonblock with flags"
>   that are in io_uring-2021-02-17.
> 
> Changes since v1 RFC:
> 
> - Drop the trailing '64' from IORING_OP_GETDENTS64 (suggested by
>   Matthew Wilcox).
> 
> - Instead of requiring that sqe->off be zero, use this field to pass
>   in a directory offset to start reading from.  For the first
>   IORING_OP_GETDENTS call on a directory, this can be set to zero,
>   and for subsequent calls, it can be set to the ->d_off field of
>   the last struct linux_dirent64 returned by the previous call.
> 
> Lennert Buytenhek (2):
>   readdir: split the core of getdents64(2) out into vfs_getdents()
>   io_uring: add support for IORING_OP_GETDENTS
> 
>  fs/io_uring.c                 |   66 ++++++++++++++++++++++++++++++++++++++++++
>  fs/readdir.c                  |   25 ++++++++++-----
>  include/linux/fs.h            |    4 ++
>  include/uapi/linux/io_uring.h |    1
>  4 files changed, 88 insertions(+), 8 deletions(-)
