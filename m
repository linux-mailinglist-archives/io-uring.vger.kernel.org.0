Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D5B3EC9D1
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 17:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhHOPGb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhHOPGb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 11:06:31 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7861BC0613CF
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:06:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso28459337pjb.2
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K6dRiWVfqPYEGM0XTEKXwwPFa8TOMfctM2bCbgQM+j8=;
        b=awukKEq7lju7+gP8fp5KAmtuR1zsNlohkntw3H98WvFvJYUmm13lITxVn4boMQFLw2
         PPez7WBS9vEMXXfMKmzeigCCFJWIzjde/O7sYLV2rli9iRICFRo31ZJgy3+ZyHZa/Hcl
         JTSfr9BfZcGEKUNHTU+dLBA1G2NXgUB/6Y0a48HOduIsjTB26zDYNJiTMkN5QGv/eVaZ
         P7czhCYnin2PV0Y4XEN7Y5EYvh5U3AgGooxgzbK5iYMtRh3M99ny07we2LVoSvZOZ4Fr
         KNjUG2NmVt55ENYY5awmmk8+FaIhCanRWEnUSF+LdflMuLyvP1hcjdFtrWMH/yPH1D0o
         Y3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6dRiWVfqPYEGM0XTEKXwwPFa8TOMfctM2bCbgQM+j8=;
        b=NwUx3f1tN1qLuqqZnKMUfCuQkMLZl21cTPLs/YM+mpQijudoVO5z+y3kYfGe0dS1Sm
         kOREm5JB8bPgZUsGJlBsWEK+ZlWAzja9QKmgc4xTi0kC2iQenxAkw/3DilMmsfn4/MQT
         bT/w4JUR6vWzY8T4pRsm0Zf0GR289PXev9jE3yNnMzLSqIor2UulNxXvry+nNnic0T1Z
         G2uDINjVzh9hwpf/WjCOxZz83/lNMNygwtphknfHP6d6klcdmVLfw31taV7FAlqjbjl/
         A4KUH47jkT+r8Wc8UYUOBnDsf2C877DLlUkVo4ufd03dGxdYuZI4ip5TAJVCPDWMOTMz
         vlLw==
X-Gm-Message-State: AOAM530zRgApSDj+u+JJSdwS+AxM+t077b7VaRvevO1ha2+BOzXmJrUP
        QDvvG+O3bsYlXlzwkR6F/h5tRA==
X-Google-Smtp-Source: ABdhPJwf3R7s+OxNSZpue4Hs5WG2pxqKsERxrpJSOdO/N0NS6P3UeDpiQ15qtMcCtC8i3dxqo5aQhQ==
X-Received: by 2002:a17:902:7611:b029:12b:e55e:6ee8 with SMTP id k17-20020a1709027611b029012be55e6ee8mr9816536pll.4.1629039960768;
        Sun, 15 Aug 2021 08:06:00 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id nl9sm6796837pjb.33.2021.08.15.08.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 08:06:00 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost> <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
 <5cf40313-d151-9d10-3ebd-967eb2f53b1f@kernel.dk> <YRiNGTL2Dp/7vNzt@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2bd1600-5649-c4be-d2a9-79c89bae774a@kernel.dk>
Date:   Sun, 15 Aug 2021 09:05:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRiNGTL2Dp/7vNzt@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/21 9:42 PM, Josh Triplett wrote:
> On Sat, Aug 14, 2021 at 05:03:44PM -0600, Jens Axboe wrote:
>> What's the plan in terms of limiting the amount of direct descriptors
>> (for lack of a better word)? That seems like an important aspect that
>> should get sorted out upfront.
> [...]
>> Maybe we have a way to size the direct table, which will consume entries
>> from the same pool that the regular file table does? That would then
>> work both ways, and could potentially just be done dynamically similarly
>> to how we expand the regular file table when we exceed its current size.
> 
> I think we'll want a way to size the direct table regardless, so that
> it's pre-allocated and doesn't need to be resized when an index is used.

But how do you size it then? I can see this being used into the hundreds
of thousands of fds easily, and right now the table is just an array
(though split into segments, avoiding huge allocs).

> Then, we could do one of two equally easy things, depending on what
> policy we want to set:
> 
> - Deduct the full size of the fixed-file table from the allowed number
>   of files the process can have open. So, if RLIMIT_NOFILE is 1048576,
>   and you pre-allocate 1000000 entries in the fixed-file table, you can
>   have no more than 48576 file descriptors open. Stricter, but
>   potentially problematic: a program *might* expect that it can
>   dup2(some_fd, nofile - 1) successfully.
> 
> - Use RLIMIT_NOFILE as the maximum size of the fixed-file table. There's
>   precedent for this: we already use RLIMIT_NOFILE as the maximum number
>   of file descriptors you can have in flight over UNIX sockets.
> 
> I personally would favor the latter; it seems simple and
> straightforward.

I strongly prefer the latter too, and hopefully that's palatable since
the default limits are quite low anyway. And, as you say, it already is
done for inflight fds as well.

-- 
Jens Axboe

