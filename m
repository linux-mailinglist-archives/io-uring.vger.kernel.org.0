Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0201292AD1
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 17:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgJSPtO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 11:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730060AbgJSPtO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 11:49:14 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3924FC0613CE
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 08:49:14 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d3so321758wma.4
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 08:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KNu4snfhjRPqeLe9Q4Dezh89wv/9BLmjMR0qxpcYaI8=;
        b=bJfBfG4MLM7A10D8Jv09kA/JcZKPXn++B4/Qr+qMkaXPY5b/tgddfvpjg4RQifFW7k
         jG28YHXr8S49pBBZHp578ryu/iByA6YgLMIVV28Nt7h6BD/sBp3C3l6N18Z8oUOIhbhs
         6V+mQo69mYpOEx+Xiu5CQ25Y9oMjMoT4YyHDKMU2NCeLsbs9OZb8ferQXuLmsvKfFggQ
         ufd4W11tGV8Al7niEgE/e1Fjn75YFdO/TnB+fqKiAc9j7VAM1J3xM95xMU52utOtYiCR
         +dxlfNpNLznWL8SdOhkw2fmVXU2tJu/W8xVlP0UxdgYU89utEaHvP5JTKObrI9VRauS2
         78sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KNu4snfhjRPqeLe9Q4Dezh89wv/9BLmjMR0qxpcYaI8=;
        b=tIEC/RcoptISgGfjekPDQMpc4cwo1fWwvp+hgwWGRajqodr51JafOw81IMjAAChGCl
         yMIK8UleRrQ4i+eRSo3uDJZ+aIrCaiO1di19vnGFwjmB8AYbw5wHQCYRozUtc5xYtOAx
         Za4WKhG7VhDQCA0XAza5Qye3O613GsqZiMNDmuXw5uMI9kKXRRcxO0p0lox1iC+Cddq6
         Nk6mqULq9bXq9urcbdqhvlP9Uc6CoHCXbqmbUXewp2gc0iRPGw0e9DtsX08/lgDcJ/e8
         5xHxkwcV0ZhrFeGQM+zNo7zZeWaZYoC0xafMXe5jypZQ3SsPPTLoMAdxEOssCIy0m2Y0
         ImYg==
X-Gm-Message-State: AOAM532xDVhWslTECcQyoYvvm3Y2d3v+dzfmYbfyJWN0SnByMoxSkbC8
        K/BUyhfUfB4N+JLLv1bbIjwLGtALsT7cig==
X-Google-Smtp-Source: ABdhPJwEFyveooohfVhrMx8Gbevb6lMWJARPw2Jq8JLtSQ0HrCXR9zraF+87TcilGm1DWzySKKBo5A==
X-Received: by 2002:a1c:6804:: with SMTP id d4mr24679wmc.27.1603122552932;
        Mon, 19 Oct 2020 08:49:12 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id z6sm164654wrm.33.2020.10.19.08.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:49:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] test/lfs-open: less limited test_drained_files
Date:   Mon, 19 Oct 2020 16:46:11 +0100
Message-Id: <d6fd0e761f9daafcd4a8092117dfd751c94f2a06.1603122173.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

close(dup(io_uring)) should not neccessary cancel all requests with
files, because files are not yet going away. Test that it doesn't hang
after close() and exits, that's enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/lfs-openat.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/test/lfs-openat.c b/test/lfs-openat.c
index 921e2a1..3fa0b99 100644
--- a/test/lfs-openat.c
+++ b/test/lfs-openat.c
@@ -202,18 +202,11 @@ static int test_drained_files(int dfd, const char *fn, bool linked, bool prepend
 		return 1;
 	}
 
-	/* io_uring->flush() */
+	/*
+	 * close(), which triggers ->flush(), and io_uring_queue_exit()
+	 * should successfully return and not hang.
+	 */
 	close(fd);
-
-	for (i = 0; i < to_cancel; i++) {
-		ret = io_uring_wait_cqe(&ring, &cqe);
-		if (cqe->res != -ECANCELED) {
-			fprintf(stderr, "fail cqe->res=%d\n", cqe->res);
-			return 1;
-		}
-		io_uring_cqe_seen(&ring, cqe);
-	}
-
 	io_uring_queue_exit(&ring);
 	return 0;
 }
-- 
2.24.0

