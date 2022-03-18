Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E994DDBDA
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 15:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbiCROoz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 10:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237382AbiCROoy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 10:44:54 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCF32E5768
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 07:43:35 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h23so11422702wrb.8
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 07:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=b5IgM1pfmqfbVyXrPizgzoTapsKtV7N1PmRvPG0bDn8=;
        b=U9Wr1Q4bESQeoe2fX5d51zV8zODH27hcQ+yET7A+AnsvZCryl/GIaJPgikhyQfdnAV
         Ss8EokDC7SYlIBbKNiLzedKtNqyRs8mL88hSzb3bz3INpQKzxoyKlx1j16tRpE2cIO43
         FKuNcUSJuK6h7pKLTzJWj7zE8W88sWHIt40u+3vqOhMWUXYI5hvjf+Jx/aH8Xm+OLlsJ
         dDUdpbXeGwsr/Q3cUKq1ipvlXm0fNU/HbdRpuEnOnKpKUr7DX4PXpMjYI30wrVg4VkLj
         FBhE6pKTowYW0T6zEu4bUzRpT29ZDBQPIeDh1b6rW3Any8CHJ826vRJ9+GBetT2X5QjE
         SKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b5IgM1pfmqfbVyXrPizgzoTapsKtV7N1PmRvPG0bDn8=;
        b=ZfTCZ1wgzdRhTtjqPZMV9Iu7Ph9Bz/wngV9uTtcG/IgZia60ktZEyMrLswArnOkV4D
         85KE6TfDJosme2gYAxpXprHIW+lYTqgHJqrGcm3C16aXLIN2tdiBsiZty9FPfO8mgrgt
         R+u2i9jcwtXB1bHRrluDYuAqL4mOZbXmzpzG/2WWZnBsWCm6zJnvXrAfWy7wwbP+qZm8
         mmtNL8UxTqzIuMcfhb7KZPPLBp/jB1am9bYUlM0PXoLkrsoDBkvDx35ow/MX2CAzd2lw
         ls6X1LunNJ3tXaMtnlXMw1a7XecySfZtgIn8AxBtMtzbpouQsZLu3wJA57BNdo/OeeZd
         +P3g==
X-Gm-Message-State: AOAM533OeSTUeihrql1TC+rkZLS3mZRack0goN9fAMkJWTuMyA8ixB6M
        F+hNBWCZTrPKQkYzFgnsOUOGraNp7gMUYw==
X-Google-Smtp-Source: ABdhPJxG77nuEo2kX6IyDo9vkNvnMCDfcJD+nT96nyz+jl+Brn6xpmiLnY8VgVFu1LZ/oTZpJuddNQ==
X-Received: by 2002:a5d:4b84:0:b0:203:e89d:71a1 with SMTP id b4-20020a5d4b84000000b00203e89d71a1mr7066146wrt.274.1647614613596;
        Fri, 18 Mar 2022 07:43:33 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id m64-20020a1c2643000000b0038c85aade4csm2590662wmm.11.2022.03.18.07.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 07:43:33 -0700 (PDT)
Message-ID: <016bd177-1621-c6c1-80a2-adfabe929d2f@gmail.com>
Date:   Fri, 18 Mar 2022 14:42:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC 0/4] completion locking optimisation feature
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1647610155.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1647610155.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 13:52, Pavel Begunkov wrote:
> A WIP feature optimising out CQEs posting spinlocking for some use cases.
> For a more detailed description see 4/4.
> 
> Quick benchmarking with fio/t/io_uring nops gives extra 4% to throughput for
> QD=1, and ~+2.5% for QD=4.

Non-io_uring overhead (syscalls + userspace) takes ~60% of all execution
time, so the percentage should quite depend on the CPU and the kernel config.
Likely to be more than 4% for a faster setup.

fwiw, was also usingIORING_ENTER_REGISTERED_RING, if it's not yet included
in the upstream version of the tool.

Also, want to play after to see if we can also avoid taking uring_lock.


> Pavel Begunkov (4):
>    io_uring: get rid of raw fill cqe in kill_timeout
>    io_uring: get rid of raw fill_cqe in io_fail_links
>    io_uring: remove raw fill_cqe from linked timeout
>    io_uring: optimise compl locking for non-shared rings
> 
>   fs/io_uring.c                 | 126 ++++++++++++++++++++++------------
>   include/uapi/linux/io_uring.h |   1 +
>   2 files changed, 85 insertions(+), 42 deletions(-)
> 

-- 
Pavel Begunkov
