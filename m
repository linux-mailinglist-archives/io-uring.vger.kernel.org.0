Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6077161985
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 19:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgBQSQZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 13:16:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39470 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729850AbgBQSQZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 13:16:25 -0500
Received: by mail-pg1-f196.google.com with SMTP id j15so9620545pgm.6
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2020 10:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kcrrptdlWegJjZkvsMsUSdJMB1XM1JN0m5gPlVy4a28=;
        b=q+2YRcqeT2wgJ8/R4PjYlFTFWL8n0yllNC6hWObjm6mhYG2pCrJs6hYW/o9dO/CZ7q
         3YO2mk5UkpA/M7ZsIG3GPO/wDG3A/LN1PEhWFI794PxpDnbaHiMFwjTQhK0/DZtP1H66
         ngxDeE3zOIYnplNsn+UiPCnckOqnZbreQElhXQ7NQcOzzkLA7rTU8pp+4kzIw2uMw/5V
         rJ/V0GuLpEUa6+5VvHbaw++ACcIw2ohhJOR2l7GEIAF9iYolgSn6ZnTV+xJk0yyijrjt
         Njb16GUhW/tLSRaPU5sqiJq2uk+oxgMDJdKP38owooXh7CFkpVwJsMDDD9TbXNhmZV2b
         OsBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kcrrptdlWegJjZkvsMsUSdJMB1XM1JN0m5gPlVy4a28=;
        b=DkbUbvEEeoIln8G9rY/UiPAG8JWlM4euWAk6vOKS3XwZtVVwCd4OeMji8hCtB41xjH
         qvFefXbxAJeYc/cGTc8sKtwg3PHx3T4jQc+6Q7ZX0bfSG8QPRF+tUFYFzEt4VbswVymb
         gUDFDwGAjND3K73D7/bAiH7PuEdxRPlgaVcBP6ydki8lhsybZqHMFx5ZG3OMs0gc5MZO
         gGMqqoUlHzh9s3QgCdJnbwKPPVmXtfNhn6liZVXymQ+s5TAoVuRkPSfsTuyLZeqgzaj0
         x53UQ2TcKz4u+4gmRNXeVOXe2IcP3A/7VXVfwjnUgI/Yfc43eb3ptlqOrmjEQI0WbdVe
         /qbw==
X-Gm-Message-State: APjAAAVl+SkFQk1y85QNs90IkUBtCtXvscSRZ3dINEPvhYXdh9FXKiu4
        +vDViIXsaedlCQPu3zw2YqCt8dLJzck=
X-Google-Smtp-Source: APXvYqw3cgbn+OYImXn6SsQBJheyiDxgqHGhJNmpC8UMP6Sm3seQ9hxvJMzZbucsLE0hBmadqNgBOw==
X-Received: by 2002:aa7:9a86:: with SMTP id w6mr18240419pfi.59.1581963382998;
        Mon, 17 Feb 2020 10:16:22 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6957:8f58:7996:df24? ([2605:e000:100e:8c61:6957:8f58:7996:df24])
        by smtp.gmail.com with ESMTPSA id t11sm1604195pgi.15.2020.02.17.10.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 10:16:22 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
Date:   Mon, 17 Feb 2020 10:16:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200217174610.GU14897@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/20 10:46 AM, Peter Zijlstra wrote:
> On Mon, Feb 17, 2020 at 09:16:34AM -0800, Jens Axboe wrote:
>> OK, did the conversion, and it turned out pretty trivial, and reduces my
>> lines as well since I don't have to manage the list side. See here:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll
>>
>> Three small prep patches:
>>
>> sched: move io-wq/workqueue worker sched in/out into helpers
>> kernel: abstract out task work helpers
>> sched: add a sched_work list
> 
> The __task_work_add() thing should loose the set_notify_resume() thing,
> that is very much task_work specific. Task_work, works off of
> TIF_NOTIFY_RESUME on return-to-user. We really don't want that set for
> the sched_work stuff.

Done, killed it from the generic helper.

I also made a tweak to work_exited, as I'll need that for the sched work.

> I've not looked too hard at the rest, I need to run to the Dojo, should
> have some time laster tonight, otherwise tomorrow ;-)

Enjoy! Thanks again for taking a look. I've pushed out the update:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll


-- 
Jens Axboe

