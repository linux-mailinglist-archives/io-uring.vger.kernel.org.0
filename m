Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C34120F82
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2019 17:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfLPQcX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 11:32:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34812 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfLPQcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 11:32:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id f4so255685wmj.1;
        Mon, 16 Dec 2019 08:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nRlAsTZQgQxc3fIhh8yOPGuQiJGZkmST4V2Dv0Yc5WA=;
        b=ociggXr36dtuVlLQL7yGwmSysVnfPrFm/3skudVOw37YtO8eRDXx6DCQimUlFZFyqe
         0bUgoO14SH0bbpG75hoe5x/iQ7BYkYd5/l1b36mJh22kx7KuBedMpV6IQ5v8e7E+UNo/
         zA7WK5+HG/sfbwfkclr0FZrT3kGfZJWuWDaB/ngdZ14biqS2YEGSDPryG6eidpey3H++
         cXyExblU9BpDAHaYg+KvVRpPo/3TiKyuNKta4HYitSspgx4iSK19Hfgx0YCPnj8XjrSa
         d7frSkqfzvB9GDVtjaoR14928qQOiZjXi4uf2lbSUfTrjXnnvwD8sNzIpmO2rxcUtMQ2
         j/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nRlAsTZQgQxc3fIhh8yOPGuQiJGZkmST4V2Dv0Yc5WA=;
        b=FCD+j6XazJTsEq97GT1a/sBwFH3rznQ5B2w0rI2vLiPtVTKsTUv5QrkxHJlbHlJQYZ
         5YipHdb7OdhGCAeTNGx9pJrx6+4NhYSOBcXsvjEC12qoSzYYAWyXhYI4rXJYZe28kZc1
         SfYEodfkCGa8CIjgBgHA8MjQFUuilqZ7FfDXKSaCQ1bNwWrLvfxemUZfwOgF6fMnAmdu
         1CSQlErjulfKW6C3ianqFt32qcqaIcxXb2r5BX6IRnEk3T1zmGJnaEl0G03+1D0agz6A
         EoKPThZ/ceAKdN1/5RpuT2QohPT8YgriTOd/8L0G/bfQSmE5YJ/lp0I/JlFebiI4F/qh
         ns/g==
X-Gm-Message-State: APjAAAXILXmrqb+BOxMdUDwrJuI0q3EZFIV7DL1JjB7vrlzCi4n4ETTL
        1pYc7BiWt0i2dtDjvb6IePf313VK/yg=
X-Google-Smtp-Source: APXvYqw8fW3E+zWZe8Wbqqo2OkCOjtP8Y/Q2twnW7hvptNWiESJKl/5sb9TtM6mEfnloEYBQbmJWgg==
X-Received: by 2002:a1c:a949:: with SMTP id s70mr4942551wme.69.1576513941754;
        Mon, 16 Dec 2019 08:32:21 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id v188sm21529921wma.10.2019.12.16.08.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:32:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] io_uring: don't wait when under-submitting
Date:   Mon, 16 Dec 2019 19:31:51 +0300
Message-Id: <d5af66a14ecd997207f1d5c63f529a36135b7209.1576410230.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>
References: <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>
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

In such cases adjust min_complete, so it won't wait for more than
what have been submitted in the current io_uring_enter() call. It
may be less than total in-flight, but that up to a user to handle.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: cap min_complete if submitted partially (Jens Axboe)
v3: update commit message (Jens Axboe)
v4: fix behavioural change when submitting more than have (Jens Axboe)

 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ad652fa24b8..167fbcc8be0b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4463,11 +4463,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+		if (submitted <= 0)
+			goto done;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
 
 		min_complete = min(min_complete, ctx->cq_entries);
+		if (submitted != to_submit)
+			min_complete = min(min_complete, (u32)submitted);
 
 		if (ctx->flags & IORING_SETUP_IOPOLL) {
 			ret = io_iopoll_check(ctx, &nr_events, min_complete);
@@ -4475,7 +4479,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
 		}
 	}
-
+done:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.24.0

