Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A793F41A3
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 23:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhHVVGg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 17:06:36 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:36180 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhHVVGf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 17:06:35 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:52708 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mHufA-0001rP-JR; Sun, 22 Aug 2021 17:05:52 -0400
Date:   Sun, 22 Aug 2021 17:05:51 -0400
Message-Id: <5eee1da51b7aaac3f55d6923e96182012b00deaa.1629655338.git.olivier@trillion01.com>
In-Reply-To: <cover.1629655338.git.olivier@trillion01.com>
References: <cover.1629655338.git.olivier@trillion01.com>
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tracehook: Add a return value to tracehook_notify_signal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The return value indicates if task_work_run has been called.
This knowledge can be of value to the caller. In particular, it allows
io_uring to easily replace calls to io_run_task_work with
tracehook_notify_signal when clearing TIF_NOTIFY_SIGNAL is needed.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 include/linux/tracehook.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 3e80c4bc66f7..1f778ed9c6e2 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -204,12 +204,16 @@ static inline void tracehook_notify_resume(struct pt_regs *regs)
  * is currently used by TWA_SIGNAL based task_work, which requires breaking
  * wait loops to ensure that task_work is noticed and run.
  */
-static inline void tracehook_notify_signal(void)
+static inline bool tracehook_notify_signal(void)
 {
+	bool ret;
+
 	clear_thread_flag(TIF_NOTIFY_SIGNAL);
 	smp_mb__after_atomic();
-	if (current->task_works)
+	ret = current->task_works;
+	if (ret)
 		task_work_run();
+	return ret;
 }
 
 /*
-- 
2.32.0

