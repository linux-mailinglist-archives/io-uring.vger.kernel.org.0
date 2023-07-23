Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7A75E2DD
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 17:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjGWPbd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 11:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjGWPbc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 11:31:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07B81A7
        for <io-uring@vger.kernel.org>; Sun, 23 Jul 2023 08:31:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6748a616e17so968732b3a.1
        for <io-uring@vger.kernel.org>; Sun, 23 Jul 2023 08:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690126289; x=1690731089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fDTMYwDqEgFqSn0Pl8eq3n9zy7vYWtdmW+PQbREAfGo=;
        b=D2U81L0yay3s2CHGMfdTVZNe5ck5DZzVI4ZCXjD97LPBzeNxvTavVAl3j6LnswenH6
         +7H9PoAx6BHp4l+/rCqF4P25FWANKbJMj1/0mgYFmzJPpEdY33k4LaEVJMrz6GveOr87
         3jdu0Ti5zUA+cQm2oDAc219xPiHNyfgjbgJyVL+DvllJM+ZvoTQE7KOi9m5E6Oyjf7SN
         SJoyz8cDv90JfR3V0RVuSZ4AnD9EDyqJDVHB7Tk10WKyRBG00iqe5152e2yzJofTE+UO
         1h5T1WvomLTZpcbWml3CP5npLwhTZV6aSGXaGo/jdBQ4Z57KlUXyDpmDqNC8XEa6Uifr
         XngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690126289; x=1690731089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fDTMYwDqEgFqSn0Pl8eq3n9zy7vYWtdmW+PQbREAfGo=;
        b=eVkqL7zSa+TVgJh+ddAoTuqDXzyd1TUBr/FisLmamTvryeDWhAemafyPKkt3t0VrCW
         BQHH8UxwfrnOiL01g6DHWYB8wUYJq6YXoTihwP93e7Yrb5ej1djUSRx9AX/RtPz7o/FF
         DAMMmHrkl3SuNCy+jmaCoGZd7fzpm0D6nsOjJeEx9lzrmtqjQ6ovVmcqPTQ88pCLPO5h
         fQVUSdxYgayFkpZ3N3rcH196gjoPkqXKtbGxk2zMCsPu2mYdmz4lcjlsNO5Qf8vFvfYx
         BJ3ujdAmVv7skuFXyx1sgGR1D21kSFfauMD+JoXqA1gP69Kc3pjlxOT2KxqY/o9Xh/KR
         QqGg==
X-Gm-Message-State: ABy/qLYCIQ6uJWlQLiPyobi6gdu/NB7zTjqvVzbHD/MpUmYpz0x59ZrO
        QAOc/ZDYRgTbl5bC7D3GRQitDw==
X-Google-Smtp-Source: APBJJlHXouCZDH/+NNu1TfzsTLZtOP1XA/fWhsuSOrjvoTA5jn+cYnPSHKt7RkpkfKq2EWMJpz19Kg==
X-Received: by 2002:a05:6a00:3993:b0:682:59aa:178d with SMTP id fi19-20020a056a00399300b0068259aa178dmr9063211pfb.1.1690126289030;
        Sun, 23 Jul 2023 08:31:29 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a14-20020aa7864e000000b0064fe06fe712sm6074443pfo.129.2023.07.23.08.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jul 2023 08:31:28 -0700 (PDT)
Message-ID: <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
Date:   Sun, 23 Jul 2023 09:31:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716195007.731909670@linuxfoundation.org>
 <12251678.O9o76ZdvQC@natalenko.name>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <12251678.O9o76ZdvQC@natalenko.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/23 3:39?AM, Oleksandr Natalenko wrote:
> Hello.
> 
> On ned?le 16. ?ervence 2023 21:50:53 CEST Greg Kroah-Hartman wrote:
>> From: Andres Freund <andres@anarazel.de>
>>
>> commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.
>>
>> I observed poor performance of io_uring compared to synchronous IO. That
>> turns out to be caused by deeper CPU idle states entered with io_uring,
>> due to io_uring using plain schedule(), whereas synchronous IO uses
>> io_schedule().
>>
>> The losses due to this are substantial. On my cascade lake workstation,
>> t/io_uring from the fio repository e.g. yields regressions between 20%
>> and 40% with the following command:
>> ./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/write.0.0
>>
>> This is repeatable with different filesystems, using raw block devices
>> and using different block devices.
>>
>> Use io_schedule_prepare() / io_schedule_finish() in
>> io_cqring_wait_schedule() to address the difference.
>>
>> After that using io_uring is on par or surpassing synchronous IO (using
>> registered files etc makes it reliably win, but arguably is a less fair
>> comparison).
>>
>> There are other calls to schedule() in io_uring/, but none immediately
>> jump out to be similarly situated, so I did not touch them. Similarly,
>> it's possible that mutex_lock_io() should be used, but it's not clear if
>> there are cases where that matters.
>>
>> Cc: stable@vger.kernel.org # 5.10+
>> Cc: Pavel Begunkov <asml.silence@gmail.com>
>> Cc: io-uring@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Andres Freund <andres@anarazel.de>
>> Link: https://lore.kernel.org/r/20230707162007.194068-1-andres@anarazel.de
>> [axboe: minor style fixup]
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  io_uring/io_uring.c |   15 +++++++++++++--
>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2575,6 +2575,8 @@ int io_run_task_work_sig(struct io_ring_
>>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>  					  struct io_wait_queue *iowq)
>>  {
>> +	int token, ret;
>> +
>>  	if (unlikely(READ_ONCE(ctx->check_cq)))
>>  		return 1;
>>  	if (unlikely(!llist_empty(&ctx->work_llist)))
>> @@ -2585,11 +2587,20 @@ static inline int io_cqring_wait_schedul
>>  		return -EINTR;
>>  	if (unlikely(io_should_wake(iowq)))
>>  		return 0;
>> +
>> +	/*
>> +	 * Use io_schedule_prepare/finish, so cpufreq can take into account
>> +	 * that the task is waiting for IO - turns out to be important for low
>> +	 * QD IO.
>> +	 */
>> +	token = io_schedule_prepare();
>> +	ret = 0;
>>  	if (iowq->timeout == KTIME_MAX)
>>  		schedule();
>>  	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
>> -		return -ETIME;
>> -	return 0;
>> +		ret = -ETIME;
>> +	io_schedule_finish(token);
>> +	return ret;
>>  }
>>  
>>  /*
> 
> Reportedly, this caused a regression as reported in [1] [2] [3]. Not only v6.4.4 is affected, v6.1.39 is affected too.
> 
> Reverting this commit fixes the issue.
> 
> Please check.
> 
> Thanks.
> 
> [1] https://bbs.archlinux.org/viewtopic.php?id=287343
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=217700
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=217699

Just read the first one, but this is very much expected. It's now just
correctly reflecting that one thread is waiting on IO. IO wait being
100% doesn't mean that one core is running 100% of the time, it just
means it's WAITING on IO 100% of the time.

-- 
Jens Axboe

