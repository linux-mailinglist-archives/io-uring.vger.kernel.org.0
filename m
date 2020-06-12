Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B5A1F7CBB
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgFLSC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 14:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLSC5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 14:02:57 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03124C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 11:02:56 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id n2so4029576pld.13
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 11:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KMdLhxIj2/PznqMQCvR0KzW1Yff4FQUIhPQnHLfe5sY=;
        b=2RoJf5t2Y3SRjkDrjNm+M3Uonqo001ps4zZvlWVu61dL75sWWUOGARgLXFsWTaYZM0
         0ovj1fFsD92dmA62FW29sxfiwiblXkwb+4r/T+thGfr1kCecnvofBDhk6mNV8fAcrSGI
         WtFdmnGETDKTuvHcBe4XNDYtnaxGnUxe84owmzs74IzRQVU0wMh5IGaDnqR/rREL81mV
         opwomnsPHT1bfUBq+bccBjhz4rAC2JE8N7Lav9sv/7DHfLbkCC1oi94SRX3XR3tFQ1NU
         EV56qGg+Zi91Hm2sBQ5HEjN4OoyFXZjWjxa4YFZ9WOrgFhkgNSL5J2yccCMERODA+9ub
         NqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KMdLhxIj2/PznqMQCvR0KzW1Yff4FQUIhPQnHLfe5sY=;
        b=K5OwvCakAFygr2CBDg5gDE8kYAG5eioigexEucQ14F4La1sQOM2ZMK+mCFNVZioizO
         lha1w9xSXM/oLO114x2FG2kGRxAvEKZo8lQMerltB2AxVu6/Xejh4HNVo5D7Nwu19hee
         3XnfOeL4vs1rTN2iEXbx4JT0lBQeVrev7Rt+EWJfphgdo8M45+93PSakJC2yTrZw15/r
         xB+N0AV+KfRO9InRu8UD2otzJofmjIlprVFDINNZ1ym2a0vBosoUi2ZqjY6xZ9sW/bIG
         ZP53+0VyUgNfueHuPlgLNc8ARsgTdQpljmibf6c6EZ1qizglfDlV5SgJBXwZO8Eorm7h
         M7ug==
X-Gm-Message-State: AOAM533FsX+0xX5KX9WfohTA9TS8OjsKtImbmpwfxmajv2g8gPIkVhtV
        X8D7fAe2KnfxrEtq64cv7h/nlEH44xgK0w==
X-Google-Smtp-Source: ABdhPJwhw4/ztlSPtgJaf27L7iE+lW2R3ot1/yR5RmFJjDg5fzBtYxKiFYCFhnMNiEWVSv1zGaLurg==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr132745pjb.208.1591984975094;
        Fri, 12 Jun 2020 11:02:55 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z1sm6698324pfr.88.2020.06.12.11.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 11:02:54 -0700 (PDT)
Subject: Re: [RFC] do_iopoll() and *grab_env()
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
 <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
 <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
 <c93fa05c-18ef-2ebe-2d8a-ca578bd648da@kernel.dk>
Message-ID: <868c9ef4-ab31-8c63-cace-9fd99c58cbb2@kernel.dk>
Date:   Fri, 12 Jun 2020 12:02:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c93fa05c-18ef-2ebe-2d8a-ca578bd648da@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 11:55 AM, Jens Axboe wrote:
> On 6/12/20 11:30 AM, Pavel Begunkov wrote:
>> On 12/06/2020 20:02, Jens Axboe wrote:
>>> On 6/11/20 9:54 AM, Pavel Begunkov wrote:
>>>> io_do_iopoll() can async punt a request with io_queue_async_work(),
>>>> so doing io_req_work_grab_env(). The problem is that iopoll() can
>>>> be called from who knows what context, e.g. from a completely
>>>> different process with its own memory space, creds, etc.
>>>>
>>>> io_do_iopoll() {
>>>> 	ret = req->poll();
>>>> 	if (ret == -EAGAIN)
>>>> 		io_queue_async_work()
>>>> 	...
>>>> }
>>>>
>>>>
>>>> I can't find it handled in io_uring. Can this even happen?
>>>> Wouldn't it be better to complete them with -EAGAIN?
>>>
>>> I don't think a plain -EAGAIN complete would be very useful, it's kind
>>> of a shitty thing to pass back to userspace when it can be avoided. For
>>> polled IO, we know we're doing O_DIRECT, or using fixed buffers. For the
>>> latter, there's no problem in retrying, regardless of context. For the
>>> former, I think we'd get -EFAULT mapping the IO at that point, which is
>>> probably reasonable. I'd need to double check, though.
>>
>> It's shitty, but -EFAULT is the best outcome. I care more about not
>> corrupting another process' memory if addresses coincide. AFAIK it can
>> happen because io_{read,write} will use iovecs for punted re-submission.
>>
>>
>> Unconditional in advance async_prep() is too heavy to be good. I'd love to
>> see something more clever, but with -EAGAIN users at least can handle it.
> 
> So how about we just grab ->task for the initial issue, and retry if we
> find it through -EAGAIN and ->task == current. That'll be the most
> common case, by far, and it'll prevent passes back -EAGAIN when we
> really don't have to. If the task is different, then -EAGAIN makes more
> sense, because at that point we're passing back -EAGAIN because we
> really cannot feasibly handle it rather than just as a convenience.

Something like this, totally untested. And wants a comment too.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d830ddb..15806f71b33e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1727,6 +1728,12 @@ static int io_put_kbuf(struct io_kiocb *req)
 	return cflags;
 }
 
+static inline void req_set_fail_links(struct io_kiocb *req)
+{
+	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
+		req->flags |= REQ_F_FAIL_LINK;
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1767,8 +1774,14 @@ static void io_iopoll_queue(struct list_head *again)
 	do {
 		req = list_first_entry(again, struct io_kiocb, list);
 		list_del(&req->list);
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
+		if (req->task == current) {
+			refcount_inc(&req->refs);
+			io_queue_async_work(req);
+		} else {
+			io_cqring_add_event(req, -EAGAIN);
+			req_set_fail_links(req);
+			io_put_req(req);
+		}
 	} while (!list_empty(again));
 }
 
@@ -1937,12 +1950,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 	file_end_write(req->file);
 }
 
-static inline void req_set_fail_links(struct io_kiocb *req)
-{
-	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
-		req->flags |= REQ_F_FAIL_LINK;
-}
-
 static void io_complete_rw_common(struct kiocb *kiocb, long res)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
@@ -2137,6 +2144,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
+		req->task = current;
+		get_task_struct(current);
 		req->result = 0;
 		req->iopoll_completed = 0;
 	} else {

-- 
Jens Axboe

