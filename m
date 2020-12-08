Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6922D35BA
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 23:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgLHWB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 17:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730482AbgLHWB0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 17:01:26 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF994C0613CF
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 14:00:39 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id i9so2195990wrc.4
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 14:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q6xtwZhsJg4d4Q2Ek0CxrT0EGWkgUWRkydyCRkxbJgo=;
        b=jfChiUwYtYbtbJK+gMKuefF/YsnjdpDBphDW2my2pOWRKLxFhxQ5c6i2gL9oVyI3kH
         xZ4GbI0eo32qB0f3AQGZg03ejatDMF2Fyt45FO/ocH5/maQ/3YsWalvREQKCmchZXkj2
         njEzJW/WRJRByl+YPnfv4PvFiTug6CO3a62wXPLbO2SGTK484I0ggAJ5rwoSY+3uWNsR
         lFbn7N+OhsGETmzoHAZnrAiAG2/ph0OxkEwj1bQCIVgP/a9bHR2opNNkCFGmoHlRakV1
         JOJpZpr8/d80jqccAAptTJco8KZiZ+K+Zarrp8xugL76AZ6MVwMNC8OLnXQ7R8+hY5Up
         fMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q6xtwZhsJg4d4Q2Ek0CxrT0EGWkgUWRkydyCRkxbJgo=;
        b=bzQhePySLiBQo9YgQWj/VoOagFshkxQev/69g/IxeaqqBSj+dZp7W5V4KTRLTfaM3e
         R0K4yDzyg3N0/QR7xFWLI0JFeWTjbEqoZ/gRwEfNERIsVuwvMpHWb+bHCcrDRv0vQiks
         MooM1TO1UfkFQPkXlF99PciqFDE+oVE/w5u7Z19Te1Si1ssy0MJLNeGTpQVGvXcCxI71
         A4aY+2Fhv/WsHtQmUVYGivA56Bw47wUd3x5midmDgpxjWLD1HgLzgIA7HgTecjNxuPB6
         qXb62wjqHgETL4+xHF3phT1AckOOly68g5r3gWdzyjaLl70A4+2d9bBAorC4PNH2dWcd
         ZGQw==
X-Gm-Message-State: AOAM531ycAa1SRdtSsHR6Xp7NZfkma9ieQzja5DM8ddmK+LEskAP77Uj
        XB7ZimJ6iOMmPOQ/I6YNBWg2zURNkgJYvA==
X-Google-Smtp-Source: ABdhPJxJDoXxIL+fCG3dpTpTS/mpqoSG2/jptai817rtkY6feObfgeQIgBc/4/VlLF2p8yqBa0pyOw==
X-Received: by 2002:adf:a551:: with SMTP id j17mr118490wrb.217.1607464838573;
        Tue, 08 Dec 2020 14:00:38 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id h98sm339035wrh.69.2020.12.08.14.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 14:00:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] timeout/test: clear state for timeout updates
Date:   Tue,  8 Dec 2020 21:57:14 +0000
Message-Id: <671c1670b4f205411ef93deed9f3bef5603d7a19.1607464429.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clear the ring before test_update_nonexistent_timeout(), because
otherwise previous test_single_timeout_wait() may leave an internal
timeout, that would fire and fail the test with -ETIME.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/timeout.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/test/timeout.c b/test/timeout.c
index b80fc36..9c8211c 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -1260,6 +1260,14 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	/* io_uring_wait_cqes() may have left a timeout, reinit ring */
+	io_uring_queue_exit(&ring);
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
 	ret = test_update_nonexistent_timeout(&ring);
 	has_timeout_update = (ret != -EINVAL);
 	if (has_timeout_update) {
-- 
2.24.0

