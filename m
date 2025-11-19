Return-Path: <io-uring+bounces-10658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C342C6CD03
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 06:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B47DC362E13
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 05:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3682BEC52;
	Wed, 19 Nov 2025 05:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="SL8Dy2Ip"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF23143C61;
	Wed, 19 Nov 2025 05:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763530897; cv=none; b=YuxhQD/ZftLLJWexz82aP+dIWjkn8/M34GvVFl7vfrZ04t+iRyTfz/0wtLKY6JynO/CPIkRrNzoFEXx8l3zp3RFjSj9jO0Rh2VUgCfVhOmHrkZwZ/aOdsSobpVZ0y/p+zEHmbbQNxX+u9duF/3OtasK/NSm+3evmlMof1R7bBj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763530897; c=relaxed/simple;
	bh=ibBq23sPdSFm0fiZJaytw/GAfU5GxowJ5jnInz3BJH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sj0yyvjjula2EWUhxIxAj70RV/5R3PsSPEWdnC1aqFveBxMGHx7sybc+UdUriPQmTbfIWIkOqrDi54nFDyUldlUcaP26XxQirZAxJ2s/re/rh+EniBqStgDz0Du5xg97WczmaG4uI1B+XHtyz5n4hlK6/6QzyonqZkXW3UhGV/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=SL8Dy2Ip; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IQsQJ9QrapoyaYZ8r5l9EcbgTw+V8hra2P2RAgbU298=; b=SL8Dy2Ip4kqIcDJbzTzyNYbtY8
	Zoe8HqRa0hhNebNVvyKNeyBjjd/DJe2mPcmR476wkuhRODEh1FQ18c3vzVgO2q01FdgynbSscdvfL
	Q4O51jR1JBeu9Gq791KWjwag+5go7I8lMwZEymLBYUAR9b1LfXfhW3Wa6srcQgxT6JyKgw13ApMz4
	wQmD85sAdApxUY0HPri6IliCiGfb/9wQDGhjXmfp/AN+fOi2TIs1oiCwVFauCTpXEf6+AeSiCv1Po
	io8RON9uHExmKktIKGFMSmcdUN6ovzg3cQxHslSpKHZb4dZefvMpBgpI03GOWmu3BkTz7Gacja2LW
	1TmR2JwQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLawc-00000009edX-1EdE;
	Wed, 19 Nov 2025 05:41:30 +0000
Date: Wed, 19 Nov 2025 05:41:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 11/13] allow incomplete imports of filenames
Message-ID: <20251119054130.GN2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-12-viro@zeniv.linux.org.uk>
 <257804ed-438e-4085-a8c2-ac107fe4c73d@kernel.dk>
 <20251119011223.GL2441659@ZenIV>
 <20251119011447.GM2441659@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119011447.GM2441659@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Nov 19, 2025 at 01:14:47AM +0000, Al Viro wrote:
> On Wed, Nov 19, 2025 at 01:12:23AM +0000, Al Viro wrote:
> 
> > int putname_to_incomplete(struct incomplete_name *v, struct filename *name)
> > {
> > 	if (likely(name->refcnt == 1)) {
> > 		v->__incomplete_filename = name;
> > 		return 0;
> > 	}
> > 	v->__incomplete_filename = <duplicate name>;
> > 	putname(name);
> > 	if (unlikely(!v->__incomplete_filename))
> > 		return -ENOMEM;
> > 	return 0;
> > }
> > 
> > and have
> >                 if (ret == -EAGAIN &&
> > 		    (!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK))) {
> > 			ret = putname_to_incomplete(&open->filename,
> > 						    no_free_ptr(name));
> > 			if (unlikely(ret))
> > 				goto err;
> > 			return -EAGAIN;
> > 		}
> > 
> > in io_openat2() (in addition to what's already done in 11/13).  Workable or
> > too disgusting?
> 
> Note that copying would happen only if extra references had been grabbed
> and are still held; that's already a slow path.

... and writing the "duplicate name" part has been a very convincing argument
in favour of a scheme Linus suggested upthread (shorter embedded name,
struct filename *always* coming from names_cachep, long name or short).
Current layout is too unpleasant to work with.

