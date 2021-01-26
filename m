Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9433E303CC4
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 13:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392152AbhAZMSj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 07:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392027AbhAZMS3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 07:18:29 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8D0C0617A7
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 04:17:49 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id kg20so22169228ejc.4
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 04:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vdA+f4Vi7nnzXSSuSNNSQOjZQoPh/oDpnlyLCKUQZpg=;
        b=t63x+JASnuuakMHFJ0UM6OJ+pejScGL9MJFYFKp33Qp3wKt3FsSjrEOVnsIW0tHa9O
         s6wNuEpguaRsKRdvmw0YUG46YW4JkUd6No2GtUt+QRuvvvhjfcFzw/1i+9gISF86s6+I
         fFv6xZfRMV8a+5lgI/7S8wK6BS1CXxX1hdArTRwb7I7U0uaA2gf4Sih6YjNzeEs9NPX8
         Is+b8Qs2RCtA1sHmoeAEcFF738TVp6eUxs8OF3qWqtJd2GbrKQo/kiERHRFrffgUYkl5
         PlGdk2chCq8MgcLG9YZqQxGpD9WRqGjizosFsArTIJKPaM6EYvrmvQKxAJsRosXoeBgu
         fG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vdA+f4Vi7nnzXSSuSNNSQOjZQoPh/oDpnlyLCKUQZpg=;
        b=n7DdVBHFIxp1pWRnR4kvzSeE5SG8gESTkhhbAUqMehRwo7YNgGZVCcDnxYpLnNu86m
         pITB0QunN9ipzmsjkh4qXhX0e+rljjRyGMZ1N0h7R7gVAaEK0FFmtMtT3cBO20HV32iO
         8QEqfwpWSEBcG8+z2RQerWRjYb3p6RgixU8FJQIALWaNh2VIcKKHHyeo5faywEUXq/xL
         v26LHgeXEJuF369zB4KZpB9LGlOaaTyIhvwA4Fe3qZh7N6SqeeV9/eS3VWCKqv5//pVo
         zcOZtF+GAmSlimXJ7ZWahb7WG8QxPJ5B1tQ8IP1xJqj8O4LRtg+skqcP5v4r7kM/IOug
         X73Q==
X-Gm-Message-State: AOAM532CTjcPO2fvCD0RXWfeAs30rGc6aQPR7VaAObelR1sLifUsWdB4
        G157oRzVm2DlsIlOJkGLhTzjg+NAU2E3jw==
X-Google-Smtp-Source: ABdhPJzKrsRm5/GfpiEtWJJgzrWEZSJ53suveZ2RQ9Yf6186lsu5Q0pmylomrvJbBWgystPrBs2WPg==
X-Received: by 2002:a17:906:3b4a:: with SMTP id h10mr3241663ejf.423.1611663468022;
        Tue, 26 Jan 2021 04:17:48 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12258203edr.17.2021.01.26.04.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:17:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: cleanup files_update looping
Date:   Tue, 26 Jan 2021 12:14:01 +0000
Message-Id: <36db2a597f591671257ef4c1f59b74c0b4c6bd6d.1611663156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace a while with a simple for loop, that looks way more natural, and
enables us to use "contiune" as indexes are no more updated by hand in
the end of the loop.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f77821626a92..36e4dd55e98b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7666,9 +7666,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	if (!ref_node)
 		return -ENOMEM;
 
-	done = 0;
 	fds = u64_to_user_ptr(up->fds);
-	while (nr_args) {
+	for (done = 0; done < nr_args; done++) {
 		struct fixed_file_table *table;
 		unsigned index;
 
@@ -7677,7 +7676,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		i = array_index_nospec(up->offset, ctx->nr_user_files);
+		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
 		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
 		if (table->files[index]) {
@@ -7715,9 +7714,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			}
 		}
-		nr_args--;
-		done++;
-		up->offset++;
 	}
 
 	if (needs_switch) {
-- 
2.24.0

