Return-Path: <io-uring+bounces-7439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5531EA8266C
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C38E97AA051
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B264F158218;
	Wed,  9 Apr 2025 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bG028Wew"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E27125B66B
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206065; cv=none; b=G9mlL6LUE/q2Ins0hRMB75WJdIzJVNz70yCx1cUwY7xRCjYOxMZz1DlWZIcFfHF9XhK+ypzpKBMDzpyK3Uakx+wZ37ZJXoa48Yww2ibPWBstZj9CMXHDMfSUVA64df6hQkpagaACtpE4OIZzYoom2fxmT3yRQcrD1+xBXh7ovSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206065; c=relaxed/simple;
	bh=uMvf7J0yA0zoR+hLE+IY57ndO65Ys2suG5b3TYxY7MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra8zfHDEDICKGxtMYJSHCDn0OXD3hdCZyJjkG0Qf4WRlgAXkx9TdwuSIftOToylQuDlBqmIbcSIIE7l1iy1hmKAVEvUvMOy6vy0/e0uSC02Tx2jaEjsBP82M31uCsFPH6nbF2NWed2eAehXV+vVVHiG5kCQiULEzdYuD3Yylz+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bG028Wew; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85de3e8d0adso113727239f.1
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744206062; x=1744810862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXFsFKc6RLbz870fPz68WCkkTLZUZDUmKqEm4G95Sm8=;
        b=bG028WewEYMgdxx5e5GWYmKSjBOkr+TAVNUTqXDYY79nADAEcdbV/jNyr6fCo6yw3q
         XK5BUjhRu7tEp1NToTAWUYiBvjghjL10Yo2qiR4w106frdBXCxC5EmCnAR85YRSJn7Oj
         dk9snHfEq9Hb61n97rg2yjBudONREjtAXiCfdiJgIqD3R3yP7oXVrO+YJs4bPueahqiX
         46nJSqdV4cGJL9atC4wD7L5NZrImfFo68OvYR8DHu0A/joSMYw5Tgn7vbILgQswPUCyw
         U9KatCa7RMoEwvbTCoO2N+hZw+e9k9tgmG7u5LYknWX/eOrfRk2FyrKQY08Hw8tkh5Cz
         Qmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206062; x=1744810862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXFsFKc6RLbz870fPz68WCkkTLZUZDUmKqEm4G95Sm8=;
        b=KII3hGCBm/l0vAZIPLKH5/q0atfjz61IRXaE9BXxXo8mZGGQxrD+Ue+Hqa1cJoEDdA
         Md55qi5opMQCQt+BkoOlp3TbRplgsJVn5edmKPY6g9/Fw6l98N/whQtL5Jcp7gS5R8GP
         FhpUwPegjzCeQWhIEVTnbqQs+dLVxLMgfAf5eN/SHvPWfCh5AS44sZyosvr6dic1MwJb
         D7QWvuY9fS9dITzDsmLnlYug8vzRfyqEBXRJiMMLLWMsg4tb4eMdNzNh8J/qO7UrYph0
         KpKWPLRcG+DkPS5RX/fFDC5bi7Y9CyxjF6+LOizmdZpWrJrHIA3Wbuy9RaNKu0OOWwdY
         mlkg==
X-Gm-Message-State: AOJu0YyuGEjGZCa2ahwkcy3XMz5rvr/0nN+Oqdhk5sfpcEaW6qPr8ZiE
	H4EqOa7K3Q7CTwkgc2HOFgQwc847doPtOmRxEyDOVFZcqu2V2/n8mgyKBNDVMZMtTcxKgi60fBX
	S
X-Gm-Gg: ASbGncvsHHeWoMRpueUf1ADyOOX0iDhlOJuqvaspkNR/qR5Yn8UdJhVdPQsxFO2fQ1h
	LNvxk4pT7peudoGcae8pi9p8f6sOTltLbWE7iPvfDbQ8o5TjZq31zFULQysgbQv3MXilohHYxK5
	Pj3qKPzacnRt6PnSOHbED25Bk4Z3x88cy2XOqyUi4ELV/o/h5tdi0xuvyVD9QRa61GtvwD+8DmG
	MlNjBUR9Y+GClO+7P8MK6KX44IHqs+d1s1wEgEQVIbVxa9PXDyFeqhk33IqonDDcwja5XTgV5Eb
	FQ3QjvHDXrUWFE3B069kqno6upkXXPTnCRQQ+fbtHbk4
X-Google-Smtp-Source: AGHT+IGJOKrUGTPRqWp38V120QN16hyhDxK5MbK9+bzXZMD1BHY+Kn7YwvCC+ACxPMhmP7gQlFpW8g==
X-Received: by 2002:a05:6e02:1a6a:b0:3d6:d3f7:8826 with SMTP id e9e14a558f8ab-3d7bda45167mr22384555ab.20.1744206061378;
        Wed, 09 Apr 2025 06:41:01 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm242546173.126.2025.04.09.06.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 06:41:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	brauner@kernel.org,
	linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
Date: Wed,  9 Apr 2025 07:35:19 -0600
Message-ID: <20250409134057.198671-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250409134057.198671-1-axboe@kernel.dk>
References: <20250409134057.198671-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fput currently gates whether or not a task can run task_work on the
PF_KTHREAD flag, which excludes kernel threads as they don't usually run
task_work as they never exit to userspace. This punts the final fput
done from a kthread to a delayed work item instead of using task_work.

It's perfectly viable to have the final fput done by the kthread itself,
as long as it will actually run the task_work. Add a PF_NO_TASKWORK flag
which is set by default by a kernel thread, and gate the task_work fput
on that instead. This enables a kernel thread to clear this flag
temporarily while putting files, as long as it runs its task_work
manually.

This enables users like io_uring to ensure that when the final fput of a
file is done as part of ring teardown to run the local task_work and
hence know that all files have been properly put, without needing to
resort to workqueue flushing tricks which can deadlock.

No functional changes in this patch.

Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/file_table.c       | 2 +-
 include/linux/sched.h | 2 +-
 kernel/fork.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index c04ed94cdc4b..e3c3dd1b820d 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -521,7 +521,7 @@ static void __fput_deferred(struct file *file)
 		return;
 	}
 
-	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
+	if (likely(!in_interrupt() && !(task->flags & PF_NO_TASKWORK))) {
 		init_task_work(&file->f_task_work, ____fput);
 		if (!task_work_add(task, &file->f_task_work, TWA_RESUME))
 			return;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f96ac1982893..349c993fc32b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1736,7 +1736,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_NO_TASKWORK		0x00800000	/* task doesn't run task_work */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
diff --git a/kernel/fork.c b/kernel/fork.c
index c4b26cd8998b..8dd0b8a5348d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2261,7 +2261,7 @@ __latent_entropy struct task_struct *copy_process(
 		goto fork_out;
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
-		p->flags |= PF_KTHREAD;
+		p->flags |= PF_KTHREAD | PF_NO_TASKWORK;
 	if (args->user_worker) {
 		/*
 		 * Mark us a user worker, and block any signal that isn't
-- 
2.49.0


