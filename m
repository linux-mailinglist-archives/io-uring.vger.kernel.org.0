Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78A75BB782
	for <lists+io-uring@lfdr.de>; Sat, 17 Sep 2022 11:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIQJSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Sep 2022 05:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIQJSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Sep 2022 05:18:51 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2235445F71
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 02:18:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z12so21272312wrp.9
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 02:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=NvJudxgp3fr9/TBV4xOPQO4o9ki4kTW2hNxhB4DaCDU=;
        b=Og4c6jooL6jjs56LNeV88dXSI93ofZOZ11Zd4XLRIh7pavyxCZpxu6FfiAWTY21kdJ
         g6cEAqvdmp+8cdjKIhDmRVaEjVVGwt9EVZAPvKM+YHCkc/cmafkTaTzV8kGeztRVDnPf
         uJtnD+wNgSOdNEEJMcn0TxcK6kdPQLTHn5l91FjAOiLCqSu3RkbwlW8Dxb64J623RJKs
         eGi2h4afdFg+soGPzU16n0+ZqtvWwNJqa7eUqpT2+Rb8KmVnzVPVxhJnoQjj0XLi2k1W
         gD9jlOKumW9sA1inIS+bSDQz0hUd4fr0eHf8oJ5ZM0K4EY0EthokbC6R9/2KV3c1fr7A
         WfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NvJudxgp3fr9/TBV4xOPQO4o9ki4kTW2hNxhB4DaCDU=;
        b=n9MmcJ32hvwyd+uftcRKQ+rUCVE5quZm0UQ2AHDZ9vYdFhzrLfN1MBmju24eDhlBTN
         Am0VBLsbcauAAf29qy1dgp+xqo8eXmW409mQYXmxhj7L//kyx+HzrpgWD+jWbgOtoTi5
         0BicIlfT/cQQ6aA6m7sW6/9nhOhupAoOE0L6E0RfjG2IZDW6FDK8OLVbLXbxdN4jGVCx
         +s/KSqcREEQGvoFLRns7Lv/pFLCcZfsHLe1V4SDSH+LkM43DYy8/34pVbvBwxU/p/nXE
         2GxnABqloCAob4TQMl71q5IksNfd3cqpCJZS3mqQFwEcZFMn1xD0B+p8z9+0R8/TkK59
         G76w==
X-Gm-Message-State: ACrzQf3TT0tj+psDM2IxWhecYrAVfGUhvZlssHJ8qavBQaYC0BoGNarj
        VuxTvmVX8zxP2xIkxdSd8ExuYSX0z7A/YQ==
X-Google-Smtp-Source: AMsMyM7xY2yVgCw2L3gZH13jfdyaunqQQNKsE4LnTK6c4B0q3TGS+jcNq1JXfM0dDAPyNqGKSzfDbg==
X-Received: by 2002:a05:6000:1b03:b0:22a:7d12:db2b with SMTP id f3-20020a0560001b0300b0022a7d12db2bmr5283439wrz.268.1663406329577;
        Sat, 17 Sep 2022 02:18:49 -0700 (PDT)
Received: from [10.128.133.254] ([185.205.229.29])
        by smtp.gmail.com with ESMTPSA id s2-20020a5d4242000000b00224f7c1328dsm7411398wrr.67.2022.09.17.02.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Sep 2022 02:18:49 -0700 (PDT)
Message-ID: <07b28a4e-df94-5fd4-e075-fb3b4084fea3@gmail.com>
Date:   Sat, 17 Sep 2022 10:17:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/5] io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        axboe@kernel.dk
References: <cover.1663363798.git.metze@samba.org>
 <8e5cd8616919c92b6c3c7b6ea419fdffd5b97f3c.1663363798.git.metze@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8e5cd8616919c92b6c3c7b6ea419fdffd5b97f3c.1663363798.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/16/22 22:36, Stefan Metzmacher wrote:
> It's confusing to see the string SENDZC_NOTIF in ftrace output
> when using IORING_OP_SEND_ZC.
> 
> Fixes: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")

It doesn't really fix anything, but it's quite simple and
we may want to take it for 6.0.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: io-uring@vger.kernel.org
> ---
>   io_uring/opdef.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index c61494e0a602..c4dddd0fd709 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -471,7 +471,7 @@ const struct io_op_def io_op_defs[] = {
>   		.prep_async		= io_uring_cmd_prep_async,
>   	},
>   	[IORING_OP_SEND_ZC] = {
> -		.name			= "SENDZC_NOTIF",
> +		.name			= "SEND_ZC",
>   		.needs_file		= 1,
>   		.unbound_nonreg_file	= 1,
>   		.pollout		= 1,

-- 
Pavel Begunkov
