Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F910215938
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgGFOQH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbgGFOQH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:16:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C7C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:16:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 17so42284880wmo.1
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XSM+wNbUpBErdeGCpkm3vYzq+wancK5WjdL49sdHWdo=;
        b=AdpZYKyg4eP+Cjw2qJpA7CCUtyIzYZ19NYc4mQFbOGyJGAN4iYcrbTUMoxXREnU7+j
         pwS23w/5e9tcp+HU6u/UZvdd/Df2PIJUU+wG5KWnqvcKh1iO5K0UCp6LcuS4FcxFQEaL
         PPiJ7m36U+JH/pr96nL7AqDlAH8C/G4jn13Z8PBhb+OEjIPf38e9PX1Qtl5k/Y36qPO6
         jXLWov6hx5JUSN93g95R9TL97Rl+Pe9ogdk4V4rCo7krP1Kl83W521EZsm3TS2vAW8hW
         Ye55PCiQ+V4dXL+/Rruyuhc2YR8EWtfU+u2QF6U+/q1lfINjlWgy8LantSofjqW538yS
         90Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSM+wNbUpBErdeGCpkm3vYzq+wancK5WjdL49sdHWdo=;
        b=VQHEv899AyPkXT+h1P1JAqi/xycHJc70l+7NH7FD0f/5ENQXB+Pverk92yyYUrCOQB
         W4fBWoBPGfgHqQh27SWh7J71ylJLgH0k4W1aapsu7OhS3D8nNbnrmwKnBhMffLhPjcZS
         fxPuhcZprSFS5TLjPx7LNLbNPy9imiT6NVSkIICqS4Xr+cx5vl5EE0TOSoG6KZmO30Tc
         YzNUWPvYDESbbkaOnO+F8on77wVuRDkKWUVbwKp4OMTyjeQ+x56UXXNw5Z5KBBvgXXFS
         ycZ3ScJFizJWWs624M0YoGnxk+UzZ4wmH/PMvZNIyKaSWegcKF7BPWEfD8LSqNvyH47p
         tOkg==
X-Gm-Message-State: AOAM530RnmYxIxIM3SarL6EoPBZULpdynTZQIuTc3EtnmHhAikN/yPyv
        LbiYt2RcTOG3cul1qELrhzbH6I65
X-Google-Smtp-Source: ABdhPJy9oYeSlYvWNOhMgkIqAmT6LpH7RBktzbTTsD0xNdPiGwEU6CsQ1KUVMZOIjtoYFlb/LP9IMA==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr51163743wmk.149.1594044965858;
        Mon, 06 Jul 2020 07:16:05 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 1sm23719286wmf.0.2020.07.06.07.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:16:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: don't delay iopoll'ed req completion
Date:   Mon,  6 Jul 2020 17:14:11 +0300
Message-Id: <b10180e4f58ab85a2b32a61a71fbbfab72344b18.1594044830.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594044830.git.asml.silence@gmail.com>
References: <cover.1594044830.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->iopoll() may have completed current request, but instead of reaping
it, io_do_iopoll() just continues with the next request in the list.
As a result it can leave just polled and completed request in the list
up until next syscall. Even outer loop in io_iopoll_getevents() doesn't
help the situation.

E.g. poll_list: req0 -> req1
If req0->iopoll() completed both requests, and @min<=1,
then @req0 will be left behind.

Check whether a req was completed after ->iopoll().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a2459504b371..50f9260eea9b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2008,6 +2008,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (ret < 0)
 			break;
 
+		/* iopoll may have completed current req */
+		if (READ_ONCE(req->iopoll_completed))
+			list_move_tail(&req->list, &done);
+
 		if (ret && spin)
 			spin = false;
 		ret = 0;
-- 
2.24.0

