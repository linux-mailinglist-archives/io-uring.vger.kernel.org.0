Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F836FDBF4
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 12:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjEJKxj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 06:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbjEJKxc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 06:53:32 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E417D90;
        Wed, 10 May 2023 03:53:26 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id DCEBEC026; Wed, 10 May 2023 12:53:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716004; bh=yLt30ccVZYSI/65st0oAv5X6KGUwx7EeVr+r1ZsxAqc=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=nobaswzK0qfQPonWpcsjEiwfLGSAeY/3jSJ2fP8YGX57ybA+L6xdLHkTbU6bAHq+b
         SFT4kFIn+IYL6yXq53Xp0OgekF4092FihADD55MAE79hT3Vise67ogY2fL6V4CzCet
         tEBrrkDWDC/xd+ji4PL2+oFhfkGPWLzXtBatLaqcUBlCGxV6E/k9AfraXji8WQ5eky
         Gw7Q50oxdYUXrrzwqh63c62U08xXhwczsKKe9GVrSnBd6RXY7TvOPtmfZAmJbBsMdj
         8rV8qF8Jvat3CvioscCx1sQJdirv5T0cKHhFNVQ4tHEJGNNqwyyM/ii9tHDhNPl8O0
         Vk8J9+2GqtkOg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 6A376C01E;
        Wed, 10 May 2023 12:53:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716003; bh=yLt30ccVZYSI/65st0oAv5X6KGUwx7EeVr+r1ZsxAqc=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=EZGCrcnQphjBkKcNP7P612MZj7jJINdX9s/+jITHBbjs+BkUeSU7sH1ufIMokm2u1
         thA80G7tsP417bFjDh+D1CPVmisFDeUu4x1HeJVo1j0AcmKskw8GKQGsStv1ZPUL30
         8kjELVSkpoYnnQmRWPcj+0viaIfRXh/m6X6eCJcAD0JB4LOHROPeatG3npesCeMI7o
         34yQWD1723BHa4FLqdSjvHQRv15bYWZr6ETf0XWzj2yp0HXwGUQehT5XPgrxI56Zzr
         91F6JLZIRx9SyS6ab7Kkt3LTmAKNrEARE2E8ZCOnAQHnsgxH5FdWdJVBY9dOWgn+wH
         1L4RBtOt/X6iw==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 7b5bfb63;
        Wed, 10 May 2023 10:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Wed, 10 May 2023 19:52:52 +0900
Subject: [PATCH v2 4/6] kernfs: implement readdir FMODE_NOWAIT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v2-4-2db1e37dc55e@codewreck.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1751;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=wZy/djlXvmoURd9RMjzidbOvF/oy0mSJeWlqAdKVlLs=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkW3eOjSYuNu0/+DbVaVJAMlyNeKQRwVDOytJtX
 K2al+2U3eWJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFt3jgAKCRCrTpvsapjm
 cHz/EACzgdngFCVzZHoRfItwuuqAMsrGmLCG07aQFKsIX2bDy4EuMQvz252mAWhajgMdRA4lWLJ
 pFMAzzzgOR0Z5/tyl2ROWfboSWqwo6eNlBc/iMeMUc2oaPw+Ermndd++p3zWDMSlPV8Fw4sW99U
 1NKEAY02oT7DqtfbqrKLZ39iNz9AdPc7HKbQevknz6zatsvL0hQvXITzL5FAuLiQ1LxmO0BpTl+
 HRbMjIPfNCyMT3VbUvQcBAaaLutQ8QPTgfWvty0Cl4ehyvPmgub5/EdG/Y2XYB/ci2ho96jlpj1
 hkB+K//2mlW2yyTbT6buUmg+p0B3BDmoS9KxxsvOTpEspwCNWvFqS0mkeDbnBj5wmjgXh+L+Vlv
 aKMlVe0Gw9RJm7Hnc3TsoiSAq+QXZyYEWvxRVCK8wcJDxJ4RsDl2WIKqpH/lxb3jf55NAbzlIoH
 FQNHZwNkXc9t9qRgwobztHeRcqR2EqlQTt+8rbYWf4V1PNxU9b5aZDBbcLY4dTQ3tlcE1PjiEo2
 ODBpGlv13ladtn014MvpLnLndyeoIc2klueNdTbTxa3OZaxH1yY3i0LlZu4Gmg87dQjFxn+i49W
 LI2yEE/p1ow9gPxHLRmOOfE0s7cQYCUb+/rmpxGcuAw864lnKbWPcU7iNSIK96UM07T3MGI3mrv
 cGheGwzHYpOpL5Q==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since down_read can block, use the _trylock variant if NOWAIT variant
has been requested.
(can probably do a little bit better style-wise)

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/kernfs/dir.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 45b6919903e6..5a5b3e7881bf 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1824,7 +1824,12 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 		return 0;
 
 	root = kernfs_root(parent);
-	down_read(&root->kernfs_rwsem);
+	if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
+		if (!down_read_trylock(&root->kernfs_rwsem))
+			return -EAGAIN;
+	} else {
+		down_read(&root->kernfs_rwsem);
+	}
 
 	if (kernfs_ns_enabled(parent))
 		ns = kernfs_info(dentry->d_sb)->ns;
@@ -1845,6 +1850,12 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 		if (!dir_emit(ctx, name, len, ino, type))
 			return 0;
 		down_read(&root->kernfs_rwsem);
+		if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
+			if (!down_read_trylock(&root->kernfs_rwsem))
+				return 0;
+		} else {
+			down_read(&root->kernfs_rwsem);
+		}
 	}
 	up_read(&root->kernfs_rwsem);
 	file->private_data = NULL;
@@ -1852,7 +1863,14 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 	return 0;
 }
 
+static int kernfs_fop_dir_open(struct inode *inode, struct file *file)
+{
+	file->f_mode |= FMODE_NOWAIT;
+	return 0;
+}
+
 const struct file_operations kernfs_dir_fops = {
+	.open		= kernfs_fop_dir_open,
 	.read		= generic_read_dir,
 	.iterate_shared	= kernfs_fop_readdir,
 	.release	= kernfs_dir_fop_release,

-- 
2.39.2

