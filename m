Return-Path: <io-uring+bounces-4993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 884A29D6553
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0587D161457
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B4417C215;
	Fri, 22 Nov 2024 21:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="URZrMc3E";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aFEJS3ZD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="URZrMc3E";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aFEJS3ZD"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF0317DFFC
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310166; cv=none; b=El+/DMbAHFMgucWGR1RE6MGMm5Zr20NgKmexBJBhqfDdY9CTRjSHFJL3RolVXTMBQGwRRoaGk4rl5ftSIJapuEhVxTm787F1z+ETMCQqa4Gt9C6h1xADscm36Ybwm+lJ3BQeKKNbD3ha4l3V8ZXvyTCfrzWQ8h7BxNsH/+xSSi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310166; c=relaxed/simple;
	bh=kFBkDnSnEZZ1VfI5FksgAvdRIAP5QPxLBN+/Yu2XlRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTE05z6GPa+fZ8HO+srtbdTojTSxa5gNEBaRAAO6H7UR0q0V0xJ/g5oNrjEasJs736yGdHk1TasfxbKtM/yfNSZMurI7lZ+M3XtN/V9ER1Xcyj9zWpbh6FcJi3lSDl/CpgVIQWkFoswcH/Qo6ZC9X/EnptJ8ShUtbusTZPuO3qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=URZrMc3E; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aFEJS3ZD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=URZrMc3E; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aFEJS3ZD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 55B8A1F79C;
	Fri, 22 Nov 2024 21:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zf3j+7x8OWqZs5Flqu4Qd02MEQlkGNkjLaHkJZbmiPk=;
	b=URZrMc3E2Lkz/omXk+lJpHt32vjgvdhwPWQ4k43/QNAWx6l7zPuw9ns7gWKdVXOaWtVoIr
	+07ju8eFiT4+oIWh6Butnv2kiu1w/32bH8D7mZ6Q0D081Vyg7Svhh5QEkqZcuVQU3Fb6FJ
	cJWdCJtKamPvRqzEfuG3rYtRNzlrbOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310157;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zf3j+7x8OWqZs5Flqu4Qd02MEQlkGNkjLaHkJZbmiPk=;
	b=aFEJS3ZDHbS4EV4Dn4vfL3z+LW88h8OFl/z4KcyQa3BniAzrWGCEfe6U+NmGe1Nry9JGPB
	NOjMAegprulVhhBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=URZrMc3E;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aFEJS3ZD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zf3j+7x8OWqZs5Flqu4Qd02MEQlkGNkjLaHkJZbmiPk=;
	b=URZrMc3E2Lkz/omXk+lJpHt32vjgvdhwPWQ4k43/QNAWx6l7zPuw9ns7gWKdVXOaWtVoIr
	+07ju8eFiT4+oIWh6Butnv2kiu1w/32bH8D7mZ6Q0D081Vyg7Svhh5QEkqZcuVQU3Fb6FJ
	cJWdCJtKamPvRqzEfuG3rYtRNzlrbOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310157;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zf3j+7x8OWqZs5Flqu4Qd02MEQlkGNkjLaHkJZbmiPk=;
	b=aFEJS3ZDHbS4EV4Dn4vfL3z+LW88h8OFl/z4KcyQa3BniAzrWGCEfe6U+NmGe1Nry9JGPB
	NOjMAegprulVhhBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D0BA13998;
	Fri, 22 Nov 2024 21:15:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qfEmN4z0QGfFXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:15:56 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 3/9] io_uring/futex: Allocate ifd with generic alloc_cache helper
Date: Fri, 22 Nov 2024 16:15:35 -0500
Message-ID: <20241122211541.2135280-4-krisman@suse.de>
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
X-Rspamd-Queue-Id: 55B8A1F79C
X-Spam-Level: 
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51
X-Spam-Flag: NO

Instead of open-coding the allocation, use the generic alloc_cache
helper.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/futex.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1..30139cc150f2 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -251,17 +251,6 @@ static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 	io_req_task_work_add(req);
 }
 
-static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
-{
-	struct io_futex_data *ifd;
-
-	ifd = io_alloc_cache_get(&ctx->futex_cache);
-	if (ifd)
-		return ifd;
-
-	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
-}
-
 int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
@@ -331,7 +320,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	io_ring_submit_lock(ctx, issue_flags);
-	ifd = io_alloc_ifd(ctx);
+	ifd = io_cache_alloc(&ctx->futex_cache, GFP_NOWAIT, NULL);
 	if (!ifd) {
 		ret = -ENOMEM;
 		goto done_unlock;
-- 
2.47.0


