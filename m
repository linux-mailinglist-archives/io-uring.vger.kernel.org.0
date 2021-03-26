Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E329C34AEDD
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 20:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhCZS73 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 14:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCZS7E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 14:59:04 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70F6C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 11:59:03 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id v26so6430650iox.11
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 11:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IPTFHd/bFsFer84YcSkEwgKpuL9sF8ejRR5pI+umTEo=;
        b=yc/HSwMASk6Ljayo+ULC4YvEGj3F6N23Ss3jM7K4MF5ctuibs1oJJmt4NQsEVWeSmO
         2oeM9qhnb36ts+9IzfcFJjJKLf7OZu1xreMgc0bN6eNxUnX45gKpRsCyR7YG8B2e5MBv
         7wd/RyLlkniwktDDXCtwBjVGaRr89Egh+t2v+MGHF9WtzkdxuMWI8xk4irhBYt0nt1qS
         lc1EPXq9Zg7x/aBrUl6/i3xf2d/6ALRR+EhFCxWdFUlBeosfNnCVnLJ+5nj5iKbxyaBo
         puQipbfQ0W+ZmGIyc+zDJDV8dhzwpURqnaAsjnvMjMtMi0C6SdBrrmLmFdsT3rQ2iBpR
         7Amw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IPTFHd/bFsFer84YcSkEwgKpuL9sF8ejRR5pI+umTEo=;
        b=ig7gC4g6LJuRZyx690nOjOh6y33UlCNhgPaXH+OXGDNr42R3ss8AVagyEuEtFwqQi2
         HeSSYH7rzQQd+C8/IsFWd2kVg6ckXixMuu1TzXOdA8Bd+BamzxXLndwoQME6Olr7SbK4
         BXIFm5lfiMcgL/6RQVfeFt2OA93JaoJeD/IGuA+8c9x4HolDNzB+8JhpoV8FmaB6QvPN
         JY0s8o3vYw90swZ7koCRWQcmGdr2UfMX3SbLzAGDG3ixz/8suEcloxxs7PnJzO1edgFb
         fg5KKDcXQguGzpCWZUatWCRFROjHM215X7xMFiBEwsuljd9hiLBSsefr51eL7jd8Bhbr
         +Yow==
X-Gm-Message-State: AOAM5311cDywwP2jNxVuc0vjg/GMH9Z+LBpXW7AeXXkVBiiFqIVHIeHC
        ZAzHEj377bWGh1TlOLJXbhxXgA==
X-Google-Smtp-Source: ABdhPJy67srVFuOjyfRF/VN6JpaOBu3bkbDnVRZ0N9/cQ/2t4+M+T5Ca5PEOOS1s1mSVqPaWPAnMEg==
X-Received: by 2002:a02:c002:: with SMTP id y2mr13308240jai.107.1616785142841;
        Fri, 26 Mar 2021 11:59:02 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o23sm4771061ioo.24.2021.03.26.11.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 11:59:02 -0700 (PDT)
Subject: Re: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
To:     Stefan Metzmacher <metze@samba.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <20210326003928.978750-3-axboe@kernel.dk> <20210326134840.GA1290@redhat.com>
 <a179ad33-5656-b644-0d92-e74a6bd26cc8@kernel.dk>
 <8f2a4b48-77c9-393f-5194-100ed63c05fc@samba.org>
 <58f67a8b-166e-f19c-ccac-157153e4f17c@kernel.dk>
 <c61fc5eb-c997-738b-1a60-5e3db2754f49@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <857d1456-2258-f798-5927-ca4d82f10d50@kernel.dk>
Date:   Fri, 26 Mar 2021 12:59:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c61fc5eb-c997-738b-1a60-5e3db2754f49@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 12:01 PM, Stefan Metzmacher wrote:
> Am 26.03.21 um 16:29 schrieb Jens Axboe:
>> On 3/26/21 9:23 AM, Stefan Metzmacher wrote:
>>> Am 26.03.21 um 16:01 schrieb Jens Axboe:
>>>> On 3/26/21 7:48 AM, Oleg Nesterov wrote:
>>>>> Jens, sorry, I got lost :/
>>>>
>>>> Let's bring you back in :-)
>>>>
>>>>> On 03/25, Jens Axboe wrote:
>>>>>>
>>>>>> With IO threads accepting signals, including SIGSTOP,
>>>>>
>>>>> where can I find this change? Looks like I wasn't cc'ed...
>>>>
>>>> It's this very series.
>>>>
>>>>>> unmask the
>>>>>> SIGSTOP signal from the default blocked mask.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> ---
>>>>>>  kernel/fork.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>>>>> index d3171e8e88e5..d5a40552910f 100644
>>>>>> --- a/kernel/fork.c
>>>>>> +++ b/kernel/fork.c
>>>>>> @@ -2435,7 +2435,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>>>>>>  	tsk = copy_process(NULL, 0, node, &args);
>>>>>>  	if (!IS_ERR(tsk)) {
>>>>>>  		sigfillset(&tsk->blocked);
>>>>>> -		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
>>>>>> +		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
>>>>>
>>>>> siginitsetinv(blocked, sigmask(SIGKILL)|sigmask(SIGSTOP)) but this is minor.
>>>>
>>>> Ah thanks.
>>>>
>>>>> To remind, either way this is racy and can't really help.
>>>>>
>>>>> And if "IO threads accepting signals" then I don't understand why. Sorry,
>>>>> I must have missed something.
>>>>
>>>> I do think the above is a no-op at this point, and we can probably just
>>>> kill it. Let me double check, hopefully we can just remove this blocked
>>>> part.
>>>
>>> Is this really correct to drop in your "kernel: stop masking signals in create_io_thread()"
>>> commit?
>>>
>>> I don't assume signals wanted by userspace should potentially handled in an io_thread...
>>> e.g. things set with fcntl(fd, F_SETSIG,) used together with F_SETLEASE?
>>
>> I guess we do actually need it, if we're not fiddling with
>> wants_signal() for them. To quell Oleg's concerns, we can just move it
>> to post dup_task_struct(), that should eliminate any race concerns
>> there.
> 
> If that one is racy, don' we better also want this one?
> https://lore.kernel.org/io-uring/438b738c1e4827a7fdfe43087da88bbe17eedc72.1616197787.git.metze@samba.org/T/#u
> 
> And clear tsk->pf_io_worker ?

Definitely prudent. I'll get round 2 queued up shortly.

-- 
Jens Axboe

