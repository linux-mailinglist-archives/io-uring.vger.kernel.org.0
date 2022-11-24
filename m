Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6B3637D67
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 16:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiKXP5u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 10:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKXP5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 10:57:49 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F67125E85
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 07:57:46 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso1537828wms.4
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 07:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JKAc1pn8oIOUbPy6Wcay1hfR1Ug3WTqcIVEEqhfO9Is=;
        b=DW2oFsAkUr4XhF6F0UrO1Aae3/kcedZenWCHVtEpdfkhaNKd/0m57b/Mvr7Dr3bMQu
         sBuAEx0jClnZZAIQz73ix01gFK27CYok+lLAeDHzQbgXnkmwCzwikJ7CbXEGcg9P6X+6
         LrNTve1iaVMEYl96d88kqF3jziVby8GWkNJRyqH7WjFMu8xX0rTXyJlaWROvqWCsOSyu
         SgsnbOryGvvLwMtuwDBtsQi0mfLC0wlv94T28coRndNMG9+hfw2Ysv/kPg4W4XgOG0CR
         SdsBiMpFxW4yizytQaUoV4SvWQ+zQN55l4n6wZSce/69EQu5Q2Wtj4/ZCNeyw48QW4OF
         2TSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JKAc1pn8oIOUbPy6Wcay1hfR1Ug3WTqcIVEEqhfO9Is=;
        b=dFlNomM6LK/upGy8m+1hwnXXpzx2RXq3CAifZ7InokjFf6MEo/vh8VFGrHQC68h4Bf
         wZlzIhtjOQwtdX7b6+6e8uoUTAtnO08ZAAeTE5uljnpBGqfSgalZRV9yM1I6aqEEUz0D
         eSrHVJDnKgvTtl2AN+SdIJ6DH1bMEcklMcoSFutsOJbJUxsGQg2tWI+kh0h30Pwvnh60
         kpKjxe+gK9vegUbJ380px+m3LZYkN//AUYNhaAZgA7/TFMWcva9njCfjfVAXstwgFmGA
         0cnRixkjXCkXLbI6ovHMUNDLz8ZwpKdjaX9TsBKZ8OWXkSGu448Dm8/fUrV4kMXQIfxw
         0Qbw==
X-Gm-Message-State: ANoB5pnXIpWx+FmLzt6TwfKx//G9xZYd4LEUX8aCiIK4KW0bQbyyP/3g
        1d0G+kaBJLQ3yKPVmppcv3K93oHijO0=
X-Google-Smtp-Source: AA0mqf772EDWS7rPgx/iBFRUBxOrLXorwQd2ND7gPDZSdqIhlU/PrODQu9RzNjpTlnBQUs+h5gH+Gw==
X-Received: by 2002:a1c:6a13:0:b0:3cf:7801:c780 with SMTP id f19-20020a1c6a13000000b003cf7801c780mr24533687wmc.29.1669305465012;
        Thu, 24 Nov 2022 07:57:45 -0800 (PST)
Received: from [192.168.8.100] (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id y3-20020adff6c3000000b00241c712916fsm2070430wrp.0.2022.11.24.07.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 07:57:44 -0800 (PST)
Message-ID: <f5cb5923-6ae5-2376-bce2-5de1ede393d9@gmail.com>
Date:   Thu, 24 Nov 2022 15:56:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-next v3 1/9] io_uring: io_req_complete_post should
 defer if available
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221124093559.3780686-1-dylany@meta.com>
 <20221124093559.3780686-2-dylany@meta.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221124093559.3780686-2-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/22 09:35, Dylan Yudaken wrote:
> For consistency always defer completion if specified in the issue flags.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>   io_uring/io_uring.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index cc27413129fc..ec23ebb63489 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -852,7 +852,9 @@ static void __io_req_complete_post(struct io_kiocb *req)
>   
>   void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   {
> -	if (!(issue_flags & IO_URING_F_UNLOCKED) ||
> +	if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
> +		io_req_complete_defer(req);
> +	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
>   	    !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
>   		__io_req_complete_post(req);
>   	} else {

I think it's better to leave it and not impose a second meaning
onto it. We can explicitly call io_req_complete_defer() in all
places that require it, maybe with a new helper like io_req_complete()
if needed.

-- 
Pavel Begunkov
