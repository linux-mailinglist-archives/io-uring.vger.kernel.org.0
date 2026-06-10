Return-Path: <io-uring+bounces-13656-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 8vdVNyUBKWriOgMAu9opvQ
	(envelope-from <io-uring+bounces-13656-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 08:16:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 730CF66622C
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 08:16:05 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=O53ANJ7b;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13656-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13656-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=infradead.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E02D53006460
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 06:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C476E30ACF1;
	Wed, 10 Jun 2026 06:16:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48FA285060;
	Wed, 10 Jun 2026 06:16:01 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781072163; cv=none; b=bPFOADkc42cTDmoW8FY7iI5W13Yo81ggkIvHT/jRZ8Og3y96P8qMc4vupEf9X9pbKdBTKUrEoIsbI3rivfwuYp+B2ECzHNUA8aCkFnGPZDnzEa+FhWcszQie0/3OJaF+VU3yAW0kkFRf11WMSARP7npSYPXTfVsoUM0EFZE8vBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781072163; c=relaxed/simple;
	bh=md4mTGUy01HWnskT2hdyl/Jz/zUMfy/Ylb2WJ+SzRcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mD5YzrAP33cgiaLYykxuRh8PDbC15aZV9WISdE0sNT3f/fkiL0WmkZuNtLYe1wc1462xgkQeBddHP65TP8JHBlGahJzY8DW/h3SMO/DnTIQfuj7cmLWBFcSoCumq/JaiQSJyDtVaGGmtX2Cbja3I5ot0XI0y0U76rdF59fBQ+9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O53ANJ7b; arc=none smtp.client-ip=198.137.202.133
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZYcfTOHydXOJAhBLYAGRX1re7dw270KkkfHrimmIDQg=; b=O53ANJ7bx7/yhJm6AXMBGgzu5q
	cJEke3nRIKODG09KcFF6CgtA2xV1kx6pQU5xEpFiMlJc0JcVexQ6tYJik2E70G9YDp20xTIjUpR+b
	2l1QqYxqWNPLtoU35jQHxgakzTREIXQrsPfdEpjEOvBOC2Tzel4WbdGR8t4cGMoUc87OtggRaoyJw
	q+5pZG+zOKPN5NbFxLQilXFdDFscQ8bPLJoTgx3Y9tDJRPFy/FbUc+WPB0ZF5CrjON0ADb2XPYGvG
	p58ESrYWhKLf+vHcZq+cwqC4trQXl8tbBy4rVoUqlAAjRSfztG90wQWUIanSbDVzPzt8E2x+3bU5h
	dharo9dA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXCEK-00000006rdy-1vdO;
	Wed, 10 Jun 2026 06:16:00 +0000
Date: Tue, 9 Jun 2026 23:16:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sw.prabhu6@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, dave@stgolabs.net,
	dongjoo.seo1@samsung.com, Swarna Prabhu <s.prabhu@samsung.com>
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
Message-ID: <aikBIESiJftxBdfL@infradead.org>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13656-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org,stgolabs.net,samsung.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:david@kernel.org,m:sw.prabhu6@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dave@stgolabs.net,m:dongjoo.seo1@samsung.com,m:s.prabhu@samsung.com,m:swprabhu6@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,infradead.org:dkim,infradead.org:mid,infradead.org:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 730CF66622C

On Tue, Jun 09, 2026 at 08:36:43PM +0200, David Hildenbrand (Arm) wrote:
> I really don't like arbitrary GUP users to starting to special case hugetlb
> folios, and making assumptions of how other pages they pinned look like (IOW,
> how the page table mappings actually looked like).

Me neither, but the current interfaces are kind forcing them :P

> 
> Ideally, we'd have a pin_user_pages_fast() variant that would give you a list of
> folio ranges instead of individual pages.

Yes.  iov_iter_extract_bvecs and thus the block direct I/O fast path
would instantly benefit from that.


