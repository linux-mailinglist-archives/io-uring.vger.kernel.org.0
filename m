Return-Path: <io-uring+bounces-12618-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WF2xNJ84sGlbhQIAu9opvQ
	(envelope-from <io-uring+bounces-12618-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:28:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA9E253830
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2E033498EB0
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 14:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914793009CC;
	Tue, 10 Mar 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ui5Fef64"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E7C2F49F1
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154530; cv=none; b=WC3OAeEufmfvtgSV36k0uyy2OIFRndd0rcZ3P+iaGEisQyWh+om63RizuDVBccBIIHu5V9okalb8mfUjDMgjZRT+aMO+pBVFqm+QV45TG/6XVM6hLSueGsLxyJv8dgZ+euo8m+HS9+1vAq1Y2wFuHSdZgLvDC65HK7WXilHCG18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154530; c=relaxed/simple;
	bh=YIo57N2vcHVypstNB2cXBU3r9AT7FE4ZbnUQ6vqutMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwIdBGFJpea01RmIQd082dEiY7XCIgPQOvN/+X3rzzCBcj1OsRw6h2fwH81aKR34qXeMSNCNjzAmmCqqLF2mGrDnP9XuI71cfcJ+IBoGy3be1b99uH8KiBPbn9baGtfJuwGXSVXmahspGO1iBuhOMEG6Xjd7lQFUgQiVAU7+8Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ui5Fef64; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4648447e29bso4829490b6e.0
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773154528; x=1773759328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UT/m7GaBXVbUKRMg37ABmfjMs9kKM0kDkv8WvMSyIRg=;
        b=Ui5Fef64Y7cc1vXZ2PqSKmIZVxSdRCWkS0Lg6mwe1iUfsq9KANbRNCnZ/FMQJMxATj
         QHFymeG9Tl/r1HOMgPXJreePTXYCip9Stf7oS0jZev52t1jnsEHab6Wq6n3yLTdHpSj8
         633geDe8muKV9jVjl6m0Cql/On6hwZW3qRdQArM/jkkWUzUcccHCHAnA+E4shE75h+dS
         P78+eRjU0w5pQWLWUb8FR7q3XFs7xsbOM5GVVVIWofXYPDJZXxIxhfdAu2HHZh2Hx6PQ
         ypVIG5HXJPclqZCLo1PTNMH/IXXLkPEde8Nqppi+xd69t9jvfudtTa04goMf2xgYSryh
         kZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773154528; x=1773759328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UT/m7GaBXVbUKRMg37ABmfjMs9kKM0kDkv8WvMSyIRg=;
        b=unGki3LisiMi4bbVeCPaWVIDZYQaCLj/wrwcx1ZgxzT5Yr3loOkzGxqJ/YzodFIErX
         yB3OgHCMLKvNwM+RY9r80B5on7Rb7RM2CSAeqiSvOrReaTgy6Ha0sZ8N51fnw+lyKB01
         6ZXo2VWnUfc/Q7IWmxXH/FPK31ZDHmCilk0/sKT2Q3mhFJQK7I9Ho1ooKVWO5Qsbm77g
         N1aQhZvkUOPMc/FQiQ0GYHlFZMv89J9ZG+76y25tcHUjBDto/XWVVpOiGeWHHHll1Ir0
         ocHUCcNd7J+fDhtuZIwLNWLY8sxSZaN7aMbt8xbh15wPp8vkDVbfdA1IwgNue0OLqZfp
         wWWA==
X-Gm-Message-State: AOJu0YxnfC5vff7SpQF7qkmqCgFUqgNJHnAU2W6UY9HpRT/xSg7yVNe1
	59hk3yk5KwL8hWDvSwL4ThK8WUuryzG5awaHW1YW5QcvodDxuKtcGLSKEqthw30VkBODMb3oLMO
	DHmYV3xc=
X-Gm-Gg: ATEYQzyOy6QW9jsPSr4ERd7Dpwk7AcKEGxmdenyZj5myVNwshz0EYFFJDQtZmwVXZFs
	MxdvwRi+4OClL3vIZTajQusJqrCr5DP0wMUhBWZzqQW/+U2wgjAvI+O5CIF+LlMKoQoh+nsMa91
	e7iShyL7BWHf6rLEyPFrzPvG7v5zVrYATocd0mI9/rPPZvRCpMUwveAEzC6iT6Gin7lCSM89aoX
	oKfnkaffGbEP0Jt3zrSdfAS4bwSRmqj3VYKAFHLm55i0utbovtCcKWWVUeW0obvudW9aYK9W/MG
	giz9ZYnw86F5vyFQ3PKplypQiUNqoZPFt/w40G2G2+LRCoNrPwlTS2g36L5NgJkIB7YtqJJpIfD
	4xkioTCeghldBwnVZ/C6p3dLaVXA8OSwg03WZcqg2rfP13dGQVdYlHRSUD78qg3kXfs1Ka8xrrB
	l/9yv2ZszXogoPzIeUWnKWNU/atq2GlCzs8T/JkqSugKkyTHtpp3XM+h+8n+OZx18DaTqo
X-Received: by 2002:a05:6808:c145:b0:467:b0f:997 with SMTP id 5614622812f47-4670b0f13a5mr4283225b6e.34.1773154527823;
        Tue, 10 Mar 2026 07:55:27 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-466f429c7fcsm5786865b6e.9.2026.03.10.07.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 07:55:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	naup96721@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring/eventfd: use ctx->rings_rcu for flags checking
Date: Tue, 10 Mar 2026 08:45:49 -0600
Message-ID: <20260310145521.68268-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310145521.68268-1-axboe@kernel.dk>
References: <20260310145521.68268-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7FA9E253830
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12618-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

Similarly to what commit e78f7b70e837 did for local task work additions,
use ->rings_rcu under RCU rather than dereference ->rings directly. See
that commit for more details.

Cc: stable@vger.kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 78f8ab7db104..ab789e1ebe91 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -76,11 +76,15 @@ void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event)
 {
 	bool skip = false;
 	struct io_ev_fd *ev_fd;
-
-	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return;
+	struct io_rings *rings;
 
 	guard(rcu)();
+
+	rings = rcu_dereference(ctx->rings_rcu);
+	if (!rings)
+		return;
+	if (READ_ONCE(rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return;
 	ev_fd = rcu_dereference(ctx->io_ev_fd);
 	/*
 	 * Check again if ev_fd exists in case an io_eventfd_unregister call
-- 
2.53.0


