Return-Path: <io-uring+bounces-13061-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMeJMVBB4WmaqgAAu9opvQ
	(envelope-from <io-uring+bounces-13061-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 22:06:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37207414753
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 22:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBFAF30312D6
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 20:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0C637C0F3;
	Thu, 16 Apr 2026 20:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="i5rdxwv9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35789374756
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 20:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776369994; cv=none; b=UEda3fhBvQuijgHma8tXML+CWsFmj2y46sQB7tDK07dUa/FW+QdpQIK1GmGfu+gVXSCgsnkbgA8Cz5O1FYmUWQcXT2bFLlaJE4sVCkyik36ANlWwnHBREF2tNaZDhlOXVjdqSFlh4Pd92tNCcJJm9/kMIc+c8qdxpjeWZehRViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776369994; c=relaxed/simple;
	bh=5ukLRDqY4e4WIRJlA5VwF/PMUZFJsZMV8oEFiTaF7H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tci/h1kCErkzosotGEWZrHEOY8MHcPtuQXg2YEeWUdoqX08GK0wXFEIqshI26DdvqGkaZOx/MqRK8U1xH3GK4pgm4yrwo7qlFz4u5Tu+z8+/d/1hoalh+P+44u26Xafg2KAzpjbGaa02psp2187BtEum44/Lit/cpfRP1OqkTGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=i5rdxwv9; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-479932ccb9bso294214b6e.3
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776369986; x=1776974786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dcD6pYwUf7E5x4vR771t+zYO6bPmP1ttmVwp5QnOAVQ=;
        b=i5rdxwv9mjnG7pMjAVPo7Ducn97lpY2mDEwRZsAwOhJzzftAn5sMvIdjk1lYbc2uTj
         8t7PTGc1QWurhkl+8+5Bqcl4OT9J9UY67hd/6zgxNt6KzsDpSUqPmiKxUWXldAMipA9i
         OLmKGyWTO5jrtTJ5Y2dSP4LwbfeCzsXe0IJ2aYoGJsaVn4SbxQYzGBrMtq+q/BPcVlKM
         7DDotcLy+iAjksr7z+S6eN+f88KKLV5aXmOQtUOfY6XGjOQtPqJQJeY41IRz5zsDlyRS
         cSHM3k/2b0ck/1NMgOzW2XGmT12Z4FgG29fem7yajVj/FpSs7HY4ojTC9JRxyt7HYbNS
         43Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776369986; x=1776974786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dcD6pYwUf7E5x4vR771t+zYO6bPmP1ttmVwp5QnOAVQ=;
        b=nFaPiAcmSgVgSIMyGbUZaCkUh+1el9x3qUU4AndoPjLAeD2cSZKmDV/ZhISAoD/MER
         e58lpc1qTN1puvAcbsFiuhy9yKJ086JKIsh8lxJlGWil2eZOgz1bieNUVXs8I5x8l3pE
         8gETt+thYVTFpRe/3BMEMEsd8vMRQnPn8vWhofWIzXHLdw7EMhyUJYiI7ak7t9CBnzRz
         I6hRD7kSikpUSP+kniU8rJ9WqtVbQB+ktj7wkPu2jj7t0oU2FZCxP3crLbUfxt0DevAA
         bkJSs+83YUi9YmecbDmrjtDv3ex4o1P5pZjaixixE8vWtfginjGVNdKep/UHD6VHOWCG
         vzyA==
X-Gm-Message-State: AOJu0YyOWPDFM+5CcpUKMZ5OisByfvdOEvTq+fxVmaxpd8wrJZFIlPmC
	6dHRvkEwh4OzoNxp9zeh4v6zCQYnGGCh+8qwSQOVa40TUaJ8eXmlfP3PcbrMwnReeqZcIn0Umya
	5Dafi
X-Gm-Gg: AeBDietOD2sYLR4DjWLJjesSELmAn6p68GbgnKloxPscBXHo/AY5HgvYT6RYcHzRjnU
	CUJA9t7YUIbF5hDfPkKiBdA1yhmgsxQ9bfcitvuK+iOcqnbWDy3f6bgQBsZdHaDZrDeHgoYmFkT
	9rPFg+A72fNBiJ7DMEQaAPXEKZg1rJSIBLPZ0ek6JIVzasRncCJrXHq9TDOCYkxUn3o5jTP3Tkm
	wUo0WHx/sebpc3pPSoUKuNSqs5chbHzC2r8Hm9QtBnztj3+kkSo1kLmomvHeb601iI4p7TH0qFQ
	AToiCz5wcVhoFHa+dFSw2SsRjAdvus+XnsaQgAVCBiL/I9a30F82XxF2b5S/+YBcTwko62TeNG4
	bdz2IfAHfgxnXbsG64TVEsL5YEnvRVLr54R6IYY/uJ/U3dK9KY9AnbWf9VeEZZYFOmWKlUFGWCz
	kr18x30epUdochd6mJGo6v8aXZv6IXHTCzaKsJl9pWx/HmjWehUk1MB0e0ZJFyt+8qO1YfiGLBM
	P+gyw==
X-Received: by 2002:a05:6808:c2d8:b0:466:fd2c:9570 with SMTP id 5614622812f47-4799a1e10f1mr235034b6e.18.1776369985793;
        Thu, 16 Apr 2026 13:06:25 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47997f9abd8sm576352b6e.15.2026.04.16.13.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 13:06:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH 1/2] io_uring/tctx: check for setup tctx->io_wq before teardown
Date: Thu, 16 Apr 2026 14:05:52 -0600
Message-ID: <20260416200622.831635-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416200622.831635-1-axboe@kernel.dk>
References: <20260416200622.831635-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13061-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 37207414753
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

As with the idling code before it, the error exit path should check for
a NULL tctx->io_wq before calling io_wq_put_and_exit().

Fixes: 7880174e1e5e ("io_uring/tctx: clean up __io_uring_add_tctx_node() error handling")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/tctx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 61533f30494f..c011a593c0ad 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -171,7 +171,8 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 	}
 	if (!current->io_uring) {
 err_free:
-		io_wq_put_and_exit(tctx->io_wq);
+		if (tctx->io_wq)
+			io_wq_put_and_exit(tctx->io_wq);
 		percpu_counter_destroy(&tctx->inflight);
 		kfree(tctx);
 	}
-- 
2.53.0


