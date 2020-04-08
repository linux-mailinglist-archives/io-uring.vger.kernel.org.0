Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7A11A2A49
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 22:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgDHUZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 16:25:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33180 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgDHUZb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 16:25:31 -0400
Received: by mail-pf1-f194.google.com with SMTP id c138so3618504pfc.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 13:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MFcGEwtnwRVhjCfNVk21MKf7e1z/AWahNMQ4Wb3R5p0=;
        b=F6dF3Hm2nIWQxepsyj6ZNrXDdON9a3H7DIIU98DQvasK2PnNFB8NcOxFj+v6OgztNU
         2Cdn45FYfi32vILvzEqtUPPlL+g7Cq0TTyu+iKpO8QCwUff5KNSEuD4QSClCSIwLBrOX
         BdkQUpBcNHutkHSHyH7nQsWZooR0CIUkNXRSZ+zRUQCzawRqlFXQaZ+udqJnXH0NuPJk
         viHmyVvETWK+gf3M2nrKYLcZ7CTqzj0YiK2Q7rXwK/DcalzHoKexB52RGTmhC1+I3pB3
         ATufEfMrWZxKzKNT4nnAhuXO2nzV5s4GEHVHDyUUHatxutJTPnHB/1YcteDkeMAvi0Jj
         69cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MFcGEwtnwRVhjCfNVk21MKf7e1z/AWahNMQ4Wb3R5p0=;
        b=ci0SzOGvGrDbPsidpGVUGIp8IemFJ8c59+N5CKzcsppJXLNgJBTdHcaS7203mgHDoi
         LQo2RKDAJwgycCE/O+y2YbH7yfchoM0DdsWXp8HAOHRp7aCkdRoMde/wOICj2qiyBRqg
         E8Nzwt5RcCCvZKAqBjui+N/XazPniRPYGSILCt/haRXdivAE3l/GfN2WfE3tbirs16Hr
         8AZM2TNirBLaON4+T0glVMzbgCK16TufWjJjRZ8YLzzIoq0n0UDVJ7cUhNZA3/lCYNzQ
         RVbC2EtqnI335zPm9U986OQyAmnp+zCH29Jn74H3fDzgPwj9U6++is8iuw+070YmWuwf
         4QWA==
X-Gm-Message-State: AGi0Pub+tg+44oq6YNo0aay9MqaNEG4P3By7PbSU1WvvT98jeLy9HrBR
        3K+znJO8Wr5bXnDL808520bHv8Z65jNFow==
X-Google-Smtp-Source: APiQypI9mhxXPnCE4gTECT7F29S2cc4aWL7/W6s33xtp6AlE6hazi+FfDJYxcikjGcWmzfeiYrZrPw==
X-Received: by 2002:a63:6fc6:: with SMTP id k189mr8443616pgc.175.1586377528052;
        Wed, 08 Apr 2020 13:25:28 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::12dd? ([2620:10d:c090:400::5:607f])
        by smtp.gmail.com with ESMTPSA id r189sm16569716pgr.31.2020.04.08.13.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 13:25:27 -0700 (PDT)
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk> <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
 <20200408184049.GA25918@redhat.com>
 <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
 <6d320b43-254d-2d42-cbad-d323f1532e65@kernel.dk>
 <20200408201734.GA21347@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <884c70e0-2ec5-7ae6-7484-2bbbf4aa3e5d@kernel.dk>
Date:   Wed, 8 Apr 2020 13:25:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200408201734.GA21347@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 1:17 PM, Oleg Nesterov wrote:
> On 04/08, Jens Axboe wrote:
>>
>> Here's some more data. I added a WARN_ON_ONCE() for task->flags &
>> PF_EXITING on task_work_add() success, and it triggers with the
>> following backtrace:
> ...
>> which means that we've successfully added the task_work while the
>> process is exiting.
> 
> but this is fine, task_work_add(task) can succeed if task->flags & EXITING.
> 
> task_work_add(task, work) should only fail if this "task" has already passed
> exit_task_work(). Because if this task has already passed exit_task_work(),
> nothing else can flush this work and call work->func().

So the question remains, we basically have this:

A			B
task_work_run(tsk)
			task_work_add(tsk, io_poll_task_func())
process cbs
wait_for_completion()

with the last wait needing to flush the work added on the B side, since
that isn't part of the initial list.

I don't I can fully close that race _without_ re-running task work
there. Could do something ala:

A			B
mark context "dead"
task_work_run(tsk)
			if (context dead)
				task_work_add(helper, io_poll_task_func())
			else
				task_work_add(tsk, io_poll_task_func())
process cbs
wait_for_completion()

which would do the trick, but I still need to flush work after having
marked the context dead.

-- 
Jens Axboe

