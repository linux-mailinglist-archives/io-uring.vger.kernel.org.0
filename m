Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EAE1F106A
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 01:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgFGX3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 19:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgFGX3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 19:29:53 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0759C061A0E
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 16:29:53 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh7so5915769plb.11
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 16:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Rohgii9zc3u8cotsbqNhzishRHY5IPoi5aTp9ov/IE=;
        b=y6pYXW40MXFQPbDWSj0UMw5QXQytB6CgHYmumvwn/DwsQWkkjD4CdzvnBqoTYvKlf7
         HUGhnatwOj9x12SJPW/Mx+SOjNCwVSGMgj34TLFFEfI1RDWG13YYpNIvzl7FVxQUQK8P
         bQH2QOJQaDRbJraIXRvc+LIYS5d/DWo+J8Izq/bL+hHkKO8iPASPGtisnXWcqoIZ6BXR
         12YSHJYT888sQ2Lup6mWoY1P+XLN+23vK8QE1X0nx+VcQBWG+fS1Jvqs2mCd64S60es7
         k29EgYDYqOZ65+PRRI0hEufbO5PmbcVkCQGCE7O81RIPALuwbTuHwnfW1G2n+UjyYZnV
         6gSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Rohgii9zc3u8cotsbqNhzishRHY5IPoi5aTp9ov/IE=;
        b=S6+EUmVr/UMYJ0WS0cCb5nimqdNN19uPq0zNCBDOK8E5TcaAZygkGI7D2eMceibx24
         MuC2GnmrfrLYXP55Ivs5TPEGVx2uX6KL3pcrjoHYdEj+zu/HyATvHYG8MBWRdkPRXadJ
         YMiizUWO4Dcyce8UpM5JE1KmNe63NGEEEZ3khU/BMWC9xmz7dhY6qpvuY7G0HMW43U5C
         PwYkug314dhbg6Is6Or2GGZaFkaxLRgviL0HssYf2pFlQDtHnf+uv4IPc+VWsMZ4TneR
         2s9Xr7idZUdwW4IvkidmmY87illGVR+XiOhObSUP72L7XNlLDoFyuZ4cn8YtCa92luIi
         ncPQ==
X-Gm-Message-State: AOAM530lWlJsvepKjDTze5JjlEmvLf10d/0Mfn4jL21+OvFV3VorvO1N
        IB85rYJiNvktjyB3jYj5pDkw6H2Qb8pxIA==
X-Google-Smtp-Source: ABdhPJz81ObxNxCJEugd8qW/OA2MVqKF4rv93TarEr1mglBsvgYzQyjqYSCSinjVvx9FqSHE/0QfNw==
X-Received: by 2002:a17:902:6b49:: with SMTP id g9mr18387672plt.66.1591572593213;
        Sun, 07 Jun 2020 16:29:53 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e12sm4451107pgk.9.2020.06.07.16.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 16:29:52 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
 <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
 <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
 <570f0f74-82a7-2f10-b186-582380200b15@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35bcf4cb-1985-74aa-5748-6ee4095acb20@kernel.dk>
Date:   Sun, 7 Jun 2020 17:29:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <570f0f74-82a7-2f10-b186-582380200b15@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/7/20 2:57 PM, Pavel Begunkov wrote:
> On 07/06/2020 23:36, Pavel Begunkov wrote:
>> On 07/06/2020 18:02, Jens Axboe wrote:
>>> On 6/3/20 7:46 AM, Pavel Begunkov wrote:
>>>> On 02/06/2020 04:16, Xiaoguang Wang wrote:
>>>>> hi Jens, Pavel,
>>>>>
>>>>> Will you have a look at this V5 version? Or we hold on this patchset, and
>>>>> do the refactoring work related io_wq_work firstly.
>>>>
>>>> It's entirely up to Jens, but frankly, I think it'll bring more bugs than
>>>> merits in the current state of things.
>>>
>>> Well, I'd really like to reduce the overhead where we can, particularly
>>> when the overhead just exists to cater to the slow path.
>>>
>>> Planning on taking the next week off and not do too much, but I'll see
>>> if I can get some testing in with the current patches.
>>>
>>
>> I just think it should not be done at expense of robustness.
>>
>> e.g. instead of having tons of if's around ->func, we can get rid of
>> it and issue everything with io_wq_submit_work(). And there are plenty
>> of pros of doing that:
>> - freeing some space in io_kiocb (in req.work in particular)
>> - removing much of stuff with nice negative diffstat
>> - helping this series
>> - even safer than now -- can't be screwed with memcpy(req).
>>
>> Extra switch-lookup in io-wq shouldn't even be noticeable considering
>> punting overhead. And even though io-wq loses some flexibility, as for
>> me that's fine as long as there is only 1 user.
> 
> How about diff below? if split and cooked properly.
> 3 files changed, 73 insertions(+), 164 deletions(-)
> 
> 
> @@ -94,9 +93,9 @@ struct io_wq_work {
>  	pid_t task_pid;
>  };
>  
> -#define INIT_IO_WORK(work, _func)				\
> +#define INIT_IO_WORK(work)					\
>  	do {							\
> -		*(work) = (struct io_wq_work){ .func = _func };	\
> +		*(work) = (struct io_wq_work){};		\
>  	} while (0)						\
>  

Would be nice to optimize this one, it's a lot of clearing for something
we'll generally not use at all in the fast path. Or at least keep it
only for before when we submit the work for async execution.

From a quick look at this, otherwise looks great! Please do split and
submit this.

-- 
Jens Axboe

