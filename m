Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBF8166A4B
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgBTWXl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:23:41 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46504 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgBTWXl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:23:41 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so2086466pll.13
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RumFsGR3gYL6kz4YuzN4+cCLKS9PyH2jTovYc60DITQ=;
        b=l0OHXqaTYKdm/59wBeB1KieTrnXP5O190HK146dCuRk/EYJxBlFsY5UWXjQDDflrRq
         LOqkNB7uNwOnE2xHLxORhEUgnRyE22RElB4gPe2RDUl1tG+i1J17F+pIcxpsBHVZhCh6
         KNY3sdn4NJkW+5fgu1AapUWU3VBGsbsc1TF1a6OCNAuTOb1A9ipTo2mla3BAvvXy/sSg
         RPS7d/c62k9IyCoxKHoKXjrI5wNDEcOP0KpFwhuxiN4ZtHG20saqCUzks5rtQVEB2/uQ
         OLEaMINNokMAqXJM+0y5PIKAy/ldsiV8guANTlvrJz0oH9p2C2k4uoDuVVzJa39crgP7
         BYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RumFsGR3gYL6kz4YuzN4+cCLKS9PyH2jTovYc60DITQ=;
        b=JJFGvM3HfjoG0v57QDqQ3MRxSiDW8NDHKFQqNLlU3zcAZcyVDBtiZOOH7fBodbfmco
         phAY6vvGeOueTS/FWeURiktXCzmetRISWfa606s60JindJRhuOVsoJRbPjDDdMq998jy
         yuK2uG98rNrezICGxpkNPZVD7TD2IRNMZo4OmgvUl/NOvnuD608RShWLuXAFrwkNrSqW
         Mmzi03Eh0vNL4PL0p11Gd0VMPWzJFQ2aS4dVTtXGcJYRsmYEjE9S1+dYQmpQ9h5LWN/v
         Zo2Nvn6UzRwCOpNyoHn0z4oILBj2NJWgs9mtM3SM+DUpXP6v2s4X290ZZXMIGtpfBZ3P
         xQJw==
X-Gm-Message-State: APjAAAW9Xd2IRVXY0iue8EZqGzCpPU2kroPa80bBbxYHsnnKStx5FGQ4
        Drd//WWdll7STFj4ZOJ4z2NcYRAraSM=
X-Google-Smtp-Source: APXvYqy8EgeriaTPmYOdPSy+4dd1a6CNujmjt243BnV2Ntx1t2eyZ2sFe8QtSwe3q3bLc462IYV+TA==
X-Received: by 2002:a17:90a:8806:: with SMTP id s6mr5732240pjn.141.1582237420748;
        Thu, 20 Feb 2020 14:23:40 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id k4sm582775pfg.40.2020.02.20.14.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:23:39 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
Message-ID: <67a62039-0cb0-b5b2-d7f8-fade901c59f4@kernel.dk>
Date:   Thu, 20 Feb 2020 14:23:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 3:14 PM, Jens Axboe wrote:
>>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>
>>>         list_del_init(&poll->wait.entry);
>>>
>> [...]
>>> +       tsk = req->task;
>>> +       req->result = mask;
>>> +       init_task_work(&req->sched_work, io_poll_task_func);
>>> +       sched_work_add(tsk, &req->sched_work);
>>
>> Doesn't this have to check the return value?
> 
> Trying to think if we can get here with TASK_EXITING, but probably safer
> to just handle it in any case. I'll add that.

Double checked this one, and I think it's good as-is, but needs a
comment. If the sched_work_add() fails, then the work item is still in
the poll hash on the ctx. That work is canceled on exit.

-- 
Jens Axboe

