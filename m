Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415D64E6A90
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 23:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345905AbiCXWTN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 18:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiCXWTM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 18:19:12 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BD2A0BF8
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 15:17:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w4so6195194ply.13
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 15:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=iPS/F09BxMEvQU1Mfgn0jDBPJkXsNdfenSHWejqQS0o=;
        b=ar9XHEq8gQA++WWwz+LN0f8ap8zbAVsa1UrCeKUngKjjJqnI63AerrkD7ARKwFKEdQ
         RGSJAEjyOlLScyCOa/ZNRVjsdILYOV1UTdjo5zgMqK4lPzb3ckAYUkJDXQ7qNoHl7lr2
         oqWrQUr4Wm2YDW1X3FkKguzPnWAVhnMZkOvwUik/fUAwTsoqQW8Dek7UjcZVEhpGWY2n
         mLu0v/OZEAVUfLPqImzQsxRCmlWRtRLS0pnqTXjaQRWq9eovOkcv+6dESU8Cl2208OGF
         dxP/nLJPSdEEYXOzhSCDmf2GCzils2wh40sJoIQiZpD9n0N8EMOZ7dyD5RhB7rDC4/qq
         anFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=iPS/F09BxMEvQU1Mfgn0jDBPJkXsNdfenSHWejqQS0o=;
        b=RCZpQj3LTk4qkXh7QOXVTDTzQ3YD0E6hWz+Netch4y/+6eOyasB1LFOGMMCN1l5GkR
         0GhzMxPl7Rm2YiSciVSkEf6LLLEaLHgBZXTqVhYsHVBDA2LLfwBJPuQnfTUwlRiCm6b7
         2elc4E9USv7VC0Kszf3TErkVrroKwRVQgzEKgx68bIMywzivWf4bim2iEEJuHf88//ra
         cRBFay3NQeMoAewIqqDgKF7Y9mQGslBAT7l4MNOqoDlzPzwq7hLcvC0rlSVc8LTpwQKL
         j1FGN67ZWbdJ44y7ehnIit+TpbTzYXqr5/yBMz2MLfVvafC75ejOAC5+Avf55NgWobrV
         WFyQ==
X-Gm-Message-State: AOAM533iSLWs/Kj6GTubWaiHWSYSX8WH5xhRGcAn0En9a+tUNyd9umfH
        l5HaD3WNg2YvgL4DAUQat8G7HhPTO0HviQ==
X-Google-Smtp-Source: ABdhPJzNsWVAO4buub2syYDeyJcBQDONPkzHHzus0FT0L7F2t/lwc5GueWoJXy3RT8sTYEGeOGfAhg==
X-Received: by 2002:a17:902:650e:b0:153:99d4:9151 with SMTP id b14-20020a170902650e00b0015399d49151mr8340269plk.20.1648160259282;
        Thu, 24 Mar 2022 15:17:39 -0700 (PDT)
Received: from ?IPV6:2600:380:6c11:f710:ef38:7e8d:293e:e1c5? ([2600:380:6c11:f710:ef38:7e8d:293e:e1c5])
        by smtp.gmail.com with ESMTPSA id f66-20020a62db45000000b004fa8a7b8ad3sm4268509pfg.77.2022.03.24.15.17.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 15:17:38 -0700 (PDT)
Message-ID: <994f54a5-9124-f970-f663-2cf19ab076ae@kernel.dk>
Date:   Thu, 24 Mar 2022 16:17:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: improve task work cache utilization
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While profiling task_work intensive workloads, I noticed that most of
the time in tctx_task_work() is spending stalled on loading 'req'. This
is one of the unfortunate side effects of using linked lists,
particularly when they end up being passe around.

Prefetch the next request, if there is one. There's a sufficient amount
of work in between that this makes it available for the next loop.

While fiddling with the cache layout, move the link outside of the
hot completion cacheline. It's rarely used in hot workloads, so better
to bring in kbuf which is used for networked loads with provided buffers.

This reduces tctx_task_work() overhead from ~3% to 1-1.5% in my testing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2 - it's better to not move io_task_work, as it then moves both fixed
buffers and file refs to the next cacheline. Instead, just prefetch
the right cacheline instead. Move link as well, which brings kbuf into
where it should be.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a76e91fe277c..37150ca89289 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -928,7 +928,6 @@ struct io_kiocb {
 	struct io_wq_work_node		comp_list;
 	atomic_t			refs;
 	atomic_t			poll_refs;
-	struct io_kiocb			*link;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
@@ -939,6 +938,7 @@ struct io_kiocb {
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
+	struct io_kiocb			*link;
 	const struct cred		*creds;
 	struct io_wq_work		work;
 };
@@ -2450,6 +2450,11 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 		struct io_wq_work_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
+		struct io_kiocb *nxt = container_of(next, struct io_kiocb,
+						    io_task_work.node);
+
+		if (next)
+			prefetch(nxt);
 
 		if (req->ctx != *ctx) {
 			if (unlikely(!*uring_locked && *ctx))
@@ -2482,6 +2487,11 @@ static void handle_tw_list(struct io_wq_work_node *node,
 		struct io_wq_work_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
+		struct io_kiocb *nxt = container_of(next, struct io_kiocb,
+						    io_task_work.node);
+
+		if (next)
+			prefetch(nxt);
 
 		if (req->ctx != *ctx) {
 			ctx_flush_and_put(*ctx, locked);

-- 
Jens Axboe

