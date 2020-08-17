Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A35E247865
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 22:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHQU53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 16:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHQU52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 16:57:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BACC061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 13:57:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p37so8693739pgl.3
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 13:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BArM3qmAQkuGk5mwPBhvOouFfmyDDYpG0FiHIP7bl1s=;
        b=fRnoVL+W3CYPQMwF8Ztn/13ifeDGEjvhv/3S97r1S8N7Q7xT/l3jF8R28olPVg2twx
         rVk5klTvXNAwaikRJKQcTIiGUxuOECw5+klLU5SPZTL40RGwba3e4OWqJiuCXH3ppnaX
         fMJp4Htk4+8kogd+5fCLJ33cw/8/4+noxOSdkL8sjLaBuqjf4xzCdUi85L4bCgZBRVpc
         Wsg62SGiPjHIvVp4jqoch+35iFK6sl3stXErX4kGMvJQG4N4Wm+giJqPQmCbtakxlAH6
         9MC8nLP8APMKfSR/qcR2NTsCa9JleBKu86LkEgGrG7B3EMRSjAMxj8RxJAH2fIKtvFgs
         ujIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BArM3qmAQkuGk5mwPBhvOouFfmyDDYpG0FiHIP7bl1s=;
        b=GXgMsoGKgqy9AYilVByIfRyBgKgpJEZdgdpU9igiFEV3F8yEvBGv0C8m1VoHM/gHoq
         9lqB4HS8snvD3dY5cs/LpN0nFmTdisTKBjvEgMyRLW4Sxb4aDxhjGg0581Pw2Txo8RaW
         R4q4rWANhKRJkX3mzh1tebehz8/ufrNeEuUJciMHn8jYvA9R2YcwaOUuSzDA3+JSyVof
         2ALsfsmHyDHNxVRPG/KmJ1sjfonQ2PPToE35gBXYpi5FXx6vmbR4A1WKYt1lvY2tLyaS
         WwRryCDtKicXcIhchzLJcWzZqRr2J1tQorXxjCcCGJoySjJkN6OaBXtaH3OmJNpVsPLF
         Kuzw==
X-Gm-Message-State: AOAM530WnyYPC1d89neGpekFGI09TeXL3aJ3GcogN3aNzoqvI1eRFQlY
        Ccm1aojRy2HiC5Bk4O5rMutAQs7s18hTAHsoNSI=
X-Google-Smtp-Source: ABdhPJzzjAULEElpIT2e6EJgix5RY5nHXtWx2Ow1gNT2xSFsb3Y0LllOPGc9FqNrz7lk8+BEo6Pifg==
X-Received: by 2002:a62:5b07:: with SMTP id p7mr12854794pfb.326.1597697847708;
        Mon, 17 Aug 2020 13:57:27 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:cef9:e56c:5fb2:d956? ([2605:e000:100e:8c61:cef9:e56c:5fb2:d956])
        by smtp.gmail.com with ESMTPSA id s22sm21075230pfh.16.2020.08.17.13.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 13:57:27 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
 <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
 <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
 <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
 <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
 <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk>
 <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
 <aadb4728-abc5-b070-cd3b-02f480f27d61@kernel.dk>
 <x49sgclf0w8.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8cc4bc11-eb56-63e1-bb5c-702b75068462@kernel.dk>
Date:   Mon, 17 Aug 2020 13:57:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x49sgclf0w8.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/20 1:55 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 8/13/20 4:21 PM, Jeff Moyer wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>>>>> BTW, what git sha did you run?
>>>>>>
>>>>>> I do see a failure with dm on that, I'll take a look.
>>>>>
>>>>> I ran it on a file system atop nvme with 8 poll queues.
>>>>>
>>>>> liburing head: 9e1d69e078ee51f253a829ff421b17cfc996d158
>>>>> linux-block head: ff1353802d86a9d8e40ef1377efb12a1d3000a20
>>>>
>>>> Fixed it, and actually enabled a further cleanup.
>>>
>>> Great, thanks!  Did you push that out somewhere?
>>
>> It's pushed to io_uring-5.9, current sha is:
>>
>> ee6ac2d3d5cc50d58ca55a5967671c9c1f38b085
>>
>> FWIW, the issue was just for fixed buffers. It's running through the
>> usual testing now.
> 
> OK.  Since it was an unrelated problem, I was expecting a separate
> commit for it.  What was the exact issue?  Is it something that needs
> backporting to -stable?

No, it was a bug in the posted patch, so I just folded in the fix.

-- 
Jens Axboe

