Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8517F763394
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 12:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbjGZK1B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 06:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjGZK0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 06:26:54 -0400
Received: from out-20.mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1911A2139
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 03:26:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690367199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7e4RDFDm8jz3Kb6NZqecvXg19GC0WTDfvDBloY02gI4=;
        b=QYlhmmBwxtEiNsNPpGdT6VCwV0vXW9/eKFMcdHDqJiJzkKleyVrWcM+oS9lyM12dW3+GB6
        Qx9bj4mCGDTyOvFg9zbPkndM62ZYNqhSN8X9ATCD6MtlHAbtw6zUJ/NimZ1V3t7+vga7PH
        OfFuDepZCG8K1oI21pkY+Tv3dNRBB1Y=
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
Subject: [PATCH 5/7] add llseek_nowait support for xfs
Date:   Wed, 26 Jul 2023 18:26:01 +0800
Message-Id: <20230726102603.155522-6-hao.xu@linux.dev>
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add llseek_nowait() operation for xfs, it acts just like llseek(). The
thing different is it delivers nowait parameter to iomap layer.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_file.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 73adc0aee2ff..cba82264221d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1257,10 +1257,11 @@ xfs_file_readdir(
 }
 
 STATIC loff_t
-xfs_file_llseek(
+__xfs_file_llseek(
 	struct file	*file,
 	loff_t		offset,
-	int		whence)
+	int		whence,
+	bool		nowait)
 {
 	struct inode		*inode = file->f_mapping->host;
 
@@ -1282,6 +1283,28 @@ xfs_file_llseek(
 	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 }
 
+STATIC loff_t
+xfs_file_llseek(
+	struct file	*file,
+	loff_t		offset,
+	int		whence)
+{
+	return __xfs_file_llseek(file, offset, whence, false);
+}
+
+STATIC loff_t
+xfs_file_llseek_nowait(
+	struct file	*file,
+	loff_t		offset,
+	int		whence,
+	bool		nowait)
+{
+	if (file->f_op == &xfs_file_operations)
+		return __xfs_file_llseek(file, offset, whence, nowait);
+	else
+		return generic_file_llseek(file, offset, whence);
+}
+
 #ifdef CONFIG_FS_DAX
 static inline vm_fault_t
 xfs_dax_fault(
@@ -1442,6 +1465,7 @@ xfs_file_mmap(
 
 const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
+	.llseek_nowait	= xfs_file_llseek_nowait,
 	.read_iter	= xfs_file_read_iter,
 	.write_iter	= xfs_file_write_iter,
 	.splice_read	= xfs_file_splice_read,
@@ -1467,6 +1491,7 @@ const struct file_operations xfs_dir_file_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= xfs_file_readdir,
 	.llseek		= generic_file_llseek,
+	.llseek_nowait	= xfs_file_llseek_nowait,
 	.unlocked_ioctl	= xfs_file_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= xfs_file_compat_ioctl,
-- 
2.25.1

