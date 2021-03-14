Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE77933A81C
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 22:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhCNVB1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 17:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbhCNVBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 17:01:21 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A355C061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:21 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z2so4713926wrl.5
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EmmR0UMUeVoOMQ6m1BaDYQKSQI9p5COZl0wsnYR5p3g=;
        b=YzlqVpxPkQX/z8lQZt23TNVUZAbig9YCO4cpskWPPD08Lb2rpOKVDuvjMY7SqQIC1j
         gjAKP9J+Ldg064IGlqx4gwvxIJqbJKM/nhN3V4Vf4SbxT8jCeZEYTtnwKFCxpLcCWdWR
         mvr1Cj8jDM4llHkDRtN3EPvj8s3wHR1PNxXVWQ/NCO+F6kF+XMsP9QqL716OmrMmEQ0k
         PN6wbcJeVk/7OUgap/LpazjduIGVehDErH9jCSAQfvFoqnv+X7dfzfKzBHwR8sPoIVzw
         xybMuiibQeiFs1924WjfbgljsJmWsJQREEVmehOoBiIGODueoemXAd36oTiQ2v6w6Z5U
         IpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EmmR0UMUeVoOMQ6m1BaDYQKSQI9p5COZl0wsnYR5p3g=;
        b=YV70BNbJxNE8waZRh+cv+WmCZiDao2ufKgEUgY5ILbsLFt204MLaX9mBi/kTvFrx4B
         W7HY/hDlEpTzVUmkfkmo28s1UAkEsfMJPzMG266ZDJiuFpPu5Nyma/ZJA1ADjJjTg4h0
         Fy7kk9afTw/hcJJFpWnCl5GiP4OHUcM5UpG4hRInN+rmljxYL+hH3lGOJVMcJkB3wvVH
         IKFogko2QMXrg+bt6qq6b/dom574seecYhEMoO1RDbS3QQHypblkOTOs/ruIoGVSB5LW
         FGDZSfDhGh3rOEiO6OU77E2+abjGZr1indkNV++RwHFFxvGnZw2YZqi16HRqM+XsyoyD
         E8qA==
X-Gm-Message-State: AOAM5334Jb20n1sPzgDUhsiyGk4bTwYYF5oTpZM40xwqqFJM+/pX6cGT
        hUMu/raHaKSAMTp1MRaXjGs=
X-Google-Smtp-Source: ABdhPJxQmPeInRGXVDtYYhZzncotuco8yWPWBwIgAfi69dSwHcLw6yYiUkASdh0jywwPkXMbgX6WGw==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr24473371wru.214.1615755680270;
        Sun, 14 Mar 2021 14:01:20 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id q15sm16232527wrx.56.2021.03.14.14.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 14:01:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: fix concurrent parking
Date:   Sun, 14 Mar 2021 20:57:12 +0000
Message-Id: <d5a054361c250d3b1b139efae2c2ce10b1437002.1615754923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615754923.git.asml.silence@gmail.com>
References: <cover.1615754923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_sq_thread_park() of one task got rescheduled right after
set_bit(), before it gets back to mutex_lock() there can happen
park()/unpark() by another task with SQPOLL locking again and
continuing running never seeing that first set_bit(SHOULD_PARK),
so won't even try to put the mutex down for parking.

It will get parked eventually when SQPOLL drops the lock for reschedule,
but may be problematic and will get in the way of further fixes.

Account number of tasks waiting for parking with a new atomic variable
park_pending and adjust SHOULD_PARK accordingly. It doesn't entirely
replaces SHOULD_PARK bit with this atomic var because it's convenient
to have it as a bit in the state and will help to do optimisations
later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4b8988785fb..ccd7f09fd449 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -258,6 +258,7 @@ enum {
 
 struct io_sq_data {
 	refcount_t		refs;
+	atomic_t		park_pending;
 	struct mutex		lock;
 
 	/* ctx's that are using this sqd */
@@ -7064,7 +7065,13 @@ static void io_sq_thread_unpark(struct io_sq_data *sqd)
 {
 	WARN_ON_ONCE(sqd->thread == current);
 
+	/*
+	 * Do the dance but not conditional clear_bit() because it'd race with
+	 * other threads incrementing park_pending and setting the bit.
+	 */
 	clear_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+	if (atomic_dec_return(&sqd->park_pending))
+		set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	mutex_unlock(&sqd->lock);
 }
 
@@ -7073,10 +7080,9 @@ static void io_sq_thread_park(struct io_sq_data *sqd)
 {
 	WARN_ON_ONCE(sqd->thread == current);
 
+	atomic_inc(&sqd->park_pending);
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	mutex_lock(&sqd->lock);
-	/* set again for consistency, in case concurrent parks are happening */
-	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	if (sqd->thread)
 		wake_up_process(sqd->thread);
 }
@@ -7096,6 +7102,8 @@ static void io_sq_thread_stop(struct io_sq_data *sqd)
 static void io_put_sq_data(struct io_sq_data *sqd)
 {
 	if (refcount_dec_and_test(&sqd->refs)) {
+		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
+
 		io_sq_thread_stop(sqd);
 		kfree(sqd);
 	}
@@ -7169,6 +7177,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 	if (!sqd)
 		return ERR_PTR(-ENOMEM);
 
+	atomic_set(&sqd->park_pending, 0);
 	refcount_set(&sqd->refs, 1);
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	mutex_init(&sqd->lock);
-- 
2.24.0

