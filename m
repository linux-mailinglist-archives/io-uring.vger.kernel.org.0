Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21E075BA71
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjGTWTb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjGTWTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:20 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDFE2737
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6748a616e17so275300b3a.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891557; x=1690496357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8p8JjwfYvwzUP3L/+vOnIO7lTE0XP2lNQtQ3ycVJyI=;
        b=ezgXyJ7eorY9miMJ0pfR/IjX47nZPS1vhqOXHCqvhuHrCTYM0NUHsVdFAPEqtelvLa
         4+TehMzudX8jcNZC1gV51ZDHzlqjdJxZj2qXSV6iPDELG9FOEFFllDhaO9FEo8HUzFaq
         jSP3Qnu+aPSZwBV3oLxSGmK33BELXZbAHbDSIpErtRd5ZlFswmgA824Hy2mKba/gyreS
         R3uCTAPbB3zlmfkOslY6oRKcKlP0l7oPLytjIXC8w0HTk5Nrx+vU4gL3gz1LQoNqA4pZ
         sKV2JNlYqiVAJBYGDD3jneUvgVemhbqwqY45Sq3Pdttoxd2DWVZ5hQLZpavjMp51WfxJ
         0MJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891557; x=1690496357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8p8JjwfYvwzUP3L/+vOnIO7lTE0XP2lNQtQ3ycVJyI=;
        b=kbfbCWzSAsyw42LUH713xWJmMZyztDaZALYOsS3yf0CNF+poI1rSaMXBK5Gj0ogyfq
         N3k2ZBzKvUUr/Sk7v2GMOHxZkODLnb3eSmqiVJ3x0KRZs2oWwlYvIh66NDOj7GcNb465
         2K2kk8uQegH6Yw7+n4Wlm74A9aevMuS9SqSzoyVbum4ZVCihywfcZj9kRa3vGdtiZufA
         27LbdIlNWL3gQXKntZ4HwPuV+p2yvpbhHe+1GL/2yUkb2FFe98SCib9PD9l4RpCk1oEC
         ROsOyTUlvVtQHinF/BlDLFT4alUnRYeLgxWYm6cRbWkRBu6EMvHviPdOH8LVcyXrc1wi
         08PQ==
X-Gm-Message-State: ABy/qLbDRU/8eGCFtld6vtuA0QLjzA1HGHQKL0Ytk1QXbgrUZ700csfn
        j2whjKHuP69qDHB1Vg3TQMo32ji/XClpwmf1KRs=
X-Google-Smtp-Source: APBJJlEvbSUT0/MY0C+XFTQOuj19deXmEQlX8UowhCce66OM9QlRtWI6YLNlXM38mj23LtLIDSM04A==
X-Received: by 2002:a05:6a20:54a7:b0:112:cf5:d5cc with SMTP id i39-20020a056a2054a700b001120cf5d5ccmr259613pzk.1.1689891556765;
        Thu, 20 Jul 2023 15:19:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/10] futex: add wake_data to struct futex_q
Date:   Thu, 20 Jul 2023 16:18:55 -0600
Message-Id: <20230720221858.135240-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720221858.135240-1-axboe@kernel.dk>
References: <20230720221858.135240-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With handling multiple futex_q for waitv, we cannot easily go from the
futex_q to data related to that request or queue. Add a wake_data
argument that belongs to the wake handler assigned.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 98d43e9efe65..292224816814 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -144,6 +144,7 @@ struct futex_q {
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
 	futex_wake_fn *wake;
+	void *wake_data;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
-- 
2.40.1

