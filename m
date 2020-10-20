Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE272940F8
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 18:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395003AbgJTQ7T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 12:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389542AbgJTQ7T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 12:59:19 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B55C0613CE
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 09:59:18 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q1so3252245ilt.6
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 09:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+YHMy2k2TKQvretK2a5uW/DRZVu4G+tALSkJFZ9d8N8=;
        b=06zKH/qzt4ZIrc1PCi4SkOwcKYTQK2FMQLXupkNigvY6nbUc/qAwjbsYmv842yADwH
         7EIwharn7mexe2RVC+nbFQWjqhJcXWmkEe1uOUo+R3hQCZaAn56yvhCkw3HUas/NTXAQ
         l6XQjf0JT5Tzd/TC88rrPczQ4dDWRsZ28Rvmj8s9YsZGDQbXs1IpBcPDfeGQhqEbMkfD
         +BGpVTWYuWrsRi85HWjUpus76BmyGaSVTzNGoZBnvaTQEhYpq9v797Nq4ytJvFvFesKJ
         ZuqgtR4oW4fi57AZoXgSH759i4fzIFqwm5FG0odoSa0jtI9pDgncvcO7Gf41WFpjmWRv
         rVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+YHMy2k2TKQvretK2a5uW/DRZVu4G+tALSkJFZ9d8N8=;
        b=hNo9AD/efIywEcdIkQl7LJbrpQKabTUpLOWkRMc54VJJzh5HlZpEVWoZAtFyaFO8nz
         PmOIpV3sQlhOgr8l6EObTKK0saZbAeUMPalckclBgUTOSKSPSDiX8waP7xBRbb3f2Pie
         +wQc775QlS7wTKO64b+D9xo6ZorfI3LxUAvTqE5c/q/Ai+DZg4Yv0VJzSRnjiixcO0rf
         BBo/UOjBzd2xn1jEazh5+cRL1AeC1cLGhaipdgIAoObt1xYrDYTTL9Kx3jhzP8UGRvbM
         0/XC17aOQmXoCxjVXSMkeA4cusf3VNFLwpe5e+2f4ZSvfA57JUBIzVITtx8rLo+CLSNY
         ye7w==
X-Gm-Message-State: AOAM5309tYPD0AenjC1utK4QIjXeg5puP2/AVh9DmV4GAYkoBSktAKJq
        3r93Yehf4D7OSRxK9lbDgs1926oMinGnCw==
X-Google-Smtp-Source: ABdhPJxc4/E6H4SlilmXjAD/SHTOaQsnc4eOod6QwGWcz8S81bF97ZSnkUwfxgEYrUggrHC2g2+iIQ==
X-Received: by 2002:a05:6e02:928:: with SMTP id o8mr2814048ilt.47.1603213156963;
        Tue, 20 Oct 2020 09:59:16 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v15sm2329158ile.37.2020.10.20.09.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 09:59:16 -0700 (PDT)
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
 <ca4c9b80-78de-eae2-55cf-8d7c3f09ca80@kernel.dk>
 <1799a7cf-7443-7eff-37b1-b3bf3f352968@gmail.com>
 <d55aa3c1-7eb4-b3a4-4a34-41d566d5c559@kernel.dk>
 <523e6ffa-49f9-e48b-369c-14cae0783b79@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8fc30a0b-5b7a-0f9c-ccae-bcb25c1baf1b@kernel.dk>
Date:   Tue, 20 Oct 2020 10:59:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <523e6ffa-49f9-e48b-369c-14cae0783b79@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/20 10:29 AM, Pavel Begunkov wrote:
> On 20/10/2020 15:09, Jens Axboe wrote:
>> On 10/19/20 5:40 PM, Pavel Begunkov wrote:
>>> On 19/10/2020 21:08, Jens Axboe wrote:
>>>> On 10/19/20 9:45 AM, Pavel Begunkov wrote:
>>>>> Every close(io_uring) causes cancellation of all inflight requests
>>>>> carrying ->files. That's not nice but was neccessary up until recently.
>>>>> Now task->files removal is handled in the core code, so that part of
>>>>> flush can be removed.
>>>>
>>>> Why not just keep the !data for task_drop? Would make the diff take
>>>> away just the hunk we're interested in. Even adding a comment would be
>>>> better, imho.
>>>
>>> That would look cleaner, but I just left what already was there. TBH,
>>> I don't even entirely understand why exiting=!data. Looking up how
>>> exit_files() works, it passes down non-NULL files to
>>> put_files_struct() -> ... filp_close() -> f_op->flush().
>>>
>>> I'm curious how does this filp_close(file, files=NULL) happens?
>>
>> It doesn't, we just clear it internall to match all requests, not just
>> files backed ones.
> 
> Then my "bool exiting = !data;" at the start doesn't make sense since
> passed in @data is always non-NULL.

Right, only if we retain this part:

if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
	data = NULL;

in there. I suspect we'll want something ala the below instead.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09e7a5f20060..4870db000f04 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8695,14 +8695,18 @@ static void __io_uring_attempt_task_drop(struct file *file)
  * Drop task note for this file if we're the only ones that hold it after
  * pending fput()
  */
-static void io_uring_attempt_task_drop(struct file *file, bool exiting)
+static void io_uring_attempt_task_drop(struct file *file)
 {
+	bool exiting;
+
 	if (!current->io_uring)
 		return;
+
 	/*
 	 * fput() is pending, will be 2 if the only other ref is our potential
 	 * task file note. If the task is exiting, drop regardless of count.
 	 */
+	exiting = fatal_signal_pending(current) || (current->flags & PF_EXITING);
 	if (!exiting && atomic_long_read(&file->f_count) != 2)
 		return;
 
@@ -8764,16 +8768,7 @@ void __io_uring_task_cancel(void)
 
 static int io_uring_flush(struct file *file, void *data)
 {
-	struct io_ring_ctx *ctx = file->private_data;
-
-	/*
-	 * If the task is going away, cancel work it may have pending
-	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		data = NULL;
-
-	io_uring_cancel_task_requests(ctx, data);
-	io_uring_attempt_task_drop(file, !data);
+	io_uring_attempt_task_drop(file);
 	return 0;
 }
 

-- 
Jens Axboe

