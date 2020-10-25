Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69029832F
	for <lists+io-uring@lfdr.de>; Sun, 25 Oct 2020 19:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418065AbgJYSm4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Oct 2020 14:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418060AbgJYSm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Oct 2020 14:42:56 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82350C061755
        for <io-uring@vger.kernel.org>; Sun, 25 Oct 2020 11:42:54 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r10so3607018plx.3
        for <io-uring@vger.kernel.org>; Sun, 25 Oct 2020 11:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aqgNmMFZrxIKJlNmgtuCAVBzQMDjimfBZ/rcFecxI9Y=;
        b=XK26PuCyRcuvv9pI52HRheKrKPpze6GW4xOf191G7NNYMw472zcAu0E014Q99Ml7/7
         8htmsuyEAwHtv/NZ1syF7UeXtc1m+VbiYM2nNSXnaUh3ZK4LX6l+rWqD2uuFLnIg0inz
         Ro4+Zer/LiHq7quBuqDb21BTdr7diSYG/p7kYSAzdCcgYjXXzeufrN2oFrPGUanwF9SL
         BwqGewakA9/b7GdLt+zCYsMKAF39gIXpG2ibiNem9spmKzHKtQx5izUVAny9nkfZ9Tjb
         AqqEMLWI1Y3tGt72amOYiKJEZn80ww/F2K3L8D0DnLso5q2YozR0hy1WJOVHZAea9c5d
         6YDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqgNmMFZrxIKJlNmgtuCAVBzQMDjimfBZ/rcFecxI9Y=;
        b=GiURvhj9wJF8l+V3fr73mHIX5BVEXKPWdCTKNwfhGn8alWm2uLZRA2tFc0gpWHaQsP
         eD82F7wcmlDbFSFYEa4vKCoe7Oj/5+crvtmBWCltXZdaVkmS6EQeSHiaM2zcGda5H9rP
         q2mP7WLJerzPkDnVjaq9Sv6Y2u/mQbr5KJ6XepbV6fd5C+1trmrtHLlxsuuQ+EFfATtI
         +CL9RaJOe0qCT5wZYkGets9HzX0gYUMjTk5PQ8ddKeg3/DhHyFRlgPiVmr1vPwaoO0mY
         0ldQqy8/c6cBmgQzyFPbKlsm4G1MNxJvnvwVWdOjc7MBKlht41j8XsIt/rHFRCeJuAj1
         +2VA==
X-Gm-Message-State: AOAM533whMO6Bea0cVKqzgTYciYbde4a4T+4Ys/6G37x/yB+BZX/ieuk
        Xtsq4xFb7lilDOSsNhiYWYMUiw==
X-Google-Smtp-Source: ABdhPJx6drJtgGXH9U4dmj++8VW/dckb6tb+lMwsyS9xRsZkIZI6pqpqUoh9jbK4Lf8FxjvSM3iUjw==
X-Received: by 2002:a17:902:eb13:b029:d6:1aa0:32fb with SMTP id l19-20020a170902eb13b02900d61aa032fbmr10102286plb.35.1603651373740;
        Sun, 25 Oct 2020 11:42:53 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z26sm774000pfr.84.2020.10.25.11.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 11:42:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix invalid handler for double apoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <1bf1093730a68f8939bfd7e6747add7af37ad321.1603635991.git.asml.silence@gmail.com>
 <1ea94ec7-d80a-527b-5366-b91815496f4a@kernel.dk>
 <2022677d-6783-468d-6e77-43208a91edba@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <83e9fd0e-9136-0ca7-5eb9-01f8da6bd212@kernel.dk>
Date:   Sun, 25 Oct 2020 12:42:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2022677d-6783-468d-6e77-43208a91edba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/20 10:24 AM, Pavel Begunkov wrote:
> On 25/10/2020 15:53, Jens Axboe wrote:
>> On 10/25/20 8:26 AM, Pavel Begunkov wrote:
>>> io_poll_double_wake() is called for both: poll requests and as apoll
>>> (internal poll to make rw and other requests), hence when it calls
>>> __io_async_wake() it should use a right callback depending on the
>>> current poll type.
>>
>> Can we do something like this instead? Untested...
> 
> It should work, but looks less comprehensible. Though, it'll need

Not sure I agree, with a comment it'd be nicer imho:

/* call appropriate handler for this request type */
poll->wait.func(wait, mode, sync, key);

instead of having to manually dig at the opcode to figure out which one
to use.

-- 
Jens Axboe

