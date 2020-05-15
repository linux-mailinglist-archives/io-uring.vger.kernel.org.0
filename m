Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543DF1D563F
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgEOQiS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:38:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726372AbgEOQiR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:38:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589560696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YZmrRZSpZSImU0ZWw6sQoh3piuQw6gdHG9URSW684/o=;
        b=E5RYsY16/xuN9bOTMY8czzyLha06dW7hGoM2Hn4FqhEcfFmWdptiX20ztPbUhIn1s3OXOU
        WPOiS3Npn3v0aWqkpxkx+xQVY8u+jC+wZI3Wlo5mcYIWPlVt00KR/xZRhldN/iX++v36Bp
        ir05G5wzLRpMUBMHqNjllIibboMyl8Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-UjJZDqgoOQylqQVFxUq62A-1; Fri, 15 May 2020 12:38:11 -0400
X-MC-Unique: UjJZDqgoOQylqQVFxUq62A-1
Received: by mail-wr1-f70.google.com with SMTP id r7so1435538wrc.13
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZmrRZSpZSImU0ZWw6sQoh3piuQw6gdHG9URSW684/o=;
        b=Hfp+TGC+YToDcGUj7gKQI275aHh6rRx72VmkQpFY7hZrx01op5x4pTXqrCLBAX/EJp
         HEnYWl3ncbQsO8e2NqHmV6gV5u6UGtfuDH4DAkGycFJOY+yXwH+zwkqU9lsHXiisOwQm
         f7j/1QC7Wp3/FZQoj4tCOr9DqjDyoFdG4IFSITB3BNL03ct8Xx/qeSmQihi73siTj8fh
         AV/Zhyzz4eqR2d/dmrVuv9auTBArXwjbiMOIUK/K8zaDBAprWSqZr0eSlONK5E2I8mb4
         C46x4X2MDuSlhaXt3uB3W+dFz23eVbd8VK+ZyTC8lFFQFoji+rkVD5RXKtMY8+yyPp5/
         cb1A==
X-Gm-Message-State: AOAM531xdIqWP46JyT8/2AWBEGxshGtY/ZO7hlM3rm34TUj3wnI2iaf1
        z/J8dUXNN0k6EypHyNa/gtmPsdSv0g+yufiMXubsFJDzrZ9CQjq8SqNYMpoWuKMS0H36FyaopVt
        ARwg9iVn+HETXDFFWOrk=
X-Received: by 2002:adf:ed82:: with SMTP id c2mr5379926wro.255.1589560690177;
        Fri, 15 May 2020 09:38:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHkK+pYRdkGRoBHu7DvxKUQxjk5W5DN2qukBf2VTAqpWYC92WZ6RC31kIRR64YG+MD9jnxcw==
X-Received: by 2002:adf:ed82:: with SMTP id c2mr5379900wro.255.1589560689927;
        Fri, 15 May 2020 09:38:09 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id b145sm4680274wme.41.2020.05.15.09.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:38:09 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 2/2] io_uring: add IORING_CQ_EVENTFD_DISABLED to the CQ ring flags
Date:   Fri, 15 May 2020 18:38:05 +0200
Message-Id: <20200515163805.235098-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515163805.235098-1-sgarzare@redhat.com>
References: <20200515163805.235098-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This new flag should be set/clear from the application to
disable/enable eventfd notifications when a request is completed
and queued to the CQ ring.

Before this patch, notifications were always sent if an eventfd is
registered, so IORING_CQ_EVENTFD_DISABLED is not set during the
initialization.

It will be up to the application to set the flag after initialization
if no notifications are required at the beginning.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v1 -> v2:
 - changed the flag name and behaviour from IORING_CQ_NEED_EVENT to
   IORING_CQ_EVENTFD_DISABLED [Jens]
---
 fs/io_uring.c                 | 2 ++
 include/uapi/linux/io_uring.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e8158269f3c..a9b194e9b5bd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1152,6 +1152,8 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 {
 	if (!ctx->cq_ev_fd)
 		return false;
+	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return false;
 	if (!ctx->eventfd_async)
 		return true;
 	return io_wq_current_is_worker();
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 602bb0ece607..8c5775df08b8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -209,6 +209,13 @@ struct io_cqring_offsets {
 	__u64 resv2;
 };
 
+/*
+ * cq_ring->flags
+ */
+
+/* disable eventfd notifications */
+#define IORING_CQ_EVENTFD_DISABLED	(1U << 0)
+
 /*
  * io_uring_enter(2) flags
  */
-- 
2.25.4

