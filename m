Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895B8407F62
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhILSZt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILSZs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:25:48 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9B1C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:24:34 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id a13so9178079iol.5
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2w+/prwDeG2WH857IIDqwMy+qCgr43LHjyGYvs8ptTQ=;
        b=F5F4HecrCA4j2VA5tJRuvZaQA9I+pA8YYxJAYUbbSnjwoyKhlM5B5lzay/JXAOruSy
         B+ToeZnJFBH1O8RvKK5dE4F8c+9oHax7NkAymalGwTP+wJln/nrZOv63WzHGOxDH4Cde
         C2ZVvhIY5ZF90/4wjZ2opfxpEeRwSIQUXkhz/F4vWMSWXnAQ/Jy5anE3+mwmEVXeisU0
         YH+wf7B2VAB/EJLD3xQa2ILG9JkhKXZwulya0+MiMihfIJCDfrAeRny9+tJ9Geyv3iM9
         wGhSt39awtjKOmwLPobigAA/Ez1FbHtNBNfsHZrKMUikufLvrA2Wu+hiLtMNdL/4+2DN
         nt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2w+/prwDeG2WH857IIDqwMy+qCgr43LHjyGYvs8ptTQ=;
        b=bCNlBLAnRIPW/eKKG4oNqAvA/kgU4quKMfNv5DDh/wiHbFAJ2L1mtyNPUBO7tZJudj
         PdOfGhw0BHjweT+UbCr5URJfzYZjBL9ZveNAPpnudJ9JB1s9WSF3r+6Vxx7GFI1HIOLG
         Xsi6WdioejIYc/JBpMNBqgsyGCOg9rSASEHBVFS4Jyy6pFRpAcQCOSc5O7e3rwyTRlnn
         fEH65BxHzBbcy/dqds4Von7DSzj7WIb7Q93gzQufIaL1hwZL/Vhswsy/gaRynEXRFFmg
         kAotXet6MVSH2+RJgHZpVXeW/lINRyefvOlsXK+8HXRyrtI5Rx9+5rws3uGObnPz3E4x
         tNjA==
X-Gm-Message-State: AOAM5302DENvmJSD51frI6KBzH9K8Nftvw/HKvPR3KnLGXNVdz9vfK3k
        hj9V12Gkn6Xt3PkjmngpPJlhsA==
X-Google-Smtp-Source: ABdhPJz0gLtIsdd0dWKBayLxB5pzr3BzCqrJXFrVvvi232K82jx0GWTxUxUBw58Y1Z0zNrwzotIdvw==
X-Received: by 2002:a02:7813:: with SMTP id p19mr3710156jac.38.1631471073438;
        Sun, 12 Sep 2021 11:24:33 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p11sm1088093ilh.38.2021.09.12.11.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:24:33 -0700 (PDT)
Subject: Re: io-uring: KASAN failure, presumably
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <2C3AECED-1915-4080-B143-5BA4D76FB5CD@gmail.com>
 <859829f3-ecd0-0c01-21d4-28c17382aa52@kernel.dk>
 <C5C0EB71-B05E-4FE6-871D-900231F8454B@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3c55f383-7574-8519-067d-cdf1a84ee95c@kernel.dk>
Date:   Sun, 12 Sep 2021 12:24:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C5C0EB71-B05E-4FE6-871D-900231F8454B@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 12:21 PM, Nadav Amit wrote:
> 
> 
>> On Sep 12, 2021, at 11:15 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/11/21 8:34 PM, Nadav Amit wrote:
>>> Hello Jens (& Pavel),
>>>
>>> I hope you are having a nice weekend. I ran into a KASAN failure in io-uring
>>> which I think is not "my fault".
>>>
>>> The failure does not happen very infrequently, so my analysis is based on
>>> reading the code. IIUC the failure, then I do not understand the code well
>>> enough, as to say I do not understand how it was supposed to work. I would
>>> appreciate your feedback.
>>>
>>> The failure happens on my own custom kernel (do not try to correlate the line
>>> numbers). The gist of the splat is:
>>
>> I think this is specific to your use case, but I also think that we
>> should narrow the scope for this type of REQ_F_REISSUE trigger. It
>> really should only happen on bdev backed regular files, where we cannot
>> easily pass back congestion. For that case, the completion for this is
>> called while we're in ->write_iter() for example, and hence there is no
>> race here.
>>
>> I'll ponder this a bit…
> 
> I see what you are saying. The assumption is that write_iter() is setting
> REQ_F_REISSUE, which is not the case in my use-case. 

Yes exactly, and hence why I think we need to tighten this check to only
be for bdev backed files.

> Perhaps EAGAIN is
> anyhow not the right return value (in my case). I am not sure any other
> “invalid" use-case exists, but some documentation/assertion(?) can help.
> 
> I changed the return error-codes and check that the issue is not
> triggered again.
> 
> Thanks, as usual, for the quick response.

OK good, thanks for confirming!

-- 
Jens Axboe

