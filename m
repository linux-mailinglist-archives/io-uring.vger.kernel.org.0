Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651983F1F1E
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 19:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhHSRaA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 13:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhHSR37 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 13:29:59 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23693C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 10:29:23 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id o185so9440797oih.13
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 10:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=S7vGzwhUEIYMuxyD633hUWAfRTig0+S4dzhj20KGpbc=;
        b=Juy1d/JyFvZRZHRN8/pYI6wbkK6j+iTlBGvO6ZQ2zqAEWG+XiSjLV7RjX5O79rzC7/
         fmqZ3nYQaD4IEWRiR51uqKdvv0EDdcJXtQ1i9FZEmcfLfAaaeQmV18vMUOi1rVjPGG89
         0CnUZcc7M4H0wCJngl+zr9QZwDbmQVTnSI5cLv3VnXYCcCcutdoOZpIQOUG5vWjNSdn7
         6PyxFRU48w75oid+L3TZimPOFWpw4it3MyE4dpuhMEyP7UHHF7iIhA9TWsIUS/ZqeIai
         cQcKoWeTjLWWJZTxfb9VJW+Vp9q5vpO1PVXgSoRfyCuePzdgGCZU0D3Ys4Qbw5jB0ppm
         jxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S7vGzwhUEIYMuxyD633hUWAfRTig0+S4dzhj20KGpbc=;
        b=YV4oViV3j7HnKTrymjiMzqYyG/H8dYubYacm+92VV4wrHx6nIOs5dPpSMFOumVtE/r
         vJJI5tvXBnfoacFGaV19eaOXF5hjrarwUX66a89YPjDUQaLUPPcVNnT+EYcYNQYXpcoQ
         YSP4pc5wk16gn0NRQwuA3TQIMvorryeZS8Oap9Ea4Tw6/Zj5NEijD8R6J5g2YjOqNhKa
         clLLxEOfjKb7T/5ecX7scMmTJZ8OayQBHxWejX4PfJ1gBzxmkPiC5paTVBwtLlWNQbWW
         pTf7PN+jcbxqodqxPys9GHtGuwYsyTHaFIqUitPpf0zWo868QvPqEWj6Jp16NEih9kx8
         pl3Q==
X-Gm-Message-State: AOAM533pn2gVOmP15+w2B3btpQYAq/My5yCV93i8Uzt4sHPqkkGbMWlV
        sl79ESaMMtrWU9oG+SrOINQt3GFrNUc2G3XD
X-Google-Smtp-Source: ABdhPJw4jA/LcGVlj83TkcknCL+u2rq+elyonm4j77CcnKfM8wjwL+srsDrfayKJhCuutPP82dMtBw==
X-Received: by 2002:a05:6808:494:: with SMTP id z20mr3435166oid.103.1629394162317;
        Thu, 19 Aug 2021 10:29:22 -0700 (PDT)
Received: from [192.168.1.170] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i27sm887911ots.12.2021.08.19.10.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 10:29:22 -0700 (PDT)
Subject: Re: [PATCH] io_uring: remove PF_EXITING checking in io_poll_rewait()
To:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
References: <0d53b4d3-b388-bd82-05a6-d4815aafff49@kernel.dk>
 <71755898-060a-6975-88b8-164fc3fff366@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2c01919-d8c8-3750-c926-13fbee14eed7@kernel.dk>
Date:   Thu, 19 Aug 2021 11:29:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <71755898-060a-6975-88b8-164fc3fff366@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 11:26 AM, Hao Xu wrote:
> 在 2021/8/19 下午11:48, Jens Axboe 写道:
>> We have two checks of task->flags & PF_EXITING left:
>>
>> 1) In io_req_task_submit(), which is called in task_work and hence always
>>     in the context of the original task. That means that
>>     req->task == current, and hence checking ->flags is totally fine.
>>
>> 2) In io_poll_rewait(), where we need to stop re-arming poll to prevent
>>     it interfering with cancelation. Here, req->task is not necessarily
>>     current, and hence the check is racy. Use the ctx refs state instead
>>     to check if we need to cancel this request or not.
> Hi Jens,
> I saw cases that io_req_task_submit() and io_poll_rewait() in one
> function, why one is safe and the other one not? btw, it seems both two
> executes in task_work context..and task_work_add() may fail and then
> work goes to system_wq, is that case safe?

io_req_task_submit() is guaranteed to be run in the task that is req->task,
io_poll_rewait() is not. The latter can get called from eg the poll
waitqueue handling, which is not run from the task in question.

-- 
Jens Axboe

