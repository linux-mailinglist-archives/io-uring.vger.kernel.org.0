Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F463D952
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiK3PXa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiK3PX2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:28 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E9B769E6
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:26 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h11so20345281wrw.13
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zLXpILH9PcccMmd6KkcbcpMJ63pfhz2reMG+GunS118=;
        b=Sx5AMy3L8jxqD5t1jZt+qxpaWUUji45LC5pgWQTC7q9xi0IR+kefFApl4Uakl9PwBJ
         0JsP4DjrEFQn9SYzP9oILju1lJvoxAs94Huo91QqKuWDuiSqxKElxyuyiUPtXknUIntn
         U04aImEuKHc35sM+GhS/mmYuZrz5yDlkv9/gMW+ImJN2tE1jf3QZtS0gL4vNOVYxjKgq
         ztgyqgxZFTzrhoNbld/rparfz/S/jwXBaI6Y1uQgpNWLgAyvom6LPEcj+XvXQqqu/zhr
         Z9D3c7+oWLOi8N5grng8LvILFFEyHyxPoXZvcf69JuFoXnbgJlwLc0VPvICyINpEq6F6
         3VwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zLXpILH9PcccMmd6KkcbcpMJ63pfhz2reMG+GunS118=;
        b=D9bMgPeWb09rhEOaRyrBn6E8xKFzb9xjsqsbCXkHrh+6Pf/rkG0UBilIpVrzzYZMw8
         6GN9u+uEl1L4QsHGf+JZJ/o6/iQ0hcvBjnxuFAr/yHVTkKEwMqKtoEPSku3jW35fl3SR
         I3RSW1xCUGPbZwhcFSto6TIyQ2VV17ej+GqnAABjgy8x1HNs+AlqBPXR7s2oEVdcn8js
         oBRvuCekzRyi5sbw0U60vwK0JoS17q8PBJkY4Jdso0w61cL760d+cHkcxOGEpLOz9LmY
         JQtGfPPoP6KjY6WeD8eHE9nKFosKIIYK2c2k5mxR/U54c4o0e000Fr2e792AFzcYDvQJ
         HYzw==
X-Gm-Message-State: ANoB5pk6/i83B3pmIaNlu2mJOSHrnBlJdYjM/raN8upGc8F1HL8VBJkY
        K4Kbaq5B4aUI6C9TjhpY7yCrvjMogHI=
X-Google-Smtp-Source: AA0mqf7B0HYPbJlgTTU8SbCgxD6taAwV92D36eseT5V+Z4RfKiHghX+2Fkh4Vsh2bLD3g9LQIKAqaw==
X-Received: by 2002:a5d:464c:0:b0:242:2ac1:375 with SMTP id j12-20020a5d464c000000b002422ac10375mr2388381wrs.432.1669821804950;
        Wed, 30 Nov 2022 07:23:24 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/9] io_uring: combine poll tw handlers
Date:   Wed, 30 Nov 2022 15:21:55 +0000
Message-Id: <482e59edb9fc81bd275fdbf486837330fb27120a.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge apoll and regular poll tw handlers, it will help with inlining.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 54 +++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8f16d2a48ff8..ee7da6150ec4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -321,50 +321,38 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	ret = io_poll_check_events(req, locked);
 	if (ret == IOU_POLL_NO_ACTION)
 		return;
-
-	if (ret == IOU_POLL_DONE) {
-		struct io_poll *poll = io_kiocb_to_cmd(req, struct io_poll);
-		req->cqe.res = mangle_poll(req->cqe.res & poll->events);
-	} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
-		req->cqe.res = ret;
-		req_set_fail(req);
-	}
-
 	io_poll_remove_entries(req);
 	io_poll_tw_hash_eject(req, locked);
 
-	io_req_set_res(req, req->cqe.res, 0);
-	io_req_task_complete(req, locked);
-}
+	if (req->opcode == IORING_OP_POLL_ADD) {
+		if (ret == IOU_POLL_DONE) {
+			struct io_poll *poll;
 
-static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
-{
-	int ret;
-
-	ret = io_poll_check_events(req, locked);
-	if (ret == IOU_POLL_NO_ACTION)
-		return;
-
-	io_tw_lock(req->ctx, locked);
-	io_poll_remove_entries(req);
-	io_poll_tw_hash_eject(req, locked);
+			poll = io_kiocb_to_cmd(req, struct io_poll);
+			req->cqe.res = mangle_poll(req->cqe.res & poll->events);
+		} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
+			req->cqe.res = ret;
+			req_set_fail(req);
+		}
 
-	if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
+		io_req_set_res(req, req->cqe.res, 0);
 		io_req_task_complete(req, locked);
-	else if (ret == IOU_POLL_DONE)
-		io_req_task_submit(req, locked);
-	else
-		io_req_defer_failed(req, ret);
+	} else {
+		io_tw_lock(req->ctx, locked);
+
+		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
+			io_req_task_complete(req, locked);
+		else if (ret == IOU_POLL_DONE)
+			io_req_task_submit(req, locked);
+		else
+			io_req_defer_failed(req, ret);
+	}
 }
 
 static void __io_poll_execute(struct io_kiocb *req, int mask)
 {
 	io_req_set_res(req, mask, 0);
-
-	if (req->opcode == IORING_OP_POLL_ADD)
-		req->io_task_work.func = io_poll_task_func;
-	else
-		req->io_task_work.func = io_apoll_task_func;
+	req->io_task_work.func = io_poll_task_func;
 
 	trace_io_uring_task_add(req, mask);
 	io_req_task_work_add(req);
-- 
2.38.1

