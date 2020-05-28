Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232DD1E6831
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405493AbgE1RG0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 13:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405487AbgE1RGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 13:06:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D567C08C5C8
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 10:06:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s69so3509291pjb.4
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 10:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iT5rezqL21tlOm+HcQxeqnOcsO/zlgv0oQIuL0r2Tvk=;
        b=g9jlowS4x5LkXCCyzKW89bhZzpd8BmLxl9gYLan/bQnsd4kg9oEfQ1ib63qh6qedJx
         zMquSBlwzNj27Yybfr6wpm/mgDZNKRYXWB4heMU2A8oQeETetFue6n8M8vOajW/EREh3
         y/VoYy/8DeejrqHoYxiCO0diBZD6emWH/e+FFADqui9G6uA2H7i5NqxGQdgiOLTRtRHY
         VUMYBYaFSdXRk9WpBqRdWn7kMeaoZ6QqrLiDs0GF6vAy0Qa4ZYlRPKXzkOkN9pXMftlO
         m4cLOwJ2s5TdWy5IyidY3LlpO8YGSaI6OhehiDw2S2sbM3gZmPUC+q7WoeHVMu5R6Hh9
         FQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iT5rezqL21tlOm+HcQxeqnOcsO/zlgv0oQIuL0r2Tvk=;
        b=fiPr2zj4JE2RMUDrYUH6+8Tz517TsN9IV+awtp5SDY4EwxHTK6zDhlMC36GdI+uU3f
         x8VXZKN8G4Re/hze+eLPmgMwQiFnXCsF26HeICUTHbho8kOujn4LUj0V2wn2JzFudX6L
         Hrzov6du40pp+NvWJFPIdMLJFILMNvfwuZMD6TJWWR35r39gQBFzZ/Gi/8nBwLskUgg6
         SUyxa9Q8Jbnv2fdKurnVBdj6lpqSBUpDdg82cOERr1Hq3Re82uctli52RtS/ugJrJT2F
         tHx27qRN/RbGubrPex3RukypiA83k22uv/4a8LQzhdxd55AQTmNcDW59yfNs45yR+RMf
         TZiQ==
X-Gm-Message-State: AOAM533EC65mopG5fb1p5MzUFRsUREpHYj09JS8LJDK9/isHrjsHaF+N
        Y+K7ChcLne8BHTA8lcVLBUkxAXN6btC26Q==
X-Google-Smtp-Source: ABdhPJzBQtX9IkxbTiq9LQQhfAIkNAs+QMc7PlP4FZdv+BJKB7P+GdnfDGUw875LRqPUpzLnyZOlSA==
X-Received: by 2002:a17:90a:8814:: with SMTP id s20mr4988444pjn.74.1590685582354;
        Thu, 28 May 2020 10:06:22 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d2sm4768862pgp.56.2020.05.28.10.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 10:06:21 -0700 (PDT)
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     sedat.dilek@gmail.com
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk>
Date:   Thu, 28 May 2020 11:06:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/20 11:02 AM, Sedat Dilek wrote:
> On Tue, May 26, 2020 at 10:59 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> We technically support this already through io_uring, but it's
>> implemented with a thread backend to support cases where we would
>> block. This isn't ideal.
>>
>> After a few prep patches, the core of this patchset is adding support
>> for async callbacks on page unlock. With this primitive, we can simply
>> retry the IO operation. With io_uring, this works a lot like poll based
>> retry for files that support it. If a page is currently locked and
>> needed, -EIOCBQUEUED is returned with a callback armed. The callers
>> callback is responsible for restarting the operation.
>>
>> With this callback primitive, we can add support for
>> generic_file_buffered_read(), which is what most file systems end up
>> using for buffered reads. XFS/ext4/btrfs/bdev is wired up, but probably
>> trivial to add more.
>>
>> The file flags support for this by setting FMODE_BUF_RASYNC, similar
>> to what we do for FMODE_NOWAIT. Open to suggestions here if this is
>> the preferred method or not.
>>
>> In terms of results, I wrote a small test app that randomly reads 4G
>> of data in 4K chunks from a file hosted by ext4. The app uses a queue
>> depth of 32. If you want to test yourself, you can just use buffered=1
>> with ioengine=io_uring with fio. No application changes are needed to
>> use the more optimized buffered async read.
>>
>> preadv for comparison:
>>         real    1m13.821s
>>         user    0m0.558s
>>         sys     0m11.125s
>>         CPU     ~13%
>>
>> Mainline:
>>         real    0m12.054s
>>         user    0m0.111s
>>         sys     0m5.659s
>>         CPU     ~32% + ~50% == ~82%
>>
>> This patchset:
>>         real    0m9.283s
>>         user    0m0.147s
>>         sys     0m4.619s
>>         CPU     ~52%
>>
>> The CPU numbers are just a rough estimate. For the mainline io_uring
>> run, this includes the app itself and all the threads doing IO on its
>> behalf (32% for the app, ~1.6% per worker and 32 of them). Context
>> switch rate is much smaller with the patchset, since we only have the
>> one task performing IO.
>>
>> Also ran a simple fio based test case, varying the queue depth from 1
>> to 16, doubling every time:
>>
>> [buf-test]
>> filename=/data/file
>> direct=0
>> ioengine=io_uring
>> norandommap
>> rw=randread
>> bs=4k
>> iodepth=${QD}
>> randseed=89
>> runtime=10s
>>
>> QD/Test         Patchset IOPS           Mainline IOPS
>> 1               9046                    8294
>> 2               19.8k                   18.9k
>> 4               39.2k                   28.5k
>> 8               64.4k                   31.4k
>> 16              65.7k                   37.8k
>>
>> Outside of my usual environment, so this is just running on a virtualized
>> NVMe device in qemu, using ext4 as the file system. NVMe isn't very
>> efficient virtualized, so we run out of steam at ~65K which is why we
>> flatline on the patched side (nvme_submit_cmd() eats ~75% of the test app
>> CPU). Before that happens, it's a linear increase. Not shown is context
>> switch rate, which is massively lower with the new code. The old thread
>> offload adds a blocking thread per pending IO, so context rate quickly
>> goes through the roof.
>>
>> The goal here is efficiency. Async thread offload adds latency, and
>> it also adds noticable overhead on items such as adding pages to the
>> page cache. By allowing proper async buffered read support, we don't
>> have X threads hammering on the same inode page cache, we have just
>> the single app actually doing IO.
>>
>> Been beating on this and it's solid for me, and I'm now pretty happy
>> with how it all turned out. Not aware of any missing bits/pieces or
>> code cleanups that need doing.
>>
>> Series can also be found here:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.5
>>
>> or pull from:
>>
>> git://git.kernel.dk/linux-block async-buffered.5
>>
> 
> Hi Jens,
> 
> I have pulled linux-block.git#async-buffered.5 on top of Linux v5.7-rc7.
> 
> From first feelings:
> The booting into the system (until sddm display-login-manager) took a
> bit longer.
> The same after login and booting into KDE/Plasma.

There is no difference for "regular" use cases, only io_uring with
buffered reads will behave differently. So I don't think you have longer
boot times due to this.

> I am building/linking with LLVM/Clang/LLD v10.0.1-rc1 on Debian/testing AMD64.
> 
> Here I have an internal HDD (SATA) and my Debian-system is on an
> external HDD connected via USB-3.0.
> Primarily, I use Ext4-FS.
> 
> As said above is the "emotional" side, but I need some technical instructions.
> 
> How can I see Async Buffer Reads is active on a Ext4-FS-formatted partition?

You can't see that. It'll always be available on ext4 with this series,
and you can watch io_uring instances to see if anyone is using it.

> Do I need a special boot-parameter (GRUB line)?
> 
> Do I need to activate some cool variables via sysfs?
> 
> Do I need to pass an option via fstab entry?

No to all of these, you don't need anything to activate it. You need the
program to use io_uring to do buffered reads.

> Are any Async Buffer Reads related linux-kconfig options not set?
> Which make sense?

No kconfig options are needed.

-- 
Jens Axboe

