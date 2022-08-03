Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037855893A4
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 22:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbiHCUwP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 16:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238296AbiHCUwO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 16:52:14 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F182631F
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 13:52:13 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d139so78046iof.4
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 13:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f+kJgdEkgp30bWaERe4Vski1FE7alwIJq4u2OppbQ/w=;
        b=nj16+e5UJJcV/iFA34nUwfYrmf8FXuwzPi/8/W6RQw0zoXtOJLIRLvJKTcBTtDpAp/
         0XftVz4Z3LHV5y9B7DUgyqH5zFwxdjo8Qa3qZskoprp3/Wr32nmg3A00IP64hGUy7JsB
         gVanoNCw962W3jg+fblI+m3JBB+U89fbrUB0LEY2pwHWdjynW7Uu3v0jyzTM84dLdNpi
         gGZEl08Ftqzv8r41ziW5svbIDLuiXjiKjUQjeT46l23ys7WOY8x4HjXvzcoJGuH5ZmSV
         roDBz/GQkfq1hWI4DZBtJMD09AWMgMAqwjre2LlcKlDG51KHsv2m4gQRh40jnt8zMDJH
         yHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f+kJgdEkgp30bWaERe4Vski1FE7alwIJq4u2OppbQ/w=;
        b=h3Gq1zXBZ/A7G1FzW91sT/BFrA0VM428eaBDlU7hyBkePZeTgn1yiEUm/5hOrECfmi
         ZfCGbXn71ENzrJ/raooG3cRar95Pyg+qTgSQndxsFl4n3EBDWz3nQD06uuZvxEczyFGG
         VzROSr8k8gzlRgitcoh+pyl8wPvo+PiNjksIteDys/1KvPCNgTN2LBewYjJRR9AVaFzt
         uEvqWqnr3oPFeuCzus81C2a6v016sj6RHla987ee9CKIzDWyX/aLdqpwpOsQ27ydl6eh
         ZjREBUlPXj7+OKQwB3RW0XueimUMHkOpMKdIEr8i3BpXjwAMIUf5R9vM7V6A3qcYV5ba
         0qKg==
X-Gm-Message-State: AJIora9Le0vs4zYaAO5k8rNc525mbjX92juzbGGw8KDCa26WlhDIeoaj
        LFVTNPVIoY+sKHTeB55CVlwkTDG6/xHsUA==
X-Google-Smtp-Source: AGRyM1tXxs7zhlm9Jvu6+p+FJ20VNCh4BqAcQdBeq/oalyDynJMU6/wzgc9VjBlrlK7mjN0rz9uRoQ==
X-Received: by 2002:a5e:d817:0:b0:67c:38a8:8f25 with SMTP id l23-20020a5ed817000000b0067c38a88f25mr9333590iok.123.1659559932393;
        Wed, 03 Aug 2022 13:52:12 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f6-20020a02b786000000b003426eb18d1dsm5183460jam.105.2022.08.03.13.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 13:52:11 -0700 (PDT)
Message-ID: <5f8fc910-8fad-f71a-704b-8017d364d0ed@kernel.dk>
Date:   Wed, 3 Aug 2022 14:52:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCHv2 0/7] dma mapping optimisations
Content-Language: en-US
To:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     hch@lst.de, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
References: <20220802193633.289796-1-kbusch@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220802193633.289796-1-kbusch@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/2/22 1:36 PM, Keith Busch wrote:
> device undergoes various represenations for every IO. Each consumes
> memory and CPU cycles. When the backing storage is NVMe, the sequence
> looks something like the following:
> 
>   __user void *
>   struct iov_iter
>   struct pages[]
>   struct bio_vec[]
>   struct scatterlist[]
>   __le64[]
> 
> Applications will often use the same buffer for many IO, though, so
> these potentially costly per-IO transformations to reach the exact same
> hardware descriptor can be skipped.
> 
> The io_uring interface already provides a way for users to register
> buffers to get to the 'struct bio_vec[]'. That still leaves the
> scatterlist needed for the repeated dma_map_sg(), then transform to
> nvme's PRP list format.
> 
> This series takes the registered buffers a step further. A block driver
> can implement a new .dma_map() callback to complete the representation
> to the hardware's DMA mapped address, and return a cookie so a user can
> reference it later for any given IO. When used, the block stack can skip
> significant amounts of code, improving CPU utilization, and, if not
> bandwidth limited, IOPs.
> 
> The implementation is currently limited to mapping a registered buffer
> to a single file.

I ran this on my test box to see how we'd do. First the bad news:
smaller block size IO seems slower. I ran with QD=8 and used 24 drives,
and using t/io_uring (with registered buffers, polled, etc) and a 512b
block size I get:

IOPS=44.36M, BW=21.66GiB/s, IOS/call=1/1
IOPS=44.64M, BW=21.80GiB/s, IOS/call=2/2
IOPS=44.69M, BW=21.82GiB/s, IOS/call=1/1
IOPS=44.55M, BW=21.75GiB/s, IOS/call=2/2
IOPS=44.93M, BW=21.94GiB/s, IOS/call=1/1
IOPS=44.79M, BW=21.87GiB/s, IOS/call=1/2

and adding -D1 I get:

IOPS=43.74M, BW=21.36GiB/s, IOS/call=1/1
IOPS=44.04M, BW=21.50GiB/s, IOS/call=1/1
IOPS=43.63M, BW=21.30GiB/s, IOS/call=2/2
IOPS=43.67M, BW=21.32GiB/s, IOS/call=1/1
IOPS=43.57M, BW=21.28GiB/s, IOS/call=1/2
IOPS=43.53M, BW=21.25GiB/s, IOS/call=2/1

which does regress that workload. Since we avoid more expensive setup at
higher block sizes, I tested that too. Here's using 128k IOs with -D0:

OPS=972.18K, BW=121.52GiB/s, IOS/call=31/31
IOPS=988.79K, BW=123.60GiB/s, IOS/call=31/31
IOPS=990.40K, BW=123.80GiB/s, IOS/call=31/31
IOPS=987.80K, BW=123.48GiB/s, IOS/call=31/31
IOPS=988.12K, BW=123.52GiB/s, IOS/call=31/31

and here with -D1:

IOPS=978.36K, BW=122.30GiB/s, IOS/call=31/31
IOPS=996.75K, BW=124.59GiB/s, IOS/call=31/31
IOPS=996.55K, BW=124.57GiB/s, IOS/call=31/31
IOPS=996.52K, BW=124.56GiB/s, IOS/call=31/31
IOPS=996.54K, BW=124.57GiB/s, IOS/call=31/31
IOPS=996.51K, BW=124.56GiB/s, IOS/call=31/31

which is a notable improvement. Then I checked CPU utilization,
switching to IRQ driven IO instead. And the good news there for bs=128K
we end up using half the CPU to achieve better performance. So definite
win there!

Just a quick dump on some quick result, I didn't look further into this
just yet.

-- 
Jens Axboe

