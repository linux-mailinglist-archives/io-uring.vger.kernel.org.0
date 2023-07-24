Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E4B75FB19
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 17:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjGXPr0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 11:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjGXPrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 11:47:25 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FB4E5A
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 08:47:23 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7748ca56133so36127839f.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690213643; x=1690818443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a2SXCjszCcNvyzagTPBmmTB8ZVmLpsS/Ne8xQ61QXVQ=;
        b=LvsvN3sJTEyyyWOJlfact5mtY0XZUi4lZ17qzGpKD5YVloXaCiTsX3KAaeXXtGhpWn
         r3FqdN0NGgz1e5C5SANi6zOugXBBmbsErWYz6s+9PCQJ3Rxvsh/VjRQNziz1YcOsS83B
         QwA0k9O8j2/FFMWWs2RU6zH0nGqA/exwk+vCyVX18O7IXU2GplNfgT+W2XjbDuhjVEaD
         DUivAMb+tLZCmO2orJ7YPtU2GFBp2MIYzoa1QViJWkAbY5tqRss5wnJJO3nJN2aWoXNJ
         Cg10LI0MhR6/4X/JPwa8xUZ+wwce6fQ/Y+pF3m/VNhiAdxHs8klwMw/jHIUq1KoTkhIU
         7/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690213643; x=1690818443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a2SXCjszCcNvyzagTPBmmTB8ZVmLpsS/Ne8xQ61QXVQ=;
        b=YNCAQtqyJL08lchlg1nRRTdIRxIk9Y7QPaqq8K8sRdmbW0WDdk6Z8ii6feEf+QSrcU
         N4HioBaHmT9w8V05+AMKsvB4tPPY3B67sLQCAg2Z62rkat+tJl45GEFgoCyR6mNXUGO1
         nkOEF7B/Q8YgpGRlPSy81Lhd5dGmzgVZrrSwtUFOXuI1+Xjliy1JgHryYFUhdDGrN34F
         nPZ0W9ukfV2et8G3Kdai3DsYEFZZUoGPXVuaJ5WwoYacaiZ/VNQxYWYeluDJ18c3rCtq
         2mwbe1pvIxZdEMsTiPyGzhITqX2eUpuM38h3vh+ZHTyeoeX2GNjTaJR9zDn7NlKGQf9a
         oamA==
X-Gm-Message-State: ABy/qLarNNn1+Q9PcMqS9LY/FAYuOr2/TfB2z9EgNfod7TgaoFpvItfu
        JL6up1/alKFdcsud6xuP3+KNlA==
X-Google-Smtp-Source: APBJJlEQZcsdjdB1LpnJi4+5q+nQ/Hbb7uF1D1blb0hPZ7O53jf1TRm2UdSfqrVo9m6vUQV7fZ1cPQ==
X-Received: by 2002:a05:6602:4809:b0:77a:ee79:652 with SMTP id ed9-20020a056602480900b0077aee790652mr8087301iob.1.1690213642756;
        Mon, 24 Jul 2023 08:47:22 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g19-20020a056638061300b0042b6a760c31sm3038815jar.28.2023.07.24.08.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 08:47:22 -0700 (PDT)
Message-ID: <11ded843-ac08-2306-ad0f-586978d038b1@kernel.dk>
Date:   Mon, 24 Jul 2023 09:47:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org, Genes Lists <lists@sapience.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>
References: <20230716194949.099592437@linuxfoundation.org>
 <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
 <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
 <2691683.mvXUDI8C0e@natalenko.name>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2691683.mvXUDI8C0e@natalenko.name>
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

On 7/23/23 12:06?PM, Oleksandr Natalenko wrote:
> Hello.
> 
> On ned?le 23. ?ervence 2023 19:43:50 CEST Genes Lists wrote:
>> On 7/23/23 11:31, Jens Axboe wrote:
>> ...
>>> Just read the first one, but this is very much expected. It's now just
>>> correctly reflecting that one thread is waiting on IO. IO wait being
>>> 100% doesn't mean that one core is running 100% of the time, it just
>>> means it's WAITING on IO 100% of the time.
>>>
>>
>> Seems reasonable thank you.
>>
>> Question - do you expect the iowait to stay high for a freshly created 
>> mariadb doing nothing (as far as I can tell anyway) until process 
>> exited? Or Would you think it would drop in this case prior to the 
>> process exiting.
>>
>> For example I tried the following - is the output what you expect?
>>
>> Create a fresh mariab with no databases - monitor the core showing the 
>> iowaits with:
>>
>>     mpstat -P ALL 2 100
>>
>> # rm -f /var/lib/mysql/*
>> # mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
>>
>> # systemctl start mariadb      (iowaits -> 100%) 
>>  
>>
>> # iotop -bo |grep maria        (shows no output, iowait stays 100%)
>>
>> (this persists until mariadb process exits)
>>  
>>
>> # systemctl stop mariadb       (iowait drops to 0%) 
> 
> This is a visible userspace behaviour change with no changes in the
> userspace itself, so we cannot just ignore it. If for some reason this
> is how it should be now, how do we explain it to MariaDB devs to get
> this fixed?

It's not a behavioural change, it's a reporting change. There's no
functionality changing here. That said, I do think we should narrow it a
bit so we're only marked as in iowait if the task waiting has pending
IO. That should still satisfy the initial problem, and it won't flag
iowait on mariadb like cases where they have someone else just
perpetually waiting on requests.

As a side effect, this also removes the flush that wasn't at all
necessary on io_uring.

If folks are able to test the below, that would be appreciated.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 89a611541bc4..f4591b912ea8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2493,11 +2493,20 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static bool current_pending_io(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx)
+		return false;
+	return percpu_counter_read_positive(&tctx->inflight);
+}
+
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
-	int token, ret;
+	int io_wait, ret;
 
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2511,17 +2520,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return 0;
 
 	/*
-	 * Use io_schedule_prepare/finish, so cpufreq can take into account
-	 * that the task is waiting for IO - turns out to be important for low
-	 * QD IO.
+	 * Mark us as being in io_wait if we have pending requests, so cpufreq
+	 * can take into account that the task is waiting for IO - turns out
+	 * to be important for low QD IO.
 	 */
-	token = io_schedule_prepare();
+	io_wait = current->in_iowait;
+	if (current_pending_io())
+		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		ret = -ETIME;
-	io_schedule_finish(token);
+	current->in_iowait = io_wait;
 	return ret;
 }
 

-- 
Jens Axboe

