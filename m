Return-Path: <io-uring+bounces-13662-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /S//BG2pKWp4bgMAu9opvQ
	(envelope-from <io-uring+bounces-13662-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 20:14:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6020B66C313
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 20:14:04 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="DouEq/+y";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13662-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13662-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=infradead.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4475316776E
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 18:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4DE34F48F;
	Wed, 10 Jun 2026 18:11:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D1C34B1B0;
	Wed, 10 Jun 2026 18:11:00 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781115065; cv=none; b=XFx/rISR/JTPqDrKKaXjsv7aUJsP35N+I7RzcKxPQHosoZsHLpPOM5YA9P2FF1QJkETbTgtfhVTkjmETzMRurkmA7HPqfMEWQSbGVT06FpkX1cLjxmVTmaUDU8e37B8VIyXJ9QmEfa6a6wf4eik2TDi0JfFFi9opVKEZKcHImgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781115065; c=relaxed/simple;
	bh=Xd2pj3xhAo9zXXvm+rfa0E2/vbFlGKgWPLn36oCgSS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vc5Fb1epczsanEaXxDqvNaPXyB5VBpJ4yz8wK0qIQBjzoYesbVtupEi6KYOlHrGIZWmNLYoYeahPGSAIbyVwVs47RkbnGD9fKyj9iQ3zi8OipOE8aawWYGlyfCoy9DcpGnt7NLA9rDrNVR4ThneoskGrlwRFuMMe1F4Judb6jkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DouEq/+y; arc=none smtp.client-ip=90.155.50.34
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cCD6fQlo+amCuh2MJv98stulEbrclG69/C//PGhk/Sw=; b=DouEq/+yDo0pRJvgQ60O6kXBai
	Ukq/D/vSXod6hUKOikuCeKPo8Me471D5X/InNXt9Mrw+d3nqA2q6LmVviXuqIRJzb65ymoXVaC6cu
	I6I+MoIg4gwlIY9+c4q1/WILLKuesO+b4sus1NrvzKylUGGa4Ycq3nFf6n82n1PIdefK8QxRK8C/T
	sow1zS8+CmxK6d94lM+hTMbNCTKWsosT0gqP88ddvHWhb5PMoZqydmsOBLxFxCxpkbMY9S6gxWIfE
	AHD8TvWg6WlBgMeSfQW4RU0U0yZCJ2iwnv96dTNtAd64zHaFESP+O8jl4LDzmO3a5APYn9T4fPEjG
	Swb+A1sg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXNOB-00000000QeG-3Mrs;
	Wed, 10 Jun 2026 18:10:55 +0000
Date: Wed, 10 Jun 2026 19:10:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, sw.prabhu6@gmail.com,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, dave@stgolabs.net,
	dongjoo.seo1@samsung.com, Swarna Prabhu <s.prabhu@samsung.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
Message-ID: <aimor-73_1ij8Nbx@casper.infradead.org>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
 <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
 <ailLu70plC9WK2dB@infradead.org>
 <d80bb796-3cac-4de2-8bc2-cc799e5bbeb1@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d80bb796-3cac-4de2-8bc2-cc799e5bbeb1@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13662-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:david@kernel.org,m:hch@infradead.org,m:sw.prabhu6@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dave@stgolabs.net,m:dongjoo.seo1@samsung.com,m:s.prabhu@samsung.com,m:linux-mm@kvack.org,m:ziy@nvidia.com,m:swprabhu6@gmail.com,s:lists@lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,kernel.dk,vger.kernel.org,stgolabs.net,samsung.com,kvack.org,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,casper.infradead.org:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6020B66C313

On Wed, Jun 10, 2026 at 03:18:52PM +0200, David Hildenbrand (Arm) wrote:
> On 6/10/26 13:34, Christoph Hellwig wrote:
> > On Wed, Jun 10, 2026 at 11:54:01AM +0200, David Hildenbrand (Arm) wrote:
> >> There are some long-term plans on providing an interface that would abstract how
> >> you refcount something you GUP'ed. (because, some pages we GUP in the future
> >> might not even have a dedicated refcount, all still fairly unclear). But it's
> >> all not really finalized I think.
> >>
> >> For now, we could expose a folio+page/offset+nr_pages interface, where we,
> >> long-term, would not be able to return non-folio pages (e.g., vm_insert_page())
> >> and would instead, in the future, fail the request if we stumble over a
> >> non-folio thing in the page tables. That sounds reasonable for now.
> > 
> > I think whatever we're going to use for direct I/O has to also support
> > non-folio pages, especially PCI P2P memory.  So coming up with an
> > interface that support this ASAP would be helpful.
> 
> Yes.
> 
> I think we can keep returning pages as long a the unpin interface knows the
> right thing to do to unpin them.

This would be the get_user_phyrs() interface I've talked about before.

https://lore.kernel.org/all/ZbVO2RKhw-dLUMvf@casper.infradead.org/
and the long thread:
https://lore.kernel.org/all/YdyKWeU0HTv8m7wD@casper.infradead.org/

> Would there be users for a new interface that returns page ranges as described
> above, that would want to still unpin stuff partially? E.g., we give them a page
> range that belongs to the same folio with only a single pin/reference, but they
> would want to logically split that range and unpin pages individually?

Urgh, no, we shouldn't do that.  ranges should be pinned / unpinned
as a whole.  I'm sympathetic to "for this special operation we need to
create a new range from this existing range and adjust the refcount(s)
appropriately so each of the two rangees can be put separately", but
I'm not sympathetic to "we need to allow each page to be individually
refcounted".

