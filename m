Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE450BA95
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448923AbiDVOxH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 10:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449016AbiDVOxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 10:53:07 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BC92458A
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 07:50:13 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e1so5190742ile.2
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 07:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ROigdjz+r9WQYm3kQ+Jbdn0BKnocvX8dhqX1kmmrbck=;
        b=450hQswzlT4N/ptzVtcGF2rKFbY1jMhY3Vp1w2AR20nwmlc839HlTWKHqdE5/829ri
         yYUcJnVU7AdsPYsMfvl03WNz0ZasMbgE2NmNJ1fnDEk916gg6ovFZCJauVygGXZX/KtR
         Asgb7Nx465QD8sOdW/Cza3FhgIaJBiW5yEJ3c6DXl4KMowODkbZ9yEcrs1b1gVpatm/4
         i85DPrJtqCide+zszdpHzKVHKjVrNhRe9ywhuRbTwkJouwKx5gfT9aE6y57foCvLC8My
         7St3emR/xNvmPs6UT28LVVaWiIpEu294P/ZqtOIXhnzviZVtjFBEMod0Gb+hOOEJlHwQ
         rUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ROigdjz+r9WQYm3kQ+Jbdn0BKnocvX8dhqX1kmmrbck=;
        b=k0Uq+lgagA1W/W3amx+5VIusxcCFKUMT9p+HaAuDWYaY0zActc+CMVnT8XcM2r5KTI
         BBm9cy6bg4FS14z7uHGnzw9rtBJFN2CDRmggjgIbdubn2jK9QP9Dw/0NO29WFRZ79mkC
         rn0vOdzoVlLeaAY9SWjxz2PWDUpS4PxZ5TerojNSg68t4r0QIXrAawzPlBxQBVddQj0y
         EFYObAKQSuH5SYxQZi7auYGoIhKaXxYi4JBphECJGDiRavyVy+31mY0D0sWcNYHZ2r3/
         6tfGpBuTpaM+RNQU2mO95ShUQJUSZbua6Cdy0LFRWDbkBS/keY3CVf+o8HbM3u+aEq6R
         bw+w==
X-Gm-Message-State: AOAM532XWE+GvKXzxDEt6pf1A1/N03mr0hYiWNL0i1rbL2mbi/IUsveM
        sisVjmADotETh1aw/+993dXzbQ==
X-Google-Smtp-Source: ABdhPJxaEMe1oitrJrdOOcu/LwyWuOThNPrhBMnRpheVrpYEa0DoGTIVWHpa4igFo6WZhCRTryOoFw==
X-Received: by 2002:a05:6e02:1587:b0:2c2:5c48:a695 with SMTP id m7-20020a056e02158700b002c25c48a695mr2070517ilu.169.1650639012580;
        Fri, 22 Apr 2022 07:50:12 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v8-20020a92c808000000b002cd6d94f263sm1430952iln.52.2022.04.22.07.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 07:50:12 -0700 (PDT)
Message-ID: <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
Date:   Fri, 22 Apr 2022 08:50:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/22 4:33 AM, Avi Kivity wrote:
> Unfortunately, only ideas, no patches. But at least the first seems very easy.
> 
> 
> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op
> itself (1-8 bytes) to a user memory location specified by the op.
> 
> 
> Linked to another op, this can generate an in-memory notification
> useful for busy-waiters or the UMWAIT instruction
>
> This would be useful for Seastar, which looks at a timer-managed
> memory location to check when to break computation loops.

This one would indeed be trivial to do. If we limit the max size
supported to eg 8 bytes like suggested, then it could be in the sqe
itself and just copied to the user address specified.

Eg have sqe->len be the length (1..8 bytes), sqe->addr the destination
address, and sqe->off the data to copy.

If you'll commit to testing this, I can hack it up pretty quickly...

> - IORING_OP_MEMCPY - asynchronously copy memory
> 
> 
> Some CPUs include a DMA engine, and io_uring is a perfect interface to
> exercise it. It may be difficult to find space for two iovecs though.

I've considered this one in the past too, and it is indeed an ideal fit
in terms of API. Outside of the DMA engines, it can also be used to
offload memcpy to a GPU, for example.

The io_uring side would not be hard to wire up, basically just have the
sqe specfy source, destination, length. Add some well defined flags
depending on what the copy engine offers, for example.

But probably some work required here in exposing an API and testing
etc...

-- 
Jens Axboe

