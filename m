Return-Path: <io-uring+bounces-252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE7680716F
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 14:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14DB5281A16
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 13:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C850B3C46C;
	Wed,  6 Dec 2023 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5Kycxyx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7C412B;
	Wed,  6 Dec 2023 05:58:45 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2c9fe0b5b28so48661441fa.1;
        Wed, 06 Dec 2023 05:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701871123; x=1702475923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ysehmX4Pt24WsrUEQ3QJu+I81wy32Tt8NuJKvK6AdqQ=;
        b=C5KycxyxaOvlRSfGwcNQUGmA5kgnc4bVcA4ljNUbe9fFjTpYSMTWH7uVwmh5wqithu
         /cSG7Pbo4Gn+Qe4N2ajssAja1CLQWaz1fprwbCKadUQfIYqsjUxwY9OSNS2YTZDslZF+
         geuAUSV/JLmLjYKxVJj4dg4YDluo1a6HfsmKWBIC1qKloZxyG/PQvfFicMuFwE+cokqf
         Bdsqv/eILGcg5A6P60XFxpavFk35pukP+lINBew7CU+6tGcE5HpdL4mWv0e1kVIk7Ho5
         VA5/687IuLMeD5W47yf5q2KRw8KO9v5ZlpwZiIrb6ehrEeAILabMiHapodb5MWQMEVln
         5nHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701871123; x=1702475923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ysehmX4Pt24WsrUEQ3QJu+I81wy32Tt8NuJKvK6AdqQ=;
        b=iM2B6DYdbWqVKQ6c3kyssa/o7pPgFtpd7TMZOoO5zXIKCp3xpCijuht1bzIHotgDV+
         8rbxjMqYnaFHlAGm/rkgmfSrxGF2d6fZJr9bk53tNHd+OjlDHFgtIksjSnUobobnKNHZ
         0hjtKF+l/dfiyhHEM1zvmGuUCPQHLY9hKHwzKdYrdcCo8EoZn/sfcnWm4ZMCL2Ba2gAq
         6UXaGgdPOl51rjmlaIewEYM6Fc9d+CVuJhR104N1SC90rT5WHkXbkpj65YZdSLlt6DKR
         ilraU1699WP4t7ls6CsukjEcas3BBbnTz/w1R2Vu8yPLdxbaoabnPRmf1fTE/gLsM1Rx
         Tiwg==
X-Gm-Message-State: AOJu0Yw0j8zfAug/tiACR35bfhgGumiA6vjr6x7pIH0+2dDZwrauG14C
	zpfRpg20mHeq2GSpAQt0UJ8wkILv2R0=
X-Google-Smtp-Source: AGHT+IHIJ4rzxIE3cF1KqRrszjBGmYzbzhE3snj7i/rSEsicZWKt3h3Qn5xDOdTY1dk+XIf0oZZXrQ==
X-Received: by 2002:a05:651c:204:b0:2c9:ffbb:34fd with SMTP id y4-20020a05651c020400b002c9ffbb34fdmr696685ljn.12.1701871122704;
        Wed, 06 Dec 2023 05:58:42 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:15ce])
        by smtp.gmail.com with ESMTPSA id m23-20020a1709061ed700b00a1ddf81b4ffsm624546ejj.207.2023.12.06.05.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 05:58:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	jannh@google.com,
	davem@davemloft.net,
	kuba@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH RESEND] io_uring/af_unix: disable sending io_uring over sockets
Date: Wed,  6 Dec 2023 13:55:19 +0000
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


