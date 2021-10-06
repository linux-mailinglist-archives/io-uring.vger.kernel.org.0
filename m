Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2995E424111
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 17:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhJFPSK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 11:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhJFPSJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 11:18:09 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B47EC061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 08:16:17 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t8so10007628wri.1
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 08:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blw7zJoDdjXUAWUIgxh9tzJj4VbYDpxx1wZJeDIeGho=;
        b=JUtNQKAgKZrlf4LVHKHnRPdFPaCcwkwVvQRgiLRNPxmaMlQ3Y0Ive/9Jx2i41FRBI7
         v/7+TR5+tbLlCbhQoqNE8Hwq8tj18KlfhRG8xR9ekNkXcmEaBL4lUVBk9XegRh7nAtHz
         gDAwIOV/9gBkVCqbKBZi4ol3WiPouAczDGxRCk7oiqSLmLP/NcYYGkJk53tVTQTnk6oh
         aev76NMKQEOkucAhCD329dLYghEc91xbyJ03IDyWePqw6J4Vf4piyyAHlOmFxLfLiSIY
         Ts0xQLi5GbNGgZJpgkqPBUGp9KdqnvhRAwQW+x2vRmubjcPSt4DnYHeWd6FiZYaJSpze
         VdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blw7zJoDdjXUAWUIgxh9tzJj4VbYDpxx1wZJeDIeGho=;
        b=ZHtFcoZzfYB6wvKnIXmDmXQMDwxrQH9XEQqRK3T0nX5jwiT9WTmmCjsT+U1Jy+MHf0
         dfiKGvU32RsuRqkvbmrZOUD38PwnAtlF4Wp4OZgUeHmElXhdOxMfs94TGUPTPBCC/Zwb
         hyg9kRBExUFgV/lSERwwsJ0jvCB4KTAXLwjb/xNvBQeS8udOz0fjL3puQaMsgAAhZJS3
         H/c6tWmhQAGCU7yN4uaDMxKs3qd3sc1CzR84jEcp8tVIXRmPiyU8EySOqhZWvmOsIrAD
         0OSIBkVPxapVjJPHc9F/V5jHy9mrUB56tsgGvCsVDa81Mk1hg1HQcSsJI76os2AR7CkW
         LUwg==
X-Gm-Message-State: AOAM5309PDBga3P4L8oswvjfffcFCksinEI9womN9CWw1/oA8QA602+B
        E7F3sUorUviKrIDqIvVPgVndO9UEKjY=
X-Google-Smtp-Source: ABdhPJw5O6LrkTJGdXF1mmglzU1uwmzOUfV42XscHxaF9CEPeMIBNpQndasxaM1a9A4bdGPrC7PG8A==
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr30073070wry.292.1633533375864;
        Wed, 06 Oct 2021 08:16:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id z6sm8794396wmp.1.2021.10.06.08.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:16:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC] io_uring: print COMM on ctx_exit hang
Date:   Wed,  6 Oct 2021 16:15:29 +0100
Message-Id: <77c68af25c707073c2708465ae576f1a231cf961.1633533200.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_ring_exit_work() hangs are hard to debug partly because there is not
much information of who created the ctx by the time it's exiting, and
the function is running in a wq context, so the task name tells us
nothing. Save creator's task comm and print it when it hangs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Just for discussion, I hope there are better ways of doing it.

It leaves out the second wait_for_completion() in io_ring_exit_work(),
which is of interest, so would be great to cover the case as well.

 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73135c5c6168..db0065637549 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -447,6 +447,8 @@ struct io_ring_ctx {
 		struct work_struct		exit_work;
 		struct list_head		tctx_list;
 		struct completion		ref_comp;
+		/* save owner thread's comm for debugging purposes */
+		char				owner_comm[TASK_COMM_LEN];
 	};
 };
 
@@ -9344,7 +9346,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 
 		io_req_caches_free(ctx);
 
-		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
+		if (WARN_ONCE(time_after(jiffies, timeout), "comm %s\n",
+			      ctx->owner_comm)) {
 			/* there is little hope left, don't run it too often */
 			interval = HZ * 60;
 		}
@@ -10266,6 +10269,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!capable(CAP_IPC_LOCK))
 		ctx->user = get_uid(current_user());
 
+	get_task_comm(ctx->owner_comm, current);
+
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
 	 * the mm is exited and dropped before the files, hence we need to hang
-- 
2.33.0

