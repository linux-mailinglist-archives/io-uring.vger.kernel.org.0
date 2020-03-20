Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F2918D5A0
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 18:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCTRVQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Mar 2020 13:21:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39316 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgCTRVQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Mar 2020 13:21:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id d25so3599393pfn.6
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2020 10:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gsJ4Zjze6P/Fj82dh+HYERxzOgT7bSRI4qKVa3kJUK0=;
        b=Hs+jMh4XhYVD9guaK0yKZGcuRjoMVXukN4GJdk/195fVDXhhSRit4yddlDP7iP0IHI
         /fXbONjdyJ446G72CCYGX17EJRBJa1QzIHLENd88f3ospOcSBBcOB+WMDbMfp7YF/ebf
         6O+y0RLW6NTEtDdu3vXrlFpj28X9PTAyT5aMqy+fcSSEWbryC6mfimTZYP3XGZb9FyaA
         gSZxk7P9AJlUJQAS56Y0TFZUi6RZ4IzCwsM2n1r4RQOGYVL9Hj30jkOZ2HmQWXGvjh6n
         K4YEupWvH9fueM/me3x4W3k86wUvbUoKNqDwHqT0IKE+AqNNoqbOHKo0xmFi6YJZgLO/
         J3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gsJ4Zjze6P/Fj82dh+HYERxzOgT7bSRI4qKVa3kJUK0=;
        b=c4JxrPYewmAVCx7Kxp/KmnA3JbM9S8qk7WF/tzoc8nNBGLkCzl4qZNlmWE9ULZzV4r
         Sd2U4QMfHv8Oa1dq4aAmE8zkYee91RO1iHeAx6vkRBuJHg8hxUQ76acJ0cyFnKr2LGxw
         yAXnOjLjgjv1EIXDYW5F9BxMEEQcNv+AJgmZMZPSr18Mb16MmDJLATgoJWsAB0C00Q3f
         OUlOWMpf7bK0qpVJKTvYF3vEx2/dZLhRYNQpS9MjmAbbLQYpVjXknIdPfDYURSVpEtcv
         CklxFUN+loQ2IOQyxp5Px0mWkmwdcbFeqInuQCukHZC684W8S0JSr0XLnstdxoT+oyfj
         SyKQ==
X-Gm-Message-State: ANhLgQ36s9MNPim6PPqoFq1hukG5tEEIM9LqniDR60g/mZ7T744Q1WI6
        7I+Kk6F4gN2Zk1HhDov17SXkTGu5OizyLg==
X-Google-Smtp-Source: ADFU+vsD54I3nSWlQn14s2YgQPQTIie5IEeDw/4nqh0wXZs2bLa70ShSRQ/GWBtKbs4X8/bmpaqNiw==
X-Received: by 2002:a62:ea08:: with SMTP id t8mr10651875pfh.71.1584724873654;
        Fri, 20 Mar 2020 10:21:13 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w138sm6358559pff.145.2020.03.20.10.21.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:21:13 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: honor original task RLIMIT_FSIZE
Message-ID: <2d33124f-b8bd-ef41-f3e9-8f3329c8e564@kernel.dk>
Date:   Fri, 20 Mar 2020 11:21:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the previous fixes for number of files open checking, I added
some debug code to see if we had other spots where we're checking
rlimit() against the async io-wq workers. The only one I found was
file size checking, which we should also honor.

During write prep, store the max file size and override that for
the current ask if we're in io-wq worker context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 731a91b772a3..cdc4216a164f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -606,7 +606,10 @@ struct io_kiocb {
 	struct list_head	list;
 	unsigned int		flags;
 	refcount_t		refs;
-	struct task_struct	*task;
+	union {
+		struct task_struct	*task;
+		unsigned long		fsize;
+	};
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -2596,6 +2599,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	req->fsize = rlimit(RLIMIT_FSIZE);
+
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -2665,10 +2670,17 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		/*
 		 * Raw bdev writes will -EOPNOTSUPP for IOCB_NOWAIT. Just
 		 * retry them without IOCB_NOWAIT.

-- 
Jens Axboe

