Return-Path: <io-uring+bounces-3292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 657F8984CFD
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 23:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2442328212F
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 21:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66B484037;
	Tue, 24 Sep 2024 21:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="hq5N7u2X"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46000139D07;
	Tue, 24 Sep 2024 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727214050; cv=none; b=A2ulZt4K0GOlT1O+66vwGBDZIUYmn7gh2LvgWxP1J5H+AEQQ989l8dhFvZ7v94KZg2JL8R2dk5f959iTGU3TeJOyLjDQvFRLlcNV3cGTLtRP+d14FjyezS1gjqq2LFa6Cl/7ovQgK3XHLLcEQzc4c55sKZPyt/6HWTMU1HbHgHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727214050; c=relaxed/simple;
	bh=RAY0u//V5rvoEZZJ6lQ/D9MwyO04UCLNzZYwgP66+Ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEEtmb4g9TeSbWFUJy8tqRtmFPW6GaPRfUaRP6VZ7Uyqri4rw7AT4BGcMIYUB24xZR81I6NYVHuBIXmX5R9Xy0fUyb9Mmx3Hz1DgZeP0mhURbcMbwdIW9gsCQ6HlGvYf9enJaOca5QulXkmFdxO32J3aoPclJDE1kNq+V7F4Ytg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=hq5N7u2X; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gKzZoHtKoQWl2qi2qmcWi2Bu3o5mOcFywRRncUL9Cfg=; b=hq5N7u2XV+zDCVKFHzns1TCFn/
	kspjA5kqFkxkWIj0Jc0y+QqJRyXTZunAYJnGe2SzgIviyRpAWaaolE36ayZ3ddXsixTePqeeYIfnG
	sLLc8N/BZFxLdO4D4oFtaGprecNos3r787ymgFLRkPj2elGzrplihUnP+Volgps8YRfVKzPnAb7Vg
	5lIuIs30Vrys62KecDMSPevZry0x3eeZXFmyijEmxv4tu/9oTmgjwIbb/QvMLTzk++TDgWkzqwFQj
	sPuV9RMM6vzwvJLU6wo11ZfUDyXQOrUBXGmm88LPLVEm3m6PfgBzbAm7Vq+QJqtseZ3xoSU47Tj0R
	T1WOBePg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1stDH4-0000000FF1v-2cLM;
	Tue, 24 Sep 2024 21:40:46 +0000
Date: Tue, 24 Sep 2024 22:40:46 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240924214046.GG3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
 <20240923203659.GD3550746@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923203659.GD3550746@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 23, 2024 at 09:36:59PM +0100, Al Viro wrote:

> 	* go through the VFS side of things and make sure we have a consistent
> set of helpers that would take struct filename * - *not* the ad-hoc mix we
> have right now, when that's basically driven by io_uring borging them in
> one by one - or duplicates them without bothering to share helpers.
> E.g. mkdirat(2) does getname() and passes it to do_mkdirat(), which
> consumes the sucker; so does mknodat(2), but do_mknodat() is static.  OTOH,
> path_setxattr() does setxattr_copy(), then retry_estale loop with
> user_path_at() + mnt_want_write() + do_setxattr() + mnt_drop_write() + path_put()
> as a body, while on io_uring side we have retry_estale loop with filename_lookup() +
> (io_uring helper that does mnt_want_write() + do_setxattr() + mnt_drop_write()) +
> path_put().
> 	Sure, that user_path_at() call is getname() + filename_lookup() + putname(),
> so they are equivalent, but keeping that shite in sync is going to be trouble.

BTW, re mess around xattr:
static int __io_getxattr_prep(struct io_kiocb *req,
                              const struct io_uring_sqe *sqe)
{
...
        ix->ctx.cvalue = u64_to_user_ptr(READ_ONCE(sqe->addr2));
	ix->ctx.size = READ_ONCE(sqe->len);
...
        ret = strncpy_from_user(ix->ctx.kname->name, name,
				sizeof(ix->ctx.kname->name));

}

int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
{
...
        ret = do_getxattr(file_mnt_idmap(req->file),
			req->file->f_path.dentry,
			&ix->ctx);
...
}

ssize_t
do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
        struct xattr_ctx *ctx)
{
...
        if (error > 0) {
		if (ctx->size && copy_to_user(ctx->value, ctx->kvalue, error))
...
}

and we have
struct xattr_ctx {
        /* Value of attribute */
	union {
		const void __user *cvalue;
		void __user *value;
	};
	...
}

Undefined behaviour aside, there's something odd going on here:
why do we bother with copy-in in ->prep() when we do copy-out in
->issue() anyway?  ->issue() does run with initiator's ->mm in use,
right?

IOW, what's the io_uring policy on what gets copied in ->prep() vs.
in ->issue()?

