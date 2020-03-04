Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B97179758
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgCDSAW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:00:22 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33008 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgCDSAW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:00:22 -0500
Received: by mail-io1-f67.google.com with SMTP id r15so3437028iog.0
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yCNno88E0SIp5+d37CJmxT3m1iaEGxFVNUpg9loipg0=;
        b=rsM38PQ3mDv+FccZ8vd59kXNn6k1fd6MhX/aVI+4GGmyaVy+U/fwBJTbeu3dKWwSxO
         R95HG1zuLvBoVtyeIk7TKKrhhbYnLjmOvOr859t/3dl+WWmFNvoeAism4NfAhpl70WrC
         UBsqXtm8Zt+x/+YEmRjq/FInzzzzb1KY1Ho79Bd9uTwQX6euCpjo7WGhdsBc2Y5eEKsE
         gQ+az5OH/OGrARGQTQxlxNkkEmB5E2Jg+I4HOWXmCQTuMAS6VZ/Bhaq+m2fkqIouL6AT
         XrSn2Yr3j7tHOqe0e/AIctIJyL+TgszcE2DASUjjso+mfBVH5OArqTevK0CfZryKwxmQ
         xgrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yCNno88E0SIp5+d37CJmxT3m1iaEGxFVNUpg9loipg0=;
        b=LyiFdlbxU1NTdxH9rJKctEVWkJVxpA3VfMZ+cgDd3wIogcrkTi5hzVOZHG4LDHXvkC
         +5VkaVCmCYrS82K8slqfxmScjbQTywdhCzTMwTd8BqlTi64bKuJZoWnAK8jZo6nDQ9eX
         KTktnzUeiA28v5cLy64jwoxxdVMtJmaYVRImrC85c5bAkx5sCPyPu+HOHyJxvoyPLtyh
         S9FpqibmzI+azN3WJsixl7y3FibEbe6vy5qKM2joRsyAqTRlcizf0mi8eV/qtgisO9lT
         1OTpteG/iQhJ0rvo7TK51aH7C2BdUTcn8N24OZNWSCpg8a8jA3KoDhRHb1gds3eV3dBr
         YbMQ==
X-Gm-Message-State: ANhLgQ3psslJIUDu0dp+1aQvRTMjBIrbwU2/r/ia0vmz3HQgxOvjx06D
        dOiPC4VHHb/z5mTvvaYiMvCKPqDEydk=
X-Google-Smtp-Source: ADFU+vvB5xafAiNA/dxBzYa4qPw6mPHT7snHumMnIfij4ksLGPGtc1zLZAtinnlGUc+ASYN4bByU6Q==
X-Received: by 2002:a5e:8507:: with SMTP id i7mr3221552ioj.9.1583344821437;
        Wed, 04 Mar 2020 10:00:21 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p23sm6715187ioo.54.2020.03.04.10.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:00:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, josh@joshtriplett.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring: move CLOSE req->file checking into handler
Date:   Wed,  4 Mar 2020 11:00:12 -0700
Message-Id: <20200304180016.28212-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304180016.28212-1-axboe@kernel.dk>
References: <20200304180016.28212-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for not needing req->file in on the prep side at all.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0fcd6968cf0f..c29a721114e0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3367,10 +3367,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if (req->file->f_op == &io_uring_fops ||
-	    req->close.fd == req->ctx->ring_fd)
+	if (req->close.fd == req->ctx->ring_fd)
 		return -EBADF;
-
 	return 0;
 }
 
@@ -3400,6 +3398,9 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
+	if (req->file->f_op == &io_uring_fops)
+		return -EBADF;
+
 	req->close.put_file = NULL;
 	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
 	if (ret < 0)
-- 
2.25.1

