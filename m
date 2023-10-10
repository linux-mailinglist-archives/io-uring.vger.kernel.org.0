Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4677BF26E
	for <lists+io-uring@lfdr.de>; Tue, 10 Oct 2023 07:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442153AbjJJFrv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Oct 2023 01:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379414AbjJJFrs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Oct 2023 01:47:48 -0400
Received: from bird.elm.relay.mailchannels.net (bird.elm.relay.mailchannels.net [23.83.212.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AF692;
        Mon,  9 Oct 2023 22:47:40 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 983C5761605;
        Tue, 10 Oct 2023 05:47:39 +0000 (UTC)
Received: from pdx1-sub0-mail-a261.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 27DC77611AA;
        Tue, 10 Oct 2023 05:47:39 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1696916859; a=rsa-sha256;
        cv=none;
        b=3Z1e2c5Gqc2xgCnjewSbdWiqgp5EWzzAh1cooBlA68uNeMxNfXF7LqyqsyYei3XzERgfHd
        JU+anznxsGCAaXKF+WQVmpjMLp9A/ncivPLYuR3u2OS4PkcecbapXNfBtM28ho4LJhsSvU
        4gdlPWV+LS8g/nqgLXSEO4MRqe+f5qzRmKcVEaAyz7cnh1Mv3ETxGWsu2mU5Vha3x/lIhi
        tkA7GcRyLqIz21KOlmBVC6vZ1wOyArEwbPnz6ju5rpPQIQCxaQRvaKopZedQOp4brJkBrH
        ELBPtm3g8YNvejCrDBWcS2Ng1pTbcJiUe/v5NOuTj8y33N9ggJS5o9WrfzwweQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1696916859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=1zJT0VoGrkLAtBvhsAQ+j3jJoyvQlLyGd/QNJF4U6d8=;
        b=JsGi1WTL7PegJ2AJ2gkBsup3Lk3lxOerUAaqdnDDs+h1tuLYtG9DdYwB3qfWN4lpXzxsu/
        6qmnWOpec2X0SoqM5MYd0QOXFtEjx18de83mHe1D7xpUvTWIqnU5BGPBALm0n46t1thZZv
        7t8WFCru1+9rtsq8kWYEEUm/JTyDoy8xFlJGuuJC7Qx4yUz5Om4aBDMQumJtrqZiXPXb9X
        U/TYVLLX64drNYCEaVHfx6m37O5lkBLwQ8ziHAgGHyoBtSSgch4iTS8hmlynEG5MvNtqIX
        siuJ1p/S0/SuggU07JWvyUeGjTLTJDN/0v0mnwLwVSiHAfNOidwk4oIOl0B5Eg==
ARC-Authentication-Results: i=1;
        rspamd-7c449d4847-9wgh4;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=bugs@claycon.org
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Scare-Tangy: 23e2acda17cb4c22_1696916859459_3115200803
X-MC-Loop-Signature: 1696916859459:1200585657
X-MC-Ingress-Time: 1696916859458
Received: from pdx1-sub0-mail-a261.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.103.131.218 (trex/6.9.1);
        Tue, 10 Oct 2023 05:47:39 +0000
Received: from vps46052.dreamhostps.com (vps46052.dreamhostps.com [69.163.237.247])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a261.dreamhost.com (Postfix) with ESMTPSA id 4S4Q0V6Kd6z3H;
        Mon,  9 Oct 2023 22:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=claycon.org;
        s=dreamhost; t=1696916858;
        bh=1zJT0VoGrkLAtBvhsAQ+j3jJoyvQlLyGd/QNJF4U6d8=;
        h=Date:From:To:Cc:Subject:Content-Type:Content-Transfer-Encoding;
        b=IHdXtsVEqd6iCHMau92UV943x3KhHWkAZtYK2DWLmbX8zDC9bVTEQhs6EH0tPXqNa
         LkjQ1xd1VAJ90uF8XBvq5AN/S0+zQ7D8CVuoVU7AJjdzOcd0xijCq+VcRF5PadSfsx
         OvCLW/kBnA+V+7yVExOpf3pIidagcKoh+AtNExjTRPGUwFHjUi4wmlff0AX0CEHt1y
         Nu1fsWjgEj5yECIPeXmmCKKpkiio8OgPFEDCHHKxd3syH+bibtp0MphRGomXAxRybh
         L7TEfDF0+UNU2XK+GFeJEZMgaTVqzEFZubRlZvxpHbygMm3tVjugnFmTOcihsIl6eI
         qIDkI2G7dtYcw==
Date:   Tue, 10 Oct 2023 00:47:37 -0500
From:   Clay Harris <bugs@claycon.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH] fs: add AT_EMPTY_PATH support to unlinkat()
Message-ID: <ZSTleVf6eNII3dg3@vps46052.dreamhostps.com>
References: <20230929140456.23767-1-lhenriques@suse.de>
 <20231009020623.GB800259@ZenIV>
 <87lecbrfos.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lecbrfos.fsf@suse.de>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apologies, this message was intended as a reply to Al Viro, but I accidentally
deleted that message so I'm replying to the reply instead.

On Mon, Oct 09 2023 at 16:14:27 +0100, Luis Henriques quoth thus:

> Al Viro <viro@zeniv.linux.org.uk> writes:
> 
> > On Fri, Sep 29, 2023 at 03:04:56PM +0100, Luis Henriques wrote:
> >
> >> -int do_unlinkat(int dfd, struct filename *name)
> >> +int do_unlinkat(int dfd, struct filename *name, int flags)
> >>  {
> >>  	int error;
> >> -	struct dentry *dentry;
> >> +	struct dentry *dentry, *parent;
> >>  	struct path path;
> >>  	struct qstr last;
> >>  	int type;
> >>  	struct inode *inode = NULL;
> >>  	struct inode *delegated_inode = NULL;
> >>  	unsigned int lookup_flags = 0;
> >> -retry:
> >> -	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
> >> -	if (error)
> >> -		goto exit1;
> >> +	bool empty_path = (flags & AT_EMPTY_PATH);
> >>  
> >> -	error = -EISDIR;
> >> -	if (type != LAST_NORM)
> >> -		goto exit2;
> >> +retry:
> >> +	if (empty_path) {
> >> +		error = filename_lookup(dfd, name, 0, &path, NULL);
> >> +		if (error)
> >> +			goto exit1;
> >> +		parent = path.dentry->d_parent;
> >> +		dentry = path.dentry;
> >> +	} else {
> >> +		error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
> >> +		if (error)
> >> +			goto exit1;
> >> +		error = -EISDIR;
> >> +		if (type != LAST_NORM)
> >> +			goto exit2;
> >> +		parent = path.dentry;
> >> +	}
> >>  
> >>  	error = mnt_want_write(path.mnt);
> >>  	if (error)
> >>  		goto exit2;
> >>  retry_deleg:
> >> -	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
> >> -	dentry = lookup_one_qstr_excl(&last, path.dentry, lookup_flags);
> >> +	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> >> +	if (!empty_path)
> >> +		dentry = lookup_one_qstr_excl(&last, parent, lookup_flags);
> >
> > For starters, your 'parent' might have been freed under you, just as you'd
> > been trying to lock its inode.  Or it could have become negative just as you'd
> > been fetching its ->d_inode, while we are at it.
> >
> > Races aside, you are changing permissions required for removing files.  For
> > unlink() you need to be able to get to the parent directory; if it's e.g.
> > outside of your namespace, you can't do anything to it.  If file had been
> > opened there by somebody who could reach it and passed to you (via SCM_RIGHTS,
> > for example) you currently can't remove the sucker.  With this change that
> > is no longer true.
> >
> > The same goes for the situation when file is bound into your namespace (or
> > chroot jail, for that matter).  path.dentry might very well be equal to
> > root of path.mnt; path.dentry->d_parent might be in part of tree that is
> > no longer visible *anywhere*.  rmdir() should not be able to do anything
> > with it...
> >
> > IMO it's fundamentally broken; not just implementation, but the concept
> > itself.
> >
> > NAKed-by: Al Viro <viro@zeniv.linux.org.uk>

Al, thank you for this information.  It does shine a little light on where
dragons may be hiding.  I was wondering if you could comment on a related
issue.

linkat does allow specifing AT_EMPTY_PATH.  However, it requires
CAP_DAC_READ_SEARCH.  I saw that a patch went into the kernel to remove
this restriction, but was shortly thereafter reverted with a comment
to the effect of "We'll have to think about this a little more".  Then,
radio silence.  Other than requiring /proc be mounted to bypass, what
problem does this restriction solve?

Also related, the thing I'm even more interested in is the ability to
create an O_TMPFILE, populate it, set permissions, etc, and then make
it appear in a directory.  The problem is I almost always don't want it
to just appear, but rather atomically replace an older version of the
file.

dfd = openat(x, "y", O_RDONLY | O_CLOEXEC | O_DIRECTORY, 0)
fd = openat(dfd, ".", O_RDWR | O_CLOEXEC | O_TMPFILE, 0600)
do stuff with fd
fsync(fd)
linkat(fd, "", dfd, "z", AT_EMPTY_PATH | AT_REPLACE?)
close(fd)
fsync(dfd)
close(dfd)

The AT_REPLACE flag has been suggested before to work around the EEXIST
behavior.  Alternatively, renameat2 could accept AT_EMPTY_PATH for
olddirfd/oldpath, but fixing up linkat seems a little cleaner.  Without
this, it hardly seems worthwhile to use O_TMPFILE at all, and instead
just go through the hassle of creating the file with a random name
(plus exposing that file and having to possibly rm it in case of an error).

I haven't been able to find any explanation for the AT_REPLACE idea not
gaining traction.  Is there some security reason for this?

Thanks


> Thank you for your review, which made me glad I sent out the patch early
> as an RFC.  I (think I) understand the issues you pointed out and,
> although some of them could be fixed (the races), I guess there's no point
> pursuing this any further, since you consider the concept itself to be
> broken.  Again, thank you for your time.
> 
> Cheers,
> -- 
> Luís
