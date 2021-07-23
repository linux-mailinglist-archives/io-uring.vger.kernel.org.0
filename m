Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC523D42F3
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhGWVvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 17:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhGWVvr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 17:51:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728EFC061575
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 15:32:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m1so4209021pjv.2
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 15:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tV66efr2sfMcVMLylWg/LJpGnE8LpQ4XpbFt6ERNEeo=;
        b=QAKuLY9GgxJ50ci9igLT9xJTZDGG+RU9DZ986me1IQNJIRMu8qK/XFM6sG2CkkDM9T
         90Ea5+/fcz4HhlsQuOlc946CFqbFBuEkWYtl9RB46oFekXIbQ4ZjdhT4lIZ7IEl5lVBl
         XNeVK+oHSqAr0R22ItaC1Xci11ealYBMDm6sRKIzWm38plmpVfHhpQNyXeL0OEaUAq/b
         HBznImA+f0YcjN+9uO3aDVIflz+ZFpke60t1y/VLAP3CobWxVUqEgVl/2K2cAp1i0tPn
         99QAIp0TAlb0kXaPxfNSWe5eD61v0AOOJ+WWKLLzuHxTV+Go+CGO/B5nFVkj1esQL7ni
         PSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tV66efr2sfMcVMLylWg/LJpGnE8LpQ4XpbFt6ERNEeo=;
        b=jCumRQ9rCoyabnKQbQ259QctjIx7RzRS2wEeKyh+c86kPZC31ePGXUVcYxB/lnsbqi
         mPrDylK0YbjuHIxAPf6ch/k1OyzPxCgIlU0ZVUmX35PjdAyBP9R1Jl5rQZaplIooqlxB
         U9lmeBmCO5eszVh7IKmg+kIcTHRlyuJoZCJ+xxKFW4NrGNG9bodbZ3HcxY4szMtTFh/L
         dGkA5YxTgz/nRkbVSxtCQAjm3ERCuo9PAq/oiwPX/QVm0aZUm9F8hExmOUBygt2cWEFV
         5x02jZxTVE0FvqWtl+55AA5hK21vzjau5mmlUaD15M76t/OJvzoQ8hw9Ck1ybkt3g47I
         ZzhA==
X-Gm-Message-State: AOAM532KzTRjWF+dMuypdC0RPpY2cvuONrWq1nF0180P5sBICX9qnj0e
        /bb/TQZ9CQLch+7XVdXghOjaMg==
X-Google-Smtp-Source: ABdhPJycsBNUILT/c7G9sDe0E4iCZEgqH7eESCoAuXelywzS7rUSy/PDR2L5TwX/RgNYlZtjbimZFQ==
X-Received: by 2002:a17:90b:a15:: with SMTP id gg21mr15674896pjb.190.1627079539802;
        Fri, 23 Jul 2021 15:32:19 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m19sm35418743pfa.135.2021.07.23.15.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 15:32:19 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
 <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
 <591b4a1e-606a-898c-7470-b5a1be621047@kernel.dk>
 <640bdb4e-f4d9-a5b8-5b7f-5265b39c8044@kernel.dk>
 <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
 <3f557a2b-e83c-69e6-b953-06d0b05512ae@kernel.dk>
 <YPslfT91brz3SsuM@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <46b579e9-795b-18db-6ccd-437278430ad7@kernel.dk>
Date:   Fri, 23 Jul 2021 16:32:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YPslfT91brz3SsuM@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/21 2:24 PM, Al Viro wrote:
> On Fri, Jul 23, 2021 at 02:10:40PM -0600, Jens Axboe wrote:
>> On 7/23/21 1:00 PM, Al Viro wrote:
>>> On Fri, Jul 23, 2021 at 11:56:29AM -0600, Jens Axboe wrote:
>>>
>>>> Will send out two patches for this. Note that I don't see this being a
>>>> real issue, as we explicitly gave the ring fd to another task, and being
>>>> that this is purely for read/write, it would result in -EFAULT anyway.
>>>
>>> You do realize that ->release() might come from seriously unexpected
>>> places, right?  E.g. recvmsg() by something that doesn't expect
>>> SCM_RIGHTS attached to it will end up with all struct file references
>>> stashed into the sucker dropped, and if by that time that's the last
>>> reference - welcome to ->release() run as soon as recepient hits
>>> task_work_run().
>>>
>>> What's more, if you stash that into garbage for unix_gc() to pick,
>>> *any* process closing an AF_UNIX socket might end up running your
>>> ->release().
>>>
>>> So you really do *not* want to spawn any threads there, let alone
>>> possibly exfiltrating memory contents of happy recepient of your
>>> present...
>>
>> Yes I know, and the iopoll was the exception - we don't do anything but
>> cancel off release otherwise.
> 
> Not saying you don't - I just want to have that in (searchable) archives.
> Ideally we need that kind of stuff in Documentation/*, but having it
> findable by google search is at least better than nothing...

Agree, and I'll amend the commit to include a reference to it as well
and expand the explanation a bit. The easier that kind of stuff is to
find, the better.

-- 
Jens Axboe

