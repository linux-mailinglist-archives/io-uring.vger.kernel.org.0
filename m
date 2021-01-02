Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01B22E8804
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 17:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhABQLq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 11:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbhABQLp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 11:11:45 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AA5C0613ED
        for <io-uring@vger.kernel.org>; Sat,  2 Jan 2021 08:11:05 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c5so26658336wrp.6
        for <io-uring@vger.kernel.org>; Sat, 02 Jan 2021 08:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BS4oQSJY0ZZ5XAnv1zLAn5Rqg+n0wpRZIeF5pDy5qKA=;
        b=b7fPub6astU5QR59tD6i1L0EoKXrw44QyIe9Bbg1oBNdc5I+nP6UPdW3fJvNaE/xil
         U6Gh/fzU8Iv+9OzS77JO3Qaxt1HnxROqM8rUTQKZKN3uuJTNtH0HHIVVsiCcQlsZPvsl
         iKgRlv2Kx7vEf3NV1TUiWRg9u0yIL+dwnqtdQpR+mSKupnrkt5R5eJb6X+R+P2HvzwRS
         44D11K2sjKMm96yaegIHEvqGFk39w7dPeQuPZn4wEMdczm3wxbNEXZDfbIPIYXpCEUPy
         QLNQn55W6P3ntySZd0pFBPqFIyABLaGfRPXT1vghuv8hR9papLFd3PeGTF6i1uXV+d1g
         eS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BS4oQSJY0ZZ5XAnv1zLAn5Rqg+n0wpRZIeF5pDy5qKA=;
        b=mUajDxKKb1sx/NUazfo9Ys1vD65H+8VLdMPzPutt053tfMf4TJLPXtm2JKoRCW7luq
         SqneVeks4Br7OYrQj34U5mKl9Lj/JL5h44Argu1XN6uS8a/Ekl4GVNkhEdwkO5hTLRt5
         mvooS0gHus0iQsiBSHMsI1Dya5e80K0Rjkpxvmtue1EIaczPdxA9FcG4BEZ7Nr9ZxlYv
         YXwT4RbDsbERdqTLHpxiSxeKg9r3UoCOIOwmJBkGRI2IyuhSKDuCLAshpbrzAFGlimuV
         e19wrok6hxMqV1FHxaXnXFiQoCWVdpXHISTF/V4Oy26EmUavDshzKchcsuSOGNviOOqw
         GUjw==
X-Gm-Message-State: AOAM532NwoZVaCRnlcRM2WIbLPYpNYZkShvtThxwHqYJ7wvwFoC3b2XF
        ajI79HVLicQKL5PcpGdeiy0=
X-Google-Smtp-Source: ABdhPJygUJmZ+rt0KfVzOLtj0rfvLeNv2yEBT3iBj7YA7iCQPjwS0gHAbh8L/qhmrb1We6pxN9MMnw==
X-Received: by 2002:adf:c109:: with SMTP id r9mr61053907wre.261.1609603864069;
        Sat, 02 Jan 2021 08:11:04 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id b83sm25222377wmd.48.2021.01.02.08.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 08:11:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: drop file refs after task cancel
Date:   Sat,  2 Jan 2021 16:06:53 +0000
Message-Id: <68cba7ce643c782719d64ead02fe770879b155c2.1609600704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609600704.git.asml.silence@gmail.com>
References: <cover.1609600704.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring fds marked O_CLOEXEC and we explicitly cancel all requests
before going through exec, so we don't want to leave task's file
references to not our anymore io_uring instances.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4deef746bc3..3f38c252860b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8958,6 +8958,15 @@ static void io_uring_attempt_task_drop(struct file *file)
 		io_uring_del_task_file(file);
 }
 
+static void io_uring_remove_task_files(struct io_uring_task *tctx)
+{
+	struct file *file;
+	unsigned long index;
+
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_del_task_file(file);
+}
+
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -8966,16 +8975,12 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-
-	xa_for_each(&tctx->xa, index, file) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		io_uring_cancel_task_requests(ctx, files);
-		if (files)
-			io_uring_del_task_file(file);
-	}
-
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_cancel_task_requests(file->private_data, files);
 	atomic_dec(&tctx->in_idle);
+
+	if (files)
+		io_uring_remove_task_files(tctx);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
@@ -9038,6 +9043,8 @@ void __io_uring_task_cancel(void)
 	} while (1);
 
 	atomic_dec(&tctx->in_idle);
+
+	io_uring_remove_task_files(tctx);
 }
 
 static int io_uring_flush(struct file *file, void *data)
-- 
2.24.0

