Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD6403E47
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 19:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245273AbhIHRWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 13:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbhIHRWG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 13:22:06 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A681CC061757
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 10:20:58 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id y18so4303357ioc.1
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 10:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=R/b0I+ce/m50yXmZCAAUVXsudiTnZHVC+UYIpQAkofU=;
        b=RqEQ17a1IvDgvMT41ZsUWvOO/WWGTXlRldkOuUAcdbtUH0g7rWkTc8I+1NUs7gFebA
         Q4dSj3VJvSzussdO/AV8v8qD562aDHkS4aFTEMDy3gwBeupCSJ/jTFN2v4OMOnmW3JdF
         zIGaGBOwUhanURfvn4xt6BvBar1xZIUlSn89K7oZgtMd1yz0jlSPzpTu8q6hLDQBaf/z
         L1Tbo1mLmvGQ6LT0hFk7Ofas5e0cwB3isas2/vCHsbBtwpNh7NadXGbm/g2gle6x9d4s
         IR/Knqd5ifme4vOPPZswEmV2g/GR9AqyvNopIcAQT/Hd04TuKz8fhsWAoLkw3tlrSA2A
         blLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R/b0I+ce/m50yXmZCAAUVXsudiTnZHVC+UYIpQAkofU=;
        b=QJkFiUJ9/iL+zx61rNURdxwsNNTE9My9MqP5lX87+jZBE+zEYN45zuSHFzUxeSMZF7
         etwg+xDjyh9b6Jw7yHt9y4XeZJBHk0FSgYzuUCqDK5eZ1/wmHWgDwMovGt6DuXY3F+Na
         u6wZUGp2HlHuTHo4pIIgENdaStvQ4IGHCb2IMWicfrlQSrGTWlDCHUPW4VhBImCsqj98
         vBItNeiWC1AzMitNYwHmQtIeW597i+Wc8LvJ+6pRgTZyfAibEx1ZFzJv3rFGBMjkyXrd
         XopvgdCltlaVUNPNnwP2P/9jPQ12AYQ1YOcBQzEH4gblZ1VDrJWc016x5SQiUeF7ofWe
         RWxA==
X-Gm-Message-State: AOAM532jXpxZhzAYn1oGg69MDtnEK1OGZ81zk+8kPty6dTAnTYjPZ7Eu
        yN3HQSJ6KTnnFqytfBpCRgkZdYAf+Jz2fA==
X-Google-Smtp-Source: ABdhPJwiUwDMXW5fQOYAbdh+oUeNWCXrjOuoFC83e4+i8iW70uTSEAzcSFBOQ05PaQOOVxPlOJjChA==
X-Received: by 2002:a6b:8e50:: with SMTP id q77mr822319iod.96.1631121657806;
        Wed, 08 Sep 2021 10:20:57 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j10sm1308638ilk.84.2021.09.08.10.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 10:20:57 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in hrtimer_start_range_ns
From:   Jens Axboe <axboe@kernel.dk>
To:     Thomas Gleixner <tglx@linutronix.de>,
        syzbot <syzbot+b935db3fe409625cca1b@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        io-uring@vger.kernel.org
References: <0000000000009eeadd05cb511b60@google.com> <875yvbf23g.ffs@tglx>
 <8bbede01-4a97-bf22-92ad-c05a562c9799@kernel.dk>
Message-ID: <111a312d-ec11-be36-ac74-ef92c8896967@kernel.dk>
Date:   Wed, 8 Sep 2021 11:20:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8bbede01-4a97-bf22-92ad-c05a562c9799@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 11:02 AM, Jens Axboe wrote:
> On 9/8/21 10:45 AM, Thomas Gleixner wrote:
>> On Mon, Sep 06 2021 at 03:28, syzbot wrote:
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    835d31d319d9 Merge tag 'media/v5.15-1' of git://git.kernel..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=14489886300000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d793523866f2daea
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b935db3fe409625cca1b
>>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>>>
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+b935db3fe409625cca1b@syzkaller.appspotmail.com
>>>
>>> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
>>> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>>> CPU: 0 PID: 12936 Comm: iou-sqp-12929 Not tainted 5.14.0-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> RIP: 0010:lock_hrtimer_base kernel/time/hrtimer.c:173 [inline]
>>
>> That's almost certainly deferencing hrtimer->base and as that is NULL
>> this looks like a not initialized hrtimer.
> 
> Does certainly look like that, I'll take a look. And agree the next one
> looks like the same thing.

I think both are fallout from a regression that we had in linked
requests, where we'd queue requests that weren't fully prepared. Current
Linus -git should not have this problem:

These were the two related fixes:

      io_uring: fix queueing half-created requests
      io_uring: don't submit half-prepared drain request

-- 
Jens Axboe

