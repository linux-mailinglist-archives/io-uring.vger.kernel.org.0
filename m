Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8791D4BB2
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 12:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgEOKyb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 06:54:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22060 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726087AbgEOKy0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 06:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589540064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FAOMWx6OVu3YpynCtja6bREESlXthahEC6nREl9YhPo=;
        b=hXMq5UalvJLNnMicl5MmwjVY+tdDeDwcLg8b0WNOE/FFJGKtnewO2zF8i272+Y5L/9dCXn
        Oqe1QwWnL3F+IrBD26fYnlszE5rrFYRnlbh/SFhnmeKskYCYkn61etDTTm7Z1J6gFvIfV2
        E5tbVZjPCqZOX5rSvQb5Kl5Ob9n5TcU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422--ZfRy9r2OPC0D10w-MvrMA-1; Fri, 15 May 2020 06:54:21 -0400
X-MC-Unique: -ZfRy9r2OPC0D10w-MvrMA-1
Received: by mail-wr1-f69.google.com with SMTP id 37so1013922wrc.4
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 03:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FAOMWx6OVu3YpynCtja6bREESlXthahEC6nREl9YhPo=;
        b=GxxH/FO627rQ/OfIHmtVXeZbQaS8AVWZKTdi59NxHB5d6elkU6CL4KVJ/kat73uZne
         qLnGke0d8qvW0hrqrwaT4czESxAdiv4GUO2xr5nRQQRVb94pNbSQTm2B4cbSOUYG77pW
         PLiILG6v6gcP+TBiaHjMCCOXrIa/kGP9Cz8lmfv48ltLhlSeNWeSbUwvi1oWg5PnPmEu
         lJHaITf3vvwr6NGoh4zvMZyp3bfjKoSssomJynRYmQBcR7io7klwFKD8+5K8kE/aX1FK
         y7Lfzg1CYlSkTKUpx92UwYsRO1Tbet0+g0s4m+MHqm/VnZ77mfc+mmRH0YaXlHS3z9OW
         7M+g==
X-Gm-Message-State: AOAM532LTKcyRp/2N2CDrZTpdUcWi0XoCLcDOiE4t9J16XhXWIGRCGJk
        zz3eiX6jHaCUwu48w4ScwA8Wk4j4SYmbAzyX+EnG/60eVLDACzMcwXdM+od2jEy7cBZM5ATXZJr
        NNxutQf/4ah42RQO7u3U=
X-Received: by 2002:adf:a1d7:: with SMTP id v23mr3623538wrv.155.1589540059925;
        Fri, 15 May 2020 03:54:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4HCg1+ZO2PPPCFOjhk551z/9enVbNA+X4sgmGqe+RDc8hyFQZev92P69lM/DpFfkAbRAVQw==
X-Received: by 2002:adf:a1d7:: with SMTP id v23mr3623519wrv.155.1589540059653;
        Fri, 15 May 2020 03:54:19 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u74sm3081713wmu.13.2020.05.15.03.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 03:54:18 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/2] io_uring: add IORING_CQ_NEED_WAKEUP to the CQ ring flags
Date:   Fri, 15 May 2020 12:54:14 +0200
Message-Id: <20200515105414.68683-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515105414.68683-1-sgarzare@redhat.com>
References: <20200515105414.68683-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This new flag should be set/clear from the application to
enable/disable eventfd notifications when a request is completed
and queued to the CQ ring.

Before this patch, notifications were always sent if an eventfd is
registered, so to remain backwards compatible we enable them during
initialization.

It will be up to the application to disable them after initialization if
no notifications are required at the beginning.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 fs/io_uring.c                 | 7 +++++++
 include/uapi/linux/io_uring.h | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e8158269f3c..7c9486ea5aa3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1152,6 +1152,8 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 {
 	if (!ctx->cq_ev_fd)
 		return false;
+	if (!(READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_NEED_WAKEUP))
+		return false;
 	if (!ctx->eventfd_async)
 		return true;
 	return io_wq_current_is_worker();
@@ -7684,6 +7686,11 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->cq_ring_mask = p->cq_entries - 1;
 	rings->sq_ring_entries = p->sq_entries;
 	rings->cq_ring_entries = p->cq_entries;
+	/*
+	 * For backward compatibility we start with eventfd notification
+	 * enabled.
+	 */
+	rings->cq_flags |= IORING_CQ_NEED_WAKEUP;
 	ctx->sq_mask = rings->sq_ring_mask;
 	ctx->cq_mask = rings->cq_ring_mask;
 	ctx->sq_entries = rings->sq_ring_entries;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 602bb0ece607..1d20dc61779e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -209,6 +209,11 @@ struct io_cqring_offsets {
 	__u64 resv2;
 };
 
+/*
+ * cq_ring->flags
+ */
+#define IORING_CQ_NEED_WAKEUP	(1U << 0) /* needs wakeup through eventfd */
+
 /*
  * io_uring_enter(2) flags
  */
-- 
2.25.4

