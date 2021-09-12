Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E083408205
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 00:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhILWSI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 18:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbhILWSH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 18:18:07 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF53C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 15:16:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id kt8so16654913ejb.13
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 15:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FhdCbu2msu4p9C58f/byhf7f2gCrEHsX4UK3yKPDFWw=;
        b=gPI9iavAOursuU/pfusP9jOcrnn+ZtxNNy9HgS97RL9hhZcEyydqkAW+aEEQjYjaRd
         okX6z7CSQBzALoNa04e/k6fTC8ndpxygwXWivkFZEeyWdhyReRKJR4XR7/7Qvq4jLcro
         4o8Yi2KW1jQqLpiz4tpcKvBzAZzbIuSMnSfbZQMc7B8JNWSKIshlkksdu3qFfZv7gUon
         j3rs29rJ1hkWBOcfsxQWj3s+sRaE1E+QtV00FDMht2wYRnKp2dY0LWPLGeiA8x04dWuv
         eey2y8QZu4gXq4AKPz0J9SCgboYqQaOkqOhmc+tggFbypT0qBM1tLpZoQKjconJN2KHN
         qGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FhdCbu2msu4p9C58f/byhf7f2gCrEHsX4UK3yKPDFWw=;
        b=dqt3bIWutbRnDrg9pFx3cBrnW9REaNU2apJgnmTs5OetkSgjn3xMvrrFAtxe4KvyPJ
         MxK2uEoEjVZ2ByTjCa9Db/8zGa3B4db/HCc29Tzicpt7LMNCXOE1HqC6LoPpzqZ5kFY0
         9jUROMjlAJno/TOAKczOXHaACwUb9SyHfubP1O7DYv7BvVWTOo7QqJqFg8imzIth2CYA
         V4KmO9TmwDJ/RhHKkzpWcMV3rTxS8jCoeFGMW/DZISPvXQoPYDUjoESox1w1xhRAQaKQ
         LHGn53OTSzPmL1UAjQaEPf3ru9ZFsyR6IkR0jB2LmIy/wRzxnT+P6u71+Ig2o2sWKvQR
         wSBQ==
X-Gm-Message-State: AOAM532KQfk9qjPtstwqLjVlnFHjYcNnF91/8o/keSTmX5J1B64Pg6Dq
        lZvxM+KKw17Ff9ZCjC6dbjUF6PQvhBk=
X-Google-Smtp-Source: ABdhPJzHmSsMulUq4t87FgDyxwNqUjpgO6zQxZ5X8trOFooK2dawcd/yUS8h28+OAwnnNo8+s8jAZA==
X-Received: by 2002:a17:906:d0cd:: with SMTP id bq13mr9633791ejb.66.1631485011418;
        Sun, 12 Sep 2021 15:16:51 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id b13sm2906728edu.27.2021.09.12.15.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 15:16:51 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: don't spinlock when not posting CQEs
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1631367587.git.asml.silence@gmail.com>
 <3a5f0436099b84f71fdc8c9bd9f21842581feaf9.1631367587.git.asml.silence@gmail.com>
 <1cc2816e-bf18-fbb9-b5ed-e8786babc4fc@linux.alibaba.com>
 <ddf1be22-4fce-8e50-851f-d898d1dcc502@gmail.com>
 <37347a03-5475-dd2e-ab58-65adb1aad04f@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <62c8fe6c-2085-4d2f-8217-0ca4d45a5c89@gmail.com>
Date:   Sun, 12 Sep 2021 23:16:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <37347a03-5475-dd2e-ab58-65adb1aad04f@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 7:14 PM, Hao Xu wrote:
> 在 2021/9/12 上午5:10, Pavel Begunkov 写道:
>> On 9/11/21 9:12 PM, Hao Xu wrote:
>>> 在 2021/9/11 下午9:52, Pavel Begunkov 写道:
>>>> When no of queued for the batch completion requests need to post an CQE,
>>>> see IOSQE_CQE_SKIP_SUCCESS, avoid grabbing ->completion_lock and other
>>>> commit/post.
>>
>> It does what it says -- skips CQE posting on success. On failure it'd
>> still generate a completion. I was thinking about IOSQE_SKIP_CQE, but
>> I think it may be confusing.
> I think IOSQE_CQE_SKIP_SUCCESS is clear..but we should do
> req->flags & REQ_F_CQE_SKIP, rather than req->flags & IOSQE_CQE_SKIP_SUCCESS

Surely we should, thanks for looking. I also think I need to add a few
lines on why IOSQE_CQE_SKIP_SUCCESS turns into just REQ_F_CQE_SKIP

-- 
Pavel Begunkov
