Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBDB2BAF5C
	for <lists+io-uring@lfdr.de>; Fri, 20 Nov 2020 16:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgKTPyK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 10:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgKTPyK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 10:54:10 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0FCC0613CF
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 07:54:09 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id m16so10039273edr.3
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 07:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OILOfqlLNv9tp6SMGqAt+v+Eax8o/Z7/Ud7bw2UXgbk=;
        b=nQjv62oMf37mNQ1ChDR0UFhK7RCZIqjy4KwIcHXW9pP12C9dqmChQ7NU88yNubyB6A
         w1CHY9sRH0P0cPZTgUz/U11gCqwpfHfIwBcgaFQzJR7On1MSVRR1xxbXVJ4DYQIjzpPv
         riOY4dhjQl/NA9cmsGPtnGvoSkog3Fv2CFwbtYTYbjLLwNG12+uPOxvKUaYypDRX/+wT
         0qpRaYi6sYQw3EczOHRZAbrCvDnYoojUi8jM3uIhQKaSrpUPmFZDTP3WSoPuF5Wt0pNy
         w3W58vqtbOS257rjkFi2xvyWkZV0m9hguFi61nhQHz/DC+YsQCJ1adB2c8Ps/HOX3jIP
         htOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OILOfqlLNv9tp6SMGqAt+v+Eax8o/Z7/Ud7bw2UXgbk=;
        b=o3bN9LkdRhw5lVHd8SPvDcEguWn+yH+pyb5I/f/b2297BNNx3nNkyDdGvBnSSsuuIv
         2gTX0a9AhKDbewxewgrH4iWtEyGq3j3DyHq8IhY1LBzYSCym6mnaCbmx9ZYSSPGR7si5
         uPIeVW5bw9rl13n+EAh3SOmzOBIBjH4BxwP9w0D5281PioYpgVerI89j/t9CEbIKFVY8
         GTkCJmpJd7S/1svF3iCmJ2O1G90Mxq7AB92SnrfuWFKGinyl6QHHoIpGhIQpEKXfnQql
         AMdgZA3NdUNLaH5ePkDVIyz8B6B+Wh06pbEZfhjdxNdaiOF0T73GEH6Zmu3SxuimVqvJ
         22rQ==
X-Gm-Message-State: AOAM53352MZ9tiwu9/owVOWBxPbNaXMiZCrFeaQXZ/EP7gh4wRLvYW7s
        p6O/FOTey1XIZfVGR2L8eyY=
X-Google-Smtp-Source: ABdhPJwEzOotZGvqQbVG/Zbf3LtGfzHX0j5qrem9ab1wMrMEEWrdpRPI2Q7kf6sNKE1GbVlTIXmeFw==
X-Received: by 2002:aa7:c2c3:: with SMTP id m3mr35877256edp.361.1605887648470;
        Fri, 20 Nov 2020 07:54:08 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id y24sm1253956edt.15.2020.11.20.07.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:54:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix miscounting ios_left
Date:   Fri, 20 Nov 2020 15:50:51 +0000
Message-Id: <bac793cf9a7b4d0bd12d860214e109567d2fc943.1605886827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605886827.git.asml.silence@gmail.com>
References: <cover.1605886827.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_init() doesn't decrement state->ios_left if a request doesn't
need ->file, it just returns before that on if(!needs_file). That's
not really a problem but may cause overhead for an additional fput().
Also inline and kill io_req_set_file() as it's of no use anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62c87561560b..72fd80f96fde 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6361,15 +6361,6 @@ static struct file *io_file_get(struct io_submit_state *state,
 	return file;
 }
 
-static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
-			   int fd)
-{
-	req->file = io_file_get(state, req, fd, req->flags & REQ_F_FIXED_FILE);
-	if (req->file || io_op_defs[req->opcode].needs_file_no_error)
-		return 0;
-	return -EBADF;
-}
-
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -6782,10 +6773,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		state->plug_started = true;
 	}
 
-	if (!io_op_defs[req->opcode].needs_file)
-		return 0;
+	ret = 0;
+	if (io_op_defs[req->opcode].needs_file) {
+		bool fixed = req->flags & REQ_F_FIXED_FILE;
+
+		req->file = io_file_get(state, req, READ_ONCE(sqe->fd), fixed);
+		if (unlikely(!req->file &&
+		    !io_op_defs[req->opcode].needs_file_no_error))
+			ret = -EBADF;
+	}
 
-	ret = io_req_set_file(state, req, READ_ONCE(sqe->fd));
 	state->ios_left--;
 	return ret;
 }
-- 
2.24.0

