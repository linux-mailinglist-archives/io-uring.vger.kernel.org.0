Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D0553AB0C
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 18:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343988AbiFAQ36 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 12:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243359AbiFAQ36 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 12:29:58 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED10941B5
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 09:29:55 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q7so3086995wrg.5
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 09:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=09bfi+qAyJsSRNe9KbtFKPfwmxdWD40fpDpgopNb6BE=;
        b=BPZZQ9it4ljPwexLWwEWR/h1ack7yKO0RJAf5qJmj40Q2GvmPUjnAGne/X76Qj2BoY
         w6Ybh+OJ70ZlfSyNMfGFPRY049C3ZrIDOC5MWe2Tt5FpnESeWI48o98aEIhlimUybUZI
         IHLnpTCBqAXhPA7HUSSen+8b+ztcDCEZcNzE+/D3enOfaXXxFqp5jZIS6gFWOb9OK9Zf
         zCxcTJsB2/N6Izl2Th/OcMzG8G6pqiOfUhNQMf67qY+MPDQh/M76+tCcW34HTAU2tn8y
         hO4AbjkZdR0wQqpetcL1DdkfRegjglQ7CyUat59eFVl8+mq6YfhVvPbCL1K3qH2XrToj
         UP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=09bfi+qAyJsSRNe9KbtFKPfwmxdWD40fpDpgopNb6BE=;
        b=3SIn4/UzpIdLmv7gQiPqSTUZY3kyzyu9sbPqi35ICC000NauBH9wKIDuP90DZRHQrO
         8vGbeL7rpMBfWlb57xwg15ySKOf7ZYj2O4ZS+LNVXh2Nt4DMe+UoekEXN6ctd8KIYg95
         0BGd0Eb7jzYOt7wOQaIqiF6w+DREdzJn/CDPKWIZCtokNvp+GKa9PmIY1da6iO6GOgdr
         ZBUKwdM6DdfZEbqvw+yqwmG1DirwjFwFSH8x+X1dJHl0xPKxO64QAu6DagKcV58hz4hb
         3KS3lH8Q4mEP+frDfS+Spzm9EJSRbyrZ1xbCFeGlzjL8hRUZ8OHZQFl7pbwV3+A6oOfB
         XSPw==
X-Gm-Message-State: AOAM530cLKs7S/4fs+wBoppCB0N7hD83/RwMYbQPuaRs+AR2Xrg/u37O
        mt9G9RM3YPgYFK2AOr2pi4e8bMDeeoeav0mX
X-Google-Smtp-Source: ABdhPJypZawp0+uaSefm0xkiHqHpOeAIVeHIswTflKolPvKYzu++319OVTuMusmq76vcBrvdAvFLZg==
X-Received: by 2002:a05:6000:1f89:b0:210:552a:644c with SMTP id bw9-20020a0560001f8900b00210552a644cmr162947wrb.667.1654100994149;
        Wed, 01 Jun 2022 09:29:54 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id d6-20020adff846000000b0020c5253d8d2sm2020064wrq.30.2022.06.01.09.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 09:29:53 -0700 (PDT)
Message-ID: <ef3aaa3e-4bc5-4ce6-28db-a3de1e6a13f5@kernel.dk>
Date:   Wed, 1 Jun 2022 10:29:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC net-next v3 1/1] io_uring: fix deadlock on iowq file slot
 alloc
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <64116172a9d0b85b85300346bb280f3657aafc26.1654087283.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <64116172a9d0b85b85300346bb280f3657aafc26.1654087283.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/22 8:28 AM, Pavel Begunkov wrote:
> io_fixed_fd_install() can grab uring_lock in the slot allocation path
> when called from io-wq, and then call into io_install_fixed_file(),
> which will lock it again. Pull all locking out of
> io_install_fixed_file() into io_fixed_fd_install().

Subject was a little funky for this one, and I had to hand-apply it
since the base was missing that fput fix.

Can you check the end result:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.19&id=61c1b44a21d70d4783db02198fbf68b132f4953c

-- 
Jens Axboe

