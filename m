Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7EA45DC47
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 15:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355668AbhKYO2S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 09:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351733AbhKYO0Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 09:26:16 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A94C0613F7
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:22:34 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id b12so12036898wrh.4
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=7SqGkxnuFsq7W2tLJuQ9EX5Y0Gz3udYcmI1vQUfctq0=;
        b=Ji618ydLnx5liab+4cSo5LxbqKtKDGwtZRB9rwoM3wF/A9GAUx1mOeE9KBTw1FbJ5D
         Y+bY2A3h37JD1A/rKQhNk9/BczGQSfFMA7FAoeWyVgxnxqPIMDBThEqm4oDn4ULGaQ0a
         bf1dUMAheOKFtRIf21ANxohPnDSd7UtJXAxwLU1fOop/EGVfCBu5g9w1v0tbL6Yg4St+
         ks0WOK69hseE8sWPW1CKm/JfgbTNOjtgq0fIdj2n40eGMa0GLTRVtaNbS8X2OJAW1Vzy
         QnX9MClqTGZwSzdFXa+mG5+Bus4VuUYFShLkmBzsW/mlE8Wqa/ekl9exIMQzFx9/e8Ye
         BcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7SqGkxnuFsq7W2tLJuQ9EX5Y0Gz3udYcmI1vQUfctq0=;
        b=Q+fr75FFkGFk8dAQud2QY5tVIBVScTwBu4QRGd6gvUbCBtwiJNWZnstlLmHwmz1Bqz
         GPSJuB1oZeUVAMgjys2BzI860CG5jPP+mFi52rn/jAjEw5VcjziiXTAMv62Lh4wAlSzZ
         JUf8uUh4SLoDZ9SeioeraKEou+CT9h/HnMx+rHeU1cnDwhFfHP+40odJtRb1+DnEOmT3
         bCKgjBci1FslCcwuwX5UCuVonVoGtFCp6WuE6Yu/QiZBqSx60f2f1ab6run/UWHz1qoT
         I+pMGl64LH8e7K97tnYH98cFwFiC4k2JfuJmVjW+T4Sg62P6iqtWfFRm6ID8vqqg67zP
         Nx6g==
X-Gm-Message-State: AOAM5331RtyhGpJugz2haDC7foW4kdGAs9RDx+HXHoo6BwIH0Wkm5ekH
        FOCMrAAdadzNRNmKLGYQF4jGLvR4CoU=
X-Google-Smtp-Source: ABdhPJxyIoECbQMHetXVjjJ5TzAkKazbpYNsDlboVq+kkomcOi+zb+8N4ViK3evwrXU9BJ8hyEZQyg==
X-Received: by 2002:adf:e84e:: with SMTP id d14mr6814868wrn.472.1637850152754;
        Thu, 25 Nov 2021 06:22:32 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id a9sm2965127wrt.66.2021.11.25.06.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 06:22:32 -0800 (PST)
Message-ID: <c11bb4de-7dd0-e125-36c5-1d4367221561@gmail.com>
Date:   Thu, 25 Nov 2021 14:22:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
 <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
 <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
 <9cf9a4a2-bdca-d955-23f5-f77bf0315fb2@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9cf9a4a2-bdca-d955-23f5-f77bf0315fb2@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/25/21 09:35, Hao Xu wrote:
> 在 2021/11/11 上午12:42, Pavel Begunkov 写道:
>> On 11/10/21 16:14, Jens Axboe wrote:
>>> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>>>> It's expensive enough to post an CQE, and there are other
>>>> reasons to want to ignore them, e.g. for link handling and
>>>> it may just be more convenient for the userspace.
>>>>
>>>> Try to cover most of the use cases with one flag. The overhead
>>>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>>>> requests and a bit bloated req_set_fail(), should be bearable.
>>>
>>> I like the idea, one thing I'm struggling with is I think a normal use
>>> case of this would be fast IO where we still need to know if a
>>> completion event has happened, we just don't need to know the details of
>>> it since we already know what those details would be if it ends up in
>>> success.
>>>
>>> How about having a skip counter? That would supposedly also allow drain
>>> to work, and it could be mapped with the other cq parts to allow the app
>>> to see it as well.
>>
>> It doesn't go through expensive io_cqring_ev_posted(), so the userspace
>> can't really wait on it. It can do some linking tricks to alleviate that,
>> but I don't see any new capabilities from the current approach.
>>
>> Also the locking is a problem, I was thinking about it, mainly hoping
>> that I can adjust cq_extra and leave draining, but it didn't appear
>> great to me. AFAIK, it's either an atomic, beating the purpose of the
>> thing.
> For drain requests, we just need to adjust cq_extra:
> if (!skip) fill_cqe;
> else       cq_extra--;
> cq_extra is already protected by completion_lock

Yes, and we don't take the lock in __io_submit_flush_completions()
when not posting.


>> Another option is to split it in two, one counter is kept under
>> ->uring_lock and another under ->completion_lock. But it'll be messy,
>> shifting flushing part of draining to a work-queue for mutex locking,
>> adding yet another bunch of counters that hard to maintain and so.
>>
>> And __io_submit_flush_completions() would also need to go through
>> the request list one extra time to do the accounting, wouldn't
>> want to grow massively inlined io_req_complete_state().

-- 
Pavel Begunkov
