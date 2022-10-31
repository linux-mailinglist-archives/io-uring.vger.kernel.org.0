Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557A5613AEE
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 17:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJaQCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiJaQCk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 12:02:40 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3741261E
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:02:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b185so11050293pfb.9
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gkA5OyNAhk007GQiM2VY4M3onWgK8ANgh6rRb43MkoI=;
        b=wX3nLpv5aRxJwWgkjXWvwv1jyNQN/amV8K79Jehtd2NMIQMFWKRu1EcVXtb7cYhNYj
         Fj7STp6ytVOhOw4CoJtVtu98KdpBFLL/HrIeNWVjAkwkO59yjg7Mdb5MLU0Jq7oGJC4V
         GTsPVadTENt3gBOUm7rbM1/YqjVnJYWHzsdC5IbGoXpRC0/gswLi8vPs+DMX0OFngXrw
         uFOOBQzQUUaUTGMZt5VB6NQQnV9B/5SBoDA4/DuD/LUWj7CXXB0Zz2IJSX8nxJU8h12W
         FJ1LysNGsRd4kCF1iIOZ9WWuhS2EN2WDL/cD9lTxWHQU8xemCmNkt7EJ0Fb9C9+71vta
         ArHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gkA5OyNAhk007GQiM2VY4M3onWgK8ANgh6rRb43MkoI=;
        b=jkOydij6i2cKCOifH5UyXgMT6/EWaNOcOgrmLv3LGBHfW/XcIHlQhUKIeSfWVoz7YA
         i1DD5NpM/mRh0ORCl3H0as4zESTNcQ06e9ovq4jLb9JFhZWGnArj/tc41D/3mlUbEsFD
         o9hxGsGtuZjahaClXp0TRgS5WYFAZfiAO4mu9+nL2gbtwqLtQ8FBJokfda1ESS+3ZuOS
         a/W//8TD8V2JSVf1gDdEbEUgo5HLA9dbYmv/7W9DckR5GPU6cz1XFXSTjjPryhAUgxgb
         +vKWgpnsaLHQzAZHvJ1b2ToVMy+c5Yj4eA0ExOB8AGq8RrUpfSpBcyWQIhmf3WOHN8Yd
         EiDg==
X-Gm-Message-State: ACrzQf2XzJKIjKzsolmp+NkpkB+x77k/73/c3U1pUQ+81KD30i8gtbWc
        lxHpM2RF4dac6RfIa59p23LJTg==
X-Google-Smtp-Source: AMsMyM62R7mvTRZnzBwj90duoRiv4sxNBfx2v/HXEN9135fAvN23FV2f4oBOd59Mwct3PLPLvyvyHw==
X-Received: by 2002:a63:81c8:0:b0:462:953a:8534 with SMTP id t191-20020a6381c8000000b00462953a8534mr13050028pgd.69.1667232158872;
        Mon, 31 Oct 2022 09:02:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902e3ca00b00180033438a0sm4629582ple.106.2022.10.31.09.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 09:02:38 -0700 (PDT)
Message-ID: <987d3d6b-7ea6-4fca-0688-060507706777@kernel.dk>
Date:   Mon, 31 Oct 2022 10:02:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-next 01/12] io_uring: infrastructure for retargeting
 rsrc nodes
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-2-dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221031134126.82928-2-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/22 7:41 AM, Dylan Yudaken wrote:
> +static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	percpu_ref_get(&ctx->refs);
> +	mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, 60 * HZ);
> +	ctx->rsrc_retarget_scheduled = true;
> +}

Can this ever be called with rsrc_retarget_work already pending? If so,
that would seem to leak a ctx ref.

-- 
Jens Axboe
