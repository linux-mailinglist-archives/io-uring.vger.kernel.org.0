Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C533F3AF7
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhHUOXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 10:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhHUOXW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 10:23:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D07C061575
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 07:22:43 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q10so18549757wro.2
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 07:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rSWOAIV4O9if0d/hzZbusvl/9ESq/K6eSIbcFGOoLao=;
        b=l4ASEl6puSbTAea+yy+GTfSx2nIvNQIJnfyM8Mmv1AdZwrEcTEIMbWO91S+n9dlwEn
         B4jsax+qPfKmonEtEr8r14KoHa9F5uzIobfV+hBxXrpUl71eJh46ZcTM4b6mcaGELy/d
         cG8n/M4tv4MIgCRUEp0cVGl0iXCvGadBQWueNLSxBDTQD9l9ED0XA1GbUIGU5hqCQxPD
         tZ5I+kCC8t96K9PA2vZGgDv457g/U1g8VZwhYAzIHPcf5f+tfXzodWE1/iVHVw0WmSUU
         smfvQQYeHzN/dep3PtU3JXQHJbZTtY1rFFdnYdHDcm8D/JV+HM0oQBA03gQdaNGUtG1N
         N0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rSWOAIV4O9if0d/hzZbusvl/9ESq/K6eSIbcFGOoLao=;
        b=FwhZttEb/1agRpb4X5xtonS9f3luEasMVD6QX/c8HCUqhrPc1nPBWx8CsCNh6gvyFJ
         kUcjUSLiUi3RLnJeXtPHuqCLRY4V7VK+ssiUBtIlYnnS5KEJBB8iqBXYvBDD5ySWovb+
         TvwJPd/y9TU6KbwWjD9kvIHBWDuszKLONxRCgW3syUOyiaqPFw47POynuS3dbkb56uuv
         HMM6pdUSrRl0GdYaJQXqnkmZ7QJwoSUYTHsPmqe8BtUG6Ikmy1IsV4vi4klbuX/kg4Zd
         Wd1ZkgJUMiU2B/YCLjdy1B3g4N9F7VQpQmW82bSog/mi/Wtw86PEBNXLH0w557SUDvB9
         cLMg==
X-Gm-Message-State: AOAM533ErVh1M4URuOO7cntXYJJi+GbFa0uilRiwdq+95vUeMA/AC3lI
        jtUaK79MfMPG4ujO7mYa+qk=
X-Google-Smtp-Source: ABdhPJxVzztJOp8zxpFIIdu6VWDoKoZHIaU5g01CLtNCICvz1PfH3vMAQPmDV+ZqpzNchd0a4Vc7fQ==
X-Received: by 2002:adf:e788:: with SMTP id n8mr4197682wrm.214.1629555761721;
        Sat, 21 Aug 2021 07:22:41 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id e2sm9683201wrq.56.2021.08.21.07.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 07:22:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: fix test_cancel_req_across_fork
Date:   Sat, 21 Aug 2021 15:22:04 +0100
Message-Id: <956be84e623dda6f7fbd0e0b0840a8dff22e6f45.1629555705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rarely, the request we're trying to cancel may not yet got picked by
a worker, and so the cancel request returns 0 instead of -EALREADY, and
it's a valid output we should consider.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io-cancel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index 9a36dd9..a4cc361 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -339,7 +339,7 @@ static int test_cancel_req_across_fork(void)
 				return 1;
 			}
 			if ((cqe->user_data == 1 && cqe->res != -EINTR) ||
-			    (cqe->user_data == 2 && cqe->res != -EALREADY)) {
+			    (cqe->user_data == 2 && cqe->res != -EALREADY && cqe->res)) {
 				fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
 				exit(1);
 			}
-- 
2.32.0

