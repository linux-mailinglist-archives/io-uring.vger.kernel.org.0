Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF396305B50
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 13:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhA0M02 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 07:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S314050AbhAZW4A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 17:56:00 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BCFC061574;
        Tue, 26 Jan 2021 14:55:19 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4XEm-006QPT-Jk; Tue, 26 Jan 2021 22:55:04 +0000
Date:   Tue, 26 Jan 2021 22:55:04 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: make do_mkdirat() take struct filename
Message-ID: <20210126225504.GM740243@zeniv-ca>
References: <20201116044529.1028783-1-dkadashev@gmail.com>
 <20201116044529.1028783-2-dkadashev@gmail.com>
 <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jan 24, 2021 at 09:38:19PM -0700, Jens Axboe wrote:
> On 11/15/20 9:45 PM, Dmitry Kadashev wrote:
> > Pass in the struct filename pointers instead of the user string, and
> > update the three callers to do the same. This is heavily based on
> > commit dbea8d345177 ("fs: make do_renameat2() take struct filename").
> > 
> > This behaves like do_unlinkat() and do_renameat2().
> 
> Al, are you OK with this patch? Leaving it quoted, though you should
> have the original too.

> > -static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
> > +long do_mkdirat(int dfd, struct filename *name, umode_t mode)
> >  {
> >  	struct dentry *dentry;
> >  	struct path path;
> >  	int error;
> >  	unsigned int lookup_flags = LOOKUP_DIRECTORY;
> >  
> > +	if (IS_ERR(name))
> > +		return PTR_ERR(name);
> > +
> >  retry:
> > -	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
> > -	if (IS_ERR(dentry))
> > -		return PTR_ERR(dentry);
> > +	name->refcnt++; /* filename_create() drops our ref */
> > +	dentry = filename_create(dfd, name, &path, lookup_flags);
> > +	if (IS_ERR(dentry)) {
> > +		error = PTR_ERR(dentry);
> > +		goto out;
> > +	}

No.  This is going to be a source of confusion from hell.  If anything,
you want a variant of filename_create() that does not drop name on
success.  With filename_create() itself being an inlined wrapper
for it.
