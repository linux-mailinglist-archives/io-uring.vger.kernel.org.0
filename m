Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BE453F7D5
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 10:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiFGIGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 04:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238000AbiFGIGo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 04:06:44 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A8B82DA;
        Tue,  7 Jun 2022 01:06:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654589198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klVOdmR1nU7hPRaqNMeN8/4eylLm3n3KJl/eiNUtm0o=;
        b=HxqJGVj9AWEXmaTuJYwqAghzOqYCKWtZjzq5XUfX8XIfvgZzRHJak4kUBr4KLoGXwbNuVJ
        DqnaAk8Y4CnHz8rU7nit+jqCQnVERRBvVKhH0zyeFrVyLXchdffcqg8P2nzsDIkQYd6WOK
        9BmlK2+vbR9mEjoN20otm7nkxGZmFds=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH 2/5] pipe: add trylock helpers for pipe lock
Date:   Tue,  7 Jun 2022 16:06:16 +0800
Message-Id: <20220607080619.513187-3-hao.xu@linux.dev>
In-Reply-To: <20220607080619.513187-1-hao.xu@linux.dev>
References: <20220607080619.513187-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add two helpers pipe_trylock() and pipe_double_trylock(), they are used
in nonblock splice(pipe to pipe) scenario in next patches.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/pipe.c                 | 29 +++++++++++++++++++++++++++++
 include/linux/pipe_fs_i.h |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index 74ae9fafd25a..033736eb61fb 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -98,6 +98,11 @@ void pipe_unlock(struct pipe_inode_info *pipe)
 }
 EXPORT_SYMBOL(pipe_unlock);
 
+int pipe_trylock(struct pipe_inode_info *pipe)
+{
+	return mutex_trylock(&pipe->mutex);
+}
+
 static inline void __pipe_lock(struct pipe_inode_info *pipe)
 {
 	mutex_lock_nested(&pipe->mutex, I_MUTEX_PARENT);
@@ -122,6 +127,30 @@ void pipe_double_lock(struct pipe_inode_info *pipe1,
 	}
 }
 
+int pipe_double_trylock(struct pipe_inode_info *pipe1,
+			 struct pipe_inode_info *pipe2)
+{
+	BUG_ON(pipe1 == pipe2);
+
+	if (pipe1 < pipe2) {
+		if (!pipe_trylock(pipe1))
+			return 0;
+		if (!pipe_trylock(pipe2)) {
+			pipe_unlock(pipe1);
+			return 0;
+		}
+	} else {
+		if (!pipe_trylock(pipe2))
+			return 0;
+		if (!pipe_trylock(pipe1)) {
+			pipe_unlock(pipe2);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
 static void anon_pipe_buf_release(struct pipe_inode_info *pipe,
 				  struct pipe_buffer *buf)
 {
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index cb0fd633a610..78dc2c7c999f 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -235,8 +235,10 @@ static inline bool pipe_buf_try_steal(struct pipe_inode_info *pipe,
 
 /* Pipe lock and unlock operations */
 void pipe_lock(struct pipe_inode_info *);
+int pipe_trylock(struct pipe_inode_info *);
 void pipe_unlock(struct pipe_inode_info *);
 void pipe_double_lock(struct pipe_inode_info *, struct pipe_inode_info *);
+int pipe_double_trylock(struct pipe_inode_info *, struct pipe_inode_info *);
 
 /* Wait for a pipe to be readable/writable while dropping the pipe lock */
 void pipe_wait_readable(struct pipe_inode_info *);
-- 
2.25.1

