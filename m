Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2F28F2EC
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgJONJP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 09:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgJONJP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 09:09:15 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0515CC061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:09:13 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id o4so531728iov.13
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yJdroy89KvK6LNKaU+WV9fMwsRWYupTkFWAQ9ViniDg=;
        b=HYjVQIluVHNIFFux0imW2H68/LZZPuauvn9BxVqOIvekT4Q8ek2iIGF1OUxzJly6IA
         JoACzZqmJx55tir91994eLziafAOz/4JusUVp+TYAgK1TyK8N+EtyfgJlzl5IHEhaBBX
         znRA50vE057uKxF7tgiQN16mfD3WbYlxhAVv80BqrnApIOcMviGvIr09d3wv7lmp6tRp
         vb8hGL7AP3N8gv8Xj9C4wpqjoBCZk6eIEXPgj3Z+m47mp3chbRmbZyU4W2d0+Rz/5QFS
         2BoUEwAwPUC80E50w/rqy5IvAoR/9baUHZamBGlGYpY6OWtsnrvhxa6zRhkQ8dOnGBKf
         y0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yJdroy89KvK6LNKaU+WV9fMwsRWYupTkFWAQ9ViniDg=;
        b=g6K1Q3zg5/JkREyHByRWw4ArS/TEJ2yKnDC1R5KFTYDwblXFNuiMjoNhb3AI8UeZ9Z
         pmU2oiaLqAawUZMke9a0Pgj/fG+nol/2uWxmlPB2AjoBt6k+BUDyaY00qAmisViSHg7c
         rJG8OVZ7+CfXP2lHAQ3xMgTYuVT8dEvPOfFbL03qBWg5dAPLTK10gaxh6EXUySlhX3ul
         YogLQafqVR8jQAcxdIhp+GccOdhc4PCf2+lz+o27YcrUrn2ukPYNvmnlGXByItkSMm3n
         PQo43lgMhwXj2TU5fX00YzL2KEaQf33COHj509qkbVEfsQBIDWF+5tJ+oElzc+zI+2iE
         AlrQ==
X-Gm-Message-State: AOAM533eJ3f30PqFoCxaopfP6/uCCHIGdPreJBsfet9KmBEuSetGgTT9
        4qVIC1QAGCnwTNvLMTJeaoctcSVQ+VrXdw==
X-Google-Smtp-Source: ABdhPJwOpB1sX9u1V7PXqY7owBv8VaFqkh4jV+snq5sy1I0PwEe2i4AjsPZftLhwGUAU8rI/kMDIyQ==
X-Received: by 2002:a05:6638:f03:: with SMTP id h3mr3341435jas.36.1602767353121;
        Thu, 15 Oct 2020 06:09:13 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y6sm2460127ili.36.2020.10.15.06.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 06:09:12 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: optimise io_fail_links()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Cc:     io-uring@vger.kernel.org, clang-built-linux@googlegroups.com
References: <cover.1602703669.git.asml.silence@gmail.com>
 <3341227735910a265b494d22645061a6bdcb225d.1602703669.git.asml.silence@gmail.com>
 <20201015085319.GA3683749@ubuntu-m3-large-x86>
 <7e293894-823c-5b91-1b55-f5941c82d83e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <01c6d077-f6fa-a8da-449a-d0c1c4d59012@kernel.dk>
Date:   Thu, 15 Oct 2020 07:09:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7e293894-823c-5b91-1b55-f5941c82d83e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15/20 4:11 AM, Pavel Begunkov wrote:
> On 15/10/2020 09:53, Nathan Chancellor wrote:
>> On Wed, Oct 14, 2020 at 08:44:22PM +0100, Pavel Begunkov wrote:
>>> -		io_put_req_deferred(link, 2);
>>> +
>>> +		/*
>>> +		 * It's ok to free under spinlock as they're not linked anymore,
>>> +		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
>>> +		 * work.fs->lock.
>>> +		 */
>>> +		if (link->flags | REQ_F_WORK_INITIALIZED)
>>> +			io_put_req_deferred(link, 2);
>>> +		else
>>> +			io_double_put_req(link);
>>
>> fs/io_uring.c:1816:19: warning: bitwise or with non-zero value always
>> evaluates to true [-Wtautological-bitwise-compare]
>>                 if (link->flags | REQ_F_WORK_INITIALIZED)
>>                     ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
>> 1 warning generated.
>>
>> According to the comment, was it intended for that to be a bitwise AND
>> then negated to check for the absence of it? If so, wouldn't it be
>> clearer to flip the condition so that a negation is not necessary like
>> below? I can send a formal patch if my analysis is correct but if not,
>> feel free to fix it yourself and add
> 
> I have no idea what have happened, but yeah, there should be "&",
> though without any additional negation. That's because deferred
> version is safer. 
> 
> Nathan, thanks for letting know!
> Jens, could you please fold in the change below.

Done.

-- 
Jens Axboe

