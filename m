Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC40B2DF582
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 14:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgLTN0K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 08:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgLTN0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 08:26:09 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61415C0617B0
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:15 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 91so7996305wrj.7
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ck46iY/TYTKrxHFIPBNz7oGe+X6AYIj9eMrAELFHYGo=;
        b=KuTYCsNNxzZG6EJCu5If7c495wmK4OYyxx/+3KsR6BR27Q4AvkkzMM1lVl4BW+P7Y/
         71PtlpGi4r8oVI5JsZxjf5L2h+O+wxTtWeElpSk6qluci+qOueBRoIXngO2I0MR8e03t
         zVD3/Wt2Vb98wm4WahjCw+Jvim2TZxMMw6YSuT+EBZDSRlL6FIqr+tvFlJgHMzbH8aQI
         2j/EHb83grxjdvbvs/P/OjYfN/yt/b7daC0jakQnhqozC6g4Q04kMERrmC0UnA4kkVR8
         qwkn7YYATU1E6thram7HBM/dSt2Nh9sg4gaEZsB+EaUxRgS+LcvUExNws9p9nVJSZRob
         R9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ck46iY/TYTKrxHFIPBNz7oGe+X6AYIj9eMrAELFHYGo=;
        b=WxbA8B5dFdSxGxi5GEsSADJtYsCs2KIqtzpj/Dytg1uNuHcHSXQo0u3hWdVI03nknz
         SBzCIPojXmsbdN46nx/p6UJrAjcRPbmsI85DEmbmNk73h/db3Ccj3waRfYaCo3XwQbc+
         ufr+gwUM/f4W/CM4JZm99fJIpwDmV1FScC/apSi20wSpcTYwtA9+tqxId4Xo7zkmNQLv
         KL01SEfBQOGtGpNjy2x0WcUVgyCr1ZfPbn0zgr521uDMrO1nh+1nZGzmQueLggsjRqZu
         4o5S4tMDfwm0mZxqnUWtXmt8+daG3pb58RwUovlkpS1YNQp7wtlT27vn5QsanoB9wnJa
         xE2g==
X-Gm-Message-State: AOAM531BuYAOOqlT0tN5yOdDi7hh8FDCApcwv8SX6clzL16n2L5u9S1+
        Fe+mnmhKEzeGXt76xRrd9Jw=
X-Google-Smtp-Source: ABdhPJw9tGYkQeGsFblVLO8wDR7+Cs85v7xe9xaM96Ks0dImsZCiHaYO1JZ7HIOq0F7q/fYr80BJrw==
X-Received: by 2002:adf:ee10:: with SMTP id y16mr13902861wrn.296.1608470714088;
        Sun, 20 Dec 2020 05:25:14 -0800 (PST)
Received: from localhost.localdomain ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id l11sm22946519wrt.23.2020.12.20.05.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 05:25:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: always progress task_work on task cancel
Date:   Sun, 20 Dec 2020 13:21:43 +0000
Message-Id: <7df05cd5492a204dade1c59d02fbd28b14893ee8.1608469706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608469706.git.asml.silence@gmail.com>
References: <cover.1608469706.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Might happen that __io_uring_cancel_task_requests() cancels nothing but
there are task_works pending. We need to always run them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3690dfdd564..051461b5bf52 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8794,9 +8794,9 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 		ret |= io_poll_remove_all(ctx, task, NULL);
 		ret |= io_kill_timeouts(ctx, task, NULL);
+		ret |= io_run_task_work();
 		if (!ret)
 			break;
-		io_run_task_work();
 		cond_resched();
 	}
 }
-- 
2.24.0

