Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C711B30AABC
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 16:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhBAPBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 10:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhBAPB3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 10:01:29 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052EEC061788;
        Mon,  1 Feb 2021 07:00:56 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6ah0-008abO-Ec; Mon, 01 Feb 2021 15:00:42 +0000
Date:   Mon, 1 Feb 2021 15:00:42 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: make do_mkdirat() take struct filename
Message-ID: <20210201150042.GQ740243@zeniv-ca>
References: <20201116044529.1028783-1-dkadashev@gmail.com>
 <20201116044529.1028783-2-dkadashev@gmail.com>
 <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk>
 <20210126225504.GM740243@zeniv-ca>
 <CAOKbgA4fTyiU4Xi7zqELT+WeU79S07JF4krhNv3Nq_DS61xa-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOKbgA4fTyiU4Xi7zqELT+WeU79S07JF4krhNv3Nq_DS61xa-A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 01, 2021 at 06:09:01PM +0700, Dmitry Kadashev wrote:

> Hi Al,
> 
> I think I need more guidance here. First of all, I've based that code on
> commit 7cdfa44227b0 ("vfs: Fix refcounting of filenames in fs_parser"), which
> does exactly the same refcount bump in fs_parser.c for filename_lookup().  I'm
> not saying it's a good excuse to introduce more code like that if that's a bad
> code though.

It is a bad code.  If you look at that function, you'll see that the entire
mess around put_f is rather hard to follow and reason about.  That's a function
with no users, and I'm not sure we want to keep it long-term.

> What I _am_ saying is we probably want to make the approaches consistent (at
> least eventually), which means we'd need the same "don't drop the name" variant
> of filename_lookup?

"don't drop the name on success", similar to what filename_parentat() does.

> And given the fact filename_parentat (used from
> filename_create) drops the name on error it looks like we'd need another copy of
> it too?

No need.

> Do you think it's really worth it or maybe all of these functions will
> make things more confusing? (from the looks of it right now the convention is
> that the `struct filename` ownership is always transferred when it is passed as
> an arg)
> 
> Also, do you have a good name for such functions that do not drop the name?
> 
> And, just for my education, can you explain why the reference counting for
> struct filename exists if it's considered a bad practice to increase the
> reference counter (assuming the cleanup code is correct)?

The last one is the easiest to answer - we want to keep the imported strings
around for audit.  It's not so much a proper refcounting as it is "we might
want freeing delayed" implemented as refcount.

As for do_mkdirat(), you probably want semantics similar to do_unlinkat(), i.e.
have it consume the argument passed to it.  The main complication comes
from ESTALE retries; want -ESTALE from ->mkdir() itself to trigger "redo
filename_parentat() with LOOKUP_REVAL, then try the rest one more time".
For which you need to keep filename around.  OK, so you want a variant of
filename_create() that would _not_ consume the filename on success (i.e.
act as filename_parentat() itself does).  Which is trivial to implement -
just rename filename_create() to __filename_create() and remove one of
two putname() in there, leaving just the one in failure exits.  Then
filename_create() itself becomes simply

static inline struct dentry *filename_create(int dfd, struct filename *name,
                                struct path *path, unsigned int lookup_flags)
{
	struct dentry *res = __filename_create(dfd, name, path, lookup_flags);
	if (!IS_ERR(res))
		putname(name);
	return res;
}

and in your do_mkdirat() replacement use
	dentry = __filename_create(dfd, filename, &path, lookup_flags);
instead of
        dentry = user_path_create(dfd, pathname, &path, lookup_flags);
and add
	putname(filename);
in the very end.  All it takes...
