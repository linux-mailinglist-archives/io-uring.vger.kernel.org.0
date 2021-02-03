Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D2730D103
	for <lists+io-uring@lfdr.de>; Wed,  3 Feb 2021 02:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhBCBt1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 20:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhBCBtZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 20:49:25 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065C6C061573
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 17:48:45 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m6so15634505pfk.1
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 17:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oWkgd5ZIJhXOiyUxYtB5Mw53O1ZCA8fIuKy1petROIA=;
        b=No6ZjQfv5jzo5oEBRRljN0W0f71v41PIGOMZXtjqEYt1RVeCCjCByVmwCdileIrjkO
         eNjkcFcuugmRJKmipu5+Gvjrh4kz+cKZQ46nN5n4TbvJb0b2Liit1nceFYwYw3+QUmcY
         I4zT0a4hb3vD5USbWhgOuoa34jkfCnD9k+ITzqlpg30FrC4a6MM5HRo6wEHPw2wbDlKA
         ZbKt8aDhG83wfrT84IgtJU0Q+4JLXM5w4BTtBDQ1hqGj54Ts3A1JI/WJj6znSZEjxd/d
         NYh5YpKgHraTRP/canOKhA+qHkMCCwLurwVUmnrgnqTC5bLXBn1JGR84znCh4XWx50Wm
         b6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oWkgd5ZIJhXOiyUxYtB5Mw53O1ZCA8fIuKy1petROIA=;
        b=iCjlT16+N0BIEqQvPYPcwuSMZEcTTE+uYGNB7XoDwUtJYX+JaqSS2gMKuXO5nD4/Me
         IIK6vRCdILNOq2oFEfR8rKPxmNsEZwUjzwqmosJDzHf5eQ9Lnvf5i9ICQcjlvKmhOnga
         1dzP1uJiDUR9QOejttHRO33/z6BWF5NUrzYrDTH8iQH4Vw2Dz+iOQjd9kHdYPTL9CiNq
         24xUq+b6oH7Ju6n3sXq4ognf8lYyZ1D+Jd2q0WAnYuG91ZYfkRgwk+C/yFFHlID6gtng
         xJ4ufNXgFwwBacwTFi4yEdBrAl1pe2lmwQ1ZNDlL/1ZXZQngrnykg1ZPFYxmgu19FvuY
         VqnA==
X-Gm-Message-State: AOAM532yCvwfAQKpf3vdhzIudyBzYu1lpe94JbBVjJFHguouHr9fJxUn
        fnxZAb9M35oA0f/sQatVQ/8uEg==
X-Google-Smtp-Source: ABdhPJyNySl7oJnMPmHkqMUokrQvpo2/sOfhzTTMsLz5tQkItBAqHHC3erS9WsB1WJlQ0dcQWJbD3w==
X-Received: by 2002:a05:6a00:2296:b029:1b6:6972:2f2a with SMTP id f22-20020a056a002296b02901b669722f2amr828193pfe.69.1612316924434;
        Tue, 02 Feb 2021 17:48:44 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x8sm217107pjf.55.2021.02.02.17.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 17:48:43 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix possible deadlock in io_uring_poll
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612295573-221587-1-git-send-email-haoxu@linux.alibaba.com>
 <9d60270f-993b-ba83-29a0-ce6582c383e0@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5f0db9bc-700a-e0f5-a77c-9acfe4e56783@kernel.dk>
Date:   Tue, 2 Feb 2021 18:48:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9d60270f-993b-ba83-29a0-ce6582c383e0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 5:04 PM, Pavel Begunkov wrote:
> On 02/02/2021 19:52, Hao Xu wrote:
>> This might happen if we do epoll_wait on a uring fd while reading/writing
>> the former epoll fd in a sqe in the former uring instance.
>> So let's don't flush cqring overflow list when we fail to get the uring
>> lock. This leads to less accuracy, but is still ok.
> 
> if (io_cqring_events(ctx) || test_bit(0, &ctx->cq_check_overflow))
>         mask |= EPOLLIN | EPOLLRDNORM;
> 
> Instead of flushing. It'd make sense if we define poll as "there might
> be something, go do your peek/wait with overflow checks". Jens, is that
> documented anywhere?

Nope - I actually think that the approach chosen here is pretty good,
it'll force the app to actually check and hence do what it needs to do.

-- 
Jens Axboe

