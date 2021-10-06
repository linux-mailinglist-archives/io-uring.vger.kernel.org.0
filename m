Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA34240D8
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 17:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhJFPJe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 11:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbhJFPJe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 11:09:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BE7C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 08:07:42 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id s15so9816865wrv.11
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 08:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eApkLLSyJ9zrDGGK3e49LpiJsyJ6BFIixo7VBvYi29Q=;
        b=TkAYfszYTEkmWEa9mwd4TAwCg4oMVgBDeYgx2Dkf5Xz/AG7yWd1pOBREXHOmhOFZBQ
         oL29z18c+iH+GSIXTlsl6R761SgJcUsCEgX8NaIL5tyXVAVmAhqZevTtCGoOs0xkgICr
         Vq7xtBd1tRaihUiFHKDH4WklCWD2mMmIeeOaJqHJbHRiU+NavOxXa2zm989eh5cIEwje
         dlCu2Qb6w3aA/TPmGB0YVNCo36kdBCtUUXU1EzIG7mlLKduxYCGOiYff5EMmPosPc2mo
         SIC3StM0N30et+2DWHlm6mFPIKjm2Hm2w4UYnkZhh4Nr75adp+hxLSIjv7kNn25KGcO+
         Chfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eApkLLSyJ9zrDGGK3e49LpiJsyJ6BFIixo7VBvYi29Q=;
        b=2l3Y4rVe0/XZ0k0MKrLxi4jKGTJugkgAdPLisux8pQ//0rEadiof5aFfNsmHxCovCI
         IdMZTOCpSK5V+c5Ir6bm9DlHNQ3sWmyuMW8ZoptYOdTfx+QYRBCLEIZlHgq1mqAu1wu0
         2u5KsZ93RcW/hmPgg/9+12nju/TSPzL/P5aX5ninUVrqKjaDuhrxvD1I3GTyiGZC4L7b
         IACnrzP2yGnoS7k+pMIZAIDvnZJ/hVkD1J/Fx9mVTfrxTxJsb5Wmhlu/S+lB/CU37/CT
         Ov/PXNCU2nmE3zHLoUBunmQdtBWQ/H1iVso5dACn4nl6o34e5+n1zaC8musqtNuLPQfS
         +Pxw==
X-Gm-Message-State: AOAM533TS+0j3v17zyD/Y8KhIBEzM6tR945cdxL97V6SvUiGB+a/ti83
        EzIIcs0sWVRYE4zQc3/o+oIxVY8fLDM=
X-Google-Smtp-Source: ABdhPJwgQjK0zASLb6vXSMKwwA/IkoHUAJjMXftLMOYRxK709KpFhlGxs8ARI54jPJp1SqxZbTCNPA==
X-Received: by 2002:a5d:64e2:: with SMTP id g2mr29848045wri.20.1633532860442;
        Wed, 06 Oct 2021 08:07:40 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id o7sm24678368wro.45.2021.10.06.08.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:07:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/5] io_uring: remove extra io_ring_exit_work wake up
Date:   Wed,  6 Oct 2021 16:06:50 +0100
Message-Id: <de9a71ee255112dcaed3b5d426be24934e74722c.1633532552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633532552.git.asml.silence@gmail.com>
References: <cover.1633532552.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task_work_add() takes care of waking up the thread, remove useless
wake_up_process().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f4aa2cdaaa2..73135c5c6168 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9370,7 +9370,6 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
 		if (WARN_ON_ONCE(ret))
 			continue;
-		wake_up_process(node->task);
 
 		mutex_unlock(&ctx->uring_lock);
 		wait_for_completion(&exit.completion);
-- 
2.33.0

