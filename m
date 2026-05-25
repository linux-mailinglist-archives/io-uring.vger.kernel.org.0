Return-Path: <io-uring+bounces-13502-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iA4CJsdOFGqnMQcAu9opvQ
	(envelope-from <io-uring+bounces-13502-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 15:29:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B7F5CB20E
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 15:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 72E633006686
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 13:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DD2383981;
	Mon, 25 May 2026 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VIftsuP1"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D251B34D385;
	Mon, 25 May 2026 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779715781; cv=none; b=maS+wkEs1S42SJc7jRDAhW2KUBOZMRVBInAu6kstjg8LWMtAwjDjW8Ub+o7b/hhhxZgFuurZ6p95F6WuVulOSlDHdBOR+eameCVkVrZM0gWksh9kZq1sefrFSOP3pI748t9PoG1t30olZh8aCJeQfwyalzRHtoqdTMS0gbFp3OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779715781; c=relaxed/simple;
	bh=hAGwMiA/rEoh12wWJ9t4kfi+//QjQSBstnkhLWoHNek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5FgXcDtxUUI1CkhP9b8W3el2Wo4Vjgwo4b39z2O85qLJR11QpUU0lPhg2ZjoD48pnbjDOJCO2ZenUKt5fUOw9zWzCSxiYv2l5rE9UdrUur6M5wgCcqIT9hRja/s1LxOeV19boZ0XXASG/ZYMH8gZjUgNtKfeFoEVOgatc4iK4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VIftsuP1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bLsJutUZxDEIl/uXq2CeXvS0Y6SzcdSFKEmmUvrQt/Q=; b=VIftsuP1+Tx/xZtsLM00lHaZHC
	VLR9Y6UK2Ei8ZyiUbDPvORAXabqK8uVbkCVBdtUuNR9FOkGcnIYWwQiTBTQWdt7R0P2L8wmaEaaNh
	doUvPHMi6GiAaPtQSY8oZ6uzqlZqE1yN/SZn8hQWt1+Q3gbMuv833AXmlAbxbtriAjyBO/SF6NyA5
	3LsieRuwYBXlS1VNnyz4vONfRz4U4pifO5UrlkYKmZiI+IoD4Ds57OHvrUv/B1j1U8f7DHBk15TFz
	yv8xzM2xPZ6VLSiPBvDy1c3LXO8rpW2CP3DkrnzdEM4mNphGrOtY/Mh4o3jPSq9ek6cswYaZ35XE9
	14SToxMw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRVN1-0000000H9UB-2Rne;
	Mon, 25 May 2026 13:29:27 +0000
Date: Mon, 25 May 2026 14:29:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahROtyLcr567wM8l@casper.infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPm4h2gKgyEEuvV@infradead.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13502-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 08B7F5CB20E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, May 24, 2026 at 11:06:26PM -0700, Christoph Hellwig wrote:
> > +/**
> > + * bvec_folio - Return the first folio referenced by this bvec
> > + * @bv: bvec to access
> > + *
> > + * bvecs can span multiple folios.  Unless you know that this
> > + * bvec does not, you may be better off using something like
> > + * bio_for_each_folio_all() which iterates over all folios.
> > + */
> > +static inline struct folio *bvec_folio(const struct bio_vec *bv)
> > +{
> > +	return page_folio(bv->bv_page);
> > +}
> 
> The comment here is confusing.  bio_for_each_folio_all is a helper that
> only works in the submitter side, and not for anything using the
> bvec_iter required for drivers or anything else sitting below a
> potential bio clone/split or using bvecs from an upper layer (like
> ITER_BVEC direct I/O).  Additionally bv_page can be a different
> page than the fist page due to large bv_offset on split bios.
> 
> So I'm not against the function per se, but the documentation must
> explain the minefields it is stepping into a bit better.

Lower level drivers shouldn't be concerning themselves with folios.
For a start, we can put non-folios (eg slab memory) into bvecs.
I'm happy to clarify this comment further, but I don't understand
who's going to look at this function and need to have more explanation.

