Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DAF351FCB
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhDAT2P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 15:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbhDAT2K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 15:28:10 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB39C05BD24;
        Thu,  1 Apr 2021 12:11:17 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lS2im-001iJP-Kk; Thu, 01 Apr 2021 19:11:12 +0000
Date:   Thu, 1 Apr 2021 19:11:12 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 01, 2021 at 07:59:19PM +0200, Christian Brauner wrote:

> I _think_ I see what the issue is. It seems that an assumption made in
> this commit might be wrong and we're missing a mnt_add_count() bump that
> we would otherwise have gotten if we've moved the failure handling into
> the unlazy helpers themselves.
> 
> Al, does that sound plausible?

mnt_add_count() on _what_?  Failure in legitimize_links() ends up with
nd->path.mnt zeroed, in both callers.  So which vfsmount would be
affected?

Rules:
	in RCU mode: no mounts pinned
	out of RCU mode: nd->path.mnt and all nd->stack[i].link.mnt for
			i below nd->depth are either NULL or pinned

Transition from RCU to non-RCU mode happens in try_to_unlazy() and
try_to_unlazy_next().

References (if any) are dropped by eventual terminate_walk() (after
that the contents of nameidata is junk).

__legitimize_mnt() is the primitive for pinning.  Return values:
	0 -- successfully pinned (or given NULL as an argument)
	1 -- failed, refcount not affected
	-1 -- failed, refcount bumped.
It stays in RCU mode in all cases.

One user is __legitimize_path(); it also stays in RCU mode.  If it
fails to legitimize path->mnt, it will zero it *IF* __legitimize_mnt()
reports that refcount hadn't been taken.  In all other cases,
path->mnt is pinned.  IOW, the caller is responsible for path_put()
regardless of the outcome.

Another user is legitimize_mnt().  _That_ will make sure that
refcount is unaffected in case of failure (IOW, if __legitimize_mnt()
reports failure with refcount bumped, we drop out of RCU mode,
do mntput() and go back).

On failure in legitimize_links() we either leave nd->depth equal to zero
(in which case all nd->stack[...].link.mnt are to be ignored) or
we set it one higher than the last attempted legitimize_path() in there.
In the latter case, all entries in nd->stack below the value we put into
nd->depth had legitimize_path() called (and thus have ->mnt either NULL
or pinned) and everything starting from nd->depth is to be ignored.

nd->path handling:
1) Callers of legitimize_links() are responsible for zeroing nd->path.mnt
on legitimize_links() failure.  Both do that, AFAICS.
2) in try_to_unlazy() we proceed to call legitimize_path() on nd->path.
Once that call is done, we have nd->path.mnt pinned or NULL, so nothing
further is needed with it.
3) in try_to_unlazy_next() we use legitimize_mnt() instead.  Failure
of that is handled by zeroing nd->path.mnt; success means that nd->path.mnt
is pinned and should be left alone.

We could use __legitimize_mnt() in try_to_unlazy_next() (basically,
substitute the body of legitimize_mnt() there and massage it a bit),
but that ends up being harder to follow:
	res = __legitimize_mnt(nd->path.mnt, nd->m_seq);
	if (unlikely(res)) {
		if (res < 0)	// pinned, leave it there
			goto out1;
		else		// not pinned, zero it
			goto out2;
	}
instead of
        if (unlikely(!legitimize_mnt(nd->path.mnt, nd->m_seq)))
		goto out2;
we have now.
