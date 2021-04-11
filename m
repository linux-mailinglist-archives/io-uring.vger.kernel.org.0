Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC65F35B114
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhDKAvY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKAvX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:23 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895C4C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g18-20020a7bc4d20000b0290116042cfdd8so6671212wmk.4
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5/kHDtCTWA+k8pfcg6n0eofFa3PpD0Dl5r17Kpx5+qQ=;
        b=XSNevgys+WjA1nSJGe2qmZXfeEQFKlzKWyly8vfNtzuPCke2HB2BTCfcn90xNTFcQb
         Rhw7eXogO4S4FHg8Dqk87MbE3/RZRDTTnfkQSk5GRiU6g6RZK976v9zZkAPw2g7eVGfr
         /vnPhVeM4SIgL+HpAZdtgjAxqtAxRujFnAQe4rl7OiecfJ3WbYxvgIteOQFgQgdMrlpa
         T81lbjpKdbBYBnIrqgH4P32H9g9GZGP+Qnp/7cAwYwfEnm72xd1yvM50mWMUNHWG5kYT
         jarm4AKMkN5VhmzQ+l5+K7QYt4yBv2qcT/MVM14p9nB4/4adqLOLxP0VZXEgYhZiT/o2
         30NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5/kHDtCTWA+k8pfcg6n0eofFa3PpD0Dl5r17Kpx5+qQ=;
        b=IJVow9+D4dPB0biKYYlMvKR23qNtkbD9giEXtA79D75q4KM+K4HkGkFZzKaPEA+BAr
         D6x62Jeh4Dw/z3daLYJmY5a6tFp435MAMwbZtlQwJRbXl/ui/pIW86xW3lUMCXzLeQck
         cy1r5wxLmVRq4gJzsD8StZZfgq7lqwDZ3dqHN+A+7TkFzMtRoSyqqor38WPahJwTQPJJ
         qz9lztZIuSgdnDy81PQ02afo7OkwcVQn+gBfZXW8j/lA3P6B9zmViJUeuBuFBSlqgcgh
         tqO9xU9bqK5KCd46rxNPOa8rMMAGSxsJk/HiMTmMwbfQ0/g6WV8JKM9a48Jjig7wmwKP
         wiPQ==
X-Gm-Message-State: AOAM5312aO30WubosmAbq5sdyuK0W/nVfj1xexedaOT4WMJ2hyHEHXOm
        b0Pbqy8muA0hZHNQPd+0uIs=
X-Google-Smtp-Source: ABdhPJw36txWEpOvqK4RCYblfQ4da1JMGiKQby7lFYUNTEF1k9wjZvbQz8U40RtWHZBx+MUGLisyiA==
X-Received: by 2002:a1c:7519:: with SMTP id o25mr19713237wmc.35.1618102267409;
        Sat, 10 Apr 2021 17:51:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 16/16] io_uring: return back safer resurrect
Date:   Sun, 11 Apr 2021 01:46:40 +0100
Message-Id: <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Revert of revert of "io_uring: wait potential ->release() on resurrect",
which adds a helper for resurrect not racing completion reinit, as was
removed because of a strange bug with no clear root or link to the
patch.

Was improved, instead of rcu_synchronize(), just wait_for_completion()
because we're at 0 refs and it will happen very shortly. Specifically
use non-interruptible version to ignore all pending signals that may
have ended prior interruptible wait.

This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2a465b6e90a4..257eddd4cd82 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1083,6 +1083,18 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 	}
 }
 
+static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
+{
+	bool got = percpu_ref_tryget(ref);
+
+	/* already at zero, wait for ->release() */
+	if (!got)
+		wait_for_completion(compl);
+	percpu_ref_resurrect(ref);
+	if (got)
+		percpu_ref_put(ref);
+}
+
 static bool io_match_task(struct io_kiocb *head,
 			  struct task_struct *task,
 			  struct files_struct *files)
@@ -9798,12 +9810,11 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			if (ret < 0)
 				break;
 		} while (1);
-
 		mutex_lock(&ctx->uring_lock);
 
 		if (ret) {
-			percpu_ref_resurrect(&ctx->refs);
-			goto out_quiesce;
+			io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
+			return ret;
 		}
 	}
 
@@ -9896,7 +9907,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-out_quiesce:
 		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;
-- 
2.24.0

