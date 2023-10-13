Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4707C7B4F
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 03:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjJMBpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Oct 2023 21:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjJMBpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Oct 2023 21:45:12 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C773BB
        for <io-uring@vger.kernel.org>; Thu, 12 Oct 2023 18:45:10 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-690fe1d9ba1so329645b3a.0
        for <io-uring@vger.kernel.org>; Thu, 12 Oct 2023 18:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697161510; x=1697766310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NkKDwESUMv6DmJniI4kRJ0Fze3BlCpWsKbtTeuEzRoQ=;
        b=wctTAqWM+C+AavijPGVNcXf4bwP+E/t8KAOEKi+zZG4WomkiYnQOuVGojNwl+bo1Fy
         kfVb9Y0l2NAq0k2sjYQSOnJdfEbR134ajyLXqORuY+Qph83AwRWE/6T3z7aTb1ubtMtQ
         xKOQ2jc67GIJXMkuJliRocizaVmoAx2MyjAfUzU4XvUrgvEAaSHQ/2qOqXxJEJF+abvJ
         sfERUcLnEhb6LnDv0ya5fLIlGmUwirNgqnIlxI7WdWz5s5xnwAmlnkvHmHGb4SqYVjul
         y5u9bI9EGvU8QWeR6dqxsq6h04/a32jq64ZNoIeYqn9uj1ezriMuQoRbHEs3K8KIZNSE
         pbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697161510; x=1697766310;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NkKDwESUMv6DmJniI4kRJ0Fze3BlCpWsKbtTeuEzRoQ=;
        b=BLc/uZEVs+rFl6B1e8rilk/1R0m/HHvEgoPGv8qk7ei7na+QKP6r9vxgggJo8F0DqS
         TznakwAjrty0Pfkxkq/x1NM37F4vd1R9hFBsPyPxbl18davRr20K63tqsGSNBsPvuo0Y
         g/VwRT/64CTKN4Z9JhRZom2toPdY8sf6NL6Bk5onU8x2IvUyAxYgATpjgK+N4fR9LX1P
         TFRqq/yDXRnbo/jX59RpuL0Pdwi7ij6gxfKFPWPHwZjXrp7m1LzeHzmTVZs3W/ytI3Cy
         d9ruV5aEXLdNxmcerxi2d3kloL08xpKPhkf5ZbFStupMaQ7D52MZ3zYstmO5r3fW9PYj
         ttZg==
X-Gm-Message-State: AOJu0YwZJSb35wyc8QeRlAsc0IwT2syjQf3huTWZ5CHW+guoAtGYofrH
        pd5aUhQP0UNgmCZeawukV4y2pw==
X-Google-Smtp-Source: AGHT+IFOeU/L1UU0SiBejqeHPkF2yLffG9fB6o7ii0U1VZbx4ZnCvJrB7MjXM1YaKAbTSIdFVKU0ZQ==
X-Received: by 2002:a05:6a20:7da2:b0:15d:6fd3:8e74 with SMTP id v34-20020a056a207da200b0015d6fd38e74mr31715422pzj.3.1697161509881;
        Thu, 12 Oct 2023 18:45:09 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l21-20020a170902d35500b001c737950e4dsm2659672plk.2.2023.10.12.18.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 18:45:09 -0700 (PDT)
Message-ID: <f39ef992-4789-4c30-92ef-e3114a31d5c7@kernel.dk>
Date:   Thu, 12 Oct 2023 19:45:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem with io_uring splice and KTLS
Content-Language: en-US
To:     Sascha Hauer <sha@pengutronix.de>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20231010141932.GD3114228@pengutronix.de>
 <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
 <20231012133407.GA3359458@pengutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231012133407.GA3359458@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/23 7:34 AM, Sascha Hauer wrote:
> In case you don't have encryption hardware you can create an
> asynchronous encryption module using cryptd. Compile a kernel with
> CONFIG_CRYPTO_USER_API_AEAD and CONFIG_CRYPTO_CRYPTD and start the
> webserver with the '-c' option. /proc/crypto should then contain an
> entry with:
> 
>  name         : gcm(aes)
>  driver       : cryptd(gcm_base(ctr(aes-generic),ghash-generic))
>  module       : kernel
>  priority     : 150

I did a bit of prep work to ensure I had everything working for when
there's time to dive into it, but starting it with -c doesn't register
this entry. Turns out the bind() in there returns -1/ENOENT. For the
life of me I can't figure out what I'm missing. I tried this with both
arm64 and x86-64. On the latter there's some native AES that is higher
priority, but I added a small hack in cryptd to ensure it's the highest
one. But I don't even get that far...

-- 
Jens Axboe

