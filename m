Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EAC557D48
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiFWNrr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiFWNrq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:47:46 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D4A3192D
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:47:45 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id i194so1138645ioa.12
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=aomQwH5hUP47KMqXdJBeAnailmowvbp4n5xIZdIFx7M=;
        b=OgPA6aPMxQ9dvQE9ib4vO120te0JCJN6LYga13rYIlvM5SIYNlJ2ABjEHxjChMaW5C
         XJ+29vTX0lVwZIKdL6xWxqwo7Br89fAdYkhKyYcWUTfy+DAefEt/9ZIZKj/V3I8kiAFn
         pWHakl1ErkmfsjGBZZh1IiAE0nNhoiVhdLUVWzn4wV1+kJAMZu/6Q/tIq9WfDLoJLdXJ
         35Kk/w33ihGcdX2bnOgZo2vql9c1kiFaf4z5JM56S0W857JX6cF3lztHP9PqbnmjZK+W
         s/P6HbDuROBbBM2lOczCB5OnHdNZwkdCg38AVBPBCoFozUoBOU/NguZ+xO0/Rd2Twyv9
         ZwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aomQwH5hUP47KMqXdJBeAnailmowvbp4n5xIZdIFx7M=;
        b=U4OorYJ6SsG2q8BGG+jvZ47y/rssNauH+C/M09/5vgQN/i3Abil63v7+OKu5qX1Bl6
         QU//7hfN4o+FajJAKAs03YPtnEh9nbpU0yP0hYEwls1qB9uJMNljzcadizRl2r5JPubj
         TRK1Rc+c4nRpxBqF5oVMCszXHItthN/qS1ujMDIV/HHPgo6/waVW8s4iY5gB8+/EPfbo
         pLd3jNWJIEd7zRVpcgn6Vqzzpo5JBulbzhqAvlXdl8Del5Oto9d7gI4ds/WWi2MsaOwi
         gtMK26sCFaOXZTU5nTxWXFblzAaCJzmITb8nuQr6QS8chA3z32JnB6F8ZlIiCdKbV1sR
         0UAw==
X-Gm-Message-State: AJIora9O3Dro0bDlYRxF1Sp+QNhh/0bUPx8MBzcPmAJBepekxzUKaesq
        Y4ur3/ryw3xBX1usOmitnYnC78u+DgcRZw==
X-Google-Smtp-Source: AGRyM1tI5ZtuoKzG3zvCKgMOJfJL1wM6BVEoxjfH0L/baBpdkfQEe66hLYojfSDzlclF1L6xPhEvog==
X-Received: by 2002:a5e:990f:0:b0:673:4f01:3a2a with SMTP id t15-20020a5e990f000000b006734f013a2amr2162715ioj.76.1655992064815;
        Thu, 23 Jun 2022 06:47:44 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l21-20020a026a15000000b0032e2d3cc08csm9871446jac.132.2022.06.23.06.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 06:47:44 -0700 (PDT)
Message-ID: <ab969989-4955-6395-a5f3-32dbaa07a6dc@kernel.dk>
Date:   Thu, 23 Jun 2022 07:47:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next v2 0/6] poll cleanups and optimisations
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655990418.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1655990418.git.asml.silence@gmail.com>
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

On 6/23/22 7:24 AM, Pavel Begunkov wrote:
> 1-5 are clean ups, can be considered separately.
> 
> 6 optimises the final atomic_dec() in __io_arm_poll_handler(). Jens
> measured almost the same patch imrpoving some of the tests (netbench?)
> by ~1-1.5%.
> 
> v2: fix inverted EPOLLET check

This passes tests, and I really like the cleanups before the actual
change. Thanks!

-- 
Jens Axboe

