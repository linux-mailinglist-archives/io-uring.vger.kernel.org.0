Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D6E44DAD8
	for <lists+io-uring@lfdr.de>; Thu, 11 Nov 2021 17:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhKKQ63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Nov 2021 11:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbhKKQ63 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Nov 2021 11:58:29 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9392C0613F5
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 08:55:39 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id y16so7716805ioc.8
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 08:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c0b+hC/XDihRQz0ifQCdSeDlqm8YlsDJfuP5nIliYKI=;
        b=6hi/B7Xq92RW3hOc+kTqRDqV1QxRgCmJiaIVX5wOSaae+jwLHvQV5HP47Y/1tTFlkU
         BlqkWAtU02MCwPb1Pea3dTq3Ak2QGOJKwRXF18y7b5CaKuvoKhgfAGl9kHbV6KBf1gsw
         Tta/UYAgEpC9AAwgS2tL1nhcLN0xtKYYjQeL/vAC+6JAQb67eOlygQWoY02xF20aTsLn
         YZmntfRJSjbyC5mSNFams34P6QBWrmAzzfaVqNoeIM3PGjbr6XeMYNDQY5+JbCszIWxt
         rIDktlmQ8MipFbaLngciMonCX1oITMqO85yNLEYAUUSgdMPaMgPsN26DL4pghxMPnHPb
         CUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c0b+hC/XDihRQz0ifQCdSeDlqm8YlsDJfuP5nIliYKI=;
        b=3xYEKnFl2CsGkfx8UiaCF6/xnwJ1j5v+234g4bFrTHlrdmX2hxZOv0UNvz0fYBGzuR
         gE4yDxWjOiYRsHDoe7QpPjZuKNsuIkhxYgXqVoQtfKxwEaoG+bo7+/SMDABMqkrY3rV0
         sdimFTDlvVPSGgH0SsJpadLEkVn4qkTTHAsboPSyoxg62m5E8lFNxN/KTIGxvzuJgqAo
         gA+8vZcqDO+9Jo9CMtdmbT9DWz02pJ0Q4Mz4HINDZ5TEnmI68Mr36JxrS5zIVDeC6wAT
         7ngQ5sSG6sNi2EDKI8HoZ9cRUNhX3u7zghgZuuUHVsmZnYmF2J5yRc3De3GpBSNzXybJ
         whMw==
X-Gm-Message-State: AOAM530m150vgYRuPIWLrltSHHX7xxD/b2delQjYDe0vjcQCNHBuB9p+
        hX8xgjndhyQ1hNcsW3sIeRfOv7fXBQOT1BGU
X-Google-Smtp-Source: ABdhPJyZuWOZ6418wabYKIFg8XBi4HnmxPEB13Iw4WQJF10htXFA9/QRhG/Eg9HpK8zeXoKti6goMQ==
X-Received: by 2002:a05:6602:2a42:: with SMTP id k2mr5906770iov.97.1636649738946;
        Thu, 11 Nov 2021 08:55:38 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s3sm2227492ilv.61.2021.11.11.08.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 08:55:38 -0800 (PST)
Subject: Re: uring regression - lost write request
From:   Jens Axboe <axboe@kernel.dk>
To:     Daniel Black <daniel@mariadb.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
 <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
 <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
 <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
Message-ID: <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
Date:   Thu, 11 Nov 2021 09:55:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/21 9:19 AM, Jens Axboe wrote:
> On 11/11/21 8:29 AM, Jens Axboe wrote:
>> On 11/11/21 7:58 AM, Jens Axboe wrote:
>>> On 11/11/21 7:30 AM, Jens Axboe wrote:
>>>> On 11/10/21 11:52 PM, Daniel Black wrote:
>>>>>> Would it be possible to turn this into a full reproducer script?
>>>>>> Something that someone that knows nothing about mysqld/mariadb can just
>>>>>> run and have it reproduce. If I install the 10.6 packages from above,
>>>>>> then it doesn't seem to use io_uring or be linked against liburing.
>>>>>
>>>>> Sorry Jens.
>>>>>
>>>>> Hope containers are ok.
>>>>
>>>> Don't think I have a way to run that, don't even know what podman is
>>>> and nor does my distro. I'll google a bit and see if I can get this
>>>> running.
>>>>
>>>> I'm fine building from source and running from there, as long as I
>>>> know what to do. Would that make it any easier? It definitely would
>>>> for me :-)
>>>
>>> The podman approach seemed to work, and I was able to run all three
>>> steps. Didn't see any hangs. I'm going to try again dropping down
>>> the innodb pool size (box only has 32G of RAM).
>>>
>>> The storage can do a lot more than 5k IOPS, I'm going to try ramping
>>> that up.
>>>
>>> Does your reproducer box have multiple NUMA nodes, or is it a single
>>> socket/nod box?
>>
>> Doesn't seem to reproduce for me on current -git. What file system are
>> you using?
> 
> I seem to be able to hit it with ext4, guessing it has more cases that
> punt to buffered IO. As I initially suspected, I think this is a race
> with buffered file write hashing. I have a debug patch that just turns
> a regular non-numa box into multi nodes, may or may not be needed be
> needed to hit this, but I definitely can now. Looks like this:
> 
> Node7 DUMP                                                                      
> index=0, nr_w=1, max=128, r=0, f=1, h=0                                         
>   w=ffff8f5e8b8470c0, hashed=1/0, flags=2                                       
>   w=ffff8f5e95a9b8c0, hashed=1/0, flags=2                                       
> index=1, nr_w=0, max=127877, r=0, f=0, h=0                                      
> free_list                                                                       
>   worker=ffff8f5eaf2e0540                                                       
> all_list                                                                        
>   worker=ffff8f5eaf2e0540
> 
> where we seed node7 in this case having two work items pending, but the
> worker state is stalled on hash.
> 
> The hash logic was rewritten as part of the io-wq worker threads being
> changed for 5.11 iirc, which is why that was my initial suspicion here.
> 
> I'll take a look at this and make a test patch. Looks like you are able
> to test self-built kernels, is that correct?

Can you try with this patch? It's against -git, but it will apply to
5.15 as well.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index afd955d53db9..7917b8866dcc 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -423,9 +423,10 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
+static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 {
 	struct io_wq *wq = wqe->wq;
+	bool ret = false;
 
 	spin_lock_irq(&wq->hash->wait.lock);
 	if (list_empty(&wqe->wait.entry)) {
@@ -433,9 +434,11 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 		if (!test_bit(hash, &wq->hash->map)) {
 			__set_current_state(TASK_RUNNING);
 			list_del_init(&wqe->wait.entry);
+			ret = true;
 		}
 	}
 	spin_unlock_irq(&wq->hash->wait.lock);
+	return ret;
 }
 
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
@@ -447,6 +450,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	unsigned int stall_hash = -1U;
 	struct io_wqe *wqe = worker->wqe;
 
+retry:
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
@@ -475,14 +479,18 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	}
 
 	if (stall_hash != -1U) {
+		bool do_retry;
+
 		/*
 		 * Set this before dropping the lock to avoid racing with new
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 		raw_spin_unlock(&wqe->lock);
-		io_wait_on_hash(wqe, stall_hash);
+		do_retry = io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		if (do_retry)
+			goto retry;
 	}
 
 	return NULL;

-- 
Jens Axboe

