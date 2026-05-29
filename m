Return-Path: <io-uring+bounces-13555-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MD4pE8kkGWotrAgAu9opvQ
	(envelope-from <io-uring+bounces-13555-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 07:31:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB9B5FD5D8
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 07:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DB08E300DA7C
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 05:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415B338D69D;
	Fri, 29 May 2026 05:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CwJluKGb"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A3430BF6B;
	Fri, 29 May 2026 05:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780032652; cv=none; b=GKeATk+F924hN5b4vhYhae1DLG9UXWgUdJoY547SAhAkFWneJcl4noyukd/yVSy5VJ7T6b2yhQIOaaXBg4pWnqFw+dm0Fg8RM2cLx4W/n+HgXc8+zBNMHdpPYumMzFFuzKPA4AdcyXKL9D2eTaGIdjia9vLb05/HtnrfpWW55cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780032652; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Db4XRzRMDky/sMAHdvAzQFdPAw0d2RENYH1peb0FOm1IfiwWsGwCcXXm4Da+nmvIbbXG7KVfQs1XqId4Aad/j1CwOxehlmALwBFdYb2F9QIU/ed8xHZ44aIPEk3H05VngDQaPdeI2lAicI9VZd8B4MDIcbcAme3HWDL2dGRef2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CwJluKGb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CwJluKGbk0pgZBB9cVqRkZyffJ
	u5FzXI2H5qsdGc+NevbzqTnCBvNFKHYw5gu/QciXhPv2YY+RIez4KuZFNktodgQKKUwibIqeYDLUM
	eCbeLkeWsrvR/KiR58CLFISZKpN27opNrGMO+N2oPC68QHwLH9Ze87aOh2TCUbXS+Sc4i9Q0vwIgD
	UAsEu9p9FT/6gDTMAwl2SW0waTgKi6SeYqhrYjgXaCrqE33tAH5KrSEdViGvCOioFElBdX1k2tmvI
	gnZQhGcC8GY8Co+4ob9SBBbyS2ajE/y9OsQ8zW/GL6EI9UgWxR+dxDuCTxRdHWKzrH6D0gx7zeTYk
	fpqjHPFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSpnx-00000006lTX-1pdG;
	Fri, 29 May 2026 05:30:45 +0000
Date: Thu, 28 May 2026 22:30:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] block: Add bvec_folio()
Message-ID: <ahkkhRsqSZPQXOAu@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
 <20260528175905.1102280-2-willy@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528175905.1102280-2-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13555-lists,io-uring=lfdr.de];
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
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lst.de:email]
X-Rspamd-Queue-Id: BCB9B5FD5D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


