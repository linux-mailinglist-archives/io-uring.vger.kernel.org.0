Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DAD352F5C
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 20:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhDBSlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 14:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbhDBSlS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 14:41:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73C4C0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 11:41:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l123so2577786pfl.8
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 11:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zMAmb/6/tSW+kcZl+B+aUDGb1L+zgqfjdSaTdqtD8Dg=;
        b=OV6tgDaFs9FEB8lEysk9ISeGasE9Q130y8+Jy9VOnzKVSDE+YPJ4rbhqGlPIel60pO
         Zz3QxrTW9ITw6tgb8G6SAWX+SaDuLo7HJ6xn0Q0fnRqjTsIFCGyIdCCDe9WPWIyLbwSB
         zAs/UoeMtkM2AWP304AFz6MkiN5yfig7cScpFYg5vQhjgqp9RdsOIMeZBNlJK8OQU8SX
         M2Yq4HepNFy4mEmXGYvlGCSpIC5SaruTOemkaJLCMzwOfDBt1ycNzU/ZXfiuebk4ig5S
         y+4w5ArDuNiNVl6MvyRFE8HAdz/xPAqLxcYVnNxCvmA05BjO5LEHWDSUhVIocak5iUj5
         lsxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zMAmb/6/tSW+kcZl+B+aUDGb1L+zgqfjdSaTdqtD8Dg=;
        b=OpvPvJTObdt2gfUAfesMDQ9miG7qp1jULco+qFSyW+zbbfU8nm5zg3lkdlV+Xl1qjD
         HrTmaL9M2FuM58hMm2PIDr4AdVCtWNjpST4U9OyybLNfxFakjwtECoRZwDvoFxRpPMkz
         1EeyXGECIiNM6/MAZyTSN2H3wZp6d7l2w4kr0g/2dEOYvT3wwq5arIoWDd1wd9k3IAID
         in0mA2RbRywi7QoxaErldZ4m3Vt3QTeV2TE87lqLEtrPqiADvKnovk2ED3dQFNUH2Qmd
         0nq6daG2wQb2IwToppvN7+kMri5BHz3TE8atJoL5+zgiUmiMkOJ9OLTcJ+gT4ODp/ekT
         mKPA==
X-Gm-Message-State: AOAM5333uUhdq6b3B/1pcpsKbH0eOSh58rUVgjcEjCuxrDd1UpwlmucX
        nWYMXcT999RZVIwxDX5w4ouP919H66gRoA==
X-Google-Smtp-Source: ABdhPJxJjk2nGgu4CYRa+5/BAV5FqnlZ/XW4N8lGURb0p7Wu6zqZMxCULHYcrwLXSA6M9mq0mrBDXA==
X-Received: by 2002:a05:6a00:b47:b029:20d:1c65:75f0 with SMTP id p7-20020a056a000b47b029020d1c6575f0mr13221828pfo.9.1617388874904;
        Fri, 02 Apr 2021 11:41:14 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d19sm8353124pjs.55.2021.04.02.11.41.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 11:41:14 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: move reissue into regular IO path
Message-ID: <6f52350f-ee76-c5bb-5faa-1c345cbb1251@kernel.dk>
Date:   Fri, 2 Apr 2021 12:41:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's non-obvious how retry is done for block backed files, when it happens
off the kiocb done path. It also makes it tricky to deal with the iov_iter
handling.

Just mark the req as needing a reissue, and handling it from the
submission path instead. This makes it directly obvious that we're not
re-importing the iovec from userspace past the submit point, and it means
that we can just reuse our usual -EAGAIN retry path from the read/write
handling.

At some point in the future, we'll gain the ability to always reliably
return -EAGAIN through the stack. A previous attempt on the block side
didn't pan out and got reverted, hence the need to check for this
information out-of-band right now.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 717942474fa9..8be542050648 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -697,6 +697,7 @@ enum {
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
+	REQ_F_REISSUE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -740,6 +741,8 @@ enum {
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
+	/* caller should reissue async */
+	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
 };
 
 struct async_poll {
@@ -2503,8 +2506,10 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 
 	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
-	if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_reissue(req))
+	if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_should_reissue(req)) {
+		req->flags |= REQ_F_REISSUE;
 		return;
+	}
 	if (res != req->result)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -3283,9 +3288,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = io_iter_do_read(req, iter);
 
-	if (ret == -EIOCBQUEUED) {
-		goto out_free;
-	} else if (ret == -EAGAIN) {
+	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
@@ -3295,6 +3298,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
+	} else if (ret == -EIOCBQUEUED) {
+		goto out_free;
 	} else if (ret <= 0 || ret == io_size || !force_nonblock ||
 		   (req->flags & REQ_F_NOWAIT) || !(req->flags & REQ_F_ISREG)) {
 		/* read all, failed, already did sync or don't want to retry */
@@ -3407,6 +3412,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		ret2 = -EINVAL;
 
+	if (req->flags & REQ_F_REISSUE)
+		ret2 = -EAGAIN;
+
 	/*
 	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
 	 * retry them without IOCB_NOWAIT.
@@ -6160,6 +6168,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		ret = -ECANCELED;
 
 	if (!ret) {
+		req->flags &= ~REQ_F_REISSUE;
 		do {
 			ret = io_issue_sqe(req, 0);
 			/*
-- 
Jens Axboe

