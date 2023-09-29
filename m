Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E813B7B2EF0
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 11:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbjI2JLf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 05:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbjI2JLe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 05:11:34 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276C9180
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 02:11:33 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-65afc29277bso16302786d6.1
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 02:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695978692; x=1696583492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vrbxuiI+WNiNLwoGNSEuok9WNREFg61kxgWpjRA8C+Y=;
        b=hjJHiN8tivg8dw6JvpXqrnKMins/uC9k1oQYA8mPUi7InVt+UvKkN4i9XCfQxqt07l
         pGfenhkMbyk3Pdcar96tSH/q7iZ28sl6/WuQXEdJorQvWF2/rzLjYJXdNnmuNs/+ZnqU
         7Oqu8qijrGlCNFQDCPycGkLcjGuDsjivI44qeaor3mww3VLjHv5QqTZMIMaCCkx2U+yz
         hl8/il4jynxKD8EvDjMhecWEYNXYGvXSyNuuWZLpHiN+I5N8wfcfV8HPyx3vgLRwmpfn
         SyB/hzoLi4IsfYWDoWNDiTz/Tf9BpVpKey1rBHnfeDQ72Im3L7LOJwidCIPeDxjl0L5v
         RGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695978692; x=1696583492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vrbxuiI+WNiNLwoGNSEuok9WNREFg61kxgWpjRA8C+Y=;
        b=p55Vm4OCzr0auxrcFdPZISTofiXdBc+ERdGFVwLGCFbz1XoKFLs99570kM36LyvmGe
         PDTcb5yRmL4t9RcxzMve1rfmRtTSb6qwlAAEk7eqEzmGUiz1brVOLriJbUJPeitiPuI5
         gToG9/jkmWYhlVxgNMJqNl35A/l1co0uwcmubaJpJXUiARuT/T+1Gwt06swMY5HE54ui
         T7RCzpiKbifsMa3/BWBhf8ov4WcjLOUKLDjYlWFwvtrmb3GPZvwueji0djsq/W7OT0pJ
         VyAxb8iZZIPK2RoBN819LogtG0Y//U0rca9N97YFdIf5AzQK9Dn5ONqoiJKsRsoI09f3
         xyPQ==
X-Gm-Message-State: AOJu0YxgsZ+xYI2PYbh1BeBODeqWdi8WoseISMaNpAzuUaJ+D2gQzjjR
        fWDGGi07Bbpct68e860KqR+kAA==
X-Google-Smtp-Source: AGHT+IGxLW/VLhcBCCWUgpkR1DRUfIOLCTizvIG4WRlUOM3cdS0dZKKElW7RkFIaS/ndfq29KA74Lw==
X-Received: by 2002:a05:6214:f26:b0:653:576d:1e8 with SMTP id iw6-20020a0562140f2600b00653576d01e8mr3796317qvb.1.1695978692179;
        Fri, 29 Sep 2023 02:11:32 -0700 (PDT)
Received: from [172.19.130.163] ([216.250.210.88])
        by smtp.gmail.com with ESMTPSA id o8-20020a0cf4c8000000b0065b260eafd9sm2859274qvm.87.2023.09.29.02.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 02:11:31 -0700 (PDT)
Message-ID: <808c8472-ba4d-466c-84ef-cff4746cfdc0@kernel.dk>
Date:   Fri, 29 Sep 2023 03:11:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v6] Add io_uring futex/futexv support
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de, tglx@linutronix.de
References: <20230928172517.961093-1-axboe@kernel.dk>
 <20230929075317.GA6282@noisy.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230929075317.GA6282@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/23 1:53 AM, Peter Zijlstra wrote:
> On Thu, Sep 28, 2023 at 11:25:09AM -0600, Jens Axboe wrote:
> 
>>  include/linux/io_uring_types.h |   5 +
>>  include/uapi/linux/io_uring.h  |   4 +
>>  io_uring/Makefile              |   1 +
>>  io_uring/cancel.c              |   5 +
>>  io_uring/cancel.h              |   4 +
>>  io_uring/futex.c               | 386 +++++++++++++++++++++++++++++++++
>>  io_uring/futex.h               |  36 +++
>>  io_uring/io_uring.c            |   7 +
>>  io_uring/opdef.c               |  34 +++
>>  kernel/futex/futex.h           |  20 ++
>>  kernel/futex/requeue.c         |   3 +-
>>  kernel/futex/syscalls.c        |  18 +-
>>  kernel/futex/waitwake.c        |  49 +++--
>>  13 files changed, 545 insertions(+), 27 deletions(-)
> 
> Thanks for bearing with us on the futex2 thing!
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks Peter! Going with the futex2 interface was the right choice, the
old one was kinda wonky anyway. New one is definitely cleaner.

-- 
Jens Axboe

