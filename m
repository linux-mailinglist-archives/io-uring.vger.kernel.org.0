Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C953A5B65
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhFNBkG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:40:06 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:45014 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhFNBkF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:40:05 -0400
Received: by mail-wm1-f45.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so8697644wms.3
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HvOm0xj3SczGBaaMsvFuIhYB/fQ218ylKbNx9nMOHq4=;
        b=qVsLmM0atHZHwfCuiB/DXHgafq6YmdeOCLsMvzL2E97cFoGuJiwpULs0DlNIyqSC/Z
         a8hHJ83qvxWyvq11jnbaJ6dW5cmfm/8dF9YRgYki2T+1fxA4OyLVtpj+orIEez3Lw7TV
         DyD5Wlaxh3JGe9lhcldy+XfUfU62dhg+jFBhwv+Za2GCUQCsJebNMzk0udjrjNFaDyzu
         /1LVWPFl6Lh0yPM+vRp3siMZjBePzZ8ZDtLn3Hpu9XaRB4BUce2U1xNI4CkeE20ig0Y8
         fS2ffcWbZCkD56gRVxS9Bzcy/7L+XBpJsdMeAiznuq76AhdS3qbp1XTTAKaaMmoHtGoP
         6sHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HvOm0xj3SczGBaaMsvFuIhYB/fQ218ylKbNx9nMOHq4=;
        b=GyjFoYybGK+crM9TRIeabjdgUt4qw/324woOdieT0UPPmqWiJa79W7MkkaUVX/xzwR
         rNRp5FF9Pxvq2AbUiaepYZYIpCoy1v961s8Y88iu6zm0OFBQ4uXZJQ/9vcBO6VwsiXP3
         5u2g59bK02SSfdH9cnb5lyeoRwMOv1DbIwanCAruWxwiP7Bxt6/WD4rfRv5ThVXtI3Lb
         EtmtNvvj/h/KUxuzkoQbVEhJpxxNb0IZ33cAaGOlQQPg3TweVVW8SMQ2MUFSd8NxL8ak
         kqPwLE49Vd8i5bsGkg9fkrzD9vnB5DQsUZfTDyeI/V3F49/Nq9zocbUSviW9lYygmOso
         LLJg==
X-Gm-Message-State: AOAM533ub4JeHQ6V2tMzaopsYurB/3jur1chHkiKzoMGob48wHF+xWIg
        JO/J07GVRA/o0DiIp52RSQQ=
X-Google-Smtp-Source: ABdhPJxBs/YAEVJIbsUt6CcQPRLiJsCjIuIzSwB4veryPqDtFGtpVE/i+OGiJIP7hohzfCrd83hbIA==
X-Received: by 2002:a7b:c44f:: with SMTP id l15mr30461718wmi.151.1623634611897;
        Sun, 13 Jun 2021 18:36:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/13] io_uring: remove rsrc put work irq save/restore
Date:   Mon, 14 Jun 2021 02:36:19 +0100
Message-Id: <2a7f77220735f4ad404ac885b4d73bdf42d2f836.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_put_work() is executed by workqueue in non-irq context, so no
need for irqsave/restore variants of spinlocking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 18ed6ecb1d76..59cd9dc6164c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7550,14 +7550,13 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 		if (prsrc->tag) {
 			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
-			unsigned long flags;
 
 			io_ring_submit_lock(ctx, lock_ring);
-			spin_lock_irqsave(&ctx->completion_lock, flags);
+			spin_lock_irq(&ctx->completion_lock);
 			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
 			ctx->cq_extra++;
 			io_commit_cqring(ctx);
-			spin_unlock_irqrestore(&ctx->completion_lock, flags);
+			spin_unlock_irq(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
 			io_ring_submit_unlock(ctx, lock_ring);
 		}
-- 
2.31.1

