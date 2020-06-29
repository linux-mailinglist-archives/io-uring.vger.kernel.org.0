Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A6C20D407
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 21:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgF2TEa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730530AbgF2TCn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:02:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1443C030F25
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:37:02 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d194so5170673pga.13
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9AwUE/+wB437cDHDRYWEKxxfemWIYQx+DW7Qy/UDGk4=;
        b=CVxyYSJ+i5VCNp6Jjmkbsj92o6F8bKx6JiZ2++G3PjyIgyl8J4VOCqWadWpGwkcSlE
         l88Aj/7NcP+G0rkdL7+FAt1LbKbYfMK8l1ouAACRHBnGW+QJRu2OEszY8Bl3FMyyj6KE
         gLUbFui3za+f2FbJ+E+x4qtEHeT87w0zcF+3KQCvoIeepgRb+y38p6cAIXtjaWqH9o6y
         SfIXbdTbAJ5jfK9xUI6Ky7Mip1E/PcSVe+ocxncZWYaRvzqLmqlzyU5kci+j1NVb05eG
         w7yrAxLVx3J2OM5NgODZ3S2FQFC0oi0iH+4oR9pnwqyOoS1THsxfsU54JZRtN8yPKDKq
         q8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9AwUE/+wB437cDHDRYWEKxxfemWIYQx+DW7Qy/UDGk4=;
        b=uRZPnvm/mDLToHRdKazZLxv374se9upr+8zDKQT1b6YXikik66sSRWHdzAq1T2rCCn
         89ZaiXu5kdCdrFGL9vDLgWqXkeFiaHTddvJmrdegOftBVOyEQLzhfLs57T5Ez7cyyuV0
         XrrQQ39pRUSEBGrSyuoxTaVK/pM0oe3ygYZFKbdVhzNZToebKnkv4wJTjEYmM8p0c2OX
         d5b0tZgrfhoPOPDdeXW+AI82mNJT+dJNh4LkBODpE9SYbZakQ3EWpoOEOznjsmCVOUZq
         ChLPEMTSdtXP8oGm1HHNFEfDP+xnuAg3QkimFAI8qMt7NSQ4bILdnJAz7AGjtghoxtA0
         JRRQ==
X-Gm-Message-State: AOAM532Zl21Snx/N3TIRIo0JPXGTuW6BXhqMtj9Dp7PrLLL+7TI7CX+m
        evi1/9ehs1prRqkW4Abpg6yOd5Veh0jm0w==
X-Google-Smtp-Source: ABdhPJzdPAliH2HLCs/TPJqKvKgOl5zGdaeP3Gq+uMgc8JivapoJK4AqiDiP0WYjTdz4jfl4M+s9qw==
X-Received: by 2002:a63:5623:: with SMTP id k35mr11704106pgb.325.1593448621908;
        Mon, 29 Jun 2020 09:37:01 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id n89sm110269pjb.1.2020.06.29.09.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 09:37:01 -0700 (PDT)
Subject: Re: [PATCH 0/5] "task_work for links" fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593253742.git.asml.silence@gmail.com>
 <05084aea-c517-4bcf-1e87-5a26033ba8eb@kernel.dk>
 <328bbfe9-514e-1a50-9268-b52c95f02876@gmail.com>
 <14de7964-8d8d-9c10-7998-c06617ef5800@gmail.com>
 <23051425-13b5-fd2c-94f7-6f28677cfc6c@kernel.dk>
 <258f09ee-9d1a-9c47-47e1-9263c7e4ba99@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b7ea8fb9-9680-958a-906a-58bbc93b94cd@kernel.dk>
Date:   Mon, 29 Jun 2020 10:37:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <258f09ee-9d1a-9c47-47e1-9263c7e4ba99@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/29/20 10:32 AM, Pavel Begunkov wrote:
> On 29/06/2020 18:52, Jens Axboe wrote:
>> On 6/29/20 4:21 AM, Pavel Begunkov wrote:
>>> On 28/06/2020 17:46, Pavel Begunkov wrote:
>>>> On 28/06/2020 16:49, Jens Axboe wrote:
>>>>> On 6/27/20 5:04 AM, Pavel Begunkov wrote:
>>>>>> All but [3/5] are different segfault fixes for
>>>>>> c40f63790ec9 ("io_uring: use task_work for links if possible")
>>>>>
>>>>> Looks reasonable, too bad about the task_work moving out of the
>>>>> union, but I agree there's no other nice way to avoid this. BTW,
>>>>> fwiw, I've moved that to the head of the series.
>>>>
>>>> I think I'll move it back, but that would need more work to be
>>>> done. I've described the idea in the other thread.
>>>
>>> BTW, do you know any way to do grab_files() from task_work context?
>>> The problem is that nobody sets ctx->ring_{fd,file} there. Using stale
>>> values won't do, as ring_fd can be of another process at that point.
>>
>> We probably have to have them grabbed up-front. Which should be easy
>> enough to do now, since task_work and work are no longer in a union.
> 
> Yep, and it's how it's done. Just looking how to handle req.work better.
> e.g. if we can grab_files() from task_work, then it's one step from
> moving back req.work into union + totally removing memcpy(work, apoll)
> from io_arm_poll_handler().

Indeed, and both of those are very worthy goals fwiw. If at all possible,
it'd be nicer to get rid of the restriction of having to check ring_fd
and file, but that doesn't seem possible without making the general
io_ring_enter() system call more expensive.

-- 
Jens Axboe

