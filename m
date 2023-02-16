Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E5869A265
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 00:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjBPXcY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 18:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBPXcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 18:32:23 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCDD26BB
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 15:32:22 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id d2-20020a17090a498200b00236679bc70cso370902pjh.4
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 15:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676590342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+H6FtjifSKxnPBbPmhhOs5v4s5uusqRcfXCwSpGTMYQ=;
        b=wughQO9hr6JBcDwgjWpPkcN2ihAYd4YYzMhZVLxc83ywgpdQXe+/IRC2nmL3yLQ+yB
         wXaxfO6+wRuM8FKLrZCklyxxHZMSxfsKI3wy91AOCvYjEGZcmP8hXu+Xeac5vmHnv+oS
         nP95ethVMSryQM018Ilhl/4RXK1+CzkfG6eL+53K6EbqxyJS22x1sz0MeejZc5XVF8ZM
         8Ntc1DdSi38ZZFcOJKYatWD74Pi9QcwP9POUNK4RQOkxdClKO2pExsVwUu1K977HlJRH
         2UMgvJ4rrTMnRmwx4EocDGSAiInS3YKejKJELTBbrH/56p8eDdPtZ3mL4AcrCJTRJfqy
         Z2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676590342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+H6FtjifSKxnPBbPmhhOs5v4s5uusqRcfXCwSpGTMYQ=;
        b=1Av9IpnuXawCjrQ+BjmrkUti6AEiE4V1eA77SalqoQza8g9QR5En+RUTF8KquQ+j9R
         ZRNibl4270VpSmrGzkGSJJtbMHcU4Uh0Y7+X7CjF7YG9o+gpvXBNBGtjQv0eLBCyg7qf
         kmmAI0Kopw8My+cPYZaIB7xy1wBbI2PkY3t4I/QQ5C4rI0BPIN6d1ITD8UiUPj/262se
         vH4MJ/rtbt8uwXvR0R9QGwbbBP+zTynHQaTQJfjTHUs6DeyiUJUKmr9BJPy7bo5FnaUI
         PmXhYW/TmWXchenBHS+3z9x1GR+ik8FIf0AoKVhBEGC/GbyG3oDSgDZcu4KwSjewHWrR
         ULNg==
X-Gm-Message-State: AO0yUKXuq530da99tGh2l7BDawv3TglDWN/sWUSNCgLp9cwiCME79PS7
        bkoHtZ4PukkKTyW7KSmgvjG8N/O5xiPDqFtH
X-Google-Smtp-Source: AK7set8/d8WJ1aJEIzoEdBzRJXu7rwI6lEll3g5I5PSYlsfLQ8cgtfYZu5oLB1pCPl8lPSCKl20gSg==
X-Received: by 2002:a05:6a20:690b:b0:c0:5903:d4b2 with SMTP id q11-20020a056a20690b00b000c05903d4b2mr8247367pzj.5.1676590341766;
        Thu, 16 Feb 2023 15:32:21 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b14-20020a65668e000000b004fb997a0bd8sm1691264pgw.30.2023.02.16.15.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 15:32:21 -0800 (PST)
Message-ID: <6eddaf2b-991f-f848-4832-7005eccdeffa@kernel.dk>
Date:   Thu, 16 Feb 2023 16:32:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: liburing test results on hppa
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, Helge Deller <deller@gmx.de>
References: <64ff4872-cc6f-1e6a-46e5-573c7e64e4c9@bell.net>
 <c198a68c-c80e-e554-c33e-f4448e89764a@kernel.dk>
 <b0ad2098-979e-f256-a553-401bad9921e0@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b0ad2098-979e-f256-a553-401bad9921e0@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 4:26?PM, John David Anglin wrote:
> On 2023-02-16 6:12 p.m., Jens Axboe wrote:
>> On 2/16/23 4:00?PM, John David Anglin wrote:
>>> Running test buf-ring.t bad run 0/0 = -233
>>> test_running(1) failed
>>> Test buf-ring.t failed with ret 1
>> As mentioned previously, this one and the other -233 I suspect are due
>> to the same coloring issue as was fixed by Helge's patch for the ring
>> mmaps, as the provided buffer rings work kinda the same way. The
>> application allocates some aligned memory, and registers it and the
>> kernel then maps it.
>>
>> I wonder if these would work properly if the address was aligned to
>> 0x400000? Should be easy to verify, just modify the alignment for the
>> posix_memalign() calls in test/buf-ring.c.
> Doesn't help.  Same error.  Can you point to where the kernel maps it?

Yep, it goes io_uring.c:io_uring_register() ->
kbuf.c:io_register_pbuf_ring() -> rsrc.c:io_pin_pages() which ultimately
calls pin_user_pages() to map the memory.

-- 
Jens Axboe

