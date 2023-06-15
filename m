Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EBF7319AA
	for <lists+io-uring@lfdr.de>; Thu, 15 Jun 2023 15:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbjFONN6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jun 2023 09:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343697AbjFONNu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jun 2023 09:13:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBADA294E
        for <io-uring@vger.kernel.org>; Thu, 15 Jun 2023 06:13:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-25b8e18c6e3so1026505a91.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jun 2023 06:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686834813; x=1689426813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g1B1o/FLv9G0pUm1w2hOwI7VRYkKM2WCDqp7dFZZlHs=;
        b=NxuAR8Kwlaeh/EmM1YCgCVqYyw6uo92KBbxLVItzxTFf/kOvv92ue2AYLsEwBT9uJb
         UwLIbo4RYn5vetNgHJS1efdFP5hetZzoQ0RJ1xTF1jqSumRQ7LFHxWMvRcGX71raeM2w
         5F7GToKM2tzpJl6DIm7fz0ROqrC8k18jzvopqmfB7aFf91epmPNpL+4BR6BsranQ4QXm
         L4AFcQuMep4XB4CN4eBft6LJ0aTGFUB8kq6L44upxPCWlLOlZsP0Q3BPhuErKOR16kXM
         f723VBQCousEB8mvomyvAOvsUNbUF7FURhWHCnoWA6bK9lZui2bBDM9kmgDn5o1/6rDd
         xUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686834813; x=1689426813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g1B1o/FLv9G0pUm1w2hOwI7VRYkKM2WCDqp7dFZZlHs=;
        b=WACe7wGh9kNZcCKbi3nvBrow90nXi/UnqiQr7vPFO+EljN9f1PYL4okK1iEddsibk6
         A7SpMsYcwip0J2KaVPairuiuvTOv8j0QCMKmjrtTxUnT/QWxUr59bbDEdPjrLrcyv6Ah
         5xa4gfSA3XUTHbYQac8efBEzOfyVKlFRzl96B4dEMFT3zb/kveCyLb2fNfUtRls2D7rK
         n0MD8q4+IOKJeXgj50klwH439iksD+P9uDLoWuNrWPU4vtPIKK1mgkueXtjVS976j0fn
         /PZrE9GzhDd7EfoVfZ8VYhJlBPW1VPvSGAtzqrj3hjZ7A3HTDl26gW+6w4jnKaLaNaMy
         BqEg==
X-Gm-Message-State: AC+VfDx75MXNAN8p53McrUDVV4yI5EllCVPoFrojMH3ihZudELPfnpy8
        iy8dl5nJ8mbzaX7fC8KFrOytCg==
X-Google-Smtp-Source: ACHHUZ6nCkovgZAgHNee1ALFg9f+niLoHWwizdqsMfP5mdeUjMGgTN+jwfaM9Dq/iz4xZ0yunDXZtw==
X-Received: by 2002:a17:90b:3852:b0:25b:e83b:593f with SMTP id nl18-20020a17090b385200b0025be83b593fmr13345455pjb.4.1686834813160;
        Thu, 15 Jun 2023 06:13:33 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ga12-20020a17090b038c00b002564dc3cb60sm1881320pjb.9.2023.06.15.06.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 06:13:32 -0700 (PDT)
Message-ID: <ec762677-f8d4-94ab-e7b3-adee45a052a1@kernel.dk>
Date:   Thu, 15 Jun 2023 07:13:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] tools/io_uring: Fix missing check for return value of
 malloc()
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Chenyuan Mi <cymi20@fudan.edu.cn>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20230615125045.125172-1-cymi20@fudan.edu.cn>
 <34898926-681e-1790-4303-e2b54e793a62@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <34898926-681e-1790-4303-e2b54e793a62@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/23 7:00?AM, Ammar Faizi wrote:
> On 6/15/23 7:50 PM, Chenyuan Mi wrote:
>> The malloc() function may return NULL when it fails,
>> which may cause null pointer deference in kmalloc(),
> 
> It's a userspace app, there is no kmalloc(). Also, I don't think it's
> worth to fix a missing ENOMEM handling for that old test program. But
> anyway, let's wait for maintainers' comment on this.

Definitely not worth it, and I find it odd how the author would target
just one of multiple allocations in that file. I'm guessing it's because
this checker only checks for malloc(), and no thought has otherwise gone
into a) if the patch makes any sense at all, and b) if it does make
sense, are there potentially other cases to consider?

-- 
Jens Axboe

