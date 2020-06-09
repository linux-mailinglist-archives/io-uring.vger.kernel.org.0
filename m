Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EC81F4149
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 18:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgFIQps (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 12:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731221AbgFIQpp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 12:45:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3506C05BD1E
        for <io-uring@vger.kernel.org>; Tue,  9 Jun 2020 09:45:43 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n24so23148508ejd.0
        for <io-uring@vger.kernel.org>; Tue, 09 Jun 2020 09:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ViVNOJN9Uxt1kC3HIllHsKQ9n81W1tZnUyBLtvgbsVE=;
        b=uCQp4WOO30QsMs0bncRtA+gHyTFLE6hHHbs71o2Uh/TZA/ZXWGCaTqyk8BaX62SQik
         q0h4l5svxb+tWmzIBApAt8UVnFvoA5u0P2FooWMwOpNN3pbErZCMMAyMi8fQVzdgzv7D
         P7b23EfYfsNzynkBPbG7qIfp2v9yAvoXBdOd4yn4NS3T94WTTE2UkvIcwWQaODj1jIjn
         hSKbHdHf9+GSStonJPXFcnHZvdCgZLNYS3029nliEjRf49UUtFf1z8RYnlkksN236N4O
         1ZDe4n7u0oTgGvJf9DTZkBbY7vKwpYzaOW1Jv/in7pb0K4RE3CfAeG5YN444SF8E2hpc
         S/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ViVNOJN9Uxt1kC3HIllHsKQ9n81W1tZnUyBLtvgbsVE=;
        b=fq2qTRXH/nICOACGhVWq7vfYhjUdwdRD4OYOPz3rr5UoRwb8DowVCkRrSQNxI3MFdX
         MbpIy6/41/kYsy3lu1wntrkCEi7mTPiZrATwgjXcuTuzufQ7pKdNPLJhCWvt6oHt5X9u
         9XmKyFFHgLYzzl1pNdOyy580Py0cf8Ga40ueVAEkkY5oQEX8AzTCdU0vpQFoje59d71M
         lot41a7Lj/ucYoRK5HynH/iPpoh1WEJ/xeFf9GCp6nFApk0eT98V+kfNdXnntPWj+yhi
         C4W7e4yp5GVjkgdtmrkU+vuAZP8zfQlYDIFBtqoivHaB/Id1M1gWABYnhdGo5QIyoZuH
         4dWA==
X-Gm-Message-State: AOAM531e/uOG3D/eP21H32Yx8CCmf38Z3DNtoOVZsto1fp2oopINOwKI
        yo+cKD+KWslUwwqNBGHkC8iuK5uU
X-Google-Smtp-Source: ABdhPJytvWrlbNBQbRSt4KmoSSWYHbKOPBUB1ME2maeRbQqJqMjzdSdxEv3ohVzQ9hBkTFgHNdq1oA==
X-Received: by 2002:a17:906:2b88:: with SMTP id m8mr8400020ejg.509.1591721142260;
        Tue, 09 Jun 2020 09:45:42 -0700 (PDT)
Received: from [192.168.43.208] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id qp16sm13463408ejb.64.2020.06.09.09.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 09:45:41 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200609082512.19053-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v6 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
Message-ID: <c4f10448-0199-85d3-3ab5-b5931dad00f0@gmail.com>
Date:   Tue, 9 Jun 2020 19:44:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200609082512.19053-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/06/2020 11:25, Xiaoguang Wang wrote:
> If requests can be submitted and completed inline, we don't need to
> initialize whole io_wq_work in io_init_req(), which is an expensive
> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
> io_wq_work is initialized.

Basically it's "call io_req_init_async() before touching ->work" now.
This shouldn't be as easy to screw as was with ->func.

The only thing left that I don't like _too_ much to stop complaining
is ->creds handling. But this one should be easy, see incremental diff
below (not tested). If custom creds are provided, it initialises
req->work in req_init() and sets work.creds. And then we can remove
req->creds.

What do you think? Custom ->creds (aka personality) is a niche feature,
and the speedup is not so great to care.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index c03408342320..5df7e02852bb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -648,7 +648,6 @@ struct io_kiocb {
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
-	const struct cred	*creds;
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
@@ -1031,14 +1030,9 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
 	}
-	if (!req->work.creds) {
-		if (!req->creds) {
-			req->work.creds = get_current_cred();
-		} else {
-			req->work.creds = req->creds;
-			req->creds = NULL;
-		}
-	}
+	if (!req->work.creds)
+		req->work.creds = get_current_cred();
+
 	if (!req->work.fs && def->needs_fs) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
@@ -5569,23 +5563,20 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt;
-	const struct cred *creds, *old_creds = NULL;
+	const struct cred *old_creds = NULL;
 	int ret;
 
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	if (req->flags & REQ_F_WORK_INITIALIZED)
-		creds = req->work.creds;
-	else
-		creds = req->creds;
-	if (creds && creds != current_cred()) {
+	if ((req->flags & REQ_F_WORK_INITIALIZED) && req->work.creds &&
+	     req->work.creds != current_cred()) {
 		if (old_creds)
 			revert_creds(old_creds);
-		if (old_creds == creds)
+		if (old_creds == req->work.creds)
 			old_creds = NULL; /* restored original creds */
 		else
-			old_creds = override_creds(creds);
+			old_creds = override_creds(req->work.creds);
 	}
 
 	ret = io_issue_sqe(req, sqe, true);
@@ -5939,12 +5930,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		req->creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->creds))
+		io_req_init_async(req);
+		req->work.creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work.creds))
 			return -EINVAL;
-		get_cred(req->creds);
-	} else {
-		req->creds = NULL;
+		get_cred(req->work.creds);
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */


-- 
Pavel Begunkov
