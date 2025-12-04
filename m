Return-Path: <io-uring+bounces-10965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8EB6CA58B6
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 22:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D842D3068148
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 21:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E2D34CDD;
	Thu,  4 Dec 2025 21:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckn6UEgo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE2C398FBF
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 21:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885108; cv=none; b=Z0uIjWov+1Wi2GcQTcYWOxlT0k1M6dRi92H/cf41GxgH0lVJbzcqq5jahmP6/wjAn2dqny1XmOMnp5vwPTmqF65TljauI80yajKhG2wicnCgnOJPwzKgBLw7nBVnkwh5wI+u6oGFoZry7IwiFfZll958L77W06nrQTvY2V3+ArA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885108; c=relaxed/simple;
	bh=zb6mo2JNbL6EUMpIBap7DLrfk8MZ3l0rt/jptgqVPTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWC873yviMHox+TKbJKPBR3IahEALGjPDyHdMJZJJZVbU1k4793inK9r7PNjUNSvX7wMFuxh7Pk/SdGO/M6mT2gCUW0glyAuSsW8TdkHRvXU9BmKf5OUjUwF5MZxZd4/FSzJyhsyRnKIcAM9o1x7r6n0aC6kgEDhSOfpx5jMtzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckn6UEgo; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29d7b019e0eso16854805ad.2
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 13:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764885106; x=1765489906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1T3lXcU0bYU8k0AILTOe74Snr5TPMW1KBuCfOmK1wZs=;
        b=ckn6UEgoZAsa81132rIoZ+SsOsdywyHqEVwQlN59ed90fK4JRB1cSQMqPwH17B4tQv
         zpQK82CcPSjpd1IstDEGLzycsIDPrH+GhZaeL8wLUe3TDycXCWCM2JpLnjmUZoLpcw1m
         Lt/Tq50p5sca2olVNLAsoPohTXXWjVslVQtCbf78VKUvKwxu0R1+1D9IowHizzRbGYHx
         jbu+gTLPKCmgkxK6AjRbm7qQyPTAeK7b2YV9TqdA+VQVk8XhpXZiEepAYbajgsyST68j
         kxskebP+JO6qAlNPP1xYg+O5sf8KzGc+BF+UPyu/ls9/+w8EirdZHTed8VKMg3782BKY
         gEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764885106; x=1765489906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1T3lXcU0bYU8k0AILTOe74Snr5TPMW1KBuCfOmK1wZs=;
        b=qydBlqqKb71/1pRIe4jec1yTLQA9r7VGsagI89fh2ubUpc0cyQyUqCqHBfMZfj6IKP
         F/QXBQySQOY1D36Tg8nEKXhdad1IblqLtctXfI3fI8JT8xF9AJXUJSINuCteZdH1PO6G
         9aBaViyrkzCXa8mDgPtEKjpYK76n+18lTEOYaPWRREXWmKYMmo8cC/PM6npNNgjLdifA
         MTgDmU2fuystvYdEHRux1kT6w/YIGmUWcy+qEXA4OzopaZnJbAjah/sKzcv5264BzBcZ
         g+GOPnFYOudPydLs+fJ7u/kpSons3UlkT3SYb/vOyufxrV6XzLMB0hXd6R7WP9s559xD
         wplw==
X-Gm-Message-State: AOJu0YyBstELj7yBNhlJ2WHVs7QPya4/bIkmzgwUsF8yRTB09wbhulhN
	Q6USZ4XQbrdueKocpvWtMs7nXvQ+K0ZKwzvGHYZLRG+5Hz1UpcetUqgz
X-Gm-Gg: ASbGncu3DbR4Zyfj8dXU+SYwr8f0CwuX4xp/jMmIfUC93dDT+mfIlZRqW+laMDzKI6e
	Rjzx83jei22aFDBGH3B3DHtiXp/SORERZWr2wO4IaFPfRJL3JJR4z1nRrb7xVHtw184rzLIVVjA
	zG5sS7R6Nc0PFjtP9HWJL1mgHOJCQ15QdoqqKTyHgYSOXjxQrKmI+6blkSWMEEU7fJ/D/ngZsRu
	4HKV+fJpvES/Zi8hBabqea5vqHTUtFW2Eg819FqFmnF+FtpVEV8I8vkzFfsQgO0X2B8262f/9Ky
	eIdzqhdd8XtUnetRZAPswTePmLHpIlbu+4pbil99Z+asRTAU3vqjlGdHVwVwQin7PGlyfetM95S
	TRE+A0HFhyWDHE1oRLhEARZX9dT9CAp0Y6/+VtCPrZ6aebnaVLHPwg/IR7RMpLWykhGtnwYN7NB
	/ntxUCdYuM7+025SKL
X-Google-Smtp-Source: AGHT+IHNfY0VvV64fAxu0l86O+45qXLhYJX6NDZKjcCAl69RZCv3GxIS9sGUx7RXoj+xLBDQc0++AQ==
X-Received: by 2002:a17:902:d646:b0:297:dfb5:5b90 with SMTP id d9443c01a7336-29d68413edcmr55880465ad.28.1764885105906;
        Thu, 04 Dec 2025 13:51:45 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae4cf98bsm29265065ad.36.2025.12.04.13.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 13:51:45 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	csander@purestorage.com
Subject: [PATCH v1 2/3] io_uring/rsrc: rename misleading src_node variable in io_clone_buffers()
Date: Thu,  4 Dec 2025 13:51:15 -0800
Message-ID: <20251204215116.2642044-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251204215116.2642044-1-joannelkoong@gmail.com>
References: <20251204215116.2642044-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The variable holds nodes from the destination ring's existing buffer
table. In io_clone_buffers(), the term "src" is used to refer to the
source ring.

Rename to node for clarity.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/rsrc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5ad3d10413eb..04f56212398a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1207,11 +1207,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 
 	/* Fill entries in data from dst that won't overlap with src */
 	for (i = 0; i < min(arg->dst_off, ctx->buf_table.nr); i++) {
-		struct io_rsrc_node *src_node = ctx->buf_table.nodes[i];
+		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
 
-		if (src_node) {
-			data.nodes[i] = src_node;
-			src_node->refs++;
+		if (node) {
+			data.nodes[i] = node;
+			node->refs++;
 		}
 	}
 
-- 
2.47.3


