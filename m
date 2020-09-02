Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF92E25B0A5
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 18:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgIBQFX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 12:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBQFW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 12:05:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26552C061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 09:05:22 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x2so5470338ilm.0
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 09:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eX/EtmQqSZYm8aWwEBbszVRQoe/arKWvgxSf53AszpQ=;
        b=Xu0sSbp6h61J9DlXDhPvqhsMhfWF2hLyBaoiSwOAe16EvS9wNQO7IFUFRjihLhH/Vg
         jzfLRUPEtNMHT+e1ItSh0s0cO5bcPzGnye3mIyn5UclZ4H5ZJuKd1BihNdJF3wbgTzlV
         lxrAWZ6ALyhcR9FMJlsPrSfafJ0gx9uvk9A4/DAGTaGCNb4JfmF3lL5rS/QEE1VZ9n4j
         JHzsai6qQGoLY+I6bzN+/NWVTsNWlc4zWNGVbF3PhD33kybmSQ7H8xIpmIBH9DuhCbGh
         TciVUdugvatQEq8sxUnRO7QCoVMhHZw7ixkwdYBRQd9rUcKr+qTZQ9di0H9sqdZdjL/i
         VcxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eX/EtmQqSZYm8aWwEBbszVRQoe/arKWvgxSf53AszpQ=;
        b=Zcsg5s9avuf+7dNqfpKnt4s7MXsUy5vwgyIlWEWtwiuF5UcjhkTDPgK+7l1O2SXp4x
         BSO+xpv3rOoQOnJ7cmhkhQMgOPXdjBzKwjlUwEgamfREczMQuxwFC2q/YFTt6zSGUewr
         FUw4bVIAl2tg8UJyRAEHzNSSFAeLSETZu1uDuaCuaMeJ7r0A3Tz5IskfXrSqF+Kso1Xk
         F4vJnfd/ZfukLC4bDfKdqui1zMA++CxP3zweT3d+knvcXzFRyYchYXeqVg8ibwtt5w8k
         OGJ9zWifNmtOXweM9SYPk+50UpLJK9gPD0WtmBgu3dwJwkUDhY/b0aLYM25IiKwacHUx
         QsJw==
X-Gm-Message-State: AOAM532ZnGYDq3KMjI546Kz1qYStA0QVzuPr87kDa09Zer8KIKwLkKn2
        dB4MfuID0b6YsdYzOFjsosRdw80n0jqTxUfc
X-Google-Smtp-Source: ABdhPJzALt1Z6TVct6pvh81REKvF1T1QlN6Ns3U/cEVIbOUMyB+LVxGFGY2fgb9h7AK/8XH8eMDzeA==
X-Received: by 2002:a92:6612:: with SMTP id a18mr3876176ilc.94.1599062721447;
        Wed, 02 Sep 2020 09:05:21 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u17sm2411650ilb.44.2020.09.02.09.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 09:05:21 -0700 (PDT)
Subject: Re: IORING_OP_READ and O_NONBLOCK behaviour
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring@vger.kernel.org
Cc:     Josef <josef.grieb@gmail.com>
References: <28EF4A51-2B6D-4857-A9E8-2E28E530EFA6@googlemail.com>
 <05c1b12c-5fb8-c7f5-c678-65249da5a6b1@kernel.dk>
 <72c31af6-2c85-4105-65fb-87a860a65a78@gmail.com>
 <06ee57db-7fcc-140a-a9de-e6e67a68b56e@kernel.dk>
 <a33bd653-1b99-43a3-216c-c1b3b93f15d8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2616564c-aa35-1f25-c9de-4d6735e73a9b@kernel.dk>
Date:   Wed, 2 Sep 2020 10:05:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a33bd653-1b99-43a3-216c-c1b3b93f15d8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/20 10:00 AM, Pavel Begunkov wrote:
> On 02/09/2020 18:35, Jens Axboe wrote:
>> On 9/2/20 9:26 AM, Pavel Begunkov wrote:
>>> On 02/09/2020 17:45, Jens Axboe wrote:
>>>> On 9/2/20 4:09 AM, Norman Maurer wrote:
>>>>> Hi there,
>>>>>
>>>>> We are currently working on integrating io_uring into netty and found
>>>>> some “suprising” behaviour which seems like a bug to me.
>>>>>
>>>>> When a socket is marked as non blocking (accepted with O_NONBLOCK flag
>>>>> set) and there is no data to be read IORING_OP_READ should complete
>>>>> directly with EAGAIN or EWOULDBLOCK. This is not the case and it
>>>>> basically blocks forever until there is some data to read. Is this
>>>>> expected ?
>>>>>
>>>>> This seems to be somehow related to a bug that was fixed for
>>>>> IO_URING_ACCEPT with non blocking sockets:
>>>>>
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.8&id=e697deed834de15d2322d0619d51893022c90ea2
>>>>
>>>> I agree with you that this is a bug, in general it's useful (and
>>>> expected) that we'd return -EAGAIN for that case. I'll take a look.
>>>>
>>>
>>> That's I mentioned that doing retries for nonblock requests in
>>> io_wq_submit_work() doesn't look consistent. I think killing it
>>> off may help.
>>
>> Right, we should not retry those _in general_, the exception is regular
>> files or block devices to handle IOPOLL retry where we do need it. The
>> below is what I came up with for this one. Might not hurt to make this
>> more explicit for 5.10.
> 
> Hmm, I didn't checked it, but if we 
> 
>>
>>
>> commit c78e0f02c3861b5b176b2f79552677b3604deb76
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Sep 2 09:30:31 2020 -0600
>>
>>     io_uring: no read-retry on -EAGAIN error and O_NONBLOCK marked file
>>     
>>     Actually two things that need fixing up here:
>>     
>>     - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
>>       regular files, so don't ever attempt to do that on other types of
>>       files.
>>     
>>     - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
>>       it. It should just complete with -EAGAIN.
>>     
>>     Cc: stable@vger.kernel.org
>>     Reported-by: Norman Maurer <norman.maurer@googlemail.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index b1ccd7072d93..dc27cd5b8ad6 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2300,8 +2300,11 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
>>  static bool io_rw_reissue(struct io_kiocb *req, long res)
>>  {
>>  #ifdef CONFIG_BLOCK
>> +	umode_t mode = file_inode(req->file)->i_mode;
>>  	int ret;
>>  
>> +	if (!S_ISBLK(mode) && !S_ISREG(mode))
>> +		return false;
>>  	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
>>  		return false;
>>  
>> @@ -3146,6 +3149,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>>  		/* IOPOLL retry should happen for io-wq threads */
>>  		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
>>  			goto done;
>> +		/* no retry on NONBLOCK marked file */
>> +		if (kiocb->ki_flags & IOCB_NOWAIT)
>> +			goto done;
> 
> We clearing and setting IOCB_NOWAIT depending on @force_nonblock, so it may not
> work. E.g. with IOSQE_IO_ASYNC io_read() will clear it at the beginning.
> Maybe REQ_F_NOWAIT?

Yeah, the posted version did get it right:

https://lore.kernel.org/io-uring/5d91a8ea-5748-803a-d2dc-ef21fe27e39e@kernel.dk/T/#u


-- 
Jens Axboe

