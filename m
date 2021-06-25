Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C5B3B3A3E
	for <lists+io-uring@lfdr.de>; Fri, 25 Jun 2021 02:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhFYAro (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 20:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbhFYAro (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 20:47:44 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29695C061574
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 17:45:24 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id d9so10623596ioo.2
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 17:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OgwpmCa+NGiSxZz9RWiJKCvZzwfB/ohD5NMjDOTctOY=;
        b=oWOgFRreIS+mHG14+LHjt1kSti9Ox9ff76J+4GC4bmLXEr9DRfn5RwTi/YHwIxph4i
         HkPwh4lLT4elGpQ99ioAK/s6YhcvWwYZb4V8pVDt0qyEGBdiPhFtCzt9oGn9fOV5Cccu
         viheBNKt4x8TMH7rpITCvnRLENeveGdYzjXRe5m4vIfJ3lvxVpNbmaCMxNxZZ6l0Xujo
         6We6Ps+OC6sY/ONgMeGkU58RbCpFFSUrWof0hQXTKutyGQoJvge7OmYuQs1Qu2hGcdDf
         VrCZUexfPz65+aEu1r4cQmhNtDSURDHMio6TgyN7Cfd9zPOAUQMrMHphQhkDMv/WI3v1
         1gSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgwpmCa+NGiSxZz9RWiJKCvZzwfB/ohD5NMjDOTctOY=;
        b=B744TJ7Vyzykma1SSQDMxY42Y6vJhSGC3P9uALaUqgJNKVuf0wkHzZeYpTHKI8yV4l
         Qf2E+hyNvW9PWHf3C569Bzd3hB+QF4nQBSMfswQChGklP7QAWXIanIIc07u7aF0MUs91
         k6PqN0n5auawYSVp6iVp967++adWzJwL3PcRie/27ltT3uQav6rrvuqMN3DfecaOjp5L
         eKd43jjH1dY33oQ12/oPnzUzrFEnhPRZyN1qlWdbEA/wtVmxa4TU4PcE64LDYk7SCTC+
         KPcTi8VdyWiZXT5+IUNG9vx+nlcRkwV4T6pO51xrznIHmgK4o2lkLgWGCTajF3zIirCK
         pT2w==
X-Gm-Message-State: AOAM531UMglHPEfEKSZRJa6np8Jt/zK99WR5G6/4+ZBqN3qs1rCtbs53
        IRf6pMNCncx9pu5JWCvakFZezg==
X-Google-Smtp-Source: ABdhPJwHPvLnB6E5qRf562QB5T/8z3YpVo9e9usZFY5ycExpYeg6eKONunZzYkifJiGdlaMicpkyAg==
X-Received: by 2002:a05:6602:2433:: with SMTP id g19mr6468394iob.100.1624581923556;
        Thu, 24 Jun 2021 17:45:23 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id r6sm2128965ioh.27.2021.06.24.17.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 17:45:23 -0700 (PDT)
Subject: Re: [PATCH v4] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <16c91f57-9b6f-8837-94af-f096d697f5fb@kernel.dk>
Date:   Thu, 24 Jun 2021 18:45:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 6:17 AM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().
> 
> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.
> 
> Performance improvement testing has been performed with:
> Single thread, 1 TCP connection receiving a 5 Mbps stream, no sqpoll.
> 
> 4 measurements have been taken:
> 1. The time it takes to process a read request when data is already available
> 2. The time it takes to process by calling twice io_issue_sqe() after vfs_poll() indicated that data was available
> 3. The time it takes to execute io_queue_async_work()
> 4. The time it takes to complete a read request asynchronously
> 
> 2.25% of all the read operations did use the new path.
> 
> ready data (baseline)
> avg	3657.94182918628
> min	580
> max	20098
> stddev	1213.15975908162
> 
> reissue	completion
> average	7882.67567567568
> min	2316
> max	28811
> stddev	1982.79172973284
> 
> insert io-wq time
> average	8983.82276995305
> min	3324
> max	87816
> stddev	2551.60056552038
> 
> async time completion
> average	24670.4758861127
> min	10758
> max	102612
> stddev	3483.92416873804
> 
> Conclusion:
> On average reissuing the sqe with the patch code is 1.1uSec faster and
> in the worse case scenario 59uSec faster than placing the request on
> io-wq
> 
> On average completion time by reissuing the sqe with the patch code is
> 16.79uSec faster and in the worse case scenario 73.8uSec faster than
> async completion.

Thanks for respinning with a (much) better commit message. Applied.

-- 
Jens Axboe

