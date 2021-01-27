Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF98E305702
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 10:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhA0JbA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 04:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbhA0J1J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 04:27:09 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A98BC061574
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 01:25:13 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f1so1529593edr.12
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 01:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SuFETdFWx5QajphBdSNfdkbidsDd9Mqmte5jL7d8G0c=;
        b=kJG3FcrBPLOnV18c0qcFRO9W7up5yo9/Cq/5BDUE1+DvHcVRhZQom6uJmyNtesGGoo
         FaKSgvYQyzQ5r1LhtBzyiVD2FX4pEapbweWvhEpkQZRsCezqnorGIcxG/fnQuEIBTJqF
         xwjqbFMD/d76myV0QjTRE/3Nr2UCFGVOLpOESo6T1hvqoYQ4tHmFrHW73/8Zc6QM5tsx
         RI7me3a73bwblkRSLk9iTZrBiaBrokJ7JnBGcTVFR2SN6Ojzlr3OardGmLzki8A0bn4e
         u4uJ0sc1DvPk7GCWLwDmFJUXtB9ef9n8VooDtiXUNrXXs8CjWxP66uhMvJBmbTwR58JQ
         2txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuFETdFWx5QajphBdSNfdkbidsDd9Mqmte5jL7d8G0c=;
        b=M/r4fFcwhePjDZln3549hz2UjtYMrIymFPdRDmXbCS9rbBu7QoyW6GmHiuSTmDe4EZ
         tQw1SuV1uoqoBuaFKF82uEikBsRpadb5OLcRUV5uIBMFwqhgYpVKKUbJzzUwMerteYOE
         +3vfM5CmUVT+f6LMbGzbhn5uv1v/WgGYpOXrFttTt41nPR9PHHBfAaBOmsvO9qHSKwct
         0sEEEDsAdKxPCFcY6ucrniiH69oTPl1IMEk4TbTKpVqg8lSR8DDZTLlBrWzFzhVD5zDP
         FiIJZhyCYymop/PTrIBj17fkxzelPw0jvKgUYwxDMvTtytMYbPkmSI57cfgSCGqGU0JI
         FDdw==
X-Gm-Message-State: AOAM531Gnt7WyXqRQIdUipFdLBhx6bxI+sH8jaU+7xGKkcuX5JWgr4FC
        VmYaoEWIGOJAqCjt1rp+bd2cBOTi6Y0=
X-Google-Smtp-Source: ABdhPJxiwTjVeYfIaUC49ViXHqmMpZLD3XJyJDiSMdjL1vB4/CaV1Stsdvo1qmyM5eF+GaAF3mgbwA==
X-Received: by 2002:aa7:dc0d:: with SMTP id b13mr8221237edu.170.1611739511887;
        Wed, 27 Jan 2021 01:25:11 -0800 (PST)
Received: from [192.168.8.159] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id p16sm878181edw.44.2021.01.27.01.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 01:25:11 -0800 (PST)
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9c4f7eb623ae774f3f17afbc1702749480ee19be.1611703952.git.asml.silence@gmail.com>
 <9c4e03b0-b506-efb6-7ecf-cf290780de6d@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11] io_uring: fix wqe->lock/completion_lock deadlock
Message-ID: <843fb27e-faf2-5a2d-94f5-b0d45d127bc6@gmail.com>
Date:   Wed, 27 Jan 2021 09:21:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9c4e03b0-b506-efb6-7ecf-cf290780de6d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/01/2021 01:52, Joseph Qi wrote:>> Only __io_queue_deferred() calls queue_async_work() while holding
>> ctx->completion_lock, enqueue drained requests via io_req_task_queue()
>> instead.
>>
> We should follow &wqe->lock > &ctx->completion_lock from now on, right?
> I was thinking getting completion_lock first before:(
> 
> Moreover, there are so many locks and no suggested locking order in
> comments, so that it is hard for us to participate in the work.

It's rc5, so that was rather of a "make it fast" kind... I don't like
this ordering, but hopefully the patch doesn't enforce it, and I'd leave
it for 5.11 and prefer to see something else for next releases.

Would be glad to review if take on it. I think it's no good taking a
lock before io_wq_cancel_cb(), but there should be other options. E.g.
split wqe->lock in two.

> 
>> Cc: stable@vger.kernel.org # 5.9+
>> Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks!

-- 
Pavel Begunkov
