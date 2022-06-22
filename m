Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF555540F1
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 05:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiFVDem (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 23:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiFVDel (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 23:34:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15712F3A4
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 20:34:40 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id w6so7728394pfw.5
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 20:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=5tTaoOkUm7N/104mPXCzX6QbfOoBAAQhk+Xt2E63Urc=;
        b=mCJn1kOIVUQ0Gsctr5+01oD298Hs8HwWxRxKSk2fEVOtsQSHa8XjQjsKUxJJU8MA3G
         tFMROAOfkvBidaOz05a+SQBVW71Cie1/G7sOIkCU6HBgbAA3AmgBQjYwx88ZNJzMYXrZ
         xT3KjkJfKqprtx2VXswjkxHVhPs/CGq1yoc+zxsSnxYWhdld4/SYWCAHMaHTJ84DfOrk
         lJnPdXvvBBEZ1M8Lc2vklvM/dUiplYcnPfCcGg0kL/6A+dlyepxJQVdYLIA5vfDkievg
         HM0mG2wq06UOQWQKyaDigTaEMrmAKZ5NNLmn3C4BalXV/N/XEyfPo+sCWMMqTOtsLIa3
         DsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5tTaoOkUm7N/104mPXCzX6QbfOoBAAQhk+Xt2E63Urc=;
        b=T/EAsxkacQbZBM+j9ZODsx/oqkLLgeUzSOr7yBxfwQZ90TWQTI04NfeGygHETVHbse
         YAmqeHag3STaxGxJLo/YkMpcYDywB0SJ8fquh6L8VVqpD0yYblYFTjWoSAfpaPmezbR6
         x7AjwHcVbsgEaP+pgnARa8OC9TUwo1HJqIUz5Gygm3xF4D97UTFw4kJ/mkKZmmZNKtP5
         RRohoFCyQ8LMY8vrdyseYiwVVpiORj4M3MrrO6ZD/WDDVQ5+KwsXveUHbt2lekdLsXEH
         MMt3VUl3SuMM13dwTvvPt9Uf8y/28AybIf/yPkQ2ElIpD1xGXTuaY0cEbLwp6A5ecaIF
         kTLw==
X-Gm-Message-State: AJIora/PtXyq2obxIG/1i6ruBNLPA7SCeRWrVNQBxsYsDsBrondbpRDj
        HPkbSVpSVzBAMz4Ysb+xkuc51w==
X-Google-Smtp-Source: AGRyM1uW8HzYRyZVkzcLCY6ZCElwA5NqeVpVESUR+AeADsX2BT5PCG1vkNeFxwqWDjXlfoDna6Isng==
X-Received: by 2002:a63:8f5e:0:b0:40c:b763:7664 with SMTP id r30-20020a638f5e000000b0040cb7637664mr1134498pgn.111.1655868880113;
        Tue, 21 Jun 2022 20:34:40 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903124100b00163f8ddf160sm11381086plh.161.2022.06.21.20.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 20:34:39 -0700 (PDT)
Message-ID: <01605a06-a316-8202-e14f-7d85be20d7e5@kernel.dk>
Date:   Tue, 21 Jun 2022 21:34:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19 3/3] io_uring: fix double poll leak on repolling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655852245.git.asml.silence@gmail.com>
 <fee2452494222ecc7f1f88c8fb659baef971414a.1655852245.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fee2452494222ecc7f1f88c8fb659baef971414a.1655852245.git.asml.silence@gmail.com>
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

On 6/21/22 5:00 PM, Pavel Begunkov wrote:
> We have re-polling for partial IO, so a request can be polled twice. If
> it used two poll entries the first time then on the second
> io_arm_poll_handler() it will find the old apoll entry and NULL
> kmalloc()'ed second entry, i.e. apoll->double_poll, so leaking it.
> 
> Fixes: 10c873334feba ("io_uring: allow re-poll if we made progress")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cb719a53b8bd..5c95755619e2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7208,6 +7208,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>  		mask |= EPOLLEXCLUSIVE;
>  	if (req->flags & REQ_F_POLLED) {
>  		apoll = req->apoll;
> +		kfree(apoll->double_poll);
>  	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
>  		   !list_empty(&ctx->apoll_cache)) {
>  		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,

Looks good, my only question was on whether we should clear ->double_poll
here, but we do that right below so all's good.


-- 
Jens Axboe

