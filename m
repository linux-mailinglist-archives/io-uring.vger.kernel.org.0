Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3DB52720D
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiENOfY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiENOfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:35:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C1F1FCDF
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e24so10497053pjt.2
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SCjl+YC+JNe7Q33BVVsOysWmiV2FuA+j2DYhAMrotF8=;
        b=ONfgolvi2DASS3lj93zU62f9+c+uDBT501dG90coaEDzFbKILspA6Qo++gqlI/c1Ax
         e9auEOleqmTww7+kyd2WxzcdKr8QYlxdqDoLcePjR4C6tTZQ0F6U74e6xAt0YTvA6tEC
         0fkeGP74J3Gc7Zo8gxJwRzPDgoPbLmrE9BSMthB3US7WwscILEyW6I53aAIp2Px2pE7m
         6gF3Zv68H0aAcYokuc5avOaoTu9+/YbrPwBK0jmahcbjRdCfs2j7qMeN7LcXg+9mG1JE
         9Lp66WmLmdxykwwq4oLf1pDRtgAv3tqrMUGDEz1rJb8HGNTf8cfgHqwGraTsupHoOcoL
         qgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCjl+YC+JNe7Q33BVVsOysWmiV2FuA+j2DYhAMrotF8=;
        b=Futn433xi5bSZUfL6YJSVQfMswftzvRnMUVJh8kH7cz5uvvbyAwQ4ZNaGsNqNptEfd
         +SHMzzLfpcXCwcfLvKABOU7WI4tdDwx7Jd1arrHlSYlxmvvSh6worVzgcQd4Yv8xMayS
         ZT3q/xqXtvFBbWxb4YM4iLZ217mAUXWGQaNjjjjZGPvzIUt5TdmzbC0lxCBBP9LV22t3
         9PWU0GsROnAtRhioZWSAoadgKgdVDXxKUbBKErwSwD9AGf0O+FKwTv5kk7kcnhHWYI2f
         w2YBBJrNrWgO5Vaj839wWdYAcyRGKC5Azki94jYL1C3evON1cEubf1VpjF64fWDmr1++
         8LuQ==
X-Gm-Message-State: AOAM531WkFiovq+Aq/uUjZzNYQqflGMBqfwL8weEowAXCZH81+V8ZYYd
        VLHQTBrWw28LiaSao5dXCDFzfFd079ZPeTXC
X-Google-Smtp-Source: ABdhPJwqLPsAljKSeA5KbV2r1DRM9YlYGQNxplrbuW53jdX+EelLCKESzV5oJ8G+Rmo+eEEloI3gEQ==
X-Received: by 2002:a17:90b:350d:b0:1dc:6680:6f1d with SMTP id ls13-20020a17090b350d00b001dc66806f1dmr21395597pjb.27.1652538920429;
        Sat, 14 May 2022 07:35:20 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015ea95948ebsm3762179plj.134.2022.05.14.07.35.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:35:20 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/6] liburing.h: support multishot accept
Date:   Sat, 14 May 2022 22:35:30 +0800
Message-Id: <20220514143534.59162-3-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514143534.59162-1-haoxu.linux@gmail.com>
References: <20220514143534.59162-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new api to leverage the multishot mode accept, this feature is to
achieve one accept request for all listened events.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 src/include/liburing.h          | 10 ++++++++++
 src/include/liburing/io_uring.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 5c03061388aa..cf50383c8e63 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -502,6 +502,16 @@ static inline void io_uring_prep_accept_direct(struct io_uring_sqe *sqe, int fd,
 	__io_uring_set_target_fixed_file(sqe, file_index);
 }
 
+static inline void io_uring_prep_multishot_accept(struct io_uring_sqe *sqe,
+						  int fd, struct sockaddr *addr,
+						  socklen_t *addrlen, int flags)
+{
+	io_uring_prep_rw(IORING_OP_ACCEPT, sqe, fd, addr, 0,
+				(__u64) (unsigned long) addrlen);
+	sqe->accept_flags = (__u32) flags;
+	sqe->ioprio |= IORING_ACCEPT_MULTISHOT;
+}
+
 static inline void io_uring_prep_cancel(struct io_uring_sqe *sqe,
 					__u64 user_data, int flags)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index bfb3548fff96..46765d2697ba 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -434,6 +434,11 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+/*
+ * accept flags stored in sqe->ioprio
+ */
+#define IORING_ACCEPT_MULTISHOT	(1U << 0)
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.36.0

