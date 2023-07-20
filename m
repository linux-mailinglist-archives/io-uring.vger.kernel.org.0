Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7828C75BAE6
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjGTW5H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjGTW5G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:57:06 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AF619B6
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:57:05 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5576ad1b7e7so174377a12.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689893825; x=1690498625;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NMEaaeRpqW3pwl1kKSSbYEAK9TzCFbNYPEL9DF7Pxzg=;
        b=WsoQTGTrAR6nfBp0UmcAXECaRnnsQos4IJ3tFnHdklJIalW7U5fyqxonoifjIeao9M
         T06e/Er5qV14XHmc4yoChVnWcQlEj25IuRi5kuu8/tbCG3OgqB1NOip508cu4KtCLWJh
         xcF4j1iYK2zlG2yt2TGo7uaa8gAD3FdFPmMGxCqO2Dm77aXv9Qxh370HuIl6mKJ+crME
         X6R/IAT63oaq2YKBraoP+pwkQpQ3x8qwZXkDqxrmSNuClwXGjXfYu8qkZGCmQ2XG1BIH
         ND7rGafEmhOXx4i3OG3ajRrnmUvErqzm+crv56w/PdpDtEf6A5B1pOEOX5UqmFh4NQbH
         4gxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689893825; x=1690498625;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NMEaaeRpqW3pwl1kKSSbYEAK9TzCFbNYPEL9DF7Pxzg=;
        b=gPiraFmAXdSqJ0FnZhTNFrtFbDamf1LrWiBV6JOYeTMILEcUQ+X/FvLoNxOPHcnUQo
         brz9vPDxlpmSvoELQGnNJrJJMru60lY4i8ij+cDTfK/CbqtLdjlFswKjC+5nS4yhwVXZ
         sN8flmvi8c6DiMQQeW3SoCuHjafP9GxniBgkr6Fll8KO0pvYYkfDnp4RWZEWaiKbNjDG
         OO2XOkvFwTHAsL72ExXoruN5QFtvIRcpBtEfRzvsQ5Jr0w+mtHrqrbWIUjRuHWY6/CJo
         DjUlP8tTUkLKl2yr3zqtwQskNkdUF0I7dhUyfmt+1xkYMSSvSxVUZljTf/D737Yf5oqg
         UyNA==
X-Gm-Message-State: ABy/qLbx9X2StkqnyAGjkVQwWECMkOSJDR8HYtX/kWhGcm1DqAWJb5jH
        pSlHmHaS64zc5ho4eAXWCa0PZPqe5G+eWDvTQgI=
X-Google-Smtp-Source: APBJJlFNwNJ3bT9Co3P8kF/6APaefDGA7dv8d0M5b7EZEYZJkROZSIosTmc8SYundLYh6u1u/S9b1g==
X-Received: by 2002:a17:902:ecce:b0:1b8:b55d:4cff with SMTP id a14-20020a170902ecce00b001b8b55d4cffmr484128plh.2.1689893825273;
        Thu, 20 Jul 2023 15:57:05 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c3c100b001ac40488620sm1922984plj.92.2023.07.20.15.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 15:57:04 -0700 (PDT)
Message-ID: <fc852c9d-558f-1f68-cb68-a59f10800715@kernel.dk>
Date:   Thu, 20 Jul 2023 16:57:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH][RFC] io_uring: Fix io_uring_mmu_get_unmapped_area() for
 IA-64
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-ia64@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        linux-parisc@vger.kernel.org
References: <ZLhTuTPecx2fGuH1@p100>
 <0a242157-6dd6-77fd-b218-52e3ba06e450@kernel.dk>
 <be208704-b312-f04d-4548-90853a638752@gmx.de>
 <6dfbaa5b-5894-bfc9-f9a9-09d019c335d9@kernel.dk>
In-Reply-To: <6dfbaa5b-5894-bfc9-f9a9-09d019c335d9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/23 4:43?PM, Jens Axboe wrote:
>> Do you have a chance to test this patch on the other io_uring
>> platforms, without applying it into your tree? I think some testing
>> would be good.
> 
> Yep, I can run it on arm64 and x86-64 pretty easily. Will do so.

Works on both of those as well.

-- 
Jens Axboe

