Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2B36E7F92
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjDSQZ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbjDSQZ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:25:58 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7043B10C1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:57 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5180ad24653so544481a12.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681921556; x=1684513556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yig2yzZEbAOAAe0JyonvM0JghOyicJfE8C/+0HCK1lk=;
        b=pZyd1zs6OIeD2mBOVJYWN+9NOY/TboYsxnPt528S8qnuyK5/24lNehJ2Kd8Mwxo2HE
         9Fz+G8G85Pj9cgI1bDRaJ5Ki0TL0+FxfWt5QfPWQ+OObGnz4qXM13XYy6BzMjFgXJ4Dd
         SoIQJRWtuhWkCJo8OsGvKXlPI5OEC/WojTz9BKQUZTu+I+DmNKXtdF6kuiS4WCTG27bp
         z/JfIxtedOtoc4yfTiKuP/N1fMbagko8uYbcvXwK15K8BEJHVZRapkBYJTqWY/ltz9EM
         1n4odr0GdcgSu8o5MZQ3Rz96lyuFVwqJp62oOw67oYCYZTsjOYtXE3mql7rc0K61HJ8J
         nzcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921556; x=1684513556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yig2yzZEbAOAAe0JyonvM0JghOyicJfE8C/+0HCK1lk=;
        b=jQC0zAWp52XyxKumgC0MtghKvksttzF7HZpSbt0bD8zQQqMRm5Hl4oAv+DnJ3AETqf
         O7cHCT7Zd6w8JPZHdC+0Q5hXqlTYjAWtLHdddGP29WzPjBOk8haPLRM2srKvnH7yGzj6
         TIoSWwvWmM7jfvZSLhaYvVnC+9nraS3j5UhYrDgqltkEu+nkn6D4aUKSsbWqvCE/v0E0
         NdpblJ/7tA8AvXKJjYZE8lQH4ohI9oJage2R/ijJlYJHQLN0mZ7zriicEA87J1Al2Bu5
         +WEN6SrxLmUxeGwyMKjU81xwiA/Pwf0YMgTDQADkOQGPQoea+zc1E5U/W2/mZvGiGiZY
         9Log==
X-Gm-Message-State: AAQBX9eX/8Nda78oMWFin+Bt0E6W5NZGt6G3wznHjJajVb/RVSrvBZOr
        39awphMrFgT8KjbygfpUlbfLLmHI21TpOIrVN4M=
X-Google-Smtp-Source: AKy350YktWJI1dlbWt35YwMyLT0dB5jy6klCfgpPd8wD1kJOgf7RZkODuIv4rFqR0f8WAsxFqywIKA==
X-Received: by 2002:a05:6a21:32a2:b0:e9:843:18f3 with SMTP id yt34-20020a056a2132a200b000e9084318f3mr20706791pzb.5.1681921556600;
        Wed, 19 Apr 2023 09:25:56 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k19-20020aa790d3000000b0063d2cd02d69sm4531334pfk.54.2023.04.19.09.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:25:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring: move poll_refs up a cacheline to fill a hole
Date:   Wed, 19 Apr 2023 10:25:48 -0600
Message-Id: <20230419162552.576489-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419162552.576489-1-axboe@kernel.dk>
References: <20230419162552.576489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After bumping the flags to 64-bits, we now have two holes in io_kiocb.
The best candidate for moving is poll_refs, as not to split the task_work
related items.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 84f436cc6509..4dd54d2173e1 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -535,6 +535,9 @@ struct io_kiocb {
 	 * and after selection it points to the buffer ID itself.
 	 */
 	u16				buf_index;
+
+	atomic_t			poll_refs;
+
 	u64				flags;
 
 	struct io_cqe			cqe;
@@ -565,9 +568,8 @@ struct io_kiocb {
 		__poll_t apoll_events;
 	};
 	atomic_t			refs;
-	atomic_t			poll_refs;
-	struct io_task_work		io_task_work;
 	unsigned			nr_tw;
+	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	union {
 		struct hlist_node	hash_node;
-- 
2.39.2

