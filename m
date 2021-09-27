Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474EF419872
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 18:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbhI0QFg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 12:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbhI0QFf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 12:05:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3ADC061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 09:03:57 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 134so23402913iou.12
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G2DZnWlzPuyDTgmdO2tPLAo3GokLfSv3e6IDNFZ7ObI=;
        b=kHG3vm609ygOUIu4ECmb888mnqPGK38TTURz6Jn1a0luwwUzCrSl0c6tcznwwV4EYQ
         6mh/ebm2MuCvVVYkmbjN2uPLY3V3tS0MQYjFltwlaQziuYO7jKvGorJzpeeZPpp02ODJ
         K6iIPTsqwUY6zLWs4dbptHVbciYsLW5Rpvd+hqEDuSSPcUJbCujx4RZ2evRcdGwhl/X2
         6Y5pHeOWzqBjrqPkYthsCKdd5+XGCEGvMJOq5jK4XRV+7jb/6e2AkSOJ0hhwv0tauidj
         bLg0/aictf65LiMYaA9wzNwLkWMFPNg6I2gNMLEwsLFK/ju0HlhqFvGeWOZ835tRasPW
         D7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G2DZnWlzPuyDTgmdO2tPLAo3GokLfSv3e6IDNFZ7ObI=;
        b=tMh8V+SmXe4kWgU61yneRjXUVGjSK7w9k+Y6IDg6UKJmSxbuQIh5TdN8bmNuTlgewI
         JdP6P3UreKJuhgQEc0wl3H5EinnKnpR7u2oroFjfYdvN21dcUFKI3+M+tLzDkpdzwDR2
         b7tO75uDWs+Rxy3/XEiZ70UtMtP4K7i+Uzt7PxZPbGNi1oglAsh65okqxe8GM22d4mW7
         gofEFOsRHuaWOhWrObSGmNuQchYEaKJrEp502zrJTCMejv1hpwEUhN9HNY/vtpgFHdxl
         OFEdCkyzuEf06s1i1AnBX4N7lcO0ceFtpRm9ytQoHMDfh9JN3FiB1WbtV8cCkEQGSpen
         CA6A==
X-Gm-Message-State: AOAM530ix3lNbnalvnosebLK78CTzpMtsROAbIa9FH0mWZshWyy/2Taj
        j3QvEWWqcWcz94tDDf/703PaHFdji24kPX49nRo=
X-Google-Smtp-Source: ABdhPJwhHTr/irdVnzisekunV2CRVh4kPBEFWDmqPjkfDzujh4DO1amV1s8lAueQIL4QN2FxN7UHjg==
X-Received: by 2002:a05:6638:1483:: with SMTP id j3mr568878jak.63.1632758636339;
        Mon, 27 Sep 2021 09:03:56 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m1sm5192699ilc.75.2021.09.27.09.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 09:03:55 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
 <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
 <0eeefd32-f322-1470-9bcf-0f415be517bd@kernel.dk> <87lf3iazyu.fsf@disp2133>
 <feb00062-647c-1c74-dbe1-a7729ca49d7d@kernel.dk>
 <521162e9-c7e4-284e-e575-51c503c51793@kernel.dk> <878rzi831l.fsf@disp2133>
 <f49ac7d4-d0a1-d05e-804b-f784a2ee028d@kernel.dk> <87wnn26mos.fsf@disp2133>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ad6339fa-4cf0-d605-2f33-f45498f98098@kernel.dk>
Date:   Mon, 27 Sep 2021 10:03:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87wnn26mos.fsf@disp2133>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/21 9:52 AM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 9/27/21 9:13 AM, Eric W. Biederman wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> On 9/27/21 8:29 AM, Jens Axboe wrote:
>>>>> On 9/27/21 7:51 AM, Eric W. Biederman wrote:
>>>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>>>
>>>>>>> On 9/25/21 5:05 PM, Linus Torvalds wrote:
>>>>>>>> On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>
>>>>>>>>> - io-wq core dump exit fix (me)
>>>>>>>>
>>>>>>>> Hmm.
>>>>>>>>
>>>>>>>> That one strikes me as odd.
>>>>>>>>
>>>>>>>> I get the feeling that if the io_uring thread needs to have that
>>>>>>>> signal_group_exit() test, something is wrong in signal-land.
>>>>>>>>
>>>>>>>> It's basically a "fatal signal has been sent to another thread", and I
>>>>>>>> really get the feeling that "fatal_signal_pending()" should just be
>>>>>>>> modified to handle that case too.
>>>>>>>
>>>>>>> It did surprise me as well, which is why that previous change ended up
>>>>>>> being broken for the coredump case... You could argue that the io-wq
>>>>>>> thread should just exit on signal_pending(), which is what we did
>>>>>>> before, but that really ends up sucking for workloads that do use
>>>>>>> signals for communication purposes. postgres was the reporter here.
>>>>>>
>>>>>> The primary function get_signal is to make signals not pending.  So I
>>>>>> don't understand any use of testing signal_pending after a call to
>>>>>> get_signal.
>>>>>>
>>>>>> My confusion doubles when I consider the fact io_uring threads should
>>>>>> only be dequeuing SIGSTOP and SIGKILL.
>>>>>>
>>>>>> I am concerned that an io_uring thread that dequeues SIGKILL won't call
>>>>>> signal_group_exit and thus kill the other threads in the thread group.
>>>>>>
>>>>>> What motivated removing the break and adding the fatal_signal_pending
>>>>>> test?
>>>>>
>>>>> I played with this a bit this morning, and I agree it doesn't seem to be
>>>>> needed at all. The original issue was with postgres, I'll give that a
>>>>> whirl as well and see if we run into any unwarranted exits. My simpler
>>>>> test case did not.
>>>>
>>>> Ran the postgres test, and we get tons of io-wq exiting on get_signal()
>>>> returning true. Took a closer look, and it actually looks very much
>>>> expected, as it's a SIGKILL to the original task.
>>>>
>>>> So it looks like I was indeed wrong, and this probably masked the
>>>> original issue that was fixed in that series. I've been running with
>>>> this:
>>>>
>>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>>> index c2360cdc403d..afd1db8e000d 100644
>>>> --- a/fs/io-wq.c
>>>> +++ b/fs/io-wq.c
>>>> @@ -584,10 +584,9 @@ static int io_wqe_worker(void *data)
>>>>  
>>>>  			if (!get_signal(&ksig))
>>>>  				continue;
>>>> -			if (fatal_signal_pending(current) ||
>>>> -			    signal_group_exit(current->signal))
>>>> -				break;
>>>> -			continue;
>>>> +			if (ksig.sig != SIGKILL)
>>>> +				printk("exit on sig! fatal? %d, sig=%d\n", fatal_signal_pending(current), ksig.sig);
>>>> +			break;
>>>>  		}
>>>>  		last_timeout = !ret;
>>>>  	}
>>>>
>>>> and it's running fine and, as expected, we don't generate any printk
>>>> activity as these are all fatal deliveries to the parent.
>>>
>>> Good.  So just a break should be fine.
>>
>> Indeed, I'll send out a patch for that.
>>
>>> A little bit of me is concerned about not calling do_group_exit in this
>>> case.  Fortunately it is not a problem as complete_signal kills all of
>>> the threads in a signal_group when SIGKILL is delivered.
>>>
>>> So at least until something else is refactored and io_uring threads
>>> unblock another fatal signal all is well.
>>
>> Should we put a comment in io-wq to that effect? I don't see why we'd
>> ever unblock other signals there, but...
> 
> I suspect rather we should update this comment in get_signal
> instead.
> 
> 		/*
> 		 * PF_IO_WORKER threads will catch and exit on fatal signals
> 		 * themselves. They have cleanup that must be performed, so
> 		 * we cannot call do_exit() on their behalf.
> 		 */
> 		if (current->flags & PF_IO_WORKER)
> 			goto out;
> 
> 
> Although I would not mind updating io-wq.c and io_uring.c where
> they call get_signal as well. 

Probably best to leave the explanation to the source, in get_signal(). If
you don't mind, I'll leave updating that one to you.

-- 
Jens Axboe

