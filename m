Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6432F376896
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbhEGQYK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238107AbhEGQYH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:24:07 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B423C061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:23:06 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id t11-20020a05600c198bb02901476e13296aso5233649wmq.0
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+HjmTjItkKD5DVylfrXyyIh0/kRLKW1JuYFqhX7VTSg=;
        b=J/CDoGJuL4qm5YaFfVr9XmLhjPkF9N0a++A1GGonQvsWlA1Q8qXcyy8s2Nwqgclfx8
         0DmqJlfaA+WZ8LCBBmdQ0fjmaJ/YrzJYVwvsb3iCuovPbFRWi30un4p7xSTEjNSMf9eq
         n/o93n//BC4ZDPnlgGZ/VLyv65sy+bJh+mjbLBLJucNSwwTLGPa4RjWX+M1bVmwOPHCC
         hBxQGrSb+/OcJJXLJxWwXjUzDeHNPJCqeEx0HBkcYzopFeKSsd/p+JVaEPqLPU8PTQO7
         7yNYskpXwFraVOUYGINJkb7PerqeOvjAuvK5HiJx/+skfBqdk5F9k0VXsVy78rC35u1+
         Q1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+HjmTjItkKD5DVylfrXyyIh0/kRLKW1JuYFqhX7VTSg=;
        b=hS093nP9C67cMdDjpF4M9ZJIxI+TgpKrfOCK5duVvYT+Bmm0YnDp9egXWQlA3VwCKq
         Dc01yXcNZkcnjRGnYPu/dzJWuRbMJ07bqNGa7q9Jn7cSEzl0aoZwoIlFpjzgv7Vxox+i
         d+R7FS54dG9FcHsvCUwnPbHHVCSDxYGRls1WM/Is22keDdrQwiwA56uW1UFBXZKGf5d6
         Fa50GbrxNaaf+fdmfPNCr2My1ZsayrZsHgL68qUnws8pMwDzlBS1SiXGOtXZEzILMHgs
         AMHkCtR4hvbisTWfSDoHZFXAFwAmo+u11X/OK7B7EpFKaBOlrwMFTSweMPZo7d3A5Vrk
         Mqsw==
X-Gm-Message-State: AOAM5330S8tsQka/vvz495+CjWd306GiiHaV47CixuWewKE1MIgcUt5x
        Z5FoOZQcxf2GnCWi3uNs6nryirh0jC8=
X-Google-Smtp-Source: ABdhPJw0Sa+vvvK+vLq8aMsd3+PucDUk74LlPu1SgFgnWYM1CRvGtynzKmqlzpS5BKyQ187kPyKzZQ==
X-Received: by 2002:a1c:6503:: with SMTP id z3mr10823561wmb.72.1620404585439;
        Fri, 07 May 2021 09:23:05 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id w4sm8765630wrl.5.2021.05.07.09.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:23:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/4] sync io_uring.h API file with Linux 5.13
Date:   Fri,  7 May 2021 17:22:48 +0100
Message-Id: <bcbe41f61f22d500b30d64335bdd74f249e64d40.1620404433.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620404433.git.asml.silence@gmail.com>
References: <cover.1620404433.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add resource tagging and registation and multi-polling definitions, and
align space/tabs with the kernel.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 41 ++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index eed991d..5a3cb90 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -168,16 +168,16 @@ enum {
  * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
  * command flags for POLL_ADD are stored in sqe->len.
  *
- * IORING_POLL_ADD_MULTI        Multishot poll. Sets IORING_CQE_F_MORE if
- *                              the poll handler will continue to report
- *                              CQEs on behalf of the same SQE.
+ * IORING_POLL_ADD_MULTI	Multishot poll. Sets IORING_CQE_F_MORE if
+ *				the poll handler will continue to report
+ *				CQEs on behalf of the same SQE.
  *
- * IORING_POLL_UPDATE           Update existing poll request, matching
- *                              sqe->addr as the old user_data field.
+ * IORING_POLL_UPDATE		Update existing poll request, matching
+ *				sqe->addr as the old user_data field.
  */
-#define IORING_POLL_ADD_MULTI   (1U << 0)
-#define IORING_POLL_UPDATE_EVENTS       (1U << 1)
-#define IORING_POLL_UPDATE_USER_DATA    (1U << 2)
+#define IORING_POLL_ADD_MULTI	(1U << 0)
+#define IORING_POLL_UPDATE_EVENTS	(1U << 1)
+#define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
 /*
  * IO completion data structure (Completion Queue Entry)
@@ -192,8 +192,10 @@ struct io_uring_cqe {
  * cqe->flags
  *
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
+ * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
+#define IORING_CQE_F_MORE		(1U << 1)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,
@@ -301,6 +303,8 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_REGISTER_RSRC			= 13,
+	IORING_REGISTER_RSRC_UPDATE		= 14,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -313,12 +317,33 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+enum {
+	IORING_RSRC_FILE		= 0,
+	IORING_RSRC_BUFFER		= 1,
+};
+
+struct io_uring_rsrc_register {
+	__u32 type;
+	__u32 nr;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+};
+
 struct io_uring_rsrc_update {
 	__u32 offset;
 	__u32 resv;
 	__aligned_u64 data;
 };
 
+struct io_uring_rsrc_update2 {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+	__u32 type;
+	__u32 nr;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.31.1

