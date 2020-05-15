Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE441D5663
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgEOQno (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:43:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbgEOQnn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589561019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8BzB2ZbPqVBvZbI6zHpmekOrcHdTij8B78Ycq7lehA=;
        b=MMeLP/XEN5TyXeBAKyqP935I9oV7jtKCpdWQzrYeA+R+kEkO2T22zIj4EExw8GMsQg5+78
        sMEdZ0gEFWpvf6Lkb37NUcsDWzzueVoMeSM/EiSpSnEF94BZYYp6zIXMHzZ4VBa8Bhfh3/
        UGgPGY50vT2hagL45Y5kyDAxzH0PFTk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-hlk9yGRBPNelnTSDh-xLFA-1; Fri, 15 May 2020 12:43:37 -0400
X-MC-Unique: hlk9yGRBPNelnTSDh-xLFA-1
Received: by mail-wr1-f70.google.com with SMTP id 30so1438832wrq.15
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:43:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8BzB2ZbPqVBvZbI6zHpmekOrcHdTij8B78Ycq7lehA=;
        b=nyC0fHyWlHCi5+u1d9nLI5uMpH6O1gcBvwhGzGwxyLqA5Sv1oMqI2cgFSdeflx4IlN
         VuzWjJeY2Ll7M1v5vUZSadjAVtTH5vm3hKQ6zb516adgO8Zz/ST/hEgNrKyNzoML7CVT
         7PGG/EFkT2qYK+AX6xCbo76PKWEwr8nm11IccldIn/F+K4EN4RhHHTgovJ7RxvdLo8MQ
         EBcRRtq8rxMVwvNAKeBfzSfHhw9+W7Z/eYTI2VIBjEo45JCWAGX4I6jbIaT3Y4zjUblo
         k12d3/uLrSRF33X+9sb2cIIkpAXihl4bwO3IjFehp+iyxv2Vprv9gkFdnbxRRA8bowLx
         c8Lw==
X-Gm-Message-State: AOAM533LAqVXdgBcFlwM98Mm2ub++sUOUAlLYxVtaBUlsbkUUrfH5aMM
        jDB040/aINWmur8322uAUdNQF3/51w0RBTSkN+/2fbUluMwdp/kGjXVMRVRd8fsTdAEJ2rf0ff+
        dRActumWle3zQo5MRvY4=
X-Received: by 2002:a1c:6402:: with SMTP id y2mr5001096wmb.116.1589561016753;
        Fri, 15 May 2020 09:43:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFtEfMXi3WHMJy0JGzZn/KEegDKNW/cxg9Zad2FDxUFAUJG/bG7UmiYrCIoZuvhMR8U4rmNA==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr5001085wmb.116.1589561016555;
        Fri, 15 May 2020 09:43:36 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id v126sm4512322wmb.4.2020.05.15.09.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:43:35 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 3/5] Add helpers to set and get eventfd notification status
Date:   Fri, 15 May 2020 18:43:29 +0200
Message-Id: <20200515164331.236868-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515164331.236868-1-sgarzare@redhat.com>
References: <20200515164331.236868-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds the new IORING_CQ_EVENTFD_DISABLED flag. It can be
used to disable/enable notifications from the kernel when a
request is completed and queued to the CQ ring.

We also add two helpers function to check if the notifications are
enabled and to enable/disable them.

If the kernel doesn't provide CQ ring flags, the notifications are
always enabled if an eventfd is registered.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 src/include/liburing.h          | 30 ++++++++++++++++++++++++++++++
 src/include/liburing/io_uring.h |  7 +++++++
 2 files changed, 37 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index ea596f6..fe03547 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -9,7 +9,9 @@ extern "C" {
 #include <sys/socket.h>
 #include <sys/uio.h>
 #include <sys/stat.h>
+#include <errno.h>
 #include <signal.h>
+#include <stdbool.h>
 #include <inttypes.h>
 #include <time.h>
 #include "liburing/compat.h"
@@ -445,6 +447,34 @@ static inline unsigned io_uring_cq_ready(struct io_uring *ring)
 	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
 }
 
+static inline int io_uring_cq_eventfd_enable(struct io_uring *ring,
+					     bool enabled)
+{
+	uint32_t flags;
+
+	if (!ring->cq.kflags)
+		return -ENOTSUP;
+
+	flags = *ring->cq.kflags;
+
+	if (enabled)
+		flags &= ~IORING_CQ_EVENTFD_DISABLED;
+	else
+		flags |= IORING_CQ_EVENTFD_DISABLED;
+
+	IO_URING_WRITE_ONCE(*ring->cq.kflags, flags);
+
+	return 0;
+}
+
+static inline bool io_uring_cq_eventfd_enabled(struct io_uring *ring)
+{
+	if (!ring->cq.kflags)
+		return true;
+
+	return !(*ring->cq.kflags & IORING_CQ_EVENTFD_DISABLED);
+}
+
 static int __io_uring_peek_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr)
 {
 	struct io_uring_cqe *cqe;
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 602bb0e..8c5775d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
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

