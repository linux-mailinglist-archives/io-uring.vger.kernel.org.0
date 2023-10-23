Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB27A7D3ABF
	for <lists+io-uring@lfdr.de>; Mon, 23 Oct 2023 17:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjJWP3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Oct 2023 11:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjJWP3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Oct 2023 11:29:54 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D6693
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 08:29:51 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7a950f1451fso12920539f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 08:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698074990; x=1698679790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GTpjeYmmQjspavLxQhh6naJ+EzrQNEPzZFeMe4y9aFI=;
        b=eUC6J/FPARr+sL3qX1oPYCOjWv/aTTj2KBRDjVv0I0O4G5EweUtFM/FaqX5gZH2lz0
         slkQUBR3oE9vEocCTX7qhmWLrujtUCbkDTX16M6LkgJCihTsLcIp4Buc8ThN6KLxxEtA
         BBSCkMcWGTOdPNJrMynhVIjBsmfP9tg+WA3ZOPwwzXfYSJLMcC9BUVRfAcQf7afM5DAq
         4FrHkCV6WFP+ep/wRYvZ9FnnWePAKbcEmkSohsJA5oDW4r4oPebJkeBmlNfy4vF2NeJC
         +4z2AW8DEEtsaGx+2pDkPqMbdXU+SG20E790dsf8dmA63AS3+DHOvUvJw68rrDaMXNOg
         N3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074990; x=1698679790;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GTpjeYmmQjspavLxQhh6naJ+EzrQNEPzZFeMe4y9aFI=;
        b=HrLuQrwCpE3n8Ed/bStDBM50g6w9Zpi1HHrjhSFwGEuANJAjLvtkyqo/q1bI4/1ltS
         2AdcIKEUnmTvkF70H2/ccS2cbzYi4jRMqJKvH06S0ubtkiCErGXry2La48iZYygP4zne
         gW6+ssRRLHdX5T89ijsQ5Fd3SPMF386h0gLSbXt+gFhTjtxSZldCZLA2Zkvm1FSKWwBl
         p5WEbCkNp3jb/tDLJ50qBIU8axAzucQAHjlTeYrOSnQAQFgvZd+4kLPoDlPtXwPQVU1l
         z7qOyk7lF6kB9KyTddgNTO4JAHWyOfIVbuKw1nhYyWA5gR2+Ax5r1wpL/rGihFuAAjop
         cszg==
X-Gm-Message-State: AOJu0YwRnbg+ZF065Qj3fIUvlJ1p8dE1WOS8CcCKbklhU/opj+rlKS3f
        xLDTuRSzu4PG5vevR2roORuPjlXGjdY75qXuV4QIaw==
X-Google-Smtp-Source: AGHT+IG0/nd6e1QcRdz23+nXKYnAOlIivUNqZU7AnA2WOO+Ma//2fIqchhxlyOay4cSsJqpobAUF/A==
X-Received: by 2002:a6b:f203:0:b0:792:7c78:55be with SMTP id q3-20020a6bf203000000b007927c7855bemr9875784ioh.0.1698074989459;
        Mon, 23 Oct 2023 08:29:49 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n20-20020a02a914000000b0045c79bb28d6sm2262984jam.114.2023.10.23.08.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 08:29:48 -0700 (PDT)
Message-ID: <04cfb22e-a706-424f-97ba-36421bf0154a@kernel.dk>
Date:   Mon, 23 Oct 2023 09:29:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/fdinfo: park SQ thread while retrieving cpu/pid
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
dereference when the thread is cleared. Grab the SQPOLL data lock before
attempting to get the task cpu and pid for fdinfo, this ensures we have a
stable view of it.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: use the sq_data lock rather than doing a full park/unpark

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index c53678875416..af1bdcc0703e 100644
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
+		mutex_lock(&sq->lock);
+		if (sq->thread) {
+			sq_pid = task_pid_nr(sq->thread);
+			sq_cpu = task_cpu(sq->thread);
+		}
+		mutex_unlock(&sq->lock);
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

