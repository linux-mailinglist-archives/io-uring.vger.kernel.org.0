Return-Path: <io-uring+bounces-4994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F7E9D6555
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9080161852
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156F5156F3A;
	Fri, 22 Nov 2024 21:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YgviElC2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TFTa+bwB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YgviElC2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TFTa+bwB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0572189B8A
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310167; cv=none; b=jjsAuqo4lH/Mo7HoGZZdQ+MnR0kMtjWcDMKbG/i+Yt/HDRn2RazsLEJKc4vH9IDSUMJw2fyDM6McTzs8Nrky4kizbhpzmgc4/ch0chSDXLji5dnNXe+6rqrsRy/YTI+bqW8E64b6wNU9qdwiff1wvThNfSynwtuCpTSQ08Yqxq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310167; c=relaxed/simple;
	bh=5WoqjSwwUE9bU5sKV+4i9+RapnGP/RtMwaSLAWVCV2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anO3pVQxz+WdtKwg61SENQWUdoBgiukY4adV6HCvu3vUsVNA8x1qnNMkL4cjORxTvl4pYni0Z8oxHDoG1dtvEy8ckn9XXVnyqgCC1RB4Lc/YRR79Jp/Sisl+mhp4/xZ5515EFZuqL3ggF9l2LSqukXyTx4Zb416NXDPiSclm12g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YgviElC2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TFTa+bwB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YgviElC2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TFTa+bwB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 094D41F79E;
	Fri, 22 Nov 2024 21:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVyY8rJDbIZ67Po5mOsXYAGukUb3YTyduqCEDWLu3co=;
	b=YgviElC2GCDI8+nusDgI/Q1g0eQDq0WTEtQWsP4+aR4emBa6nIQLq3bs3oc41tBkBEYk9K
	9AvhaLeVh/qE3i6ZFcd/FqpsDGoclfT3eE9LkuL8bIR5IC0LNhlIRa6tXoQSL/Z1RxBT16
	6Qq+J9ZT+AGIyqUmBQgno6oA6JO+Tmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVyY8rJDbIZ67Po5mOsXYAGukUb3YTyduqCEDWLu3co=;
	b=TFTa+bwBXJ5gjc/DGIdSNTfhS5pbnEfA/Wov0zW5sOkKMcFKqpyfYsj7gcXAd0jUXSZcfK
	gUsZWbpqomwMGtDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVyY8rJDbIZ67Po5mOsXYAGukUb3YTyduqCEDWLu3co=;
	b=YgviElC2GCDI8+nusDgI/Q1g0eQDq0WTEtQWsP4+aR4emBa6nIQLq3bs3oc41tBkBEYk9K
	9AvhaLeVh/qE3i6ZFcd/FqpsDGoclfT3eE9LkuL8bIR5IC0LNhlIRa6tXoQSL/Z1RxBT16
	6Qq+J9ZT+AGIyqUmBQgno6oA6JO+Tmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVyY8rJDbIZ67Po5mOsXYAGukUb3YTyduqCEDWLu3co=;
	b=TFTa+bwBXJ5gjc/DGIdSNTfhS5pbnEfA/Wov0zW5sOkKMcFKqpyfYsj7gcXAd0jUXSZcfK
	gUsZWbpqomwMGtDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA6AA13998;
	Fri, 22 Nov 2024 21:16:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h1xJJZD0QGfMXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:16:00 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 5/9] io_uring/uring_cmd: Allocate async data through generic helper
Date: Fri, 22 Nov 2024 16:15:37 -0500
Message-ID: <20241122211541.2135280-6-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241122211541.2135280-1-krisman@suse.de>
References: <20241122211541.2135280-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -1.30
X-Spam-Flag: NO

This abstracts away the cache details and simplify the code.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.h  |  1 +
 io_uring/uring_cmd.c | 20 ++------------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ddf3f05c3622..91414a4da1b2 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -8,6 +8,7 @@
 #include <linux/poll.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
+#include "alloc_cache.h"
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e9d99d3ecc34..8c1c732b3f15 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -16,22 +16,6 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
-static struct uring_cache *io_uring_async_get(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct uring_cache *cache;
-
-	cache = io_alloc_cache_get(&ctx->uring_cache);
-	if (cache) {
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = cache;
-		return cache;
-	}
-	if (!io_alloc_async_data(req))
-		return req->async_data;
-	return NULL;
-}
-
 static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -181,8 +165,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct uring_cache *cache;
 
-	cache = io_uring_async_get(req);
-	if (unlikely(!cache))
+	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req, NULL);
+	if (!cache)
 		return -ENOMEM;
 
 	if (!(req->flags & REQ_F_FORCE_ASYNC)) {
-- 
2.47.0


