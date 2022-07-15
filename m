Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658555764D3
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 18:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiGOQAV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 12:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiGOQAU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 12:00:20 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F773958C
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 09:00:19 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id w16so2266750ilh.0
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 09:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rmpoX4O37nbYIxBzqGyioBhgmV198F5GjgDovHlcPks=;
        b=Qnu6EHnngw29XzGoUyf2ygFYP9hsNXagG+JPTBHSaraI2ZXnkmcSfbd/pfPLQIsS8g
         eQNkS+N6COBmRi0CHjx4cJ9hpeesikzuh6xGsGTR+1DYfMM4OzK5+g5d+XCl3FeBUGKb
         KIKWT10sLnDsWPR5vv5FZqPxJMxRyy+Fys9Hnjcimgfv3fTkMv8py84EMCUHY6BifeNN
         DbjuxA/zKCZfWMHjYVOnThcyr41Wd+Em7AxoC4kkfbI2DNHguIqkDdraIPDTXRkr4td5
         pZerhaKmbsrSZbZBSKriK79KDv4JyvH/+7mVhuCa3CsnqL9Z2X9xyGiAOlhry+ME6/DR
         rykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rmpoX4O37nbYIxBzqGyioBhgmV198F5GjgDovHlcPks=;
        b=l2G2UY9w4aL2byHQrLelynJ+2VsZF/UXe/O8wmPJtUW2K9MTeLfNJR2wPhzKq08ObI
         t+KJ/1xeugYvttXqUoWU5eW2EL9zP/gTT5AZo6H/E5HZbDfw/L49kjsv8sla/HMS10vs
         DL2/kqwT6Ms/WKKIEXb24gXTpPPQ+f6sjKvQtKoMEybHJQmssOfj69LaDZammaVcdF+3
         gUZCL1H/qDtPpdXTWKNeXOWT5Q1t0rv6Aic3v1Iaa1ZV2gzW7w9JM4R7GpIOsu1Pgbx9
         Y1dOrFQ4r9acti8rJTlRxbftTsq2mx/Ud2zIwny6nKbrGlj1nG9Xwy/6nPKs0Y49f4lZ
         3q/g==
X-Gm-Message-State: AJIora9WL2uh2vzkmJQJreMM3Wxesi2XXrcNjzR5bV1e2794qgwGQrvV
        rZhA6Hlv8KlUj9k+8zLlCfiiCg==
X-Google-Smtp-Source: AGRyM1tQ9KmDcbdBM6tbIkW5FHvjXmLg/s444KN5ra6tgSKQGB679jWHox2sheILd7kuqfqa4WOHjg==
X-Received: by 2002:a05:6e02:1d95:b0:2dc:4746:6a2d with SMTP id h21-20020a056e021d9500b002dc47466a2dmr7107157ila.322.1657900818837;
        Fri, 15 Jul 2022 09:00:18 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k7-20020a0566022a4700b0067becf1978csm147064iov.4.2022.07.15.09.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 09:00:18 -0700 (PDT)
Message-ID: <8a9adb78-d9bb-a511-e4c1-c94cca392c9b@kernel.dk>
Date:   Fri, 15 Jul 2022 10:00:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 5/5] io_uring: remove ring quiesce for
 io_uring_register
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Usama Arif <usama.arif@bytedance.com>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, fam.zheng@bytedance.com
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
 <20220204145117.1186568-6-usama.arif@bytedance.com>
 <20220715154444.GA17123@blackbody.suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220715154444.GA17123@blackbody.suse.cz>
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

On 7/15/22 9:44 AM, Michal Koutn? wrote:
> Hello.
> 
> On Fri, Feb 04, 2022 at 02:51:17PM +0000, Usama Arif <usama.arif@bytedance.com> wrote:
>> -	percpu_ref_resurrect(ref);
>> [...]
>> -		percpu_ref_reinit(&ctx->refs);
> 
> It seems to me that this patch could have also changed
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1911,7 +1911,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>         ctx->dummy_ubuf->ubuf = -1UL;
> 
>         if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
> -                           PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
> +                           0, GFP_KERNEL))
>                 goto err;
> 
>         ctx->flags = p->flags;
> 
> Or are there any plans to still use the reinit/resurrect functionality
> of the percpu counter?

Ah yes indeed, good catch! Would you mind sending that as an actual
patch?

-- 
Jens Axboe

