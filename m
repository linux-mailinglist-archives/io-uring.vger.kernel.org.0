Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B453D3014
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 01:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhGVWcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 18:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGVWcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 18:32:05 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4844C061575
        for <io-uring@vger.kernel.org>; Thu, 22 Jul 2021 16:12:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id my10so8221262pjb.1
        for <io-uring@vger.kernel.org>; Thu, 22 Jul 2021 16:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BULifhoaWAiZpy9ex5uBmDt823I9EPRjUd2U8zXjhTk=;
        b=1j4XqFyFJxoe2O+Oc4DCqnZow6yCJGzX4fEFZ+JYWd0/roxXmrLeGxqliCqDtlo9ib
         WqVvt01XIqhM0Go4QnzKXDnqx0DTGLuA10vNeBEXKyT4b0l88/1qBHOmmiI9Evkegr1A
         +dYoZuyjyTJmN4PGQ2lAx1XjQBq39GIfu/1735zii8jpakSJ1UGegq5WI8NU7Ed/TLBk
         NeQPxb99CUyyXm/ziNmOdrWwYCihD2+2hDPAFjsasv6d1ZgezTc4NpkwfFU4h8QbAzK+
         C+zIOc3zYTpkp5vuYQojkH4/IhqQwunvdRpZ7drAS2YULtF15coEdlfb+YsmOJNORHWW
         0uIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BULifhoaWAiZpy9ex5uBmDt823I9EPRjUd2U8zXjhTk=;
        b=lcQa8YYbcQlYQozm3BKkwyjTVg1pMB2nn8LdbW7j4TQ/9I/YN3uWqahsRgwP/a3SVo
         A+X0Q93Y0R7opDDdRIIiOcSTjEP4g/qHfhsCV8VCjJoCDddUWKqeu5vw8vvXo+mWzhXQ
         6qsC0Z2WTE1GcnSTdZ6AakygXzLVGdviht30zET81m5SHyPBzVDATSNqRq/NgGXL0j0c
         +MekfdYLoWQK0KPPw3Eora7fJwQdf0coEqs7NNWCbzgTksfERockd53eUIGXNJqvILub
         haBGcQD2Nla4BeeluLQR8U9z76X78HSTlo3NYAVovaxD6GzPUFfgkQvEuMOkuvzaLC9w
         X8pQ==
X-Gm-Message-State: AOAM531G5PC+MECdXJyFs5CunELlXczgL3zBYc52nVeDAYZRAvjMdvXu
        KPsIbY4kT1k/d6GQR7QiMUojRg==
X-Google-Smtp-Source: ABdhPJyPvzuZ58c89XwVvxjKELsPtJho0hyFcxpPi9QfOWdQ8rB7fjt/kqHHzlFm9U4KZnsItnpN9w==
X-Received: by 2002:a17:90b:1195:: with SMTP id gk21mr1934975pjb.150.1626995558305;
        Thu, 22 Jul 2021 16:12:38 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id o184sm35636770pga.18.2021.07.22.16.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 16:12:37 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix early fdput() of file
Message-ID: <da4a7435-c50b-5a0a-0e4b-9d35dc7d719a@kernel.dk>
Date:   Thu, 22 Jul 2021 17:12:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit shuffled some code around, and inadvertently used
struct file after fdput() had been called on it. As we can't touch
the file post fdput() dropping our reference, move the fdput() to
after that has been done.

Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/io-uring/YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk/
Fixes: f2a48dd09b8e ("io_uring: refactor io_sq_offload_create()")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe3d948658ad..f2fe4eca150b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7991,9 +7991,11 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		f = fdget(p->wq_fd);
 		if (!f.file)
 			return -ENXIO;
-		fdput(f);
-		if (f.file->f_op != &io_uring_fops)
+		if (f.file->f_op != &io_uring_fops) {
+			fdput(f);
 			return -EINVAL;
+		}
+		fdput(f);
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct task_struct *tsk;
-- 
Jens Axboe

