Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72897445591
	for <lists+io-uring@lfdr.de>; Thu,  4 Nov 2021 15:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhKDOrF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Nov 2021 10:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhKDOrE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Nov 2021 10:47:04 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5511C061714
        for <io-uring@vger.kernel.org>; Thu,  4 Nov 2021 07:44:26 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z206so7226499iof.0
        for <io-uring@vger.kernel.org>; Thu, 04 Nov 2021 07:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7AsHwRp7W89TDu4CaaCkCBJjXNZdEdmiMQdVy3czbNY=;
        b=b5j9TCl/4nB3OfsBXecWlEHpNTejWrzDGHJMDjMh4rvTnH2et0rEOnFDSOpV1PujBN
         FVuNBLWL9344adIZyFhDQ6qREQUqe1N7XWUD5a5+GSZThhUlUEQiYNHWkoTCQgjBzA9h
         KfuJLh3ru268LY2GHUt9UHGuWZiZN6OIe5cYQ/sss2x3YHb0FtDvFBPd+umjgUt9ONUf
         vqrsCcMDEV+LLLMidxlm7dNt5VPyip2KjBbyfEeGFPmlNvtu8H5Es1SElYki9q5vhx4A
         uTK3WVwTydAQ3y77SsSk+MWALuKUNQHauoxQzsOYR5HD7VPpfleUt90kW1cNfppvbpi2
         cFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7AsHwRp7W89TDu4CaaCkCBJjXNZdEdmiMQdVy3czbNY=;
        b=u+Cg2pSrYb3QZ3uQ4Ea54uI9I/LR13icAYgjmM2x+samaMvcYe20vTgkm+1uBR+WEt
         CIfI46cOIxzsfpA+ZyI0qK5wt0JM63gMN47IgrZen/tq5I/jMzFfrujOSfZcr1/nQpOi
         G05yppSSCYoNGSPr+HsRSamQwhfnRPe9t6wJqtgr8FeFzCauMRvuN5LzDcqe9T98X1XR
         sIegqtelf/gLWA8zVsr7ZDPL1Lrad/cQzcvLrHWJimwhFzAcrPfiXJPMZIeEI0bs6z8B
         sbkw+eiXNf3gKh+pWA1cw3nG+9A407puBX+dimNVeE0BnvZoskKkvpcKEwGlJ/JUir0S
         i4RQ==
X-Gm-Message-State: AOAM533Vbz5KKcWa6O96x0Jgb/IYBKVNPvu9dT+ftAsMtvMJtAQaUMNO
        tEkUtOls7kOfa1yN5uDgCWbfiA==
X-Google-Smtp-Source: ABdhPJya0s5iJuHzAorLG6/MYzrxzuKhIBQIuXwGk2hiSyk/aD1paAV9Hp8M5wwf+dpBZEX2r5j+WA==
X-Received: by 2002:a6b:fe11:: with SMTP id x17mr7846300ioh.131.1636037066269;
        Thu, 04 Nov 2021 07:44:26 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t6sm3096389iov.39.2021.11.04.07.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 07:44:25 -0700 (PDT)
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
To:     Cyril Hrubis <chrubis@suse.cz>
Cc:     Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <cc3d7fac-62e9-fe11-0cf1-3d9528d191a0@kernel.dk> <YYPt1PaGtiSLvyKw@rei>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fdf1c610-6c9a-befd-a284-b8a552b4c225@kernel.dk>
Date:   Thu, 4 Nov 2021 08:44:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YYPt1PaGtiSLvyKw@rei>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/21 8:27 AM, Cyril Hrubis wrote:
> Hi!
>>> This limit has not been updated since 2008, when it was increased to 64
>>> KiB at the request of GnuPG. Until recently, the main use-cases for this
>>> feature were (1) preventing sensitive memory from being swapped, as in
>>> GnuPG's use-case; and (2) real-time use-cases. In the first case, little
>>> memory is called for, and in the second case, the user is generally in a
>>> position to increase it if they need more.
>>>
>>> The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
>>> preparing fixed buffers for high-performance I/O. This use-case will
>>> take as much of this memory as it can get, but is still limited to 64
>>> KiB by default, which is very little. This increases the limit to 8 MB,
>>> which was chosen fairly arbitrarily as a more generous, but still
>>> conservative, default value.
>>> ---
>>> It is also possible to raise this limit in userspace. This is easily
>>> done, for example, in the use-case of a network daemon: systemd, for
>>> instance, provides for this via LimitMEMLOCK in the service file; OpenRC
>>> via the rc_ulimit variables. However, there is no established userspace
>>> facility for configuring this outside of daemons: end-user applications
>>> do not presently have access to a convenient means of raising their
>>> limits.
>>>
>>> The buck, as it were, stops with the kernel. It's much easier to address
>>> it here than it is to bring it to hundreds of distributions, and it can
>>> only realistically be relied upon to be high-enough by end-user software
>>> if it is more-or-less ubiquitous. Most distros don't change this
>>> particular rlimit from the kernel-supplied default value, so a change
>>> here will easily provide that ubiquity.
>>
>> Agree with raising this limit, it is ridiculously low and we often get
>> reports from people that can't even do basic rings with it. Particularly
>> when bpf is involved as well, as it also dips into this pool.
>>
>> On the production side at facebook, we do raise this limit as well.
> 
> We are raising this limit to 2MB for LTP testcases as well, otherwise we
> get failures when we run a few bpf tests in quick succession.> 
> Acked-by: Cyril Hrubis <chrubis@suse.cz>

Andrew, care to pick this one up for 5.16?

-- 
Jens Axboe

