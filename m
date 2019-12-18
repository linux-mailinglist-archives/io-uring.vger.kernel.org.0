Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB43B124E6D
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 17:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfLRQyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 11:54:19 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37663 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfLRQyS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 11:54:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so3073700wru.4;
        Wed, 18 Dec 2019 08:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EP911nSLn2Vvgh6u3IlrfunDIUtinbfht576MeZl9vU=;
        b=FtT2G1x8vmq1aKeLKcwZ5GBfDHbyrFavKKLhVNJSLjA/Vy3lRtlVd5934szOsrXvNg
         M2Xhp0XSR0aQUZmsjZZuH+php++4yCfNvadeV9zhrU9BeYEu0d0Qcuxo2fk6JfHnwQNm
         xEOOgsRk0NgpiVTuL47wlHJE2w1qZUvIBG/9BnxW3PSqN++a/VUOA2Zcb+2cFu5fOOUq
         ttokrTaIDWxZgT79HXyyhts2bJdkQorLu5Fvcf1gVgqh0Z2jaYu4rqBG8VCd4t28Tg/H
         Qzs+NRkJEgpv5zy96hZMtgoKsh2OIBdEdVFLXqhEY6mmBpKXDU81a6F7mKVe//mHyXM2
         5QlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EP911nSLn2Vvgh6u3IlrfunDIUtinbfht576MeZl9vU=;
        b=hWcnFcN2uZHDzdT8etDq9ZbTTMJKb9B0pKg12hdldedndPQhAD8fxkHP+8IB8cfEMw
         7fmHXc64q1vgvuMxjrYHStj6cYc7lE5lQmmGDYCNBzziWBZvilr0Q4QBs8JuKsS02Fvw
         qvHBVSZtTqGX+5FyAL7j+0xL5tK4UBZgtL7mZqQfxXJNVfI+DWziCqlWe3w0J6PSLKxa
         Mg50Gbj4k9eqKShrG1EEp6BmUcfL5seCMHVojQ3wKoDFBOc1D0DFwwln6d9faiccPuXX
         uMFtIWNAA2+O4gX4+kKL3vm5ynqEc8nJQjnCm+8Xay8J5BuTDvHe0zm07JSn8W716Dt2
         hWSg==
X-Gm-Message-State: APjAAAWnHuOc7MigQVo/DX8ahA0ms2WsTohbJYk1aoX41hEk5aXh0h8Y
        X7CZBqoNmlYSvQmLz2GgvmjAWXFQ
X-Google-Smtp-Source: APXvYqwqthIIeClNPYTweeerQmwMsf4UH7HXj0fEs3V0m5z5QScsmpyr+r082e5y7lVS0NNF1Cf4gQ==
X-Received: by 2002:adf:fbc9:: with SMTP id d9mr4097279wrs.20.1576688056522;
        Wed, 18 Dec 2019 08:54:16 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id b17sm3152856wrp.49.2019.12.18.08.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 08:54:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] io_uring: don't wait when under-submitting
Date:   Wed, 18 Dec 2019 19:53:45 +0300
Message-Id: <28aad565ed6c3a3a03975377aa62035b1b0a4d97.1576687827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576687827.git.asml.silence@gmail.com>
References: <cover.1576687827.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no reliable way to submit and wait in a single syscall, as
io_submit_sqes() may under-consume sqes (in case of an early error).
Then it will wait for not-yet-submitted requests, deadlocking the user
in most cases.

Don't wait/poll if can't submit all sqes

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v5: as the v1, but doesn't return -EAGAIN

 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fd85f9d3a8e1..eca025f38614 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5133,6 +5133,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+
+		if (submitted != to_submit)
+			goto out;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
@@ -5146,6 +5149,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 	}
 
+out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.24.0

