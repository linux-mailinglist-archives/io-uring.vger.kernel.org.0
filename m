Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3803841FA6C
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 10:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhJBIrC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 04:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbhJBIrC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 04:47:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39BAC061570
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 01:45:16 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id l7so19784138edq.3
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 01:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0xpplnfMgwjEb6QaFAyHRWz9ppBgUrkSdZdO99j5hHc=;
        b=k6SvxAdLynmKQzZ/YMLeEbsEbHwmU5dIigZzrpEPXekMKd3W5b74AEetB7QyLO2SpS
         THMWLFquXYgLpss/9rg8dLk3czuBoT9VKM6j9UQgATd3qcqvGBHlUDHskTmFE5/aFpiD
         jBjsI3p64ppYOm/Uv+X/WZb0DjgUDq9DvOnXoRRqNfkgPdubVmSu4MSOQNfbAWO5tU8o
         tdiq66Q+yrXcI7NFoMMNd278dcJJpkjPs8mbTttuSEcxs6D46+OMk5MNCabLg4T9tH2e
         d5Aj9j0EIoHoQgwp5zPwgIebRzMcUg3XQeUNqiGf9t5zFwCFw/0pTdeiJPwe1wJlRFWY
         4Mpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0xpplnfMgwjEb6QaFAyHRWz9ppBgUrkSdZdO99j5hHc=;
        b=jXwkiii1L0QqEs0SDyKZrgfHD8BJz7Xlk/fxFqNUZMhH9pERX++4HMSaT+QUtIKQwV
         tNo2YYTHYtaUpfWKr78HcYoGSH0QyjFqFnes2wy/3dZe1wqbfppqRODJb528WLu++uzR
         9dBlXwp8TDhZ6eP40gJp6rZrkUcAq+/ggmktCZUp3qCKw4+QL9PyazGU2CwRi9/tsewI
         saroaFpsoqAVroXLn+3GQCJd3FK1ILgc2WtReWqyamNCyHmujT5AYfkzPExE7Q6G0N0n
         N5wLJgHeqi9C/huICQCwVFelLjpQV4RtX2+r8GKkIf7/jn0DX7//cvYeSQuUIe/ATOcp
         O10A==
X-Gm-Message-State: AOAM531PH1Q8/23KMPQHUUCidYak7nWexVomIBLwC/Y5zON+XLdjPTzj
        M4bOKGBC1fnM/P1IxGEOAJc=
X-Google-Smtp-Source: ABdhPJxFvC2owY8EtshGXQQKnFK3Ifs824GiQv057d55b9rZAsEWfRQwZN0ZtGFsSsigtQHrLEdz/Q==
X-Received: by 2002:a17:906:a18f:: with SMTP id s15mr3054760ejy.269.1633164315291;
        Sat, 02 Oct 2021 01:45:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id kx17sm3820940ejc.51.2021.10.02.01.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 01:45:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH v2] io_uring: add flag to not fail link after timeout
Date:   Sat,  2 Oct 2021 09:44:28 +0100
Message-Id: <52a381383c5ef08e20fa141ad21ee3e72aaa2857.1633120064.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For some reason non-off IORING_OP_TIMEOUT always fails links, it's
pretty inconvenient and unnecessary limits chaining after it to hard
linking, which is far from ideal, e.g. doesn't pair well with timeout
cancellation. Prevent it and treat -ETIME as success.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: conditional behaviour with a new timeout flag

 fs/io_uring.c                 | 8 ++++++--
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1ad5817b114..98401ec46c12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5860,7 +5860,10 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
 {
-	req_set_fail(req);
+	struct io_timeout_data *data = req->async_data;
+
+	if (!(data->flags & IORING_TIMEOUT_DONT_FAIL))
+		req_set_fail(req);
 	io_req_complete_post(req, -ETIME, 0);
 }
 
@@ -6066,7 +6069,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (off && is_timeout_link)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK))
+	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
+		      IORING_TIMEOUT_DONT_FAIL))
 		return -EINVAL;
 	/* more than one clock specified is invalid, obviously */
 	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b270a07b285e..259453ce5f90 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -158,6 +158,7 @@ enum {
 #define IORING_TIMEOUT_BOOTTIME		(1U << 2)
 #define IORING_TIMEOUT_REALTIME		(1U << 3)
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
+#define IORING_TIMEOUT_DONT_FAIL	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
-- 
2.33.0

