Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7486A5F4BA6
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 00:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiJDWL2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 18:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiJDWLU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 18:11:20 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D566D576
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 15:10:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id f140so9032111pfa.1
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 15:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=9c4M4NaKYwplMQyV+GkcSll4buW+t3Sjd/Yj4MDRHKw=;
        b=tQsA8k2mYw22xI7s9M70ai/xj/eaL4qPzJ2kiDmzw+z1Ju72fmABqKfwSsOxfAbucD
         tWfGaY0DW5BrnU74eRKCRRl+yecWlCMLDIblUa0YC/zIiYViOgApabgUs/f2E45QN4xB
         4cJ06b0rcoUP2TOZ6+r5IZGKcLFY4StU9yXN1XNvD0eB3htUOmJmtpNQ+OTyF7yUFYII
         zm5zkAv4SSIFpeQVkSmDazhU0Fp0N2AHRo/RdHhw1/VhqS0RBmV+/FH9CqASxk47ffh+
         ymDjOcJd+Hl9RicJkCVkSbxAmMdd3MNDDbJmQVMmyhYrKpSqSaAiL9R2kN40QV337xpX
         R1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9c4M4NaKYwplMQyV+GkcSll4buW+t3Sjd/Yj4MDRHKw=;
        b=jmCm/eE2UkAKdmgXszTDAnTMOtIkXBRoz7/2M+Fz/X2zFnqZywIlScSjRB/EiFNe7W
         9O5u1JsC0FP68zAGuFNi0GGgLILwqmtxkiyKMWrgqSKMKFAAfE9/ihbN8ErPGf+ho5jp
         S4ulj13Knv2QAe72rrOpRTlwaFHI9xr4uvGy5cvfsux7fuaRaZ5FFasutDa5oLLGwZ5P
         T1qF8LuQEPXAvJ/2KK63SKDFeJODlHK8GjUNu1y5ozng0As8vVqSBybr8FG52XSQsZqi
         Eft12sSlPJq0m4f5TkzOJvS9F8GbG2gQkTEU+hCIhAlV61UkthS0p0gHMWBGTMy7Suei
         kl/Q==
X-Gm-Message-State: ACrzQf0kVtWtEbRMmkAaR0qDNQ9/LjSjz1smzGBj+jT56ZQPgKm23zym
        J+Ern+p230ZQQAA3ooVtK/zpjQ==
X-Google-Smtp-Source: AMsMyM7Mmvf+MrajTLKjZd44LA1r6QmvaJbevAc7dpsqiube9kj0tGNFPBv3uIaDW2ws9h0BFKryRw==
X-Received: by 2002:a65:6e47:0:b0:438:c2f0:c0eb with SMTP id be7-20020a656e47000000b00438c2f0c0ebmr24742972pgb.236.1664921441082;
        Tue, 04 Oct 2022 15:10:41 -0700 (PDT)
Received: from ?IPV6:2600:380:4b7a:dece:391e:b400:2f06:c12f? ([2600:380:4b7a:dece:391e:b400:2f06:c12f])
        by smtp.gmail.com with ESMTPSA id z13-20020a63330d000000b00434651f9a96sm8758274pgz.15.2022.10.04.15.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:10:40 -0700 (PDT)
Message-ID: <d7d4befa-bfff-e01f-817c-03158528e46e@kernel.dk>
Date:   Tue, 4 Oct 2022 16:10:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [GIT PULL] Passthrough updates for 6.1-rc1
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <dcefcabc-db87-f285-ddce-ad8db26feb2e@kernel.dk>
Content-Language: en-US
In-Reply-To: <dcefcabc-db87-f285-ddce-ad8db26feb2e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/22 1:40 PM, Jens Axboe wrote:
> Hi Linus,
> 
> On top of the block and io_uring branches, here are a set of updates for
> the passthrough support that was merged in the 6.0 kernel. With these
> changes, passthrough NVMe support over io_uring now performs at the same
> level as block device O_DIRECT, and in many cases 6-8% better. This pull
> request contains:
> 
> - Add support for fixed buffers for passthrough (Anuj, Kanchan)
> 
> - Enable batched allocations and freeing on passthrough, similarly to
>   what we support on the normal storage path (me)
> 
> Please pull!

Geert noticed that there was an issue if io_uring wasn't configured,
there's been a patch added for that. I'll send a v2 of this pull request.

-- 
Jens Axboe


