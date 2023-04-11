Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520316DD919
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjDKLNP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjDKLNE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:04 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B511346B1
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j17so9682892ejs.5
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vk+L5iCXvmHnZt4vc6rvDG8PS1OW/kzTiKfkRlYy0ZY=;
        b=HlfwovvjkIP5woFiUF4XO8MoGOOVrUhZIRgJvrf7Z8sQmiKunOBVPMpZZyAgBO70mH
         156U4jxmU0/MsEnrfGl6k/fhtCj2ZMqWMnoBc9Qq3U2PGVND6Xe/trWVXTBXkIwkrJxX
         WwJW0gtqa/dDJHzcxxXVnyNUfHqGlxQtqPpXTAmNMVRqp7uPC9YLVhfXErZ50qbYb9AK
         RxPxRxy5ucxsiP04TFKIsCqiFwCOMFw/4ULNFygGmL7CG8jDdyFJuAKxpE7ftoRYQTEX
         Iy6GEUs03HWRi2aowyAAeJ9vUsYF0izQFPZ6QXyM/Gfk6keanl8gYTR+qvz+6itGGVyq
         0zgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vk+L5iCXvmHnZt4vc6rvDG8PS1OW/kzTiKfkRlYy0ZY=;
        b=36bYkL9uLmOON4B4OirsJJhe8j6+VzBDhCAIcGpJ4UJuxkxxobKWVgyaicEm6PZaKL
         6NiEPEXTWVp0cv243jGAKZeGW9UeifVyOdzFvbskfYhEaTOWa0Hp6Zq31mITpsETkcTi
         yrsWnXoTZ2SkaaSm6fJArFRzY+Y7yDL95+M+JnWwuRxzMbQoIQjBZ7OcxAOVZMRLNirM
         LMumxWKNVMrsO/Qnj7iJ4PbA6C0VK3SMK4iRk6+kfu8sf1HlA55+LPTQb+wUAxdBmvQg
         bBV+3d4wVDYRPHyd2GIWGzrtTMtcoydSHeD+wBBc/QIfKCau+9sRQFwJhx46Zr5FAXkj
         /kig==
X-Gm-Message-State: AAQBX9eP34mSgR0m++FMkdfrrN+mmWt9R62YilzotPuyTWjBmjBjA1ws
        dhw2w2EeAirAT6G5GxegvRh88Y8Rfx4=
X-Google-Smtp-Source: AKy350YwjVmarvrgfIDX7q+nnMGZ+t7/ZlrEB8KXNFn89LagCt/dP1dK6wrH275mWwv3Fp4hgH8KUA==
X-Received: by 2002:a17:906:d055:b0:94a:4d06:3de3 with SMTP id bo21-20020a170906d05500b0094a4d063de3mr2092795ejb.72.1681211568880;
        Tue, 11 Apr 2023 04:12:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/8] io_uring: add irq lockdep checks
Date:   Tue, 11 Apr 2023 12:06:03 +0100
Message-Id: <f23f7a24dbe8027b3d37873fece2b6488f878b31.1681210788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681210788.git.asml.silence@gmail.com>
References: <cover.1681210788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't post CQEs from the IRQ context, add a check catching that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ef449e43d493..25515d69d205 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -94,6 +94,8 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 
 #define io_lockdep_assert_cq_locked(ctx)				\
 	do {								\
+		lockdep_assert(in_task());				\
+									\
 		if (ctx->flags & IORING_SETUP_IOPOLL) {			\
 			lockdep_assert_held(&ctx->uring_lock);		\
 		} else if (!ctx->task_complete) {			\
-- 
2.40.0

