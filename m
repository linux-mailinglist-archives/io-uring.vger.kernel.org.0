Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0FF720505
	for <lists+io-uring@lfdr.de>; Fri,  2 Jun 2023 16:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbjFBO6p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Jun 2023 10:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbjFBO6o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Jun 2023 10:58:44 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544DBE7
        for <io-uring@vger.kernel.org>; Fri,  2 Jun 2023 07:58:43 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-776f790de25so11343439f.0
        for <io-uring@vger.kernel.org>; Fri, 02 Jun 2023 07:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685717922; x=1688309922;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQlOMxFyObtyKi3dqUsHjyRLk+YlmDbI1ZOc2wrI/Lo=;
        b=rswJrSw9Hsje/LxuX26nYZq0i86+Zd20JWC77AAiWvZrhYrlTH2VvE6pMA+PHjksAj
         QjfIsG9gwIB5+tstsgeyRYHVTS22eotxphaQ6pjjGPg9ajXDHoHLQwAnUEt3ykxr+WB+
         Ba+1rtGMVoPADUqZ3zCm02PLJBZGritlZC4TqoiNfIdT7tqsUmzcD4j9TMtXJrus5FHT
         XeVIip+R5gCUBo2BMBOw51QKERra8mFExS9nf/PMxL5GM+57DKVCrLupZNLeoaLVRx9+
         qu0ug0t7maWcOrGsCmTXHjlM9wqRhciAjtgZZCPCn/w9faxFsiJBtnfezYJoWc343Uzi
         bYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685717922; x=1688309922;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZQlOMxFyObtyKi3dqUsHjyRLk+YlmDbI1ZOc2wrI/Lo=;
        b=JGVHMbg8rFYn44D9RqADiZzNLLpSd897HkyRcy6gKWseAeQ89kame9H4O9GvpHdj1x
         tm28gEypgt4HExbdaZ38XG2PxDaLhc6Ncp7sURxCzSJqaIhMOSVT+F3VDTZI0gOWPakO
         lvmJxD6TIdgqDPSkH3tv1FsKcJB72obBz8zd5SKb2izkJv+XQaMvkQAfbOmNEP6AaYHR
         IGvlFM+eWDu9PdxuGaVquP36b5Ug1r8Ssw1VVBtfZBG87mHEC/v0vTSOdHHuIiDNSby9
         GbKF9wjV+IknVsrOST6Uzy/3yiY6YpHc+sKgjnru45RcgYJxocN9HYIhf4Rs6YXc99pn
         0auA==
X-Gm-Message-State: AC+VfDy0/hqIrQOSQlBikbv0AxjvhZtUAPDblrn5ieTRHHjPQWk+fvK1
        xa0BbiTON1fAvtuR0cg8AnSkakTXgsnNY9zKbAc=
X-Google-Smtp-Source: ACHHUZ5X8XFt7HkEDVX/EnTfuKuuRd1qIGMpX8Hw8O0ttJUZq90Jv/LG4ACutjl8cDZmWNf9c3LVnw==
X-Received: by 2002:a5d:9c42:0:b0:775:78ff:4fff with SMTP id 2-20020a5d9c42000000b0077578ff4fffmr5960057iof.1.1685717921914;
        Fri, 02 Jun 2023 07:58:41 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k9-20020a6b3c09000000b00774efe6fa24sm437002iob.10.2023.06.02.07.58.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 07:58:41 -0700 (PDT)
Message-ID: <16e8e2f5-5532-9ed0-c203-c5f018380563@kernel.dk>
Date:   Fri, 2 Jun 2023 08:58:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: avoid indirect function calls for the hottest
 task_work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use task_work for a variety of reasons, but doing completions or
triggering rety after poll are by far the hottest two. Use the indirect
funtion call wrappers to avoid the indirect function call if
CONFIG_RETPOLINE is set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c99a7a0c3f21..fc511cb6761d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 
 #include "timeout.h"
 #include "poll.h"
+#include "rw.h"
 #include "alloc_cache.h"
 
 #define IORING_MAX_ENTRIES	32768
@@ -1205,7 +1206,9 @@ static unsigned int handle_tw_list(struct llist_node *node,
 			ts->locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
 		}
-		req->io_task_work.func(req, ts);
+		INDIRECT_CALL_2(req->io_task_work.func,
+				io_poll_task_func, io_req_rw_complete,
+				req, ts);
 		node = next;
 		count++;
 		if (unlikely(need_resched())) {
@@ -1415,7 +1418,9 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
-		req->io_task_work.func(req, ts);
+		INDIRECT_CALL_2(req->io_task_work.func,
+				io_poll_task_func, io_req_rw_complete,
+				req, ts);
 		ret++;
 		node = next;
 	}
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c90e47dc1e29..9689806d3c16 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -326,7 +326,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 	return IOU_POLL_NO_ACTION;
 }
 
-static void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
+void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	int ret;
 
diff --git a/io_uring/poll.h b/io_uring/poll.h
index b2393b403a2c..ff4d5d753387 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -38,3 +38,5 @@ bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			bool cancel_all);
 
 void io_apoll_cache_free(struct io_cache_entry *entry);
+
+void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3f118ed46e4f..c23d8baf0287 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -283,7 +283,7 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 	return res;
 }
 
-static void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
+void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	io_req_io_end(req);
 
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3b733f4b610a..4b89f9659366 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -22,3 +22,4 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags);
 int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
+void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts);

-- 
Jens Axboe

