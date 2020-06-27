Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8196920C0F1
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 13:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgF0LGt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 07:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgF0LGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 07:06:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C89C03E979
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a6so11896930wrm.4
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oQpUyKwzhFyll4n64/46LXuxst6j/+b4hr4pa9KRvmo=;
        b=Je8gPpdzAllTEEWWtgYd2qVFHcxgbLshSUraJKpUQttutCOhlLyJYCd3da/LsmRl8d
         gi16hvOQSPVDZK4LcEbBcHEBesBoa5W0v4eeEhZK16xAsAmA5dIHrfSIgn4O5QFeFnuT
         6bo3b82nxpJGI1R8e9QKHcp0NKkG3JMIbC882YpFkwSeWhqZmgtzBF5LIaLNN5HYtCoJ
         eQU8YySNLtO0OB/Y+qVbapwdVev3g4xjnUAx5Oz4KRyJb9oJfc8BJtABosawduwrTML3
         OUBjETBcfldf7z7SwEQnHGCQOY49Sp5+P7bKfiwMZYkUwB5BzuwmJJhS0p25Ir+0PMtl
         aodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQpUyKwzhFyll4n64/46LXuxst6j/+b4hr4pa9KRvmo=;
        b=JWaqx36s4BYSXaT632w2jgtflKYsZ9j0sJ6FwYrxzPLraaTQ8zcrl5VNxMsKa2U/hG
         RRRvqYmUaG5MHyG8Ll63HSM5l8oUDGt6vw/Yoa8lVqpgspfstsJyv2YwrsKU6wfogyaS
         ez7vkLM5TPBnTv6KU/1cjPQU0AwX7QeCbfKjxtkzy5vITCrVOIBzryIDI9ewHoxOMzHx
         Zq7y1CMNRHLZSwCdGfPOLX1Ag5frPuv6QC3yJFHArFrznZqAc7Rz9BHNvbTn6yiP4Vck
         q5IC26TorrWDprXuPNtGXZOPyUyytgAmJa1TV07LR+P3nREiPpCpvPNER55oD7HMpvVh
         CX4w==
X-Gm-Message-State: AOAM533YsCtJA9p1+vYvoJZB2b0LD4W9AH1hKHZqsiQ243FYVbtycEqF
        DcQYB3ahhxzyXdSiQD7EYq8=
X-Google-Smtp-Source: ABdhPJxX7jLLlpy1qG6CbHU86K9Z4cLe6kT1OYdMeqDq01toYpYv0yo3UPERhzBsq8TVJO+thROtKQ==
X-Received: by 2002:adf:dd4a:: with SMTP id u10mr8063947wrm.169.1593256007806;
        Sat, 27 Jun 2020 04:06:47 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id x1sm14706721wrp.10.2020.06.27.04.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 04:06:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_ring: fix req->work corruption
Date:   Sat, 27 Jun 2020 14:04:59 +0300
Message-Id: <dcf47f69e4973ac76af8bdbd9aed0892912943d0.1593253742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593253742.git.asml.silence@gmail.com>
References: <cover.1593253742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->work and req->task_work are in union, so io_req_task_queue()
screws everything that was in work. De-union them for now.

[  704.367253] BUG: unable to handle page fault for address:
	ffffffffaf7330d0
[  704.367256] #PF: supervisor write access in kernel mode
[  704.367256] #PF: error_code(0x0003) - permissions violation
[  704.367261] CPU: 6 PID: 1654 Comm: io_wqe_worker-0 Tainted: G
I       5.8.0-rc2-00038-ge28d0bdc4863-dirty #498
[  704.367265] RIP: 0010:_raw_spin_lock+0x1e/0x36
...
[  704.367276]  __alloc_fd+0x35/0x150
[  704.367279]  __get_unused_fd_flags+0x25/0x30
[  704.367280]  io_openat2+0xcb/0x1b0
[  704.367283]  io_issue_sqe+0x36a/0x1320
[  704.367294]  io_wq_submit_work+0x58/0x160
[  704.367295]  io_worker_handle_work+0x2a3/0x430
[  704.367296]  io_wqe_worker+0x2a0/0x350
[  704.367301]  kthread+0x136/0x180
[  704.367304]  ret_from_fork+0x22/0x30

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e2b5f51ebb30..bf236ba10601 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -668,12 +668,12 @@ struct io_kiocb {
 		 * restore the work, if needed.
 		 */
 		struct {
-			struct callback_head	task_work;
 			struct hlist_node	hash_node;
 			struct async_poll	*apoll;
 		};
 		struct io_wq_work	work;
 	};
+	struct callback_head	task_work;
 };
 
 #define IO_IOPOLL_BATCH			8
-- 
2.24.0

