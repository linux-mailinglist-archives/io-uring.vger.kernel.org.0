Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2B11D4BAE
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 12:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgEOKy0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 06:54:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32153 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725835AbgEOKyY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 06:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589540062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gZ5R0zPx7v8Q5QUl+dC4PL1yY2tt7RqoIbj3l8sE74=;
        b=d7cJe4MWvIFIoFuHPJx3DZkOVWKwGOOmX91Wg9H7XvHwqyJ5yFa7N/1CGhNq3Npr8pnp1t
        ORFRu0zX5Vzh5rVDu270ytUi5LwNsCujDoV151XTcmZsY9g+d7wk+cISy60ekj6rt07HaP
        X3/+WujCv+x0B1qs72zZTnjnCEy1qDE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-xwUPgXZ5OaqjnbImZn1_NQ-1; Fri, 15 May 2020 06:54:19 -0400
X-MC-Unique: xwUPgXZ5OaqjnbImZn1_NQ-1
Received: by mail-wr1-f72.google.com with SMTP id 90so990082wrg.23
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 03:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6gZ5R0zPx7v8Q5QUl+dC4PL1yY2tt7RqoIbj3l8sE74=;
        b=MlDArqjcwrtUMOMr4OlYK4wXYQ7yWGy6BXj/jxucwvEp9QVDiTB4zjmxWmItE/Q/vB
         fY9Ug5kNOLWlN+quAD1ait8dCceIGDIMIgJEugQnz+u/TNmI5YuYX2XAL6mh1z2SrL6D
         VZpxO837dZT6vq9ne/2uFx/GgaaEp7k76knF3TBvTZdwDZmU1LHTF/MH+sKcMjg3QMfd
         KrcK0UXv1nBQn+o+Nu+cDbQyiv+LZL0gs5TaJiBtMMw58tEGdcMOCTncEga2EgECKdmn
         9k3ZMHS5qcy8c7sE0u3Ajwh2oixUoAVjyw4/nra7WVf2/v7tLeB82gqp6Yh9DMSDbL3h
         nnnQ==
X-Gm-Message-State: AOAM532c6ASTUzDAVvHSjfRMUw1+ZNcrJOHScr8FibVtwPXZuRV7pl6H
        s4d1AoUr/jZStI/qh7B5mIW2L+VopGc1GtR8mJVfnQl17yPEV5Cie2nfruQqO/GvOiXMP+otIii
        V/qR2mb3Q1iNg5TcvsVM=
X-Received: by 2002:adf:a151:: with SMTP id r17mr3552502wrr.161.1589540058510;
        Fri, 15 May 2020 03:54:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyANinCJRe3qYf2rSPZc3k0J3adf1PvxM/KmGOwiUEErSAAvt9ePGHUThMA2CAAwwoOjOO2vQ==
X-Received: by 2002:adf:a151:: with SMTP id r17mr3552475wrr.161.1589540058226;
        Fri, 15 May 2020 03:54:18 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u74sm3081713wmu.13.2020.05.15.03.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 03:54:17 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] io_uring: add 'cq_flags' field for the CQ ring
Date:   Fri, 15 May 2020 12:54:13 +0200
Message-Id: <20200515105414.68683-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515105414.68683-1-sgarzare@redhat.com>
References: <20200515105414.68683-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds the new 'cq_flags' field that should be written by
the application and read by the kernel.

This new field is available to the userspace application through
'cq_off.flags'.
We are using 4-bytes previously reserved and set to zero. This means
that if the application finds this field to zero, then the new
functionality is not supported.

In the next patch we will introduce the first flag available.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 fs/io_uring.c                 | 10 +++++++++-
 include/uapi/linux/io_uring.h |  4 +++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 979d9f977409..6e8158269f3c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -142,7 +142,7 @@ struct io_rings {
 	 */
 	u32			sq_dropped;
 	/*
-	 * Runtime flags
+	 * Runtime SQ flags
 	 *
 	 * Written by the kernel, shouldn't be modified by the
 	 * application.
@@ -151,6 +151,13 @@ struct io_rings {
 	 * for IORING_SQ_NEED_WAKEUP after updating the sq tail.
 	 */
 	u32			sq_flags;
+	/*
+	 * Runtime CQ flags
+	 *
+	 * Written by the application, shouldn't be modified by the
+	 * kernel.
+	 */
+	u32                     cq_flags;
 	/*
 	 * Number of completion events lost because the queue was full;
 	 * this should be avoided by the application by making sure
@@ -7834,6 +7841,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
+	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e48d746b8e2a..602bb0ece607 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -204,7 +204,9 @@ struct io_cqring_offsets {
 	__u32 ring_entries;
 	__u32 overflow;
 	__u32 cqes;
-	__u64 resv[2];
+	__u32 flags;
+	__u32 resv1;
+	__u64 resv2;
 };
 
 /*
-- 
2.25.4

