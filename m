Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F282241CA6
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 16:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgHKOpt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 10:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbgHKOps (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 10:45:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B8DC06174A
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 07:45:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t6so1998449pjr.0
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 07:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0TKJ8QiOGw2cS0Spzetvjqqgie96cDTA3YQauzdWsow=;
        b=sE1l4Jh9OMKhr6xkroUSS+SsiF3XTlxMVq54bvxBNHB0HnSBRmgi14cdjhUvy/fMtl
         gdau5+ZUXd9R7E1FQD26A22G4PI6hs0d1cDOFFVFNLUWQpYYKdeKQTWk+LmlJvc3PpSj
         NNboc4l12wzSTutNqGLd4oNJ9OxsfwP3ugQOa0LDf01ZD2l9kQQUnAio+1EI8/F6I90y
         CBoOE14OjyFNaHXtsLxUWEkFLeYfyBzqp9C5rmJHYr87GWLRcJwzW4LskCOJSZhri+m0
         0XIDSqFtVfWxMBbJUwblt5zoQxxSCllh59qRDLqYCf1N12aUch673H4de3PfwPlPUxMx
         6eBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0TKJ8QiOGw2cS0Spzetvjqqgie96cDTA3YQauzdWsow=;
        b=V5fEKb20+55Jpe/DZC7LbVHjjWuCe6FoaOTky4WL26drKXNTH8xturUBqcwHNx7oFo
         +t+TXHOR0ae6PkjCrWAw0ljWKkClB6O7iIQuydPSq79B0Acsr9Tc1PtzpqpJmAVCbb32
         HOhJL2HN+EWOqKKHJmhXkFQh9PmWjc8n7y7MUpThY8zgi6k3H+V82376OmV0QlF+Dkp1
         jQMJ2OwWSpzuTC7hjLITQQSmcSlDjSZ7PErRtPuavaCR/lSdYRGw3/fwbgUos/Lbtipf
         4VzyY1RYlHO08e/KVAbHW+dxrslGZRcrtopX9D1Ui5G6WQl+bjm15sYgRAo3h+28edUf
         JdKg==
X-Gm-Message-State: AOAM532cSXTQKL5fypJtf9lsx03nG2YgRBAJvHqogqdqoEVs/ugJigiR
        f1RH5lLT8ZuBWH6Fn3zg8bhBgA==
X-Google-Smtp-Source: ABdhPJzVUb/kkKz4xX9b2SpN/rk2/QXWukAxXF6jnULCHWiub9Vfnn7sZ2Fu/H7SPfgKF+vPez+WeQ==
X-Received: by 2002:a17:90a:3ac5:: with SMTP id b63mr1480680pjc.3.1597157147934;
        Tue, 11 Aug 2020 07:45:47 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id bv17sm3003751pjb.0.2020.08.11.07.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 07:45:47 -0700 (PDT)
Subject: Re: possible deadlock in __io_queue_deferred
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     syzbot <syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <00000000000035fdf505ac87b7f9@google.com>
 <76cc7c43-2ebb-180d-c2c8-912972a3f258@kernel.dk>
 <20200811140010.gigc2amchytqmrkk@steredhat>
 <504b4b08-30c1-4ca8-ab3b-c9f0b58f0cfa@kernel.dk>
 <20200811144419.blu4wufu7t4dfqin@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <23b58871-b8b6-9f5c-2a7b-f4bade6dee6e@kernel.dk>
Date:   Tue, 11 Aug 2020 08:45:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811144419.blu4wufu7t4dfqin@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/20 8:44 AM, Stefano Garzarella wrote:
> On Tue, Aug 11, 2020 at 08:21:12AM -0600, Jens Axboe wrote:
>> On 8/11/20 8:00 AM, Stefano Garzarella wrote:
>>> On Mon, Aug 10, 2020 at 09:55:17AM -0600, Jens Axboe wrote:
>>>> On 8/10/20 9:36 AM, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
>>>>> git tree:       upstream
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=14d41e02900000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9d25235bf0162fbc
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=996f91b6ec3812c48042
>>>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133c9006900000
>>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1191cb1a900000
>>>>>
>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>> Reported-by: syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com
>>>>
>>>> Thanks, the below should fix this one.
>>>
>>> Yeah, it seems right to me, since only __io_queue_deferred() (invoked by
>>> io_commit_cqring()) can be called with 'completion_lock' held.
>>
>> Right
>>
>>> Just out of curiosity, while exploring the code I noticed that we call
>>> io_commit_cqring() always with the 'completion_lock' held, except in the
>>> io_poll_* functions.
>>>
>>> That's because then there can't be any concurrency?
>>
>> Do you mean the iopoll functions? Because we're definitely holding it
>> for the io_poll_* functions.
> 
> Right, the only one seems io_iopoll_complete().
> 
> So, IIUC, in this case we are actively polling the level below,
> so there shouldn't be any asynchronous events, is it right?

Right, that's serialized by itself.

-- 
Jens Axboe

