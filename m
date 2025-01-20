Return-Path: <io-uring+bounces-6024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1474CA17009
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 17:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E2E3A796B
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 16:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260AE1E7C3F;
	Mon, 20 Jan 2025 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q2fzR57c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5343619BA6
	for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737390128; cv=none; b=iFWnhNeR0DzKWPBth0oeQbSvutLj635+Gnq0JMkfyzws6KwetS5KAXh29zjisCPX9zykf+NYUX4Jq9U9W2G1htMGsxD0Ff1zmpTrph+41dfLKNDKIdDinMpy4GtwALjha6FUKkY4dSESCAyAJDAjpSzef403PkVC5TUWGQRYMjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737390128; c=relaxed/simple;
	bh=8fIX//j64iO7ZvDYGldrNMq5zBkTxUOcmJ3XHeDThgI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=exzVuoJPnoPFMFVK5dfaEMhAeU74pRUcuYBF9bj1a/IDDzSUbHpMAzGg6+ckVLvhdXqZf5oq113/y7xIiFGLrx7mxQAzkN056yv/ulY5D5FOHcg9QiABgDFw0QXpAGiEez+UcAmPgb8kbD3ZTMLCexjp5OC8cJ88BblX78U6dvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q2fzR57c; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso90135e9.0
        for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 08:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737390124; x=1737994924; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kcegWB5gzBcjXR2hlDCxV4rmwPgblc2EWcoFtm7prig=;
        b=Q2fzR57cfdcCb+/u7K3ooLUQTFcgpSYKrHFhwYU14DthDx9EIFGXH58t103qu+IaCN
         rvULlMBPY7QxidrG2f6WKRthQ/hwdSv/2a+BypBTxnMTqBmZUGPYQDQwjjAoRlFr44+R
         cQnBXWj3Sm8sD0q3iMHdLKS9iGgwKpUOv24ZjrGc1uVQ1C2HCt+FcxCZxykH8olAeGA4
         8ktvcNMnqSKPGS3bFWLuiXelx4xseEwuAqDE5SQKlw2Wo1HMdibgVSXhzxdh990lsVlm
         qfbg2uCQ06eOyDsP0EdovK9hXZ/b829gW7u8lpFpYzhUDgyj51Ty7M8w5o0eNGZ8L7p/
         KOuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737390124; x=1737994924;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kcegWB5gzBcjXR2hlDCxV4rmwPgblc2EWcoFtm7prig=;
        b=CdGC71K6zJCC7PEuQWu9Zsm3Kzk79KpWD309Aqg3X/y9sSMGA88d7wvgmi8N+vrH4B
         05lBDSoQ6uaKxV01KhFnFSMT8BTkDVyzE2AKpa3njl6v7AJQc3ypYDdS/hRt/RkX3XJL
         81Ra6JQ152Kkg/U/I5k22yPhdKRLTku+ux+29idDbll/XqKGEjaFlvW7hjQzR/HrykoI
         1ITTPKj8WPcEBMQPtO8MIagiCGYfj5Kv2qpivYPhgU4EXVJXgX+foSh56OQkLtv7TiOn
         fc2ffQV+UAyMa6K7tPfyfX25EXuKi8QNYWTz0nHG3v5RvCB+AJpvsfbdIP3L9Zp/6lf/
         PwEw==
X-Gm-Message-State: AOJu0YxYJl9axDUGLda92U0aXpmZvfJExuQjK9d9/4BnqKkV75gEFRfn
	cRiqzGgK7gdyIX5x/qIbKojwiUjCROoLcbg6mohTUlsd9q12Js1Q1Tp3SYX7ds6SfN83mHlzcbU
	VMVVq
X-Gm-Gg: ASbGncufmfwqgQnSFXrCRkvmSi8DMWke4uk9wyanNs97zOFLRckQw8VtlPIliRruoeL
	KHDa2viqcEJInsoYFJjJqzMErWzqWTnAWrRkL7yfL963UMskakcY6hqzouyXbDsja8M8LP3kQOT
	N0fMSuKeUeJrQwv9bxYJNATayn84yRuu0Rs08+K+x8+Bj0D64TagglQlJY5O6lYMxb/kyqjJ1mM
	SACf95eOqBabJop5+sgNb1vFO/FbNeB1unIZtyEQpqYkIzdj1jA28O45WY=
X-Google-Smtp-Source: AGHT+IHniSo3OPrzq+gDj0wmmnMZTEUp9dmnFoKK6kXaV5OIUAJxg/XIpg8ZZQZRU63yt/CiGErmJA==
X-Received: by 2002:a05:600c:584e:b0:435:921b:3535 with SMTP id 5b1f17b1804b1-438a0f3de76mr2505565e9.3.1737390124179;
        Mon, 20 Jan 2025 08:22:04 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:f36d:a4b1:14eb:4837])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890412f7csm143613825e9.9.2025.01.20.08.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 08:22:03 -0800 (PST)
From: Jann Horn <jannh@google.com>
Date: Mon, 20 Jan 2025 17:21:57 +0100
Subject: [PATCH] io_uring/rsrc: Move lockdep assert from
 io_free_rsrc_node() to caller
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-uring-lockdep-assert-earlier-v1-1-68d8e071a4bb@google.com>
X-B4-Tracking: v=1; b=H4sIACR4jmcC/x3MSwqEMBBF0a1IjS2I8QO6FXEQ9EULJUrFbgRx7
 waHZ3DvTREqiNRlNyn+EmUPCUWe0bi4MINlSiZrbG0Ka/inEmbe9nGdcLCLqT8ZTjeBsm0qmLL
 1zqOmtDgUXq5v3w/P8wKtUXX9bgAAAA==
X-Change-ID: 20250120-uring-lockdep-assert-earlier-264e039fafe5
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737390120; l=1766;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=8fIX//j64iO7ZvDYGldrNMq5zBkTxUOcmJ3XHeDThgI=;
 b=n4Y/AtAT/KFaXFstIsPDujMD5gT0BecNur//c1jnRiaK3zAqCbagf0kiZRPpVyddUtcTdKb0A
 PWSpHMvzJWTBvMfOzyiSXEKSbh044MFNziZHFtKgVNkRcD2NvXZyuTX
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=

Checking for lockdep_assert_held(&ctx->uring_lock) in io_free_rsrc_node()
means that the assertion is only checked when the resource drops to zero
references.
Move the lockdep assertion up into the caller io_put_rsrc_node() so that it
instead happens on every reference count decrement.

Signed-off-by: Jann Horn <jannh@google.com>
---
 io_uring/rsrc.c | 2 --
 io_uring/rsrc.h | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a5fc035af8ff910d423930d7c662cc0e1a9f8444..af39b69eb4fde8b6e478e71c36dc04d3eec1b6d1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -444,8 +444,6 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
-	lockdep_assert_held(&ctx->uring_lock);
-
 	if (node->tag)
 		io_post_aux_cqe(ctx, node->tag, 0, 0);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 5cd00b7baef8b03dd5f4a3aacee859b37db98e9b..190f7ee45de933b39a8c4d33dc86f687e338eb16 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -2,6 +2,8 @@
 #ifndef IOU_RSRC_H
 #define IOU_RSRC_H
 
+#include <linux/lockdep.h>
+
 #define IO_NODE_ALLOC_CACHE_MAX 32
 
 #define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
@@ -80,6 +82,7 @@ static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data
 
 static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
+	lockdep_assert_held(&ctx->uring_lock);
 	if (node && !--node->refs)
 		io_free_rsrc_node(ctx, node);
 }

---
base-commit: e8153972dea537f1ae3ac45355fe3b2b3cbf59bf
change-id: 20250120-uring-lockdep-assert-earlier-264e039fafe5

-- 
Jann Horn <jannh@google.com>


