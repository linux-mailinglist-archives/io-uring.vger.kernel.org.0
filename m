Return-Path: <io-uring+bounces-13552-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEwNI5KCGGp8kggAu9opvQ
	(envelope-from <io-uring+bounces-13552-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 19:59:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7515F5FD6
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 19:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B1153023DA9
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 17:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA81363C7C;
	Thu, 28 May 2026 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FYkUfT7g"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCA43FFAAA;
	Thu, 28 May 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779991154; cv=none; b=f4AcKau5ph5PR8Ap7/b0fnB5en2Q8mpA+fyRyu5dkVHsJuGuAsX/x8FvXJTrtrSSirrR/MN/29pS6S9wsn9FXpSGV4BhgJNSlmc9TcxdgK3RM4mB+qTzjH3YBn145QHt/UI2pR8CT+4pUCw3dtgNCpL1+wvm5J1WplXJZU4CuEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779991154; c=relaxed/simple;
	bh=B5+iiubFY2WySZ4DjiX1w5VwrGkgnT9zl5grrfROc+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQWboiltZiaMPY1ey8yqu9u0YNmzx6EMpJjafUnVtMe3v0TlR2ICYQQnh6YOcOjX9LgRkCpOZnrhND5TX3TfWNwyfb1JXyTNPX5FqGpBluNsQjReQcloncNns8/gEf4TmQ+tLsm1BcdSphKzkO4mEW5v+al/nhtLTMEDtwfUg4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FYkUfT7g; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=EGVmzaNcu/49E2fMbgScKw5kBNsfavLbAhlmVlLSNus=; b=FYkUfT7g4UMygsRy00AFaFX47s
	kjEQozDyEE80XVE63jF3gPUMIHTC/IJYHb9NkibfKWXnGXdHHCyDOGrJXjaOtTHtFWY6pR3foOPdn
	3PP/4eEbtWxBZqtRXs8JRP5jzg6YnLf50adQ11TjweGHEbwbAX1NogA6502huvXX/OtuCKOFWEyjr
	i3gdFQtlXf4WkiYlKaae0B+J8CL0lqITx3OQ6LJepVLv5sJjEhV8VkqWyweHUslKDAtNMhkAkyOEe
	XmNphA6bjaJPlXirk5sCqqWhFyqWXVpjl5iDRtAbuhvGaR5RN+L96WdJuwJeBRwZc4EWqIX/+PIRf
	U5AcLsiw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSf0d-00000004cld-2uYw;
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
Subject: [PATCH v2 2/2] block: Include bvec.h kernel-doc in the htmldocs
Date: Thu, 28 May 2026 18:59:04 +0100
Message-ID: <20260528175905.1102280-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
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
	TAGGED_FROM(0.00)[bounces-13552-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 1D7515F5FD6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

People have gone to the trouble of writing this kernel-doc; the
least we can do is publish it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/core-api/kernel-api.rst | 1 +
 include/linux/bvec.h                  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index e8211c4ca662..4c4a57c1c094 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -307,6 +307,7 @@ Accounting Framework
 Block Devices
 =============
 
+.. kernel-doc:: include/linux/bvec.h
 .. kernel-doc:: include/linux/bio.h
 .. kernel-doc:: block/blk-core.c
    :export:
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 27ac3fcc6d9e..09d6bb76919e 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -262,6 +262,7 @@ static inline void *bvec_kmap_local(struct bio_vec *bvec)
 
 /**
  * memcpy_from_bvec - copy data from a bvec
+ * @to: Kernel virtual address to copy to.
  * @bvec: bvec to copy from
  *
  * Must be called on single-page bvecs only.
@@ -274,6 +275,7 @@ static inline void memcpy_from_bvec(char *to, struct bio_vec *bvec)
 /**
  * memcpy_to_bvec - copy data to a bvec
  * @bvec: bvec to copy to
+ * @from: Kernel virtual address to copy from.
  *
  * Must be called on single-page bvecs only.
  */
-- 
2.47.3


