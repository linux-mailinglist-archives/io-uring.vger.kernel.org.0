Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD477797B0
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbjHKTYY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 15:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjHKTYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 15:24:21 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F15E30EC
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 12:24:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6878db91494so470086b3a.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 12:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691781860; x=1692386660;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mlwzPwxXPZvYdQ5TdZrtnbjgr6uXBMavxXl0FNVe1uY=;
        b=JZ5lO39oJ2JmWpOmVJslFeZ9IUP0Aie+4pDP4Bcoxn0gZuMtikWxOt8IIYGM304YEO
         eump7B3caD7VXP+xGl6jmBVlhBisNHSG3a5Hmy75Mz87k61u3BuG1NJrXojH01zpz5ES
         aIF94kk/k8VR9F7qfknb3vhn/vb4n0oTRrDgBKQiod6ZuG4t17iOqgnaHiGIXvtdExTz
         Ldifcqk1/gK6zOdkPerxz9olHeOOMH5pWF5OL6V2Zw+nnRDqkk0mabDBdUoPITcS7SJE
         bSYaH6JfP7ESxcw0mqz9AnPTnyEEqf/8p/tanBo1odCRWAesHvz/obpUginyzp4SFT+/
         vwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691781860; x=1692386660;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mlwzPwxXPZvYdQ5TdZrtnbjgr6uXBMavxXl0FNVe1uY=;
        b=P1OHtmWcIxCa92a7y/fHl9xLaVDHIAQ4N5LIgeDz0GENghnfNpEZlxFGoHeedE+12F
         QJTR+hYSHQ1oZO6tsCIcH5CWCJFLnzj7Ait4QsUMdS/BrGtVvhEAjmUMSsHvb9R6+ZyU
         PnRNd23Et20UzscFyK3tqBdr/Ag10+nmFL3abOzEZjrUMS+091KrdXqq1g2Cc1eSwLIP
         J0EgGrlWPPBS8LKuKGWTyyL/Fa3O6qMCVCD+/PnNQgxhBJdNzF3sTWhIWLWzP+iWKe4J
         vLKjFWqdhONl/bWrEP3QPH6lmgDlUTdig/A8tYlWW3PI9jhIyozHLIxorLgTrAofDnPw
         77QA==
X-Gm-Message-State: AOJu0YxqyvteOiN7b2yrJkLaxQxrM4hy01P5K6bHCg0b5wuSggEOucz/
        wgHyS+puknqP0l3xqMYWsH2IXg==
X-Google-Smtp-Source: AGHT+IEBTy82172CwyKRPsTYtQpTgZgOufE7xlzHukLV6MPc6tYOtsZ0CFj73c/0L0PdcoJIKrdi6w==
X-Received: by 2002:a05:6a20:1606:b0:136:f3ef:4d2 with SMTP id l6-20020a056a20160600b00136f3ef04d2mr4254725pzj.3.1691781859890;
        Fri, 11 Aug 2023 12:24:19 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c12-20020a63350c000000b005533b6cb3a6sm3692260pga.16.2023.08.11.12.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Aug 2023 12:24:19 -0700 (PDT)
Message-ID: <cbf529c4-6fb7-40da-8b01-514a8e3e6f5c@kernel.dk>
Date:   Fri, 11 Aug 2023 13:24:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3] io_uring: set plug tags for same file
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, asml.silence@gmail.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>
References: <20230731203932.2083468-1-kbusch@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230731203932.2083468-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/23 2:39 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> io_uring tries to optimize allocating tags by hinting to the plug how
> many it expects to need for a batch instead of allocating each tag
> individually. But io_uring submission queueus may have a mix of many
> devices for io, so the number of io's counted may be overestimated. This
> can lead to allocating too many tags, which adds overhead to finding
> that many contiguous tags, freeing up the ones we didn't use, and may
> starve out other users that can actually use them.
> 
> When starting a new batch of uring commands, count only commands that
> match the file descriptor of the first seen for this optimization. This
> avoids have to call the unlikely "blk_mq_free_plug_rqs()" at the end of
> a submission when multiple devices are used in a batch.

Wanted to run this through both the peak IOPS and networking testing,
started with the former. Here's a peak run with -git + pending 6.5
changes + pending 6.6 changes:

IOPS=125.88M, BW=61.46GiB/s, IOS/call=32/31
IOPS=125.39M, BW=61.23GiB/s, IOS/call=31/31
IOPS=124.97M, BW=61.02GiB/s, IOS/call=32/32
IOPS=124.60M, BW=60.84GiB/s, IOS/call=32/32
IOPS=124.27M, BW=60.68GiB/s, IOS/call=31/31
IOPS=124.00M, BW=60.54GiB/s, IOS/call=32/31

and here's one with the patch:

IOPS=121.69M, BW=59.42GiB/s, IOS/call=31/32
IOPS=121.26M, BW=59.21GiB/s, IOS/call=32/32
IOPS=120.87M, BW=59.02GiB/s, IOS/call=31/31
IOPS=120.87M, BW=59.02GiB/s, IOS/call=32/32
IOPS=121.02M, BW=59.09GiB/s, IOS/call=32/32
IOPS=121.63M, BW=59.39GiB/s, IOS/call=31/32
IOPS=121.48M, BW=59.32GiB/s, IOS/call=31/31

Running a quick profile, here's the top diff:

# Baseline  Delta Abs  Shared Object     Symbol                                     
# ........  .........  ................  ...........................................
#
     6.69%     -3.03%  [kernel.vmlinux]  [k] io_issue_sqe
     9.65%     +2.30%  [nvme]            [k] nvme_poll_cq
     4.86%     -1.55%  [kernel.vmlinux]  [k] io_submit_sqes
     4.61%     +1.40%  [kernel.vmlinux]  [k] blk_mq_submit_bio
     4.79%     -0.98%  [kernel.vmlinux]  [k] io_read
     0.56%     +0.97%  [kernel.vmlinux]  [k] blkdev_dio_unaligned.isra.0
     3.61%     +0.52%  [kernel.vmlinux]  [k] dma_unmap_page_attrs
     2.04%     -0.45%  [kernel.vmlinux]  [k] blk_add_rq_to_plug

Note that this is perf.data.old being the kernel with your patch, and
perf.data being the "stock" kernel mentioned above. The main thing looks
like spending more time in io_issue_sqe() and io_submit_sqes(), and
converserly we're spending less time polling. Usually for profiling a
polled workload, having more time in the polling function is good, as it
shows us we're spending less time everywhere else.

This is what I'm using:

sudo t/io_uring -p1 -d128 -b512 -s32 -c32 -F1 -B1 -R0 -X1 -n24 -P1 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1 /dev/nvme6n1 /dev/nvme7n1 /dev/nvme8n1 /dev/nvme9n1 /dev/nvme10n1 /dev/nvme11n1 /dev/nvme12n1 /dev/nvme13n1 /dev/nvme14n1 /dev/nvme15n1 /dev/nvme16n1 /dev/nvme17n1 /dev/nvme18n1 /dev/nvme19n1 /dev/nvme20n1 /dev/nvme21n1 /dev/nvme22n1 /dev/nvme23n1

which is submitting 32 requests at the time. Obviously we don't expect a
win in this case, as each thread is handling just a single NVMe device.
The stock kernel will not over-allocate in this case.

If we change that to -n12 instead, meaning each will drive two devices,
here's what the stock kernel gets:

IOPS=60.95M, BW=29.76GiB/s, IOS/call=31/32
IOPS=60.99M, BW=29.78GiB/s, IOS/call=31/32
IOPS=60.96M, BW=29.77GiB/s, IOS/call=31/31
IOPS=60.95M, BW=29.76GiB/s, IOS/call=31/31
IOPS=60.91M, BW=29.74GiB/s, IOS/call=32/32

and with the patch:

IOPS=59.64M, BW=29.12GiB/s, IOS/call=32/31
IOPS=59.63M, BW=29.12GiB/s, IOS/call=31/32
IOPS=59.57M, BW=29.09GiB/s, IOS/call=31/31
IOPS=59.57M, BW=29.09GiB/s, IOS/call=32/32
IOPS=59.65M, BW=29.12GiB/s, IOS/call=31/31

Now these are both obviously lower, but I haven't done anything to
ensure that the two-drives-per-poller workload is optimized. For all I
know, the numa layout is now messed up too. Just as a caveat, but they
are comparable to each other.

Perf diff again looks similar, note that this time it's perf.data.old
that's the stock kernel and perf.data that's the one with your patch:

     3.51%     +2.84%  [kernel.vmlinux]  [k] io_issue_sqe
     3.24%     +1.35%  [kernel.vmlinux]  [k] io_submit_sqes

With the kernel without your patch, I was looking for tag flush overhead
but didn't find much:

     0.02%  io_uring  [kernel.vmlinux]  [k] blk_mq_free_plug_rqs

Outside of the peak worry with the patch, do you have a workload that we
should test this on?

-- 
Jens Axboe

