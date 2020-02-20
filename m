Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE78E16685F
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgBTUcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:32:05 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54298 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:32:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id dw13so1343650pjb.4
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7+RvmWWEGA6TFzhd+dY2FETzWvu71sWktcInNPLVctA=;
        b=JXtglvkCxqWsk5H5BmhgmC1ixIDfC13xDnD7y1s8ewTEOiEBatswQ3skWNtQhUNX5Y
         qeGlPAgz1c9aPQaXjyQ+B0Xi8dCJD0RxUrtlgsUMWG6N5GMac1VJ9HxBPcl7pMz8baQk
         85xpujuHU7PptI7zDvej71EJM0An4OiRC7Xt1P9BJz8kBuaDXB+r9VUOsObG+e8avvSO
         FBGVmssmZ2+a2cnkvwGaKtMt8HSWSk47zfOJNzURm6/3LRtrKMVyluZ5KYLTWtMFfBjW
         g8HiwcPrusnqYuScWaEujnfKMaLByRxOuKIjwpICfR0eRbsqzQAfZixkE/fqFckxVP95
         n86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7+RvmWWEGA6TFzhd+dY2FETzWvu71sWktcInNPLVctA=;
        b=jFaJZQf/GRJbynZInFnvnJqK62K3y+OaBd1PkVxecAEURmOJbqza5oPj/ODyTJZnpz
         55DukRE6YUW2t027W+Kwgbejl3n2u5SA9xvASKjrmag6VJllO6pl2ScpU0pu7JTayYaI
         /bPLIwOmJ/W1djl8XAE5soOpp1Szi1S15eGyxSR8BvDIN2/MVSpfjkcpybDTfdrGNaw2
         optIyZ4eUFPUgUYw6MWF+BGLpgdqnp/3m+pEH+lMNnqvgcaDdl1NLfVgDxfcadsOY3u8
         uCgnOe1zGO6z6/bEXEecgVvyHmnkKJQvgbFFg+ZHjFCp5SLsICh/aNKd02w24w27iuV7
         fTdA==
X-Gm-Message-State: APjAAAXcYs/NQbqay2ck0Si+S0TzkPfj+oarVTi7Q1B+SP6iGAYGbzYH
        k0gLY6lYSC7K9vwN40KcU8yZ8XX1GtI=
X-Google-Smtp-Source: APXvYqwDm0fLc12MRrwiEL01d48IucihzJq5vsOLbE1qwl3/HIkqZl9pL5E7I67XCIZORA4llVESww==
X-Received: by 2002:a17:902:fe13:: with SMTP id g19mr33582550plj.216.1582230724574;
        Thu, 20 Feb 2020 12:32:04 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:32:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring: mark requests that we can do poll async in io_op_defs
Date:   Thu, 20 Feb 2020 13:31:50 -0700
Message-Id: <20200220203151.18709-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a pollin/pollout field to the request table, and have commands that
we can safely poll for properly marked.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5991bcc24387..ca96e0206132 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -624,6 +624,9 @@ struct io_op_def {
 	unsigned		file_table : 1;
 	/* needs ->fs */
 	unsigned		needs_fs : 1;
+	/* set if opcode supports polled "wait" */
+	unsigned		pollin : 1;
+	unsigned		pollout : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -633,6 +636,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITEV] = {
 		.async_ctx		= 1,
@@ -640,6 +644,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -647,11 +652,13 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -667,6 +674,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_RECVMSG] = {
 		.async_ctx		= 1,
@@ -674,6 +682,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
@@ -685,6 +694,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.file_table		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
@@ -696,6 +706,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
@@ -724,11 +735,13 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -740,11 +753,13 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_RECV] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_OPENAT2] = {
 		.needs_file		= 1,
-- 
2.25.1

