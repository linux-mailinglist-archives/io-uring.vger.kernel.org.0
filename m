Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7EF504A6A
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 03:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiDRBZP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 21:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiDRBZP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 21:25:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5C3DE5
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 18:22:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n8so11231862plh.1
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 18:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=oOx5QKsqtCbmbKdRgY5fVJc0bCF1Q4fCmLw3QUyfvcE=;
        b=T21a8FeZvwf6VaJhyMGDGVe8smgyCkTJOdFKmKh+Cl+FHudEJvXkEXT1qAml11EdEq
         ALINe6jdwHfl9cR+ycb0mEHlnBcvWPyfI/lExdjlSPiH0c3K1OXSLfqDx3Io0duY4cFu
         gq8rDoXHtwWRuMVobvo1mvL7exbPkxOIrg+yJ5slRgeBUupfdQaa+abgP/zHYkF2r5H/
         lmHPeRk2YndnUs/virzNioxXDw7TmmBL/JGZhM0r2l6qzQsmN6689cdWLhJSCKiF597x
         xHG9VDZjMx5zns/zrujTQRZ/94Hq2MyNX6nur8rsiIK2IAkUnwUQPEZolrYfVO1YkHie
         IdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=oOx5QKsqtCbmbKdRgY5fVJc0bCF1Q4fCmLw3QUyfvcE=;
        b=AkZRFCJJIxNFGB68PMtGL5sotdD7rXp7dXpltsbu6QNIEseIM/gdY/YUO6YVsmXQoq
         mvuD10zzGkv9Nd53VVZmJ7ORlY3t3wMHlwWyGz6yUj9tNPip1+9U79g/+4noS/Wg9sqP
         guKma4KfLRhndlZ0BAeTCk2v+wlqej0ZpH78QH2llj/c09dN5FyHgKlHtfYfuuCFKMfK
         XnOXi1Du8jXdBTh7uxFjaStqaKkCOoOShdh2iW/Tzmq/VOJUXDq5vIt54K4P4m1/lQzn
         T7Gi4wJikupPSx44lDZbAlY+TtSx1KtljaeYdL1WzheqUKqk19WxR9fdSA4c1A+w8HMF
         NfrQ==
X-Gm-Message-State: AOAM5311p8SSUxVM1QTQYlIJP7Gf1hoOjkYDxCdapt+CcnVupabI9o4M
        iRbJkUoUseoTvn/A57UfCXBS5A==
X-Google-Smtp-Source: ABdhPJwLWU7E0gAmAK1P6AGFrZy8Ra78XbOW5V0DJCvsRyzrvmwwkPLn84TVxLl3dZScZ1H5UCoj8g==
X-Received: by 2002:a17:90a:f011:b0:1cd:8da6:122 with SMTP id bt17-20020a17090af01100b001cd8da60122mr10358175pjb.59.1650244957329;
        Sun, 17 Apr 2022 18:22:37 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h18-20020a63c012000000b0039cc3c323f7sm10782785pgg.33.2022.04.17.18.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 18:22:36 -0700 (PDT)
Message-ID: <2aa72b12-bdf6-0815-dfa3-304444f38e67@kernel.dk>
Date:   Sun, 17 Apr 2022 19:22:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 02/14] io_uring: add a hepler for putting rsrc nodes
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1650056133.git.asml.silence@gmail.com>
 <865313e8a7eac34b6c01c047a4af6900eb6337ee.1650056133.git.asml.silence@gmail.com>
 <6ba23bd7-26c1-64fd-a312-f90c398b4062@kernel.dk>
In-Reply-To: <6ba23bd7-26c1-64fd-a312-f90c398b4062@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/17/22 6:05 PM, Jens Axboe wrote:
> On 4/15/22 3:08 PM, Pavel Begunkov wrote:
>> @@ -1337,21 +1342,21 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
>>  		if (node == ctx->rsrc_node)
>>  			ctx->rsrc_cached_refs++;
>>  		else
>> -			percpu_ref_put(&node->refs);
>> +			io_rsrc_put_node(node, 1);
>>  	}
>>  }
>>  
>>  static inline void io_req_put_rsrc(struct io_kiocb *req, struct io_ring_ctx *ctx)
>>  {
>>  	if (req->rsrc_node)
>> -		percpu_ref_put(&req->rsrc_node->refs);
>> +		io_rsrc_put_node(req->rsrc_node, 1);
>>  }
> 
> What's this against? I have req->fixed_rsrc_refs here.
> 
> Also, typo in subject s/hepler/helper.

As far as I can tell, this patch doesn't belong in this series and not
sure what happened here?

But for that series, let's drop 'ctx' from io_req_put_rsrc() as well as
it's unused.

-- 
Jens Axboe

