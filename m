Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818393FCE0C
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 22:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhHaTxr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 15:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240991AbhHaTxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 15:53:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F4BC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 12:52:46 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t15so901190wrg.7
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 12:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XDA/hWBAQl6OkJn8Cv/Gtp+vk6WVer1NbJyzbBroQgU=;
        b=Gu+lZhuCk/UMMD/WwimWXjUDlARsKvaI+llNX9YY37H5oKK/r9x87r+rj4B8XA2vLM
         Vg4JxGq/sKVyNf4WGk1U24YBfRh5k1Y1zIh+WnLE8PtHAeSATeFDRMKreniQaHptJSjH
         rk54k+rRzLziWm6lRS8yBrdBwQDcQyHWADRdyloHQIqbGXPGvhAd8V5+bcMXab7yuL4s
         DKu3tYqWdIh4dv+I7Rbni+C22cr3kt5sJLlaWd5j3ZogOoy2/eauQrbMmWj14iMEKMV5
         TsapYqVfEQvEiYhJSjvi10D6ud5tA/Po1/brsMV0XmEuYd3o1pCWNwrkHn9vcItzQJ6z
         7h5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XDA/hWBAQl6OkJn8Cv/Gtp+vk6WVer1NbJyzbBroQgU=;
        b=WDSKokjBJiKUtyetQp9KTS4brEwlKWXLr/jgFtMxd9mlOBzPH5lf1hrcFU0SRqPm58
         8c2k9iYh10TXBkhtaJZa0UvBfzn7IQSmam/VuX3prgTEt10UIs5A8TGDjHQLoiTkUI/r
         LKIf1tygGtsGFzKOgqvfLrJ9gmmjcfAzJUTSRub8tYORy74B0lfw2I/LZeG6sT4hhujy
         pY0JIFfQB1tShWqpv5N5yepRDZkq5CZXHcYEhvvdRb3aRnZ8YMkMyeC6HGV6glgSiCH/
         puq+02jejto29I3gGPm176e4NfGcbSSnepod5mHEbi5UclRUza0aKnTMVv19ITpZJ05D
         Jm6A==
X-Gm-Message-State: AOAM531PNtJI9k6R7gN7VsI3eAi9RnS1H5D/hoTb1uqUipKGkWbRbdVl
        6kRUXo0ydtnrDSvFnA1ajBw=
X-Google-Smtp-Source: ABdhPJwuyD2EY3Ni066/1qaqL6fsABaJVpwnOJNRC7aWdSDf6tQ8ODv1rqQNL+k1ikmFAXLKNCFuDw==
X-Received: by 2002:a5d:4410:: with SMTP id z16mr33780669wrq.110.1630439564709;
        Tue, 31 Aug 2021 12:52:44 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id l21sm3235143wmh.31.2021.08.31.12.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 12:52:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] man/io_uring_enter.2: add notes about direct open/accept
Date:   Tue, 31 Aug 2021 20:52:07 +0100
Message-Id: <e4b7c0f9b585307ac542470c535ef54e419157e0.1630439510.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a few lines describing openat/openat2/accept bypassing normal file
tables and installing files right into the fixed file table.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 9ccedef..52a5e13 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -511,6 +511,18 @@ field. See also
 .BR accept4(2)
 for the general description of the related system call. Available since 5.5.
 
+If the
+.I file_index
+field is set to a non-negative number, the file won't be installed into the
+normal file table as usual but will be placed into the fixed file table at index
+.I file_index - 1.
+In this case, instead of returning a file descriptor, the result will contain
+0 on success or an error. If there is already a file registered at this index,
+the request will fail with
+.B -EBADF.
+
+Available since 5.15.
+
 .TP
 .B IORING_OP_ASYNC_CANCEL
 Attempt to cancel an already issued request.
@@ -634,6 +646,18 @@ is access mode of the file. See also
 .BR openat(2)
 for the general description of the related system call. Available since 5.6.
 
+If the
+.I file_index
+field is set to a non-negative number, the file won't be installed into the
+normal file table as usual but will be placed into the fixed file table at index
+.I file_index - 1.
+In this case, instead of returning a file descriptor, the result will contain
+0 on success or an error. If there is already a file registered at this index,
+the request will fail with
+.B -EBADF.
+
+Available since 5.15.
+
 .TP
 .B IORING_OP_OPENAT2
 Issue the equivalent of a
@@ -654,6 +678,18 @@ should be set to the address of the open_how structure. See also
 .BR openat2(2)
 for the general description of the related system call. Available since 5.6.
 
+If the
+.I file_index
+field is set to a non-negative number, the file won't be installed into the
+normal file table as usual but will be placed into the fixed file table at index
+.I file_index - 1.
+In this case, instead of returning a file descriptor, the result will contain
+0 on success or an error. If there is already a file registered at this index,
+the request will fail with
+.B -EBADF.
+
+Available since 5.15.
+
 .TP
 .B IORING_OP_CLOSE
 Issue the equivalent of a
-- 
2.33.0

