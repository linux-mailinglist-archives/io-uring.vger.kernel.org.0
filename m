Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B03B939A
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 16:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhGAO6o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 10:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhGAO6o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 10:58:44 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCEDC061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 07:56:14 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id m6-20020a9d1d060000b029044e2d8e855eso6761384otm.8
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 07:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=M0bxHcZ/jFkrzT06/I8u1LAbqimEq39/Bd383u1E86c=;
        b=z1PMoWQChonVvDZJmmXsUdy9LIAbpMVtv2x6uxJOACX00oWH4aHvTSrzPzWwl5WMbj
         wwdT4jUSAUp9obj3E7p7xoH3O+g42U8xTBfMLYkIQeNhRcP+ROBhTDJ7shdFPa4afVPW
         Lzu/2wmN9SozYZ1ciV6mg5jYtRwq+n/wjb2YZTcvnpHu329ykyb6lbZtTfVbNtPvMexA
         toUfjeMgiJ1d1TyD6dKIStiNk4O1Z5H4ctCCB8eniU7kAbZd06aCkQEvmtKArN/XRjAj
         TshrREak/FvwnE75MYwoYbBUShvnoAzUGmVIFXoq8K+yNZ60g3mMNAlxcYoFIOC1UimH
         VT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0bxHcZ/jFkrzT06/I8u1LAbqimEq39/Bd383u1E86c=;
        b=b1fIcmB8ea5u3qxFKmMiSEfY+OIqJ8GR5RQK4Lm8F5C/8mOigORZtejgkT6M/w+67z
         WwBbllnWyyPtPdqGv05WnfYYelEQQAYvKqkGZi+qYEqFGenTaMtVKWwRmZriWioVp+Y7
         +BfRuiL3sX/KEkbHO6h5apLRVrrPr50QqHzScJ1Us0HQNvM5p5kqPcHqbAi3cWKbBQXi
         IMw996McHnG9HYi6gKt4B2SkLOj2NBpjHAju5Sip2G0G+HOFrAQMnJZW5kvWWoCmSmLr
         kvrzQ8CbgZTfR8MdZIGV9kdoB+UXBgtAnNmHGkYZ9dExeDAGPVxML7IHcqmEEf+6os4k
         IAeA==
X-Gm-Message-State: AOAM530WhldXJTEUCfXlLVvBDe/xmK3jz1+/cMPpMUOKsXaCRdmvsyce
        hyILcWfFyqZSFyTrGwCzJxxwgRXCaLqMTA==
X-Google-Smtp-Source: ABdhPJymLSig2UJeuxwmKonlZID05OWHp8trHw42DvheakmmZwunebd4+ZqxIE5CbN112tNKhJetVA==
X-Received: by 2002:a05:6830:22c9:: with SMTP id q9mr353280otc.178.1625151373103;
        Thu, 01 Jul 2021 07:56:13 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id o45sm62661ota.59.2021.07.01.07.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 07:56:12 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix exiting io_req_task_work_add leaks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
 <c5284516-def2-eb21-e95d-96aeda167c97@kernel.dk>
 <46a98c79-17ef-1041-b4ff-5b178c06f55d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d013c401-3c51-af46-5091-e7db186e9791@kernel.dk>
Date:   Thu, 1 Jul 2021 08:56:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <46a98c79-17ef-1041-b4ff-5b178c06f55d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/21 8:19 AM, Pavel Begunkov wrote:
> On 7/1/21 2:45 PM, Jens Axboe wrote:
>> On 7/1/21 6:26 AM, Pavel Begunkov wrote:
>>> If one entered io_req_task_work_add() not seeing PF_EXITING, it will set
>>> a ->task_state bit and try task_work_add(), which may fail by that
>>> moment. If that happens the function would try to cancel the request.
>>>
>>> However, in a meanwhile there might come other io_req_task_work_add()
>>> callers, which will see the bit set and leave their requests in the
>>> list, which will never be executed.
>>>
>>> Don't propagate an error, but clear the bit first and then fallback
>>> all requests that we can splice from the list. The callback functions
>>> have to be able to deal with PF_EXITING, so poll and apoll was modified
>>> via changing io_poll_rewait().
>>>
>>> Reported-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> Jens, can you try if it helps with the leak you meantioned? I can't
>>> see it. As with previous, would need to remove the PF_EXITING check,
>>> and should be in theory safe to do.
>>
>> Probably misunderstanding you here, but you already killed the one that
>> patch 3 remove. In any case, I tested this on top of 1+2, and I don't
>> see any leaks at that point.
> 
> I believe removal of the PF_EXITING check yesterday didn't create
> a new bug, but made the one addressed here much more likely to
> happen. And so it fixes it, regardless of PF_EXITING.

That's what it looks like, yes.

> For the PF_EXITING removal, let's postpone it for-next.

Agree, no rush on that one.

-- 
Jens Axboe

