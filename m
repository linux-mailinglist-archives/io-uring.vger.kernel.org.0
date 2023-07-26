Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49840763396
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 12:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjGZK1K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 06:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjGZK05 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 06:26:57 -0400
Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486E92716
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 03:26:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690367205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pom+EUyMYYQeMzw7Ruff4vSIuJsxO1g2AFt2EmqIW7g=;
        b=fsU5snFl5wlkpiManVsyEaqkA3jtYtL56SiUXPkUd2iP9vfHwkwlJOE8O0ij0tynJqOi6S
        u2AAScVr21h+JW9OrGQSDOETHmX1xQd0ggkbmaQLOjwtEsyGae6SRkpvVpe6Em6ca2gLOa
        o2lPAr6Nf7qOVDfuuv28eZrhNR7FoQQ=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 6/7] add vfs_lseek_nowait()
Date:   Wed, 26 Jul 2023 18:26:02 +0800
Message-Id: <20230726102603.155522-7-hao.xu@linux.dev>
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new vfs wrapper for io_uring lseek usage. The reason is the
current vfs_lseek() calls llseek() but what we need is llseek_nowait().

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/read_write.c    | 18 ++++++++++++++++++
 include/linux/fs.h |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index b07de77ef126..b4c3bcf706e2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -290,6 +290,24 @@ loff_t vfs_llseek(struct file *file, loff_t offset, int whence)
 }
 EXPORT_SYMBOL(vfs_llseek);
 
+loff_t vfs_lseek_nowait(struct file *file, off_t offset,
+			 int whence, bool nowait)
+{
+	if (!(file->f_mode & FMODE_LSEEK))
+		return -ESPIPE;
+	/*
+	 * This function is only used by io_uring, thus
+	 * returning -ENOTSUPP is not proper since doing
+	 * nonblock lseek as the first try is asked internally
+	 * by io_uring not by users. Return -ENOTSUPP to users
+	 * is not sane.
+	 */
+	if (!file->f_op->llseek_nowait)
+		return -EAGAIN;
+	return file->f_op->llseek_nowait(file, offset, whence, nowait);
+}
+EXPORT_SYMBOL(vfs_lseek_nowait);
+
 static off_t ksys_lseek(unsigned int fd, off_t offset, unsigned int whence)
 {
 	off_t retval;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d37290da2d7e..cb804d1f1650 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2654,6 +2654,9 @@ extern loff_t default_llseek(struct file *file, loff_t offset, int whence);
 
 extern loff_t vfs_llseek(struct file *file, loff_t offset, int whence);
 
+extern loff_t vfs_lseek_nowait(struct file *file, off_t offset,
+			       int whence, bool nowait);
+
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
 extern void address_space_init_once(struct address_space *mapping);
-- 
2.25.1

