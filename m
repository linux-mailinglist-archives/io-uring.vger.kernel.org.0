Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D860387B61
	for <lists+io-uring@lfdr.de>; Tue, 18 May 2021 16:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhEROlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 May 2021 10:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbhEROk6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 May 2021 10:40:58 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C667BC06138F
        for <io-uring@vger.kernel.org>; Tue, 18 May 2021 07:39:39 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t206so5597330wmf.0
        for <io-uring@vger.kernel.org>; Tue, 18 May 2021 07:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3v4f5tA9Od6WJ2nn8bVzZo72cAQxgdQtC8rgVSrK56s=;
        b=Px4EzM4gD0lP9hiKi2RdibCuu9T6KRoCnBqy1VacErL96GP2mp8ZxzX2AxfQzLGPf0
         LIvfjqg1o8iX8Ftd7RlXezV66IpQ7EsdVe6ZpVrWq/yLVmu3V/y+04Jns0qU5iw3EX0F
         M49/my5aizqmFyQSIKborh5V1Ks65W47eTr51EhFuxOvmgZ7r2kJhQgQnS4nyQXLaTAR
         fZy08uBn9e7ZDwVEmm7dbTrEXooiR7+R0yLuLvaeWzyjxlmSa7JVCCH1ZpLshuGjvLWF
         sPoSN9KrgjUD+69Ccxbl14b038vSxjHt+e6kViIwNVD9h05O8D6Fbgl0yeuy7uYLh4cd
         pmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3v4f5tA9Od6WJ2nn8bVzZo72cAQxgdQtC8rgVSrK56s=;
        b=XNKsGEDnT3KJ44be73H2FU3LjhhiMWKFfElFvQsnpHHG5qUpXrQ0nXvKDypw8SC+AW
         hwZIvM7j+anMtq2cs7E+gDabYZJzo1hPwS3K+627Qf6EM6cRR9caf03BA/JEGhn8gyOm
         5Wk5S2iZbKWcdeLo4YwjfdfhVCW25UPzuHw9LCWloJsHtM/nsktA4c+K3KuDDwKX9A4l
         Ju+FNbjfsx9S/2lSclWK2Fr/0zKDiiEtig0kdtJiqSIcJfXTapubs6FhdI1gF3Qliubl
         ok5ijlQt1UTm+EPP97h9WIGssb27ex2MAzg9e8GHE90npcHGXrGGkT5b6ch5l0REUIdx
         hz5g==
X-Gm-Message-State: AOAM531obStGS3jXNkTYJaStpJ9+/NfQlnBS9NYkl2k4Z+iy7DnfJnJ3
        pyZpDBsablzMDBMpCfm8W8YNwZVBHE68Sw==
X-Google-Smtp-Source: ABdhPJxaRTy4ejeFE0T1DeVRrgHFJ/GowFe9x/Z/HjqDiLxaeWfqGTp8jqyKRzTYrLtpR1hc75DRlg==
X-Received: by 2002:a1c:6a08:: with SMTP id f8mr2811420wmc.143.1621348778553;
        Tue, 18 May 2021 07:39:38 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2810? ([2620:10d:c092:600::2:d9b4])
        by smtp.gmail.com with ESMTPSA id z12sm139591wmc.5.2021.05.18.07.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 07:39:38 -0700 (PDT)
To:     Christian Dietrich <stettberger@dokucode.de>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
 <s7bmttssyl4.fsf@dokucode.de>
 <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
 <s7bv985te4l.fsf@dokucode.de>
 <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
 <s7bpmy5pcc3.fsf@dokucode.de> <s7bbl9pp39g.fsf@dokucode.de>
 <c45d633e-1278-1dcb-0d59-f0886abc3e60@gmail.com>
 <s7beeec8ah0.fsf@dokucode.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC] Programming model for io_uring + eBPF
Message-ID: <fd68fd2d-3816-e326-8016-b9d5c5c429ed@gmail.com>
Date:   Tue, 18 May 2021 15:39:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <s7beeec8ah0.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/12/21 12:20 PM, Christian Dietrich wrote:
> Pavel Begunkov <asml.silence@gmail.com> [07. May 2021]:
> 
>>> The following SQE would become: Append this SQE to the SQE-link chain
>>> with the name '1'. If the link chain has completed, start a new one.
>>> Thereby, the user could add an SQE to an existing link chain, even other
>>> SQEs are already submitted.
>>>
>>>>     sqe->flags |= IOSQE_SYNCHRONIZE;
>>>>     sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.
>>>
>>> Implementation wise, we would hold a pointer to the last element of the
>>> implicitly generated link chain.
>>
>> It will be in the common path hurting performance for those not using
>> it, and with no clear benefit that can't be implemented in userspace.
>> And io_uring is thin enough for all those extra ifs to affect end
>> performance.
>>
>> Let's consider if we run out of userspace options.
> 
> So summarize my proposal: I want io_uring to support implicit
> synchronization by sequentialization at submit time. Doing this would
> avoid the overheads of locking (and potentially sleeping).
> 
> So the problem that I see with a userspace solution is the following:
> If I want to sequentialize an SQE with another SQE that was submitted
> waaaaaay earlier, the usual IOSQE_IO_LINK cannot be used as I cannot the
> the link flag of that already submitted SQE. Therefore, I would have to
> wait in userspace for the CQE and submit my second SQE lateron.
> 
> Especially if the goal is to remain in Kernelspace as long as possible
> via eBPF-SQEs this is not optimal.
> 
>> Such things go really horribly with performant APIs as io_uring, even
>> if not used. Just see IOSQE_IO_DRAIN, it maybe almost never used but
>> still in the hot path.
> 
> If we extend the semantic of IOSEQ_IO_LINK instead of introducing a new
> flag, we should be able to limit the problem, or?
> 
> - With synchronize_group=0, the usual link-the-next SQE semantic could
>   remain.
> - While synchronize_group!=0 could expose the described synchronization
>   semantic.
> 
> Thereby, the overhead is at least hidden behind the existing check for
> IOSEQ_IO_LINK, which is there anyway. Do you consider IOSQE_IO_LINK=1
> part of the hot path?

Let's clarify in case I misunderstood you. In a snippet below, should
it serialise execution of sqe1 and sqe2, so they don't run
concurrently? Once request is submitted we don't keep an explicit
reference to it, and it's hard and unreliably trying to find it, so
would not really be "submission" time, but would require additional
locking:

1) either on completion of a request it looks up its group, but
then submission should do +1 spinlock to keep e.g. a list for each
group.
2) or try to find a running request and append to its linked list,
but that won't work.
3) or do some other magic, but all options would rather be far from
free.

If it shouldn't serialise it this case, then I don't see much
difference with IOSEQ_IO_LINK.

prep_sqe1(group=1);
submit();
prep_sqe2(group=1);
submit();

-- 
Pavel Begunkov
