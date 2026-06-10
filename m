Return-Path: <io-uring+bounces-13658-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id htbZDe9MKWpFUQMAu9opvQ
	(envelope-from <io-uring+bounces-13658-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 13:39:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 802DB668DF3
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 13:39:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=X8o7G3dr;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13658-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13658-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=infradead.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3883E31FE934
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 11:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28503FD956;
	Wed, 10 Jun 2026 11:34:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EB33E3D94;
	Wed, 10 Jun 2026 11:34:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781091264; cv=none; b=r2DHmtpxfF5S1QDZAtozdlNG4p8SEXjO/ryKPCFyhVQGWYinxgpjvKrtUfZJ9qvirYanZkJy45mk84Ddh9oLG+hPCoUb47THjPiyrXNCVI6yQxmVE6rF/ZYEcnNHx4K9jOlqBCUGxSzCaE/NQ4rsRiXo9hya1DIu2LgwTeZv6Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781091264; c=relaxed/simple;
	bh=X3CGElBYBq/DR8zDvRk1BpXGX5aF5tjW3M5hj69ecwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAroTU0aCXVELz1F1GFCJP33k76rQgdv5PK22Ri5zzWooofzjaSXnNSr7+6WpdxeKHEwF/+//tMw3WnayDtgFMf3gEKn/AQfq9hCYu89Sbgo1uq1zSDSjqHnY+l1UoCn+5lp2tBpP6kDeCvvLMyQTnb8AanImrG0w7Ui0qkY1xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X8o7G3dr; arc=none smtp.client-ip=198.137.202.133
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J6hoPXLvOx2TCA04yMR1djb76KWHLJVHc2qvhWJmOVg=; b=X8o7G3drVcOXM+/TpI2tFzOhkP
	P+GddtDvp2pcyv740wKRQAwQ86oEtCJXElaDEVU3xXw6NMUe09t3i+I/y4Gy2LaNxWs4SavNjxxbA
	2bI8d6iDEqIo6r3aRUBUy7lP6q0/j4fdw5S3JIe5VcLvkNTG+oqL2jFV5uMajzkRvBMc6Gc0SrH8C
	Ob7UActExDvwWTL2K40r6rxwQjd8KTodQrivPka0hP1PcWGPHWu1LQ54JVLeDi1k+dwx0LbLl5Qag
	m0Dna0idaCifxxntWzhZNWcDEJlnNxFv9AywFjTHAjESdqqJWDlBqVf3QmhF6kInPlW4BdTCFDcah
	n6VMPwnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXHCN-00000007Y6Q-3gpC;
	Wed, 10 Jun 2026 11:34:19 +0000
Date: Wed, 10 Jun 2026 04:34:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, sw.prabhu6@gmail.com,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, dave@stgolabs.net,
	dongjoo.seo1@samsung.com, Swarna Prabhu <s.prabhu@samsung.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
Message-ID: <ailLu70plC9WK2dB@infradead.org>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
 <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13658-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:david@kernel.org,m:hch@infradead.org,m:sw.prabhu6@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dave@stgolabs.net,m:dongjoo.seo1@samsung.com,m:s.prabhu@samsung.com,m:linux-mm@kvack.org,m:willy@infradead.org,m:ziy@nvidia.com,m:swprabhu6@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,kernel.dk,vger.kernel.org,stgolabs.net,samsung.com,kvack.org,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:dkim,infradead.org:mid,infradead.org:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 802DB668DF3

On Wed, Jun 10, 2026 at 11:54:01AM +0200, David Hildenbrand (Arm) wrote:
> > Yes.  iov_iter_extract_bvecs and thus the block direct I/O fast path
> > would instantly benefit from that.
> The tricky bit for such an interface is that, soon, some pages won't be folios,
> but we could still end up with non-folio pages in the address space (e.g.,
> vm_insert_page()) and have to pin+return them. So using folios is not future-proof.

I'm still doubtful on the "soon" beause of all the issues like this
in the I/O path.

> There are some long-term plans on providing an interface that would abstract how
> you refcount something you GUP'ed. (because, some pages we GUP in the future
> might not even have a dedicated refcount, all still fairly unclear). But it's
> all not really finalized I think.
> 
> For now, we could expose a folio+page/offset+nr_pages interface, where we,
> long-term, would not be able to return non-folio pages (e.g., vm_insert_page())
> and would instead, in the future, fail the request if we stumble over a
> non-folio thing in the page tables. That sounds reasonable for now.

I think whatever we're going to use for direct I/O has to also support
non-folio pages, especially PCI P2P memory.  So coming up with an
interface that support this ASAP would be helpful.

> Another solution would be, exposing page-ranges (e.g., page + nr_pages), whereby
> we'd say, that all pages in a range belong to the same compound page, and that
> we took a single reference for all pages in the range. IOW, page_folio() would
> for now be the same for all pages in a range.

This does sound like a reasonable short-term improvement.  One annoying
issue with returning only order 0 page in the current interfaces is
that it fills up the pages array in the caller for no good reason.


