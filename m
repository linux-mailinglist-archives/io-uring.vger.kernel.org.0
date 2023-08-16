Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8C377E3B0
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 16:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243319AbjHPOe1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 10:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343661AbjHPOeC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 10:34:02 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7872723
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 07:34:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bdf1abee23so3418045ad.0
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 07:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692196440; x=1692801240;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9xT590qt7mm5MjOfdptQw7aCHYsf9L28vWl7CnKdAfo=;
        b=tGxJKLaRk78eiDLkNJ3AXJlRfK7xE2WRPZVwt5ilh67dmje8JSt7+0ZKd2daAgaNnv
         iemXHsEmrebskERFFpQ4yEt+5QdcaqmbItOocaVf/iP/S2r+pNgJVueTEjdBhvl1t2LW
         be91ntwsnifGb1w5nbNKggNOEWh31XtMkrbjjmHKBR9aEIyQ25+lZ2MZXm9PbnYRcT6+
         416ntk1rQIRQdC+hcTWB4WPFw6MhuY98wRo3OF1s3ngev0ngUdAMuTmvg7vY1wqaM7Zq
         5Cvor9qFy4E7Pg/jzh7TyYxjcH3OjOgPnNlKXFMBpeucJyGcNVdhUNU9H361Lz8YXsZi
         Ewdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692196440; x=1692801240;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xT590qt7mm5MjOfdptQw7aCHYsf9L28vWl7CnKdAfo=;
        b=HlqYa8Y5JrQf7iiNbDzi+Zg6ABT7ybcgJ6fxziJF+DmGz3EPTOztXjIvYfRUDBLxbK
         WUnxEtoagIGOXyyDTRCr0wtq9XoU/t3ptuxZbLgNsK1cHEwbDVDopehCfUzM6fBd5rnb
         vOOWXFOI+tSARrJZrDym9lgLXWZkpQdKy+LYCXAeC0abpQlUuflmqbEC8sPLqhPtVgKl
         jiUp5y5JDTqM1HKDP/5f+yzVPunAbQBvXMCRn/Iu2kluFQlhC0Dh8fKgdFhy1uQIFh9v
         B6VNat2VaWE3gbX3DnL2a2t9Rq+VcKEnWr+J2bXwkjaTipWxCyhQ11igavxcBwVOlM+3
         oVHw==
X-Gm-Message-State: AOJu0YzNSxedaMs4i5ojnYoPsIV0EGt0sOfk6aFIOJQdrmpIkXsNGkff
        Nco0YoGpE6d5g4xJBn2zK4QgrDYScdqGh0ld6+o=
X-Google-Smtp-Source: AGHT+IFFzY/fKIJquyk/ZnCDVEKZJuhnOKZ/7pZBqB86zRH/6r911IQ3VsBKdP+GbbaybPCcGEvIRw==
X-Received: by 2002:a17:902:e5c9:b0:1bc:496c:8eda with SMTP id u9-20020a170902e5c900b001bc496c8edamr2218206plf.4.1692196440328;
        Wed, 16 Aug 2023 07:34:00 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y22-20020a1709027c9600b001b8a85489a3sm13164080pll.262.2023.08.16.07.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 07:33:59 -0700 (PDT)
Message-ID: <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
Date:   Wed, 16 Aug 2023 08:33:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 12:52 AM, Qu Wenruo wrote:
> Hi,
> 
> Recently I'm digging into a very rare failure during btrfs/06[234567],
> where btrfs scrub detects unrepairable data corruption.
> 
> After days of digging, I have a much smaller reproducer:
> 
> ```
> fail()
> {
>         echo "!!! FAILED !!!"
>         exit 1
> }
> 
> workload()
> {
>         mkfs.btrfs -f -m single -d single --csum sha256 $dev1
>         mount $dev1 $mnt
>     # There are around 10 more combinations with different
>         # seed and -p/-n parameters, but this is the smallest one
>     # I found so far.
>     $fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt
>     umount $mnt
>     btrfs check --check-data-csum $dev1 || fail
> }
> runtime=1024
> for (( i = 0; i < $runtime; i++ )); do
>         echo "=== $i / $runtime ==="
>         workload
> done
> ```

Tried to reproduce this, both on a vm and on a real host, and no luck so
far. I've got a few followup questions as your report is missing some
important info:

1) What kernel are you running?
2) What's the .config you are using?

> At least here, with a VM with 6 cores (host has 8C/16T), fast enough
> storage (PCIE4.0 NVME, with unsafe cache mode), it has the chance around
> 1/100 to hit the error.

What does "unsafe cche mode" mean? Is that write back caching enabled?
Write back caching with volatile write cache? For your device, can you
do:

$ grep . /sys/block/$dev/queue/*

> Checking the fsstress verbose log against the failed file, it turns out
> to be an io_uring write.

Any more details on what the write looks like?

> And with uring_write disabled in fsstress, I have no longer reproduced
> the csum mismatch, even with much larger -n and -p parameters.

Is it more likely to reproduce with larger -n/-p in general?

> However I didn't see any io_uring related callback inside btrfs code,
> any advice on the io_uring part would be appreciated.

io_uring doesn't do anything special here, it uses the normal page cache
read/write parts for buffered IO. But you may get extra parallellism
with io_uring here. For example, with the buffered write that this most
likely is, libaio would be exactly the same as a pwrite(2) on the file.
If this would've blocked, io_uring would offload this to a helper
thread. Depending on the workload, you could have multiple of those in
progress at the same time.

-- 
Jens Axboe

