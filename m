Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE310301753
	for <lists+io-uring@lfdr.de>; Sat, 23 Jan 2021 18:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbhAWRiL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 12:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbhAWRiI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 12:38:08 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C433C0613D6
        for <io-uring@vger.kernel.org>; Sat, 23 Jan 2021 09:37:28 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id i5so6084591pgo.1
        for <io-uring@vger.kernel.org>; Sat, 23 Jan 2021 09:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zyXonzKaM8k6OOnkDrxM5pAHWQEmapPZdcJnRLpZOUY=;
        b=1LTdiGYKSeYUIoLVn2hyU/Aq/Ef1TzWLSzSD+FI3sw9U60YDuJtu7JswiavSVAD2FR
         /wx1dUpnFU0P9teymLn8RbM+6wPArUxVrpJAPyj/jwbC2ndC3SpT9hNPRiYKROFvr3eh
         jo39gcx0X///m5tIIj2w+vq9yqm47ecbGqOjENWReEygvWp0ejCcUTiBXs6s8NrnVjTj
         wW0ngs+NBKLdPx/bgkZuDVOp8VdXKJ/YqylCYbsv37ZaJns9BPK33g90be2br47t+mjt
         iDORfZdudab53iEvgWcrL9UwiAl7jKSW5+SHajADgP23KGzNjnnTvN9VZI6CElBFs/L6
         8b7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zyXonzKaM8k6OOnkDrxM5pAHWQEmapPZdcJnRLpZOUY=;
        b=ECHZpgMPZCY0kviTf7xINIH/8AU8CKiETlhmjmi1/dH1sJuKZibz02zCeGNqJRsJXF
         UL3oooNeC40y+Oleam7uvwMdhCv04mcMctQCt0XGBsd0jY+eiqPPKDEb7fb+SYj848oV
         sHDXYyt4dzMbRgCJoD7xIFwROR+NS/zoIsTueL3A10MraxPDhvexX14PvFY+S/hdJvbA
         pigyHg0YUQkIqC+BF+/ZQHnOhWdV9n6Ao+6ZtUyHun76jo4n3wtQ3fTrcwqQrCJwzvlo
         HnifaRoVxcaP2uPbDVs5S5I80afVH4Ta6fDHfH+2Qecrvmq/g56EiGMcpX+jnB11F+yD
         OgOA==
X-Gm-Message-State: AOAM531c6rO9W4LpzSMJMJCrs9P4SygWsGcVcIuW3wcbVJIWWU2QxoFL
        ujIDIsJkcfYBkNtely7VqSQ0gQ==
X-Google-Smtp-Source: ABdhPJxRf5qjlvC4skWicX7l2XytqhLPOkLd7uFj0eop1zrDNaLQPmktHwtTCqnRJB5DzSvImpcCcw==
X-Received: by 2002:a63:5b1a:: with SMTP id p26mr10584754pgb.76.1611423447701;
        Sat, 23 Jan 2021 09:37:27 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id r14sm12893895pgi.27.2021.01.23.09.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 09:37:26 -0800 (PST)
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20210123114152.GA120281@wantstofly.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b5b978ee-1a56-ead7-43bc-83ae2398b160@kernel.dk>
Date:   Sat, 23 Jan 2021 10:37:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210123114152.GA120281@wantstofly.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/23/21 4:41 AM, Lennert Buytenhek wrote:
> IORING_OP_GETDENTS64 behaves like getdents64(2) and takes the same
> arguments.
> 
> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> ---
> This seems to work OK, but I'd appreciate a review from someone more
> familiar with io_uring internals than I am, as I'm not entirely sure
> I did everything quite right.
> 
> A dumb test program for IORING_OP_GETDENTS64 is available here:
> 
> 	https://krautbox.wantstofly.org/~buytenh/uringfind.c
> 
> This does more or less what find(1) does: it scans recursively through
> a directory tree and prints the names of all directories and files it
> encounters along the way -- but then using io_uring.  (The uring version
> prints the names of encountered files and directories in an order that's
> determined by SQE completion order, which is somewhat nondeterministic
> and likely to differ between runs.)
> 
> On a directory tree with 14-odd million files in it that's on a
> six-drive (spinning disk) btrfs raid, find(1) takes:
> 
> 	# echo 3 > /proc/sys/vm/drop_caches 
> 	# time find /mnt/repo > /dev/null
> 
> 	real    24m7.815s
> 	user    0m15.015s
> 	sys     0m48.340s
> 	#
> 
> And the io_uring version takes:
> 
> 	# echo 3 > /proc/sys/vm/drop_caches 
> 	# time ./uringfind /mnt/repo > /dev/null
> 
> 	real    10m29.064s
> 	user    0m4.347s
> 	sys     0m1.677s
> 	#
> 
> These timings are repeatable and consistent to within a few seconds.
> 
> (btrfs seems to be sending most metadata reads to the same drive in the
> array during this test, even though this filesystem is using the raid1c4
> profile for metadata, so I suspect that more drive-level parallelism can
> be extracted with some btrfs tweaks.)
> 
> The fully cached case also shows some speedup for the io_uring version:
> 
> 	# time find /mnt/repo > /dev/null
> 
> 	real    0m5.223s
> 	user    0m1.926s
> 	sys     0m3.268s
> 	#
> 
> vs:
> 
> 	# time ./uringfind /mnt/repo > /dev/null
> 
> 	real    0m3.604s
> 	user    0m2.417s
> 	sys     0m0.793s
> 	#
> 
> That said, the point of this patch isn't primarily to enable
> lightning-fast find(1) or du(1), but more to complete the set of
> filesystem I/O primitives available via io_uring, so that applications
> can do all of their filesystem I/O using the same mechanism, without
> having to manually punt some of their work out to worker threads -- and
> indeed, an object storage backend server that I wrote a while ago can
> run with a pure io_uring based event loop with this patch.

The results look nice for sure. Once concern is that io_uring generally
guarantees that any state passed in is stable once submit is done. For
the below implementation, that doesn't hold as the linux_dirent64 isn't
used until later in the process. That means if you do:

submit_getdents64(ring)
{
	struct linux_dirent64 dent;
	struct io_uring_sqe *sqe;

	sqe = io_uring_get_sqe(ring);
	io_uring_prep_getdents64(sqe, ..., &dent);
	io_uring_submit(ring);
}

other_func(ring)
{
	struct io_uring_cqe *cqe;

	submit_getdents64(ring);
	io_uring_wait_cqe(ring, &cqe);
	
}

then the kernel side might get garbage by the time the sqe is actually
submitted. This is true because you don't use it inline, only from the
out-of-line async context. Usually this is solved by having the prep
side copy in the necessary state, eg see io_openat2_prep() for how we
make filename and open_how stable by copying them into kernel memory.
That ensures that if/when these operations need to go async and finish
out-of-line, the contents are stable and there's no requirement for the
application to keep them valid once submission is done.

Not sure how best to solve that, since the vfs side relies heavily on
linux_dirent64 being a user pointer...

Outside of that, implementation looks straight forward.

-- 
Jens Axboe

