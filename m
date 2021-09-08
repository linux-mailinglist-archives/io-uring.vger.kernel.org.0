Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C373A40401D
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 22:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhIHUQP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 16:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhIHUQP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 16:16:15 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63405C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 13:15:07 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z1so4907946ioh.7
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 13:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eE4tqd6RrGoSxwFZmawYgb9mL+mwW86i5U7gDmqsJ8A=;
        b=Dwt9fh7HncO8CNzeRLQy/tCe3Lr7Pvkp2vYk60oRoW8W+RjVwGPivNGM5965XJAiiF
         I6l3WNQI63l5GfX0dfjuRl89n2mCajVtxgkRkuTPir0Ki1nphPJOa1dOoOEuVAhbD1x/
         BK16TVCCdemtn1g6HhymR7zAvovZTQejWGBFc3DOr/C2zK4FJ7O+EkxbR7+yRRHEMTgQ
         dpPeKSGQ4dN88zWabnC8Ztee1DQNOZflb3pmT1kn5O8OVbuXCu6MXOJ6oGbqWe9/aoun
         A7WcFEiFhnXc/YZ/x8bNYi0cLa2KVUAwMJ+ozuac2jNVGL9FIWnGnxZU7nGGjTG1X5UE
         yyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eE4tqd6RrGoSxwFZmawYgb9mL+mwW86i5U7gDmqsJ8A=;
        b=A0GICpHNtm/VP2GOeYKWzE8uqA4hfLhEEiY8+GKLVSxaj+RWTWktFKVnKESxBGwIhg
         TTpdFdOsvh/PKAhi4Suuj8jjuGfWNy8q/zGUsQg4jkOZJRFBZ4l//SuWfL1uKlKP/RzV
         7iE7qQDSPIsHnozr2V1jd5LgHkCFsH20OwQOAify3avVRflBFjvzOUSI4dfb2YbDoSxg
         zzKWRlT3uLYdDvUgfOdO1RUvJM8nd5UOheP8LzFU7IUToUxdY2nc8870FP1zL/PV9hYX
         VmI7Y+5GDzQVdYg79McmjsbHY1T8kEvEasR7nuI7yNZNX67p8Q466iCATgi7ByHhCCi/
         Gvjg==
X-Gm-Message-State: AOAM530J/mGoZveuZJcVsWtL7FHKN5o+vmIdyCLYFRhQdtc9vnoPFiJc
        ufRzv1mrLzLXBCIMr2OLchsmNPreplt6RA==
X-Google-Smtp-Source: ABdhPJzHWsJl2ntlNwuYeAvnywWSG1+XzfsrMcI0PbuYclNMgCn4Rd/C3ejmxSl7DlSSZ6cq8TRzYA==
X-Received: by 2002:a05:6638:1352:: with SMTP id u18mr97282jad.147.1631132106633;
        Wed, 08 Sep 2021 13:15:06 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f3sm35193ilu.85.2021.09.08.13.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 13:15:06 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix missing mb() before waitqueue_active
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2982e53bcea2274006ed435ee2a77197107d8a29.1631130542.git.asml.silence@gmail.com>
 <bd0b0727-d0ac-7f2a-323d-39411edbe45d@kernel.dk>
 <34219094-7e90-a665-2998-4658f3becdff@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8d2a7c4e-67d3-681b-bf54-f0409cff672f@kernel.dk>
Date:   Wed, 8 Sep 2021 14:15:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34219094-7e90-a665-2998-4658f3becdff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 2:09 PM, Pavel Begunkov wrote:
> On 9/8/21 8:57 PM, Jens Axboe wrote:
>> On 9/8/21 1:49 PM, Pavel Begunkov wrote:
>>> In case of !SQPOLL, io_cqring_ev_posted_iopoll() doesn't provide a
>>> memory barrier required by waitqueue_active(&ctx->poll_wait). There is
>>> a wq_has_sleeper(), which does smb_mb() inside, but it's called only for
>>> SQPOLL.
>>
>> We can probably get rid of the need to even do so by having the slow
>> path (eg someone waiting on cq_wait or poll_wait) a bit more expensive,
>> but this should do for now.
> 
> You have probably seen smp_mb__after_spin_unlock() trick [1], easy way
> to get rid of it for !IOPOLL. Haven't figured it out for IOPOLL, though
> 
> [1] https://github.com/isilence/linux/commit/bb391b10d0555ba2d55aa8ee0a08dff8701a6a57

We can just synchronize the poll_wait() with a spinlock. It's kind of silly,
and it's especially silly since I bet nobody does poll(2) on the ring fd for
IOPOLL, but...

-- 
Jens Axboe

