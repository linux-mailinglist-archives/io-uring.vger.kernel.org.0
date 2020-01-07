Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183D9133061
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 21:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgAGUMh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 15:12:37 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33856 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgAGUMh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 15:12:37 -0500
Received: by mail-il1-f194.google.com with SMTP id s15so715409iln.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 12:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=v1fOEbzCCkcMTp/P5J5L/1GHsaWacZss144GGq7KQxI=;
        b=eedMbDOSWYPKF1t9RHhKiCMu8HMyilrd5/N7jlMytWqqHu9tcd78xU3p1Y36DmmT9w
         APJe7+lJYXzb5RL7972qK1zGIefPKQSZ5KvgFyaC1Sn1vtko8HNNDzCu4ja39jsKHCvk
         nwLy2HSwQ1WUzCFPTuqmitmP35rsKF//Tr7LhnFTwdkN6pVdJOLYvaS7IZH2/c1oB4iS
         BMLLhqXs6HqALSLuS4d1JVMq1gcJZF/+sRNeJwo21flXx3lwZ5c20j3KqFkguE7aa3as
         2ZrKIxvpbNQq28b9BNQQY6qDYJkRVpQYX1VCO+fJEUGyxR2on6EoZG4HvjTEXVMEMyzW
         urrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=v1fOEbzCCkcMTp/P5J5L/1GHsaWacZss144GGq7KQxI=;
        b=jkI0j+k835qjhjOUV9KSiSDORlOJZay3mvpSG6SGtqdae1dRLSoAP0CRlg52Q13KKc
         C8aJFn/6wXgg9rlPdgMoPZHQqfGXPxhzGITaD4a2Wiu2y9/N6Mf9INMKSMLWICn1n9yV
         V8hyXgh2g12vga3Wb5tfg+panGhwh9g9/yjyNCpnRw7S9TF6Ic9SUp2iEEsi0WTd9+jy
         4XtqgzHG6Ou1v04ngvWCJN+VVxswkVVQwhJ4EgYJFjosHPCKA9ntU/rxVfLndEuNss6M
         tvJUCQ65n8jKy4BLGjHIssi1FJsccA2AgmktUlyXkPJI5jNs0r4FAMPRYngdHPawX2Pu
         t7QA==
X-Gm-Message-State: APjAAAUV30XBbKLd6EZcHd7vqbfGuS9H5177iZixlBAoqEQGyxTbuWCa
        /umygH3rluH8HB2n5vlf2lSbpxleWCQ=
X-Google-Smtp-Source: APXvYqwb33SSLmHQL94UhexkvE5jxTLK/777cswZHIUccWHETnUhUgK9mwdCtN9IvqB4b05m+eIFQw==
X-Received: by 2002:a92:8511:: with SMTP id f17mr824427ilh.255.1578427956544;
        Tue, 07 Jan 2020 12:12:36 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n5sm193780ili.28.2020.01.07.12.12.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 12:12:36 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove punt of short reads to async context
Message-ID: <a61c54af-9e5b-6e5a-224d-60ad3a383054@kernel.dk>
Date:   Tue, 7 Jan 2020 13:12:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently punt any short read on a regular file to async context,
but this fails if the short read is due to running into EOF. This is
especially problematic since we only do the single prep for commands
now, as we don't reset kiocb->ki_pos. This can result in a 4k read on
a 1k file returning zero, as we detect the short read and then retry
from async context. At the time of retry, the position is now 1k, and
we end up reading nothing, and hence return 0.

Instead of trying to patch around the fact that short reads can be
legitimate and won't succeed in case of retry, remove the logic to punt
a short read to async context. Simply return it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Also see: https://github.com/axboe/liburing/issues/52

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 562e3a1a1bf9..38b54051facd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1863,18 +1863,6 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		else
 			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
 
-		/*
-		 * In case of a short read, punt to async. This can happen
-		 * if we have data partially cached. Alternatively we can
-		 * return the short read, in which case the application will
-		 * need to issue another SQE and wait for it. That SQE will
-		 * need async punt anyway, so it's more efficient to do it
-		 * here.
-		 */
-		if (force_nonblock && !(req->flags & REQ_F_NOWAIT) &&
-		    (req->flags & REQ_F_ISREG) &&
-		    ret2 > 0 && ret2 < io_size)
-			ret2 = -EAGAIN;
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			kiocb_done(kiocb, ret2, nxt, req->in_async);

-- 
Jens Axboe

