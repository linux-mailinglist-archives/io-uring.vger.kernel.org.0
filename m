Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554322C91B0
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 23:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgK3WzT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 17:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgK3WzT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 17:55:19 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DACC0613D3
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 14:54:33 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id s63so11001583pgc.8
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 14:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PhcrGpM559y5mlRLo3+VhPtlTYJlHtZu5eLwigi/7kE=;
        b=1JcW2fgfH5u9w008rzy7uuE6JwtNVNDA+aVZjVbTYEDj3vn/Jb4jxMILt/+Mi1nTR6
         fA6Jaj1STDtfvztUod3QLAmkPv4sCzP9vJKgJzlKn+Xx6S3yC3tDZEf8/IYpdYgNoWj9
         m10GM87ZBjuFLyfe14U9oP24iG5KVO5IzjFxPNI+MPWhXAsDX9tDZ2Y6qVenph7jrVfk
         0GnAScXyHZACyRoM451S5WdFYUvHRs3YAU7W5QNt/TWED/2LZKG56i7PYzjgdF839Ahr
         AAZMUY5mhcA90wlovEstvCTs0I89QTTxQn7se6V2Ifszd1dLYaaK3rF/PLn+nBK3AnLn
         8Vrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PhcrGpM559y5mlRLo3+VhPtlTYJlHtZu5eLwigi/7kE=;
        b=kbnj+HExcCA+5f10BXnIh+2FYxcUPmjwMj+drOC0v3A8UJ+ZEW5iAGQaD0vstW++Yc
         Lduc2QumPsV+XhsxhZ0KRwoSNJT41ReMrEmLLmHxCkRQL+gTZn09z/iqhqSw6AIGJz/W
         abM9MRVop3+6YYSDCh40zEqJuOTgd3NBBbivDgBqc4AargZjdgoscr4vb+lfuGcbClmk
         FgAUJZADdJNmtLCzAtgD2p9U3cXxv1iZ8hJ1fjkqJEVzf2KFajxATs1eNSeNc77Au+Oe
         36nQCe3p6JdJcumv0xg2QpF8S8MNzlQhiN4k78EZTw/F95ql+TV+fSdRAsULEl4yMVkG
         LcJw==
X-Gm-Message-State: AOAM53373MVzriUaRFbT/LPMH/8W+V6mHkW0bSntKzrY65w0nDO/wEFt
        mQUoQsZ2HBVK5uk3CRTktS62WnaNNDAyVQ==
X-Google-Smtp-Source: ABdhPJzyTy9ibrEVWLmDYx++o2HeQG0VrVAxq29t07dbXwXeUvRC4aTd0GCR+7KjzvyLDhCetG8aPw==
X-Received: by 2002:aa7:8105:0:b029:18e:c8d9:2c24 with SMTP id b5-20020aa781050000b029018ec8d92c24mr20696575pfi.49.1606776872985;
        Mon, 30 Nov 2020 14:54:32 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f15sm14900pju.49.2020.11.30.14.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 14:54:32 -0800 (PST)
Subject: Re: [PATCH liburing v2 0/2] test timeout updates
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1606763704.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a8e83756-b9d5-51c4-1f98-8e025d252e65@kernel.dk>
Date:   Mon, 30 Nov 2020 15:54:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1606763704.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/30/20 12:17 PM, Pavel Begunkov wrote:
> v2: [1/2] bit 1 for IORING_TIMEOUT_UPDATE
>     [2/2] test sqpoll
> 
> Pavel Begunkov (2):
>   Add timeout update
>   test/timeout: test timeout updates
> 
>  src/include/liburing.h          |   9 ++
>  src/include/liburing/io_uring.h |   1 +
>  test/timeout.c                  | 272 +++++++++++++++++++++++++++++++-
>  3 files changed, 281 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Jens Axboe

