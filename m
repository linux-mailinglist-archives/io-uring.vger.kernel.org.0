Return-Path: <io-uring+bounces-10656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EE954C6C386
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 02:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E6A004E1B4A
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 01:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4966224AE8;
	Wed, 19 Nov 2025 01:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="XahLDQ/m"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7423822154B;
	Wed, 19 Nov 2025 01:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763514891; cv=none; b=N1GeDBxicen6cquyQGQgJYAKHz/ahtMU9KgsEwclg3dzkRL4YUr+f4+ZGMHaizVK90M3NclwbnuY8q589cEmmqfLJoqBxpdiP31HzYXGJLexN9DjZxyabjtv9HPVJIQ0Pd5kzhIjeH9FeXZwGoQFn9/+XUUdzhgt4+EVQwdSDJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763514891; c=relaxed/simple;
	bh=Wu7LjLAOBb0+e+MQ/Py5o+8QQLdZuMlq15GHQwj4YeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/WcI+ppamKGHc0QPEstCxM2iLygJtkbAyYYpqenKcjxN5qfXmUfxxX3Y5rFOCgD0fEqZNHaqUuECvp81YTZHSviUQwt74ekfcpOTLBLCN8XTao/f8BBLw8+gVHVj9IAa0xGAuH90Y5+aDXY96wPdHusO7gvVXtZSzKAlQZveQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=XahLDQ/m; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kRUa2+eEEst0Qe7yL2Pj2TauMzIwNCDek+dlaGZLtqY=; b=XahLDQ/mnKV7z4FMalMSxSBhh9
	7bkDhrG1p2tqEOMkPLkxl5kr7Nc9VtceSrFcJgqAPNJouYnHJO/C0D1CJsQvz4Y5zCJJkXt7iw61C
	qvEkUEvsL/YhyVTtxAe6mxmssV8SPP4/+d61o0V5BYqOLWfzYtVGE+wKLBVZKAEPY7lwa3mpj+m9x
	/XDsyZQAWhDdSyyfg8LvcvWZ6JIDtSF4R83QJa3SUqhH5bcuTBoUrV00kI3giXitxOAgfcXgHD0g9
	JJD7F1hSNDn2rQZZlovMY2g4jFEAq24lDMD82LWC0ogtA09NHT2W3CDqTAjdvij8RGD2SzSeRUXio
	b9enR0Zg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLWmV-00000004AzB-3MnT;
	Wed, 19 Nov 2025 01:14:47 +0000
Date: Wed, 19 Nov 2025 01:14:47 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 11/13] allow incomplete imports of filenames
Message-ID: <20251119011447.GM2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-12-viro@zeniv.linux.org.uk>
 <257804ed-438e-4085-a8c2-ac107fe4c73d@kernel.dk>
 <20251119011223.GL2441659@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119011223.GL2441659@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Nov 19, 2025 at 01:12:23AM +0000, Al Viro wrote:

> int putname_to_incomplete(struct incomplete_name *v, struct filename *name)
> {
> 	if (likely(name->refcnt == 1)) {
> 		v->__incomplete_filename = name;
> 		return 0;
> 	}
> 	v->__incomplete_filename = <duplicate name>;
> 	putname(name);
> 	if (unlikely(!v->__incomplete_filename))
> 		return -ENOMEM;
> 	return 0;
> }
> 
> and have
>                 if (ret == -EAGAIN &&
> 		    (!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK))) {
> 			ret = putname_to_incomplete(&open->filename,
> 						    no_free_ptr(name));
> 			if (unlikely(ret))
> 				goto err;
> 			return -EAGAIN;
> 		}
> 
> in io_openat2() (in addition to what's already done in 11/13).  Workable or
> too disgusting?

Note that copying would happen only if extra references had been grabbed
and are still held; that's already a slow path.

