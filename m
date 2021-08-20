Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325553F36A0
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhHTWrb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHTWrb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:47:31 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D91C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:46:53 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id g9so14179410ioq.11
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DUtwTvwFF1Ohy/BjuZ6qycejqIYt3vsLP/FzQQhBfII=;
        b=VRl9UfmWeBSKK32wpNW1yCrNMJRq30bSUfnB1yLCcw+34iqpYael4MnNSdEv4ZfjPu
         BH6lP1tNqAmzwHXnuCVfoZ5bHOsfgmGsMv9hfSL64Rwqt21bd01SqSpqDWc70b2PIp2i
         6Llu0wRqkOOfHGNoBdPwbvvILxOu1W7DTw9lJJ41VA6opQ5n/uztYb6KmBPHUsqd/OvV
         qg312plPSjDrpuG4nlAmvW4HLB1jXeb+Fc2dKH7RTYyvF3xMSuarCfIk5p8+ZGLehJD0
         KoQ3PFT+7YyfM6VZHTOdCvQ9VntNK9fq7dxjqnvtpdPTKNt7R+NGKP3d+KJUU6urtKjw
         rziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DUtwTvwFF1Ohy/BjuZ6qycejqIYt3vsLP/FzQQhBfII=;
        b=JzsSlgxCjrM/+8iTmgtLUOH9uAHQwqokzZDct2pgf+QTdJqn6wKfRiKEIswfCYN/K6
         VY5DRF7BGYAFwCZivRV52tmf8dz/w8Hhzi42OMP/DWwixwhCalDB5guaSE2Qq8SZCzQN
         qEjHUz87JpcmpJnKXazbyLYyj30jr9cMWJjdbmPOQt9w6ED8Sr0l25DXlvRKQu8XhtyQ
         vzwHoUH2h02VqHVLnr0EoWNe9PHd7lwZP+c+DcGufn3N09MovBgu7bqpGVjIDTEnHRk8
         UcKbxIVQ1RhfQcvqfBTzzSBYgMYBPZMdU7gJmDIW0Pe/U8AE05WCf7mjIpgUvIaHO+JX
         IdDg==
X-Gm-Message-State: AOAM5323x+FyWE7QwpWyK05Ds9IwhQJEtDesuSoN72NhaQtj/8znasqB
        twJh+F/u+N2S9/+9kP1/jmqvmQnileb7MJfT
X-Google-Smtp-Source: ABdhPJz3GdHRmgihfH/fw/pAoi9KLRiq7WKcsI0AeFVBbIcq+EAd1TesvyKPHRgTWjT1DglEg9AZ2Q==
X-Received: by 2002:a5d:9693:: with SMTP id m19mr17650519ion.181.1629499612272;
        Fri, 20 Aug 2021 15:46:52 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p15sm3584773ilc.12.2021.08.20.15.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:46:52 -0700 (PDT)
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
 <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
 <8ab470e7-83f1-a0ef-f43b-29af8f84d229@gmail.com>
 <3cae21c2-5db7-add1-1587-c87e22e726dc@kernel.dk>
 <34b4d60a-d3c5-bb7d-80c9-d90a98f8632d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5900a96e-541c-4dba-eb42-dc8c30f6d5ea@kernel.dk>
Date:   Fri, 20 Aug 2021 16:46:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34b4d60a-d3c5-bb7d-80c9-d90a98f8632d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 4:41 PM, Pavel Begunkov wrote:
> On 8/20/21 11:30 PM, Jens Axboe wrote:
>> On 8/20/21 4:28 PM, Pavel Begunkov wrote:
>>> On 8/20/21 11:09 PM, Jens Axboe wrote:
>>>> On 8/20/21 3:32 PM, Pavel Begunkov wrote:
>>>>> On 8/20/21 9:39 PM, Hao Xu wrote:
>>>>>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>>>>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>>>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>>>>>> may cause problems when accessing it parallelly.
>>>>>>>
>>>>>>> Did you hit any problem? It sounds like it should be fine as is:
>>>>>>>
>>>>>>> The trick is that it's only responsible to flush requests added
>>>>>>> during execution of current call to tctx_task_work(), and those
>>>>>>> naturally synchronised with the current task. All other potentially
>>>>>>> enqueued requests will be of someone else's responsibility.
>>>>>>>
>>>>>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>>>>>> 0 there, but actually enqueued a request, it means someone
>>>>>>> actually flushed it after the request had been added.
>>>>>>>
>>>>>>> Probably, needs a more formal explanation with happens-before
>>>>>>> and so.
>>>>>> I should put more detail in the commit message, the thing is:
>>>>>> say coml_nr > 0
>>>>>>
>>>>>>   ctx_flush_and put                  other context
>>>>>>    if (compl_nr)                      get mutex
>>>>>>                                       coml_nr > 0
>>>>>>                                       do flush
>>>>>>                                           coml_nr = 0
>>>>>>                                       release mutex
>>>>>>         get mutex
>>>>>>            do flush (*)
>>>>>>         release mutex
>>>>>>
>>>>>> in (*) place, we do a bunch of unnecessary works, moreover, we
>>>>>
>>>>> I wouldn't care about overhead, that shouldn't be much
>>>>>
>>>>>> call io_cqring_ev_posted() which I think we shouldn't.
>>>>>
>>>>> IMHO, users should expect spurious io_cqring_ev_posted(),
>>>>> though there were some eventfd users complaining before, so
>>>>> for them we can do
>>>>
>>>> It does sometimes cause issues, see:
>>>
>>> I'm used that locking may end up in spurious wakeups. May be
>>> different for eventfd, but considering that we do batch
>>> completions and so might be calling it only once per multiple
>>> CQEs, it shouldn't be.
>>
>> The wakeups are fine, it's the ev increment that's causing some issues.
> 
> If userspace doesn't expect that eventfd may get diverged from the
> number of posted CQEs, we need something like below. The weird part
> is that it looks nobody complained about this one, even though it
> should be happening pretty often. 

That wasn't the issue we ran into, it was more the fact that eventfd
would indicate that something had been posted, when nothing had.
We don't need eventfd notifications to be == number of posted events,
just if the eventfd notification is inremented, there should be new
events there.

-- 
Jens Axboe

