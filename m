Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DCE23F191
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGQ4C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Aug 2020 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGQ4B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Aug 2020 12:56:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C011BC061756
        for <io-uring@vger.kernel.org>; Fri,  7 Aug 2020 09:56:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id z20so1322009plo.6
        for <io-uring@vger.kernel.org>; Fri, 07 Aug 2020 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SHmi8Gvw/Gpw0qYZnNiHRJJAK4MoE0DIlocKPPpOBj0=;
        b=QH2wRwoEGLUE9yggrGzQ54HIpf+gcc52e0vsOYq78JEYp1PFohkg6IGhW3a+a9utUT
         eLu/Ad4mDlOhYsfoUc+LH2BSbZpPzjRYPMcAdly2WdEjPP0niHifNHlQ7nhnTXiDR+Q/
         6W/9Uw+/jbFmncLAeq/GjH74qW8eh26uEIJw8GP5A5BJ2YdgmzNLE2KZclFueSeWPlSZ
         LnQfPhPTwjrh8VejsTh0nZM1fDt3Y5zFhCzmGaTAIscWAcdoeg45q/ypJhwsuRoo2JJY
         n8+J3knNUgXvBv3pao+HT6d9Ji9bjsLCKP50oxeYi4i5Dt9fh7c4AEYQRMe50pnKzR9r
         xB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SHmi8Gvw/Gpw0qYZnNiHRJJAK4MoE0DIlocKPPpOBj0=;
        b=rTNDSixNLKhlNiDqifdPT0x5wuh2cKhOQqxlbYdVHJlF+h59TgkPfRmZ7oMwkK59Kz
         vDVulkij62GRBCUmx5eRCgIWXa7Rjs3qHM18SF1cNdDN/iAtGpX9macDsbmHpVIUfmHJ
         hp5Z/MZRQHHDX7qLGgv6fiSwsAC8JBMRqDPk0cDx10exuFTssh/AEmQRcoE/+bvpBPpr
         orf7H34HIEHoYqAXgUu/t4++NBRbICPZ1L8usi1v3cPgCgjhKLNlzCEKrv4hZ7sBbfzV
         n4xnKukAL77GZBX8J0b7VqILXUo5vDktT50rhvaxq9JTCWLJjmBc0aU9fFN5h/ImT+xH
         RlJA==
X-Gm-Message-State: AOAM531+q71I+NqTEcdK1KjGG30/XUtow0tyey6P6Ugyg2xMwpYzUtwG
        PbE/fdYVr5tPUnXYFywNLo3Hjx6/Qac=
X-Google-Smtp-Source: ABdhPJwX7gniD6aZUdTvKF9zpdx3RrV0VJKySevDo+gpDOk/hhxK5Q2UZBk/N25hjd3u5sCUDmLFIg==
X-Received: by 2002:a17:90a:c208:: with SMTP id e8mr14206115pjt.73.1596819360128;
        Fri, 07 Aug 2020 09:56:00 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e8sm13494543pfd.34.2020.08.07.09.55.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 09:55:59 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: use TWA_SIGNAL for task_work if the task isn't
 running
Message-ID: <ba5b8ee4-2c6f-dec7-97f2-d02c8b3fe3f8@kernel.dk>
Date:   Fri, 7 Aug 2020 10:55:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

An earlier commit:

b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")

ensured that we didn't get stuck waiting for eventfd reads when it's
registered with the io_uring ring for event notification, but we still
have a gap where the task can be waiting on other events in the kernel
and need a bigger nudge to make forward progress.

Ensure that we use signaled notifications for a task that isn't currently
running, to be certain the work is seen and processed immediately.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Josef <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This isn't perfect, as it'll use TWA_SIGNAL even for cases where we
don't absolutely need it (like task waiting for completions in
io_cqring_wait()), but we don't have a good way to tell right now. We
can probably improve on this in the future, for now I think this is the
best solution.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9b27cdaa735..b4300a61f231 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1720,7 +1720,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 */
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		notify = 0;
-	else if (ctx->cq_ev_fd)
+	else if (ctx->cq_ev_fd || (tsk->state != TASK_RUNNING))
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);

-- 
Jens Axboe

