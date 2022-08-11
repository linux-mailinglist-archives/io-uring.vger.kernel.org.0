Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547DD590582
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 19:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiHKROK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 13:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiHKRNp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 13:13:45 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC39E80F55
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 09:55:31 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id o2so15101663iof.8
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 09:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=D2Y1eCDWFOrc8ZZ01Z6GK1krSd7ild2hi3nlB+EruAY=;
        b=mJRMCYOkpchRj0L/Yyp/N1wWJ46LVn1b1hzKeyvJ/kpxQ4fucbezqNPQ6nGRH3Cimc
         DaCHA/1DQNVs1WaGYIHWeYxClXyw/M2K1WDMrisOM899a4ylwjMkDGgZCGoX72+r5zS4
         cTVySLZoTgtd/61nSNruUX1yjIf9/veQpJQW7dqJ6Msx1iwkpzzCEK/97moNNLQJeGwU
         XVavXJfjhBFPsZR1LujT95mn71UTVinHjTGavD+LPCM6n1/VWRFEARzSKN+N+w3KTu2R
         Uc56b2OX7IFFM/MuGaCufIvoBsHnOjvpqMQm43/69LXATIsKa7yqn3ugcuMh62cN1/qA
         98xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=D2Y1eCDWFOrc8ZZ01Z6GK1krSd7ild2hi3nlB+EruAY=;
        b=35bATTim6flMd2e3VVs6/jKfMCBS7LZjjZImy9u3qmNGCC+lLn6kK5EfjxdF+6E0ze
         vS3wuCNllihTbPe6ZRb1TnVx/QuUL7ZQIkhml0Z/SUNKmlVkLTS7NEbxAzNyFOQC+0Ci
         X0h2nauXYC7STEOy0shCQwz6MOYbqeJ5SbSsZHSeXFpcxNcfPm4Qd5OgmIbAqpyw9te8
         7AEN4/p910RLrtU3O8NGjMnyDBI5NQh5IV7fXpDsmUO4JsXD0jImG9evrHymOXOnf6lp
         Y1zpbMboZKqcM+4GezpCho27jIQvdLQzkFWUcttMYUTnifSl/k+8bWSz/SKvL9/YXaB4
         40LQ==
X-Gm-Message-State: ACgBeo3ZHhfbgGDhWFhxEcW9S726DaYNi+OQlBmG+2qOXowTHYNAv2wu
        48EjRaKVl77OMT57h9BkhmABJoSCj34NWQ==
X-Google-Smtp-Source: AA6agR7u1YJaBNZ2Nd8DvHPb7B5uog6mgFhEZ6AVLCyhuoFceKBUkzjJDzy7igVGRDTboWSxMnDcTw==
X-Received: by 2002:a05:6602:27c6:b0:657:7e7a:11f3 with SMTP id l6-20020a05660227c600b006577e7a11f3mr98832ios.40.1660236930854;
        Thu, 11 Aug 2022 09:55:30 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w3-20020a05660205c300b0067c05ad90d6sm3682618iox.19.2022.08.11.09.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 09:55:30 -0700 (PDT)
Message-ID: <f172af9b-2321-c819-2e29-357d4f130159@kernel.dk>
Date:   Thu, 11 Aug 2022 10:55:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: fix error handling for io_uring_cmd
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     anuj20.g@samsung.com
Cc:     joshi.k@samsung.com, io-uring@vger.kernel.org, ming.lei@redhat.com
References: <CGME20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb@epcas5p2.samsung.com>
 <20220811091459.6929-1-anuj20.g@samsung.com>
 <166023229266.192493.17453600546633974619.b4-ty@kernel.dk>
In-Reply-To: <166023229266.192493.17453600546633974619.b4-ty@kernel.dk>
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

On 8/11/22 9:38 AM, Jens Axboe wrote:
> On Thu, 11 Aug 2022 14:44:59 +0530, Anuj Gupta wrote:
>> Commit 97b388d70b53 ("io_uring: handle completions in the core") moved the
>> error handling from handler to core. But for io_uring_cmd handler we end
>> up completing more than once (both in handler and in core) leading to
>> use_after_free.
>> Change io_uring_cmd handler to avoid calling io_uring_cmd_done in case
>> of error.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: fix error handling for io_uring_cmd
>       commit: f1bb0fd63c374e1410ff05fb434aa78e1ce09ae4

Ehm, did you compile this:

> io_uring/uring_cmd.c: In function ?io_uring_cmd?:
io_uring/uring_cmd.c:113:38: warning: passing argument 1 of ?req_set_fail? makes pointer from integer without a cast [-Wint-conversion]
  113 |                         req_set_fail(ret);
      |                                      ^~~
      |                                      |
      |                                      int
In file included from io_uring/uring_cmd.c:9:
io_uring/io_uring.h:144:50: note: expected ?struct io_kiocb *? but argument is of type ?int?
  144 | static inline void req_set_fail(struct io_kiocb *req)
      |                                 ~~~~~~~~~~~~~~~~~^~~

s/ret/req obviously.

-- 
Jens Axboe

