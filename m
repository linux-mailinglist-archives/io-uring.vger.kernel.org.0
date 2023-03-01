Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CA76A74B6
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 21:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCAUAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 15:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCAUAU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 15:00:20 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317F54C6E4
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 12:00:19 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id b16so9075210iln.3
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 12:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677700818;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1O0YFkJ0OrZtWj6k2957doAN5KDDIQp9pjml5whfF1Q=;
        b=q66cop55yp2/x0Q/utUzbEqWRr/OMIRW0W6JDHjNYy/ME8+WLxURUgwjpTWNIblh7Z
         Tfc3GQ1dazJO1TUnUvD72PbDAI3SdkhKzlHmEXUlWIZqK7QfkCi3mUzXc19bdMasGtTp
         nHaN5ovr1oA8GY7UZXPFJAKDNZiIVytZgEXv0SEfKO+XQNl1SgkqwyVNT4IwM3SK2ZZu
         CJmJbBFmmJLuEJ6m4LLbbCucyTLw9VyKhxK9xyA0HccNoIl6Sknwts9unsNBjw6SuMpT
         EX/ny0E33HIFp8tCeMuOGm/X7TL/PGUOqkW6V2twDSdGj+ZZVkOhnRDzQSEHbOgYZDoA
         1UWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677700818;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1O0YFkJ0OrZtWj6k2957doAN5KDDIQp9pjml5whfF1Q=;
        b=WqEr1JIxUhPhBHL3IrhO7zYXbkgA0iKAAz33J7GPHOmn4dkim+1FmeCbm8bxsZye2D
         omw5TDpeiwRNihQrDSMY5H6QvBVbCKpZ976BR1jS19ZklfwbAYF3fimljWs8O/YrsCCI
         QDcIxVjBkkcMDCF2x7QpCs5Vbq9T27RxCj/0RPYwxwFV3X+L+5liaTEQ4kkF4axUE2TG
         NzfrUGO6IWq1vWvTfhEmsaxPXMZI4frK7iJVXQg8zvrs6JqoI0EKpw9dmvvanUkvSM4b
         WtNCEoezHGRoa59giY6O5UYvs4hzkMG/5wpGFnSzEKJKukx5xy7XND2FJrcnkAQm489q
         jKsw==
X-Gm-Message-State: AO0yUKU3DSuPGOGXXIF47l7rDPb+1z4TyQw+p4Xa2zoJQKae5TBakD+0
        fV0WerOmTFPf54WMobDYn9qQwg==
X-Google-Smtp-Source: AK7set+/8BRxyVSOx97zwOyyIGYXhee/i9kcJgMIe7+YRyFie7gKIEfxhY2ieMBQFIquLQz7axGjdg==
X-Received: by 2002:a92:b106:0:b0:317:5547:70c0 with SMTP id t6-20020a92b106000000b00317554770c0mr4389554ilh.2.1677700818515;
        Wed, 01 Mar 2023 12:00:18 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r20-20020a02c854000000b0037477c3d04asm3826920jao.130.2023.03.01.12.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 12:00:17 -0800 (PST)
Message-ID: <c8842e6d-4ce6-75f5-5ca0-c77fa23290db@kernel.dk>
Date:   Wed, 1 Mar 2023 13:00:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH liburing 0/3] sendzc test improvements
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1677686850.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1677686850.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/23 9:10 AM, Pavel Begunkov wrote:
> Add affinity, multithreading and the server
> 
> Pavel Begunkov (3):
>   examples/send-zc: add affinity / CPU pinning
>   examples/send-zc: add multithreading
>   examples/send-zc: add the receive part
> 
>  examples/Makefile        |   3 +
>  examples/send-zerocopy.c | 277 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 249 insertions(+), 31 deletions(-)

This doesn't apply to the current tree, what am I missing? I
don't see any send-zc changes since the last ones you did.
First patch:

axboe@m1max ~/gi/liburing (master)> patch -p1 --dry-run < 1
checking file examples/send-zerocopy.c
Hunk #1 succeeded at 12 with fuzz 2.
Hunk #2 FAILED at 51.
Hunk #3 succeeded at 78 (offset -2 lines).
Hunk #4 succeeded at 192 (offset -7 lines).
Hunk #5 FAILED at 333.
Hunk #6 succeeded at 360 with fuzz 2 (offset -14 lines).
Hunk #7 succeeded at 382 (offset -14 lines).
2 out of 7 hunks FAILED

-- 
Jens Axboe


