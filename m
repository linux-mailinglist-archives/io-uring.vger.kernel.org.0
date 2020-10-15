Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D2828FA84
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 23:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732806AbgJOVO3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 17:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbgJOVO3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 17:14:29 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E08C061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a72so377533wme.5
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SVqJnpPjUA1wp2GbkJKKI3KuW6Epps9xgSflDtkgEZU=;
        b=fj1XUTmY9S/OhM8L84uqM5ehlE4ja+2ct545d2+RIug1PK4Lkoi6amsKBJL9cI6Sj0
         0WGeFBLqZxQWNPLs5385sRomoLbXV8OpfuiMvI52NRphmTeqCdb2STXzFA7S03SSWK9k
         t/XAAPeScbaOg05LNIQP44v02RNXuZN9U9UuepOUe9GB3mTPnOJsUEj/XZ90rYYk2r1+
         ZcyebDQyKMuvblB10s5knfUVGN1C3KGmT6qkw39/GdHfVeBeIanwugknqEvy2pRFiCHE
         blftuXykpLJuaGE35Alb47IImPZE99YSYec0fDaB5GK5NBNX9EHjX7Pl1fR9bGTCGbJ0
         fU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SVqJnpPjUA1wp2GbkJKKI3KuW6Epps9xgSflDtkgEZU=;
        b=mB/Th4A3to/28f/j7Bp2roZjeZGDfdOQdRlvTmZxnWONrYk/MU+p7GizZ9LwSb2whi
         UUIVjZt+zyEz6z5psFTBhDRLNH5tvSs1DE5XRVmQt11ZYmzSjP88VnEihzRXecHZKHuo
         +5rIFFkm05DaEn9rkdL3UE36kEj+lrtMiaBOciVvdF+/Rjz170ebc3q8svbh8DHVjCRA
         SdPRBEzPEFle6eoyLE5yNsq9N+RTtr5S7urhP5U9mLvRkUTGmKH22t+NvDDO5SQbaOhY
         b6iMKOB9YX3VitAQA6CdEVAHs97uIWqXi+tEGqht6k1tvDfWGKJ4HstQ1q8Ypi2mKhzH
         ukLQ==
X-Gm-Message-State: AOAM5311DrUlCcPDLWMCuV2K+ToMUzTYA3UTDvr3zPkWr0YWsC0Er/0o
        aiEIYm/iDBTifCY0O/zd27k=
X-Google-Smtp-Source: ABdhPJw/o2/UOV610C3j3l+XPPca6661uKrOwVn6ZObotJkVp0vA/FQoAfCuXFNH8CaoByxXTQnonw==
X-Received: by 2002:a1c:9952:: with SMTP id b79mr570527wme.144.1602796468181;
        Thu, 15 Oct 2020 14:14:28 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x3sm320865wmi.45.2020.10.15.14.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 14:14:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: toss io_kiocb fields for better caching
Date:   Thu, 15 Oct 2020 22:11:24 +0100
Message-Id: <bb960925b9fba8a23c86ddaf7c52ff91288afc49.1602795685.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602795685.git.asml.silence@gmail.com>
References: <cover.1602795685.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We've got extra 8 bytes in the 2nd cacheline, put ->fixed_file_refs
there, so inline execution path mostly doesn't touch the 3rd cacheline
for fixed_file requests as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fd5360a238a7..f3f4cb538d43 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -675,14 +675,13 @@ struct io_kiocb {
 	u64				user_data;
 
 	struct io_kiocb			*link;
+	struct percpu_ref		*fixed_file_refs;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
 	 * 2. to track reqs with ->files (see io_op_def::file_table)
 	 */
 	struct list_head		inflight_entry;
-
-	struct percpu_ref		*fixed_file_refs;
 	struct callback_head		task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
-- 
2.24.0

