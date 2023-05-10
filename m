Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A677F6FDBEE
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 12:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbjEJKxe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 06:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbjEJKxV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 06:53:21 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFF57284;
        Wed, 10 May 2023 03:53:19 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8D6EEC025; Wed, 10 May 2023 12:53:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683715998; bh=Su8eZJ2qoUmmfP+Csyh7fEepnzBLn1U8CMdrHQiSywQ=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=Qb+3YVDjWhUvItj0olOQOcYmZ+4SLJqW8Q+o/0SgSNzgEeO5qgfD/eGTNe6avol7I
         Abfz5THYWoFpx/PYXR0lwU499hXLdIOj12S8YlSDC2FU5iq0IHaV0l+HWFne8I4wI4
         hytX/9KjaYaoNHijvPKE5m0S1pU+bSyUtK1AhWGr1JoJ9lA35sz6EK0CRQo1dc3x7a
         3wWu9hT0HDAFQCt+ei0mEJxayMwbALBVkceP/xj6w4wtgsfmos99PTL1ECKvzgUkxC
         wjFQ886lJE2owczhvDAnfoISFaKuKu9i8CeePSOufXHoxSOBZT8fgC4gdmUeV2feMG
         OQEvNoHzvP8zw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 24E43C009;
        Wed, 10 May 2023 12:53:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683715997; bh=Su8eZJ2qoUmmfP+Csyh7fEepnzBLn1U8CMdrHQiSywQ=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=k10H8T4hwcG1piRv8tvJe47oCmGc7WbXQZZrQ2KxIOmcrVUzAAXEEniU4OVUWbTrS
         TMMlMUDYSE71SSoR1oGTr3HphKF51lQ7DgiLeaELjwSl/V86FfZYDfTfIQzJ7FfzCd
         O45tL9L+s3HnYvRj6YF4yMv1m72Huq18m+fVWqljgRJgAiMwv47ygMwJORC92dmzWg
         ainvu5tFdA+xI408lDd9w3gF9zRZpoksKc8GbzvJHFLL6gOKYQEoH5XJp8Pctg9Pb8
         1AjD6pO7ULsLPNf1PcYgXxktZeP0X3ipAvwkogXO9uKCJhGxGqkNryyPNxJhotzaIN
         jB+yjZVWc0jXg==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id fee99f7d;
        Wed, 10 May 2023 10:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Wed, 10 May 2023 19:52:50 +0900
Subject: [PATCH v2 2/6] vfs_getdents/struct dir_context: add flags field
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v2-2-2db1e37dc55e@codewreck.org>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
In-Reply-To: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=2686;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=nNsGnPD2PxOG3GhcmpTd07ibIqX2g1FmG81LOmB1oSI=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkW3eNkJj7HaLZY/LqWPlbwN8L1PpEPw0D7pA5T
 D9jz+d8VCKJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFt3jQAKCRCrTpvsapjm
 cD06D/9CZfBLETGNann/siG9m1DVR2a2B8saSu6y0XNqusMCdXLyZU0VTWXkvv+U2GhNItVaZ7B
 85Vmv6btA0DMBEiul7aeIV9uL+Doi0AnjKGhHMAOgAhVqlvKjlpCtzHZ3m6o8rDDRDEIVs0slUw
 +aehwVwjjHIq40dR8O3d9Vu/2xhaEo8SLqRi7p8IKW5DkjXsbXOYqFLgNzHa16LJ4zGhQQb5RuD
 B0k6qYDazIKXRYeVfAlVwYIH3Ogb4abof7q7Kekrxsod1dDf6LRdtGB7b1gXI7xs98RoZ6e4HVi
 iPV8ffTbgRhcUX3UvBcfYtZVmwZMQZNGbrlai2qhOuqmtAjmAWFLTaFgv9Ojjlp1emAXros8wGk
 7uUJTDeujO3w2WqXyltIeACymjHdTl+8Ql4Bz7qjKMHFUSAWX2/+B+mQ5/POew2LjspcL5V0sPd
 50+eqpXNr6pJlkQyXk+kBoPs5bN8IWPE78VIXK6/hu2acqrgD3E+cDjhDGE10w1K4PG5QaaAMy7
 j9J7SBnmJcy/GcOrJna/ttR1LVjS2ghYgf0v/PXC5AQTAcrsd0fVT+dwf4bEN1U2O6+2Z2w61AV
 H4aOmW2X0pxgTSYbOdi/KDAjSv8nqh56gMY32I0ckHUqIA93hJJEWPkXTZSgVhFVnKTnWAiVtbm
 XVjPZe39nDkw0rA==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The flags will allow passing DIR_CONTEXT_F_NOWAIT to iterate()
implementations that support it (as signaled through FMODE_NWAIT
in file->f_mode)

Notes:
- considered using IOCB_NOWAIT but if we add more flags later it
would be confusing to keep track of which values are valid, use
dedicated flags
- might want to check ctx.flags & DIR_CONTEXT_F_NOWAIT is only set
when file->f_mode & FMODE_NOWAIT in iterate_dir() as e.g. WARN_ONCE?

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/internal.h      | 2 +-
 fs/readdir.c       | 6 ++++--
 include/linux/fs.h | 8 ++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index e8ca000e6613..0264b001d99a 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -267,4 +267,4 @@ void mnt_idmap_put(struct mnt_idmap *idmap);
 struct linux_dirent64;
 
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count);
+		 unsigned int count, unsigned long flags);
diff --git a/fs/readdir.c b/fs/readdir.c
index ed0803d0011e..1311b89d75e1 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -358,12 +358,14 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
  * @file    : pointer to file struct of directory
  * @dirent  : pointer to user directory structure
  * @count   : size of buffer
+ * @flags   : additional dir_context flags
  */
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count)
+		 unsigned int count, unsigned long flags)
 {
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
+		.ctx.flags = flags,
 		.count = count,
 		.current_dir = dirent
 	};
@@ -395,7 +397,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
 
-	error = vfs_getdents(f.file, dirent, count);
+	error = vfs_getdents(f.file, dirent, count, 0);
 
 	fdput_pos(f);
 	return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 21a981680856..f7de2b5ca38e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1716,8 +1716,16 @@ typedef bool (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
 struct dir_context {
 	filldir_t actor;
 	loff_t pos;
+	unsigned long flags;
 };
 
+/*
+ * flags for dir_context flags
+ * DIR_CONTEXT_F_NOWAIT: Request non-blocking iterate
+ *                       (requires file->f_mode & FMODE_NOWAIT)
+ */
+#define DIR_CONTEXT_F_NOWAIT	0x1
+
 /*
  * These flags let !MMU mmap() govern direct device mapping vs immediate
  * copying more easily for MAP_PRIVATE, especially for ROM filesystems.

-- 
2.39.2

