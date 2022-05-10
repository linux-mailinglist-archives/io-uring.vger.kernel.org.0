Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D5520BF1
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 05:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiEJD0X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 23:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiEJD0W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 23:26:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E0F2528D
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 20:22:25 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so1012691pji.3
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 20:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=lbYYE3FkgJLMrhEBukuaEzA7b4wZvwXXam8n++hprXI=;
        b=tj8d7aK8Cc6brpCobS1tE6+YGdW4kh/dXlcKYN9Bktt4IUeti04fAN4NFT89Kai94q
         BaBwUWrj6TG8MBxDmjf6q06An1dR0pziEkztU3HYa6sBGR28pEzmI3sreC+3zFE8smxd
         jvuKAd0uajb57bGblTQ84Nbg6C4qljTW4G6oerzcJ/3HZ0ha36yqzkAuw8Oy8ndw6jca
         JQl+oCC7N+k0oTTtmsvka/glxWUhEl2cDWbe82VZ+/Pq7ffzFUgAF4TqlaIk8BEB5HfG
         o1LFRFQ/CYE8jXFsWXzk3IcE6P0BzgUkcXAJ6liNgHP22sqZF+3sChoYqf3P3+n1or98
         hJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=lbYYE3FkgJLMrhEBukuaEzA7b4wZvwXXam8n++hprXI=;
        b=AIK1Cj1kSorQdLluyPHgJiRW3T9NC066A2BR3F+p3DrDauPIRLDMkEpThs9aQI5/Gs
         HYHFzFaIi+AKMl2TYSZnJnkjHOtBKb6atO4k2cFz0M0EipL935oI45yxPxSOfgv6abab
         +/W5tTwXvLqCKHJkOPhzJQmdl/bmecn6UZKYfdK6pGFd+tTN9R40RlvchZ/lGQ0w3zU9
         Mjgn9JUzEp8+jwhoOnII1uDAw1KQH3fpWBAIJJKV7etAJwXx4ygDdSE2g86eSPFbkyti
         rWAPRa6SGKGDoWeWbK0d/AqgPfvPqb6NospUhXPD/7+ylz1RvUZKptF4qg3t0RGjFQDj
         v3Wg==
X-Gm-Message-State: AOAM532rdV3orEsgYtySDsxdazyeHwqPciVPGLLE8/QnlG+B7fCsTqMc
        +LXoLhAQKe0PmsAiPU8+UkD34A==
X-Google-Smtp-Source: ABdhPJzl4VdwZ7UMRHEaqo6JpBbMLQR7N+wiAn4UZdUdT/KleoEJ+nclK7nHnRjZXteX+mbTbs0A3A==
X-Received: by 2002:a17:90b:1291:b0:1db:eab7:f165 with SMTP id fw17-20020a17090b129100b001dbeab7f165mr29271123pjb.74.1652152944749;
        Mon, 09 May 2022 20:22:24 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e1-20020a170902f10100b0015e8d4eb20csm678627plb.86.2022.05.09.20.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 20:22:24 -0700 (PDT)
Message-ID: <c3eabd1b-c68a-498a-8dac-73bb51a7a654@kernel.dk>
Date:   Mon, 9 May 2022 21:22:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 0/4] fast poll multishot mode
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <SG2PR01MB241138EDCD004D6C19374E80FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
 <SG2PR01MB241141296FA6C3B5551EA2BBFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
 <e43d206b-1fdf-556b-4667-c2572709c18f@kernel.dk>
In-Reply-To: <e43d206b-1fdf-556b-4667-c2572709c18f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 9:15 PM, Jens Axboe wrote:
> On 5/8/22 9:43 AM, Hao Xu wrote:
>> Sorry for polluting the list, not sure why the cover-letter isn't
>> wired with the other patches..
> 
> Yeah not sure what's going on, but at least they are making it
> through... Maybe we should base this on the
> for-5.19/io_uring-alloc-fixed branch? The last patch needs to be updated
> for that anyway. I'd think the only sane check there now is if it's a
> multishot direct accept request, then the request must also specify
> IORING_FILE_INDEX_ALLOC to ensure that we allocate descriptors.

Oh, and I'm assuming you added some comprehensive tests for this for
liburing? Both functionally, but also checking the cases that should
fail (like mshot + fixed without alloc, etc). When you send out the
next/final version, would be great if you could do a the same for the
liburing side.

-- 
Jens Axboe

