Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D71E3F5FA1
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhHXN7S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 09:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbhHXN7R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 09:59:17 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F7FC061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 06:58:32 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f5so31433308wrm.13
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 06:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=usKcXXE7LD6xR/J83+xwOB3ds6fThGvXWh81u3oWUiI=;
        b=bWoeZc7sk6TFyJ8IbnCn5mHQicTEOF8r6BMSVe07m6FqX1vK7R+ZeuK9CXujkaQaRk
         V++lf/HQUh/WGeM+eKCF7I8dXygoC9DpoD5ixfaWhxz8ia0U0qEFfApie7aVTlkQIQNY
         tgVQ6xE1+Y1nsauWFsOqZK78Y8bzl1veObED3aRQfaiWS7CLz77E6qVOEmWMncOQALJP
         rTPRmdsxS//Ok3TM7rdhNtzVTWekIJexPpjzpkNDkNNgo9FFy/Ytc5SXqt9iGU21HAZX
         bg+mczxlCi2C4SbyJpjsysOveyBT2JrsVb+KIbtQrIY2gmGrexfweI7Y/8jVtHjsfqhy
         azMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=usKcXXE7LD6xR/J83+xwOB3ds6fThGvXWh81u3oWUiI=;
        b=UtDZ27XeaHI+iylAolZssflYBmzC+0ZFlOTfzdC0FsS8p4SGC3erWShH5Div55TnDh
         0vQgsgF8/RPtAtp42ja6ysWKJkiZ8xXHR0KIZgz8xAL3XHNejggi1Kry1R4Q6MaBz/Bw
         mIeiMmJZhhxvZsqrncoJRRPyIEh8sdUGeFfFrdxvLnSOwPX0w1dGE9CFRlUt8N1tiHxu
         a4HiszQe3msW45cD4ozjmBhTj5SzOmL+UgAzUlh+D+yfbJwsIzI7LGbttvE93N8CXwxZ
         pwxyiaoECEh1Vkjn8R77sHyZKBJ5IoUieyplyKMZtjVTFyzEH9NS0JU5BCJrzwbmjuGr
         t/hg==
X-Gm-Message-State: AOAM530OwOEDRL+5uk2oXVA9c1UbUKyHtQ3hk5dSs9xiDuAIkNafjsdd
        9uJAWaX2nB/zLQuWr/qfGRI=
X-Google-Smtp-Source: ABdhPJyKbd6r/8N/7tSmIcUCB1N25U6+O7DMyLBTsGGSXrE/VrVhOCwcVCtOFi2aIVeN1h99oNJ93g==
X-Received: by 2002:adf:d1c3:: with SMTP id b3mr18626671wrd.286.1629813511240;
        Tue, 24 Aug 2021 06:58:31 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id y21sm2568622wmc.11.2021.08.24.06.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 06:58:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: non-root io_uring_register
Date:   Tue, 24 Aug 2021 14:57:52 +0100
Message-Id: <2d40f84f0fa5e5dc53ef8b55bdcc00a11e0dc5a7.1629813328.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629813328.git.asml.silence@gmail.com>
References: <cover.1629813328.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Non-previliged users can't register too many buffers, just skip the test
in this case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io_uring_register.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index 53e3987..9475739 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -303,12 +303,14 @@ test_iovec_nr(int fd)
 	printf("io_uring_register(%d, %u, %p, %u)\n",
 	       fd, IORING_REGISTER_BUFFERS, iovs, nr);
 	ret = __sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, iovs, nr);
-	if (ret != 0) {
+	if (ret && (errno == ENOMEM || errno == EPERM) && geteuid()) {
+		printf("can't register large iovec for regular users, skip\n");
+	} else if (ret != 0) {
 		printf("expected success, got %d\n", errno);
 		status = 1;
-	} else
+	} else {
 		__sys_io_uring_register(fd, IORING_UNREGISTER_BUFFERS, 0, 0);
-
+	}
 	free(buf);
 	free(iovs);
 	return status;
-- 
2.32.0

