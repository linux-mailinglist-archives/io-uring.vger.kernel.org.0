Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CAC319666
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhBKXMz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhBKXMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:12:54 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912A6C061788
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:13 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id o24so7293904wmh.5
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FQnundIDPSJ5zP1cDSj4ZTrcp5+brNfXp0SE0k15vlA=;
        b=g27IXdTaPEEXUixJMFU39GzGlrHakbs6iDQr/6TFYVX7e+Ln/U0WXl94IMbFuQRov6
         tEjoeFY9TiMtliBTsuEqzhH1KKcJ4/xq45b2N49fTPU8dVqW9UY+EoHbDEJ0ALrmW8pL
         TtXb6K3pb+oMNw7IHLcVNFH0fwWIe7u4aC8EYlwIWJlxuN9m7Wx7S2ZloN7QDZ824t3r
         dEKrngViulOTFUY3tlQesh0b+RUZEc9IeITvnsiKTVcfq6bshfy2euwy94E2fcKvJnga
         6wr9o5lF5+899blxSC83j5Q3t3b4q9DAPeY+k8+77dgg3S7iuqswYAsk13+0tzk2v8P6
         kaaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQnundIDPSJ5zP1cDSj4ZTrcp5+brNfXp0SE0k15vlA=;
        b=dRAtf4IpkeMaCdbA4SH6M3pbIUTbdBZK7gX1BbG5qxfnAWTK9Mv4zU9EYpjBfpUA5V
         VHPv+fy/VgdQVLEGAVl3HC9W/my7JbZtZHPMztJqY1oRvw7XQYLtx2gql/yigJEaSgdH
         BDQT7OYMDvTBB/N6s++UEr79+fZ8aBtU17FD3yX6o8w637O1R3pzcA2AKidaX0ZIlJ4U
         4oMFg3JWxOswSSW98GWIwtbgFJy36v1QDL/JXufGvoMZorePXk9PCJCL50/WopfluzyB
         C2zcC/fbnVtXz2Ob81iM+roE3c5EKyA2EkB+riL4aH3ZDirVa1UN2ODK68pYV6paASn6
         R48A==
X-Gm-Message-State: AOAM533qjd09U+Sy7qct21gPwkMrs+0uSnVoit14WUEpyjUcw0b0e3Yw
        xEVvpfhIFV4agj7L+ak76d0=
X-Google-Smtp-Source: ABdhPJy7igkvUU5+R7sVuVhgRnvI3H5SkKNDuA/DWfMqs0I/pcxOT4XNTCcuxAZyMH+zZej6vEiMIg==
X-Received: by 2002:a05:600c:2351:: with SMTP id 17mr257074wmq.2.1613085132433;
        Thu, 11 Feb 2021 15:12:12 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id d9sm7271184wrq.74.2021.02.11.15.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:12:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 4/5] test/sq-poll-share: don't ignore wait errors
Date:   Thu, 11 Feb 2021 23:08:15 +0000
Message-Id: <3423f7d9c689456d3b506186ad939f7f444b4f3c.1613084222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613084222.git.asml.silence@gmail.com>
References: <cover.1613084222.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Check io_uring_wait_cqe() result, it's not safe to poke into cqe on
error.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/sq-poll-share.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/test/sq-poll-share.c b/test/sq-poll-share.c
index 0f25389..02b008e 100644
--- a/test/sq-poll-share.c
+++ b/test/sq-poll-share.c
@@ -60,7 +60,14 @@ static int wait_io(struct io_uring *ring, int nr_ios)
 	struct io_uring_cqe *cqe;
 
 	while (nr_ios) {
-		io_uring_wait_cqe(ring, &cqe);
+		int ret = io_uring_wait_cqe(ring, &cqe);
+
+		if (ret == -EAGAIN) {
+			continue;
+		} else if (ret) {
+			fprintf(stderr, "io_uring_wait_cqe failed %i\n", ret);
+			return 1;
+		}
 		if (cqe->res != BS) {
 			fprintf(stderr, "Unexpected ret %d\n", cqe->res);
 			return 1;
-- 
2.24.0

