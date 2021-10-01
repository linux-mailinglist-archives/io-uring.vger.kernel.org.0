Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E026541E9B5
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 11:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352790AbhJAJlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 05:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353053AbhJAJlk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 05:41:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81187C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 02:39:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u18so14507584wrg.5
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 02:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKidjiVgjgcNPg/X5YsoTZ59FWzE/SfkdRHZdYMJnRs=;
        b=U8nGX8avTZSPPMfJZLzGgtl5I/R75vbPHljFve/NQxKM3zEoXkOliCqnOcp6RnxlPv
         sKjiUY4W17oTXqHtaEdqsaQCCXQEKbAtzOpcXyllmiNTs5WZyePdaSq9mqYOW36qaRx5
         6/qBcjxqpLGte/AP3/PtjXMU94IeiyWTX2ZnBjfUqCUbYTSJ3m4OWpcfW36wUIAOrwSa
         b5FpebvA9ICwPeHzW93wcm7yd4OC8NQ0+NEEF+r2VhRsD0fbFdVOWsqgL16/pfVFHPZ9
         HyC7uYgCBrxVMbSOByWSbAuxox93j6iOa4gpp0kGKjM1LALVunA/gs7eb4TvVDotbinX
         6HPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKidjiVgjgcNPg/X5YsoTZ59FWzE/SfkdRHZdYMJnRs=;
        b=orww9bBrFOkSpyrTD9Zsphm/8kzySDgOY39vR0OHzBbh11LRT8lAH4NXUvkVpHihBl
         X8jAQt6Wam9q6vOU0jk7WRwNuePPzrlKt6/2KeaYvpjllQcxeu2lHJq4KkzhOKSz+NTS
         QWax6HZtReRJI/fUYBO4oQ/z7mDjqjELnU53h4reJHfpefIsuKv88bveWpT2IkptBUsq
         IBQhfHaJQJWKux7GijRmGShHJCA9vokyedW6ndfnqDGisxBp3/9FAj5NXt2r6Ho4ZSAE
         spfHTTgI/1P5klBxY0g0fXLkfGRrZVMz1GyglK0ByZWgG9JHZyeVwVJc3qvc/fnESSvf
         WakQ==
X-Gm-Message-State: AOAM532plKXvI9PpKMqvRvv2G7A/UoCxGbsy6QeaDAQgD8fr/Nki5jhe
        Em9V5DJin4V40kdeTw+8S40=
X-Google-Smtp-Source: ABdhPJyBkOvMotCDtab+MfTgsfo2PyQoxesTQDh7YayO561qnCsOzFKOThjeu01Dau056T8oYKbSjA==
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr10904256wri.284.1633081195067;
        Fri, 01 Oct 2021 02:39:55 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id f1sm5846595wri.43.2021.10.01.02.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 02:39:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: add flag to not fail link after timeout
Date:   Fri,  1 Oct 2021 10:39:04 +0100
Message-Id: <074f26611a748ab48fbdcbc5ab3de9a25fba0cd0.1633080227.git.asml.silence@gmail.com>
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

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f76a9b6bed2c..ed5bff887294 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5873,7 +5873,6 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
 {
-	req_set_fail(req);
 	io_req_complete_post(req, -ETIME, 0);
 }
 
-- 
2.33.0

