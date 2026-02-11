Return-Path: <io-uring+bounces-12157-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YF4pBCGbjGlkrgAAu9opvQ
	(envelope-from <io-uring+bounces-12157-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:07:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ABBE9125703
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE2A2301750D
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885FB2BD5A2;
	Wed, 11 Feb 2026 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ilZTz7FF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204F01632DD
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822394; cv=none; b=SttDUQK+voBUapHXkYO9O2ZIeAg4BTO2UHjIVtqORkf6fo7JCgF3dpnRO3BX4ArBzcG+l4HQbVNroPB0VBTYYkzzBH+tMBjGVynXRLbTe0yW+skgb7knWglL6RV3/y4k0tmTNeFp8gtDSJ1QSucxmWFGW2i2I0t3UGwY60qp+fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822394; c=relaxed/simple;
	bh=Ej9fl4mQZ69yctcVpf+b9hNDLVrExKQQtGnHwteAsA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LloTBHaTVsFSFppL37DDucMUuCCPKpkGwVadMUhu9byjhneoPLOd6HLrOWmsLzOYniZXpst513iMVcK07UtoZKUZhvlk40giWmvFlYjXCkw8M9RLSX9Byd27UMQyPhtmyLGQ+bZd67dhdVYuGE6RNjqRCNKYYPeZr/51DgPett8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ilZTz7FF; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d1851d85daso2034717a34.1
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 07:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770822391; x=1771427191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uY/NQ9xxRlpLelqZEjLTGgzE855U4ciw83F5DKXPts8=;
        b=ilZTz7FF8wxeS+aJhXnfLgNnLqJdubCfUeX8BJ/ShnWflwdb+9KKUKa8ovXxHmpBmZ
         7OTanJbM7yBtq2iymuAW+IpqjZMAar8lyw1jpRwyejVrFbjYYy6QidhhICZnT7PJ7yoj
         SNbxB5tS5uCb5zv6JHuNwzPW32gzHWDhm3keftaK0TmHWYjlvaCMQwTYJYXAqGVGdx+D
         K+Lodj2QCEuPxtmuR13j1+9SndRv6jnzw+tj5dj5c3UOlegZ2evLy84G5h7bXKA98Nek
         wCBD+KBuZwErNU4vOgMRPwitZ3OeR63bPPCnjSN/lOITwiOarCYtV5Q47DyDrBCXzPYH
         W6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770822391; x=1771427191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uY/NQ9xxRlpLelqZEjLTGgzE855U4ciw83F5DKXPts8=;
        b=ey3Z29i25nZhq5akPgq+bD1k0cCuyageWIUA+MTXtZ0m9X8RY+UUNTvg5CkhDmv4XQ
         GQdwNP9HWjpDOHQ9v5uDwFXgXiMK7qJeqb0ar32cmb8B4nk/KiKvOjzo4oQ5xBrIegF2
         cswl+gmvIbfWlKMRvpHVHOA1QL8gCcePEIXPajSI43UYQGVVoaLoDNzxOZw1DZHS+vqv
         8Tbr9n3apseSG4dRoyt9T6jCfRebYZM+quYdp7xsh1gkI1MW5G7yuTftGlzUkOUSCduw
         aNtsaQ8j6qxgRqc4uZMBLVtC+DVSVngCn9nS/LccyibpYcqUFKDUo0IWCG2ScbcGoC49
         vDDQ==
X-Gm-Message-State: AOJu0YzTfgFQweC/KYtR1SHX8tble3Jgy6qMf3fH4P9SJMpVj9QlA/RW
	ITm1s+Pea0skNTuu+kzfJbMGrRAoBlC++NQ4JxieBLq2SA3n/FftiEqXRJo7AYQiMMoU3IaFN/3
	iaYh5CXU=
X-Gm-Gg: AZuq6aILE7VoHO3cE7kyHDAZPWEEaVSJHxlWpD8Tp6o3QghfvG9YyTDDa5gM3JCzr/6
	D72S2ZkOeU028TptKWs6M+1PLxhaA84rCGXk2zJhElfZx/uBJAt4CREKB8HHEl+HWtiHZox9fZ3
	zDl5mmHiLOXOy+gFgL3c3xrKLayoN5+ah8/K1CQMp8VA4fv/5jVxX0ibXNdImjatcf5Y3P2olVQ
	rI3ujO8jkCiFI2APhEi+n5GfXIjC0wc3UiHbwHrlFS35z10qoUS9lfEf78o66b0ZdYrqndmX94H
	gm1vakjSYoG9yt91suHomVrN7twdXfwFV22jpM4VZmvtCs7ZP9wVpPYDyLpnTyRDpkuCxdkNDZr
	okYbwIkTih43Q6BbPe438O0pQaktNOk/jZ3FUwtMeK0+SEHpXUxXzrLjQbQ2RV1ovh9PaKlKZDE
	jfZQRRnq5V96YEDD8KIVL05ar7QREyQh/U5OPEnqV58evtKj3r7Wq0rygmSZjFju/vIkHv
X-Received: by 2002:a05:6820:1808:b0:662:c6f1:9231 with SMTP id 006d021491bc7-67437d6da96mr1352432eaf.4.1770822390621;
        Wed, 11 Feb 2026 07:06:30 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf16c383sm1462414fac.14.2026.02.11.07.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:06:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/bpf_filter: move filter size and populate helper into struct
Date: Wed, 11 Feb 2026 08:01:17 -0700
Message-ID: <20260211150626.136826-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211150626.136826-1-axboe@kernel.dk>
References: <20260211150626.136826-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12157-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: ABBE9125703
X-Rspamd-Action: no action

Rather than open-code this logic in io_uring_populate_bpf_ctx() with
a switch, move it to the issue side definitions. Outside of making this
easier to extend in the future, it's also a prep patch for using the
pdu size for a given opcode filter elsewhere.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/bpf_filter.c | 17 ++++++-----------
 io_uring/opdef.c      |  6 ++++++
 io_uring/opdef.h      |  6 ++++++
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 3816883a45ed..8ac7d06de122 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -26,6 +26,8 @@ static const struct io_bpf_filter dummy_filter;
 static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
 				      struct io_kiocb *req)
 {
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+
 	bctx->opcode = req->opcode;
 	bctx->sqe_flags = (__force int) req->flags & SQE_VALID_FLAGS;
 	bctx->user_data = req->cqe.user_data;
@@ -34,19 +36,12 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
 		sizeof(*bctx) - offsetof(struct io_uring_bpf_ctx, pdu_size));
 
 	/*
-	 * Opcodes can provide a handler fo populating more data into bctx,
+	 * Opcodes can provide a handler for populating more data into bctx,
 	 * for filters to use.
 	 */
-	switch (req->opcode) {
-	case IORING_OP_SOCKET:
-		bctx->pdu_size = sizeof(bctx->socket);
-		io_socket_bpf_populate(bctx, req);
-		break;
-	case IORING_OP_OPENAT:
-	case IORING_OP_OPENAT2:
-		bctx->pdu_size = sizeof(bctx->open);
-		io_openat_bpf_populate(bctx, req);
-		break;
+	if (def->filter_pdu_size) {
+		bctx->pdu_size = def->filter_pdu_size;
+		def->filter_populate(bctx, req);
 	}
 }
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index df52d760240e..91a23baf415e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -221,8 +221,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.issue			= io_fallocate,
 	},
 	[IORING_OP_OPENAT] = {
+		.filter_pdu_size	= sizeof_field(struct io_uring_bpf_ctx, open),
 		.prep			= io_openat_prep,
 		.issue			= io_openat,
+		.filter_populate	= io_openat_bpf_populate,
 	},
 	[IORING_OP_CLOSE] = {
 		.prep			= io_close_prep,
@@ -309,8 +311,10 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_OPENAT2] = {
+		.filter_pdu_size	= sizeof_field(struct io_uring_bpf_ctx, open),
 		.prep			= io_openat2_prep,
 		.issue			= io_openat2,
+		.filter_populate	= io_openat_bpf_populate,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
@@ -406,8 +410,10 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_SOCKET] = {
 		.audit_skip		= 1,
 #if defined(CONFIG_NET)
+		.filter_pdu_size	= sizeof_field(struct io_uring_bpf_ctx, socket),
 		.prep			= io_socket_prep,
 		.issue			= io_socket,
+		.filter_populate	= io_socket_bpf_populate,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index aa37846880ff..faf3955dce8b 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -2,6 +2,8 @@
 #ifndef IOU_OP_DEF_H
 #define IOU_OP_DEF_H
 
+struct io_uring_bpf_ctx;
+
 struct io_issue_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -33,8 +35,12 @@ struct io_issue_def {
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 
+	/* bpf filter pdu size, if any */
+	unsigned short		filter_pdu_size;
+
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
+	void (*filter_populate)(struct io_uring_bpf_ctx *, struct io_kiocb *);
 };
 
 struct io_cold_def {
-- 
2.51.0


