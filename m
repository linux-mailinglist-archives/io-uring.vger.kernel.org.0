Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC9D320DD2
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 22:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhBUVNl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 16:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhBUVNk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 16:13:40 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDA3C061786
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 13:13:00 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t11so8915098pgu.8
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 13:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XGOsLiErfxYd1/InqUure7ZZFegbdsVCiWPPvmHL1jQ=;
        b=rzbSTNMpVPCXZzLHL+sy4i7YqojBC6CzlNhGxN/Z0AESXTI4H6eBVI8ETjpdgByGho
         kAT9rPu5sux/kzqFtT5SxfRQgr1zJzZP2lCCMS6z+r23FnX+elS7+d4CNWef/kI4VymT
         Nl7vgCG2S5m4qpRQzdqhPdBzxAFSQF9e0x+uq2wNTCE6Aj/2Lxim3OgLzIY0aGE2In++
         2OBHxUkjNia6QuxejLQs84QDRyRtf0btf8idSToyylp7pVduoPMg4wdCBOWQAA0SC6LD
         ob6BAX5tDEmT/Q0fkkqEj9BJ5mGXdgGXvOJT4Fg6+OyLGCduWbYDDMsamjhzzOUrfxLM
         gCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XGOsLiErfxYd1/InqUure7ZZFegbdsVCiWPPvmHL1jQ=;
        b=mrcrucPqhGLpsT3zkQx7q5UKPNGWilLQHKyqNG5JUsf9D7gmZGpR1zoVVnfw9Nd0GK
         zKTdLuu1A3yHCNNIzw/cNwz0BE0AVbQLbSUJV0UtOKyGncUQIU5EWoN8ZJDtA2hmv5Uo
         QPL8JLBjGhdDHae6nsaFs8rBoA81RVmvxCqiwV8Danqy/hOHPcgMkRocef+JSqTVKfh4
         py7IngPWThmSIkN7qlTFNfBhG8TdfGq2XyFlBnsEdP32EaLV8yhFdwMRmvwEUKdCAcO3
         +WJuCUbLapytXvYlZiuY8ztfcZpITCRRGDQaB8zLDz8KG6kB+eIjVdb5cn2C9nrOs97T
         e41g==
X-Gm-Message-State: AOAM533EVV4jcZ9PUiS43SQvYaGwtr5oEupATDRnwi/bocoK2Ty18dD/
        b4B2GsAAKE9pg9SR02KrJpj+mg==
X-Google-Smtp-Source: ABdhPJw5MqPMqd3CQkEk8Sv2l+wtWCYG2L8ozgrBxT3nTFiE0cEYbdVQSGU22jcHSNwZ3x9d7vnIIg==
X-Received: by 2002:a63:6f8a:: with SMTP id k132mr17687990pgc.59.1613941979229;
        Sun, 21 Feb 2021 13:12:59 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j1sm15721768pjf.26.2021.02.21.13.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 13:12:58 -0800 (PST)
Subject: Re: [PATCH v3 0/2] io_uring: add support for IORING_OP_GETDENTS
To:     David Laight <David.Laight@ACULAB.COM>,
        'Lennert Buytenhek' <buytenh@wantstofly.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>
References: <20210218122640.GA334506@wantstofly.org>
 <247d154f2ba549b88a77daf29ec1791f@AcuMS.aculab.com>
 <28a71bb1-0aac-c166-ade7-93665811d441@kernel.dk>
 <b2227a95338f4d949442970f990205fa@AcuMS.aculab.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de7e79a4-ebbd-4536-ea54-365e26646587@kernel.dk>
Date:   Sun, 21 Feb 2021 14:12:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b2227a95338f4d949442970f990205fa@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/21 12:38 PM, David Laight wrote:
> From: Jens Axboe
>> Sent: 20 February 2021 18:29
>>
>> On 2/20/21 10:44 AM, David Laight wrote:
>>> From: Lennert Buytenhek
>>>> Sent: 18 February 2021 12:27
>>>>
>>>> These patches add support for IORING_OP_GETDENTS, which is a new io_uring
>>>> opcode that more or less does an lseek(sqe->fd, sqe->off, SEEK_SET)
>>>> followed by a getdents64(sqe->fd, (void *)sqe->addr, sqe->len).
>>>>
>>>> A dumb test program for IORING_OP_GETDENTS is available here:
>>>>
>>>> 	https://krautbox.wantstofly.org/~buytenh/uringfind-v2.c
>>>>
>>>> This test program does something along the lines of what find(1) does:
>>>> it scans recursively through a directory tree and prints the names of
>>>> all directories and files it encounters along the way -- but then using
>>>> io_uring.  (The io_uring version prints the names of encountered files and
>>>> directories in an order that's determined by SQE completion order, which
>>>> is somewhat nondeterministic and likely to differ between runs.)
>>>>
>>>> On a directory tree with 14-odd million files in it that's on a
>>>> six-drive (spinning disk) btrfs raid, find(1) takes:
>>>>
>>>> 	# echo 3 > /proc/sys/vm/drop_caches
>>>> 	# time find /mnt/repo > /dev/null
>>>>
>>>> 	real    24m7.815s
>>>> 	user    0m15.015s
>>>> 	sys     0m48.340s
>>>> 	#
>>>>
>>>> And the io_uring version takes:
>>>>
>>>> 	# echo 3 > /proc/sys/vm/drop_caches
>>>> 	# time ./uringfind /mnt/repo > /dev/null
>>>>
>>>> 	real    10m29.064s
>>>> 	user    0m4.347s
>>>> 	sys     0m1.677s
>>>> 	#
>>>
>>> While there may be uses for IORING_OP_GETDENTS are you sure your
>>> test is comparing like with like?
>>> The underlying work has to be done in either case, so you are
>>> swapping system calls for code complexity.
>>
>> What complexity?
> 
> Evan adding commands to a list to execute later is 'complexity'.
> As in adding more cpu cycles.

That's a pretty blanket statement. If the list is heavily shared, and
hence contended, yes that's generally true. But it isn't.

>>> I suspect that find is actually doing a stat() call on every
>>> directory entry and that your io_uring example is just believing
>>> the 'directory' flag returned in the directory entry for most
>>> modern filesystems.
>>
>> While that may be true (find doing stat as well), the runtime is
>> clearly dominated by IO. Adding a stat on top would be an extra
>> copy, but no extra IO.
> 
> I'd expect stat() to require the disk inode be read into memory.
> getdents() only requires the data of the directory be read.
> So calling stat() requires a lot more IO.

I actually went and checked instead of guessing, and find isn't doing a
stat by default on the files.

> The other thing I just realises is that the 'system time'
> output from time is completely meaningless for the io_uring case.
> All that processing is done by a kernel thread and I doubt
> is re-attributed to the user process.

For sure, you can't directly compare the sys times. But the actual
runtime is of course directly comparable. The actual example is btrfs,
which heavily offloads to threads as well. So the find case doesn't show
you the full picture either. Note that once the reworked worker scheme
is adopted, sys time will be directly attributed to the original task
and it will be included (for io_uring, not talking about btrfs).

I'm going to ignore the rest of this email as it isn't productive going
down that path. Suffice it to say that ideally _no_ operations will be
using the async offload, that's really only for regular file IO where
you cannot poll for readiness. And even those cases are gradually being
improved to not rely on it, like for async buffered reads. We still
need to handle writes better, and ideally things like this as well. But
that's a bit further out.

-- 
Jens Axboe

