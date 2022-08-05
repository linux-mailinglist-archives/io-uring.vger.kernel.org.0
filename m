Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7952258AEC1
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 19:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbiHERSm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 13:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240921AbiHERSl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 13:18:41 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D8A46DBB
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 10:18:40 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id x64so2381948iof.1
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 10:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=6/DqADyM3sQL00vGbUB26CuaAWBmO6y2rTbxXW/U54A=;
        b=K4Ws868YsLAywh1TYSuPdBFWw1OHzTF4oRD3ojGV4ls1+9JqeThR8AT4u8dur7vr6r
         JUJwUMgxXrlL2OusvJHSE9LRwX2aZmW+1Q8t0nLQoDaE5RJo+DD3XU9xNSbbAph4Z/Zi
         mBUFiqpsPmtx/jKr9pDWU9YpBIAyA2w6wR7jrOtTD4HLH9Q5+LguDT1LkCv081QKdgZ7
         IWd+c43VlfwQpq8lSAUnxQUCRdUQ8pnA8QZBzco0rv8PQXMVBBRLInP9hYQachOP33G4
         rVwOZG6Y/EEvQXCXc6R+xAjGVpCsNewi1NcE/lb9IA3U4QvP6CCD3inQfLT1c2E2GypM
         yC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=6/DqADyM3sQL00vGbUB26CuaAWBmO6y2rTbxXW/U54A=;
        b=bNtZskCOr3fo+DTYTK6HZsYs8jEB2MHxlqnvUl5hlNRFyPvYg4JPwjxaygiXjOgqRd
         32Tl/zboX1EMshIxfl5hKE7j3BGvdGMtTq1bIiktCCbZNqBgzZo13e9JUzqO2863/VUP
         agT4pcQnKPU+EYgF30d53wlM8JlNVqvRySg49lmp57JuYjKeDswNOzBBx9QjxxVOzJTs
         wOBnikyy6xhuGZmUBJ97yxM4yqkx2pdGkIX/s1wRE3pv5VR9uQog3mvyLw+1xjtj6N5T
         r9xIFfQaU4Hr8TNlETbxxJtFHOK8UJoICzvLfkvM2vifiBGhqMv0dlkeC81wRfV3ZgBj
         eEUQ==
X-Gm-Message-State: ACgBeo2F/MKhm1rGLtv3ZWthRJhg8by2VUBglplfm+aLCC85P5uZq/gR
        WEq25nDRrwV+5cTSHKAhQc0DZA==
X-Google-Smtp-Source: AA6agR55dbbtqPssP7l2tXFfNISN7x+xN1v8y2BsnPEQiP22QyEVvoTIOhvxc54whmXNc9sfXWaxxA==
X-Received: by 2002:a6b:3f85:0:b0:683:7d5c:dccf with SMTP id m127-20020a6b3f85000000b006837d5cdccfmr2391543ioa.48.1659719919519;
        Fri, 05 Aug 2022 10:18:39 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i9-20020a056e021b0900b002d90c9077a2sm1822759ilv.57.2022.08.05.10.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 10:18:39 -0700 (PDT)
Message-ID: <a2a5184d-f3ab-0941-6cc4-87cf231d5333@kernel.dk>
Date:   Fri, 5 Aug 2022 11:18:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/4] iopoll support for io_uring/nvme passthrough
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com
References: <CGME20220805155300epcas5p1b98722e20990d0095238964e2be9db34@epcas5p1.samsung.com>
 <20220805154226.155008-1-joshi.k@samsung.com>
 <78f0ac8e-cd45-d71d-4e10-e6d2f910ae45@kernel.dk>
In-Reply-To: <78f0ac8e-cd45-d71d-4e10-e6d2f910ae45@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/5/22 11:04 AM, Jens Axboe wrote:
> On 8/5/22 9:42 AM, Kanchan Joshi wrote:
>> Hi,
>>
>> Series enables async polling on io_uring command, and nvme passthrough
>> (for io-commands) is wired up to leverage that.
>>
>> 512b randread performance (KIOP) below:
>>
>> QD_batch    block    passthru    passthru-poll   block-poll
>> 1_1          80        81          158            157
>> 8_2         406       470          680            700
>> 16_4        620       656          931            920
>> 128_32      879       1056        1120            1132
> 
> Curious on why passthru is slower than block-poll? Are we missing
> something here?

I took a quick peek, running it here. List of items making it slower:

- No fixedbufs support for passthru, each each request will go through
  get_user_pages() and put_pages() on completion. This is about a 10%
  change for me, by itself.

- nvme_uring_cmd_io() -> nvme_alloc_user_request() -> blk_rq_map_user()
  -> blk_rq_map_user_iov() -> memset() is another ~4% for me.

- The kmalloc+kfree per command is roughly 9% extra slowdown.

There are other little things, but the above are the main ones. Even if
I disable fixedbufs for non-passthru, passthru is about ~24% slower
here using a single device and a single core, which is mostly the above
mentioned items.

This isn't specific to the iopoll support, that's obviously faster than
IRQ driven for this test case. This is just comparing passthru with
the regular block path for doing random 512b reads.

-- 
Jens Axboe

