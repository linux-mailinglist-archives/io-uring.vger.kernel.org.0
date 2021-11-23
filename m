Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE9B45A220
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 13:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhKWMFQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 07:05:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233959AbhKWMFP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 07:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637668927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdNCVm5I+Q2tdRBLAErQwYJMGPXNfC9Gg37QHqIgOLg=;
        b=GNzlh+KjSmxEvh5YfaWlwTJ7rCv+VhxN03aLBi5lpe9TiNp9Q+Uduz5+DE+8uVwj+j9ShV
        jr+/LiJMZHSyad3qVMjLPKtDb0KdRn2zTCm/1RV47Kbg2/PzSDDXw6pUm8gSUzgXYjjmIu
        Jt6UeicuBYW8VhE5FabPIhifR9x8p1k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-Jh60Pg6bPrWwGNCnJxlbOg-1; Tue, 23 Nov 2021 07:02:06 -0500
X-MC-Unique: Jh60Pg6bPrWwGNCnJxlbOg-1
Received: by mail-wm1-f69.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so1400011wmq.9
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 04:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=JdNCVm5I+Q2tdRBLAErQwYJMGPXNfC9Gg37QHqIgOLg=;
        b=Oxb5W89z1gcsllX6BMN4buIM+Ql8OoAJePn87VtEFrIKTXrFOm3tZKpn1nPAz0tj+e
         i9faNhnWnJANFFubPcD6LWJ+ZlSTmaWajA9YGglGcKzb3e+JMK7vLsUaR4NsMfYNBoaW
         aPoX9BY2Zyf2ENQ77l14izTLkRXcRL+DIesjAKBzQeoWoz8UcfGJIp+aoaWl8VeA3dCo
         +tbBBgN9+fnJ6wgGLLZwZb3FYURFLIDWmit4aAQFWQlgeAKu64i0RhBtyNL/7a5T9238
         P/WcYHBf/3cj8QeI7CGCT/Tsv+oSTOYBafrv7dfp9C54PCWjBjjNta/i7dOkuROJEiWu
         oLrw==
X-Gm-Message-State: AOAM532smNcOkFgHXa+6x0p/Eer/3lNMREBxgHOpv3Js6c6M7+lzf8Nu
        D8t/mpdbCHtOrEB/p4LUHl0h6gwcaErq0Rryo8QngTeMXZvuYCqcN7Qfo2Gv3eCGxxGxvZOCJeJ
        54J7G+B6Ud8QLP95mQJk=
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr2408115wme.182.1637668925101;
        Tue, 23 Nov 2021 04:02:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4X+d0sHyk7qvzIlv4QXcrhMXR7T+rdEozr8VusV5WWhJueU/JGKC/I3FJqrdQaE2c0TuMzg==
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr2408050wme.182.1637668924714;
        Tue, 23 Nov 2021 04:02:04 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6765.dip0.t-ipconnect.de. [91.12.103.101])
        by smtp.gmail.com with ESMTPSA id l5sm1074222wms.16.2021.11.23.04.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 04:02:04 -0800 (PST)
Message-ID: <4409acf9-4927-861e-997a-6e3db42d6851@redhat.com>
Date:   Tue, 23 Nov 2021 13:02:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <CFQZSHV700KV.18Y62SACP8KOO@taiga>
 <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
 <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
 <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
 <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
 <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
 <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
 <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
 <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
 <3adc55d3-f383-efa9-7319-740fc6ab5d7a@kernel.dk>
 <ffa66565-d546-a2cf-1748-38b9992fd5b8@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
In-Reply-To: <ffa66565-d546-a2cf-1748-38b9992fd5b8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

>>>>
>>>> We should just make this 0.1% of RAM (min(0.1% ram, 64KB)) or something
>>>> like what was suggested, if that will help move things forward. IMHO the
>>>> 32MB machine is mostly a theoretical case, but whatever .
>>>
>>> 1) I'm deeply concerned about large ZONE_MOVABLE and MIGRATE_CMA ranges
>>> where FOLL_LONGTERM cannot be used, as that memory is not available.
>>>
>>> 2) With 0.1% RAM it's sufficient to start 1000 processes to break any
>>> system completely and deeply mess up the MM. Oh my.
>>
>> We're talking per-user limits here. But if you want to talk hyperbole,
>> then 64K multiplied by some other random number will also allow
>> everything to be pinned, potentially.
>>
> 
> Right, it's per-user. 0.1% per user FOLL_LONGTERM locked into memory in
> the worst case.
> 

To make it clear why I keep complaining about FOLL_LONGTERM for
unprivileged users even if we're talking about "only" 0.1% of RAM ...

On x86-64 a 2 MiB THP (IOW pageblock) has 512 sub-pages. If we manage to
FOLL_LONGTERM a single sub-page, we can make the THP unavailable to the
system, meaning we cannot form a THP by
compaction/swapping/migration/whatever at that physical memory area
until we unpin that single page. We essentially "block" a THP from
forming at that physical memory area.

So with a single 4k page we can block one 2 MiB THP. With 0.1% we can,
therefore, block 51,2 % of all THP. Theoretically, of course, if the
stars align.


... or if we're malicious or unlucky. I wrote a reproducer this morning
that tries blocking as many THP as it can:

https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/io_uring_thp.c

------------------------------------------------------------------------

Example on my 16 GiB (8096 THP "in theory") notebook with some
applications running in the background.

$ uname -a
Linux t480s 5.14.16-201.fc34.x86_64 #1 SMP Wed Nov 3 13:57:29 UTC 2021
x86_64 x86_64 x86_64 GNU/Linux

$ ./io_uring_thp
PAGE size: 4096 bytes (sensed)
THP size: 2097152 bytes (sensed)
RLIMIT_MEMLOCK: 16777216 bytes (sensed)
IORING_MAX_REG_BUFFERS: 16384 (guess)
Pages per THP: 512
User can block 4096 THP (8589934592 bytes)
Process can block 4096 THP (8589934592 bytes)
Blocking 1 THP
Blocking 2 THP
...
Blocking 3438 THP
Blocking 3439 THP
Blocking 3440 THP
Blocking 3441 THP
Blocking 3442 THP
... and after a while
Blocking 4093 THP
Blocking 4094 THP
Blocking 4095 THP
Blocking 4096 THP

$ cat /proc/`pgrep io_uring_thp`/status
Name:   io_uring_thp
Umask:  0002
State:  S (sleeping)
[...]
VmPeak:     6496 kB
VmSize:     6496 kB
VmLck:         0 kB
VmPin:     16384 kB
VmHWM:      3628 kB
VmRSS:      1580 kB
RssAnon:             160 kB
RssFile:            1420 kB
RssShmem:              0 kB
VmData:     4304 kB
VmStk:       136 kB
VmExe:         8 kB
VmLib:      1488 kB
VmPTE:        48 kB
VmSwap:        0 kB
HugetlbPages:          0 kB
CoreDumping:    0
THP_enabled:    1

$ cat /proc/meminfo
MemTotal:       16250920 kB
MemFree:        11648016 kB
MemAvailable:   11972196 kB
Buffers:           50480 kB
Cached:          1156768 kB
SwapCached:        54680 kB
Active:           704788 kB
Inactive:        3477576 kB
Active(anon):     427716 kB
Inactive(anon):  3207604 kB
Active(file):     277072 kB
Inactive(file):   269972 kB
...
Mlocked:            5692 kB
SwapTotal:       8200188 kB
SwapFree:        7742716 kB
...
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB


Let's see how many contiguous 2M pages we can still get as root:
$ echo 1 > /proc/sys/vm/compact_memory
$ cat
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
0
$ echo 8192 >
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
$ cat
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
537
... keep retrying a couple of times
 $ cat
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
583

Let's kill the io_uring process and try again:

$ echo 8192 >
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
$ cat
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
4766
... keep retrying a couple of times
$ echo 8192 >
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
$ cat
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
4823

------------------------------------------------------------------------

I'm going to leave judgment how bad this is or isn't to the educated
reader, and I'll stop spending time on this as I have more important
things to work on.


To summarize my humble opinion:

1) I am not against raising the default memlock limit if it's for a sane
use case. While mlock itself can be somewhat bad for swap, FOLL_LONGTERM
that also checks the memlock limit here is the real issue. This patch
explicitly states the "IOURING_REGISTER_BUFFERS" use case, though, and
that makes me nervous.

2) Exposing FOLL_LONGTERM to unprivileged users should be avoided best
we can; in an ideal world, we wouldn't have it at all; in a sub-optimal
world we'd have it only for use cases that really require it due to HW
limitations. Ideally we'd even have yet another limit for this, because
mlock != FOLL_LONGTERM.

3) IOURING_REGISTER_BUFFERS shouldn't use FOLL_LONGTERM for use by
unprivileged users. We should provide a variant that doesn't rely on
FOLL_LONGTERM or even rely on the memlock limit.


Sorry to the patch author for bringing it up as response to the patch.
After this patch just does what some distros already do (many distros
even provide higher limits than 8 MiB!). I would be curious why some
distros already have such high values ... and if it's already because of
IOURING_REGISTER_BUFFERS after all.

-- 
Thanks,

David / dhildenb

