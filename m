Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D7354C810
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 14:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiFOMDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 08:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiFOMDH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 08:03:07 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E487E19015
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:03:05 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id e11so11255626pfj.5
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=CMgovceH9qvo6MCDqcicc5IbfTBWw5j59PqWqSzg2Fo=;
        b=4dCH16dl0H91o9yicWD3VNgAhy8NpBpw8Xk2TloKm4iYXhf3EDylU5e1P2SKquK42C
         YH9vMd3ZCG+hhb/5c+77EUpyv4fuFOpImbNCfH4+nSH7dNc7/F7KdJWLCnKmnzmYzfRV
         TEpa4MWgrGQNiSgDmqw2n1UCnUVME/gRA9JtFA120jOXbvBCzJoYaDlRf55TGZbgNOov
         xRmfgENqLKYVIjuGwVCDgBgioCmS9+sjc7QlLtBhFJng68iBIKY+6vp15K8vWp0gpAlV
         IUKGlYruKsGnNwYaysaRo5wdRPEJGJWk8o+riXX5x3xXPALiHHeMwCv/mD4x1wI9VBnn
         FBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CMgovceH9qvo6MCDqcicc5IbfTBWw5j59PqWqSzg2Fo=;
        b=fPldJuFlhPIMS8YyrBsXM23wxuFh5njBbl0722ItITWBzpR0+UW9sHnWNNyKnxBvIj
         iXXtdjWKIC2o3HJdwZNUMMekBecFPsCcgS8mDjdpbv60AdoP7m80kpHXjobsJFQNFv3F
         qhoggVNnULvQLkBg2Vm1heqQ98+DWtJT0xyzU3kbkxYvAo92IIRuBNnVFwGekd6p9Ah9
         DqwF3Q+eFRtM5ggJLZ59lQJ6g4GYQqEXLzarkRoF9a68Ovgkaxu+imBffWtdlfNoeXcV
         SX9Xmt6Y0xhCICRGaoWOub9defQ2R0sFwzl0O2flZhjUBPu+qTJQ3160oZaRCw8n4Ldj
         fyNQ==
X-Gm-Message-State: AOAM533TqHAuE70c9GCqJwStQiOKQwPrRzUIcFaqwQ3WqAkaBDfzu3RK
        v3VU1iykPy8VGc3y/LCr/jBJ004jOakYvA==
X-Google-Smtp-Source: ABdhPJxJlY8Dsa3HRZgI8yTmpiM6HChEb9AZAxYeJBhDjVgCg2etxhUmZSM68sp4jck2j/BFpVl5uA==
X-Received: by 2002:a63:da56:0:b0:3fe:2bc7:a605 with SMTP id l22-20020a63da56000000b003fe2bc7a605mr8915795pgj.560.1655294585313;
        Wed, 15 Jun 2022 05:03:05 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q4-20020a170902f34400b0015ee60ef65bsm9036181ple.260.2022.06.15.05.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 05:03:04 -0700 (PDT)
Message-ID: <52279d69-ee83-c6d4-cf02-7384bf758a9a@kernel.dk>
Date:   Wed, 15 Jun 2022 06:03:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19 0/6] CQE32 fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655287457.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1655287457.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 4:23 AM, Pavel Begunkov wrote:
> Several fixes for IORING_SETUP_CQE32
> 
> Pavel Begunkov (6):
>   io_uring: get rid of __io_fill_cqe{32}_req()
>   io_uring: unite fill_cqe and the 32B version
>   io_uring: fill extra big cqe fields from req
>   io_uring: fix ->extra{1,2} misuse
>   io_uring: inline __io_fill_cqe()
>   io_uring: make io_fill_cqe_aux to honour CQE32
> 
>  fs/io_uring.c | 209 +++++++++++++++++++-------------------------------
>  1 file changed, 77 insertions(+), 132 deletions(-)

Looks good to me, thanks a lot for doing this work. One minor thing that
I'd like to change, but can wait until 5.20, is the completion spots
where we pass in both ctx and req. Would be cleaner just to pass in req,
and 2 out of 3 spots always do (req->ctx, req) anyway.

-- 
Jens Axboe

