Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E632B52C5
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 21:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbgKPUjM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 15:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgKPUjM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 15:39:12 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0144FC0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 12:39:12 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id 35so4817774ple.12
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 12:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=o54PSEF2bsVyACt0vUuURhxMiMEZUQGdAmhiWd7OQws=;
        b=aXMnuKqUqcGEuH7huh+3Kx/SIfcQ15GOu8oJar3VwLL//u508skOnRXH0SBHMfn4GZ
         dTIcyCk3ByeFXPfMXIfmJVaehp+vZTL6hnb6PSV6jAz7ysQkck6c5n3W/VeuQz1xZQ9O
         ngFTBC7phhK6vS+JUynZrBZGRspam9V7aQXIpbp1iO4ymFWNFT8WMyRyyxrIw5BgS823
         IAgOZmxt/TooQAqB/merEI+02OWWcYnXGNbEgf8Fhh9UuK6eOul9akAfzoYdVGfRS6qY
         bQQVfrsSG6y87l4bwC80AfBCxxq6b0dGEMQuLIXl2YNZDcJgAmgLbmqKPDCjxUc09Ifw
         8pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=o54PSEF2bsVyACt0vUuURhxMiMEZUQGdAmhiWd7OQws=;
        b=WUyq82PFuSnykue6ybVF8DZFlXSrdrHjzgtjCoJ+yKRXlQvzQwyoEX3draWqWED5T1
         P7crVFLZIYooGURAabZTt3sPgkMuyKQzS25/tLb2Zb60s0gXVMLkChgRB5Eg7wwh3c5Q
         K/NLkv6iKksOKukzqO0b3OlCE5g76T1xymTGhCFuDwayBOFQWUxF+cOqOispv+qc7iJc
         BFGUiHzO15QPHUSStDJ45Rz3jSTZNhioBHr7hk1k8oTsSW/MuKMjY2lmwvhOB/s+7epZ
         rLSHUyQYX0ZSh+E+e/qYKb54mZ0FErgkEK7wjwNmgla1Qyh7gKqUCTDO/37BWuy4q69o
         wC4w==
X-Gm-Message-State: AOAM533iGLV3CHr4XlaHahEygp7JZ3LmXeYvql3Y15KLTQRZ9FnUziLl
        q3oTylRJe2HAlqifQU/dPY/Torq3wBHiyQ==
X-Google-Smtp-Source: ABdhPJwaO8JhK0xUrUzMom1iwoj6h5PBiRQQS7xN+Es8Y8R83V9/gXTqBiXKGNcqENt/BpEirzBgPQ==
X-Received: by 2002:a17:902:d908:b029:d8:d387:3c2b with SMTP id c8-20020a170902d908b02900d8d3873c2bmr13633014plz.53.1605559151371;
        Mon, 16 Nov 2020 12:39:11 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 194sm18798992pfz.142.2020.11.16.12.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 12:39:10 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] mm: never attempt async page lock if we've transferred data
 already
Message-ID: <313ab88b-33d5-5c19-11d3-b8bad7980685@kernel.dk>
Date:   Mon, 16 Nov 2020 13:39:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We catch the case where we enter generic_file_buffered_read() with data
already transferred, but we also need to be careful not to allow an async
page lock if we're looping transferring data. If not, we could be
returning -EIOCBQUEUED instead of the transferred amount, and it could
result in double waitqueue additions as well.

Cc: stable@vger.kernel.org # v5.9
Fixes: 1a0a7853b901 ("mm: support async buffered reads in generic_file_buffered_read()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/mm/filemap.c b/mm/filemap.c
index d5e7c2029d16..3ebbe64a0106 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2347,10 +2347,15 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		if (iocb->ki_flags & IOCB_WAITQ)
+		if (iocb->ki_flags & IOCB_WAITQ) {
+			if (written) {
+				put_page(page);
+				goto out;
+			}
 			error = lock_page_async(page, iocb->ki_waitq);
-		else
+		} else {
 			error = lock_page_killable(page);
+		}
 		if (unlikely(error))
 			goto readpage_error;
 
@@ -2393,10 +2398,15 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 		}
 
 		if (!PageUptodate(page)) {
-			if (iocb->ki_flags & IOCB_WAITQ)
+			if (iocb->ki_flags & IOCB_WAITQ) {
+				if (written) {
+					put_page(page);
+					goto out;
+				}
 				error = lock_page_async(page, iocb->ki_waitq);
-			else
+			} else {
 				error = lock_page_killable(page);
+			}
 
 			if (unlikely(error))
 				goto readpage_error;

-- 
Jens Axboe

