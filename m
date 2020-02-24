Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD6116A013
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgBXIdq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:33:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46170 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXIdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:33:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id g4so2916051wro.13;
        Mon, 24 Feb 2020 00:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IlbVyaKmWMm2jjHgFJW71i25rExJdy144VQKowr29nM=;
        b=HZ0HkzTiwtYt7nPJCTn4uFj93uAixNqr5SEckIk4cQ5lm0Ryhxn7DFMLRxsvt4kRuq
         DQAHuuhHD17x1tBEJKhCiQpKpOily2PZWh9NGFv1W9F4t7JZTp5QXeJepJD3LXpSDq/P
         V4DzLgB+MubIPsLBKyuG1kNb7ciQvGQWuBej6TjoEYwvI5G+CXsBmaNtFO0+sA16MTrl
         biexL2KYtXyblpRYz4XKrBoMj6TVMszvgXkMH9dJVDbJesg3dKQPPGB9opt/Oc+YzRCc
         vY83HCFjxQyoafrSOMix5JBm5Ka67GtsCgFykmWCCGDPbIFhe32SBhOKFEmFIUDMHFFz
         aUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IlbVyaKmWMm2jjHgFJW71i25rExJdy144VQKowr29nM=;
        b=j3QUqdFVPi5HtFozZgtHN4YHli/+zjoz6/n/Q/ek75D9AXzRVGN1fbRjwyXSQb0T70
         sJeqODi1fj9rpx7XzAlo5Nreq8Glrvb36PxalqM8URZ1saUhdqKmYOt/HNQHQH7FkSPD
         pG/idGMDoHiXR7Kb35ZpreE9D3T7kHA5Du1Q47hyojxJtY/X0dGFZmOF9t+S36NEyxqJ
         I15X7vtPqSBpjCDKPLxlBA6Zw7cC6ibVjOsinxoFuFxlp42tPBYbM8ZmPdndLvIrCfu5
         1nG2/GB8+BNqq/H0glvTB14xT5dUQcn7oTPYsmxE77116lq/0+KUa1gO0z+Ol1NiQ6es
         gnfA==
X-Gm-Message-State: APjAAAWuvShDsgmVwNgvCTO+7Apu59TxFZD2v3lsmd0y5Mh/wLhQ+DE9
        fK8AYEvQ5EFV17iiGqCXzGU=
X-Google-Smtp-Source: APXvYqyWgLEkdBXw56kjAzzV16ELPSeql0F3nZIgeK9AnbaCk4ztG97Ryv3jP6z6BIJAAL13GY4isA==
X-Received: by 2002:adf:8084:: with SMTP id 4mr13600884wrl.201.1582533222435;
        Mon, 24 Feb 2020 00:33:42 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id p15sm16695353wma.40.2020.02.24.00.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:33:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] splice: make do_splice public
Date:   Mon, 24 Feb 2020 11:32:43 +0300
Message-Id: <ff7d58630ce3099509ad0636adb2504e915fcda1.1582530525.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582530525.git.asml.silence@gmail.com>
References: <cover.1582530525.git.asml.silence@gmail.com>
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
index d671936d0aad..4735defc46ee 100644
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

