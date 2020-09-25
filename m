Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF452279333
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgIYVXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 17:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbgIYVXT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 17:23:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA638C0613D5
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 14:23:18 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s14so92715pju.1
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 14:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0YOb8ZDq0Y6kchWaIZPJa/N63+vnWXVeYZA3nVgbbFo=;
        b=ZP5rH9fKYTI8foSAnWly099niDXKL1xI05QpHRaLvT6PF/LOcQnePWA10KPt0jZWlI
         DTZCMLFWcju+JducoEY17x9m60Z0XHr7uh1vQeByhcGsVzqwhlJ6tXc06TqwKiliTeRy
         +ycOEteZAy5QdaYeSZOzEvXV+TNMZJK1PLjnsf4/Fp4pPOShw5X1tlgBNWBoRehg1rQw
         OUfvvBFmB9QD7RrXG5sTuW3ZWX9lMatKm6SWD8ZpN2vQ/ZAxrQsmTrLFmYJbdjG8FfsF
         Sc5MxxTMi8MDdnj6xuzq7Q/gk1sDr4GPnCQlkOEFXvIdA9ZH7omHUiWP6KdG99ScLeYi
         DIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YOb8ZDq0Y6kchWaIZPJa/N63+vnWXVeYZA3nVgbbFo=;
        b=LY3DFSx/cUj/+qOcGxvuLruiYhHsaJ3sfghlekba0gdV0PozZoo0cnTEoc9OQ0tuQI
         SMS6tVha1aF0pEDX+qTACQYOp9A29EQLt7VkYG/XTJR96thdMttY/1PVNmm1wWb/FWky
         10XKh7mUj5BWCS4dp5ODcG9CkyZtSl5U/stULBEToPH1Qh4i3FIK0xiuNEIKvAgGo96y
         Kb7ZmctDtHwwfMeqnUluizuwsu4CBhj/aOMMKVd2gVk2kstjX/saHhfVgxlSdEcMyyl4
         oG9ZWEVRd0QCaWxIjAXSbzZsknkdLaijHhQqGQAUfxEPDb8Xy/3pYzLyndHHLvG99Y/U
         4mFw==
X-Gm-Message-State: AOAM5329Rght1Xu1KvCXye1r7XicXVYbnqkxyLCEq0/ap+npIifICqIb
        voQOc3rko0nE/OFZCrYp4khgXwiCb/a4GsHM
X-Google-Smtp-Source: ABdhPJxdGMZlIlrndztzyy3FAW3beUa9ppiOnrhOCiGj+2956pibz2l/qJVvTm+GFN3khP4YoZPgAg==
X-Received: by 2002:a17:90b:617:: with SMTP id gb23mr448815pjb.36.1601068998083;
        Fri, 25 Sep 2020 14:23:18 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i9sm3594474pfq.53.2020.09.25.14.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:23:17 -0700 (PDT)
Subject: Re: [Question] about async buffered reads feature
To:     Hao_Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <a1bd6dfd-c911-dfe8-ec7f-4fac5ac8c73e@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <09ea598d-6721-4e67-df4a-2bbb8ada24d9@kernel.dk>
Date:   Fri, 25 Sep 2020 15:23:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a1bd6dfd-c911-dfe8-ec7f-4fac5ac8c73e@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/20 3:18 AM, Hao_Xu wrote:
> Hi Jens,
> I'm doing tests about this feature: [PATCHSET RFC 0/11] Add support for 
> async buffered reads
> But currently with fio testing, I found the code doesn't go to the 
> essential places in the function generic_file_buffered_read:
> 
>            if (iocb->ki_flags & IOCB_WAITQ) {
>                    if (written) {
>                            put_page(page);
>                            goto out;
>                    }
>                    error = wait_on_page_locked_async(page,
>                                                    iocb->ki_waitq);
>            } else {
> 
> and
> 
>    page_not_up_to_date:
>           /* Get exclusive access to the page ... */
>           if (iocb->ki_flags & IOCB_WAITQ)
>                   error = lock_page_async(page, iocb->ki_waitq);
>           else

Can you try with this added? Looks like a regression got introduced...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40670ad4446c..99b842ac2dc0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3339,10 +3339,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-		if (ret)
-			goto out_free;
-		return -EAGAIN;
+		goto copy_iov;
 	} else if (ret < 0) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;

-- 
Jens Axboe

