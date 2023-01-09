Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7396628FF
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbjAIOvX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjAIOu7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:50:59 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5441A59FB5
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:27 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v10so11611383edi.8
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPPCDXuaEQHmOJtwcbG7jAg/56GzHF5CmEGxm6YsYGM=;
        b=j0N0OuSf1ka7JQt9QlgWNvb1hydBrbC3dD4PsL3Gnf1VO23NF9a2PaWU3IxSGV+f7t
         nokZB2tF9vqLMRi4RgX85Mo4PVQdUaGFuCMxcnqOUAYYM3DhGelvurruzDe+CO6tCbTr
         dVevPYpYGi72bKw5sbdZg407/ChhGxbiaEC3r7OPT1MkYA4H/ENlsTGlBAOf3+SEOcbb
         ZMOALfuyEQ2C5VOiI2KKn5x8W6UG3XlgJCkobY768te8IzrM4MyA2WIZVsz67Anmva+e
         BpKzySq0TvNFGv8QJN5xHIU6MoK8rQ8Dg8AEnJe4H0TFV7I4H57oiqDQcMUs8/dxLWP7
         jQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sPPCDXuaEQHmOJtwcbG7jAg/56GzHF5CmEGxm6YsYGM=;
        b=oZ/kpXPO9dhDmMctuaJiSXGIzd1dxZjYQHu0FYcXMy5yhDlGVWYDsj2GH3wrkH7NAb
         /JXxPem+q/K6L18etv8xb4OVULPYSWMIrZPwqz+W19O4wpK6o09KK3zOsylGCPeftQnK
         if4A7/yaToWIfcTHmoBGAduHcC8pQzQ6hbnQbk5hBNUWs+d3MfBrWAKHvn4GSGR/3m01
         4QEEXn+XcdH9zUkSXcQUw8QkzBRf1f7+6aRZW9mUGciTUbduC3C9/+Nug0TsvkcGVOrq
         T7bB05vI/2p35txm6+/tUiHjEFvHlya6QwbbXuN3SINlwbeHI45NXHaUzqJ5U1W5FA/5
         xb9w==
X-Gm-Message-State: AFqh2kr7tqgyTeRjIXfwm6P43ZsAw6Ck3S+ZsB3uEANKQgemey0HX2ay
        lbjotibK+1riXNi+oQxME0b1ulkCL9w=
X-Google-Smtp-Source: AMrXdXuWXC0FrYVMsEcpvS3ydVPdFihUCgPOP/ZxH3n94ZIr8LmWbNtJEhd5Ml4k1+xafEsmQ6DD9g==
X-Received: by 2002:a05:6402:e83:b0:45c:a5f2:ffea with SMTP id h3-20020a0564020e8300b0045ca5f2ffeamr77914448eda.7.1673275645536;
        Mon, 09 Jan 2023 06:47:25 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 01/11] io_uring: move submitter_task out of cold cacheline
Date:   Mon,  9 Jan 2023 14:46:03 +0000
Message-Id: <415ca91dc5ad1dec612b892e489cda98e1069542.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
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

->submitter_task is used somewhat more frequent now than before, i.e.
for local tw enqueue and run, let's move it from the end of ctx, which
is full of cold data, to the first cacheline with mostly constants.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 128a67a40065..8dfb6c4a35d9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -195,11 +195,7 @@ struct io_alloc_cache {
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
-		struct percpu_ref	refs;
-
-		struct io_rings		*rings;
 		unsigned int		flags;
-		enum task_work_notify_mode	notify_method;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		restricted: 1;
@@ -210,6 +206,11 @@ struct io_ring_ctx {
 		unsigned int		syscall_iopoll: 1;
 		/* all CQEs should be posted only by the submitter task */
 		unsigned int		task_complete: 1;
+
+		enum task_work_notify_mode	notify_method;
+		struct io_rings			*rings;
+		struct task_struct		*submitter_task;
+		struct percpu_ref		refs;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -320,7 +321,6 @@ struct io_ring_ctx {
 	/* Keep this last, we don't need it for the fast path */
 
 	struct io_restriction		restrictions;
-	struct task_struct		*submitter_task;
 
 	/* slow path rsrc auxilary data, used by update/register */
 	struct io_rsrc_node		*rsrc_backup_node;
-- 
2.38.1

