Return-Path: <io-uring+bounces-10655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB50C6C371
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 02:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0C6F64EA4FC
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 01:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FE1226D17;
	Wed, 19 Nov 2025 01:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Nd5xbeJu"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFB122FDEA;
	Wed, 19 Nov 2025 01:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763514748; cv=none; b=KaWI1zOX8QJCDuWRhh1B+3TEur3BJ06W7hL4vHKMmTre/s39TkOR4spdaeQ5VG4CqJXFyi9SyHQjXODozu+fcMUmZsfVhQGFIeGHSxPX1LlI4XXsyvZpqzQzaZTBJzPSfVc2aeDj+iZE9EY1x4Kc+MhVzkQcnwsQZqLz4EpUfoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763514748; c=relaxed/simple;
	bh=2Rx8XCdzHjJIlTspDM1ljFO+dt4sCkDup0S9W+r6mCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n0TMaH59igp+UuCp3E+3zf6psDmudYdeWIrow9aLD8EC1QdAlWxvwdm7Th5iBHsYMd3mlw0Tr2SCnpSydVYATY4WXs8MHKFigP1+YOanIpE3T8iiTCAJZOn08S0WL5udx2OsJgVcfBTqupMmXzk7bfE5sLm2NBgJP3vMLQuoV80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Nd5xbeJu; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ez5hPH+ChtRiWvVs9RI2L5Gbgi4SNbK/1ae/jYD9A5g=; b=Nd5xbeJuKkYDpaKp+IP1rUny1z
	wJ3MSgpyz4YFNZZYgcPyQR0qn4aCFpyCVXNCtaejweH2XTamRV1OQzCyQNr09jFZPu5QttWM9P3Zf
	59ULI/tBiLPmBgUMBpqhc5DZBkj81we4bRzSr8SrCm73sK1CIo7FliRcEo+LZSM/BtwKwIretN45W
	BALGh86YpN7CeRDkerYfnyjMoV7iKT6+XaysEieGM0RivNpC++PF1KgcF8E5n2vXPnch86eqQmR09
	5I/fxmzjJ/APmjrBdp5Kjem1sy1b+Mbd4KtPXNAaj+gqy76vpns+gK7CDh/prKcb9wgsXiqA88vEI
	4XKzMkCA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLWkB-000000047t2-1Zr9;
	Wed, 19 Nov 2025 01:12:23 +0000
Date: Wed, 19 Nov 2025 01:12:23 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 11/13] allow incomplete imports of filenames
Message-ID: <20251119011223.GL2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-12-viro@zeniv.linux.org.uk>
 <257804ed-438e-4085-a8c2-ac107fe4c73d@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <257804ed-438e-4085-a8c2-ac107fe4c73d@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Nov 11, 2025 at 07:41:24AM -0700, Jens Axboe wrote:

> > diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> > index bfeb91b31bba..6bc14f626923 100644
> > --- a/io_uring/openclose.c
> > +++ b/io_uring/openclose.c
> > @@ -121,6 +118,7 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
> >  	struct file *file;
> >  	bool resolve_nonblock, nonblock_set;
> >  	bool fixed = !!open->file_slot;
> > +	struct filename *name __free(putname) = complete_getname(&open->filename);
> >  	int ret;
> >  
> >  	ret = build_open_flags(&open->how, &op);
> 
> I don't think this will work as-is - the prep has been done on the
> request, but we could be retrying io_openat2(). That will happen if this
> function returns -EAGAIN. That will then end up with a cleared out
> filename for the second (blocking) invocation.

If retry happens in a different thread, we do have a problem ;-/
This -EAGAIN might've come from ->open() itself (io_openat2() sets
O_NONBLOCK on the same calls), and by that point we have already
shoved that filename in direction of audit...

IMO the first 10 commits (up to and including audit_reusename() removal)
are useful on their own, but io_openat2() part does look broken.

Hmm...  FWIW, we could do a primitive like

int putname_to_incomplete(struct incomplete_name *v, struct filename *name)
{
	if (likely(name->refcnt == 1)) {
		v->__incomplete_filename = name;
		return 0;
	}
	v->__incomplete_filename = <duplicate name>;
	putname(name);
	if (unlikely(!v->__incomplete_filename))
		return -ENOMEM;
	return 0;
}

and have
                if (ret == -EAGAIN &&
		    (!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK))) {
			ret = putname_to_incomplete(&open->filename,
						    no_free_ptr(name));
			if (unlikely(ret))
				goto err;
			return -EAGAIN;
		}

in io_openat2() (in addition to what's already done in 11/13).  Workable or
too disgusting?

