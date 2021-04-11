Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B98C35B108
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhDKAvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDKAvN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86385C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:58 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x7so9229690wrw.10
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7onh0fZelm+dS8yswGKjDv25bdyUuiEGID65vR+B3Yk=;
        b=cg/mbnGUyfr8F2tuVJ+sAshO+bsqjEJaPnebJDvt6IXedDYHraG6GIpEZdcQ81Tlmm
         PyNOCAJ9JLKeMa3hOz9jAGR5UM6AGIZ4ZVlgQLfcGN2OmoG3wp9VBa9AwdQlZWKXoN0F
         HXC80qrlpDl/R5vx0BoJRNpaeSmiwyJd5CUXEEwh4Rs6jxwtk0MqfsR0Jar5cZ4DJdH7
         1vLonXeUSEGEYjRPSf8KPBzvLI427x1p0wy5Un174X6HG2GJ0Gy/cdo0C7kLogF4V+la
         y0blNUsVY1CpUjv+ngJnh7NvF9Sgi5hrIwXn1EXyYVuBV0OhAWyQo83qRKyQzQD5N8Jn
         EMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7onh0fZelm+dS8yswGKjDv25bdyUuiEGID65vR+B3Yk=;
        b=BmEeWqpqxC1wIAyJvvWR84JRgCvmazH52HTChX+gcN5QSfHcQV+50ScS72NgaW0IBa
         zd1scsyaVfw3u/rtGZGO0CURNwa0GCKz8eoU7EfDlPuzudNKW9OTt7x9FYia7BlI7Ji8
         pQT3HZfh3PFAHV+xsvjQCaYr4/efpHvxvdda1F+qP54FYaJqsuI/oRLJpX0dFDDB3vuL
         bdLAoDwJ9ToUnl/ePaeAwAqGQpEDIoTUES+HLuiBYKUzVeuAB8Du4McO3gDPUzHwIbGr
         WwXRxzIYM542Gb8ZsbULL/Y1AXIPPBLJ2Rj37qBVmZVbkRaDEMlYFeoew6gWnuYj8m8Q
         4fmg==
X-Gm-Message-State: AOAM531/YCzXzHnSTEE3v6j/wLU3uohj4UOhVBzd9USg1yPQRY3SIT/y
        BkJFO+Lmvhf5AFBIpuNEDNs=
X-Google-Smtp-Source: ABdhPJzFhB58bmfFAt1+/WjG/a8CqIOU0lC/qIwb/aMQKPdp225U53AWY2Lssww8RX4nsf9/dGvQEg==
X-Received: by 2002:a05:6000:1209:: with SMTP id e9mr24349994wrx.36.1618102257357;
        Sat, 10 Apr 2021 17:50:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/16] io_uring: refactor io_close
Date:   Sun, 11 Apr 2021 01:46:28 +0100
Message-Id: <19b24eed7cd491a0243b50366dd2a23b558e2665.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A small refactoring shrinking it and making easier to read.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0dcf9b7a7423..2b6177c63b50 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4184,11 +4184,9 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	struct files_struct *files = current->files;
 	struct io_close *close = &req->close;
 	struct fdtable *fdt;
-	struct file *file;
-	int ret;
+	struct file *file = NULL;
+	int ret = -EBADF;
 
-	file = NULL;
-	ret = -EBADF;
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (close->fd >= fdt->max_fds) {
@@ -4196,12 +4194,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 		goto err;
 	}
 	file = fdt->fd[close->fd];
-	if (!file) {
-		spin_unlock(&files->file_lock);
-		goto err;
-	}
-
-	if (file->f_op == &io_uring_fops) {
+	if (!file || file->f_op == &io_uring_fops) {
 		spin_unlock(&files->file_lock);
 		file = NULL;
 		goto err;
-- 
2.24.0

