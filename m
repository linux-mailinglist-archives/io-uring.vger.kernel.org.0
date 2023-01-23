Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3A9677E45
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjAWOmR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjAWOmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:15 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DD121A0F
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:14 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d14so7338802wrr.9
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCWbGwBl576a0ArFhLpktKBP44fCtoi8yPjJSutd26c=;
        b=Ru+NvOrZat8Q4naKOvtZZE5eIJ0xQ0ktc27fRXyv1tWCfYZEeL6BwWHbFc5XMxDK8L
         Fvw/NETP+ei3HtMs11TOtLptJniwvp6fv/oslYqvT8wGjWXB+Vik+s/sHyMU4LgtqDOL
         RGy6FZU/M9yRMeOBq2VGEgrZ2KCsn06xEusVTRSo8Ej9+dWLmAWr6w9K/a8/JASo62HT
         3ctXv8rQiFFCgUM+XeEiOLqN4n10h6S3eYFLt3yui6StqDcO/9GIcXE6PymWrImJe8ut
         FOFdw7PN3BSEizvYg3bDzPqJ8keFFN7Ju3dykLB8YmIGR9QEIq1vzINXJoZQSQkCS1AR
         Tcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCWbGwBl576a0ArFhLpktKBP44fCtoi8yPjJSutd26c=;
        b=N8PPRsK7zEBKuxXEEprCpJbg7Zaot9/Sqr/dHHwk3LzTysok0MM7W3lsf1NQolMFr1
         GQvjCat+NBQxXTS6C7f5YxlctqXPs3k+OsIhmM+Xp/5EcFhAeNIoDi4R4DnA19kgEa1O
         5fRIVX83vM9W96h0kkCk7YZoY7qWbNxez1wBwOxDNNUu1HqQyw4mdB6FTVcfjs/WMKQO
         p1WFY9La42ezDpyA72833NWxtyGla661ZKGVMiN/TWmiPl8oysFVjTOuG1t/pfSOSHzI
         jcygCXgR00eRjF0VVsaGdkfJTdbBa+34XNoAbxr6x+5yUMNUxDzxa+71j9+9n5u6xmyK
         1e2w==
X-Gm-Message-State: AFqh2kpzIwdVRy78d3pRcaxsivYtSc/vGIAdg/eDufYdFHfoW9QwF69l
        6fmza6GYNvazjO0FWGudPZMfYUgU8bw=
X-Google-Smtp-Source: AMrXdXuvIa4UQlMVSHG3GUuF92gxi34AWjhovyqIk3PSEPm1SxEdb02kvaSX6HTAaq1kJrnL16f3/g==
X-Received: by 2002:adf:f7c5:0:b0:2be:5a87:4e5 with SMTP id a5-20020adff7c5000000b002be5a8704e5mr10641777wrq.12.1674484934079;
        Mon, 23 Jan 2023 06:42:14 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 7/7] io_uring: return normal tw run linking optimisation
Date:   Mon, 23 Jan 2023 14:37:19 +0000
Message-Id: <a7ed5ede84de190832cc33ebbcdd6e91cd90f5b6.1674484266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
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

io_submit_flush_completions() may produce new task_work items, so it's a
good idea to recheck the task_work list after flushing completions. The
optimisation is not new and was accidentially removed by
f88262e60bb9 ("io_uring: lockless task list")

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 586e70f686ce..8c4d92e64c20 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1238,6 +1238,15 @@ void tctx_task_work(struct callback_head *cb)
 		loops++;
 		node = io_llist_xchg(&tctx->task_list, &fake);
 		count += handle_tw_list(node, &ctx, &uring_locked, &fake);
+
+		/* skip expensive cmpxchg if there are items in the list */
+		if (READ_ONCE(tctx->task_list.first) != &fake)
+			continue;
+		if (uring_locked && !wq_list_empty(&ctx->submit_state.compl_reqs)) {
+			io_submit_flush_completions(ctx);
+			if (READ_ONCE(tctx->task_list.first) != &fake)
+				continue;
+		}
 		node = io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	} while (node != &fake);
 
-- 
2.38.1

