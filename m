Return-Path: <io-uring+bounces-13508-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BLNBtHcFWrTdQcAu9opvQ
	(envelope-from <io-uring+bounces-13508-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 19:48:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D58C5DAE8D
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 19:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9AC16300E5FE
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 17:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2A941B366;
	Tue, 26 May 2026 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZDbJ9u9B"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9ED3F7AB2;
	Tue, 26 May 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779817657; cv=none; b=YLseScKvRDWkwwUbqKuhp4bZIt7mLd+TJNHUG8Jx56e4sywtKPTix51NVQtRqW39+RIqR9A10YvDd2esX3yqPz7vq8C2vULrcY6j2wK7cthvI8VWxiS9djOcaiX23FArQWbOqqpLpHHXhRvpVIr7S+A1dNFMfTHgUOnjWXjIN3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779817657; c=relaxed/simple;
	bh=avkOWiNgD9pXcohll8sYbzk80rwewxXGSC2exgbOpiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocFQ9UuJnVluQBEKYnhQEY66RHbG8zAdm1L4wIdrPcJw8+trb1tyJlaD+AiVCqJ/fxdl/aS473gDSVgpwAXkgDTk6Ghm7z3M8NT2KYCWR+VjqnBeDyIqOwLx+mrBnKEnwDwaxB2f0FED7vydVkO96TSx40VnnPB6oEquXA7jow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZDbJ9u9B; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=obRsQ1GuuOVKjDYMtGxxbgivbv2h67tD79o7v9BhPZI=; b=ZDbJ9u9BFvwxXxLG1LFlcEvnKw
	i1CjHb0eytwQjIOb6IV6mejfIJePHkJ1GI1eizRXJ4YdJUyzSRVO/k3bQT0xYGd6FvX2owKIQzQbG
	sKIBX3igF9DaozOI76Voyomv+o5dlknH7Gfi3kzMPSHvoCNpQx9HCganUiOOdKpveeFJdeCWnesXp
	hBF9AfTT0IBl8crJyGIzS3YQgEFkZdx1Ro86ISN3Nl+0dJLZP+gptI6T16ljh/qVlRoTszpRLzOKJ
	tdSpxrNraKn1Rn4NoRYTYh4J49Fx5XgHXihgpnee5Sf+RsicqB0ibQQ4KittPIrqtUbZL+Y/qx0ZP
	kThsRjKA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRvsI-00000001MNz-2rl4;
	Tue, 26 May 2026 17:47:30 +0000
Date: Tue, 26 May 2026 18:47:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahXcsrxUFfzoVCOr@casper.infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
 <ahROtyLcr567wM8l@casper.infradead.org>
 <ahVBCtsodsM2FHis@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahVBCtsodsM2FHis@infradead.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13508-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[casper.infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 2D58C5DAE8D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 25, 2026 at 11:43:22PM -0700, Christoph Hellwig wrote:
> On Mon, May 25, 2026 at 02:29:27PM +0100, Matthew Wilcox wrote:
> > > So I'm not against the function per se, but the documentation must
> > > explain the minefields it is stepping into a bit better.
> > 
> > Lower level drivers shouldn't be concerning themselves with folios.
> > For a start, we can put non-folios (eg slab memory) into bvecs.
> 
> Well, that is a very good thing to put into the comment.  We can also
> put them into high-level bvecs, so framing this as 'only use if you
> know the memory is folios, which you can't unless you are the entity
> who filled the bio' might be a good choice.

How about:

/**
 * bvec_folio - Return the first folio referenced by this bvec
 * @bv: bvec to access
 *
 * bvecs can contain non-folio memory, so this should only be called by
 * the creator of the bvec; drivers have no business looking at the owner
 * of the memory.  It may not even be the right interface for the caller
 * to use as bvecs can span multiple folios.  You may be better off using
 * something like bio_for_each_folio_all() which iterates over all folios.
 */


