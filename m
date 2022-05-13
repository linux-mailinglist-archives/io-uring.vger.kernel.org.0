Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191A1526254
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 14:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbiEMMud (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 08:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380451AbiEMMub (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 08:50:31 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4994ECEF
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:50:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 31so7402028pgp.8
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=mcLwwYnh3nLnjvH4TxkCjh9OnoZtVh71SsyQ1+k5COY=;
        b=mo1CArx6DadkGCUbhWp/h8qgZfyyht8AQKwcqee6ae8plWpQH/ad3pAX+qHDldI1Ly
         hfGRyjlaDweABj5NEmynKfmka5heFJb76CoRUHLBu47Ne6/Zo9+d0bMc3WnDrNj3uuLe
         Ad+esiOZQFqbQW9onFg73XpWu5bzDd5EPrUQa3/Dn19pZT7uPyqht1X5Te8cMZ6C/3DL
         YUmQFLrBNE3zHCDqDvPKmhBKdeqqdK/zA2IK25D4ZYqLZ2g9LfjbyrGPAY3rc6dKqg2f
         Ceyu6ISPtx70cPHbsKibsBFawo1hySfl9qz0bgwHDoZ6qytgihey9EbqW1hT0te+404j
         KTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mcLwwYnh3nLnjvH4TxkCjh9OnoZtVh71SsyQ1+k5COY=;
        b=KTyamGp9OOIiH8OsxIj6vAUYrYLo14I8CUvyxPOvoRb/FJCVEJ3IRmQ7GCTsbYVVCr
         FJelqdOf6YSgVU3RQM6jsAZd45svLtz4aSmUs9ercr9wSCtSwF62ehBmkOwnvOMIFB8Y
         YL1PgDVqNkklIjB9vWyNYUcVanOwZN35UTXntqN3g//MIegq6TTlRe3sAY8/pDWZKxN7
         nIaPPRirTYO3TkYW7zvozgKVOmX9Tx8z4Xl3T/vxl+/DmxVEquGDs/jC5Met9Ps7YypN
         E6i+zrcT2Y21USMmXMJerFishoiFEQ5DcUPnSXp5MVS/NAbZZ/rxhP/TNDQ4Ka2alKuU
         Ging==
X-Gm-Message-State: AOAM533HTdVrqU6LJ8AP790hC1ycRzK7ICULi8wpIcm98XVlYXfmLc0S
        i22umhFVLTM3svJSQu6X8IT5Zw==
X-Google-Smtp-Source: ABdhPJyUFMv5UMe8tj/GtpmKq/D6FpFjg6em+1cDZcLhsM4Vp5MPilYqTHU9pMnE5uCNv256ZUGaiQ==
X-Received: by 2002:a63:2215:0:b0:3c1:fd25:b6a1 with SMTP id i21-20020a632215000000b003c1fd25b6a1mr3905246pgi.406.1652446229077;
        Fri, 13 May 2022 05:50:29 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709029a8200b0015f36687452sm1678112plp.296.2022.05.13.05.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 05:50:28 -0700 (PDT)
Message-ID: <cfe6c401-5bf3-f3c1-cc99-b6a63efa93c4@kernel.dk>
Date:   Fri, 13 May 2022 06:50:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: avoid iowq again trap
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
 <64c7ae41-9c6c-5dc9-c58d-54bc752a2017@kernel.dk>
 <7876d493-2a63-c66c-7dab-4f6c57916d14@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7876d493-2a63-c66c-7dab-4f6c57916d14@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/22 6:49 AM, Pavel Begunkov wrote:
> On 5/13/22 13:31, Jens Axboe wrote:
>> On 5/13/22 4:24 AM, Pavel Begunkov wrote:
>>> If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
>>> might continue busily hammer the same handler over and over again, which
>>> is not ideal. The -EAGAIN handling in question was put there only for
>>> IOPOLL, so restrict it to IOPOLL mode only.
>>
>> Looks good, needs:
>>
>> Fixes: 90fa02883f06 ("io_uring: implement async hybrid mode for pollable requests")
>>
>> unless I'm mistaken.
> 
> It's probably more of
> 
> Fixes: def596e9557c9 ("io_uring: support for IO polling")

Yes, I think you are right and it goes back further. I'll get it queued
up, thanks!

-- 
Jens Axboe

