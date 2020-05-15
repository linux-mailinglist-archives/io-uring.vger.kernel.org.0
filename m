Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFC91D563B
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgEOQiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:38:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28073 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726233AbgEOQiN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589560692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gZ5R0zPx7v8Q5QUl+dC4PL1yY2tt7RqoIbj3l8sE74=;
        b=Psye5yAzWoGgQZiNB7G+RGlp/2ujq3OuHTGWF5AgXH3A9qu23YNE8YQkUTyXmMhdXDKm+4
        yOCZCDir6f0VXksXZBY9RBl0dHrrLO451zwZR9RviAKNC+rREpcUysnux4+tNRgBdKZ5vj
        K7KH7MyQY01BXKtCjPF2QjWYd3V4T4g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-YNocHvW0MkaG1MIBmipkuw-1; Fri, 15 May 2020 12:38:10 -0400
X-MC-Unique: YNocHvW0MkaG1MIBmipkuw-1
Received: by mail-wm1-f72.google.com with SMTP id x11so1226587wmc.9
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6gZ5R0zPx7v8Q5QUl+dC4PL1yY2tt7RqoIbj3l8sE74=;
        b=myph1NukHBuzdislkIKZr+YW0vJJhrBYgd8/1oBeRbTiopVXuF+q7jamr93cKqT6xo
         pkwCrGwDT10IgZWTdI7C2N5ClO4vWd5zaQbfdFV08MXk9qyR/AjVJ6rZdZU4J9z/oK17
         ChjPPSzWca1duIwfPN3fv6YG9xC3NiA3RYCcWiGBTFXWF8YG+eRG8H72KzKxLU0CCEbr
         nGGqmyujd3LkZBJmbbqpPPcrOKT2rtc5b9RZFpTkWdBSRbLw+I05tNtjcUl11YMSGMhJ
         CkCVjavOrgDi36AYDgd6dJowlLF1VCRLMLUCIshDGwdADpriUBbevt0I5i7hXjOaya/n
         8XzA==
X-Gm-Message-State: AOAM533xUekTw3PSJYFD9em4UHjCWmB1dVxbACbV+vBQSkUq4IXhAjmT
        Yf1feYVXvSQmYiKkpqV2rZ0mlk47zO2VtiuAAF2+HKwtH5jhs1aXH/FYel/FyU4KVGCbxFCmBay
        ALvC8oZKO9Ll0smlal0k=
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr5068323wri.165.1589560688994;
        Fri, 15 May 2020 09:38:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxF+hp4GbO5uog6iIPuueL5jjs4PZEKrB1UaoTN20cj9bx0TDVFE81Yzd2+7qty/BxbZXjrMA==
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr5068296wri.165.1589560688701;
        Fri, 15 May 2020 09:38:08 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id b145sm4680274wme.41.2020.05.15.09.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:38:08 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 1/2] io_uring: add 'cq_flags' field for the CQ ring
Date:   Fri, 15 May 2020 18:38:04 +0200
Message-Id: <20200515163805.235098-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515163805.235098-1-sgarzare@redhat.com>
References: <20200515163805.235098-1-sgarzare@redhat.com>
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

