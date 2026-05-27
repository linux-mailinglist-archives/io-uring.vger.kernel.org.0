Return-Path: <io-uring+bounces-13526-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8MNiOaQVF2px3wcAu9opvQ
	(envelope-from <io-uring+bounces-13526-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:02:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7615E761D
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E6B0B30477DB
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 15:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B441237F00A;
	Wed, 27 May 2026 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mvzMjij3"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B4837FF76;
	Wed, 27 May 2026 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897253; cv=none; b=dj48/75M2cCtif1y0//bLMI0N2O4B4nhuNOgJTyiyTyY31RfGkW9kFlsWV4i8DK0oghNR3y/FXIEe6EJ4LFTKTuJ4tVl7IFChPg9zSMZSeLkgtiiacfvjsQRhZH+ZNyReVgeH+t96+l/zb+zW4L6vMRbkCFuRVhwpBgj2FqUF9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897253; c=relaxed/simple;
	bh=mJSO9kqJwmefLIxtJiE7S3g75xzYcCRkbAVvq/3EaWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0QFEtphmxuc1aqS9azOSkOGFc/LEUVDySW8ODaPbhLzxoP8EJXVyEj7U6vF8RdiCU2kJfT6ERhP8IMYLINF2Ul+RbQcFflGvoRHIOzVEH65FQ+xLw+50DpaUbIH0Tte/NfHSjQJLKVPEe1eRLvFG5/f9vgCbwNBky455LDsfbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mvzMjij3; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r3kGopIcRkfvszZsA1EUPYixmwDaQOtICWsDPOe8I0o=; b=mvzMjij3hvAena8FUDu7i/An8i
	Hu1eU+qPGpk+KN69un2RqCY6ynnqD/2F6M9QVhjezGyAMrJx/wdlz8wt54HdgxPSSAkfBwB14FY3s
	qTZHOtLeakW785KrN4qJn6cvwr03hSqJvOkbHTML6+WLBbBNx5dZ3gH3lNF4aSz2qSwBp0Qg/nPFL
	Bu4tx9SBGf17DPG2SToycs773UlYDBv2wbjjUo4dX30QS8y/nawiK+iqloWG8nB+Ia/SdGHPjg+M3
	7+iHzYuRReuZ1peI4KDzTOMOmRXwWNkL5zGBmX1Nndy06qsRfeRrL1f5eOsKifn6NSQIn5a/0DR70
	njE9hAcQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSGa5-00000002unM-1n4L;
	Wed, 27 May 2026 15:54:05 +0000
Date: Wed, 27 May 2026 16:54:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahcTnfk_SjbN7J9e@casper.infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
 <ahROtyLcr567wM8l@casper.infradead.org>
 <ahVBCtsodsM2FHis@infradead.org>
 <ahXcsrxUFfzoVCOr@casper.infradead.org>
 <ahaNpbG15d6StT9d@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahaNpbG15d6StT9d@infradead.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13526-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[casper.infradead.org:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:dkim]
X-Rspamd-Queue-Id: 4E7615E761D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, May 26, 2026 at 11:22:29PM -0700, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 06:47:30PM +0100, Matthew Wilcox wrote:
> > How about:
> > 
> > /**
> >  * bvec_folio - Return the first folio referenced by this bvec
> >  * @bv: bvec to access
> >  *
> >  * bvecs can contain non-folio memory, so this should only be called by
> >  * the creator of the bvec; drivers have no business looking at the owner
> >  * of the memory.  It may not even be the right interface for the caller
> >  * to use as bvecs can span multiple folios.  You may be better off using
> >  * something like bio_for_each_folio_all() which iterates over all folios.
> >  */
> 
> Sounds good, although I'd captialize the first word in the sentence.
> (Not that anyone should follow my spelling advice in general)

I don't know how to capitalise bvec.  Is it Bvec?  BVec?

Fortunately my wife is an expert, and many years ago taught me that if
you have a difficult grammar problem, don't fix it, avoid it.

 * A bvec can contain non-folio memory, so this should only be called by

