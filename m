Return-Path: <io-uring+bounces-14016-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id dIQmHDMsV2qhGwEAu9opvQ
	(envelope-from <io-uring+bounces-14016-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:44:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA70F75B2DA
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:44:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dN3+1rXc;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14016-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-14016-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0129A300A3B1
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 06:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5761821CA03;
	Wed, 15 Jul 2026 06:39:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA7B314B66
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 06:39:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097598; cv=none; b=NqPslawNE+aGbW4SMwOMWqKmFTa9pTplA3xfLGxewtfIHzCEZLe9ioolLtQO9tRd4/5RlEEYyDG5sOlUjveT3V0VzsP2+PZsfjtfQNYlEbS95h9RkCngoBlXjv2jfwZLy4QV7V4MdZ2OM/V4T3AJP3XZqDMH1jQOqEf/oRSz/xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097598; c=relaxed/simple;
	bh=yXPStabMzbcrA1bkiGXHOPC7MT6UnBnVE4IZ45r9Utc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgVT+7kdJPRnrgs4mtIQBK38xG+KfRH0BRmTsw/fw+JBGwe0CZClJoGleZxyoMIQU/c9fXwcEGQB+0tQRhEd60QXHynDCgIeZyDy9ziQbzAgoAoV7vrS994WZrzrMFJvGdfCF7pLCIwSO+H+GB/oPaeMNgx7FEB8tUQbiOTi+tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dN3+1rXc; arc=none smtp.client-ip=198.137.202.133
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x8opDpgqRqXDwzblcZHOP75J0mlMGEGZK9SIgaxiSXk=; b=dN3+1rXc1h154vhcW2QaAA9Hki
	Tzyor+XzzNF+Ub9mX3iJSoybiE2GD2qPmanpF9S056rgalSd+wuaHSH5uoKNEbB0OCoqhrf3+8/rh
	/qGZ+gPCXkcBvpNliEa6DhDRjtdi+iejumQn1WEKgX1FbsnlrV1LUsIAEWCO3tWip3mup1BSd44hd
	jCGBgwJypT7YMWqBpzJIprE+bZOUVsuMPRCONxHHSSG0S9Y6F7N4xSEUOFqM5y2Vw++RVNMdvne91
	iOGebnu99sJrsQciLYLi3fGGpso/9dpYqHXxmIEMsLGt+8+EcTF/aYmxOaB3y0CTTCjOYqtsPLnA1
	ZFPLpBUw==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjtHf-0000000DvCZ-3qW8;
	Wed, 15 Jul 2026 06:39:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH 2/5] man: fixups for io_uring_prep_cmd_discard.3
Date: Wed, 15 Jul 2026 08:39:29 +0200
Message-ID: <20260715063947.2933606-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715063947.2933606-1-hch@lst.de>
References: <20260715063947.2933606-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.06 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14016-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:dlemoal@kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim,vger.kernel.org:from_smtp,lst.de:from_mime,lst.de:email,lst.de:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BA70F75B2DA

Mention the ioctl this is modelled after instead of the io_uring
cmd used to implement io_uring_prep_cmd_discard.3, and drop an
incorrect plural for page cache.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/io_uring_prep_cmd_discard.3 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/man/io_uring_prep_cmd_discard.3 b/man/io_uring_prep_cmd_discard.3
index 97786726f03b..349df86ff9c9 100644
--- a/man/io_uring_prep_cmd_discard.3
+++ b/man/io_uring_prep_cmd_discard.3
@@ -26,14 +26,14 @@ to start discarding
 at the specified
 .IR offset .
 
-The command is an asynchronous equivalent of
-.B BLOCK_URING_CMD_DISCARD
+The command is an asynchronous equivalent of the
+.B BLKDISCARD
 ioctl with a few differences. It allows multiple parallel discards, and it does
 not exclude concurrent writes and reads. As a result, it may lead to races for
 the data on the disk, if the application has IO inflight for the same ranges
 that the discard operates on. It's the user's responsibility to account for that.
-Furthermore, only best efforts are done to invalidate page caches. The user has
-to make sure that no other inflight requests are modifying or reading the
+Furthermore, only best efforts are done to invalidate the page cache. The user
+has to make sure that no other inflight requests are modifying or reading the
 range(s). If that is the case, it might result in stale page cache and data
 inconsistencies.
 
-- 
2.53.0


