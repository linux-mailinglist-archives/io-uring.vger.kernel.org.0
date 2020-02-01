Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6851414F55B
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 01:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgBAAVb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 19:21:31 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40952 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgBAAVb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 19:21:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so4259319pfh.7
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 16:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2mY3dPmf2uuMt8QWNpwg8GFH3q6MQyBpaYXbaJcyfWc=;
        b=IykQ9DtKqYoBMpZsTR6rzJRGYZDSLL/lj0gWK+x11P+c8figm9HmfATK35Ve35xbTU
         YlEBUHeWUYUVa/bnedj1N5pWzES7t+7tCLRk210C4xVhFA5kKSdFZKCJePWDkh+z4Aqs
         WkyXz72XpGVlnaPINYp3+T3sUgntoVM6QNjbyEZNsmCMqzKCkxHHzjFZdFkKmb8LD37+
         SfqQQh+43NKz/Ec1qqv0sEjuHahtGIJNsJGy47c/38ThhNNrv+fyq7PDTQtiHuRbRmSY
         kTGKNFsHYyH8UiPjnWrWvCqafXZxIUwbjiyu+LQrJLx7OApQgJlBL7wKWfHdrx2gdUhq
         0JaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2mY3dPmf2uuMt8QWNpwg8GFH3q6MQyBpaYXbaJcyfWc=;
        b=Y8ryhbr5QENVJeLfK56jOqWwqHhrUzFVrhk7G+5nO22I0O44VRYiZTFoTKq3z4wZoH
         uAZ3aNyNy1m6bS+7Vo6+iy4yNLKONiHBVKTggNzP/Pf8mVFWa0Ht0pRJ8eLmwwXs1TzW
         t8SxMWxFv3Q+tAOvAJASOb5jAL9Lv+S4rDlK1u+PQmUZ03LQ7mdZN6bu1yVtNZVlptHG
         eJfTgH8KsexPiILLsk+dlayeou7Vu3h+58NYQIrOpKia4m9gdlbHrgDswod+YrE6ku4O
         XQREvbv5PS0Eml11fQ40nfRP51P0qlo9f4zy+2Z39KqxTCs8QvtpLTMgKtOnbAri3qL/
         hjBg==
X-Gm-Message-State: APjAAAW/7DlGjQEd/EUP9cztM15q/qxv5Ju7OzeW6+0aLgu/9d5SruD1
        ySWtDNl2HGThO0i8al9ZZJR2JINKsTs=
X-Google-Smtp-Source: APXvYqzBG+dryJo3p77LqMGEBPHcnv4a7fQOITmf+k2yrgzUfRDOsLtMpMDnxWBpJO7GuFGo5GIkdw==
X-Received: by 2002:a62:e411:: with SMTP id r17mr12447663pfh.119.1580516490583;
        Fri, 31 Jan 2020 16:21:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e7sm12084970pfj.114.2020.01.31.16.21.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 16:21:29 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix sporadic double CQE entry for close
Message-ID: <b0b0bb08-d3ab-a9f7-d468-6f113fbda19f@kernel.dk>
Date:   Fri, 31 Jan 2020 17:21:27 -0700
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

We punt close to async for the final fput(), but we log the completion
even before that even in that case. We rely on the request not having
a files table assigned to detect what the final async close should do.
However, if we punt the async queue to __io_queue_sqe(), we'll get
->files assigned and this makes io_close_finish() think it should both
close the filp again (which does no harm) AND log a new CQE event for
this request. This causes duplicate CQEs.

Queue the request up for async manually so we don't grab files
needlessly and trigger this condition.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cb3c0a803b46..fb5c5b3e23f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2841,16 +2841,13 @@ static void io_close_finish(struct io_wq_work **workptr)
 		int ret;
 
 		ret = filp_close(req->close.put_file, req->work.files);
-		if (ret < 0) {
+		if (ret < 0)
 			req_set_fail_links(req);
-		}
 		io_cqring_add_event(req, ret);
 	}
 
 	fput(req->close.put_file);
 
-	/* we bypassed the re-issue, drop the submission reference */
-	io_put_req(req);
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
@@ -2892,7 +2889,13 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 
 eagain:
 	req->work.func = io_close_finish;
-	return -EAGAIN;
+	/*
+	 * Do manual async queue here to avoid grabbing files - we don't
+	 * need the files, and it'll cause io_close_finish() to close
+	 * the file again and cause a double CQE entry for this request
+	 */
+	io_queue_async_work(req);
+	return 0;
 }
 
 static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
Jens Axboe

