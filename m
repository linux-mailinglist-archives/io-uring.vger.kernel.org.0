Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDC11F6A93
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 17:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgFKPGC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 11:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgFKPGC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 11:06:02 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186A9C08C5C1
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 08:06:02 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n2so2409001pld.13
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 08:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/XozilSCMPO+DzwxXxej5kI1SBryNWue/7kNfb2/3vo=;
        b=kHjRHotFmm6rBj91FvS6KUU/JkVu5h3m3uq3jWlbAHtd45K6fDiZ8tTTaOc4bpI17J
         1NAl1sxJOiZBYTBaqrwk4igaIftpaV5MjtEVqzs/xLqHAVDjsL86x+rvWaVTWQyhDDct
         ogVtrkJuytvUa1YeCa09lf9csxcaqMvgIAWkFLw/1uahgo5EIohdrk8fG3gM22a6kwuQ
         XVGICXB9jk+muVOUA6jEqQgXR1Ez4sUI/JTewlSLDo/231nLzaBW9Z7Tw5RSIoNpI65V
         UPiMkfID7XrZ6mPbshIfwMefWgyXCdBcSurOhHFJp6q4zKaBk7lO/5Ix+QTV06TKGVLo
         MxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XozilSCMPO+DzwxXxej5kI1SBryNWue/7kNfb2/3vo=;
        b=t2Y/Ksh00ezkh1+vdLVhb+SRSUYjq+SF0QM1IvRb7rzuPbvBsywtYlL1Jop1FjoUfH
         WitFeHXNzC1mp11IQqyOFlJ7OrovhlXtOUWHgQkWgupys9mYYFnFSFrJrQZQ68Fl4iyv
         HEkgzKFvB1xB16gqEXsZGoBpxGoozz0xKCJzXJ9XP39R8Eu9l2v8c8QfCinklMmnyknw
         MOeYO2/iObBUq+FHL2OeDvUlrXXr1MfHQo+Ryw371eK1W0NlRpS9E18xZDqzwckHWpgF
         aPkYF2+14sor8GO8i8EAMuztHq/W3+LRjqpwkmT5/nQvrsyDPqnjAO7oQbSAHSvLOIlI
         Rk0w==
X-Gm-Message-State: AOAM530xNauOS04SQDG8uWo18SMbt0mgu8NQ9bS2cWVNKftlwM/WOfOw
        wdlMLrQsG1LL2iIv6foIwAzBZ+ZMpm/ISA==
X-Google-Smtp-Source: ABdhPJy3gEHGoddKuFibF9G7svlQtbHLNmHdXITmW0yLIkwCj0QVIJb8lszdppUdtOep+MyRK9szqA==
X-Received: by 2002:a17:90a:6f04:: with SMTP id d4mr7793865pjk.134.1591887961391;
        Thu, 11 Jun 2020 08:06:01 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x1sm3305224pfn.76.2020.06.11.08.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 08:06:00 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix io_kiocb.flags modification race in IOPOLL
 mode
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200611092510.2963-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0543873-7e78-62af-67fa-fa5ae9ed4e0f@kernel.dk>
Date:   Thu, 11 Jun 2020 09:05:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200611092510.2963-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/20 3:25 AM, Xiaoguang Wang wrote:
> While testing io_uring in arm, we found sometimes io_sq_thread() keeps
> polling io requests even though there are not inflight io requests in
> block layer. After some investigations, found a possible race about
> io_kiocb.flags, see below race codes:
>   1) in the end of io_write() or io_read()
>     req->flags &= ~REQ_F_NEED_CLEANUP;
>     kfree(iovec);
>     return ret;
> 
>   2) in io_complete_rw_iopoll()
>     if (res != -EAGAIN)
>         req->flags |= REQ_F_IOPOLL_COMPLETED;
> 
> In IOPOLL mode, io requests still maybe completed by interrupt, then
> above codes are not safe, concurrent modifications to req->flags, which
> is not protected by lock or is not atomic modifications. I also had
> disassemble io_complete_rw_iopoll() in arm:
>    req->flags |= REQ_F_IOPOLL_COMPLETED;
>    0xffff000008387b18 <+76>:    ldr     w0, [x19,#104]
>    0xffff000008387b1c <+80>:    orr     w0, w0, #0x1000
>    0xffff000008387b20 <+84>:    str     w0, [x19,#104]
> 
> Seems that the "req->flags |= REQ_F_IOPOLL_COMPLETED;" is  load and
> modification, two instructions, which obviously is not atomic.
> 
> To fix this issue, add a new iopoll_completed in io_kiocb to indicate
> whether io request is completed.

Long term, I want to ensure that IOPOLL irq completions are illegal, it
should not be enabled (or possible) if the driver doesn't do pure polled
completions.

Short term, I think your fix is fine, but should be turned into using
READ_ONCE/WRITE_ONCE for the reading/setting of ->iopoll_completed.
Can you resend it with that?

-- 
Jens Axboe

