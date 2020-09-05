Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABE325EB11
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIEVs3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEVsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:48:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F610C061245
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:48:20 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n13so9195934edo.10
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2Oom0dNRtPrSBao4ztc8MzIu9gTZDAqmrmdVxOf+LpA=;
        b=IaoVF2SMiaaBquNotswo7KormCz1QJOOfto9oVpNBc7NT3SGPC8QYKAqWcS51FPWsX
         kFYoOLL+JWw/8m/Rk8BaPgsr0HU+/oSMkkg4Q3MEGHXg3ov12LsiXQAjKoVpUN+uHNrU
         JKNdPYRQk2ymgOTzYpLwYL2HQzHp1jIymFYWnSngjvjJzb3fCSUpNPad1rGFI8yqAy6R
         j/3gHOvYgGvS7vTb+5ELourLV7sPXCA1abQQXGEmif5GgjwbcQ7cyom8CsCktXzEE8eD
         usreJiL01LIB7f9ici5FCjAvetXVk8N9DBrsWRi+i9zLnbYa5YZCHQjyWHAdyPwTOpiH
         nHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Oom0dNRtPrSBao4ztc8MzIu9gTZDAqmrmdVxOf+LpA=;
        b=A8xMS4uIHUPt1Afr+yR6Eo9bmkQstAt9TSX7hGHUVmWQPIrUrJHMkymbfRD3/fF48b
         89sq0fsoqcof4lYy9TMe+x2mjoljYBlUCpITGuG3tQGk6GJ4VoGTB4Z5iyk7wERP/s1Z
         l0Gz+8WxxqYpRAFUj0f1oR2JDYG57c1Yy8/NCKuSsoy+YM3MCMVPji/mF0XLWnnR8vf6
         iTjiPNe8WC9S6qlJsB2cZ+aSpx1mNUZLM5Y4hXoYfp8MujVcWoPiY0wUdrWyAqOq3UAF
         blX3VuqKvQJlqy8hRudWrsHq1BvwmppHWoFsDy2RR2fNZyFq3+QO6UfCBXRVDaRTVYAD
         yQ8A==
X-Gm-Message-State: AOAM532FUXoEs57kXpXR7mP1faa75U5jrOQxFE2byzvq/0trBRDB8+7t
        ME3EfFJSIYzoLSsTW9bkAJI=
X-Google-Smtp-Source: ABdhPJxCk9IwVGO+cMUSrvbfW1CRjV9dFdacDWFzHdRSUFT/WIy/CszTta/xG4cZuvTbohJim4ddeg==
X-Received: by 2002:a05:6402:209:: with SMTP id t9mr11370863edv.208.1599342499192;
        Sat, 05 Sep 2020 14:48:19 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id g25sm7965603edu.53.2020.09.05.14.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:48:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: simplify io_rw_prep_async()
Date:   Sun,  6 Sep 2020 00:45:45 +0300
Message-Id: <e465708d526db522f77c1c1082fafc9e0721ddec.1599341028.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1599341028.git.asml.silence@gmail.com>
References: <cover.1599341028.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't touch iter->iov and iov inbetween __io_import_iovec() and
io_req_map_rw(), the former function aleady sets it right. because it
creates one more case with NULL'ed iov to consider in io_req_map_rw().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f703182df2d4..e45572fbb152 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2980,16 +2980,14 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
 				   bool force_nonblock)
 {
 	struct io_async_rw *iorw = &req->io->rw;
-	struct iovec *iov;
+	struct iovec *iov = iorw->fast_iov;
 	ssize_t ret;
 
-	iorw->iter.iov = iov = iorw->fast_iov;
 	ret = __io_import_iovec(rw, req, &iov, &iorw->iter, !force_nonblock);
 	if (unlikely(ret < 0))
 		return ret;
 
-	iorw->iter.iov = iov;
-	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
+	io_req_map_rw(req, iov, iorw->fast_iov, &iorw->iter);
 	return 0;
 }
 
-- 
2.24.0

