Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3C9156BBB
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBIRMe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:12:34 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41482 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbgBIRMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:12:33 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so1826744plr.8
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3MppnTrhUTtU7DiBxrfsQX3Pwckxck7GfWkr9i0Ro8=;
        b=DkupJ/mH5JqvesuWmpT+CzbNtf0cc7VYmfwMg06Dop2GEeVpQbHOZEY22yCmEC5i6Y
         Po3xycWsbn4VdtZpPc47p/Zlqgsp8Yy+47eHW0GewWgHLsQs0WmQrHHiqTUBRlvpG7S4
         8l6lUt+EkHNNRtAjGqsn3Mbo5qv/Lpjs4fIZlnweYmmpufwu30dt+FVfB4hLeUUGogFB
         hMdWftokcDXUOIpzj/STeNM9Bio2O/R7qYrXGfFA9qpnaEWPuWTfnIEZj62ktm8PF9BE
         yJThib0dLwifrjdLeUf0kPMHuRhxeW+tjNcm3+fMmIrqXasnKwCdR2Bvnd1FmhbGO6lZ
         1ObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3MppnTrhUTtU7DiBxrfsQX3Pwckxck7GfWkr9i0Ro8=;
        b=m+bBEQYrWG60ulLUn+A9I4sXDTZPLMmQVxwnlYdutXSl+L7dAXX8ymH39wm9aJsxev
         4ldt2VGFixKZk2HMsjKLLZlL5eh9XgeAtLGtNuFUMG18pEJhOrwgcelTJsEGtcg7HKss
         iaB87zRnb5VJCjeUlN7S5koKV83fIMhhbl9jmbepGPSkw3SrxfA3S45rz6SjPrap0KpP
         VaPyMUVCwdXoyb7vBOUq+s9IVK/KJoygKTLpW2HdhETe3+CgcsTsUIYTNY1b0c706bZT
         yrohQ/YlWSMgCh/YrinEMWnq+7QOwMCckxcJnjpKppvEeLkO8tqn50Z1Gfo2cYegvWQk
         gLbg==
X-Gm-Message-State: APjAAAXFjw14IzfrSdScPz8TbBZVOjM0GeTnbVJKwwgfJaGM1ZcIM4ft
        bsp6Lom+Gx9DB1xd0rLVlKZokALhDNo=
X-Google-Smtp-Source: APXvYqxIoC+w3qWTnUxojeeXbufX8wu+3Qig8aX88jVbbwV04lpAiNwH+5UnsxpEXSLgoBVFuZbgRg==
X-Received: by 2002:a17:90a:8a96:: with SMTP id x22mr15610820pjn.139.1581268352874;
        Sun, 09 Feb 2020 09:12:32 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z29sm9869695pgc.21.2020.02.09.09.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:12:32 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io-wq: add io_wq_cancel_pid() to cancel based on a specific pid
Date:   Sun,  9 Feb 2020 10:12:22 -0700
Message-Id: <20200209171223.14422-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209171223.14422-1-axboe@kernel.dk>
References: <20200209171223.14422-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper that allows the caller to cancel work based on what mm
it belongs to. This allows io_uring to cancel work from a given
task or thread when it exits.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 29 +++++++++++++++++++++++++++++
 fs/io-wq.h |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4889b42308ac..9317c1a075eb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1032,6 +1032,35 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 	return ret;
 }
 
+static bool io_wq_pid_match(struct io_wq_work *work, void *data)
+{
+	pid_t pid = (pid_t) (unsigned long) data;
+
+	if (work)
+		return work->task_pid == pid;
+	return false;
+}
+
+enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
+{
+	struct work_match match = {
+		.fn	= io_wq_pid_match,
+		.data	= (void *) (unsigned long) pid
+	};
+	enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
+	int node;
+
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		ret = io_wqe_cancel_work(wqe, &match);
+		if (ret != IO_WQ_CANCEL_NOTFOUND)
+			break;
+	}
+
+	return ret;
+}
+
 struct io_wq_flush_data {
 	struct io_wq_work work;
 	struct completion done;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index f152ba677d8f..ccc7d84af57d 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -76,6 +76,7 @@ struct io_wq_work {
 	const struct cred *creds;
 	struct fs_struct *fs;
 	unsigned flags;
+	pid_t task_pid;
 };
 
 #define INIT_IO_WORK(work, _func)			\
@@ -109,6 +110,7 @@ void io_wq_flush(struct io_wq *wq);
 
 void io_wq_cancel_all(struct io_wq *wq);
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
+enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid);
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
-- 
2.25.0

