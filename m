Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5087235B109
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhDKAvQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDKAvP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:15 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E3DC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:59 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id 12so9254342wrz.7
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oX3WzSPm28qN2TSO7/GZJkVzb6DpFAQFRkb/DPJbjww=;
        b=CVi3Bi484yXU64ph4SDgo3f9fPdhlocw/1xKc5joqVeXTo6NWOU2MyNsA98mhZjskS
         CeN/ISdGSCbWn1Vdec0yu6JvG9iZnqTAURVhH3TaslBcPQIlpFrlfVQseKbT4qhiyyvY
         ajIF03Ba76VnPf7oZrb7xyPbtLuB9R1uvcZxNk/bQdj7us/qrJBy7jw/nyW80456A3W1
         TsZHlNGj9vy+RusbK2tNi6ApFqmD/xFhPWdgefHBXwoMcR118sWq6c5GkdgjhaAUMZ7t
         J+YrwTLyRjA0dVGw5Mb6HGoTNCQVsKz8S7vNWy5w1JiXq0E7Z1M7ZsEHfR0l6efaO9YK
         kzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oX3WzSPm28qN2TSO7/GZJkVzb6DpFAQFRkb/DPJbjww=;
        b=OHuVePZ0qA2jCZ7Hk6QM7rka+tIrhlXcOxmIDvNc1URQfM347sXvmGjDj/wj9Xf/KZ
         Ef7lv34/90lL12+Gwbp4TIkhUSif9DgeJ9sbVZ0WG+857KyyebipZyvO6cY9pXnuQWJF
         JRJ7OrbFWjDTe2kjO26emGTV3I4L1w/ckJEqOMNg79U70FxAY0TgZJT0b6PETz63RSrh
         mvISmqdIa1QciD0nr42IPgLFNk/SyqkQf3J6MVieps4aytKtnasPptcOQJcnYn+wA27E
         l9yqaatdgiov1Hcrc0/jiviEltfN6ljwCKPMtvMzTmC36eMQfi2kYXaEGEH9HkRKmv2/
         yDsw==
X-Gm-Message-State: AOAM533IelyiPa2+NbQ7wU+MLECl19BAzoR4lfctGAwoWFwIBMVBL+AX
        h8gU6XtChUZrXDmTh1AAaGwRe3qWf4pwMQ==
X-Google-Smtp-Source: ABdhPJylzmsCcts2XWwrIIG2ow0LiWdKSbooWFVJu8uhxRMLCdpcuqZzP3UJ0GVXp0E1ToI/xhjOjQ==
X-Received: by 2002:adf:e541:: with SMTP id z1mr23838287wrm.383.1618102258210;
        Sat, 10 Apr 2021 17:50:58 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/16] io_uring: enable inline completion for more cases
Date:   Sun, 11 Apr 2021 01:46:29 +0100
Message-Id: <0badc7512e82f7350b73bb09abbebbecbdd5dab8.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Take advantage of delayed/inline completion flushing and pass right
issue flags for completion of open, open2, fadvise and poll remove
opcodes. All others either already use it or always punted and never
executed inline.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2b6177c63b50..cfd77500e16c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3848,7 +3848,7 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
@@ -4126,7 +4126,7 @@ static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
@@ -5322,7 +5322,7 @@ static int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
-- 
2.24.0

