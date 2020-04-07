Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF0F1A1070
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 17:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgDGPnP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 11:43:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46049 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgDGPnO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 11:43:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id o26so1892452pgc.12
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 08:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=esbc294qxv0Vy6CQHe0kNgabtIH+vZ4A7k+ZHRl5Hpc=;
        b=rqgVHFFgVw0hHbLJSC55ddRvYuX2r2wmzCdC2aoC3EDd3BWyMhoblDY8YoEDtOgfPj
         vTPXtB7NyLelcZ9I8Eg6OU1WQfSJZlM0fK3SciHPDmnlEeIY5kfFsurV8mYx38+jqJhf
         72UA9tLULNleKa/26+y+vvrSeVCsUk16BtvpyZwPpqlCMdXWmNENa/kIc2cC3QZJj6gT
         2LTyBRNKHRFDy7EK5gnwV8VVDIPZBiyby8uR3SrIKNa4EeIBoRIR280RPMpxkHfmbO17
         lfeQ3591OQIZhwsaT6W5gAayrIXydj1W/LhkP85Jpa6FMOa/BqPrnqTxKYyQZ+VS94bM
         i/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=esbc294qxv0Vy6CQHe0kNgabtIH+vZ4A7k+ZHRl5Hpc=;
        b=EsDMac+xT/ePmZhfc9dXQEQ9Novib5XtReGfYBk8bqERQiVYsj9AJ5SUVZUyAIGRWQ
         G7FxSF7VgyZao3bbBCoyX/WDwltiJrt4QMqPzHUflx7UAjh1s3xCk235cK034H71eVFg
         NjI5F+RRz7mIYcyZueZDvdT2QnOOn4gmbZCwOYT0A8KvXxwF/v+nve8FgyNV9I354MN6
         n8OAjnmbcpNUVDUbl1QIm43O/fYSUuWN48D8js7Bp0Zq7a4CnPdvAyOSvczri7Btr0gS
         1eEKTW1oeWgk9VJHCx1cp6tCkwce4yukO4eNELo0Lizlxm2PQkhLAu++WZxtLk98mItT
         FJzA==
X-Gm-Message-State: AGi0PuYCsdzKrZgGaHkY26LeNkGOlpn9e1i4ulm/FrmVgUIP7SAuZWSQ
        PZQKVAr9i4DcVq9Z4wRpGFU+eA==
X-Google-Smtp-Source: APiQypJlEu7ysTPl+Gka4q1ohYgYomUy8PHscU8QrrKVHGEOAQdXNTfSiE0rKSZJ6dZQjllidThVLg==
X-Received: by 2002:a62:fc07:: with SMTP id e7mr3189444pfh.299.1586274192366;
        Tue, 07 Apr 2020 08:43:12 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id b2sm1905757pjc.6.2020.04.07.08.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:43:11 -0700 (PDT)
Subject: Re: [PATCH 2/4] task_work: don't run task_work if task_work_exited is
 queued
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        viro@zeniv.linux.org.uk
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-3-axboe@kernel.dk>
 <20200407124721.GX20730@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <486fca1e-fb23-d67f-3b92-2a5fd492f143@kernel.dk>
Date:   Tue, 7 Apr 2020 08:43:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407124721.GX20730@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 5:47 AM, Peter Zijlstra wrote:
> 
> You seem to have lost Oleg and Al from the Cc list..

I'll add them for v2, I did point Oleg at it!

> On Mon, Apr 06, 2020 at 01:48:51PM -0600, Jens Axboe wrote:
>> If task_work has already been run on task exit, we don't always know
>> if it's safe to run again. Check for task_work_exited in the
>> task_work_pending() helper. This makes it less fragile in calling
>> from the exit files path, for example.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/task_work.h | 4 +++-
>>  kernel/task_work.c        | 8 ++++----
>>  2 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/task_work.h b/include/linux/task_work.h
>> index 54c911bbf754..24f977a8fc35 100644
>> --- a/include/linux/task_work.h
>> +++ b/include/linux/task_work.h
>> @@ -7,6 +7,8 @@
>>  
>>  typedef void (*task_work_func_t)(struct callback_head *);
>>  
>> +extern struct callback_head task_work_exited;
>> +
>>  static inline void
>>  init_task_work(struct callback_head *twork, task_work_func_t func)
>>  {
>> @@ -19,7 +21,7 @@ void __task_work_run(void);
>>  
>>  static inline bool task_work_pending(void)
>>  {
>> -	return current->task_works;
>> +	return current->task_works && current->task_works != &task_work_exited;
>>  }
> 
> Hurmph..  not sure I like this. It inlines that second condition to
> every caller of task_work_run() even though for pretty much all of them
> this is impossible.

Oleg had the same concern, and I agree with both of you. Would you
prefer it we just leave task_work_run() as:

static inline void task_work_run(void)
{
	if (current->task_works)
		__task_work_run();
}

and then have the io_uring caller do:

	if (current->task_works != &task_work_exited)
		task_work_run();

instead?

-- 
Jens Axboe

