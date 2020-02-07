Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7408155B09
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 16:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBGPur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 10:50:47 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:39567 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgBGPur (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 10:50:47 -0500
Received: by mail-il1-f193.google.com with SMTP id f70so2083938ill.6
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 07:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D26ycyyixKYpx3yX+Ak713T8bnVBatPnLzgb6E5ndAE=;
        b=QAUMDDkuylGriTHXTapemNq+y6QvSmif+jIoDlgntgbsXedC22fF/0XDZ0G5mWFLdJ
         peh53ktgWyhDFGfb2j8QuQzjh/PHRZUuol1rI4cXELrKAFZFb/rFr1GLSi9wMDy11iOK
         v2caTMtmL8AeWW3/DhlzeYAvy/QjCTRM9xetSmQYpGSpk+/j2AVZenPgY7LpKF1DGAHo
         mUe4WwJzmmuECtOT+7m1HLogvAaK/5baPAhPO454v193h4ZuzEWZgbSyqo/iPg6kLd0p
         /F3KXRYcpv7bO0heZd/upIGras4j9s7y1nj6t3FpLe1TCDiOge5tSeT8qfx/LPZySVxh
         KyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D26ycyyixKYpx3yX+Ak713T8bnVBatPnLzgb6E5ndAE=;
        b=bMg5OZlsCTpmQJXZgRQRiz+rgCxqaRDA2j3Z8jnZ43eEby+krDcW+Hb40JQQOOcZcY
         QOd/2cWYbpHxFjlLXgIu4dsntU+Z+AR4siRPP4Si46iOaI6ZdP6RG92LzxpmObJ8+Wfp
         qOCJ0q97bp8zBM9s+OU3jXKJXhfrZQ1UK+I2UY/hHQEwcFznl8uIMnLsYTV09zEh+cXF
         2HqwmHQX34+pAmmJlJ7CmVuSFugeGldmkxD5xRJ7o9cSR55rqttoxrQMRrLzvO5aqQAx
         sgj6ulurAsz2MHbbetkTKLA3tngkpfNigRA0XcZWYDnYHy8vb2mt4HwIe1HKR4Gj4hA+
         W/Lg==
X-Gm-Message-State: APjAAAX1I+PGSvLFOSavquX8JaXoYGIKMtcrqUIXYh0CFVnRC+6/TuT+
        x8S8HKrdR1aXN+v+xehvH7mZQAQsy2Q=
X-Google-Smtp-Source: APXvYqygJRN9TJUb8jARNxJzbZbxPy6HOVjpM9gUYZ9vH5CrFHc/6ohCob4nHR1LoAAnEXs6TDf2Lg==
X-Received: by 2002:a92:c50f:: with SMTP id r15mr22134ilg.258.1581090646104;
        Fri, 07 Feb 2020 07:50:46 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r18sm978493iom.71.2020.02.07.07.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:50:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: add ->needs_fs to the opcode requirements table
Date:   Fri,  7 Feb 2020 08:50:38 -0700
Message-Id: <20200207155039.12819-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200207155039.12819-1-axboe@kernel.dk>
References: <20200207155039.12819-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Set it for openat/openat2/statx, as they all potentially need relative
path lookups if AT_FDCWD is used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index da6a5998fa30..957de0f99bcd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -616,6 +616,8 @@ struct io_op_def {
 	unsigned		not_supported : 1;
 	/* needs file table */
 	unsigned		file_table : 1;
+	/* needs ->fs assigned */
+	unsigned		needs_fs : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -694,6 +696,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.file_table		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_CLOSE] = {
 		.needs_file		= 1,
@@ -707,6 +710,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
@@ -738,6 +742,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.file_table		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
@@ -911,6 +916,8 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 	}
 	if (!req->work.creds)
 		req->work.creds = get_current_cred();
+	if (!req->work.fs && def->needs_fs)
+		req->work.fs = req->ctx->fs;
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
-- 
2.25.0

