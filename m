Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343094FE451
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 17:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiDLPIL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 11:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351911AbiDLPIL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 11:08:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90185BE6E
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 08:05:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so3312347pjk.4
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=575yhJWOwnhQtoZd2ow0ufojHTa2PUfqoNWRJf0qa1s=;
        b=VRkKMQUHGuTf0cOje9lrnwLBUjYojyPIgqFvJ5VLDiYR5671J2MQF85WZzZRoROlik
         GZkfp+cKETvLKIxmph2wmOsWAaqZpMxG0xUUKbzPRE1ohCJ+Wna3kiXqifA0ajqhNo0s
         kZI/X31SZRgxjiHKFkKed2RMg8ntW+Mgc7pZuLFNnV4hTGRvI6DKjwVDo/DI2DVE1xKZ
         kvMhFsaO5V77PAzqRo9PoCAjQz8PIfayzo/BQ7oHm8anc1miGupDFiI3rb+0CCzAsl5O
         IlR9Qeum1F4BBZ0WOzYs7tHMMX0RFPC6SPIvPneEvh4CSEkO/QmiVDE10i//soGmsMS9
         9PkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=575yhJWOwnhQtoZd2ow0ufojHTa2PUfqoNWRJf0qa1s=;
        b=db1Qyqjp3/KeFIe1gk+IKR5D+Mg58fpJOjhpd8Lxk4Jba8gat3YLBPRbuorC+i1IyJ
         AkdDVqCMmXnvnbn0/mma0Vfh9juN8AKrZJttHTXsPOIaJCLPJvaKSXR2n+3h8jFQtw1b
         58qcXbGI7hJ97Qm1m8aixypfnzr1nuuYQnS8WfTlXM7sX4yL10E3BWZ9tSjLf4DHcwvo
         XMpElZIE9AeWq+uyJ0Ckjyut6/5F4x90wxLzuWmiaygsmG1IjogKbzbnfUj09DunkIit
         4CLNOHPZUCNjFKS7PqBoDz64Q939h/+01GySvruucm/TyY71oqa3OOvFvrrvTRUb4ic0
         c/Aw==
X-Gm-Message-State: AOAM533PXLVXwNxYgLzaCnHkGRAlXaYkLREyJp5TmV9G8Odg/+CtdBI6
        82xT5UPEvWIsbxv/1QCd2x0McZkL3hTS5/mT
X-Google-Smtp-Source: ABdhPJwjOwvzvT0VIMyfJB6/2vNxkNjgSHe9FIJ0O0ZWBp9vsMXJ3flxdyz4e1rZseirWeYE6jYCdA==
X-Received: by 2002:a17:902:b10f:b0:156:612f:318d with SMTP id q15-20020a170902b10f00b00156612f318dmr37577289plr.143.1649775952373;
        Tue, 12 Apr 2022 08:05:52 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h19-20020a632113000000b0039d9c5be7c8sm2285076pgh.21.2022.04.12.08.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 08:05:51 -0700 (PDT)
Message-ID: <3a0e08f1-ec78-f91c-e260-318b6bda1335@kernel.dk>
Date:   Tue, 12 Apr 2022 09:05:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH next 0/9] for-next clean ups and micro optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1649771823.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 8:09 AM, Pavel Begunkov wrote:
> nops benchmark: 40.3 -> 41.1 MIOPS, or +2%
> 
> Pavel Begunkov (9):
>   io_uring: explicitly keep a CQE in io_kiocb
>   io_uring: memcpy CQE from req
>   io_uring: shrink final link flush
>   io_uring: inline io_flush_cached_reqs
>   io_uring: helper for empty req cache checks
>   io_uring: add helper to return req to cache list
>   io_uring: optimise submission loop invariant
>   io_uring: optimise submission left counting
>   io_uring: optimise io_get_cqe()
> 
>  fs/io_uring.c | 288 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 165 insertions(+), 123 deletions(-)

Get about ~4% on aarch64. I like both main changes, memcpy of cqe and
the improvements to io_get_cqe().

-- 
Jens Axboe

