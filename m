Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9E234971F
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 17:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhCYQoI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 12:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhCYQnu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 12:43:50 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A68BC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 09:43:50 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w2so2194468ilj.12
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 09:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3dp61o6F3hqxMbMpN9J8E9x3tY2eyW4PS/mGGFHMbvA=;
        b=dL5jZOqPFrSb9Oj9FLfuY4FAbj8v8dXvuyG1H2e2jy3Epf4WMDngkcwDf/GDjlEqeq
         BrT84yl0cCzQQtqcUYiiHF2mqWSmtBlESC8TaZVNXe9NVGAmtX1BUNN34UteLmwJjpxd
         oP7QA1j9pguI2UI7+D2a2TlQdw6w4W5mtttT6msMI18lLSMJ2sIn82ljFY2WUl1gXofE
         frs1SpctbE0XjMIttEzkYHfXcAe3TP/TAWqtkuzcSHv5xqisOJrHMqxapB68t+Wa2dmS
         CiO/0mZRvRqi1VPXqAVC9QQC3KDZfK2HJFAadvP1QHURIKQzUFV1koVsYPBLFHSmAZLo
         xjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3dp61o6F3hqxMbMpN9J8E9x3tY2eyW4PS/mGGFHMbvA=;
        b=HuoEOECmV+wpy2TLe5mkeiw87X2661Rpr+21n4cFlNihEC2Q9Sact0tbJ8EHwRwu6x
         vmYL86jclgbeyYt/zG6NTEOmqZpr2txE0ifvN/JoMocUJvCN1DfweYrUv62vhx9Gm2s+
         39LgFXEkIyPjZ+d7ht0XQDPl4AUE1kA59uQsl9lgAAlcqBeZAFYqJhfxxnT13YRF0JHZ
         fdlbcdrmB4VWnzkvr6+4bREwsIQ83bZ8owkuqk9pxL53CvJF4pHiBdWd2oBuZlP/tzHk
         QSZGMRQ+YyP2KW8J2ngeHOxndraAAPAf604Zc+xiyHlhBdMYlYbKdiKZM0ZOSbqN9Jl+
         3Etw==
X-Gm-Message-State: AOAM530s4FuJrXn78i8/d1DJrqzc+5KHZ1EnHomoy9Xm4JtN+CnpJ5fD
        gShy6LKtgNR6v26oAHtZUXS36KNGVWNFSQ==
X-Google-Smtp-Source: ABdhPJxwxYjP5S4lA8SJOW+4pNwM6kgk9NMYjp4EfBYFflCceicfN5WxY49qjwu9LCrK/G/hMq9KVQ==
X-Received: by 2002:a05:6e02:1b86:: with SMTP id h6mr7051197ili.145.1616690629868;
        Thu, 25 Mar 2021 09:43:49 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k12sm2990605ios.2.2021.03.25.09.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:43:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] proc: don't show PF_IO_WORKER threads as threads in /proc/<pid>/task/
Date:   Thu, 25 Mar 2021 10:43:43 -0600
Message-Id: <20210325164343.807498-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325164343.807498-1-axboe@kernel.dk>
References: <20210325164343.807498-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't allow SIGSTOP and ptrace attach to these threads, and that
confuses applications like gdb that assume they can attach to any thread
listed in /proc/<pid>/task/. gdb then enters an infinite loop of retrying
attach, even though it fails with the same error (-EPERM) every time.

Skip over PF_IO_WORKER threads in the proc task setup. We can't just
terminate the when we find a PF_IO_WORKER thread, as there's no real
ordering here. It's perfectly feasible to have the first thread be an
IO worker, and then a real thread after that. Hence just implement the
skip.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/proc/base.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3851bfcdba56..abff2fe10bfa 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3723,7 +3723,7 @@ static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
 	 */
 	pos = task = task->group_leader;
 	do {
-		if (!nr--)
+		if (same_thread_group(task, pos) && !nr--)
 			goto found;
 	} while_each_thread(task, pos);
 fail:
@@ -3744,16 +3744,22 @@ static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
  */
 static struct task_struct *next_tid(struct task_struct *start)
 {
-	struct task_struct *pos = NULL;
+	struct task_struct *tmp, *pos = NULL;
+
 	rcu_read_lock();
-	if (pid_alive(start)) {
-		pos = next_thread(start);
-		if (thread_group_leader(pos))
-			pos = NULL;
-		else
-			get_task_struct(pos);
+	if (!pid_alive(start))
+		goto no_thread;
+	list_for_each_entry_rcu(tmp, &start->thread_group, thread_group) {
+		if (!thread_group_leader(tmp) && same_thread_group(start, tmp)) {
+			get_task_struct(tmp);
+			pos = tmp;
+			break;
+		}
 	}
+no_thread:
 	rcu_read_unlock();
+	if (!pos)
+		return NULL;
 	put_task_struct(start);
 	return pos;
 }
-- 
2.31.0

