Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15E311DEE8
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 08:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbfLMHvi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 02:51:38 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38478 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLMHvh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 02:51:37 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so5548853wrh.5;
        Thu, 12 Dec 2019 23:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zhWGf6of1paXEg2Udp6pFG3Inh/6p+5h7lz+S0oU+A4=;
        b=sqLAEFDadV4KroJZMrXwhCmHegBtzMMxzO8vFNablwsVogQElVhFjExoQP2pEW+xXo
         bKy7OW8Z3Mv04NDiBSGlg6yFsoxih7dyQIK6GvHlAIRlxgkGCvD01g8OBP/8dd5/RvkU
         3nFbKMASTguOGC23Hqn+1W/KXMYXcJYB9gj9L54I6oiLdlCpFh5NMrYWL4LU5KbcV5jL
         CjAdpHKN5KFv4k1+0L6kYnXBoGmb2FD73uDGbhMu+IvMnHXwREoIb2kyNyI4spnzF25l
         /W6rm+v1zRWQBtG7HGWSX+RWuMhCFR4Gb+at5zxFRRhgWDphlUbGM+p/Z+AOG5ghn+Fc
         MMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zhWGf6of1paXEg2Udp6pFG3Inh/6p+5h7lz+S0oU+A4=;
        b=dap9s4OEVRgDdDvsJQ5pJM7D/PWHp0QNOwC/RprifAvY4/znmCm8lnzQLScEHK1SVd
         bGLHlX1rjbHboXGEuVu0dnr9p+gYR8WHtlPM8aHyf+y1xpVUJy00Ft8qGST12ZhSNFhG
         aiWkfuG3iix87Zu/CLa9znaUH4suYxz5mfsU7p9GThoozq7w6pWy53C9wnsdvXMNEDL+
         cEQp6PfibOFgrWQXe31IP0+6sXbP/wzFhDMRRxYC3GvWOr3W+tOx3qeWuqHHgEaTHTmq
         a6wObBLbj9vu5ejRGvTOxR7tflTMGI/OKZovd2ajRrLe1qbpIdAxpM2Yj+h2JaCa1he0
         wtDA==
X-Gm-Message-State: APjAAAV3j//BgRXNywr/iTMYFWFn/BaqZTSDm2MsKgrbDAOqgitOfIh8
        DdT59v8Um1M0Uxg7J/RSeokOS9tZ
X-Google-Smtp-Source: APXvYqyom5M80VGqoE8j7sjcy58SGOQ6fbdKO7z9ZSAKXY8PLBLyuXfQjNqrFt9dILUbltwPcrBXhw==
X-Received: by 2002:adf:ee82:: with SMTP id b2mr11602891wro.194.1576223495273;
        Thu, 12 Dec 2019 23:51:35 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.210])
        by smtp.gmail.com with ESMTPSA id q11sm8942490wrp.24.2019.12.12.23.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 23:51:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: don't wait when under-submitting
Date:   Fri, 13 Dec 2019 10:51:00 +0300
Message-Id: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
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

Don't wait/poll if can't submit all sqes, and return -EAGAIN

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

I wonder, why it doesn't return 2 error codes for submission and waiting
separately? It's a bit puzzling figuring out what to return. I guess the
same with the userspace side.

 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42de210be631..82152ea13fe2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4877,6 +4877,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+
+		if (submitted != to_submit) {
+			submitted = -EAGAIN;
+			goto out;
+		}
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
@@ -4890,6 +4895,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 	}
 
+out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.24.0

