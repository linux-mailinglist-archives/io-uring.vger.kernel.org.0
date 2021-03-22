Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF534367E
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCVCDS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCVCCr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:47 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7BCC061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:46 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso8379427wmi.0
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DNTpkA3Ww5fUFv7EFo7fVpqh3mJX5dvLugKI9OWjBZw=;
        b=Yv7HzXt+iIwQs+NqNgwSm81k9cUm9UbLN+11oU2ntSxuzzFd2RJVA9od/+XqBZYNgr
         x+g356RZK0clJHGikDZRTiyrgNxA5caRigXaSNKkdS55wPPKOZoJIQ7MY9UAGetlV9cW
         ECy5vvvX0+Vw0OIcLehImJ3nhOwT4QtS8JF6LHhJyROPQh148LroVBF2jldyLTY9S9cU
         pqijVfPIT9igdCLsbrKxuJsYxjvAPkr8lMPTxGURubBqTho75egvnrInxXuz1CZuagi2
         lPZjvk8kuSh2+2Um/AHqb/uAVvxQcj2Vw7cOdTSbR7b1DwnAu4T6VeUqk2lv931oTbh7
         zddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DNTpkA3Ww5fUFv7EFo7fVpqh3mJX5dvLugKI9OWjBZw=;
        b=RhSyPCOQA4Cp/aegRO1vYrBZD9sXcThI2QCdOneNjB6Ou+J53VjDX82TYUfO0amTNw
         qTL9bxSbWEHrOiET6JWrSK/Ba4xz9tDSTD2pTO1iaPsxCOwP5Nll9ryX62KkkK2ISeWX
         HyZ4RIc3l1gtUI/jpugo3vgmLHwG5+3ucSqx7RPLmnvPkPKlt9yxMpOFZCIgdUbyaV2l
         oDR3f2Hh64SO5pRD4ln7LU/83nx1rzjKT9lLKwCekl8ZyYBBuvYF2g5mBPpGRBALFZ6a
         zWZbS2Dd0gnTuzZ5we3hNiSkeKG58HM5NvkjkHl+/uy1GidSq6uGlRVX4txGSm4SdlDc
         gEgw==
X-Gm-Message-State: AOAM532c/i8e+DMYP9gtPX2w2TyEzYBVyXovhw72NoQ2WNzq3FM25rQY
        jG7Y+//Q/xNpMWRN6YXyN12dqLkzYw+HAQ==
X-Google-Smtp-Source: ABdhPJzfcwHA73tECjeYUXM7lblzVMvgTPmECrrZ1IBdL9ST6vy+qO8JTRoWIrsx/cUmP7sF5ErWQA==
X-Received: by 2002:a1c:9a47:: with SMTP id c68mr13545715wme.63.1616378565705;
        Sun, 21 Mar 2021 19:02:45 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/11] io_uring: remove tctx->sqpoll
Date:   Mon, 22 Mar 2021 01:58:27 +0000
Message-Id: <a4aba990c9fd73b18a107ef363aad7590d54d533.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_uring_task::sqpoll is not used anymore, kill it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 45b49273df8b..ff238dc503db 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -465,7 +465,6 @@ struct io_uring_task {
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
 	atomic_t		in_idle;
-	bool			sqpoll;
 
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;
-- 
2.24.0

