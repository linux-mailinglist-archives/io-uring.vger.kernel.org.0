Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA624320D0
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 16:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhJRO6m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 10:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbhJRO6c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 10:58:32 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD225C06161C;
        Mon, 18 Oct 2021 07:56:20 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id o184so4615291iof.6;
        Mon, 18 Oct 2021 07:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hdr2dRLUt3IvmtpjSWHuCnzGrEz+FDPlFqvXtc4t0b4=;
        b=q4AkAROiUzc7bXDfhBGMPCHYeQUZqb3uJ6oZABhYhcL65oepI+NFIfsXEhXSS/7HU2
         O/zpepFWtjfGD2Rb890Uk+A2nOkal516mf9J578pjQqWXfbI/AdbYgZe34OpOwDJ7YAV
         xryaon1FTUoLmtAA/l5rg3bqLSYje1LTicxWieABh9ujPGXy0drf2jxJw/mvI2sQOeua
         w/kUlK5QiIrPsbDmlWQIwmHybLngAeoz9sIDc3DpZB8/GZLT33pX/LZYgzwZ+lsHZBfi
         a1vkjfTuZVIM/H3GcGkDWlPzwQdhRsCvh+yYTh/JU/tDNizzaPj6V7yYchliOfJEqPIM
         z+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hdr2dRLUt3IvmtpjSWHuCnzGrEz+FDPlFqvXtc4t0b4=;
        b=jFeZeVK6nuP8N1yZ6BH9OVp0dh5IK9V4/R8nbzYtgmLTkHsKbLfFLxwB5SnvhpiAPl
         uSUE7NELIIGgd1aF/TCyBqSqZi50HrBXApJmLKVyB9Po9xOmoql7D0KcBrtBTgsr0TAq
         aXiWLnjHccx6AYG5NXUic5x6LNNVJjCq1MRTnRmyBbae2J0yL2nYyGx+EHUDbeMRcjtp
         gK0Sq1bLMpmwzhY+vy/wjdBSpbkunD2KXHS1f4IZPTXBLUq3JWCSWwA9657H9BoHmJmN
         D5zOhTrOkYdlWRlIs7UpYcTi+khxrJESSraGK6aazROuIAHoSD02ttZX3RzNErgPgoeN
         zOCA==
X-Gm-Message-State: AOAM532HTngAwz/cGSwhbfS1Wr6n4TrqESomnDdjdka2Y5135IqeWYQ5
        UbRk16yitYwEZ88Oib7gi9sAQtDncEQ=
X-Google-Smtp-Source: ABdhPJyYJWuacrOecwhfuQQS5XCacRduppR3iXfv3/UYOi37iBqxleoDXdbWxzoOl1Nbol/KYAQrzw==
X-Received: by 2002:a05:6638:3052:: with SMTP id u18mr175359jak.148.1634568980317;
        Mon, 18 Oct 2021 07:56:20 -0700 (PDT)
Received: from localhost.localdomain (node-17-161.flex.volo.net. [76.191.17.161])
        by smtp.googlemail.com with ESMTPSA id r24sm6867968ioa.5.2021.10.18.07.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 07:56:20 -0700 (PDT)
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     goldstein.w.n@gmail.com, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] fs/io_uring: Hoist ret2 == -EAGAIN check in tail of io_write
Date:   Mon, 18 Oct 2021 10:56:13 -0400
Message-Id: <20211018145613.22186-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211018070242.20325-1-goldstein.w.n@gmail.com>
References: <20211018070242.20325-1-goldstein.w.n@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This commit reorganizes the branches in the tail of io_write so that
the 'ret2 == -EAGAIN' check is not repeated and done first.

The previous version was duplicating the 'ret2 == -EAGAIN'. As well
'ret2 != -EAGAIN' gurantees the 'done:' path so it makes sense to
move that check to the front before the likely more expensive branches
which require memory derefences.

Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
---
 fs/io_uring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d1e672e7a2d1..18293407e8bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3648,21 +3648,19 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 		ret2 = -EAGAIN;
-	/* no retry on NONBLOCK nor RWF_NOWAIT */
-	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
-		goto done;
-	if (!force_nonblock || ret2 != -EAGAIN) {
-		/* IOPOLL retry should happen for io-wq threads */
-		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
-			goto copy_iov;
-done:
+
+	if (ret2 != -EAGAIN ||
+	    /* no retry on NONBLOCK nor RWF_NOWAIT */
+	    (req->flags & REQ_F_NOWAIT)
+	    /* IOPOLL retry should happen for io-wq threads */
+	    || (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))) {
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
 		iov_iter_restore(&s->iter, &s->iter_state);
 		ret = io_setup_async_rw(req, iovec, s, false);
 		return ret ?: -EAGAIN;
-	}
+}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
 	if (iovec)
-- 
2.29.2

