Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159162AA85C
	for <lists+io-uring@lfdr.de>; Sun,  8 Nov 2020 00:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgKGXSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 18:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGXSs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 18:18:48 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B80C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 15:18:47 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id o129so4770147pfb.1
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 15:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZBJqMVsRsS7iQVBCGYKv4vydq1aQOpaDTZyS6r94prE=;
        b=ep4AMIvmGdlRzOH9r2fjHA9U8xevaKf8/xEDh5oLANa5xnNApqGrNcm5zR4dxqrYOh
         plF+vyErAkDegqm68y0eNPJ5/KItOvnlrXuxwMl619TVeIJN5VPdK8vwMFHMCiHJPyus
         Oq8rdU+wl2e9vLoW7lrwS2oyCpe/kJ7j4soRPXNTkYbDVG9ODqxr/HrJ/Jb03MQ/fxxL
         twzxvhjfsp9P18SlF4U6ZbkX84E/mgbiRy62MfY72NOJJxCk9NiNXYYTwYJShFVvfvR6
         OdD7AMeS22XmXGYL9vSD2xDkjCzXiF5QA/t+Sc9q5QL0/0RNy5Ybg01qenegaXFeeSf1
         ZGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZBJqMVsRsS7iQVBCGYKv4vydq1aQOpaDTZyS6r94prE=;
        b=OTmt6n8C//2pPuQi1+COfu0FF1t16iA4ZM7kwW9aRgKupAHLKERI8HXAlGmQNsxpDR
         2W2EkMrIoxkwUV2uGAo3dGiFj+Ejhe9K8wZcYQGJ7W74vCrVat31N0QF/w6GsosjXWb9
         VU4K/FBw0epDA/IOhq7iIDUfNjTp4si6z6QvB9VsxjTHZpxH90e+Y4IbPX+PGtPqGx9R
         sc832JPevHpTtS1R6Ivxvqwq7jDp0e+Ja+EHWCxRfHapZPp1VuuRQAMd8qglPaa48L5D
         WL8nI4MmBhZW4gSkBy0qsXJz5KvFDU54/icHYWeDoxxckuw/0qw9mMNLTkywJ20qCZsN
         rZ2g==
X-Gm-Message-State: AOAM5321nJBLz+8s4Fr4RmVl9QTqtUNi4AlXr3Ktr/3C70i0TvuRIO2w
        OKbcCddOLiYFOD5GSY8qvIG5cA==
X-Google-Smtp-Source: ABdhPJz1Zo3/lRCGH7jmW4xw+FMJtj1UiJ0y/YqSprKknP4QRNZ6BBnDJRgQhTSHXgBWLy64SPfCSA==
X-Received: by 2002:a62:2c8a:0:b029:160:d7a:d045 with SMTP id s132-20020a622c8a0000b02901600d7ad045mr7901959pfs.65.1604791126902;
        Sat, 07 Nov 2020 15:18:46 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m66sm297997pfm.54.2020.11.07.15.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 15:18:46 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Josef Grieb <josef.grieb@gmail.com>
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
 <39db5769-5aef-96f5-305c-2a3250d9ba73@gmail.com>
 <030c3ccb-8777-9c28-1835-5afbbb1c3eb1@gmail.com>
 <97fce91e-4ace-f98b-1e7e-d41d9c15cfb8@kernel.dk>
 <a8a4ac73-81f9-f703-2f91-a70ff97e5094@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3094f974-1b67-1550-a116-a1f1fca84df2@kernel.dk>
Date:   Sat, 7 Nov 2020 16:18:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a8a4ac73-81f9-f703-2f91-a70ff97e5094@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/7/20 3:47 PM, Pavel Begunkov wrote:
> On 07/11/2020 22:28, Jens Axboe wrote:
>> On 11/7/20 2:54 PM, Pavel Begunkov wrote:
>>> On 07/11/2020 21:18, Pavel Begunkov wrote:
>>>> On 07/11/2020 21:16, Pavel Begunkov wrote:
>>>>> SQPOLL task may find sqo_task->files == NULL, so
>>>>> __io_sq_thread_acquire_files() would left it unset and so all the
>>>>> following fails, e.g. attempts to submit. Fail if sqo_task doesn't have
>>>>> files.
>>>>
>>>> Josef, could you try this one?
>>>
>>> Hmm, as you said it happens often... IIUC there is a drawback with
>>> SQPOLL -- after the creator process/thread exits most of subsequent
>>> requests will start failing.
>>> I'd say from application correctness POV such tasks should exit
>>> only after their SQPOLL io_urings got killed.
>>
>> I don't think there's anything wrong with that - if you submit requests
>> and exit before they have completed, then you by definition are not
>> caring about the result of them.
> 
> Other threads may use it as well thinking that this is fine as
> they share mm, files, etc.
> 
> 1. task1 create io_uring
> 2. clone(CLONE_FILES|CLONE_VM|...) -> task2
> 3. task1 exits
> 4. task2 continues to use io_uring

Sure, but I think this is getting pretty contrived. Yes, if the task
that created the ring (and whose credentials are being used) exits,
then the ring is effectively dead if you're using SQPOLL. If you're
using threads, the threads go away too.

-- 
Jens Axboe

