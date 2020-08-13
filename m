Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9D0243FD8
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 22:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHMUdz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 16:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgHMUdy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 16:33:54 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93091C061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 13:33:54 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id g19so8681679ioh.8
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 13:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WCkp29LLbiFh6rDfQGLlXEj9GkSe3Gs7HQPIT6WIhDw=;
        b=w6qIwf5yrqOcYeqRklbULVnZXrdabpJkZR89hz8JO2f+2eAAl38UTd5/ZYDTSnuq5S
         3YThxmdfwlPs6n/OH3cV6Xd7dqoUu7vJ9cUJmoDP2VsxqoT8DQs+6vEEXYpZqNiTbWuA
         5GuQszCk1melq9XNVlmrc4v/dollJdUAb6lQc+njzYID+ApFlOe2+0bQWGD2rCeQX4We
         n7s9FUEewiUhwVguR4Aop0hxcD3PSMMbTn+sOEhXssXTrRLWU4Jgm+FhC8fMFS2ABi0E
         KO+LC677mMbQdAniZPqshCLuMCs8WBGlH4gEre+k8OvRG6O9uQG+q4OT9NtCMSih3zFW
         3W8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WCkp29LLbiFh6rDfQGLlXEj9GkSe3Gs7HQPIT6WIhDw=;
        b=MWe9oJFolAedCJADJrUlW5WCxfs+JDTlgFrJq0vsKcKh5dbGVnsYVdLA8r8yw8CI82
         QVEUxyDGUT+Q8NA3dKW8SXGTY+qwFd8K81xdx0PwUEweJEfdmFaS4+rmSbI34/VkbDhK
         RmGc6G/fZIz+BlklbfCLAVE8hfp5vWrCYD6N7nstYxqAR2CGn/t3BkYQe1r2yTlSfRlb
         t0PsJZhBECbW5gI41+btAgPAg0uOydxHouYaqQhv52bsLoTZhcxNx8I6hn+qNIfB/0DE
         p0tiqGEPK/zh0Xa/A7tiENJ7WtxO7+GDnS8FTVz4Qexn6JvCL3dfWmnpbs4nhAw0ulz3
         4/GA==
X-Gm-Message-State: AOAM533zrto43F6vYdBzO7km4nt2zzhIEWlzGTxWeFp1h+ckoNNs2KPw
        Ru/7s+vpHlMQ1FSWOOqGnSobyQ==
X-Google-Smtp-Source: ABdhPJwNPqBN53gpmpJLPguJcVPGsvLQIuq3uUNxfDwWNumfzrqeF4Dc/QX+B0Lk7Tr6mYXXlxIVIQ==
X-Received: by 2002:a05:6602:14c1:: with SMTP id b1mr6357694iow.163.1597350833439;
        Thu, 13 Aug 2020 13:33:53 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t14sm3114936ios.18.2020.08.13.13.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 13:33:53 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
Date:   Thu, 13 Aug 2020 14:33:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x497du2z424.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/20 2:25 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Since we've had a few cases of applications not dealing with this
>> appopriately, I believe the safest course of action is to ensure that
>> we don't return short reads when we really don't have to.
>>
>> The first patch is just a prep patch that retains iov_iter state over
>> retries, while the second one actually enables just doing retries if
>> we get a short read back.
> 
> Have you run this through the liburing regression tests?
> 
> Tests  <eeed8b54e0df-test> <timeout-overflow> <read-write> failed
> 
> I'll take a look at the failures, but wanted to bring it to your
> attention sooner rather than later.  I was using your io_uring-5.9
> branch.

The eed8b54e0df-test failure is known with this one, pretty sure it
was always racy, but I'm looking into it.

The timeout-overflow test needs fixing, it's just an ordering thing
with the batched completions done through submit. Not new with these
patches.

The read-write one I'm interested in, what did you run it on? And
what was the failure?

-- 
Jens Axboe

