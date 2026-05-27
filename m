Return-Path: <io-uring+bounces-13510-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GIH+DdSNFmqCnQcAu9opvQ
	(envelope-from <io-uring+bounces-13510-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 08:23:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A40B5DFC5D
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 08:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6F5E3009F8B
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 06:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9F730E85D;
	Wed, 27 May 2026 06:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RCtA/4X1"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164881A5B9E;
	Wed, 27 May 2026 06:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779862955; cv=none; b=PykIXNpYgzRmfJZTgoWkADKEWLiEX+UfTntueS0Nsqyzsfs1UoPRsDuDQ2y54DkrlLhHpMCur8+ir5NVj8TVzw8/KTwt2IW2JgahRWIyBNXlSeOYdpqzmTSfVtzWs99gvXaP0tHgbGALw2VUTjcQlt091cnQ/1AHUJnfTE8cybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779862955; c=relaxed/simple;
	bh=D6qiNKtozgv1ru63gwq6prIRdKT/tXSlog/V7cAwdbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHCTMdVkFaBrGACWzg6YXVTgeiCZhZUykCD/9aSRObEgVDrktcGNrmz3zAAXfoSiZgfH0SNn/Iob/vqCRQxWeoXRmfUS6GPW3RjxxNQnApyia87emQXVV95uWgt76s3zTrvO5FIGb7ADhSBVTW7ZNU8Md8giYXmTEFtpwQYDNWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RCtA/4X1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sIgn2pTb2lMuNpwxC9YljPb7qAqonpElKjgih7wuKeA=; b=RCtA/4X1G26+BLIr7I/PYFUdTY
	8uwJSaRlcCbSxn5XSr8N3Lm5+OkQnR/gXCK2Y3Ci/F0aRBZJmf+XF/eobnpq3pSiRdqITeARtvojH
	n1WpNWosatSSsRkpQ0+gSgqLNTKZIyRQ0jgsvvLCiQABS8wGJRm+BpILb4o2JYoPE07e3rHohQAMY
	HJoHTan4Tyn8ET+0TQe9K7K+V9XbTPCaCrprD0U6vrgPJCpHsnk0WB69CWV+AuF6YzlC6/B5ib7v/
	EfMuLlBdUbzrvw3rFuAm7EVsmJsqVDQfg6Te1WX7VlhRLIM+PPs4vqi4NeCGgjrl1UpSRMYGm2K8F
	hquiZvTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7ev-00000003OVG-3fl4;
	Wed, 27 May 2026 06:22:29 +0000
Date: Tue, 26 May 2026 23:22:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahaNpbG15d6StT9d@infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
 <ahROtyLcr567wM8l@casper.infradead.org>
 <ahVBCtsodsM2FHis@infradead.org>
 <ahXcsrxUFfzoVCOr@casper.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahXcsrxUFfzoVCOr@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13510-lists,io-uring=lfdr.de];
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
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 8A40B5DFC5D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, May 26, 2026 at 06:47:30PM +0100, Matthew Wilcox wrote:
> How about:
> 
> /**
>  * bvec_folio - Return the first folio referenced by this bvec
>  * @bv: bvec to access
>  *
>  * bvecs can contain non-folio memory, so this should only be called by
>  * the creator of the bvec; drivers have no business looking at the owner
>  * of the memory.  It may not even be the right interface for the caller
>  * to use as bvecs can span multiple folios.  You may be better off using
>  * something like bio_for_each_folio_all() which iterates over all folios.
>  */

Sounds good, although I'd captialize the first word in the sentence.
(Not that anyone should follow my spelling advice in general)


