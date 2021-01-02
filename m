Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44472E87AF
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbhABPWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhABPWF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08DFC0613C1;
        Sat,  2 Jan 2021 07:21:24 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 3so13738330wmg.4;
        Sat, 02 Jan 2021 07:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rf6BUzrBX0nFEremfE+E6aI01/qO5RAbaAeeEZzdEU8=;
        b=b+W6Gio8PokvEN1p7hK+vmrtFsYuUXj5E1Pcurgm37QcJbo+IA1ctH7QYYoo7/bbAh
         CN1Ig8NDcGJCRgskTeuCehCCc3ApampAkhSMSg2g/2YalrbDFo/CHnPDKFyTmy/+JAGB
         WTZaFIVAU3/+edur0jyHbznCOvvLQgMzn3ycRPlQMd4vU60LafrpHS/ipZaf+XXm4IEX
         tlsU6fQjwRt3P8URGU8LEebx6TQBAIvGZsZGQNF/fgCj0JpB0HUSXNMuJkKfSKZurWme
         +ogJW22uQPLiT7k4Wy03Qa4DsVt11BbsmMtb4LQtIZN+IhFNvNGpiUgToKDkYZsoZrtD
         h/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rf6BUzrBX0nFEremfE+E6aI01/qO5RAbaAeeEZzdEU8=;
        b=o9436OLd5iMQhXloxcW6OV5rTksWhfRDHs/57xqYcRN9PkZkzelgrVevr5DE0uSmFm
         pZmQuA1YcjwbAz0JnU8YdgEuEJ9baQB73y5qbZyOzAYX1zfodX4xFVjSBPjUhO46cKNE
         qPckybt7iqGRyqWiLxXSFnp7LlsZkvOxTGvwD16cxgVNonY5TlftG0FciKIfofW4oXFZ
         Qqdgj98A2DgsTcr2MNaA5457OKmYffmB6toGKGZSKYtGFT0NDNVBDkorR4O9hOZk7D4J
         7yWfPkJnBeMqzZ6f78wq7bWWXGIsxQA3cPq4JLnGQUZxF1OxL7fG02JPjN2F5H7TMl5w
         waAA==
X-Gm-Message-State: AOAM531FZTEFHN1OjV5hB0O+YNQjAfOH1YPncLb7GM5xtia2nE+NK2zX
        9pxX0MtOoL0MOGBcH9wdq7QUV9f/ootjyw==
X-Google-Smtp-Source: ABdhPJx/WYak/g3xVcVBFTivN/j7PYb09nrxUAu6QP88WHUxu/G0S/WDG8I7eQUPvioar/5dabMjRQ==
X-Received: by 2002:a1c:ba44:: with SMTP id k65mr19751159wmf.188.1609600883202;
        Sat, 02 Jan 2021 07:21:23 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 1/7] splice: don't generate zero-len segement bvecs
Date:   Sat,  2 Jan 2021 15:17:33 +0000
Message-Id: <ca14f80bf5156d83b38f543be2b9434a571474c9.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609461359.git.asml.silence@gmail.com>
References: <cover.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iter_file_splice_write() may spawn bvec segments with zero-length. In
preparation for prohibiting them, filter out by hand at splice level.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 866d5c2367b2..7299330c3270 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -644,7 +644,6 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		ret = splice_from_pipe_next(pipe, &sd);
 		if (ret <= 0)
 			break;
-
 		if (unlikely(nbufs < pipe->max_usage)) {
 			kfree(array);
 			nbufs = pipe->max_usage;
@@ -662,12 +661,13 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 		/* build the vector */
 		left = sd.total_len;
-		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++, n++) {
+		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++) {
 			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
 			size_t this_len = buf->len;
 
-			if (this_len > left)
-				this_len = left;
+			if (!this_len)
+				continue;
+			this_len = min(this_len, left);
 
 			ret = pipe_buf_confirm(pipe, buf);
 			if (unlikely(ret)) {
@@ -680,6 +680,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 			array[n].bv_len = this_len;
 			array[n].bv_offset = buf->offset;
 			left -= this_len;
+			n++;
 		}
 
 		iov_iter_bvec(&from, WRITE, array, n, sd.total_len - left);
-- 
2.24.0

