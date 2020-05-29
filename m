Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88DF1E78E7
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 10:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgE2I7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 04:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2I7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 04:59:51 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A932CC03E969
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 01:59:50 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so2336708wmb.4
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 01:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wqlpNHf32+vSr/onlAfZWWc/BiqZixBWCu54HMPoOSs=;
        b=jY6t650KWyW1YiFswXHVCZwqcTIAgX60XhE/5AXO8T+JCfTlDricoznH+O3mnpnpD4
         sGlvKAGMtVq2UiT2xmMtj0ftGN7zbHGAT4PrbiRyyFftJtNQf3cjpRpKWwEwjdSsQV9G
         HkoiwrjjX7n5N1EQfU3WDhYazNVA1aOv/VeIB5xb5QznZMAjaKfep6FDiWiGNrduqZB6
         KP73+aV+aJ2KCdE1EJxnolv2bgBR1RifVqrl93qjMVLqv6phWDmmgYX0czeQCXKC27K4
         XJgva8LPQIqU2H6PkyS5XHs8sCfRgQ/8ob2EVqHy5Cue1o3kVl3mg3DxtjMvxMc9Crn9
         aAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wqlpNHf32+vSr/onlAfZWWc/BiqZixBWCu54HMPoOSs=;
        b=raA6CbXVtoPmnhw9LhkPFQPaa3T4UfrgSfnbeVSTdGhD8JWm9pMXdzLwEc/An9inJ3
         MisRIxz9uuxpruZs+aX5opXCXBb8VFwy7BWo4yPp23AqeFelERCI6WJTpObUN8cIb1xM
         JNBQzmB/E+TquSlmFsFl5OZF8R4DOfwoJtpqV9+3P9nWD0pinsXBQ1mt0Qv612Kn6Tu/
         gzwd7tqJeLPzPfVST9aU8LXaFJtRB/LkoQqTaMbNjtJr0/GXZtdPWlCSSFk/ab5sks66
         FH3p4Z1xhnyuq10TGSGSbVKhUV3x0sOJYw8j9yl7YDdVRsWUZrPAc8fxpGAh26jcQTok
         85zw==
X-Gm-Message-State: AOAM531nRw+SVRtEUTdUxy76XZsrIghKIaNpfFoTsGQGcdO7BoPdAER+
        r3wGi0KB4PkdcNVt+iz9bOM95FyF
X-Google-Smtp-Source: ABdhPJzdTWMhH+kgryTm+Ne/Mee/1U6+tyW0lulwttD1Ynf0d5ry6/d9ooLBL7PVRRLuJn6k5kCuWQ==
X-Received: by 2002:a1c:c3d7:: with SMTP id t206mr7637917wmf.69.1590742789099;
        Fri, 29 May 2020 01:59:49 -0700 (PDT)
Received: from [192.168.43.204] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id o20sm9326249wra.29.2020.05.29.01.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 01:59:48 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
Message-ID: <fa5b8034-c911-3de1-cfec-0b3a82ae701a@gmail.com>
Date:   Fri, 29 May 2020 11:58:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/05/2020 12:15, Xiaoguang Wang wrote:
> If requests can be submitted and completed inline, we don't need to
> initialize whole io_wq_work in io_init_req(), which is an expensive
> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
> io_wq_work is initialized.

It looks nicer. Especially if you'd add a helper as Jens supposed.

The other thing, even though I hate treating a part of the fields differently
from others, I don't like ->creds tossing either.

Did you consider trying using only ->work.creds without adding req->creds? like
in the untested incremental below. init_io_work() there is misleading, should be
somehow played around better.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4dd3295d74f6..4086561ce444 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -643,7 +643,6 @@ struct io_kiocb {
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
-	const struct cred	*creds;
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
@@ -894,8 +893,16 @@ static const struct file_operations io_uring_fops;
 static inline void init_io_work(struct io_kiocb *req,
 			void (*func)(struct io_wq_work **))
 {
-	req->work = (struct io_wq_work){ .func = func };
-	req->flags |= REQ_F_WORK_INITIALIZED;
+	struct io_wq_work *work = &req->work;
+
+	/* work->creds are already initialised by a user */
+	work->list.next = NULL;
+	work->func = func;
+	work->files = NULL;
+	work->mm = NULL;
+	work->fs = NULL;
+	work->flags = REQ_F_WORK_INITIALIZED;
+	work->task_pid = 0;
 }
 struct sock *io_uring_get_socket(struct file *file)
 {
@@ -1019,15 +1026,9 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
 	}
+	if (!req->work.creds)
+		req->work.creds = get_current_cred();

-	if (!req->work.creds) {
-		if (!req->creds)
-			req->work.creds = get_current_cred();
-		else {
-			req->work.creds = req->creds;
-			req->creds = NULL;
-		}
-	}
 	if (!req->work.fs && def->needs_fs) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
@@ -1044,6 +1045,12 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,

 static inline void io_req_work_drop_env(struct io_kiocb *req)
 {
+	/* always init'ed, put before REQ_F_WORK_INITIALIZED check */
+	if (req->work.creds) {
+		put_cred(req->work.creds);
+		req->work.creds = NULL;
+	}
+
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
 		return;

@@ -1051,10 +1058,6 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 		mmdrop(req->work.mm);
 		req->work.mm = NULL;
 	}
-	if (req->work.creds) {
-		put_cred(req->work.creds);
-		req->work.creds = NULL;
-	}
 	if (req->work.fs) {
 		struct fs_struct *fs = req->work.fs;

@@ -5901,12 +5904,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct
io_kiocb *req,

 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		req->creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->creds))
+		req->work.creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work.creds))
 			return -EINVAL;
-		get_cred(req->creds);
+		get_cred(req->work.creds);
 	} else
-		req->creds = NULL;
+		req->work.creds = NULL;

 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags;

-- 
Pavel Begunkov
