Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231293B30FD
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFXOMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 10:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 10:12:45 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02469C06175F
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:26 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h11so6829223wrx.5
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MTeyhxs3F2iECS7gcwKO/IsUIQTpIriKeEYu6dqLg4U=;
        b=M3LuPE0dYS2mTFYyX5uL/ypfQzbi9cgWl11VZjgvqX4Mn7bDdf9+YCOBD9umxbN9AT
         f2gX1hn7adhq3L2AyvfD136MPOSP+TPuMnxaYN6+xGDHKyOohKax7lfC2kQnztwU7Y+5
         l1OMLcjFY0K/plPZdlsy+gEymyrzAMeAZE9qNoc8HR6GKCGudrClznmx7ThckQ0NShuC
         3B4daoRSNvcmVRcArhmrUkMuc7NbwzaVNmpBzN0RPYv5SJelXTw9+8QLGHHO887cyEbp
         5Vfob4RD4cUgN1xBGTaCtrT8ZsNvERBTS3ggd1F12PhVgw6sm9za2W8bTYKYs0voDEAO
         FJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MTeyhxs3F2iECS7gcwKO/IsUIQTpIriKeEYu6dqLg4U=;
        b=nHYnPwZfLp+o+2ynwLLUkFkuuz0Bda1lB1R/VNaI0G0JAi6QHzvF+8vE6ARV6ZhXy7
         s6t9s2LqNTvFxHDHysB+QUU55L0yBVsMvEPkB2x3lPvLIwAWX1Ips634q4ELkLCHVXxy
         YAU7ywgIZKreq0eReq0AVJ3x7V9UDu14mr+kJ/pjNbyHU2y6k31VtQjQphHx39tXQRJp
         ZUqfW9dBybi9myK/4Z57tCzNdBpGJ1xa/WN244e6w4ua3lombJ3LGPv4XwCq7/RXRSnq
         gfvKBKaOHajmhqGGWi8t8Ay+6RwEUZEqkN/K4DR0hwRCCMytwn0ovn+QBvyeTY23NJuf
         K9oA==
X-Gm-Message-State: AOAM533FNo+wca+qPsQdHeV1UVmVTVeEZVkO7BpYHRrFgmOllh6rBN43
        v3+qX2oBKGoUvh9e1uxP5wU=
X-Google-Smtp-Source: ABdhPJyS+YpPOMse+Y7R/ihacDI0I4ig6/Wh7yra5ItLigwZvxSk4S+zX3Gb2fwE0GYb/ZMDDde0Bg==
X-Received: by 2002:a5d:4b88:: with SMTP id b8mr4716497wrt.95.1624543824589;
        Thu, 24 Jun 2021 07:10:24 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm3408428wrp.14.2021.06.24.07.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:10:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/6] io_uring: refactor io_sq_thread()
Date:   Thu, 24 Jun 2021 15:09:56 +0100
Message-Id: <e4a07db1353ee38b924dd1b45394cf8e746130b4.1624543113.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624543113.git.asml.silence@gmail.com>
References: <cover.1624543113.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move needs_sched declaration into the block where it's used, so it's
harder to misuse/wrongfully reuse.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cf72cc3fd8f4..5745b3809b0d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7072,7 +7072,7 @@ static int io_sq_thread(void *data)
 
 	mutex_lock(&sqd->lock);
 	while (1) {
-		bool cap_entries, sqt_spin, needs_sched;
+		bool cap_entries, sqt_spin = false;
 
 		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
 			if (io_sqd_handle_event(sqd))
@@ -7081,7 +7081,6 @@ static int io_sq_thread(void *data)
 			continue;
 		}
 
-		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
@@ -7100,7 +7099,8 @@ static int io_sq_thread(void *data)
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
 		if (!io_sqd_events_pending(sqd) && !io_run_task_work()) {
-			needs_sched = true;
+			bool needs_sched = true;
+
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 				io_ring_set_wakeup_flag(ctx);
 
-- 
2.32.0

