Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFF4162F79
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 20:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgBRTMU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 14:12:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38107 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRTMT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 14:12:19 -0500
Received: by mail-wr1-f65.google.com with SMTP id e8so2830878wrm.5
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 11:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=foKquxBAIMXjAR3tdf5BNsaZnzetsrzrXlbRi9LRBb4=;
        b=GPc6MYHJ6GXBCtvrhye9jZRqSj1WpTd083Qk8WXZdxGfK9Pf/Mnd8H7VSHyTws28bF
         QAfmIi+VydHG/fA2rh1ZcyFG1eptM+hn4PVIKzF26P1OdDGo5ZtcCyfkWyu5Zn0uzTi3
         aXLHL5AAW9iOs4oMY61+MqxIm9MgYcH6hHwPamNYL7pSHmPAn+aczothAyX7U+NEft3v
         mb13eWFZ2xe+4n6LDIJ6R0rncake3E0hwcfbKavoUf0uYtXnfzHxJr+1orofmVna/gQx
         QLLTTCOCh98obVYn8lkb92wt9qf3Tp+RAt9EcaCFOI0fBYYQ91Z1myKMNlJGTeOlTE+H
         6vbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foKquxBAIMXjAR3tdf5BNsaZnzetsrzrXlbRi9LRBb4=;
        b=VTr5/i/tM3I5Xm/3cGIU9cC0evIo23pHUKIPewkkFYjW9ZMx7RAd+tXdH6EbcAWlDn
         8utVxsuIYy+DbMGqiGD1qds718yYM+mZ3Sy5s8BpqU6/Cez2PHji9yxma9OCK5nqq+QI
         L0u2AFhw36ZlJngHOXtZR1fbkYoUHrmpU+E2/9VstIN7PaoZjE3wd24XSuqiCKXFDVsb
         V2a9ZAxfHnCNpKGVcRUzsxRoIfdZ+c7ZT1KIN3ClOlOYl/BKmrJ215Nf6BmaPXInVjfO
         sRQJeicBYfXWhCZ+stszAI95zIcCNpSDKgqkfDl+QeRB1M4vfTXMQSBNK9KPGcv78qBb
         fJ8Q==
X-Gm-Message-State: APjAAAWaHC+URShCl7iJBm5krFD8aKZqNPeTqd2bU3PlsHQK9vFXM/nb
        zUjTLH7Ix417bNXnEUWsrj1gfc3n
X-Google-Smtp-Source: APXvYqxxFQa9jmm0uxONK4B+A1bocsiptuToB6VswiN9wOvrwT03DPgXdjigu9hnzyLhyYnN0jQ8Lw==
X-Received: by 2002:a5d:6805:: with SMTP id w5mr31581719wru.64.1582053137396;
        Tue, 18 Feb 2020 11:12:17 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.56])
        by smtp.gmail.com with ESMTPSA id y7sm3862750wmd.1.2020.02.18.11.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:12:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 1/3] splice: make do_splice public
Date:   Tue, 18 Feb 2020 22:11:22 +0300
Message-Id: <e7803efcf00c869dcf22b8b9baf7d9b96683c15d.1582052861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582052861.git.asml.silence@gmail.com>
References: <cover.1582052861.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make do_splice(), so other kernel parts can reuse it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c            | 6 +++---
 include/linux/splice.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3009652a41c8..6a6f30432688 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1109,9 +1109,9 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 /*
  * Determine where to splice to/from.
  */
-static long do_splice(struct file *in, loff_t __user *off_in,
-		      struct file *out, loff_t __user *off_out,
-		      size_t len, unsigned int flags)
+long do_splice(struct file *in, loff_t __user *off_in,
+		struct file *out, loff_t __user *off_out,
+		size_t len, unsigned int flags)
 {
 	struct pipe_inode_info *ipipe;
 	struct pipe_inode_info *opipe;
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 74b4911ac16d..ebbbfea48aa0 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -78,6 +78,9 @@ extern ssize_t add_to_pipe(struct pipe_inode_info *,
 			      struct pipe_buffer *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
+extern long do_splice(struct file *in, loff_t __user *off_in,
+		      struct file *out, loff_t __user *off_out,
+		      size_t len, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
-- 
2.24.0

