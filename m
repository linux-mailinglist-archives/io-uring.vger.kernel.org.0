Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3218F3FC550
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 12:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbhHaJzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 05:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240676AbhHaJzW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 05:55:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF5CC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 02:54:27 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u15so10778418wmj.1
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 02:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d/bgyQCCA0QtkbGzZGQCuml1I3OSj5H7HuA8dw83PVc=;
        b=ev5P/uqwPRnho/TMyT7K6ejTsTA1G7KHdAV7Lea6LotRa3hjLSdoIoItZW5uJIkAP5
         mXvhxG/TD2Bz19WgpCxJmF1TE6dzKy0K8kCnW2yiArjAtdzlYrkGbJ74a739Sp2Se5wm
         w91xneYnHokLNCH81xYKNkygOPDvhHYoaiZxGHjCefsq4TQIXyg9WzWTnNJvo+NzLb/t
         LTasHPWJ4vzD8aijWr2RqdsjVAZK12XcATHfqMyBhRlCh8c+ho/y8VrMwHVkVpmZfJpw
         /Pf9xqBJWKI+rNJ+trL55FCsYZvyg/uOsO4r3KFkqgnEBPdiVweBvB1G/Vii9btOoacQ
         B0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d/bgyQCCA0QtkbGzZGQCuml1I3OSj5H7HuA8dw83PVc=;
        b=DJ+FwggGI/l/nWEb3xJ2mjRGR4tmkWWTKHozLAQbo7FB5kJQEUktFqyVapp4idEY8a
         ozaBK40RxF9tA9PojFn+4P3Huskx423OUSks9QUeM//QiY8e30/0Mq3vL508It3gI69G
         7shqOAB3Nm1WqTUluo3tn/pA+d34qZILVUDVFbr3aC8qWC3FWcbZ6A//VrP4OoazXFgv
         cNOSoM7OX4M4lTUcKL+b7ohL73NRwIZmglXfOUrqLPW08eFQu+ZKnq5uFJdWhLxN32NH
         TU63i2cYNJED1yVB1pN8bIrUb9k5xvhCs/5nHTe/qakOfHTb3X+sLRJrCdPhIGNp1xS5
         +F6A==
X-Gm-Message-State: AOAM530jvP6fkBZjE+J+HHU96N1G8pEFWfZyjzLdgVf3vY0yv60Sl0xH
        BDbrujA8/5aGgCflSoBjT5YcHlXVhDk=
X-Google-Smtp-Source: ABdhPJz+MWPplwt7wNpmvKUKO6K2CGKy/FttDuOEHexcLtk98oCa0WdcriPjVCitjYcvQ/BmNUXp7w==
X-Received: by 2002:a1c:98d8:: with SMTP id a207mr3221505wme.16.1630403666389;
        Tue, 31 Aug 2021 02:54:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id z17sm13641665wrh.66.2021.08.31.02.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 02:54:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: don't submit half-prepared drain request
Date:   Tue, 31 Aug 2021 10:53:47 +0100
Message-Id: <789119cca15a00b4840ca5fc069ab82dd072da39.1630403377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_drain_req() goes before checks for REQ_F_FAIL, which protect us from
submitting under-prepared request (e.g. failed in io_init_req(). Fail
such drained requests as well.

Fixes: a8295b982c46d ("io_uring: fix failed linkchain code logic")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a531c7324ea8..8902ff5add47 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6221,6 +6221,13 @@ static bool io_drain_req(struct io_kiocb *req)
 	int ret;
 	u32 seq;
 
+	if (req->flags & REQ_F_FAIL) {
+		/* fail all, we don't submit */
+		req->flags &= ~REQ_F_HARDLINK;
+		io_req_complete_failed(req, req->result);
+		return true;
+	}
+
 	/*
 	 * If we need to drain a request in the middle of a link, drain the
 	 * head request and the next request/link after the current link.
-- 
2.33.0

