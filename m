Return-Path: <io-uring+bounces-5361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB129EA302
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5DD16680B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B50224899;
	Mon,  9 Dec 2024 23:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O272HWtu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9l5EfZRl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O272HWtu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9l5EfZRl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96C82248AF
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787817; cv=none; b=Bm/+T8OSD3otW5UxoLVn+k44jtNHg3oS++/6JbZ7f5PzhHx6gebvrgN+j3hJNUe9RbsPzfDoA7DQIsRMppOR0IMAVNscQ+DrKEkanRuTaXBeobZddhyQjHHkaarfQLHRSJvceIZLxB1p2b8Aym1SrK7rdE1A0ZSxWkzvtyFCWL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787817; c=relaxed/simple;
	bh=+gJ3v1ULc7lVJuiS1T1ZgjOtqR4/tpvamuoXJw59FiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbpeLOVF/ouIHM3abJuwEZ5m5af4F8CGBG1yobS1TOxA47FiU3qmGBd4vpV7WIMr2wumqBKHWaAq/iUbRV6LRiK0BSoaHU6Jp+6T8dn/l7KflDHBPG03iSFit646Z7HwlTw/OZz78uyIokSAyae8tkLU2pWT60fosSAaEcJ2Aag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O272HWtu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9l5EfZRl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O272HWtu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9l5EfZRl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 105011F451;
	Mon,  9 Dec 2024 23:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9CA77SOuPnWZ3xnV7R7T3AEVu338QN1dDtteijQVt4=;
	b=O272HWtuGRilkDveaQIB+o65z8XeRzGMBvg7d7BApUhfWk37BSUJm/DlPQaCKfC3U0kkCh
	dGKMuEsGeAksBXzqurV89r2Jfcml8cl9WnooaW49QpPudixqy6pjY2227lfbi0NPodmX2S
	sFELe8VD/W+5nzHAZlzSieQAY4YqT/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9CA77SOuPnWZ3xnV7R7T3AEVu338QN1dDtteijQVt4=;
	b=9l5EfZRlSwhccLPyziiTG1SYYg9XPoVx5n9GAKsXdT0V+Y3vlHbIEox3o9SXrUFTZsxeX6
	OnRUhq5d3wUMkLAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O272HWtu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9l5EfZRl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9CA77SOuPnWZ3xnV7R7T3AEVu338QN1dDtteijQVt4=;
	b=O272HWtuGRilkDveaQIB+o65z8XeRzGMBvg7d7BApUhfWk37BSUJm/DlPQaCKfC3U0kkCh
	dGKMuEsGeAksBXzqurV89r2Jfcml8cl9WnooaW49QpPudixqy6pjY2227lfbi0NPodmX2S
	sFELe8VD/W+5nzHAZlzSieQAY4YqT/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9CA77SOuPnWZ3xnV7R7T3AEVu338QN1dDtteijQVt4=;
	b=9l5EfZRlSwhccLPyziiTG1SYYg9XPoVx5n9GAKsXdT0V+Y3vlHbIEox3o9SXrUFTZsxeX6
	OnRUhq5d3wUMkLAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2C2B138A5;
	Mon,  9 Dec 2024 23:43:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lW1sH6WAV2fwHAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:33 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 2/9] io_uring: Expose failed request helper in internal header
Date: Mon,  9 Dec 2024 18:43:04 -0500
Message-ID: <20241209234316.4132786-3-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 105011F451
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
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51
X-Spam-Flag: NO

In preparation to calling it from the clone command, expose this helper
in io_uring.h.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 6 ------
 io_uring/io_uring.h | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 57d8947ae69e..a19f72755eaa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -224,12 +224,6 @@ bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 	return matched;
 }
 
-static inline void req_fail_link_node(struct io_kiocb *req, int res)
-{
-	req_set_fail(req);
-	io_req_set_res(req, res, 0);
-}
-
 static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 12abee607e4a..4dd051d29cb0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -222,6 +222,12 @@ static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
 	req->cqe.flags = cflags;
 }
 
+static inline void req_fail_link_node(struct io_kiocb *req, int res)
+{
+	req_set_fail(req);
+	io_req_set_res(req, res, 0);
+}
+
 static inline bool req_has_async_data(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_ASYNC_DATA;
-- 
2.47.0


