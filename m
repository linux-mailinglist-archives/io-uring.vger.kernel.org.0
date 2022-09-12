Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2025B5EFE
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 19:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiILRO6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 13:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiILRO4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 13:14:56 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727A2AE47;
        Mon, 12 Sep 2022 10:14:55 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id l10so9199245plb.10;
        Mon, 12 Sep 2022 10:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rGoF9S1tPTyhIfo+29v5A20vdNRYGUtH8TxtmaiKD3g=;
        b=2iQXuynY+016hLbvm+LWVeXGGGNFV/akxkAtPskwE19rLDsQolZLZZRuPmp4KVKhBf
         ww4fi90wClxk9NFNBRCkC2oOzt3ehRsTb1rmyGOZwRCoGdZt7bb7z34GbcoadK7I5zpf
         O8flzuGBWDSaBagi5CN/3nsYpVMKnV6uT0LYW1AZG7hzqdXQRqtkLXDOOGcSDPHkYsNe
         i4BHx6Mzkdu6pdfPmMBCRryQm+vU26Z02oRZdizhdB2lHdfnbj6KTaKLXISKwkP8RtoO
         AuDcWmpu5DBIYUP/92HG24mChhoitNHytXJS8WD15xN7uZqKddHSvu9hIW7rf1JvYXeQ
         Zzgw==
X-Gm-Message-State: ACgBeo1fs1XtXWJw7n8YSUVKcDDna9qPDMU/p3rxa0OMDbEHnpPaiJst
        BHqktJsRWakKfLx8tOs8FFM=
X-Google-Smtp-Source: AA6agR5A2KDaOkeK5a5si+hoQ2zSxhq5bUUW7RS1fpwi0a+lcHvJa0ORFKtRjBuWFzBJ2lPJawxg0g==
X-Received: by 2002:a17:902:8e88:b0:172:d1f8:efcb with SMTP id bg8-20020a1709028e8800b00172d1f8efcbmr27162646plb.27.1663002894839;
        Mon, 12 Sep 2022 10:14:54 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:2514:22ad:a954:81c1:a291? ([2620:0:1000:2514:22ad:a954:81c1:a291])
        by smtp.gmail.com with ESMTPSA id 68-20020a630547000000b00434272fe870sm981547pgf.88.2022.09.12.10.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 10:14:53 -0700 (PDT)
Message-ID: <24aad185-fc3e-420b-b638-227c4564bcf8@acm.org>
Date:   Mon, 12 Sep 2022 10:14:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v1] block: blk_queue_enter() / __bio_queue_enter() must
 return -EAGAIN for nowait
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, kernel-team@fb.com, axboe@kernel.dk,
        linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <20220912165325.2858746-1-shr@fb.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220912165325.2858746-1-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/22 09:53, Stefan Roesch wrote:
> Today blk_queue_enter() and __bio_queue_enter() return -EBUSY for the
> nowait code path. This is not correct: they should return -EAGAIN
> instead.

Why is this considered incorrect? Please explain.

Since this patch also affects other code, e.g. NVMe pass-through, can 
this patch break existing user space code by changing the value returned 
to user space?

Thanks,

Bart.
