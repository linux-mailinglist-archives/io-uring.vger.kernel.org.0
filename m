Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DFD5153BF
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 20:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380017AbiD2SfD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380021AbiD2SfD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:35:03 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C473D6A435
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:31:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so11233944pjb.4
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:references
         :content-language:in-reply-to:content-transfer-encoding;
        bh=Nydb2OkBDtppCQEc3lJNsVExaegvRBKpFB6tFOI9J2g=;
        b=BltNBwIlAc9e7/F/O9ISHTTsvr1EyCsTAnFv0yvtLLtOK67lKZGbTWGxBcQ86KTTst
         3HOjlw0cLbTwGYJiUceNDGAan+JDewIwGXhVqAegQxpyF8h3ty66F/ULq27oCwzaCij2
         vmu5HKqmcHPkpYlJA0F6QKCdIY31NE3WjgFXrWg0rDYemIy/hcs/k4UOpGtj2CqEq+6x
         nr8L1Sg3ZZa7/coNRJu8yZFhG6ecr4FqL2PmBJ7dq/PBCFtEfp9WRZGatA9k9ztK9JNO
         gy0/MKfDlBylgGYTwtknqubA+ovl3wnFEFidEyYuafG0pFrfRq87hmSC6VdDQfJrwY92
         Tgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=Nydb2OkBDtppCQEc3lJNsVExaegvRBKpFB6tFOI9J2g=;
        b=oYzPwh6i322TAqw9x3DQLFmuvCpfnkRkVG2lVqZWI9QWc4BsoZCpKPBBensz8Bu+2z
         BOyouqFpmcPp79wo12xeV7d+KhRWLVrJCwzPuuNJGG3lA1N0QSKjoYBos+eX/gwTMali
         H2NxZxSNdvnnHaClQEGetRkEcSRqZMUehv9Zqf4BiNAmQUqffEYMabbuRpbRWnUxywgQ
         kpk+zQbbLseisuBySGu/RzLB+YRqwJJeJ6LyhA+KXulSmYyxMfO+Vjo5RgXx6WUpxcXI
         BnIZB7pUdx6EnkOOp8TBhicUkQx7IX+fgY5MpoJmkNj5vX8p2Y0RuoGR/zvhdKr8foPr
         dgPA==
X-Gm-Message-State: AOAM533JElqaF8Fr5BHjPgyStzabrwImvyJvgtZHT8x5B2uS9f/aWEOi
        JwI7wsZD88e+HkN30KWQaxouAM5PoPBaTg==
X-Google-Smtp-Source: ABdhPJzyGA1qp8mXi8h4KuHwK5u33u/kcDaoBxL+RA07ADmUFiLz0OEHDO4Zrrv0E1jcN7oRBXCcSg==
X-Received: by 2002:a17:90b:1bcd:b0:1da:5010:ff44 with SMTP id oa13-20020a17090b1bcd00b001da5010ff44mr5369770pjb.1.1651257103328;
        Fri, 29 Apr 2022 11:31:43 -0700 (PDT)
Received: from [127.0.0.1] ([103.121.210.106])
        by smtp.gmail.com with ESMTPSA id e12-20020a63e00c000000b003c14af505f9sm6054396pgh.17.2022.04.29.11.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:31:43 -0700 (PDT)
Message-ID: <7368ecc8-1255-09a5-0d1e-e4250062f84e@gmail.com>
Date:   Sat, 30 Apr 2022 02:31:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Hao Xu <haoxu.linux@gmail.com>
Subject: Re: [PATCHSET 0/2] Add support for IORING_RECVSEND_POLL_FIRST
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220427015428.322496-1-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20220427015428.322496-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/22 09:54, Jens Axboe wrote:
> Hi,
>
> I had a re-think on the flags2 addition [1] that was posted earlier
> today, and I don't really like the fact that flags2 then can't work
> with ioprio for read/write etc. We might also want to extend the
> ioprio field for other types of IO in the future.
>
> So rather than do that, do a simpler approach and just add an io_uring
> specific flag set for send/recv and friends. This then allow setting
> IORING_RECVSEND_POLL_FIRST in sqe->addr2 for those, and if set, io_uring
> will arm poll first rather than attempt a send/recv operation.
>
> [1] 
> https://lore.kernel.org/io-uring/20220426183343.150273-1-axboe@kernel.dk/
>

Hi Jens,
Could we use something like the high bits of sqe->fd to store general flags2
since I saw the number of open FDs can be about (1<<20) at most.
Though I'm not sure if we can assume the limitation of fd won't change
in the future..

Regards,
Hao


