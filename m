Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C743B128A84
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 18:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfLURBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 12:01:10 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34758 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLURBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 12:01:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so107752pfc.1
        for <io-uring@vger.kernel.org>; Sat, 21 Dec 2019 09:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EfhtVqbfRNchJXGKYNnjK189Wzr7z0ljLBenvVe83Bg=;
        b=kEG9PFRG9Uvdbot3yMEjUmv3moIuUezSLDNHOAIixNkkHFJXpSNIRVmICZgWU8NZEv
         nJDnkPrcfJejWqIJbxwZ7YrESHetwJa437nxiTD6E+tm1Gs47bmdGjfrZWHHnp9IZqrI
         juv4rK7JUzqxpA9C9ls1wqFREP9WtcoqlZ3+h2H55xeTZ2vTvwoPhyy+MseCX7+R7/fS
         a2MnX1cOJVbdUI78I52WllUVXcOxKrDqInDw/plgj2bORSNLbsxwzZuhh0QG3ayppOej
         QXsocBfLfudKEZKmAGpvX5bhN8pb0j2zn8MBicJvXV2pk57flO5/uGqMi+rOrVwAcYQA
         OhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EfhtVqbfRNchJXGKYNnjK189Wzr7z0ljLBenvVe83Bg=;
        b=TovwvwRvjKOiXppuMif70oygrfswYhtMTtpJcBneneNrf+v8CFuC/FTYbWGEZA5Wkf
         pj7ZUniPfUoi0tOMAyDABFuiI/uNq4Kbzhst1URAqYE/PVZ6XLGfc+W127KNHK2TOVd0
         2qwpIYIkQlgLiKKMFNO7wmhnxp+oZ7S+7Kp1WQ+1ghT13l9/isZqrouhTRFydN40QO+P
         Ip7P8joqimJVVeLCIW/HZPncZip0c75tZuf2E37YzROzxsRmu/Wcuuk0m6EQyF8gqh/D
         x13bGJNn6sWWKgWpfrwIYPXHq8XSBIAHmy0Pfd1dZxgV3QLHovOrv4wJtTHPmgaG2YJH
         BO2g==
X-Gm-Message-State: APjAAAWSTBVgvbKnPEw1xl9hDrPVwsGqoccpxlJ8URALR08yP+GXtEQl
        hJDWD1arXLSudUrJQ1lFg3D6/Q==
X-Google-Smtp-Source: APXvYqzL9SlCQt49ptIpUkigX4FhPLwOhk0xJThIen+rDzELZJAXyqvGnAF3NxdNPB5zhtAaTGBeYw==
X-Received: by 2002:aa7:85d3:: with SMTP id z19mr23130341pfn.62.1576947669033;
        Sat, 21 Dec 2019 09:01:09 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c199sm18140362pfb.126.2019.12.21.09.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 09:01:08 -0800 (PST)
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
 <da858877-0801-34c3-4508-dabead959410@gmail.com>
 <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>
 <fef4b765-338b-d3b0-7fd5-5672b92fd3e8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fef3a245-d2a2-23b3-ff03-3e05af19b752@kernel.dk>
Date:   Sat, 21 Dec 2019 10:01:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <fef4b765-338b-d3b0-7fd5-5672b92fd3e8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/19 9:48 AM, Pavel Begunkov wrote:
> On 21/12/2019 19:38, Jens Axboe wrote:
>> On 12/21/19 9:20 AM, Pavel Begunkov wrote:
>>> On 21/12/2019 19:15, Pavel Begunkov wrote:
>>>> Double account ctx->refs keeping number of taken refs in ctx. As
>>>> io_uring gets per-request ctx->refs during submission, while holding
>>>> ctx->uring_lock, this allows in most of the time to bypass
>>>> percpu_ref_get*() and its overhead.
>>>
>>> Jens, could you please benchmark with this one? Especially for offloaded QD1
>>> case. I haven't got any difference for nops test and don't have a decent SSD
>>> at hands to test it myself. We could drop it, if there is no benefit.
>>>
>>> This rewrites that @extra_refs from the second one, so I left it for now.
>>
>> Sure, let me run a peak test, qd1 test, qd1+sqpoll test on
>> for-5.6/io_uring, same branch with 1-2, and same branch with 1-3. That
>> should give us a good comparison. One core used for all, and we're going
>> to be core speed bound for the performance in all cases on this setup.
>> So it'll be a good comparison.
>>
> Great, thanks!

For some reason, not seeing much of a change between for-5.6/io_uring
and 1+2 and 1+2+3, it's about the same and results seem very stable.
For reference, top of profile with 1-3 applied looks like this:

+    3.92%  io_uring  [kernel.vmlinux]  [k] blkdev_direct_IO
+    3.87%  io_uring  [kernel.vmlinux]  [k] blk_mq_get_request
+    3.43%  io_uring  [kernel.vmlinux]  [k] io_iopoll_getevents
+    3.03%  io_uring  [kernel.vmlinux]  [k] __slab_free
+    2.87%  io_uring  io_uring          [.] submitter_fn
+    2.79%  io_uring  [kernel.vmlinux]  [k] io_submit_sqes
+    2.75%  io_uring  [kernel.vmlinux]  [k] bio_alloc_bioset
+    2.70%  io_uring  [nvme_core]       [k] nvme_setup_cmd
+    2.59%  io_uring  [kernel.vmlinux]  [k] blk_mq_make_request
+    2.46%  io_uring  [kernel.vmlinux]  [k] io_prep_rw
+    2.32%  io_uring  [kernel.vmlinux]  [k] io_read
+    2.25%  io_uring  [kernel.vmlinux]  [k] blk_mq_free_request
+    2.19%  io_uring  [kernel.vmlinux]  [k] io_put_req
+    2.06%  io_uring  [kernel.vmlinux]  [k] kmem_cache_alloc
+    2.01%  io_uring  [kernel.vmlinux]  [k] generic_make_request_checks
+    1.90%  io_uring  [kernel.vmlinux]  [k] __sbitmap_get_word
+    1.86%  io_uring  [kernel.vmlinux]  [k] sbitmap_queue_clear
+    1.85%  io_uring  [kernel.vmlinux]  [k] io_issue_sqe


-- 
Jens Axboe

