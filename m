Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4837536661
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbiE0RJu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 13:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiE0RJt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 13:09:49 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F3F13FD41
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 10:09:48 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9so3484739ilq.6
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 10:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mj6UV587NLHpPh8LwVuZSQ7l6DmDqRXj14pCf0PRZsI=;
        b=Kwtz+ROtW7SSqbkI6pDqPohCzmSoT8KUfiPvrN+MI2vVXKXeGXNhH2duH7BEI0VRs2
         17OtaRV69WiLBHV6i1z+uzSMhciW6SMnToFKKUk7UwDaJni91LG0hbDxOqB5xa7RcUwx
         PVrpKD9a0N/03851iQWqzuqtDkqgZWKXOGbfN36lyBbaxNPbTNSblZK32+oTWxJzO/AZ
         F2DZnFCJe26nNy9Y93Xo0J0eyrd/+UnSW/rw3a2XgPhX3pCJYb/p3yOqrqKnfMy26huP
         /4G3g71/hkT1s6Sx2GhN5JTTVT39TjkCJVmdCYMRWjyOo8c+iN2RR448lhQfLv/gOzV/
         4DBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mj6UV587NLHpPh8LwVuZSQ7l6DmDqRXj14pCf0PRZsI=;
        b=0fBWPLDVPSGik3YNlSdZBTqaC8x3s//9TV5fzOuXZ87cHRMbBn/1jtcQSoX3GAj2F/
         HXvfm6h0l2tP+9LEqyzh7OILSIDk9NgmiwBkytAtTqjOMs980NVqxbq75wVpCHVfs4R9
         2ERCfC5XYrXkH/IsIxpzxqY+1TL1xriMglWvn0W5QJd8nOpmdsbaVcpUmGMgnwABIBLE
         +XQEzI4Fx1k++K2SRbcclrVxZLrLr9VFnxlkP2S3tIS5svSqH3Wg/XkSpBsbDF0IEo0b
         jqpVFAlY5eW9/3ZJ4naaFuu1cg44Ng2kInvlHfs1i6ELzw0CFz00RQo788BGDuXfMcjw
         /Cgw==
X-Gm-Message-State: AOAM532EWSgNgOh/PEZTUNb3RdXG1CNMFfKY9EGwaywY6h9mne0qSDr9
        7n3zK8gEPOmNnabRRWq0/qpd8Q==
X-Google-Smtp-Source: ABdhPJw/+6U3Z6Z2IUd44AS2LfQAM+XVQDlUp4KdzRSPWjtCZZLOpvPaxGAGmjPd9LrnBrx6Z9dsww==
X-Received: by 2002:a92:c547:0:b0:2cf:90b9:67be with SMTP id a7-20020a92c547000000b002cf90b967bemr22357895ilj.119.1653671388368;
        Fri, 27 May 2022 10:09:48 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z16-20020a056638215000b0032e3bf65b5esm693293jaj.38.2022.05.27.10.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 10:09:47 -0700 (PDT)
Message-ID: <dce4572c-fecf-bb84-241e-2ea7b4093fef@kernel.dk>
Date:   Fri, 27 May 2022 11:09:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] io_uring: defer alloc_hint update to
 io_file_bitmap_set()
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220527165333.55212-1-xiaoguang.wang@linux.alibaba.com>
 <20220527165333.55212-3-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220527165333.55212-3-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/22 10:53 AM, Xiaoguang Wang wrote:
> @@ -9650,12 +9646,15 @@ static void io_free_file_tables(struct io_file_table *table)
>  	table->bitmap = NULL;
>  }
>  
> -static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
> +static inline void io_file_bitmap_set(struct io_ring_ctx *ctx, int bit)
>  {
> +	struct io_file_table *table = &ctx->file_table;
> +
>  	WARN_ON_ONCE(test_bit(bit, table->bitmap));
>  	__set_bit(bit, table->bitmap);
> -	if (bit == table->alloc_hint)
> -		table->alloc_hint++;
> +	table->alloc_hint = bit + 1;
> +	if (table->alloc_hint >= ctx->nr_user_files)
> +		table->alloc_hint = 0;
>  }

This branch isn't needed, we'll reset it when failing to get one anyway.
Much better than adding a branch to the fast path.

-- 
Jens Axboe

