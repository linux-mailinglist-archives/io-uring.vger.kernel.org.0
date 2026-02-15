Return-Path: <io-uring+bounces-12212-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iEkfI9w6kmnUsAEAu9opvQ
	(envelope-from <io-uring+bounces-12212-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:30:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 030EF13FC50
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 259D3300AC03
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D8829DB6C;
	Sun, 15 Feb 2026 21:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0G894GQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772FC2690C0
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771191001; cv=none; b=hziArc1aleedMMdGbnmHlFwK70sDqZmIINmfsq1LmDlJXxu7nrYFhQEAqncA1mJzd826nGyNC0HfrrKddhyivVxkqZmUfhESJGR7IEtlVGav7Fn487PbavhjhKxJtLz+VY5m/F1+NMsA/6R4vCzjX12nQgrFbdL6Bp43FxzrjBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771191001; c=relaxed/simple;
	bh=Gck0A+phSNurtc/OQ3pxvQVhSdXt5D9V/ywktWRk6fM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ec7i5EYNZhBWah2tponTF1eGMrufWMYsULUwBl8S9rTWVZ9tXvte31ZC9a2xkDx8KGiChwSNNEq9zo4XMZdzbK5LQdzoZlaoRyMPq0i2Lef9L0Ht+1JrDNYn+LXR1GS4A6hYgiS/ffMiYVHGzV3GceuO/NNu3oMIMljmBTmrKwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0G894GQ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48375f1defeso18859565e9.0
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771190998; x=1771795798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IfjZbgjWMg97sVKbottTbZucPpj7FDXvTOk+Eh9jmXU=;
        b=A0G894GQ0vDwpOTOVs0H8n1uq60N8BEqey9ygamKq7h3OUHfL5RaSFyP7/0Ija3Z9q
         IyRUhgiTc7Nxzfy8RDnSYyFmbIASSd3f8bg/NYr3GglOcYdMogAjuRP4GPfKc4HtuRS8
         0Ehj8y9k097u0p/3wYGJsCvH8OoZMUYvjvL4kd6okniBT+6OVscoN3ezi3suBwdUEc3y
         YfNL9t1L9m2IF+i9QnsojR2O/VmwxB5G7mFbXdS36lRUOp803+Pr3hxH7a2CXyg8d9MW
         hZnPOP6sV8KnlR6c0uYoiIWytnnZ4uY13gq5WQLlCsGCb50bdniDdn+ESjelGcehfLOG
         tCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771190998; x=1771795798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IfjZbgjWMg97sVKbottTbZucPpj7FDXvTOk+Eh9jmXU=;
        b=vRMWSiD2hTG9SazMJHBxhl6j5lQg4ZEhqyi7bw5FvHBFLbv7s3K7saMVuV+DfQne/E
         PJs5aZ5UUOO0v5iD6S9NO20yirGMVeQYab1HXxkNdFZ16/kXX1c/pfJdlQuC+oxf9Az7
         eiZ9b076V+axb62oCBMG0gsmg9Ojh2HBBJZ3RpjyzGrj2ote2qcCRAXx7xj1XMoBNb7R
         hCPBs1DAyGLzLogpxAILGMvLFeCJSb9wfjwqmzAx1T0rMnFGeJGzU+tESwXTzhHi2VUx
         mDL9iWPSdHD/+jAA3G1T4voz1wAnGqKK/pTw7/lp0M0wwFlaaX4WW56tlazXSUYw3xvg
         edaA==
X-Gm-Message-State: AOJu0YwFJHGPR+ysnuSUf9ZD6nvhwOvDoL1Kd1Qt7yHhnITP8hdfbtAk
	FD5LJ9j71GBbMsSzgrCD+bhBKD+AOQLO6v+o3zpXY9qKB2W1TwbxmpcV8j67Jg==
X-Gm-Gg: AZuq6aIFmuF8F2I7Pt8Lbr1J6wYRbzUgZFHqKbXSEQCNYsJ5tq7wdyMW8XTqm80CTJA
	e91DTfEStAMUCfRI1C+y+6LtdkccipWt0ErJW+JDQKw3twqkSA3zsJNxxIDWUQQQv3u/g4gljHr
	CBPCB0+aPqUlFZbcPBNITXVf/FA3ao8/12VKzNGqHys8o7bZWukk2aOLeXPLG1oiW3V+DJs6qud
	j8VxRSNLic8nuZTE/BKOKrfGqktZR3SJ8L92Mazs3d3hPX2/KaRdxtP68kPXxSW8mkBam3onWny
	hthMfSW5RSwmQykNmEdmsqLr4ndfCxETjq0awkagbtgSl9h7I5znFuc/5hkM9z2kHbf/lF4I3Bt
	1Fh5T6rUtNzsaAGbtb1CHH3PClttRK+m8eeFnnxi2ZomZOLyfe30cImaOPp+krHkfqaPe5wroXO
	95Y3hWjBysMSOQ44BNtyOsKJn8aHf6Vl7mT2bhZ8y51BVGoqJKzlca2knBKUMSxp8dlklMPSYRO
	heelYRmuOmlGANG+1PuqjG3cgNCcg==
X-Received: by 2002:a05:600c:1909:b0:47e:e712:aa88 with SMTP id 5b1f17b1804b1-48373a746e0mr151813895e9.31.1771190998392;
        Sun, 15 Feb 2026 13:29:58 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a694d3sm69268805e9.10.2026.02.15.13.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 13:29:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring: delay sqarray static branch disablement
Date: Sun, 15 Feb 2026 21:29:52 +0000
Message-ID: <8990bf99bc758c6e033e7a75ea5eb1834dd2f920.1771189395.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12212-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 030EF13FC50
X-Rspamd-Action: no action

io_key_has_sqarray static branch can be easily switched
on/off by the user. Prevent abuse and defer for a bit when it's
disabled.

Fixes: 9b296c625ac1d ("io_uring: static_key for !IORING_SETUP_NO_SQARRAY")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3a2753f6b444..1e627b7a2f3a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -119,7 +119,7 @@
 static void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
-static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
+static __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(io_key_has_sqarray, HZ);
 
 struct kmem_cache *req_cachep;
 static struct workqueue_struct *iou_wq __ro_after_init;
@@ -1978,7 +1978,7 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	unsigned mask = ctx->sq_entries - 1;
 	unsigned head = ctx->cached_sq_head++ & mask;
 
-	if (static_branch_unlikely(&io_key_has_sqarray) &&
+	if (static_branch_unlikely(&io_key_has_sqarray.key) &&
 	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
 		head = READ_ONCE(ctx->sq_array[head]);
 		if (unlikely(head >= ctx->sq_entries)) {
@@ -2173,7 +2173,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_rings_free(ctx);
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_dec(&io_key_has_sqarray);
+		static_branch_slow_dec_deferred(&io_key_has_sqarray);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -2951,7 +2951,7 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	ctx->clock_offset = 0;
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_inc(&io_key_has_sqarray);
+		static_branch_deferred_inc(&io_key_has_sqarray);
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL))
-- 
2.52.0


