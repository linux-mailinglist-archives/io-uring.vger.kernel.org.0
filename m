Return-Path: <io-uring+bounces-250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EAA8070E9
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 14:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E21B1F2142F
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 13:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B09134553;
	Wed,  6 Dec 2023 13:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQL+qM4s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28879122
	for <io-uring@vger.kernel.org>; Wed,  6 Dec 2023 05:29:55 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-50bf26f8988so4870512e87.2
        for <io-uring@vger.kernel.org>; Wed, 06 Dec 2023 05:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701869393; x=1702474193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ysehmX4Pt24WsrUEQ3QJu+I81wy32Tt8NuJKvK6AdqQ=;
        b=dQL+qM4sm/uw5RBTX73bjHvHORjgbRpam9pHyJN1MZRzMrxqdSbvHTH0VlcEb3I+OE
         mJo/e5j8P+2IdH42HPOWA9rDP1ZGgW/PUMEKKy5Ud1RePXwEHD+aDRB3DLuwuhOseH5L
         S5V3brtR4R8kEtpo+E+zB7hbFiA78FD2h5bmLdzbNRVTpRnC89akayW56ysGX7pNowIz
         1J4KJOlwHnsPatQ2Gn8YNs6XOKjKho/79OlUf3wbquDY5uGvKEhvkUSasBz7+JmRHtvC
         qfq6dpgH/iyc4gmNg0aCpoXom+26VFP4c/L7zx78TfWWosmiziI19fFYpHIi5V/+hPtp
         0tag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701869393; x=1702474193;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ysehmX4Pt24WsrUEQ3QJu+I81wy32Tt8NuJKvK6AdqQ=;
        b=IFFhN4c0Iig4Q9+6sGXRXqUawGFdXBuQHa4kJeQY+fJejLS8yisis5paij3Z9X+85T
         TNvYfE3/FpVtx5SvNUJvWDpXWJYlnAcribyJRr/KoHrTO5tOG1xUQWxWWqIzYIH41QKW
         zf/Z69xuoEqsVbboV5QaBHAmmsSZTBdDgCYfKzKvFGZTFgqvDZ5WIN/XHObkrwU5Yepx
         c7MDTJchzhLNFJ3ITvmLHmG12IW9nJEEAPFgYZY5WMSPD9XnzQECr9feddAZtcUOoNen
         qnybouCgPLtzGtLPUDWO1i63BNjnDd9nOEQoo0hO7XYJubVtGCYT673ChnvzggUwwKV9
         387Q==
X-Gm-Message-State: AOJu0YzjhKVaeh7rGRTqCCUrSuwCBmflEJCaZ4NQpPiBPFH9dIYQkO5d
	fjIXe5efzPgx2PHH2+B2zoXE2S1vVmU=
X-Google-Smtp-Source: AGHT+IHWj1yYCreHfdsfyOwIHBQQ1IxH2ewW01g9Jb1lNJRWewMDD/whc8VoIZPhxh7AJ/K9EeheMQ==
X-Received: by 2002:a19:7018:0:b0:50b:c24d:9284 with SMTP id h24-20020a197018000000b0050bc24d9284mr592119lfc.49.1701869392926;
        Wed, 06 Dec 2023 05:29:52 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:15ce])
        by smtp.gmail.com with ESMTPSA id y10-20020a056402134a00b0054c86f882bcsm2416561edw.22.2023.12.06.05.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 05:29:52 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	jannh@google.com
Subject: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over sockets
Date: Wed,  6 Dec 2023 13:26:47 +0000
Message-ID: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

File reference cycles have caused lots of problems for io_uring
in the past, and it still doesn't work exactly right and races with
unix_stream_read_generic(). The safest fix would be to completely
disallow sending io_uring files via sockets via SCM_RIGHT, so there
are no possible cycles invloving registered files and thus rendering
SCM accounting on the io_uring side unnecessary.

Cc: stable@vger.kernel.org
Fixes: 0091bfc81741b ("io_uring/af_unix: defer registered files gc to io_uring release")
Reported-and-suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Note, it's a minimal patch intended for backporting, all the leftovers
will be cleaned up separately.

 io_uring/rsrc.h | 7 -------
 net/core/scm.c  | 6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8625181fb87a..08ac0d8e07ef 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -77,17 +77,10 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file);
 
-#if defined(CONFIG_UNIX)
-static inline bool io_file_need_scm(struct file *filp)
-{
-	return !!unix_get_socket(filp);
-}
-#else
 static inline bool io_file_need_scm(struct file *filp)
 {
 	return false;
 }
-#endif
 
 static inline int io_scm_file_account(struct io_ring_ctx *ctx,
 				      struct file *file)
diff --git a/net/core/scm.c b/net/core/scm.c
index 880027ecf516..7dc47c17d863 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -26,6 +26,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/errqueue.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 
@@ -103,6 +104,11 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 
 		if (fd < 0 || !(file = fget_raw(fd)))
 			return -EBADF;
+		/* don't allow io_uring files */
+		if (io_uring_get_socket(file)) {
+			fput(file);
+			return -EINVAL;
+		}
 		*fpp++ = file;
 		fpl->count++;
 	}
-- 
2.43.0


