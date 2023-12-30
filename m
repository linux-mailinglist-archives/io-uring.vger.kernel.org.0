Return-Path: <io-uring+bounces-368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8D1820915
	for <lists+io-uring@lfdr.de>; Sun, 31 Dec 2023 00:19:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F3CA1C212C2
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 23:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7A6DDBB;
	Sat, 30 Dec 2023 23:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VsMNWJoW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B785D30B;
	Sat, 30 Dec 2023 23:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-556275957ccso160764a12.0;
        Sat, 30 Dec 2023 15:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703978369; x=1704583169; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRJ+DTpGBZ3TXUxBHuDKhYlIwy5ESgSOhmMKsr/UzJk=;
        b=VsMNWJoWdSoMHHT6h7CHq3LkihQ+2NHcHTuHZfQeUw9xpvhEIaFeD0qKzjo8Ey+1bS
         ec1dUMg9jE8UdZmqAbBR1ataq8RNSPNsWdDvZqLvl4FKwrnyTNxmyp8PWvXqAceoiNo9
         7J60z5ZHoFHkj9xlLmh8eUGPTCBRCnFpJaMvuZ98sMPRRRmv5mXNRSE0cEKYOgJsolnf
         BSUt/4zKc+6WgYtCOhGpW6XvEoeIPORPiIjp6VuiGpxXL4WgVMPymXREZB5cCLR2pi6E
         Q2/Un9Y4MAy0PQObtLKbG9lPHjPYJNQMd2Cx8EezNCzO6QfIvI+fdQ+iWFwiTrtvrQa3
         ig+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703978369; x=1704583169;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XRJ+DTpGBZ3TXUxBHuDKhYlIwy5ESgSOhmMKsr/UzJk=;
        b=M36aoWCUUT1kOra8GOLCLfV7RPShYv1/ep0APkTf2lBRrjVUwNNrw9sj4+zzbY8w5s
         ntGN2xjn9m8uxoIoLFofA4pwEDaP80XwzgcrgqRSjOLtJffq/U36mT/59nxcUmrLo2Rb
         JUPkrndH/CZE6Iw7vekGARLDADqPLlAAAqAk6x8CEvGLNeBE549y77QRhmRysEDPPQhG
         nHBp3mw47pQo03Fw5j5dgfZv9/QRssCSH+PXtCcSBEkDxwTyldFxF9uEI+ZmlBeOLwtG
         0GWaEHXmNMkBIbiRfvDilfK7BO+3r/1NwdnJl+UpO7BPeIuq6Gl3cM7RjLXIL+sxnuvU
         uPww==
X-Gm-Message-State: AOJu0YzLR7W31w1mIYjWCfMkHFNLiUi5du6LXLhdTai6D2r5/y6yEool
	yS3X0NP/sWAfdEqQ7qOaPPs=
X-Google-Smtp-Source: AGHT+IFD2W0fnppJaiSDwzmpCN6Plf+687SYG2Vbu8LWIhyePQe+l38LRyGT6PXgtQRBftG8pcFokg==
X-Received: by 2002:a50:d706:0:b0:553:7e5:df10 with SMTP id t6-20020a50d706000000b0055307e5df10mr5074985edi.22.1703978368618;
        Sat, 30 Dec 2023 15:19:28 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.139])
        by smtp.gmail.com with ESMTPSA id c1-20020a056402100100b00555ac93cd00sm3146831edu.41.2023.12.30.15.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Dec 2023 15:19:28 -0800 (PST)
Message-ID: <97804586-ca0c-4918-be05-0863b92cc141@gmail.com>
Date: Sat, 30 Dec 2023 23:17:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
To: Jens Axboe <axboe@kernel.dk>, Xiaobing Li <xiaobing.li@samsung.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 cliang01.li@samsung.com, xue01.he@samsung.com
References: <CGME20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb@epcas5p4.samsung.com>
 <20231225054438.44581-1-xiaobing.li@samsung.com>
 <170360833542.1229482.7687326255574388809.b4-ty@kernel.dk>
 <7967c7a9-3d17-44de-a170-2b5354460126@gmail.com>
 <57b81a15-58ae-46c1-a1af-9117457a31c7@kernel.dk>
 <6167a98c-35f3-4ea6-a807-dc87c0e4e1bf@gmail.com>
 <d383aaa6-8918-42c6-8ec0-73e234175770@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d383aaa6-8918-42c6-8ec0-73e234175770@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/23 22:17, Jens Axboe wrote:
> On 12/30/23 2:06 PM, Pavel Begunkov wrote:
>> On 12/30/23 17:41, Jens Axboe wrote:
>>> On 12/30/23 9:27 AM, Pavel Begunkov wrote:
>>>> On 12/26/23 16:32, Jens Axboe wrote:
>>>>>
>>>>> On Mon, 25 Dec 2023 13:44:38 +0800, Xiaobing Li wrote:
>>>>>> Count the running time and actual IO processing time of the sqpoll
>>>>>> thread, and output the statistical data to fdinfo.
>>>>>>
>>>>>> Variable description:
>>>>>> "work_time" in the code represents the sum of the jiffies of the sq
>>>>>> thread actually processing IO, that is, how many milliseconds it
>>>>>> actually takes to process IO. "total_time" represents the total time
>>>>>> that the sq thread has elapsed from the beginning of the loop to the
>>>>>> current time point, that is, how many milliseconds it has spent in
>>>>>> total.
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>>
>>>>> [1/1] io_uring: Statistics of the true utilization of sq threads.
>>>>>          commit: 9f7e5872eca81d7341e3ec222ebdc202ff536655
>>>>
>>>> I don't believe the patch is near complete, there are still
>>>> pending question that the author ignored (see replies to
>>>> prev revisions).
>>>
>>> We can drop and defer, that's not an issue. It's still sitting top of
>>> branch.
>>>
>>> Can you elaborate on the pending questions?
>>
>> I guess that wasn't clear, but I duplicated all of them in the
>> email you're replying to for convenience
>>
>>>> Why it uses jiffies instead of some task run time?
>>>> Consequently, why it's fine to account irq time and other
>>>> preemption? (hint, it's not)
>>>
>>> Yeah that's a good point, might be better to use task run time. Jiffies
>>> is also an annoying metric to expose, as you'd need to then get the tick
>>> rate as well. Though I suspect the ratio is the interesting bit here.
>>
>> I agree that seconds are nicer, but that's not my point. That's
>> not about jiffies, but that the patch keeps counting regardless
>> whether the SQ task was actually running, or the CPU was serving
>> irq, or even if it was force descheduled.
> 
> Right, guess I wasn't clear, I did very much agree with using task run
> time to avoid cases like that where it's perceived running, but really
> isn't. For example.
> 
>> I even outlined what a solution may look like, i.e. replace jiffies
>> with task runtime, which should already be counted in the task.
> 
> Would be a good change to make. And to be fair, I guess they originally
> wanted something like that, as the very first patch had some scheduler
> interactions. Just wasn't done quite right.

Right, just like what the v1 was doing but without touching
core/sched.

>>>> Why it can't be done with userspace and/or bpf? Why
>>>> can't it be estimated by checking and tracking
>>>> IORING_SQ_NEED_WAKEUP in userspace?
>>>
>>> Asking people to integrate bpf for this is a bit silly imho. Tracking
>>
>> I haven't seen any mention of the real use case, did I miss it?
>> Because otherwise I fail to see how it can possibly be called
>> silly when it's not clear how exactly it's used.
>>
>> Maybe it's a bash program printing stats to a curious user? Or
>> maybe it's to track once at start, and then nobody cares about
>> it, in which case NEED_WAKEUP would be justified.
>>
>> I can guess it's for adjusting the sq timeouts, but who knows.
> 
> I only know what is in those threads, but the most obvious use case
> would indeed be to vet the efficiency of the chosen timeout value and
> balance cpu usage with latency like that.
> 
>>> NEED_WAKEUP is also quite cumbersome and would most likely be higher
>>> overhead as well.
>>
>> Comparing to reading a procfs file or doing an io_uring
>> register syscall? I doubt that. It's also not everyone
>> would be using that.
> 
> What's the proposed integration to make NEED_WAKEUP sampling work? As
> far as I can tell, you'd need to either do that kind of accounting every
> time you do io_uring_submit(), or make it conditional which would then
> at least still have a branch.
> 
> The kernel side would obviously not be free either, but at least it
> would be restricted to the SQPOLL side of things and not need to get
> entangled with the general IO path that doesn't use SQPOLL.
> 
> If we put it in there and have some way to enable/query/disable, then it
> least it would just be a branch or two in there rather than in the
> generic path.

It can be in the app without ever touching liburing/kernel. E.g. you
can binary search the idle time, minimising it, while looking that
sqpoll doesn't go to sleep too often topping with other conditions.
Another stat you can get right away is to compare the current idle
time with the total time since last wake up (which should be idle +
extra).

It might be enough for _some_ apps, but due to the fog of war
I assume there are currently 0 apps supposed that are supposed
to use it anyway.

>>>> What's the use case in particular? Considering that
>>>> one of the previous revisions was uapi-less, something
>>>> is really fishy here. Again, it's a procfs file nobody
>>>> but a few would want to parse to use the feature.
>>>
>>> I brought this up earlier too, fdinfo is not a great API. For anything,
>>> really.
>>
>> I saw that comment, that's why I mentioned, but the
>> point is that I have doubts the author is even using
>> the uapi.
> 
> Not sure I follow... If they aren't using the API, what's the point of
> the patch? Or are you questioning whether this is being done for an
> actual use case, or just as a "why not, might be handy" kind of thing?
I assume there is a use case, which hasn't been spelled out
though AFAIK, but as a matter of fact earlier patches had no uapi.

https://lore.kernel.org/all/20231106074055.1248629-1-xiaobing.li@samsung.com/

and later patches use a suspiciously inconvenient interface,
i.e. /proc. It's a good question how it was supposed to be used
(and tested), but I have only guesses. Private patches? A custom
module? Or maybe a genuine mistake, which is why I'm still very
curious hearing about the application.

-- 
Pavel Begunkov

