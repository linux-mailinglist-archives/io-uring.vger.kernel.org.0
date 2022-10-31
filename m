Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5834613D35
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 19:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJaSTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 14:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJaSTS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 14:19:18 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81CA65C6
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 11:19:17 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e129so11376179pgc.9
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 11:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ySA7l2k2GU9BiVlZfSKJ7ZVzppRzFjMrJFAsHG8FDsI=;
        b=H/0qe1DBk3mubWDSXhSKNp4RGcIScUb5xTiPB+CyIbJfS0C3GNAuwURZpcVcNiUy9+
         SlATdF9j9wvylMzUlcp9hLEAVVg56QAw6jplsi6scn1eGUI2431JR5z7VPuNoY3TzAIx
         e5fF/sMsJwB8zO6f+U5lj8MQL7chGYFLvVYzslz47c1ejTpAi5vxSUQpl+c6i1zH+9SU
         pr5OM5/bzaPZsHnOmiaHnHgHkYjczuKTDthHs41pQ/ZPb6UiF3HqWuWqtTZzJD7eoljE
         am6xKxxfOU2Ip+WGfkD2s+SLuiTsE9RX30XUkDfwAkf2c1R1A7jay9UcMBTR3sa256zn
         S5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySA7l2k2GU9BiVlZfSKJ7ZVzppRzFjMrJFAsHG8FDsI=;
        b=aXkSiMVJ8l+mTg7D8qexlu0TlRVYjiCq2+oGMCd9vO2YQ8MpDeVeP+/8EXlYRn2CtM
         wILyxddioTtef3kPi/FysOVwrNGdrNFt1TnDoo4FsUZ4YabKn48iwgc7/KMHIBlflRJH
         qVWPo6fZ9GVk3LMMLSCgBf94GH5Lfy7K9xrqEqYM5/aNN3CPm3Bq3nEMLwmPUp800hE9
         lyV6qbNMgn9OKxY4ZMrjg6lH/a6T4E60We7K9UCq6y238o4o/c7BPWqUpHhFhYF1iG0j
         Hcnd7O3MTKGOozOBkdy+mkq3hk/yu0TziOEHS49e5yozC81eYtkAFNO1OoRctYGsi0+7
         1qHA==
X-Gm-Message-State: ACrzQf3W/Q41yv0hogtNuuRHsU4d7MIzPAvvQwWR1t9Blgm5H4zKG5RY
        xDYpFmERgea/oFykWL7Vx66uLA==
X-Google-Smtp-Source: AMsMyM6fRBs6WmAFPt9qnOPGVGioxJe1hhiB0uAdWjaqeQ6vyk8O7nvwXrIa0wnJ3mJIY2GQEzkKSw==
X-Received: by 2002:a05:6a00:1145:b0:52b:78c:fa26 with SMTP id b5-20020a056a00114500b0052b078cfa26mr15469313pfm.27.1667240357288;
        Mon, 31 Oct 2022 11:19:17 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ix2-20020a170902f80200b00178b6ccc8a0sm4759649plb.51.2022.10.31.11.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 11:19:16 -0700 (PDT)
Message-ID: <14596976-2928-4fd2-87f4-49eefb8b62d2@kernel.dk>
Date:   Mon, 31 Oct 2022 12:19:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-next 03/12] io_uring: support retargeting rsrc on
 requests in the io-wq
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-4-dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221031134126.82928-4-dylany@meta.com>
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
> Requests can be in flight on the io-wq, and can be long lived (for example
> a double read will get onto the io-wq). So make sure to retarget the rsrc
> nodes on those requests.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>  io_uring/rsrc.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 106210e0d5d5..8d0d40713a63 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -16,6 +16,7 @@
>  #include "openclose.h"
>  #include "rsrc.h"
>  #include "opdef.h"
> +#include "tctx.h"
>  
>  struct io_rsrc_update {
>  	struct file			*file;
> @@ -24,6 +25,11 @@ struct io_rsrc_update {
>  	u32				offset;
>  };
>  
> +struct io_retarget_data {
> +	struct io_ring_ctx		*ctx;
> +	unsigned int			refs;
> +};

Do we really need this struct? As far as I can tell, you pass in ctx
only and back refs. It's passed in the callbacks, but they only care
about ctx. If io_rsrc_retarget_wq() returned back the refs rather than
use data->refs, then we could just pass in the ctx?

Or you could at least keep it local to io_rsrc_retarget_wq() and
io_retarget_rsrc_wq_cb().

Not a big deal, just always nice to keep the scope of struct as small as
can be (or get rid of them).

-- 
Jens Axboe
