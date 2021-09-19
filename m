Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0388E410B72
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 14:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhISMGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Sep 2021 08:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhISMGN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Sep 2021 08:06:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E627EC061574
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 05:04:47 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d21so23473005wra.12
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 05:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JHuxHMlOEGbwFmK1fd+3CPFdcvQmfGn79W7eRHKQ2+E=;
        b=NyKaouqv9WlHLw1w4Qe1R2DnBq1mXhpHPX0QR3gdozJiczILwYF6559DfgQDBUGD8I
         jQQnFaIlysqgK1JNsIPLAyt0JnadUGVb/kJ2grp2JPSzq4gGBAZk4P59hhcDvAn8YYz8
         Ce78/4YN0qZhZWCxs6s9sioPs1MUadGQfi9gVic8/UcEpTkzdcDfVC1YMp9PefwnY7R3
         jX+hvzV0knTgr4SZyR7btQPL3ov7H6eZtld8CQS9C2s4o2QTxG7rQuUitkt7AttQtLcQ
         rDzUnEUkjTIu4hBEEHWmBBR4woz+jVmvW12X58h2sxF0jGU2Lr4O7l9ay5QPo3+J6lpg
         XDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JHuxHMlOEGbwFmK1fd+3CPFdcvQmfGn79W7eRHKQ2+E=;
        b=AVIiyM3ZJyRMqhLwtvsO69Pn5UzNyDRCcDABHd3wMcOxKNK6fHj4uUj0xIRBYRGgpI
         a4IcE9Qy3MxkOH0c3SrPY5sCLOPEg+6c6tHP0/RLAkEvu2R1oZhdralC9kn4hl+0MEQp
         AtJTnzQEuRvqEjhzm/UcNTk3DrAepZaWQqFK1HQdo40jN9LW2/wNuBdp9XZ0I2OPd7yU
         sbDI/Yogq7eb4HcZqUfPP7oxetms03xvUbdkfmIuT2nwoJ8FhZVv7KSpZHbBq3c2jRLm
         UqA4ndWqe+1MEfqb8Va26GiDRZyu/Zq+2Rdk83yWxu9a0I4wXTxmyiMtipkPGZStcy0m
         XyUg==
X-Gm-Message-State: AOAM530wOPyi2IRIlHIiizzIChzRFqRalXJIfeyAdAnppEKdkKAwGatW
        sAiDAFNj+duyTbhFCczHVsc=
X-Google-Smtp-Source: ABdhPJx8s/j8nac9cSK2a3P6qCEmNZuE0R/D79UIZgh+cyesFn4lNlcjmwQIt4mCTfe8jaTMgsj1mQ==
X-Received: by 2002:adf:e40b:: with SMTP id g11mr22764777wrm.313.1632053086524;
        Sun, 19 Sep 2021 05:04:46 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.22])
        by smtp.gmail.com with ESMTPSA id d9sm15840802wrb.36.2021.09.19.05.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 05:04:46 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
 <20210917193820.224671-6-haoxu@linux.alibaba.com>
 <fe379c0c-0eeb-6412-ffd7-69be2746745f@gmail.com>
 <2ab8efb5-7927-cf1a-a1af-f4955f7d94f6@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 5/5] io_uring: leverage completion cache for poll requests
Message-ID: <166dc3e2-6eea-8354-ef12-07df49ec5aaf@gmail.com>
Date:   Sun, 19 Sep 2021 13:04:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2ab8efb5-7927-cf1a-a1af-f4955f7d94f6@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 7:11 AM, Hao Xu wrote:
> 在 2021/9/18 上午4:39, Pavel Begunkov 写道:
>> On 9/17/21 8:38 PM, Hao Xu wrote:
>>> Leverage completion cache to handle completions of poll requests in a
>>> batch.
>>> Good thing is we save compl_nr - 1 completion_lock and
>>> io_cqring_ev_posted.
>>> Bad thing is compl_nr extra ifs in flush_completion.
>>
>> It does something really wrong breaking all abstractions, we can't go
>> with this. Can we have one of those below?
>> - __io_req_complete(issue_flags), forwarding issue_flags from above
>> - or maybe io_req_task_complete(), if we're in tw
> Make sense. we may need to remove io_clean_op logic in

> io_req_complete_state(), multishot reqs shouldn't do it, and it's ok for
> normal reqs since we do it later in __io_submit_flush_completions->
> io_req_free_batch->io_dismantle_req->io_clean_op, correct me if I'm
> wrong.

req->compl.cflags is in the first 64B, i.e. aliased with req->rw and
others. We need to clean everything left in there before using the
space, that's what io_clean_op() there is for

-- 
Pavel Begunkov
