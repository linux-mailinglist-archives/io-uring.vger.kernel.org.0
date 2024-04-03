Return-Path: <io-uring+bounces-1383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 120ED8976B8
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 19:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8A9E1F2E8A9
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 17:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5B015DBBA;
	Wed,  3 Apr 2024 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoDuaa/j"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9240415DBAE;
	Wed,  3 Apr 2024 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712164724; cv=none; b=J1NjF7JlVxDXAiqd2kQ75NVuQRCPi1jhkl41Bi6PI7nxk8ubFhJGaoGZnXGf+kzfw8tqzpWxG4AJMnoCii/zs7gIRDi9gi5YGFVlo4EkSTVpDQy8HJbl9vOV6PRRZywAbcbBErbRRfWwnohlwJZ1/mWxRyLrQE9XA85IyO213mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712164724; c=relaxed/simple;
	bh=sCi2Zjwkluq7tYcwVCzU97e+fqfE0XuBcMdfkvm6RvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpAk0dLPdqyZDbeuXpmyt09BUR+Qa3THiaxtaN9Yo5D+su02EWHatC3lnSlOsmaJvPL7SLymyNYpurakujcSoddaH/4TrbMuLWaW1EMH1HiI15i0PgHme4Zddj6YtWN0e2iWICxSR0ilivfj9JLtfJ2vlkyTgOEpsjhqMqnO+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoDuaa/j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88DCC433F1;
	Wed,  3 Apr 2024 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712164724;
	bh=sCi2Zjwkluq7tYcwVCzU97e+fqfE0XuBcMdfkvm6RvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoDuaa/jW/462E1Mz4vNqzvtplX7CD1NZSUzawiiwzqzpg93V/fqtylrSmZwBAzCp
	 YyGXSkPXq/o3rd4gLl034XpvcydkUbGPYR8kDtXL+RoUkx0OtwnzB4PgUtKHB2cx11
	 XwrK8noc39LlNSYB0IceAVE9XR0PgTem6GaxXDw8DLLTH8n77gBMI9dEyDwAUXG50e
	 K2SNSeEFN03ttVWS4MwmEjB4eoe1wSi59HsiZGQA3qaAjKS66A+QiNkp999ms7DMQ+
	 Mwr9zVQvusE9fJqISqZ+mSW8wsptWVU7fzAGTdbgtpaM5npEuMutvqKLpbnzaWtzeb
	 kiUz0HqqCuO7g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 15/20] io_uring: clear opcode specific data for an early failure
Date: Wed,  3 Apr 2024 13:17:56 -0400
Message-ID: <20240403171815.342668-15-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240403171815.342668-1-sashal@kernel.org>
References: <20240403171815.342668-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.24
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit e21e1c45e1fe2e31732f40256b49c04e76a17cee ]

If failure happens before the opcode prep handler is called, ensure that
we clear the opcode specific area of the request, which holds data
specific to that request type. This prevents errors where opcode
handlers either don't get to clear per-request private data since prep
isn't even called.

Reported-and-tested-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ea772a02c1405..c1e411017d8af 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2147,6 +2147,13 @@ static void io_init_req_drain(struct io_kiocb *req)
 	}
 }
 
+static __cold int io_init_fail_req(struct io_kiocb *req, int err)
+{
+	/* ensure per-opcode data is cleared if we fail before prep */
+	memset(&req->cmd.data, 0, sizeof(req->cmd.data));
+	return err;
+}
+
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
@@ -2167,29 +2174,29 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 	}
 	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
-			return -EINVAL;
+			return io_init_fail_req(req, -EINVAL);
 		if (sqe_flags & IOSQE_BUFFER_SELECT) {
 			if (!def->buffer_select)
-				return -EOPNOTSUPP;
+				return io_init_fail_req(req, -EOPNOTSUPP);
 			req->buf_index = READ_ONCE(sqe->buf_group);
 		}
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
 			if (ctx->drain_disabled)
-				return -EOPNOTSUPP;
+				return io_init_fail_req(req, -EOPNOTSUPP);
 			io_init_req_drain(req);
 		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
-			return -EACCES;
+			return io_init_fail_req(req, -EACCES);
 		/* knock it to the slow queue path, will be drained there */
 		if (ctx->drain_active)
 			req->flags |= REQ_F_FORCE_ASYNC;
@@ -2202,9 +2209,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	if (!def->ioprio && sqe->ioprio)
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 
 	if (def->needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
@@ -2228,12 +2235,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 		req->creds = xa_load(&ctx->personalities, personality);
 		if (!req->creds)
-			return -EINVAL;
+			return io_init_fail_req(req, -EINVAL);
 		get_cred(req->creds);
 		ret = security_uring_override_creds(req->creds);
 		if (ret) {
 			put_cred(req->creds);
-			return ret;
+			return io_init_fail_req(req, ret);
 		}
 		req->flags |= REQ_F_CREDS;
 	}
-- 
2.43.0


