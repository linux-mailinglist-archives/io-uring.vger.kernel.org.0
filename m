Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B5D5507F3
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 04:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiFSCH2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 22:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiFSCHV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 22:07:21 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7006357
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:21 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e63so5767792pgc.5
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yv80EaGMevOd0EuZa7EL3jvvNdNnZ4kzHEkhSFcBaU8=;
        b=5qVv5YkGGVF3DMT5SdkY7+ZDHmplg1YTMCeSV/jWWUj/xYhpNe5XoSRUJrrMPjjfr5
         jUUfPuU3r2obt2cXxW34Ikttarvwlx1RigZn53hgkLPaaqutIt5zSKSq1G6lP+kLQhrD
         5mMCOEoXDSFmQEYPfL49EFse7RrA0CK7oYwMtIOtpOpfc2n4rdTPuVfZhDzrh64r3Hgc
         JTgEqNARwuHZ0J/kg/XlnUGqO2LBGGNXnEBR78K2fPwtI4sli42t2yJMbAkx6EzIddgP
         3fYVbG+qqpZQiA2YZ5q8fiqzWtl1xMy2czR0IdI1c8+MZQFSHE6Do6x6uLyXOpFibC+O
         lgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yv80EaGMevOd0EuZa7EL3jvvNdNnZ4kzHEkhSFcBaU8=;
        b=uj1T7IFqT02mWuMCJYp5n3t9kzhEQhTIXIaC+O2wP5Gt1kxY3eWPPYr0nPkeNtDFK6
         6J+gfimN3DxEHY4tZAxICuySCvrXIFdH99wKGo66YfnMR5DNlZsT+F/TqjljtLIf9Clr
         OyuW/XKp/MpBybWGvuzXXXXIq9lIAUsfEvh9fdLpf/scXpQRRZjx+MH/dQtykMtcLEBO
         jACQ5YRHt46Cr8a5DgAn8yV5GIIjsDf/jecc67BIosCt1NKjOd50rwrMuW0Gy8INSqq5
         sonQz/feh+4M2iePXel6bLDmOai09PcEvyTYQgeRt25/86x53GT1HuNVvDscW5RJdFkf
         olkg==
X-Gm-Message-State: AJIora990F+mV7HA285ii9ppEvVt8VPe5IzUIf9Zy4m7nxIaXlVPD8Df
        EF3lhcfbvZVnP77baa/Cz8xQtrAA4M6sow==
X-Google-Smtp-Source: AGRyM1vO6HI/CP776uSaTlLma2fYLIzsNCXmUF1ag7tqRu185Mh+XhDebzpzosmy+GG2zCH0GY/3Fw==
X-Received: by 2002:a63:d949:0:b0:408:870f:70d1 with SMTP id e9-20020a63d949000000b00408870f70d1mr15682446pgj.620.1655604440214;
        Sat, 18 Jun 2022 19:07:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b0051c7038bd52sm6118598pfn.220.2022.06.18.19.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 19:07:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, carter.li@eoitek.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: add IORING_ASYNC_CANCEL_FD_FIXED cancel flag
Date:   Sat, 18 Jun 2022 20:07:14 -0600
Message-Id: <20220619020715.1327556-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220619020715.1327556-1-axboe@kernel.dk>
References: <20220619020715.1327556-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for not having a request to pass in that carries this
state, add a separate cancelation flag that allows the caller to ask
for a fixed file for cancelation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 2 ++
 io_uring/cancel.c             | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8715f0942ec2..d69dac9bb02c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -244,10 +244,12 @@ enum io_uring_op {
  * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
  *				request 'user_data'
  * IORING_ASYNC_CANCEL_ANY	Match any request
+ * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
+#define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->addr2)
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 500ee5f5fd23..da486de07029 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -24,7 +24,7 @@ struct io_cancel {
 };
 
 #define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
-			 IORING_ASYNC_CANCEL_ANY)
+			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED)
 
 static bool io_cancel_cb(struct io_wq_work *work, void *data)
 {
@@ -174,11 +174,14 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	if (cd.flags & IORING_ASYNC_CANCEL_FD) {
-		if (req->flags & REQ_F_FIXED_FILE)
+		if (req->flags & REQ_F_FIXED_FILE ||
+		    cd.flags & IORING_ASYNC_CANCEL_FD_FIXED) {
+			req->flags |= REQ_F_FIXED_FILE;
 			req->file = io_file_get_fixed(req, cancel->fd,
 							issue_flags);
-		else
+		} else {
 			req->file = io_file_get_normal(req, cancel->fd);
+		}
 		if (!req->file) {
 			ret = -EBADF;
 			goto done;
-- 
2.35.1

