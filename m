Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF4F51A49D
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 17:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352953AbiEDP7D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 11:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352949AbiEDP7C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 11:59:02 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4006A60D6
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 08:55:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d22so1768054plr.9
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 08:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=6cDThZPiCnCQczpp5V/ZPAbaqvT+RFKW/HPvI6WuLxY=;
        b=q6UIn0ddONwsMwtGbndW/+WaCttSZzX0vuSFhowDUbj5cipb/+qyVs0v7U4zl9jS6z
         fZiTetgyYM4zF0xvu93we6PWp5XlTuLqGRccJ+/Ww+sRFvNTOheTBKIf7qDe9cLBYVNh
         Xlr9LF+/IKeKg0vWCQF4eV1MHqgZ1xRDXyAbix9LU/wpYubgC3mVeQCH0yiRonJ5Eamz
         nrIc/vdk1jXrHwwAxS4EBzERfEVqUfbWDS87DVRYb1aTc5yGSfR2JtmdgH1gr6AcMX+U
         eyYXUoUsGwop9N8yhKMTjTEN1UlYa0cl4FMB4FCoL1bXInQSsJrruUcrnE8lXbBtLLmH
         6eMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=6cDThZPiCnCQczpp5V/ZPAbaqvT+RFKW/HPvI6WuLxY=;
        b=M8Y6x8aiDPnyXeaSb5v1ve9ctj58deLUxLOZsVAav0YK3uYlgmExYI/ZVEWksyMyYQ
         SJk5LZ3Dm8fRVUdK3iKpFBmAyR9WXFoDO8l+g5zbrbzqCqKyZu5c+mn0mKNZEI/S0i8R
         0SZxmP9Z1hYvtL9+ITJi5EOScxAF1+E+b55ZVC0EE+yn8uqeV7HOJYWBHobmNnBYhwl+
         AinE91lTuzv9wCGXnMyf2YXpcy8iAHE8gAd6SCvb0XB2ncKYlS5DsSz7Oh76DdnKWmvL
         SxKgwo5gaceON/ostf6weOwH8s0VrU+5moNTbcRb+bAaVIe1f5Sildic/pnkeTu1kmub
         aaYQ==
X-Gm-Message-State: AOAM533+XoikxE3tqCMro0YWz2HCWIF305CavTrUp0rxAXVmcsRmdcAG
        LiIL7uljBwRRIwbKFQYooMH+bAe8P7+zVw==
X-Google-Smtp-Source: ABdhPJzPR+C9CNEclmDBfFIyYRZ7/g7aFG4TvxlsN+u9ItPyv60V7/NUzH1sof4rGr1gv4d7kWaI4g==
X-Received: by 2002:a17:90b:4f81:b0:1dc:681e:248 with SMTP id qe1-20020a17090b4f8100b001dc681e0248mr164884pjb.98.1651679724660;
        Wed, 04 May 2022 08:55:24 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u15-20020aa7838f000000b0050dc7628136sm8642866pfm.16.2022.05.04.08.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 08:55:24 -0700 (PDT)
Message-ID: <71956172-5406-0636-060d-a7c123a2bfab@kernel.dk>
Date:   Wed, 4 May 2022 09:55:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Short sends returned in IORING
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
 <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
 <744d4b58-e7df-a5fb-dfba-77fe952fe1f8@kernel.dk>
In-Reply-To: <744d4b58-e7df-a5fb-dfba-77fe952fe1f8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/22 9:28 AM, Jens Axboe wrote:
> On 5/4/22 9:21 AM, Constantine Gavrilov wrote:
>> On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
>>>> Jens:
>>>>
>>>> This is related to the previous thread "Fix MSG_WAITALL for
>>>> IORING_OP_RECV/RECVMSG".
>>>>
>>>> We have a similar issue with TCP socket sends. I see short sends
>>>> regarding of the method (I tried write, writev, send, and sendmsg
>>>> opcodes, while using MSG_WAITALL for send and sendmsg). It does not
>>>> make a difference.
>>>>
>>>> Most of the time, sends are not short, and I never saw short sends
>>>> with loopback and my app. But on real network media, I see short
>>>> sends.
>>>>
>>>> This is a real problem, since because of this it is not possible to
>>>> implement queue size of > 1 on a TCP socket, which limits the benefit
>>>> of IORING. When we have a short send, the next send in queue will
>>>> "corrupt" the stream.
>>>>
>>>> Can we have complete send before it completes, unless the socket is
>>>> disconnected?
>>>
>>> I'm guessing that this happens because we get a task_work item queued
>>> after we've processed some of the send, but not all. What kernel are you
>>> using?
>>>
>>> This:
>>>
>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
>>>
>>> is queued up for 5.19, would be worth trying.
>>>
>>> --
>>> Jens Axboe
>>>
>>
>> Jens:
>>
>> Thank you for your reply.
>>
>> The kernel is 5.17.4-200.fc35.x86_64. I have looked at the patch. With
>> the solution in place, I am wondering whether it will be possible to
>> use multiple uring send IOs on the same socket. I expect that Linux
>> TCP will serialize multiple send operations on the same socket. I am
>> not sure it happens with uring (meaning that socket is blocked for
>> processing a new IO until the pending IO completes). Do I need
>> IOSQE_IO_DRAIN / IOSQE_IO_LINK for this to work? Would not be optimal
>> because of multiple different sockets in the same uring. While I
>> already have a workaround in the form of a "software" queue for
>> streaming data on TCP sockets, I would rather have kernel to do
>> "native" queueing in sockets layer, and have exrtra CPU cycles
>> available to the  application.
> 
> The patch above will mess with ordering potentially. If the cause is as
> I suspect, task_work causing it to think it's signaled, then the better
> approach may indeed be to just flush that work and retry without
> re-queueing the current one. I can try a patch against 5.18 if you are
> willing and able to test?

You can try something like this, if you run my for-5.19/io_uring branch.
I'd be curious to know if this solves the short send issue for you.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index f6b6db216478..b835e80be1fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5684,6 +5684,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
+retry:
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 
 	if (ret < min_ret) {
@@ -5694,6 +5695,8 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
+			if (io_run_task_work())
+				goto retry;
 			return io_setup_async_msg(req, kmsg);
 		}
 		req_set_fail(req);
@@ -5744,6 +5747,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	msg.msg_flags = flags;
+retry:
 	ret = sock_sendmsg(sock, &msg);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
@@ -5755,6 +5759,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			sr->buf += ret;
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
+			if (io_run_task_work())
+				goto retry;
 			return -EAGAIN;
 		}
 		req_set_fail(req);

-- 
Jens Axboe

