Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94B13F297B
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 11:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhHTJub (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 05:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhHTJub (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 05:50:31 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78ADC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 02:49:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id r7so13432020wrs.0
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 02:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KiZtxUyHldT+i9prJUf5PEONb4U7wnOVQmoq1Kx38KU=;
        b=YY+obbZZsRPTrwjH7hJeg/0hwudGqg+3fb20cQwwe02UMvv7tIAbeipN+jZm5Rvtn1
         +6NoO0tej1DURY6cvzIBNA8zkcPo1DUqCgU9Nz7oW08X5NnHBLaIhkH/nC+HCmUKIwt4
         aY/wRgJg1Jsx0EL53nH01WEQk7NLWqHR/sSO1laFmSLZWCtHidjpq1HUrJhSN+UDdQY7
         ZWMtwMoB7uEWuupNCg35nfit12M+dlMMHysFFeBUwA1b+5ww2dTQKPA/yZ4suJXeQCVN
         ZmGp+Ax2DaN1W1FH8dEejE5qsNmdr0plEPanhYQqJ8m0Ec5MTdajfOXBY9hV5Zd7qT6c
         iJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KiZtxUyHldT+i9prJUf5PEONb4U7wnOVQmoq1Kx38KU=;
        b=G2yW5jpg81ew+X82H2bdmlRlSrvZEEbMFTLf4U3CMAnd5a8n6V1JwJ9pZPWFn0AXLz
         9yCeXdefLmwO4aqJ44L9i+ZdZ5eHLv4DQNMzUlgnnUf+aveUaJjkAvMd/f18xMpwAQgS
         eV2sfREZvsNdUsfwpRV+wNS27KYOWxLSK2/Gar1m/CgDq84DB4T8qjkVdVisjCHxL63n
         6F/0VeoyIWrzGsNlrL1nT7ADzp25QQ9XFQk5NTRfbPwUJtxrcrSgpNKdMEfsj8sRmRUt
         QGgNPYSVl0N/DHniOr1EOyEObmH0mEkorqtvWvLzbZdexQ84dF0qwoxYM++pvBOCVb9X
         j13w==
X-Gm-Message-State: AOAM530zZdE6Nt0Hdq3+Fxi78HukksNEIcRoGcy/UBHlGC89r7PJwAUm
        aLc8E+Hgu9cYnUUcT/FS0GYBGg+Wg/k=
X-Google-Smtp-Source: ABdhPJwn+K7Gad4DS8cuVShUBnUomu8SBgAjA3Icho9pAQ1MRk9T1NWxq2ax3O/qwmueigPjDgVY5Q==
X-Received: by 2002:adf:dd4d:: with SMTP id u13mr8571231wrm.324.1629452992146;
        Fri, 20 Aug 2021 02:49:52 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.190])
        by smtp.gmail.com with ESMTPSA id z6sm4844848wmp.1.2021.08.20.02.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 02:49:51 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1629286357.git.asml.silence@gmail.com>
 <8b941516921f72e1a64d58932d671736892d7fff.1629286357.git.asml.silence@gmail.com>
 <a02fcefe-3a55-51fb-9184-6a49596226cf@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/3] io_uring: flush completions for fallbacks
Message-ID: <0fcdffe3-024d-2f0f-78f1-938594f68995@gmail.com>
Date:   Fri, 20 Aug 2021 10:49:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <a02fcefe-3a55-51fb-9184-6a49596226cf@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 10:21 AM, Hao Xu wrote:
> 在 2021/8/18 下午7:42, Pavel Begunkov 写道:
>> io_fallback_req_func() doesn't expect anyone creating inline
>> completions, and no one currently does that. Teach the function to flush
>> completions preparing for further changes.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 3da9f1374612..ba087f395507 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1197,6 +1197,11 @@ static void io_fallback_req_func(struct work_struct *work)
>>       percpu_ref_get(&ctx->refs);
>>       llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
>>           req->io_task_work.func(req);
>> +
>> +    mutex_lock(&ctx->uring_lock);
>> +    if (ctx->submit_state.compl_nr)
>> +        io_submit_flush_completions(ctx);
>> +    mutex_unlock(&ctx->uring_lock);
> why do we protect io_submit_flush_completions() with uring_lock,
> regarding that it is called in original context. Btw, why not
> use ctx_flush_and_put()

The fallback thing is called from a workqueue not the submitter task
context. See delayed_work and so.

Regarding locking, it touches struct io_submit_state, and it's protected by
->uring_lock. In particular we're interested in ->reqs and ->free_list.
FWIW, there is refurbishment going on around submit state, so if proves
useful the locking may change in coming months.

ctx_flush_and_put() could have been used, but simpler to hand code it
and avoid the (always messy) conditional ref grabbing and locking.

-- 
Pavel Begunkov
