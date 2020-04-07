Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D08C1A1251
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgDGQ7D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:59:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38936 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgDGQ7D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:59:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id k18so1463898pll.6
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 09:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ulMhPGWGo1ykoMZdQm7q06WdRD3Nje16LrNIvxd9P0w=;
        b=lmhJyjcXmFCAYa419RclDvlp4yUWrZ1h5veQ/FlsLt6FlIjApRgSCk25Bz9l8enGMW
         KL/q63mncHgvTGKjGlmHSFbodckNsg6Nh3Ba0m3Q2La731mZkwYYWx8/JTDkdkUcTAwC
         yWm6MzGxSlKCchU38C8mF4MnSyu8MN9Lk+fTWzY7XVxPP16uiRu31i3FPzJxk5MwHLhb
         UoMQ5FgCT2TN0WhiKzD638EBxZuC3I3c5DKJukLoAW47aWz8Y9rBzkCAU3O0cdY6jGbR
         XgmJtKpt/FDpQDKCWGpbnFHxlUBgxOHcMKwY9NDKa/AX29eIRiMlzl8cCyDkJRSXiPXA
         9xrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ulMhPGWGo1ykoMZdQm7q06WdRD3Nje16LrNIvxd9P0w=;
        b=IrJRObGvxXxBYyqNKC/RusSL5LaMXcrd8fXTtuXwxRd03ZN/6fxdFDpzLSZanFaZ3+
         eCXrTtUw/euKfZr4ATiG3MtPuKN13tUH2uMTTyQNPVcSHdL4dXjtOjFaRi0JBFUA1wGY
         Qp9fYS5fHM456FZaw0wGDbKCiJq1OL6alBqYzKBjYXdM3bp6ixgo6D6XvPqx17YiivxC
         VbtJ+PtxYSUG/JQyjYuyQTT4D0b69lYN/qEDQo4/OGO6W8ckEepngMSbS0g8Gt9l1POm
         z1p55EnHfukQ1umctbFT5ui9IOvtnUaC+y7EgJlH+IJQS5z2m4PKly8cEvhsbbqkN36e
         xapQ==
X-Gm-Message-State: AGi0PuZdE7p8IAlNcRpofvddAaIVXIzBh1azYgrkC+7oX6wWFvqrEd8y
        5Kd81JOq/S2dtXIQadxN4wuHj+zXtYyS/Q==
X-Google-Smtp-Source: APiQypLtV7Smof1kyWjr1JT2qydz2ecKAupTuxQldW9YLVfkE73KTmRiZTxAvXDEaNqDtApRFSxyOg==
X-Received: by 2002:a17:90a:228c:: with SMTP id s12mr321300pjc.68.1586278742831;
        Tue, 07 Apr 2020 09:59:02 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id np4sm2134869pjb.48.2020.04.07.09.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 09:59:02 -0700 (PDT)
Subject: Re: [PATCH 2/4] task_work: don't run task_work if task_work_exited is
 queued
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, peterz@infradead.org
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-3-axboe@kernel.dk> <20200407113927.GB4506@redhat.com>
 <147b85ab-12f0-49f7-900a-a1cb0182a3f1@kernel.dk>
 <20200407161913.GA10846@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ce5fd3f-2f6b-e0da-9db0-26c09c5320a6@kernel.dk>
Date:   Tue, 7 Apr 2020 09:59:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407161913.GA10846@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 9:19 AM, Oleg Nesterov wrote:
> On 04/07, Jens Axboe wrote:
>>
>> On 4/7/20 4:39 AM, Oleg Nesterov wrote:
>>>
>>> IIUC, this is needed for the next change which adds task_work_run() into
>>> io_ring_ctx_wait_and_kill(), right?
>>
>> Right - so you'd rather I localize that check there instead? Can certainly
>> do that.
> 
> I am still not sure we need this check at all... probably this is because
> I don't understand the problem.

Probably because I'm not explaining it very well... Let me try. io_uring
uses the task_work to handle completion of poll requests. Either an
explicit poll, or one done implicitly because someone did a recv/send
(or whatever) on a socket that wasn't ready. When we get the poll
waitqueue callback, we queue up task_work to handle the completion of
it.

These can come in at any time, obviously, as space or data becomes
available. If the task is exiting, our task_work_add() fails, and we
queue with someone else. But there seems to be a case where it does get
queued locally, and then io_uring doesn't know if it's safe to run
task_work or not. Sometimes that manifests itself in hitting the RIP ==
0 case that I included here. With the work_pending && work != exit_work
in place, it works fine.

>>> could you explain how the exiting can call io_ring_ctx_wait_and_kill()
>>> after it passed exit_task_work() ?
>>
>> Sure, here's a trace where it happens:
> 
> but this task has not passed exit_task_work(),

But it's definitely hitting callback->func == NULL, which is the
exit_work. So if it's not from past exit_task_work(), where is it from?

> 
>>  __task_work_run+0x66/0xa0
>>  io_ring_ctx_wait_and_kill+0x14e/0x3c0
>>  io_uring_release+0x1c/0x20
>>  __fput+0xaa/0x200
>>  __task_work_run+0x66/0xa0
>>  do_exit+0x9cf/0xb40
> 
> So task_work_run() is called recursively from
> exit_task_work()->task_work_run().  See my another email, this is
> wrong with or without this series. And that is why I think
> task_work_run() hits work_exited.

I see your newer email on this, I'll go read it.

> Could you explain why io_ring_ctx_wait_and_kill() needs
> task_work_run() ?

Hopefully the above helped! If I'm way off somehow, cluebat away.

-- 
Jens Axboe

