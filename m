Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B6D7CF6DC
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 13:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345340AbjJSLbS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 07:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345355AbjJSLbR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 07:31:17 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0969C197
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 04:31:13 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c9c3c51e01so5004905ad.0
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 04:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697715073; x=1698319873; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YtUpG3z/ptGXHxJZoUNCtfy+bOPW2YPP62H/52skaZU=;
        b=xXOnPQOgL1E3ea3wpzKhzoBnPd4CuE9TG3TCHpi70KoyPDBfI5UFWn36aI1chYJzyW
         n7zZCnr25wQgm8Qk8i9Juy3o+JOd5y8soK4T2knyBz/wQ955dorfBsbcDQVQIxwjG2nN
         /UMUofGqC6ulOI5zUiZPF/DS+RU/YykGb7/mY3A9akFgF26sI8olxfkUnddr+C4RTMWN
         /csWgixFChFfUWEoLS4FG8wgjVspCpeipzrigJIhhtNrvqFT7kap4nkIUtH1liC0ESVo
         mWUKmyYGw4a5n3gKJY8aRQHZva/NCQFLvNF37pqp7FPcJLATsT1bwO5+efBcpJv9UGYJ
         fpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697715073; x=1698319873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YtUpG3z/ptGXHxJZoUNCtfy+bOPW2YPP62H/52skaZU=;
        b=Ci1ImEO0KXBmjrXDY011BYj+7cebTU5qmMSIAv2qP2LRGpD3kk8wrZldtYvsYssLDZ
         I9PL8f6N1ZapxlnnDhjOI5g9z72dZhfafesYZrjcltYStBUhAgA6D7A1dat/10crjZI7
         ZOYOhb4CV7mn7dsnAYZAAx5flmkOWr/nO2BSK1hY0OMkTcMln544+41v92qeF5rFZ+sE
         rZRJSwarLdC5UKQ57jCqq3Xqapb0mfnHS10FMIXP4BOqKekVy8+gSB2uwc5DYMKrz8JM
         L9x91tJIWE7C1wzl/9si/Dy2AQK1JznL3Q4Yx7+f7tjjK/L8WarjMu3mI7yxa4Z8U6mz
         31EQ==
X-Gm-Message-State: AOJu0YwqaunogAVRxkShBfDNwNTkYTO4MRrkwcFqZBWiHkWXC3cTP2sM
        M8wckhcZ19tv92ZCQzuZx7Iwjw==
X-Google-Smtp-Source: AGHT+IFqXLGA6LMdVhqth4vl8VmPvVejV8pS+kMp2b+sRFA0vCR0lqi0vxmTE9tIt148LKFc7wCfdw==
X-Received: by 2002:a17:902:f7c7:b0:1ca:273d:22f with SMTP id h7-20020a170902f7c700b001ca273d022fmr2022936plw.0.1697715073210;
        Thu, 19 Oct 2023 04:31:13 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709029a8200b001ca23f2470bsm1705920plp.196.2023.10.19.04.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 04:31:12 -0700 (PDT)
Message-ID: <aa10bf89-779c-4383-a36c-5615f73dc6a4@kernel.dk>
Date:   Thu, 19 Oct 2023 05:31:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6.4 Regression] rust/io_uring: tests::net::test_tcp_recv_multi
 hangs
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Cc:     Guang Wu <guazhang@redhat.com>
References: <ZTDjhCk8TC47oBdZ@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZTDjhCk8TC47oBdZ@fedora>
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

On 10/19/23 2:06 AM, Ming Lei wrote:
> Hello Jens,
> 
> Guang Wu found that tests::net::test_tcp_recv_multi in rust:io_uring
> hangs, and no such issue in RH test kernel.
> 
> - git clone https://github.com/tokio-rs/io-uring.git
> - cd io-uring
> - cargo run --package io-uring-test
> 
> I figured out that it is made by missing the last CQE with -ENOBUFS,
> which is caused by commit a2741c58ac67 ("io_uring/net: don't retry recvmsg()
> unnecessarily").
> 
> I am not sure if the last CQE should be returned and that depends how normal
> recv_multi is written, but IORING_CQE_F_MORE in the previous CQE shouldn't be
> returned at least.

Is this because it depends on this spurious retry? IOW, it adds N
buffers and triggers N receives, then depends on an internal extra retry
which would then yield -ENOBUFS? Because that sounds like a broken test.
As long as the recv triggers successfully, IORING_CQE_F_MORE will be
set. Only if it his some terminating condition would it trigger a CQE
without the MORE flag set. If it remains armed and ready to trigger
again, it will have MORE set. I'll take a look, this is pure guesswork
on my side right now.

We've done quite a lot of testing with recv multishot with this change,
and haven't had any issues. Which is why I'm a bit skeptical.

-- 
Jens Axboe

