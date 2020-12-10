Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482682D63DB
	for <lists+io-uring@lfdr.de>; Thu, 10 Dec 2020 18:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392701AbgLJRm7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Dec 2020 12:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392879AbgLJRmu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Dec 2020 12:42:50 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6368C0613D6
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 09:42:09 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id t16so6362157wra.3
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 09:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5iGtu25a5aaKPulln//7UFA3FLkS8CABfcPsugbtM3Y=;
        b=OM36dx63sYo0nho4abFwr5jLTcW/IrzYE5Ti1ETaDp/FrHBQ+FI5VTAMOD5oIQuAWJ
         88A8zpFwxYHr/7VXiMAJy9yKn208fYV7GSCjf8uSN7erFf8HHGJRnNabkvCRrIUAMtfv
         RUv+uAztG+4SecahKp2T5CxxY1qjG8sAgFgJdzUgEchTbzRBklTes26bBlWCdPnCLJoo
         HhvAJSi95dqXypNqWzAi32LB8US0b1IWNul0POY0kK6s99ZmwGyxv/72dIPYPGBTAB8S
         izGZlTw6SgFG+1Sd6eBKr6KiPS+x7f46DA0umA1NyEsSV//cjKxviVG/LfFahZvkpLVc
         43ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5iGtu25a5aaKPulln//7UFA3FLkS8CABfcPsugbtM3Y=;
        b=NB9HoxXUy5Y6jKvPktQ8i/wqHeVs8qd22AgP8EQg/6zGDd0jp4HDVHs20Mpex9eAfR
         Lwb9XXW+rtKQeebIP094aA+l/3OWCPihGrmFnBHY7QGI4RJkxxNTxh1ODcEw1U5NujYE
         OLTXcjHesfSuBBa52RgwZJmt9pd6MEhaYTciEUf2OGwTXNk3/eEbZcw5sN6W8vGPBhNh
         dvBU3v8y5WeCwotIG/Iyo/wWKf0cKoteF09UyTo4riz24VU2HuU/j4NL0OPyMyi34G68
         y+U7t9oQUzOkPtOxnhk7Y42Z+mvMN7TAq2qp6F96F3oola6T7dKMveHUtS4JNsEBN3n7
         ojSA==
X-Gm-Message-State: AOAM530/W+LARHgIZoGIzAEG0I8bFNmFpwXZ3kY4BZ9j4TzAYaUPM+3c
        rVWtDzFVgseYBKVpo/e+FqSrfJbg+g4A4Q==
X-Google-Smtp-Source: ABdhPJwnJBzz9A2VA4XfSZiW9ekh/UxmGBPsCUiF6Eru5JKGl4we/rfh9ozBYnDtGuTqTGSezRx/lw==
X-Received: by 2002:a05:6000:ce:: with SMTP id q14mr9348378wrx.277.1607622128209;
        Thu, 10 Dec 2020 09:42:08 -0800 (PST)
Received: from [192.168.8.122] ([185.69.144.17])
        by smtp.gmail.com with ESMTPSA id q12sm11493517wmc.45.2020.12.10.09.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 09:42:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     xiaoguang.wang@linux.alibaba.com,
        io-uring <io-uring@vger.kernel.org>
References: <cover.1607293068.git.asml.silence@gmail.com>
 <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
 <10e20bd3-b08f-98b8-f857-8b9a75a511dd@kernel.dk>
 <d9f677a4-1ac0-0e64-5c2a-497cac9dc8e5@gmail.com>
 <33b5783d-c238-b0da-38cf-974736c36056@kernel.dk>
 <89d04d6b-2f84-82af-9ee7-edeb69f2a5bb@gmail.com>
 <7514e884-ce01-380c-5c06-f2331a4906bf@kernel.dk>
 <c99691ef-6b0c-faf8-ea41-459806672e26@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.10 1/5] io_uring: always let io_iopoll_complete()
 complete polled io.
Message-ID: <471ba4c7-2fcb-d42f-c40d-18bb916aef1f@gmail.com>
Date:   Thu, 10 Dec 2020 17:38:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c99691ef-6b0c-faf8-ea41-459806672e26@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/12/2020 20:17, Pavel Begunkov wrote:
> On 08/12/2020 21:10, Jens Axboe wrote:
>> On 12/8/20 12:24 PM, Pavel Begunkov wrote:
>>> On 08/12/2020 19:17, Jens Axboe wrote:
>>>> On 12/8/20 12:12 PM, Pavel Begunkov wrote:
>>>>> On 07/12/2020 16:28, Jens Axboe wrote:
>>>>>> On Sun, Dec 6, 2020 at 3:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>>> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>>>>>
>>>>>>> The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
>>>>>>> we'll complete req by calling io_req_complete(), which will hold completion_lock
>>>>>>> to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
>>>>>>> hold completion_lock to call io_commit_cqring(), then there maybe concurrent
>>>>>>> access to ctx->defer_list, double free may happen.
>>>>>>>
>>>>>>> To fix this bug, we always let io_iopoll_complete() complete polled io.
>>>>>>
>>>>>> This patch is causing hangs with iopoll testing, if you end up getting
>>>>>> -EAGAIN on request submission. I've dropped it.
>>>>>
>>>>> I fail to understand without debugging how does it happen, especially since
>>>>> it shouldn't even get out of the while in io_wq_submit_work(). Is that
>>>>> something obvious I've missed?
>>>>
>>>> I didn't have time to look into it, and haven't yet, just reporting thation.
>>>> it very reliably fails (and under what conditions).
>>>
>>> Yeah, I get it, asked just in case.
>>> I'll see what's going on if Xiaoguang wouldn't handle it before.
>>
>> Should be trivial to reproduce on eg nvme by doing:
>>
>> echo mq-deadline > /sys/block/nvme0n1/queue/scheduler
>> echo 2 > /sys/block/nvme0n1/queue/nr_requests
>>
>> and then run test/iopoll on that device. I'll try and take a look
>> tomorrow unless someone beats me to it.
> 
> Tried out with iopoll-enabled null_blk. test/iopoll fails with
> "test_io_uring_submit_enters failed", but if remove iteration limit
> from the test, it completes... eventually.
> 
> premise: io_complete_rw_iopoll() gets -EAGAIN but returns 0 to
> io_wq_submit_work().
> The old version happily completes IO with that 0, but the patch delays
> it to do_iopoll(), which retries and so all that repeats. And, I believe,
> that the behaviour that io_wq_submit_work()'s -EGAIN check was trying to
> achieve...
> 
> The question left is why no one progresses. May even be something in block.
> Need to trace further.

test_io_uring_submit_enters()'s io_uring_submit never goes into the kernel,
IMHO it's saner to not expect to get any CQE, that's also implied in a comment
above the function. I guess before we were getting blk-mq/etc. them back
because of timers in blk-mq/etc.

So I guess it should have been be more like the diff below, which still
doesn't match the comment though.

diff --git a/test/iopoll.c b/test/iopoll.c
index d70ae56..d6f2f3e 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -269,13 +269,13 @@ static int test_io_uring_submit_enters(const char *file)
 	/* submit manually to avoid adding IORING_ENTER_GETEVENTS */
 	ret = __sys_io_uring_enter(ring.ring_fd, __io_uring_flush_sq(&ring), 0,
 						0, NULL);
-	if (ret < 0)
+	if (ret != BUFFERS)
 		goto err;
 
 	for (i = 0; i < 500; i++) {
-		ret = io_uring_submit(&ring);
-		if (ret != 0) {
-			fprintf(stderr, "still had %d sqes to submit, this is unexpected", ret);
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "wait cqe failed %i\n", ret);
 			goto err;
 		}

-- 
Pavel Begunkov
