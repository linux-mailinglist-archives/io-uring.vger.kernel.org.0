Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991E02F9039
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 03:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbhAQCeV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 21:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbhAQCeV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 21:34:21 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E1BC061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 18:33:40 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id e15so4500496wme.0
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 18:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DPRs68GVZpn+eawFsdtPzmnmfC7PpnofLunBIuWjkF0=;
        b=kbHSbgOkzD9Ls9r7gO41XdDArs4EoOm7yZ0E8BUzlBhA3axYwxZKsWU+hvkAU+n4aR
         +CpLd0DI4qoFnpNvJhsAb06XH+fouuv/o7rqobsQU0DAmxvesuqvMs3uttI+zSyxflPW
         TJvlykENi1aw8AXizeBqCqurHkLuIsfUKYswCd0fBO9r0Oj9Xuc5XdhdbbUEZ46/B654
         gGpG3Q05QokuUgG1nX2yc4l1BnIivjnuWes62hLDGTibh0hzmhg1I5JPNDt3/g+Fdo9P
         E7Y4mhW8tb9D9S0/hjBq1B+HeEyVHYqxcx2KZfZbexk+a9z45WqJR/WBtu6plNugPVSz
         +nDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DPRs68GVZpn+eawFsdtPzmnmfC7PpnofLunBIuWjkF0=;
        b=PHx/etvmUWbgghPWRzGd3Xuswr6DOPB6Nov51nQ1z5SUWje97hZdTS+5JBRSI02WYE
         SpMuq87mdGXFmwOyMxca+rC1VH5slSpY0laBpmehRiyPBmXZa4YZSxAGtLhfG+2Zg8Fh
         N45T/YrWBqYTKm9i2g8gOFLJ9MkdxjYf2J1Ie12ALIkP9Bwe8k7dO4Xg8fN3pr4+vU4H
         e9Rc1eezfIFpn4fNaJDE7BJaOPk+BVLKPvPE3VSkde8HHYI3snFkTTzeb3jKTx3CC9O8
         IBAVXpQY/QBgUnxZUtkNylAwzPNj5v/h+uHEA98iTdI81C1fhKqfVcOpO4SrFlpqaalj
         rnXA==
X-Gm-Message-State: AOAM531zUAM6m+W8fPeNwAh4vqIyViUH3ivG4fU/E5nssu4W9BDm2w9b
        D34MH3YlOx2aipp49Ax7XyO9KyjVyhI=
X-Google-Smtp-Source: ABdhPJxodKD0bjIJbeS8kt15kuTaNjfv1JVI4K2L3e3NdamEHLaxilbRKw4IwvYzz7UexVCGqyrudA==
X-Received: by 2002:a1c:2605:: with SMTP id m5mr15113097wmm.111.1610850819054;
        Sat, 16 Jan 2021 18:33:39 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id q7sm20407892wrx.62.2021.01.16.18.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 18:33:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] io_uring: fix skipping disabling sqo on exec
Date:   Sun, 17 Jan 2021 02:29:56 +0000
Message-Id: <aafb4f9c5380abad2142d33f4969ae5ac32f2c31.1610850562.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If there are no requests at the time __io_uring_task_cancel() is called,
tctx_inflight() returns zero and and it terminates not getting a chance
to go through __io_uring_files_cancel() and do
io_disable_sqo_submit(). And we absolutely want them disabled by the
time cancellation ends.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: drop sq_data stuff, can't happen

 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d494c4269fc5..383ff6ed3734 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9085,6 +9085,10 @@ void __io_uring_task_cancel(void)
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 
+	/* trigger io_disable_sqo_submit() */
+	if (tctx->sqpoll)
+		__io_uring_files_cancel(NULL);
+
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
-- 
2.24.0

