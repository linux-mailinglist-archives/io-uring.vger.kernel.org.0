Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A54243FE6
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgHMUhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 16:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgHMUhc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 16:37:32 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A54C061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 13:37:32 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p18so2863249ilm.7
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 13:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FqmAZYqzFsSkWzm5o6JzBWrR6k3tJqnevIJpVeNdzMc=;
        b=xpmXjb8yXTC+LVaZXU4TMn0MFpntrufP2lqe2nApiLUBxKdgpoEi9sHXKaiNHN/+i/
         RxZEVsG1DSgXxXH+bSm0V/d+YsCwL5ejR+/2jIWDJhmE0zXD4t0yWiPhX4cWd7TkxxCh
         W8exrqh+T9poiNVKGVZHps2T4Y/cW2ZuhgmP+dFLEVvDM6FRFOIVj9RMgaTFL72BdZNq
         WoAWjYv9C/tB4xyHW2NKVz1syGQFfV0uEPjab4mw6ZgTohuQT+dDELdlyOKKIy0MnXHT
         pcLc+P8M/x+jZtkcnZUf3sz0UYlBeOZBMswpVEX1OYwjyrR4flc3+lIxv2v9FpAyCvWA
         k/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FqmAZYqzFsSkWzm5o6JzBWrR6k3tJqnevIJpVeNdzMc=;
        b=HwjwKJvWQpXeNuB/XMN3KDByk+Xt69FVElEpJ/EJLnJJHJmzwSyzrgm3efvu62WmMz
         G8y0/zXY0WXv9vcGYmjDrE3YUZB3UX4QuAGUwwQRdctFGCtbV3MUK4/ybqcaCZcsAdv0
         YCfOcrmYksgiax4VWjB4ahKgl1AmC5gSSaMN70JALO/ilQvkfoSrH9e+5mAHWfQKIdzO
         pFvL1WC+MjVW1ZEb8LwRlDRrlFJRFd0KXRkXwxvXn2TWpzQMAdC1nsesmgbT48rxMZQs
         bR5cubKLE3QfY5IAG1h4c7aOQ5qfNdIucJQORD0y9EYAEYy3aJzSKP1mCd4lxXah3vta
         bihg==
X-Gm-Message-State: AOAM532l0mZmhrmcQKAhYtKKnnxaXuIHXWgoBhjXxNHbxczR70Zocpne
        bKxrOYKpetxYf0IVU25ijYUnuvv39/U=
X-Google-Smtp-Source: ABdhPJybe3xztlTAzs44jMd4bVx61FWHndqihrMhrJljmbtrlp1YmdyEjwGCj1sWaCqUvnYAatHRWQ==
X-Received: by 2002:a92:dac1:: with SMTP id o1mr2583669ilq.86.1597351051693;
        Thu, 13 Aug 2020 13:37:31 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f128sm3251731ilh.71.2020.08.13.13.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 13:37:31 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
From:   Jens Axboe <axboe@kernel.dk>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
 <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
Message-ID: <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
Date:   Thu, 13 Aug 2020 14:37:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/20 2:33 PM, Jens Axboe wrote:
> On 8/13/20 2:25 PM, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> Since we've had a few cases of applications not dealing with this
>>> appopriately, I believe the safest course of action is to ensure that
>>> we don't return short reads when we really don't have to.
>>>
>>> The first patch is just a prep patch that retains iov_iter state over
>>> retries, while the second one actually enables just doing retries if
>>> we get a short read back.
>>
>> Have you run this through the liburing regression tests?
>>
>> Tests  <eeed8b54e0df-test> <timeout-overflow> <read-write> failed
>>
>> I'll take a look at the failures, but wanted to bring it to your
>> attention sooner rather than later.  I was using your io_uring-5.9
>> branch.
> 
> The eed8b54e0df-test failure is known with this one, pretty sure it
> was always racy, but I'm looking into it.
> 
> The timeout-overflow test needs fixing, it's just an ordering thing
> with the batched completions done through submit. Not new with these
> patches.
> 
> The read-write one I'm interested in, what did you run it on? And
> what was the failure?

BTW, what git sha did you run?

-- 
Jens Axboe

