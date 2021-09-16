Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2316340D11E
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 03:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhIPBRS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 21:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbhIPBRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 21:17:17 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA52CC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:15:57 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id j18so5861086ioj.8
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M/faTXn1SjxhQ6qy0K7k7cEDFuF/xWQ+SaNiUztry3E=;
        b=f8Bad83/dhUbPcl5woEiHQX906D4Aj+o/zHxmqsOgB41wrxlxjc0audgP6zL0p9982
         qTLDmgygGzYYQBsT0URy1BPFHjvmr/BQa/onawExPiPX/txTCJin7SAJ8H7HNC3FopxP
         WNPIn3CxnfJYcCX13SwSvtohe5cwbsMxBU31bXbsgVRIIFBKitd3CetkIljP07vMwO0p
         CC7SE9THGdh+JdbD4NDCVwbUI4N/v2jlrwfYhksk2OxXNHRazExXcabXFbqzl3NiOXZ9
         uJVwSm9cgnwPmUunqku5pwaStwHjzbJFqu+ZWeq+mJQD0M+hLtgHz0PPyoI3lBJLzNrt
         pdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M/faTXn1SjxhQ6qy0K7k7cEDFuF/xWQ+SaNiUztry3E=;
        b=JBS3re6s0KEDRUY8IS4RPSrnABhTOGm+MN3EHB8sIKmY/i3iZFp5dYBGhLUUEgw8DM
         XTIdJOJDMjvfMHdpAsUw0jRRNhGQkKG3bXR4zbYzb3/RAIUtaVHtYuUdF9M1QQ7p+i+r
         8gcM2QQxtg6xxm3/ht7loAd5EC2Z1BjztvpedwaKMgZoENeiy1LsbQBdtluZZQAk+51j
         y2C4uNny4ZohFpq/ut9kqIjwa8MA8M38SVLdTJf6sw+C8omOvKAkEOBWuVcRHYdBivoO
         er8JWCIJK4AZDhL+TpyU6dviXTXgd32dsskjC1BCaiU8ioScYh7G0oXwZPoYlTElAei0
         fMDA==
X-Gm-Message-State: AOAM531xI+BblKtyn7qibEAg4nFdCHLimUfowtaqOZofdohq4Rh8lLgW
        +D2nzfJuFmoJeEx5st2o9N0C2Q==
X-Google-Smtp-Source: ABdhPJyny3E+qnxtdslVv9if67lLF19B5P6BRbTH4bpCoZxEdMEnIAEBPDrtQ9+xByxHA02NUNIU6w==
X-Received: by 2002:a6b:5c0c:: with SMTP id z12mr2337797ioh.171.1631754957054;
        Wed, 15 Sep 2021 18:15:57 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e22sm815282iob.52.2021.09.15.18.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 18:15:56 -0700 (PDT)
Subject: Re: [PATCHSET v3 0/3] Add ability to save/restore iov_iter state
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210915162937.777002-1-axboe@kernel.dk>
 <CAHk-=wgtROzcks4cozeEYG33UU1Q3T4RM-k3kv-GqrdLKFMoLw@mail.gmail.com>
 <8c7c8aa0-9591-a50f-35ee-de0037df858a@kernel.dk>
 <CAHk-=wj3dsQMK4y-EeMD1Zyod7=Sv68UqrND-GYgHXx6wNRawA@mail.gmail.com>
 <6688d40c-b359-364b-cdff-1e0714eb6945@kernel.dk>
 <f6349daf-2180-241d-54aa-adbfd955c5fa@kernel.dk>
Message-ID: <3beb1715-84da-ae33-7d99-406df463b508@kernel.dk>
Date:   Wed, 15 Sep 2021 19:15:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f6349daf-2180-241d-54aa-adbfd955c5fa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 4:42 PM, Jens Axboe wrote:
> On 9/15/21 1:40 PM, Jens Axboe wrote:
>> On 9/15/21 1:26 PM, Linus Torvalds wrote:
>>> On Wed, Sep 15, 2021 at 11:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>    The usual tests
>>>> do end up hitting the -EAGAIN path quite easily for certain device
>>>> types, but not the short read/write.
>>>
>>> No way to do something like "read in file to make sure it's cached,
>>> then invalidate caches from position X with POSIX_FADV_DONTNEED, then
>>> do a read that crosses that cached/uncached boundary"?
>>>
>>> To at least verify that "partly synchronous, but partly punted to
>>> async" case?
>>>
>>> Or were you talking about some other situation?
>>
>> No that covers some of it, and that happens naturally with buffered IO.
>> The typical case is -EAGAIN on the first try, then you get a partial
>> or all of it the next loop, and then done or continue. I tend to run
>> fio verification workloads for that, as you get all the flexibility
>> of fio with the data verification. And there are tests in there that run
>> DONTNEED in parallel with buffered IO, exactly to catch some of these
>> csaes. But they don't verify the data, generally.
>>
>> In that sense buffered is a lot easier than O_DIRECT, as it's easier to
>> provoke these cases. And that does hit all the save/restore parts and
>> looping, and if you do it with registered buffers then you get to work
>> with bvec iter as well. O_DIRECT may get you -EAGAIN for low queue depth
>> devices, but it'll never do a short read/write after that. 
>>
>> But that's not in the regressions tests. I'll write a test case
>> that can go with the liburing regressions for it.
> 
> OK I wrote one, quick'n dirty. It's written as a liburing test, which
> means it can take no arguments (in which case it creates a 128MB file),
> or it can take an argument and it'll use that argument as the file. We
> fill the first 128MB of the file with known data, basically the offset
> of the file. Then we read it back in any of the following ways:
> 
> 1) Using non-vectored read
> 2) Using vectored read, segments that fit in UIO_FASTIOV
> 3) Using vectored read, segments larger than UIO_FASTIOV
> 
> This catches all the different cases for a read.
> 
> We do that with both buffered and O_DIRECT, and before each pass, we
> randomly DONTNEED either the first, middle, or end part of each segment
> in the read size.
> 
> I ran this on my laptop, and I found this:
> axboe@p1 ~/gi/liburing (master)> test/file-verify                                0.100s
> bad read 229376, read 3
> Buffered novec test failed
> axboe@p1 ~/gi/liburing (master)> test/file-verify                                0.213s
> bad read 294912, read 0
> Buffered novec test failed
> 
> which is because I'm running the iov_iter.2 stuff, and we're hitting
> that double accounting issue that I mentioned in the cover letter for
> this series. That's why the read return is larger than we ask for
> (128K). Running it on the current branch passes:
> 
> [root@archlinux liburing]# for i in $(seq 10); do test/file-verify; done
> [root@archlinux liburing]# 
> 
> (this is in my test vm that I run on the laptop for kernel testing,
> hence the root and different hostname).
> 
> I will add this as a liburing regression test case. Probably needs a bit
> of cleaning up first, it was just a quick prototype as I thought your
> suggestion was a good one. Will probably change it to run at a higher
> queue depth than just the 1 it does now.

Cleaned it up a bit, and added registered buffer support as well (which
is another variant over non-vectored reads) and queued IO support as
well:

https://git.kernel.dk/cgit/liburing/commit/?id=6ab387dab745aff2af760d9fed56a4154669edec

and it's now part of the regular testing. Here's my usual run:

Running test file-verify                                            3 sec
Running test file-verify /dev/nvme0n1p2                             3 sec
Running test file-verify /dev/nvme1n1p1                             3 sec
Running test file-verify /dev/sdc2                                  Test file-verify timed out (may not be a failure)
Running test file-verify /dev/dm-0                                  3 sec
Running test file-verify /data/file                                 3 sec

Note that the sdc2 timeout isn't a failure, it's just that emulation on
qemu is slow enough that it takes 1min20s to run and I time out tests
after 60s in the harness to prevent something stalling forever.

-- 
Jens Axboe

