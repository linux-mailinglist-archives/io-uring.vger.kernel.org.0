Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E2974FC58
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjGLArY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGLArV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:47:21 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EE41733
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b8c364ad3bso11362415ad.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689122837; x=1691714837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USpRQzApdKpSjiyBkjEmkDnIwRqj5vH3splpyWQ1un8=;
        b=FpZRUoq0aBYl9CAG+w+52gtPelgfB27iLDuiaLxgUVSRo0wfLIQu3VEnoXzkS21Xdq
         m2jQmSMLiebVrVI9WO6ahU0wvGJn/wLM2FxTrd9cUM9WY4c+wcnNp67maehJN6ewabhh
         dVK3RGPyvWiLbGnt4Qo07jrG56bi2emgJqA1ILLMMFhyvloYjZbVc+3Tsh0eEojhdfSx
         Xzby3UClIYLVNsK9oAJUNiNmY2DF9sC0AQdDgP1zbgR+eX1Dy8ibt4t9ZPK+1jt4zUJS
         dDCtTrGBlpkFiOwIMzYzUn/KTkuI44aU08Q8pOq37fL0TdJ7sMpjmm2L1cMFu309BpEl
         Dl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689122837; x=1691714837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USpRQzApdKpSjiyBkjEmkDnIwRqj5vH3splpyWQ1un8=;
        b=FebiGcTGcQ6YSXShdsotOTokRUWLTrDfVYgC73zfBqR/rWoHJTqhzf0/LXRa2krrNz
         UmBidaDPHQjD1uFrI/fOcdFwVhvE9PeEtpbs4jvm1OqUtGujgqmGm8joH6sHTxGth2Ze
         9CuqOUZqANZw28k0pdwdRuBwAjg4YqtbgEXBDH6RLf7svG2tiHWUZHmb8QVRwPZq2pPB
         2JgYheRaBoNNQSIMfavT0pvA/xWuAijuNRohBB0kpoS+z6XxKP1ek55teCBXEGmk6TND
         FSxZdZ7sDrQh4Zq7tV+QbjDxiqYL/UFYEDnNV0SkHcnSsgdVVsD5u1B4hTQ+d0tluwe7
         L9hA==
X-Gm-Message-State: ABy/qLbViuHy8VQrD8X8t7mAJTmN1UXXci3CLFrURLpuq22/Kica680R
        xPeWSX703n4xcgvg27eUpdGbx+7eKMNTt9E4/1s=
X-Google-Smtp-Source: APBJJlGcQTb4zl90ols3sb/WEm7O0/Lzfmu6C2MX3GYDEZjK7TfuE80XBAJnU+feK9BQZF1fr1oReQ==
X-Received: by 2002:a17:903:244e:b0:1b8:b4f6:1327 with SMTP id l14-20020a170903244e00b001b8b4f61327mr21565526pls.6.1689122837255;
        Tue, 11 Jul 2023 17:47:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902b18800b001b694140d96sm2543542plr.170.2023.07.11.17.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 17:47:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] futex: add wake_data to struct futex_q
Date:   Tue, 11 Jul 2023 18:47:02 -0600
Message-Id: <20230712004705.316157-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712004705.316157-1-axboe@kernel.dk>
References: <20230712004705.316157-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
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
index 8eaf1a5ce967..75dec2ec7469 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -102,6 +102,7 @@ struct futex_q {
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
 	futex_wake_fn *wake;
+	void *wake_data;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
-- 
2.40.1

