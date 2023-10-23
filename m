Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905E27D27B7
	for <lists+io-uring@lfdr.de>; Mon, 23 Oct 2023 02:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjJWAyc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Oct 2023 20:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJWAyc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Oct 2023 20:54:32 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F4AB7
        for <io-uring@vger.kernel.org>; Sun, 22 Oct 2023 17:54:29 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-7b5f1a6267bso181921241.1
        for <io-uring@vger.kernel.org>; Sun, 22 Oct 2023 17:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698022468; x=1698627268; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsslYOka4dg7q6DuaUTenw8f3cz+l7QP9kA0WS8X1SI=;
        b=KsUxTieznI8l79434ReN8QxZyfakC6tGDElKkfDzTC40ho5knqDNLrkMY2V/XkwhAv
         cUC2JleJ5Pq6oJuptty0giNtjcSbB2vl/BKa7vv5paYJrxHW2XK/Ve0HCtI27XWn7rnY
         i9CfVS63/l1q/BbiqdhTn9yVlecsbmq1O1YTC8eXLkkn7OUel1+xHJeaD3IBXSzcsXIj
         rrk9OkHieh+wPmpRFfozuwwdPf59krhpdb6mQZhxCoop+gua26cv+AAiR10nyAegFL/g
         Cm6j5X9f6SmWRro2DLeY9tQ5dZSHYxHo6wKEAHvDn5yVFUDGXv5FJ5OR4R5xLXIvLYXH
         8SYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698022468; x=1698627268;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hsslYOka4dg7q6DuaUTenw8f3cz+l7QP9kA0WS8X1SI=;
        b=chW4unFGu0qd+FDRDdCfYDsqZfWwDVsVYWbnqyC8BtnddVg19Q5c1zCyj2ihrudOGj
         U+JMYZPlMxshX8M8+BEW5tVpS/XwzT23gUaGT3rqZBShjByP6EpTD++5VdTPO1VJIs1R
         oPvBn9L2FQ4Ege9AC1SqFf5Op6QV9aFZOIoR3Dch7sYfeATKETr8PHCOUqqTP+PqKMiV
         cg3eqDvTixmtdRIS8vkkIidE0zRmGRWHEMbmpvCNehrNO/3XCrpqTE6U5rxatMBcLLJj
         ATdKeMnnZaW1gk0qDmD7hK+X/q5GVwviyaaHQAijjfnnfjw1rbKVO/F3eC1MaXLhRbuA
         gsaQ==
X-Gm-Message-State: AOJu0Yzd2K/6EIz3jV619b7jtxXQhjUBUJgNIqnVTTKzwnpOcxAEsR7w
        hVtB91gy9oX2pkIbFUULSTiAryHS6kXe2pjuXdcjDQ==
X-Google-Smtp-Source: AGHT+IGU2yV+iIKftPRG5fqLQ1aMnF6IkquA7w7U5zCL5YTOhqnCY2U4JTPqda4XptBUvC/NRdS3wA==
X-Received: by 2002:a67:fe89:0:b0:457:c159:9675 with SMTP id b9-20020a67fe89000000b00457c1599675mr3168547vsr.1.1698022467953;
        Sun, 22 Oct 2023 17:54:27 -0700 (PDT)
Received: from [172.19.131.149] ([164.86.4.149])
        by smtp.gmail.com with ESMTPSA id b4-20020a67f844000000b0045272462f7dsm728449vsp.26.2023.10.22.17.54.25
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Oct 2023 17:54:27 -0700 (PDT)
Message-ID: <64f28d0f-b2b9-4ff4-8e2f-efdf1c63d3d4@kernel.dk>
Date:   Sun, 22 Oct 2023 18:54:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/fdinfo: park SQ thread while retrieving cpu/pid
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
dereference. Park the SQPOLL thread while getting the task cpu and pid for
fdinfo, this ensures we have a stable view of it.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index c53678875416..cd2a0c6b97c4 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -53,7 +53,6 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
 __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 {
 	struct io_ring_ctx *ctx = f->private_data;
-	struct io_sq_data *sq = NULL;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
@@ -64,6 +63,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int cq_shift = 0;
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
+	int sq_pid = -1, sq_cpu = -1;
 	bool has_lock;
 	unsigned int i;
 
@@ -143,13 +143,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	has_lock = mutex_trylock(&ctx->uring_lock);
 
 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
-		sq = ctx->sq_data;
-		if (!sq->thread)
-			sq = NULL;
+		struct io_sq_data *sq = ctx->sq_data;
+
+		io_sq_thread_park(sq);
+		if (sq->thread) {
+			sq_pid = task_pid_nr(sq->thread);
+			sq_cpu = task_cpu(sq->thread);
+		}
+		io_sq_thread_unpark(sq);
 	}
 
-	seq_printf(m, "SqThread:\t%d\n", sq ? task_pid_nr(sq->thread) : -1);
-	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
+	seq_printf(m, "SqThread:\t%d\n", sq_pid);
+	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);

-- 
Jens Axboe

