Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65AEB18C53D
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 03:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgCTCW0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 22:22:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43340 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbgCTCWZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 22:22:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id u12so2290346pgb.10
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 19:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fbheEg10SbUTsjAqjhSAuNozu2FF30lIAVOK4ONpdZ4=;
        b=xTQQ11RmtPmCWNmJskDGv4tA1MlIOc+CflXD2aL1EifyklT9w15HmB057mjfVUvPie
         6uW4cIJWFKu5Qn6r+6J+PvhcLwSFKeHCiaQX4qdQtGqppmZgXYulrZdNjeyZtz9aXV0r
         9B+JzPdkEeFvSX0wkKnAG356GeKGi+461RyhrH9zSZpDs36i+rHzkoHCkEWSuEx74n94
         N75THLebFC6KMc+SORwZGkYIQdiuG+U/nHjs2jNhzXsEcsT3Bmwfn46P07i0Y6TMBCwU
         3Tc4y77m5SidLzzKfLcxGIy4Ilb+K3wG7ctSV99FKGzMwffLbyUfep86J0P2krCqwyId
         RuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fbheEg10SbUTsjAqjhSAuNozu2FF30lIAVOK4ONpdZ4=;
        b=KReqNQrymZztDFUynaLcENNWuVikkcQsXp2KCpMP3KYNNMdIeXiyyAW89Wvy4IeRV/
         oa+8soSpzK0eDJITO5fkIs1iT07nT9NnYptehr+aQ4ReV3yXg5P4Amf/ri6PNB/jpR1B
         GIWYt62oT4n9O1osQzePh7GexjUnaCmIM31jQ6AAq9FYc4+EeM7oAJvdGS2eK3qjxap6
         AL+rnnkTH5eecxCPfmtGAUttBu2DHKm5uiYZqK0w4gBCt30OD8Tjbzz3dJ9p+C6/h7bH
         BuY7lz3xfY//SgtgbadhuCF+fYlQtO2baLfJck6EMCwj5bmHbO43HgwSot3lNhtVNzDE
         X6Zw==
X-Gm-Message-State: ANhLgQ10PcEOdAvJdLT60z7cmJIe/uoMFWeEZk/D8UrlvlfskjKPlMLn
        bn1yPnqaK5KryzDdIcVXH0BFc+/Wrd42ww==
X-Google-Smtp-Source: ADFU+vs8Pin1GVlzywK6sDOHdXesbckgeoc9cYroBZtHto9jRv68GR/p6ElJfxGFFkRmo2G6UaEO/Q==
X-Received: by 2002:a62:19d8:: with SMTP id 207mr7383918pfz.278.1584670944511;
        Thu, 19 Mar 2020 19:22:24 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id mq18sm3423993pjb.6.2020.03.19.19.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:22:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH 1/2] io_uring: make sure openat/openat2 honor rlimit nofile
Date:   Thu, 19 Mar 2020 20:22:15 -0600
Message-Id: <20200320022216.20993-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200320022216.20993-1-axboe@kernel.dk>
References: <20200320022216.20993-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dmitry reports that a test case shows that io_uring isn't honoring a
modified rlimit nofile setting. get_unused_fd_flags() checks the task
signal->rlimi[] for the limits. As this isn't easily inheritable,
provide a __get_unused_fd_flags() that takes the value instead. Then we
can grab it when the request is prepared (from the original task), and
pass that in when we do the async part part of the open.

Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/file.c            | 7 ++++++-
 fs/io_uring.c        | 5 ++++-
 include/linux/file.h | 1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index a364e1a9b7e8..c8a4e4c86e55 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -540,9 +540,14 @@ static int alloc_fd(unsigned start, unsigned flags)
 	return __alloc_fd(current->files, start, rlimit(RLIMIT_NOFILE), flags);
 }
 
+int __get_unused_fd_flags(unsigned flags, unsigned long nofile)
+{
+	return __alloc_fd(current->files, 0, nofile, flags);
+}
+
 int get_unused_fd_flags(unsigned flags)
 {
-	return __alloc_fd(current->files, 0, rlimit(RLIMIT_NOFILE), flags);
+	return __get_unused_fd_flags(flags, rlimit(RLIMIT_NOFILE));
 }
 EXPORT_SYMBOL(get_unused_fd_flags);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index b1fbc4424aa6..fe5ded7c74ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -397,6 +397,7 @@ struct io_open {
 	struct filename			*filename;
 	struct statx __user		*buffer;
 	struct open_how			how;
+	unsigned long			nofile;
 };
 
 struct io_files_update {
@@ -2577,6 +2578,7 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -2618,6 +2620,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -2636,7 +2639,7 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret)
 		goto err;
 
-	ret = get_unused_fd_flags(req->open.how.flags);
+	ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
 	if (ret < 0)
 		goto err;
 
diff --git a/include/linux/file.h b/include/linux/file.h
index c6c7b24ea9f7..142d102f285e 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -85,6 +85,7 @@ extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
+extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
 
-- 
2.25.2

