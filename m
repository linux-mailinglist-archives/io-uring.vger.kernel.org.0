Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918BE3A2F7D
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhFJPk4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 11:40:56 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:47083 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhFJPk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 11:40:56 -0400
Received: by mail-wm1-f43.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so6695693wmq.5
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 08:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YhIUR/cEe3W5Pbbpzn0l5xbHL0j5fOo/YUe/3Cj4wKg=;
        b=DeO0+bthKUf4IIqOMzS8c6AUG1cqe4FekU217kBshXPl+dodO6i2BruigJe3/fHsie
         PKteTWPg+hGiHNu11yFyJIfX01zmyaBhGdBmlW9jdK/HI6I3TK7gT8rQ4/pkdGJT0IQA
         RQZPrrWxXsEVnE3IjVs+rD33gCyL2ii2/m3J+SOIHaaPg5rtl2CpwAgQ4XgeSk+pp3tj
         Nr1ddNWBotswanQITnzGUq+zAenIXMrH/zx93D6SgpxxjcRFbaDadKA7w4rXLR82dEGp
         aoRJrrHM2pwaOHbrXgy1ogWwQ43Qa1+B9c3Cdpw2MH9iSBOR/iN5KTQQzxG1AqEzLXC8
         nv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YhIUR/cEe3W5Pbbpzn0l5xbHL0j5fOo/YUe/3Cj4wKg=;
        b=STxkq5krDyN9FjJXbWzsLViGXUz1kuZYfSbnOgUWFALhv2foViv1ZMfsC3nWg7b1Q0
         /uvKonKSZby+fpprcet4vCi9wtboJqEn3BtPMZOADCY/v2uj0N6LIs+4RASvMiZD0md2
         Ch6638+kduRb2NoXOTYZmmt4va0HIro9YOhInNS2lDr8NviWBYFFpFpOcKEh0KfHk8Z+
         Kr7ASX/Cls5ovcIXdoQ1/TK9bI7L/Jl0Qxp0XposGUDg/fbOswlC0m9UOF1zBO3BnpYX
         Gry/g1aG3jjejLSU0rVmMn29S67Hd4ilqC0UsnL5WAnFfqibHHqaB1XDHl6hXmKQQG5p
         HF1Q==
X-Gm-Message-State: AOAM533mYvy/jUrAVfMup88G+A6yc+4szgPq2LiwJs5Vp3htI8MD9vqE
        57fcgLjW/TmRpeozJxXQ48eEnjUNKdz6k0CE
X-Google-Smtp-Source: ABdhPJxO58xZlS7Df7CwztVWTMWSCBORm6p3XF75dgyrtvyjftNm/gvvKTiq1+elPI6T0KznGuWJ9w==
X-Received: by 2002:a7b:c38f:: with SMTP id s15mr16181827wmj.16.1623339479458;
        Thu, 10 Jun 2021 08:37:59 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id f184sm2388825wmf.38.2021.06.10.08.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:37:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: change registration/upd/rsrc tagging ABI
Date:   Thu, 10 Jun 2021 16:37:37 +0100
Message-Id: <9b554897a7c17ad6e3becc48dfed2f7af9f423d5.1623339162.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623339162.git.asml.silence@gmail.com>
References: <cover.1623339162.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are ABI moments about recently added rsrc registration/update and
tagging that might become a nuisance in the future. First,
IORING_REGISTER_RSRC[_UPD] hide different types of resources under it,
so breaks fine control over them by restrictions. It works for now, but
once those are wanted under restrictions it would require a rework.

It was also inconvenient trying to fit a new resource not supporting
all the features (e.g. dynamic update) into the interface, so better
to return to IORING_REGISTER_* top level dispatching.

Second, register/update were considered to accept a type of resource,
however that's not a good idea because there might be several ways of
registration of a single resource type, e.g. we may want to add
non-contig buffers or anything more exquisite as dma mapped memory.
So, remove IORING_RSRC_[FILE,BUFFER] out of the ABI, and place them
internally for now to limit changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 39 ++++++++++++++++++++++++-----------
 include/uapi/linux/io_uring.h | 18 ++++++++--------
 2 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42380ed563c4..663fef3d56df 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -783,6 +783,11 @@ struct io_task_work {
 	task_work_func_t	func;
 };
 
+enum {
+	IORING_RSRC_FILE		= 0,
+	IORING_RSRC_BUFFER		= 1,
+};
+
 /*
  * NOTE! Each of the iocb union members has the file pointer
  * as the first entry in their struct definition. So you can
@@ -9911,7 +9916,7 @@ static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 }
 
 static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
-				   unsigned size)
+				   unsigned size, unsigned type)
 {
 	struct io_uring_rsrc_update2 up;
 
@@ -9919,13 +9924,13 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (!up.nr)
+	if (!up.nr || up.resv)
 		return -EINVAL;
-	return __io_register_rsrc_update(ctx, up.type, &up, up.nr);
+	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
 
 static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
-			    unsigned int size)
+			    unsigned int size, unsigned int type)
 {
 	struct io_uring_rsrc_register rr;
 
@@ -9936,10 +9941,10 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&rr, 0, sizeof(rr));
 	if (copy_from_user(&rr, arg, size))
 		return -EFAULT;
-	if (!rr.nr)
+	if (!rr.nr || rr.resv || rr.resv2)
 		return -EINVAL;
 
-	switch (rr.type) {
+	switch (type) {
 	case IORING_RSRC_FILE:
 		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
 					     rr.nr, u64_to_user_ptr(rr.tags));
@@ -9961,8 +9966,10 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
-	case IORING_REGISTER_RSRC:
-	case IORING_REGISTER_RSRC_UPDATE:
+	case IORING_REGISTER_FILES2:
+	case IORING_REGISTER_FILES_UPDATE2:
+	case IORING_REGISTER_BUFFERS2:
+	case IORING_REGISTER_BUFFERS_UPDATE:
 		return false;
 	default:
 		return true;
@@ -10088,11 +10095,19 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_RESTRICTIONS:
 		ret = io_register_restrictions(ctx, arg, nr_args);
 		break;
-	case IORING_REGISTER_RSRC:
-		ret = io_register_rsrc(ctx, arg, nr_args);
+	case IORING_REGISTER_FILES2:
+		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_FILE);
+		break;
+	case IORING_REGISTER_FILES_UPDATE2:
+		ret = io_register_rsrc_update(ctx, arg, nr_args,
+					      IORING_RSRC_FILE);
+		break;
+	case IORING_REGISTER_BUFFERS2:
+		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_BUFFER);
 		break;
-	case IORING_REGISTER_RSRC_UPDATE:
-		ret = io_register_rsrc_update(ctx, arg, nr_args);
+	case IORING_REGISTER_BUFFERS_UPDATE:
+		ret = io_register_rsrc_update(ctx, arg, nr_args,
+					      IORING_RSRC_BUFFER);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e1ae46683301..48b4ddcd56ff 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -298,8 +298,12 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
-	IORING_REGISTER_RSRC			= 13,
-	IORING_REGISTER_RSRC_UPDATE		= 14,
+
+	/* extended with tagging */
+	IORING_REGISTER_FILES2			= 13,
+	IORING_REGISTER_FILES_UPDATE2		= 14,
+	IORING_REGISTER_BUFFERS2		= 15,
+	IORING_REGISTER_BUFFERS_UPDATE		= 16,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -312,14 +316,10 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
-enum {
-	IORING_RSRC_FILE		= 0,
-	IORING_RSRC_BUFFER		= 1,
-};
-
 struct io_uring_rsrc_register {
-	__u32 type;
 	__u32 nr;
+	__u32 resv;
+	__u64 resv2;
 	__aligned_u64 data;
 	__aligned_u64 tags;
 };
@@ -335,8 +335,8 @@ struct io_uring_rsrc_update2 {
 	__u32 resv;
 	__aligned_u64 data;
 	__aligned_u64 tags;
-	__u32 type;
 	__u32 nr;
+	__u32 resv2;
 };
 
 /* Skip updating fd indexes set to this value in the fd table */
-- 
2.31.1

