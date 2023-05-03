Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655C46F5A76
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjECOzk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 10:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjECOzj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 10:55:39 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284A94231
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 07:55:38 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-32ad7e5627bso2880365ab.1
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683125737; x=1685717737;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dl/IBw2WdBnGYyKwNqM3waEYSLRJqlPrI5So0a7cmo4=;
        b=jh0PZjcTTw6r3RsWYgRljO9mnehUNwHm8wCXxj5p0I/WBgzT6r6Y9eUtB6JX9Jz4md
         lJRSdhoWFY+5sIdgFc+aU10wHRGalqPUfJzXvr3oJRsE3KbW7AbEZ24d6M/JHtOCee3c
         6rCx6JF8QxxLVpr6GyzpFJWx56Fa7AX6swscSE7nAP9Gh0HyR6WW5Y9lIGT4hIHkhHvB
         7hfprbShIxtXhf7Jf2lpEuHEvC8a7iG49LpGRrbJyL4b0qUJyDRzn9G5A4w154C2T2xQ
         wa+HK3O4TwBsDmlEq1nyaC0U4SPhcloNoMz0m4NBpaop+8lqr7O0qHnth6vqRW8IscjQ
         awPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683125737; x=1685717737;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dl/IBw2WdBnGYyKwNqM3waEYSLRJqlPrI5So0a7cmo4=;
        b=ACOBUURzyjIcHOkd29Kf/I8OqeritYY82TeYq6NKdIG7TR4hpSGxIYwZt2GSVsTGjf
         5tweD/0oEE0HF4hL8h+YMiRhDUVC7kaZbhh354GpuPSygpdi8D/Y0ABxm69oVNQdS3PC
         hARQ0T8JeeYE4yQ9aKAEqxKL0fCGMHsoe+0sj+3Kjbs2YPjDMq9jtyn+rLEKGwY2UdNY
         v3CIL8Qm0J/xxFS6+j5mmSyt48jp8xYCJ8NR6bPha29IWoqv24/6K9g3rKK3moEY9cUQ
         XnDq+UaOCML8Q5FbRKqtTB7TVqVWp31odVWjfvbsApftpYnUOXKrNgjRFqmFPkead/Q3
         2QdA==
X-Gm-Message-State: AC+VfDx3NECyvzhG7zWRDWU2+nj8RPO6eTnLjbXEzJqTIyMLiWP5lHxU
        NQ+t4FdUP0YFeCsqumjHRsjz9X8ZKGSE7hAbAaM=
X-Google-Smtp-Source: ACHHUZ5VXEjsC32p8xkbnsZFFEMqdTdhrUwhHE2cyDtgjEhthFl41CpC9eMtd/ZiYQObO6B8nP/OFA==
X-Received: by 2002:a6b:3e57:0:b0:763:542a:f26e with SMTP id l84-20020a6b3e57000000b00763542af26emr3359154ioa.1.1683125737391;
        Wed, 03 May 2023 07:55:37 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k21-20020a056638141500b00406237f0752sm9813157jad.1.2023.05.03.07.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 07:55:36 -0700 (PDT)
Message-ID: <64e5fbc2-b49f-5b7e-2a1e-aa1cef08e20c@kernel.dk>
Date:   Wed, 3 May 2023 08:55:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
Content-Language: en-US
To:     Ben Noordhuis <info@bnoordhuis.nl>, io-uring@vger.kernel.org
References: <20230501185240.352642-1-info@bnoordhuis.nl>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230501185240.352642-1-info@bnoordhuis.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/23 12:52 PM, Ben Noordhuis wrote:
> Libuv recently started using it so there is at least one consumer now.
> 
> Link: https://github.com/libuv/libuv/pull/3979

If we're going to apply this, we also need to have your Signed-off-by
line added. And then I think it'd be a good idea to also add:

Cc: stable@vger.kernel.org
Fixes: 61a2732af4b0 ("io_uring: deprecate epoll_ctl support")

so it would wind up in the stable releases that have the original
deprecation patch.

-- 
Jens Axboe


