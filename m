Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF91B3EB692
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 16:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbhHMOMi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 10:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbhHMOMh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Aug 2021 10:12:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8B8C0617AD
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 07:12:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q2so12116848plr.11
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 07:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sM9iZQWOpgXtCBxdiAH87a4w4pD1Hwf0Q/waRT60trY=;
        b=L4fbcQ/XtI8L4Dwr6IgeN+D/hs24frS3q4t7H7qlyDb7LBWVIjTli59tuqeZ0bVK+I
         +m4RqhoDbSfmXaOlRVCvuoUArFRgWaDPl+DlYdW/RnQ1WW8YDGIRBECQrWLsj6vZx2aI
         yQ9y7XQ+Heop80RAY0Oz0LRfdNPE4f2Bf1fT5V06dbG1vYHHjJFLJ0ztMRKkQX5IFyNo
         g3rP4zcxGVj0yUQbM38kAvfemHMN5DPL09kdgJK/TB0uNl9GWYc+J9DLEmf87nr2vh/a
         Y1ehh2KRphTB4BGJeMGwU56uPGPlcNYGPsHNAu9Pb6XPp5klfdTcRvdTlGN3bf1w+ZXC
         50Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sM9iZQWOpgXtCBxdiAH87a4w4pD1Hwf0Q/waRT60trY=;
        b=W/bXnKC2c3Qt6R+nHaLl+Bzo7WN0M/IYzO82CPFGVCjFaBZPrLUkEK109mhdoGAgL3
         oIDMYRQsO3YT2WBno5ILCPsFSxt2UAk6bAc5ZKU8Kl1qWa0gSmGXKK+pmne45cV3NaIf
         hOzMf18Tn69jj2lSLPd4YMlNWk1Y+HulQ1eZUmavKd4Rpei8KPZcq+UJl4IedeeQJfMA
         G5cUKZyyt+bjbpXKMaB534gewrwI/z3+KFd+K3AGenJWWb75W625CdqOj5bWVviSJ2qM
         Q2hsIkipQWIwmnQuP15bmMGPHeB0lav3KCsxOMdqINpR6y2TdK+ZiK5osgvaZoNn1etz
         hdoA==
X-Gm-Message-State: AOAM5310YGy0bK1Km+wQiQJj+sSxuGkRCMLajaH23GpZNw1Kq2jx6Hf4
        KdiHn93r9Q29kDCuy+k/4jiG/iTmnmIFcnJ6
X-Google-Smtp-Source: ABdhPJxk/6mubsgRh4KoiPUmDR+lqAmlG7SCS2sNtmMzaLRGB7vL6TfeFPyTxgoPtBChlKsE0Q5Utg==
X-Received: by 2002:a17:902:e851:b029:12c:9284:8c2b with SMTP id t17-20020a170902e851b029012c92848c2bmr2099685plg.57.1628863930374;
        Fri, 13 Aug 2021 07:12:10 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z15sm2982341pgc.13.2021.08.13.07.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 07:12:09 -0700 (PDT)
Subject: Re: [PATCH v9 00/11] io_uring: add mkdir and [sym]linkat support
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
 <CAHk-=wjMFZ98ERV7V5u6R4FbYi3vRRf8_Uev493qeYCa1vqV3Q@mail.gmail.com>
 <cbddca99-d9b1-d545-e2eb-a243ce38270b@kernel.dk>
 <CAOKbgA5jHtR=tLAYS_rs77QppRm37HV1bqSLQEMv8GusQNDrAg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <506f544a-cb0b-68a2-f107-c77d9f7f34ed@kernel.dk>
Date:   Fri, 13 Aug 2021 08:12:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA5jHtR=tLAYS_rs77QppRm37HV1bqSLQEMv8GusQNDrAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/21 3:32 AM, Dmitry Kadashev wrote:
> On Fri, Jul 9, 2021 at 2:25 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/8/21 12:34 PM, Linus Torvalds wrote:
>>> On Wed, Jul 7, 2021 at 11:35 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>>>>
>>>> v9:
>>>> - reorder commits to keep io_uring ones nicely grouped at the end
>>>> - change 'fs:' to 'namei:' in related commit subjects, since this is
>>>>   what seems to be usually used in such cases
>>>
>>> Ok, ack from me on this series, and as far as I'm concerned it can go
>>> through the io_uring branch.
>>
>> I'll queue it up in a separate branch. I'm assuming we're talking 5.15
>> at this point.
> 
> Is this going to be merged into 5.15? I'm still working on the follow-up
> patch (well, right at this moment I'm actually on vacation, but will be
> working on it when I'm back), but hopefully it does not have to be
> merged in the same merge window / version? Especially given the fact
> that Al prefers it to be a bigger refactoring of the ESTALE retries
> rather than just moving bits and pieces to helper functions to simplify
> the flow, see here:
> 
> https://lore.kernel.org/io-uring/20210715103600.3570667-1-dkadashev@gmail.com/

I added this to the for-5.15/io_uring-vfs branch:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.15/io_uring-vfs

had one namei.c conflict, set_nameidata() taking one more parameter, and
just a trivial conflict in each io_uring patch at the end. Can you double
check them?

-- 
Jens Axboe

