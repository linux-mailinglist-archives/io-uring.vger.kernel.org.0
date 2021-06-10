Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB23A2FDA
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 17:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFJPyl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 11:54:41 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:42538 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhFJPyk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 11:54:40 -0400
Received: by mail-wm1-f52.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso6734018wms.1;
        Thu, 10 Jun 2021 08:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BDfPnO3+j04xZi8QCwuObMJ/ZEkxbsqWl6e/Hz/TDI4=;
        b=koROQkRSCDnRqTw32O5pYKu84xihdvkCbeB1GdEz+REMyZamWAV8V6nE76eIhTqhnd
         YIce0+0cEu/Afkzzzn6+yZaVFgMbkCU9JBJlj6Qfd4jAa1RiTW0dBSANq/V4gJmfwcRX
         X6Ono2ykyBnIKEpgHkVpYl1BUaSJFCA5+nPUbgfkk9SDu5QC6bOmPupRB9XPtW8JHS19
         b1Rju0Dnw2FXcRAnWonLhaWkBF0qV8ohRCW5IRLWJlPMhTCownl91m8xGtZGS5ir8pPe
         wfTHRcAYB2u5PoecCdoCxe5/TngqglLXdn4MBxpQME8ReN2qhp9EB2Ge1GvuNQua64pl
         ffEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BDfPnO3+j04xZi8QCwuObMJ/ZEkxbsqWl6e/Hz/TDI4=;
        b=DSd+FSE4HfKRgTeiIJZ8SiX8J8LWdRuEzZgG+t9og1ISMGKy82bWuPzdSzaiA7xsjD
         EKfnxof/QJN1IGTGel8W8Ocxep3hmcXeqn3Vce04GjGOGXG9LfbNKvmCxNHRpJhVrSFB
         yJfc/vjrz9uf/jj/C1joILFyNBShqntMNJAMLqGPb94r6oeOGOIt1oW/AwSs89L3yaA0
         m4clpiBxPlcq6lrUDqimQe6VnZNS555w/d9zlIpuuoyoekmVqpMs8o/pJHz7qLVlrbkG
         gsQ0S97yh3cHhIw4o6uedRUKCHaD3+NYCfwn4YFG8oq5A05ALAOS4M/+cIjR/2zFGC9k
         BlwQ==
X-Gm-Message-State: AOAM530wybnGosCiVt+9hxdWoZSVKpCxx2IMvsnURO2tdyNIJ18yW4RQ
        hl5FU7+7g4rTH9GgcEthDvNXtpZGJ1fXSA==
X-Google-Smtp-Source: ABdhPJx98lHvYGVe+aYdGGSMYKtK1TmBd2gU9mSpTe/DldviGgat7HullXhrKtmeC9hzunYwYkvxtA==
X-Received: by 2002:a7b:c417:: with SMTP id k23mr15413341wmi.71.1623340291252;
        Thu, 10 Jun 2021 08:51:31 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id w13sm4366985wrc.31.2021.06.10.08.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 08:51:30 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
 <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
 <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
Message-ID: <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
Date:   Thu, 10 Jun 2021 16:51:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/21 4:38 PM, Olivier Langlois wrote:
> On Thu, 2021-06-10 at 10:03 +0100, Pavel Begunkov wrote:
>> On 6/9/21 11:08 PM, Olivier Langlois wrote:
>>> It is quite frequent that when an operation fails and returns
>>> EAGAIN,
>>> the data becomes available between that failure and the call to
>>> vfs_poll() done by io_arm_poll_handler().
>>>
>>> Detecting the situation and reissuing the operation is much faster
>>> than going ahead and push the operation to the io-wq.
>>
>> The poll stuff is not perfect and definitely can be improved,
>> but there are drawbacks, with this one fairness may suffer
>> with higher submit batching and make lat worse for all
>> but one request.
>>
>> I'll get to it and another poll related email later,
>> probably next week.
>>
> Hi Pavel,
> 
> I am looking forward to see the improved solution that you succeed
> coming up with.
> 
> However, I want to bring 1 detail to your attention in case that it
> went unnoticed.
> 
> If io_arm_poll_handler() returns false because vfs_poll() returns a non
> zero value, reissuing the sqe will be attempted at most only 1 time
> because req->flags will have REQ_F_POLLED and on the second time
> io_arm_poll_handler() will be called, it will immediately return false.
> 
> With this detail in mind, I honestly did not think that this would make
> the function unfair for the other requests in a batch submission
> compared to the cost of pushing the request to io-wq that possibly
> includes an io worker thread creation.
> 
> Does this detail can change your verdict?
> If not, I would really be interested to know more about your fairness
> concern.

Right, but it still stalls other requests and IIRC there are people
not liking the syscall already taking too long. Consider
io_req_task_queue(), adds more overhead but will delay execution
to the syscall exit.

In any case, would be great to have numbers, e.g. to see if
io_req_task_queue() is good enough, how often your problem
takes places and how much it gives us.

-- 
Pavel Begunkov
