Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16571DBABA
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 19:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgETRHg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 13:07:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20387 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726881AbgETRHY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 13:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O9d7VWgOSe/qjvNlnDodBcvOOgqJg891hEBMUAOJFSc=;
        b=P+WUAfrw1q7no8m7wyX+5Bb9RHLExdbBDVgwvaxwiu6ShBCna9l+1hYO3VugHQb3O5WLGW
        PcHkzdY/t0E25TpJBO16v8BL7hLGIs4IzQipbv7qv9a0SgOnLyOzSbtjLGMOhJDCdnUDs1
        /5f61P8oKJl1gkmx/fJElNy4N23QAU0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-b9ttIF78MPmya4YqMPloLA-1; Wed, 20 May 2020 13:07:21 -0400
X-MC-Unique: b9ttIF78MPmya4YqMPloLA-1
Received: by mail-wr1-f72.google.com with SMTP id p13so1672503wrt.1
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 10:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9d7VWgOSe/qjvNlnDodBcvOOgqJg891hEBMUAOJFSc=;
        b=IVsYURFSOUuxY44TUAZXfb5x8t+LHT+Hc5iYislbk57tj/uHcXGlcuLKcavvgO13uW
         BVQUjD6v0x/k0N8SB5FXCO2sRUe6gILk24cqHuVkcsvMPDvfu2B012fEBui8HThMSY5Z
         obWCZ3Ukr4EJSLF9AMi2lb59H9hgGdjbzR0vXXrmuTanxDAUIkrhYfMV1sJuxWXFU73/
         FrHGRS8O1N9YXBpXRWtknIRqm+NS9ndaB6/WJIrl2NcZMUKbDDTldogPtxitDuE83Y/2
         YmSwaam1eCDttx0yAINofrQ09jiNguiDjlyDzhlYWDN00E/v1UX+W7SzoI15+KGZYGe9
         mz2w==
X-Gm-Message-State: AOAM53395AVyebHZhykaBYPMB06/me5kWMKuFvHW7Ll7SsEurfllU1Qn
        OLnMAlikr/bYlEA0/Is7zj7cnHS4pc4VvU8mI6RXfFT/G95t7DkdZO/TdqRa9Uc8aUE6Dt0XVje
        vOiR9sCdeK6ZPMFcJtzQ=
X-Received: by 2002:a1c:7515:: with SMTP id o21mr5343856wmc.52.1589994440013;
        Wed, 20 May 2020 10:07:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwP/KAxcq+j3CuGhNdzPkxWKaWxRgPtfGdNQFk2DNOJ7uQe76sv4GxyNOb9EzJKk680RI+xFA==
X-Received: by 2002:a1c:7515:: with SMTP id o21mr5343843wmc.52.1589994439789;
        Wed, 20 May 2020 10:07:19 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u74sm3768614wmu.13.2020.05.20.10.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:07:19 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 3/5] Add helpers to set and get eventfd notification status
Date:   Wed, 20 May 2020 19:07:12 +0200
Message-Id: <20200520170714.68156-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200520170714.68156-1-sgarzare@redhat.com>
References: <20200520170714.68156-1-sgarzare@redhat.com>
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
enabled and to toggle them.

If the kernel doesn't provide CQ ring flags, the notifications are
always enabled if an eventfd is registered.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v1 -> v2:
- renamed io_uring_cq_eventfd_toggle()
- return EOPNOTSUPP only if we need to change the flag
---
 src/include/liburing.h          | 33 +++++++++++++++++++++++++++++++++
 src/include/liburing/io_uring.h |  7 +++++++
 2 files changed, 40 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index adc8db9..0192b47 100644
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
@@ -445,6 +447,37 @@ static inline unsigned io_uring_cq_ready(struct io_uring *ring)
 	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
 }
 
+static inline bool io_uring_cq_eventfd_enabled(struct io_uring *ring)
+{
+	if (!ring->cq.kflags)
+		return true;
+
+	return !(*ring->cq.kflags & IORING_CQ_EVENTFD_DISABLED);
+}
+
+static inline int io_uring_cq_eventfd_toggle(struct io_uring *ring,
+					     bool enabled)
+{
+	uint32_t flags;
+
+	if (!!enabled == io_uring_cq_eventfd_enabled(ring))
+		return 0;
+
+	if (!ring->cq.kflags)
+		return -EOPNOTSUPP;
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
 /*
  * Return an IO completion, waiting for 'wait_nr' completions if one isn't
  * readily available. Returns 0 with cqe_ptr filled in on success, -errno on
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 9860a8a..92c2269 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -210,6 +210,13 @@ struct io_cqring_offsets {
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

