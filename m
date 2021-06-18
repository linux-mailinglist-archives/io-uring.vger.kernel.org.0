Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF8F3ACF3B
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 17:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhFRPiL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 11:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRPiL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 11:38:11 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A11EC061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 08:36:01 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so10092127otl.3
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 08:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2+uHXabS73QwtqxQYP0XOp93mYe6wHNsZFiV4xN0b0w=;
        b=O2MNp178Cwc6NJ+HH/VwbbPSQicoP2fiYtO2xiUx/bU0c9UX0cR5FjBENhE5h4XHJk
         ltZany56tbJO9S+1OulYjFXCki+oLnHISStimrQcc5HidfWd4RsmTi9UjIBo2i3+xDKm
         RXzFIvxnntPyXFyyjcMlbZ0s4UvEbH7O5iIuB6HGROay0AuPuKrLiRzG1muuyeH13GXY
         WztFsZ55SjDJz+WLkMn+7RXXzAnJ/omqDaSBiN5uF8jNbF36qhrZtDHd3Y2XTFoxKIOT
         1k1yvl0HUMjHSYYFkl16ROigW050P6at/SWdn6fdI811M1o2twt0hi4YbM/V+PBn2A2J
         dYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2+uHXabS73QwtqxQYP0XOp93mYe6wHNsZFiV4xN0b0w=;
        b=MP8oFeiYn+20jFu4+us7FkUUK+XZKDrCDGtSa0/FzVKiscWi3VTrNmqHziBTxaPsLj
         wjPNPNZ6bOKPzLmlrOtF8j4nkZ/IrFxNHEhKGE7uT39Ye2Hrx7HvTEYRxbXxf4dbSQoN
         r4AKzgPiQqRqojVkV6BNHBxwC1u9k64m3L/e+TXWmkIJBp7xe0ZL2TNSsSYd+4yMcDUy
         5KV2QUkynvrInmX9bswFPQyd4JgrAZWlQzyr3UQK3IY01Q9z9JJi4FrJlQALQylt7PXb
         Tyi4YdpVG5LDEXh26GhqB0+qQ7ZNt7Yo2B7LE6B+xTkWPz3HR2XhqZzy8CYGL0VXNSoy
         T3WQ==
X-Gm-Message-State: AOAM5322gU3N47o7Rpq7lUQquFuDxotwFm2xJFtcgRJBfgVjRiKd7jHo
        XwRdzhAM/BFNBfXXRL8zdDti8gElB91DLg==
X-Google-Smtp-Source: ABdhPJzAPPgBeP+wbvWE/WNltxl4+mYYwJnSFJBX+rBIdAXfRx2c3bkV71k7aPHDRZWeOHpyTxeEOQ==
X-Received: by 2002:a05:6830:1387:: with SMTP id d7mr10431922otq.61.1624030559208;
        Fri, 18 Jun 2021 08:35:59 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id l28sm2039959otd.66.2021.06.18.08.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 08:35:58 -0700 (PDT)
Subject: Re: [PATCH 12/12] io_uring: improve in tctx_task_work() resubmission
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1623949695.git.asml.silence@gmail.com>
 <1ef72cdac7022adf0cd7ce4bfe3bb5c82a62eb93.1623949695.git.asml.silence@gmail.com>
 <c8a55ff7-6e90-c6df-1f68-3ed1a58da6c5@kernel.dk>
 <507b0fa2-da08-fc77-5a2f-414040740655@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c575464-03db-45a7-d69f-85e08f1d9387@kernel.dk>
Date:   Fri, 18 Jun 2021 09:35:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <507b0fa2-da08-fc77-5a2f-414040740655@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/21 9:33 AM, Pavel Begunkov wrote:
> On 6/18/21 4:23 PM, Jens Axboe wrote:
>> On 6/17/21 11:14 AM, Pavel Begunkov wrote:
>>> If task_state is cleared, io_req_task_work_add() will go the slow path
>>> adding a task_work, setting the task_state, waking up the task and so
>>> on. Not to mention it's expensive. tctx_task_work() first clears the
>>> state and then executes all the work items queued, so if any of them
>>> resubmits or adds new task_work items, it would unnecessarily go through
>>> the slow path of io_req_task_work_add().
>>>
>>> Let's clear the ->task_state at the end. We still have to check
>>> ->task_list for emptiness afterward to synchronise with
>>> io_req_task_work_add(), do that, and set the state back if we're going
>>> to retry, because clearing not-ours task_state on the next iteration
>>> would be buggy.
>>
>> Are we not re-introducing the problem fixed by 1d5f360dd1a3c by swapping
>> these around?
> 
> if (wq_list_empty(&tctx->task_list)) {
> 	clear_bit(0, &tctx->task_state);
> 	if (wq_list_empty(&tctx->task_list))
> 		break;
> 	... // goto repeat
> }

Yeah ok, that should do it.

I've applied the series, thanks.

-- 
Jens Axboe

