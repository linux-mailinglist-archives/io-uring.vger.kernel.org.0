Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B1631FE90
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 19:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhBSSJT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 13:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhBSSJS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 13:09:18 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C4DC061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 10:08:38 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u14so9755117wri.3
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 10:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uQkd289Nfl/JyKzX/SwxCuAb1i8bJ67oeZ76grFK14Y=;
        b=hGaEfLHWekqPO6PyZXRGRh/xMApp8YA97aSYpHCadI47oSrESXmeH9JuhV5GN0kmZE
         haf/Pt0Ct5DncVD3On0oA72w4l9lhJyNExULMaPMlEgUs8wg7aupMeFarw8mk1eGKdry
         T3DV3JsuJN7UYAbFQ4klMZGW6OZqECdFUGgQy4tQG67IXz89VoPClVkjpXCXi8yWYRev
         Z7CzrA/KCup1xM2kr0LKLRGjee0Fy0q497mh3pclSegvzLm0mAd4e+AWPeWfaMbkDzjb
         THIlYwgCgjTBUh+YGX0x88uc/hQ1OlVb+PDoay20QYjnu0sHg74bloF2STpVjcwurIc+
         LDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uQkd289Nfl/JyKzX/SwxCuAb1i8bJ67oeZ76grFK14Y=;
        b=CIo2uz75pKwz5vGvop+bdUe94oL3UTqpARTn97f2uRmetDJcu8b/MvY3fR0jiEJpkq
         UueW6/yQLdDVOsWIKnoXjlK7ZfA1iknZiaLnbaLSwDaF9qqhchqlAc2q9TyTJMeE9kXg
         Wz/ZisjJsVXuMP6BAsqsHQfecvHQMJg5Gi1yhGQrj1VQY5imkHAfA3LVpTnhzSwFHJj2
         5MYYorGTAMEjCM9TzJMMSPpDCVECI9IK2D006oHGKxU4OzNF176S7AHag3SSAF0ewybA
         JeYNSCWCXljRqRT6SdBwqdW2RolM844dcCDkCOdWM5/YMpTVG9vxjpnQq1fqf57fgRp9
         HWag==
X-Gm-Message-State: AOAM530nJgl0RBUAEN6uiw474xwYorOMx6XbuJ+p6gsmSSTVf5ddFo2B
        UBwbjJ9OximRUire/fWIPP4=
X-Google-Smtp-Source: ABdhPJyvUO1bIZNxMHmNtKlDnDaHr8smIQgmg87AwrM9ucWuP4Op50Ii2Vum3MP2eReltbXJYClmLw==
X-Received: by 2002:a5d:5248:: with SMTP id k8mr10350294wrc.17.1613758116966;
        Fri, 19 Feb 2021 10:08:36 -0800 (PST)
Received: from [192.168.8.138] ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id l1sm12431120wmi.48.2021.02.19.10.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 10:08:36 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't submit sqes when ctx->refs is dying
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1613757506-199460-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <150ff599-eb5f-d605-ea9c-f49557c6324b@gmail.com>
Date:   Fri, 19 Feb 2021 18:04:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1613757506-199460-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/02/2021 17:58, Hao Xu wrote:
> When doing __io_uring_register() and waiting for references to exit,
> there could be other threads calling io_uring_enter() and submitting
> sqes which may cause the drain wait endless. So avoid this case by
> checking if ctx->refs is dying.

IMHO, let's leave it as is because it noticeably changes behaviour.
That's nothing that can't be solved in userspace if needed differently.

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 931671082e61..9aab4d25c2df 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9356,6 +9356,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
>  		}
>  		submitted = to_submit;
>  	} else if (to_submit) {
> +		if (unlikely(percpu_ref_is_dying(&ctx->refs)))
> +			goto out;
>  		ret = io_uring_add_task_file(ctx, f.file);
>  		if (unlikely(ret))
>  			goto out;
> 

-- 
Pavel Begunkov
