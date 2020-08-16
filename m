Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6924584F
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 17:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgHPPW7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 11:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgHPPW6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Aug 2020 11:22:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9DCC061786
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 08:22:57 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c10so6917513pjn.1
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 08:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PVOyNfwN5m3nAmoJsFst0bPqdPGq9jMDVYbsbztjMsQ=;
        b=u7du3PK9tmk8KzEbIvsHYC+rARy5cwZurltc7mF37ma82W+ZNgn72OOkkic+yJ3t4C
         4lFECr0ru44o96+yskEALy8nW9gt3vbQHJvj6JpUAYxY1IVdAENhLj/luSrIumdfzMcm
         wgvxoLjPx/2+jFmKrfIum6WkTRRT7J2I4l1qPjQTkcw/ZssoCZpvanDrupOkhbdpnqyr
         v8rRt/ZDHp0f0LsfkRrXDKoRB7DRyQD7n6HaKvIosXgHRS0ONXfMlSzQS8RZcOq6KKl+
         nJXl/3w/UcLWcnd19T+TvumA+/yaydlvtGVqtmVM9s4FvtRNZ+pcmWCja75S3eLPw/K8
         Yf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PVOyNfwN5m3nAmoJsFst0bPqdPGq9jMDVYbsbztjMsQ=;
        b=DdEeCtgBtlem2v89enhaNZ+4U2YUFh6rQzgwgQBe/1OrBlQ62KqCIkeFs533LZCTaG
         2M8Hiho7jtRJli6Wa9KUsCxJz4yIlcMBBdI0xlw4+xclxKg5c9lgx8XlKPqqKwKNNsYS
         TJE5w91Prn3MqHvVf9qttSRLpkaiBuTb/SY3l0jELPf3HAwbx3B7D3OUHkK4s8jGi/TM
         mwAh+J11x0053ivefxT3tI3lZ4y0zu0uye8D4mfHy7WV0KweAu2dpTiZA/A5FmRiElEt
         CMNEtczasQICdPC4VS4ekvhD7KIsUuzoe4qeCUf307KJW2dMxIPJBrOKyGy2YRtGaC7N
         ARzw==
X-Gm-Message-State: AOAM532y2ePalZwV/WcL5XMmLTfnaU5ThGoaUHfsNSViyZSI496v/kOl
        x4wJA1HfJR68qMniuw/lwd7Snp7OJrXVxw==
X-Google-Smtp-Source: ABdhPJzUmDYr4J5/xVm7rNq8BpOXmP71Aaet4RyDuTsvhFp1JiZE9Nu5P4q3BKBwjwlhSOPDNCvsRQ==
X-Received: by 2002:a17:902:ea8c:: with SMTP id x12mr8522487plb.60.1597591375394;
        Sun, 16 Aug 2020 08:22:55 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:80d9:87c:7a0f:8256? ([2605:e000:100e:8c61:80d9:87c:7a0f:8256])
        by smtp.gmail.com with ESMTPSA id m19sm13854743pgd.21.2020.08.16.08.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 08:22:54 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <86295255-567d-e756-5ca3-138d349a5ea1@kernel.dk>
 <d2341bc7-e7c8-110f-e60c-39fc03c62160@kernel.dk>
Message-ID: <67cf568c-27fc-d298-5267-1212f9421b74@kernel.dk>
Date:   Sun, 16 Aug 2020 08:22:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d2341bc7-e7c8-110f-e60c-39fc03c62160@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/20 7:53 AM, Jens Axboe wrote:
> On 8/16/20 6:45 AM, Jens Axboe wrote:
>> On 8/15/20 9:48 AM, Pavel Begunkov wrote:
>>> On 15/08/2020 18:12, Jens Axboe wrote:
>>>> On 8/15/20 12:45 AM, Pavel Begunkov wrote:
>>>>> On 13/08/2020 02:32, Jens Axboe wrote:
>>>>>> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
>>>>>>> On 12/08/2020 21:22, Pavel Begunkov wrote:
>>>>>>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>>>>>>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>>>>>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>>>>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>>>>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>>>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>>>>>>>> works
>>>>>>>>>>>
>>>>>>>>>>> I've attached a file to reproduce it
>>>>>>>>>>> or here
>>>>>>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>>>>>>>
>>>>>>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>>>>>>>> state, which is why you can't kill it.
>>>>>>>>>
>>>>>>>>> It looks like one of the hangs I've been talking about a few days ago,
>>>>>>>>> an accept is inflight but can't be found by cancel_files() because it's
>>>>>>>>> in a link.
>>>>>>>>
>>>>>>>> BTW, I described it a month ago, there were more details.
>>>>>>>
>>>>>>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
>>>>>>
>>>>>> Yeah I think you're right. How about something like the below? That'll
>>>>>> potentially cancel more than just the one we're looking for, but seems
>>>>>> kind of silly to only cancel from the file table holding request and to
>>>>>> the end.
>>>>>
>>>>> The bug is not poll/t-out related, IIRC my test reproduces it with
>>>>> read(pipe)->open(). See the previously sent link.
>>>>
>>>> Right, but in this context for poll, I just mean any request that has a
>>>> poll handler armed. Not necessarily only a pure poll. The patch should
>>>> fix your case, too.
>>>
>>> Ok. I was thinking about sleeping in io_read(), etc. from io-wq context.
>>> That should have the same effect.
>>
>> We already cancel any blocking work for the exiting task - but we do
>> that _after_ trying to cancel files, so we should probably just swap
>> those around in io_uring_flush(). That'll remove any need to find and
>> cancel those explicitly in io_uring_cancel_files().
> 
> I guess there's still the case of the task just closing the fd, not
> necessarily exiting. So I do agree with you that the io-wq case is still
> unhandled. I'll take a look...

The below should do it.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc506b75659c..346a3eb84785 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8063,6 +8063,33 @@ static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
 	return found;
 }
 
+static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
+{
+	return io_match_link(container_of(work, struct io_kiocb, work), data);
+}
+
+static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	enum io_wq_cancel cret;
+
+	/* cancel this particular work, if it's running */
+	cret = io_wq_cancel_work(ctx->io_wq, &req->work);
+	if (cret != IO_WQ_CANCEL_NOTFOUND)
+		return;
+
+	/* find links that hold this pending, cancel those */
+	cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_link_cb, req, true);
+	if (cret != IO_WQ_CANCEL_NOTFOUND)
+		return;
+
+	/* if we have a poll link holding this pending, cancel that */
+	if (io_poll_remove_link(ctx, req))
+		return;
+
+	/* final option, timeout link is holding this req pending */
+	io_timeout_remove_link(ctx, req);
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
@@ -8116,10 +8143,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				continue;
 			}
 		} else {
-			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
-			/* could be a link, check and remove if it is */
-			if (!io_poll_remove_link(ctx, cancel_req))
-				io_timeout_remove_link(ctx, cancel_req);
+			/* cancel this request, or head link requests */
+			io_attempt_cancel(ctx, cancel_req);
 			io_put_req(cancel_req);
 		}
 
-- 
Jens Axboe

