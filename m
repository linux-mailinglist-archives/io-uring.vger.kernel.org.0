Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F012B2EF0
	for <lists+io-uring@lfdr.de>; Sat, 14 Nov 2020 18:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgKNR0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Nov 2020 12:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKNR0f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Nov 2020 12:26:35 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34204C0613D1
        for <io-uring@vger.kernel.org>; Sat, 14 Nov 2020 09:26:34 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ei22so1894919pjb.2
        for <io-uring@vger.kernel.org>; Sat, 14 Nov 2020 09:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HU49s90zL26NulPTuwpBBy4cTigUfiaDg/0IELFUFz0=;
        b=UAgAetbN4yrXyNTv4z6hd/7psdqg0mvroPi/1sx0j3JqGQXi4NhR5X+uEgSsxkj34E
         MGnrEgBL1vUXG6LpPjLn3HAvYdfmJRXV8ZGKWeolCWwl/nklLkwEJ50agj2I26cUA3Io
         XPOzwKxperA4/PGERzqz7cnc4LqRu73jvgXzrNmMwCK4kSz6P7p7GyrtaIzLfy6pKaas
         eVqmAj5B54vWl+QX7mN3V8lLMQhksAGavsD+koPFYZTEor4qdOs0mLbZtEgI0VT60lEZ
         z2hV1kQnj9kiY3RzJHFW35K+my7CNSxz4nKpWGivTbSJg0RPxxqaFKlqwZYz7fkr6gxo
         RSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HU49s90zL26NulPTuwpBBy4cTigUfiaDg/0IELFUFz0=;
        b=Rf6KiqSZljKoHN8U66jSJAWv9/Cx4o72OtOTlPpHQNpY4MKkA+SjyWa+/OwzJO2R30
         h+udW4GqtdENhw3FDWFbnsrAs+JPUWU0wUgOg9GUdQv7VhgBFOIX6Q7s3FLFii0fn/wY
         MSxshEtCGm5tfjOCxFijo4asceA5/eohBLeP+VkDKRbwotFztaRJ5kE6LxQ8R/Z3ptN0
         wn+9iQcUvK5QD8q4AgHBqquPntQ8L+qgT7TGh5B0RNjlQ3xmOM2ytt7ryDQvtfQJ8sKE
         YUrubPRcCr2I0o+LSr2VHXLh3XvTuicaHpjf/WnycOXEBaLDgnSh2F11LMTU95OHqefv
         Q3NQ==
X-Gm-Message-State: AOAM532PtQRjV68cPIc4E5rkfmDnPpcJNPbZ+wux4PjhZ0u5fYx6cSdf
        BG7yoybzVG4gkjC8xNazYX/vJmOlt8NNUw==
X-Google-Smtp-Source: ABdhPJxx9L6cjaFQvRZYIXc5HF3f5duZT9j0xgrBXTIoX/kObpu7BEjG1kAJHos4XrTyF1l5cbfDcQ==
X-Received: by 2002:a17:902:6b8c:b029:d6:d32e:4a8c with SMTP id p12-20020a1709026b8cb02900d6d32e4a8cmr6668449plk.28.1605374793022;
        Sat, 14 Nov 2020 09:26:33 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k25sm13272783pfi.42.2020.11.14.09.26.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 09:26:32 -0800 (PST)
Subject: [PATCH v2 2/2] io_uring: handle -EOPNOTSUPP on path resolution
To:     io-uring <io-uring@vger.kernel.org>
References: <20201113235130.552593-1-axboe@kernel.dk>
 <20201113235130.552593-3-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <496fb404-2736-5b8d-a11c-ad8262a314d9@kernel.dk>
Date:   Sat, 14 Nov 2020 10:26:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201113235130.552593-3-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Any attempt to do path resolution on /proc/self from an async worker will
yield -EOPNOTSUPP. We can safely do that resolution from the task itself,
and without blocking, so retry it from there.

Ideally io_uring would know this upfront and not have to go through the
worker thread to find out, but that doesn't currently seem feasible.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2:
	- Handle this internally to the open command, so we don't
	  need to touch the fast/common path.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c77584de68d7..f05978a74ce1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -478,6 +478,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
+	bool				ignore_nonblock;
 	struct filename			*filename;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -3796,6 +3797,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return ret;
 	}
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
+	req->open.ignore_nonblock = false;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -3839,7 +3841,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	struct file *file;
 	int ret;
 
-	if (force_nonblock)
+	if (force_nonblock && !req->open.ignore_nonblock)
 		return -EAGAIN;
 
 	ret = build_open_flags(&req->open.how, &op);
@@ -3854,6 +3856,21 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	if (IS_ERR(file)) {
 		put_unused_fd(ret);
 		ret = PTR_ERR(file);
+		/*
+		 * A work-around to ensure that /proc/self works that way
+		 * that it should - if we get -EOPNOTSUPP back, then assume
+		 * that proc_self_get_link() failed us because we're in async
+		 * context. We should be safe to retry this from the task
+		 * itself with force_nonblock == false set, as it should not
+		 * block on lookup. Would be nice to know this upfront and
+		 * avoid the async dance, but doesn't seem feasible.
+		 */
+		if (ret == -EOPNOTSUPP && io_wq_current_is_worker()) {
+			req->open.ignore_nonblock = true;
+			refcount_inc(&req->refs);
+			io_req_task_queue(req);
+			return 0;
+		}
 	} else {
 		fsnotify_open(file);
 		fd_install(ret, file);

-- 
Jens Axboe

