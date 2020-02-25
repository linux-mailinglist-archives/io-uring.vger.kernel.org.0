Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2D216B7F3
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 04:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYDNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 22:13:19 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41919 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgBYDNT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 22:13:19 -0500
Received: by mail-pg1-f193.google.com with SMTP id 70so6153387pgf.8
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 19:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0F1o25Xj6KNzEpQatqLPwN2yUZ1zRsRORz30vzS5dHc=;
        b=xg2Ky5f4jhru5tqUOiPJADsSlukZXzwb6IbQckObB9mFcTHC8CI5w25+ZCcBVGFLAZ
         iRFX9WCr8tgzuaBM7Vi07E+LfAK9LfQT3L2vfPhThCy6cRZFHRWCijP6Ky5hI1BOGeqX
         2rnK8fYWf2+1X8Rjr882bi/hjqCkNPk85/w8noZC4pZzpl96Mn0hYxq2MT+sJLbJvFjb
         WgcRKN+eiZKhhmTzeJHsPXQDShVj81sIHzfbXWEczLTmsbPiN9Yu5gmX7HbbjI8jYLTc
         boaDBqTFbXcqtJy90HAv4eg29vUpLuGasMXYNxFBfYVwkDCMLBnBBQ+qMDQIXENwn3ES
         rOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0F1o25Xj6KNzEpQatqLPwN2yUZ1zRsRORz30vzS5dHc=;
        b=KacAxPCMtFNAD/94QFIHPwfEw7sdGYh7cb7nZ4eY6kw/PHli2ryAMI7LBhA/RZJt1b
         a9JzbwYm+EsE73ekSjaJcx1CNAva2eLNK1twfmWIApi9H45660fr50LJHTIlPLmk+JJo
         8Lu4qHUXKf4HK06fIXHafCT2y2jhUkSKZ0KyMwdpl2gomX16VOqNr82+IycYhOYTAEtJ
         OEKfSU3pGC9j8WxkFUCLUMcMaPdx32qrSxe+h59FgJmVOr4WVt0y2io0M0bCpCFh1C97
         4UJAwhwX6ZtKAs06xpLE2Hq8LZFNa9sgID2oGOSxDdf3MIhdG2YwPGu8zrcy9Y6yJVvn
         JtqQ==
X-Gm-Message-State: APjAAAVsJlhoshkH7V/hbuKislhm2/IML4IvzndEbMvizNhWRWAxqLRE
        jVzCrUBg0GStTuRNHCWwQhLTD5VFD2s=
X-Google-Smtp-Source: APXvYqwAzlMOQf6mG9o/EE1rorpwupYhI1mkulCe1DmsjxtN7um6biO1WOh8j7//52T4xTalAAROFA==
X-Received: by 2002:a65:6402:: with SMTP id a2mr57405074pgv.142.1582600398045;
        Mon, 24 Feb 2020 19:13:18 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 64sm14387572pfd.48.2020.02.24.19.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 19:13:17 -0800 (PST)
Subject: Re: [RFC] single cqe per link
From:   Jens Axboe <axboe@kernel.dk>
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
 <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
 <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
Message-ID: <56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk>
Date:   Mon, 24 Feb 2020 20:13:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 7:36 PM, Jens Axboe wrote:
> On 2/24/20 7:14 PM, Carter Li 李通洲 wrote:
>>> 2020年2月25日 上午8:39，Pavel Begunkov <asml.silence@gmail.com> 写道：
>>>
>>> I've got curious about performance of the idea of having only 1 CQE per link
>>> (for the failed or last one). Tested it with a quick dirty patch doing
>>> submit-and-reap of a nops-link (patched for inline execution).
>>>
>>> 1) link size: 100
>>> old: 206 ns per nop
>>> new: 144 ns per nop
>>>
>>> 2) link size: 10
>>> old: 234 ns per nop
>>> new: 181 ns per nop
>>>
>>> 3) link size: 10, FORCE_ASYNC
>>> old: 667 ns per nop
>>> new: 569 ns per nop
>>>
>>>
>>> The patch below breaks sequences, linked_timeout and who knows what else.
>>> The first one requires synchronisation/atomic, so it's a bit in the way. I've
>>> been wondering, whether IOSQE_IO_DRAIN is popular and how much it's used. We can
>>> try to find tradeoff or even disable it with this feature.
>>
>> Hello Pavel,
>>
>> I still think flags tagged on sqes could be a better choice, which
>> gives users an ability to deside if they want to ignore the cqes, not
>> only for links, but also for normal sqes.
>>
>> In addition, boxed cqes couldn’t resolve the issue of
>> IORING_IO_TIMEOUT.
> 
> I would tend to agree, and it'd be trivial to just set the flag on
> whatever SQEs in the chain you don't care about. Or even an individual
> SQE, though that's probably a bit more of a reach in terms of use case.
> Maybe nop with drain + ignore?
> 
> In any case it's definitely more flexible.

In the interest of taking this to the extreme, I tried a nop benchmark
on my laptop (qemu/kvm). Granted, this setup is particularly sensitive
to spinlocks, they are a lot more expensive there than on a real host.

Anyway, regular nops run at about 9.5M/sec with a single thread.
Flagging all SQEs with IOSQE_NO_CQE nets me about 14M/sec. So a handy
improvement. Looking at the top of profiles:

cqe-per-sqe:

+   28.45%  io_uring  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
+   14.38%  io_uring  [kernel.kallsyms]  [k] io_submit_sqes
+    9.38%  io_uring  [kernel.kallsyms]  [k] io_put_req
+    7.25%  io_uring  libc-2.31.so       [.] syscall
+    6.12%  io_uring  [kernel.kallsyms]  [k] kmem_cache_free

no-cqes:

+   19.72%  io_uring  [kernel.kallsyms]  [k] io_put_req
+   11.93%  io_uring  [kernel.kallsyms]  [k] io_submit_sqes
+   10.14%  io_uring  [kernel.kallsyms]  [k] kmem_cache_free
+    9.55%  io_uring  libc-2.31.so       [.] syscall
+    7.48%  io_uring  [kernel.kallsyms]  [k] __io_queue_sqe

I'll try the real disk IO tomorrow, using polled IO.

-- 
Jens Axboe

