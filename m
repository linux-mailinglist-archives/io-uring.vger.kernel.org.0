Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1AB1F1068
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 01:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgFGX0Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 19:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgFGX0X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 19:26:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836A1C061A0E
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 16:26:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z64so7721167pfb.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 16:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yu7tMexgbwrzNKyY2kLJDxlj9LOTKDbq8HJyZBy2mZ8=;
        b=U81sOFh7qtQNFl2cOmKUbLcnkjroX3KxklTR584NIQ+pym3VLgIOy2PZpPBcsWPc3b
         gAgy51lkPc3vwFTH6J7+LjuLyb6l8YZTLk7HLeWfpzNquRWOFCGQWh7dRnjA1qLP/l+S
         QE/Y+jRcprj1Gn3/eO7LK6qsnyJ+LMR9FiuITM8V7uy7QzeMC4SMFZqUqfDn83xsXl3I
         PvhQUxXFRxe1ruviG9lv6jCrNPVVNwxGQkQ0IgtiBTiqli51No+7utFVaJg8qCjmX3wn
         9Q4yzWaAKxgEW0BH1Sb9RjaPKDckuufIg3oZ8bn+M7yJEaqaDW7lte9gZiJXhOQ3h+xM
         gF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yu7tMexgbwrzNKyY2kLJDxlj9LOTKDbq8HJyZBy2mZ8=;
        b=JYTDaD8I+3zZAfH6nah8oBvPTHy6pvRUXnKwu+trTaC87ErksLJ/65I4Pw9zBLaBTE
         JvM9aLYXFTk0p+2p0t0pMmNqG7pJzmYvR+V3fZmnW3ZnEjyr6dDvKcR8TCPQxNAwjt2O
         0yO2oobJ3rHOV1J2qAs5pK3/KFjK5qGJaMxsPmANXydNkYE3zrYZhsXOHjxytjr6kuPp
         5sRdbETE6OxFrfqRb/S+muAd8hCRcWuJEA1wGlfgqHWwvrSbEqa/fUU5el1RHvdn8TDL
         3C5kOe61n/IdJg3/v38R8yJMd5zUhxE0+A25PA1l9EjRwkB94+Szs0l2U1BePdks6JuO
         h9dA==
X-Gm-Message-State: AOAM533yxMk5naZ+K5q4Yd2zFluX207G0+1rrRKwxIyQBmj+oSXnAOzE
        1EIc+tlj5lH85Xh0sLI3M9veeQ==
X-Google-Smtp-Source: ABdhPJy5FTBHIdhRXcSshZ+O5bsu0fd8Z5W7DjVkvE1duevVb6WjgpXhss68n6H/qrvz6o1ZL0Drhw==
X-Received: by 2002:a65:614b:: with SMTP id o11mr17837938pgv.443.1591572382866;
        Sun, 07 Jun 2020 16:26:22 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f3sm14996968pjw.57.2020.06.07.16.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 16:26:21 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
 <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
 <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e61d4a47-80fc-21f8-7019-bb1e8ab563e9@kernel.dk>
Date:   Sun, 7 Jun 2020 17:26:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/7/20 2:36 PM, Pavel Begunkov wrote:
> On 07/06/2020 18:02, Jens Axboe wrote:
>> On 6/3/20 7:46 AM, Pavel Begunkov wrote:
>>> On 02/06/2020 04:16, Xiaoguang Wang wrote:
>>>> hi Jens, Pavel,
>>>>
>>>> Will you have a look at this V5 version? Or we hold on this patchset, and
>>>> do the refactoring work related io_wq_work firstly.
>>>
>>> It's entirely up to Jens, but frankly, I think it'll bring more bugs than
>>> merits in the current state of things.
>>
>> Well, I'd really like to reduce the overhead where we can, particularly
>> when the overhead just exists to cater to the slow path.
>>
>> Planning on taking the next week off and not do too much, but I'll see
>> if I can get some testing in with the current patches.
>>
> 
> I just think it should not be done at expense of robustness.

Oh I totally agree, which is why I've been holding back. I'm just
saying that we're currently doing a number of semi expensive operations
for slow path setup up front, which is annoying and would be nice NOT
to do.

> e.g. instead of having tons of if's around ->func, we can get rid of
> it and issue everything with io_wq_submit_work(). And there are plenty
> of pros of doing that:
> - freeing some space in io_kiocb (in req.work in particular)
> - removing much of stuff with nice negative diffstat
> - helping this series
> - even safer than now -- can't be screwed with memcpy(req).

Definitely sounds good.

> Extra switch-lookup in io-wq shouldn't even be noticeable considering
> punting overhead. And even though io-wq loses some flexibility, as for
> me that's fine as long as there is only 1 user.

Don't care too much about the extra lookups, it's a very minor cost
compared to the wins.

> And then we can go and fix every other problem until this patch set
> looks good.

I'll take a look at your patch.


-- 
Jens Axboe

