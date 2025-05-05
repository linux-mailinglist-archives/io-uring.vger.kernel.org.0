Return-Path: <io-uring+bounces-7836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F610AA9EF1
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 00:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9768017ED48
	for <lists+io-uring@lfdr.de>; Mon,  5 May 2025 22:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A01C27B4EE;
	Mon,  5 May 2025 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F163Hjl7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B7C27B4E3;
	Mon,  5 May 2025 22:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483278; cv=none; b=Po2uFA5Hf+LowSu0w4qPEpmiro0OK4t/xEr9BoteeRvbLwlH21K9oP0EoB4YetUf1ixzTlUBxdkmdrwAMG9LgSRuY7PxDmR2hrkXaVR5Mb9zrn+xrDf0kPVgdZEg2KkFvGEMaPiSEeZ1DYHJcDVFPziq6LEaDU9F0k2flJGTcYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483278; c=relaxed/simple;
	bh=Oz3eyYIFP4kwj0nI69Wh/mRzmq93sGznS23VdlXRZAg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h5wp8Oa9RtyVb0HwK083dwurZixu9T8F1ty67mMOOa81Adkd7Zz+DGg8QtZWbO7gSwMky1tQF4T3zuVoGY8whFkd5fcs06lFlb60vj6XrYz6HQxBa41QzjuJJgXPgdD52HyWUef5VT05sgQ6niyh7Iso+YON7m7XDcnMdLS483w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F163Hjl7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE28C4CEED;
	Mon,  5 May 2025 22:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483278;
	bh=Oz3eyYIFP4kwj0nI69Wh/mRzmq93sGznS23VdlXRZAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F163Hjl7RgcFSvlDxfBjupVplZ72qwU0WuiNPYixzOgJVhZ2yjB4z95iZ6MdlSMA/
	 iT0K7CSAFx9jLSoGjdfTMj0l68pu0Qk2LMcyyQY5+hQqajx1dkXX+arw5qH4h3k/TL
	 jcYHHkn5Zt8UVw0FZ0WTs3TYTtm4iQgoEuEGIz3koLc6OCgX8R8Xpxy9levodkMubY
	 5DVR+UJVlMt4n6vaVg0Oo8h/54CzfudHY0wubKGZMj+oyBVWGJAGoZyQs6TB4wQhxY
	 aEAlCET55Egno0fAVsiq9+fvthIx7hOq7n5YnBKPQ/v7x5jjnAj/uLRAUPxjNFnNM7
	 dELIhTpw4ggRQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 011/642] io_uring/msg: initialise msg request opcode
Date: Mon,  5 May 2025 18:03:47 -0400
Message-Id: <20250505221419.2672473-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 9cc0bbdaba2a66ad90bc6ce45163b7745baffe98 ]

It's risky to have msg request opcode set to garbage, so at least
initialise it to nop. Later we might want to add a user inaccessible
opcode for such cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9afe650fcb348414a4529d89f52eb8969ba06efd.1743190078.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/msg_ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7e6f68e911f10..f844ab24cda42 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -93,6 +93,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		kmem_cache_free(req_cachep, req);
 		return -EOWNERDEAD;
 	}
+	req->opcode = IORING_OP_NOP;
 	req->cqe.user_data = user_data;
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
-- 
2.39.5


