Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5705E327F0B
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 14:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhCANI1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 08:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235414AbhCANHN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 08:07:13 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6898DC06121D
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 05:06:17 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a18so7869549wrc.13
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 05:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=84IsB2LwZkMzMMvdOpKy2L20pHDOMSTw2EOnIbea67Q=;
        b=F50j5nxhIu+8Jg408Vi0dqRoK1+x0L11+go1VwiAkLU8zoWIRSBUWdkOljIaIEKB6Q
         R/2hqZc71XxLdw1VUu8Gv0Oy5rZxM/r5jGMIxbSuj6ep8d4G2M/6nWnScB3rxkkyHoNg
         ucIsPxpmlcUkJL8I5gd1V7wOd2uHFXTuRexMNhvY9vHUhh6wxA3/OzhdmhdKJFnrjtS8
         4yDhjKfDejTHdL+7KpACE1PZrpd/WDO01s0zdlcPJ1M2XhwgOJkyRnCeGBqyTXOqzEek
         6lt/kkoLyN/WrYLksa7/ogBnYa/++fCjZC4sfc8ULxnc6vgNRMsAraU7+fU2pwo6+n0r
         9/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84IsB2LwZkMzMMvdOpKy2L20pHDOMSTw2EOnIbea67Q=;
        b=F+s4Bq7itDhTvIX7lFrrW15siuTw348VmMH4uR/+qcWyoDIw8r/rhcjg6X+ENPw0e6
         XboPJkspG2JSsLm4j5UlY7rAcd/c3PQ25Ut0iejqbBBDpXfhdIvbpaRGlKJFXpxojTqb
         3vggHhgWZdUPEGoXS37cUWWI6OLrLCCf9Pehhe0FLfH2GsQB3+35iike3LM8uIkf8SQG
         vN93rK2UTZ43k7OKNr8SfQcvjXt4cnTV40aLDaqr7xziJC8O6X8h6t9LTmEmrrNsZ72i
         0Jkc0D3KkafWIbuJOTrV8/Pg8yuDDn7xHUQ+0Md24ygEekRmMfOIXSkZkDcDz4baJTRE
         qPug==
X-Gm-Message-State: AOAM533qLCsQiDo7xNphKz1AJ5vPTUPPXrmqCrvVaSIt7niUxWYHMU6M
        TAF2/HKmr0AKv1A9zhOQDRM=
X-Google-Smtp-Source: ABdhPJwsuWQVbFDf5eJ+P9B528NumymNEn9pTfn6M7m3fNUBeNlI/XoQuPn1L/p4PIrFbP7p752PRQ==
X-Received: by 2002:a5d:6d0c:: with SMTP id e12mr16181631wrq.136.1614603976208;
        Mon, 01 Mar 2021 05:06:16 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id j16sm1898903wmi.2.2021.03.01.05.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:06:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: remove sqo_task
Date:   Mon,  1 Mar 2021 13:02:16 +0000
Message-Id: <ccd790202c88a7ea2ca4e9f83bc25d3f4dfb2107.1614603610.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614603610.git.asml.silence@gmail.com>
References: <cover.1614603610.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now, sqo_task is used only for a warning that is not interesting anymore
since sqo_dead is gone, remove all of that including ctx->sqo_task.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6529761b77eb..7fb284ce5319 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -379,11 +379,6 @@ struct io_ring_ctx {
 
 	struct io_rings	*rings;
 
-	/*
-	 * For SQPOLL usage
-	 */
-	struct task_struct	*sqo_task;
-
 	/* Only used for accounting purposes */
 	struct mm_struct	*mm_account;
 
@@ -8747,10 +8742,6 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 				fput(file);
 				return ret;
 			}
-
-			/* one and only SQPOLL file note, held by sqo_task */
-			WARN_ON_ONCE((ctx->flags & IORING_SETUP_SQPOLL) &&
-				     current != ctx->sqo_task);
 		}
 		tctx->last = file;
 	}
@@ -9398,7 +9389,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->compat = in_compat_syscall();
 	if (!capable(CAP_IPC_LOCK))
 		ctx->user = get_uid(current_user());
-	ctx->sqo_task = current;
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
-- 
2.24.0

