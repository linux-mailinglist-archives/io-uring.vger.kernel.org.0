Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074014E66D7
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 17:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345560AbiCXQTV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238822AbiCXQTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 12:19:20 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA652FE7C
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 09:17:46 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b9so3482300ila.8
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=0krsNBOeMXog6tUzC5pS8BfPte2nrn+rRdpzBNHcByg=;
        b=zpBBYTH8dJiaoVuWxcynMDpPbypl3JoWySewRIx1d/WZ3fQpE3s3d9xzmNCs0XGVYQ
         QKsXGV/LPqVHU/E5bu00fUx7JWw60N7NHB+u46P+BDz9X4Bzuo6nT2dBke6rkOhfxhLB
         uosuoducoHSBGbTUF5lzJ0sjIoiKJr0Mnx5g672n7mL8XlUiXMy00HzwXW7AzrkphakH
         jz7aRusdJ76VMRiQ4XJ8rpg0nztgIMtjxXLNLgxxfyGRZBVjCKy000hmB6YS6+FgYT2U
         q653wdBFfFxLDB/9xHR0yHOpcAR5jvYy4p9cLSxFTPygzhBy7a25u2Quv4b2A7Eh7fN8
         s/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=0krsNBOeMXog6tUzC5pS8BfPte2nrn+rRdpzBNHcByg=;
        b=2otjHH9A/3e+6aF3WY7MvbUej/50Yk6dE0/5KmsefLMj/CqyBYzBSUYLVzMyY5i//S
         Z/FER4jGwAkEtpKe2dymsfO5HoZePosg76irn3mOURO28ZCShQKJ2XtrmmlM1xT3LySG
         xTWguqiBkCpP95SKXu4zJyZEdiJqI35FaB7h/3q6oVmSiZPxjFUSp7Me7Nx5HVb7rAWW
         OAv/yngdqlvpxOWgW4a7JI6BDY2P1Wu9OPNqbyOEWxUCk06o0wX2/3Cat8NSC16yrJj7
         W1fcmmvi+ezTm+CfMOBao4BO/W8tLnC697JCdtJKo8nbLXLvOqiNjwcew6yBWbdO85kX
         xlbQ==
X-Gm-Message-State: AOAM53090BUU3M8F+dh1CjuDtDxDHYEgMFzyZj4unUCUIJrIIDcQs/58
        ScPjHQ7V6ivobO4RYcvYGG1oa/VYRD+Cx/bC
X-Google-Smtp-Source: ABdhPJyfpg7Utu3rF/jb1kvMRkS8wtHao5Wbna4wT42h77DSmyojOl7e/AetGT13u6+TQR2/uuLVWQ==
X-Received: by 2002:a05:6e02:1d03:b0:2c7:e33f:2557 with SMTP id i3-20020a056e021d0300b002c7e33f2557mr3344249ila.15.1648138665018;
        Thu, 24 Mar 2022 09:17:45 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d14-20020a056602328e00b006494aa126c2sm1622786ioz.11.2022.03.24.09.17.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 09:17:44 -0700 (PDT)
Message-ID: <87ea541a-c863-cfe3-ade6-0aeadb264638@kernel.dk>
Date:   Thu, 24 Mar 2022 10:17:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: improve task work cache utilization
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

Move the list entry to where the rest of the data we care about is, and
prefetch the next entry while iterating the list and processing the work
items.

This reduces tctx_task_work() overhead from ~3% to 1-1.5% in my testing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 17a76bc04344..5cdd3a6c9268 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -933,6 +933,8 @@ struct io_kiocb {
 	struct io_ring_ctx		*ctx;
 	struct task_struct		*task;
 
+	struct io_task_work		io_task_work;
+
 	struct percpu_ref		*fixed_rsrc_refs;
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
@@ -942,7 +944,6 @@ struct io_kiocb {
 	atomic_t			refs;
 	atomic_t			poll_refs;
 	struct io_kiocb			*link;
-	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
@@ -2483,6 +2486,9 @@ static void handle_tw_list(struct io_wq_work_node *node,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
+		/* fetch next entry early to avoid stalling */
+		prefetch(next);
+
 		if (req->ctx != *ctx) {
 			ctx_flush_and_put(*ctx, locked);
 			*ctx = req->ctx;

-- 
Jens Axboe

