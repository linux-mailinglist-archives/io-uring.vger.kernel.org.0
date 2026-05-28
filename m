Return-Path: <io-uring+bounces-13551-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKmSOXSCGGp8kggAu9opvQ
	(envelope-from <io-uring+bounces-13551-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 19:59:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 797955F5FC8
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 19:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 171CE30053B4
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 17:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B69B3B5847;
	Thu, 28 May 2026 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dxXupcRA"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06091363C7C;
	Thu, 28 May 2026 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779991151; cv=none; b=I1teJ6iEQstQDHL4ETQhiQS4cQ2C/goM0+AgLwc2UjvLOoNsbjXkTT5ZCV/f1B1mVexeG+/LibdO+4Dd0pfsjsEXfWGcBTJyir4vSIdEVOKcUR4Dne3RY4bs3xnpEyEhOO+whry+5vMjiqvPtnxdCFrXVr0Cof0dAZlNQxhi5aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779991151; c=relaxed/simple;
	bh=OOpSwKi6eKWgyDI/PIZKFaBjo4KtkkGNmHTHdgH45Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WSH/OZjec9jINHKDsTT/fpj58nF+dk21vwetg42+UZdZoMoh/bZYzdgms8Yfljhf8P1rqSdGy3MgMgaKnMwCjSnN66Lz8hbmqAbdJxUHNBR3kRQza0zISrwUsV+S3cPbw5zRqAfufCMS7/2ivwg9f81dwhCot5+ulabilfp3vF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dxXupcRA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=eyENAjnk2aJwSde2nbPfN2ywHeMCCavPgJObBpyXFM0=; b=dxXupcRAnbMiSHF/aR4483vLNC
	0XZRti9N6De3tJeOrzt8jgd7qjnPxPSjFzTVOhDyYHLm2cxIT7COBYR2aPF1IsYaZN7+NKXiFeihu
	Tf8W9ic5rc0a/ERE45RycMwCoQE4GPQQPZ8DCZ2wjNXWcmOYHfkw5aExNv1u1oRcD3/kDfZGAvDyl
	U4byuvX7LxJmNd0wiXQm7/0z3NsQ8PiwMdpOT+WjaykS7lHjCToiLxjZECWwMeWOgIJ/y87ITizii
	oD1htBO6tCkjhRPd8KXG8pKDE/4n6XheUE4ACEQX0CvhHL4ri5Xj6LIs0eUIFSfn+7pWIkX9ny4yt
	IOhodNNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSf0d-00000004clZ-21QA;
	Thu, 28 May 2026 17:59:07 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 0/2] Add bvec_folio and its kernel-doc
Date: Thu, 28 May 2026 18:59:02 +0100
Message-ID: <20260528175905.1102280-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13551-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 797955F5FC8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add the convenience helper bvec_folio() to avoid references to bv_page.
Convert a few of the obvious users.

v2:
 - Tweak the kernel-doc (Christoph)
 - Add the bvec kerneldoc to the documentation build

Matthew Wilcox (Oracle) (2):
  block: Add bvec_folio()
  block: Include bvec.h kernel-doc in the htmldocs

 Documentation/core-api/kernel-api.rst |  1 +
 block/bio.c                           |  6 +++---
 include/linux/bio.h                   |  2 +-
 include/linux/bvec.h                  | 17 +++++++++++++++++
 io_uring/rsrc.c                       |  2 +-
 mm/page_io.c                          |  4 ++--
 6 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.47.3


