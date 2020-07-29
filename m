Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175F42323BD
	for <lists+io-uring@lfdr.de>; Wed, 29 Jul 2020 19:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgG2RvM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jul 2020 13:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2RvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jul 2020 13:51:12 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33455C061794
        for <io-uring@vger.kernel.org>; Wed, 29 Jul 2020 10:51:12 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id g6so5230080ilc.7
        for <io-uring@vger.kernel.org>; Wed, 29 Jul 2020 10:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4e7BnlZAOb2j5vo7O8ophS/nhAuYKwAVuz5Bvo/hZWw=;
        b=1rXLnpyQRjMe7kyyRhgr+GwCDGDVJmo1zYUAThR8FDmKcTctBooFoOIyQZFz2mQupR
         RWI35TYdVAI/t9RNaYwFXb2TP+1mqmMxsFd66oEFVSSefroqb6qo4n6yChuoZvWXNS7C
         UXmKT89mZVWmZSorRALjfJ2F81x9B4gAS5HJ2Blz3uQpB8Bs311O94/h3EZPoqunhtnv
         vQWqmLPJmcey7oFekMzGxHzraIMizRDfq5PIQfvgqwJUpbm7oX5waokmu9rl28JfTn1a
         Jv6HWsBzh+/W6dah6/UPgDbIRFXDjyATCiG1iMVVhgpVILhlisH7bWwIQqrZZiIGw/zE
         5yvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4e7BnlZAOb2j5vo7O8ophS/nhAuYKwAVuz5Bvo/hZWw=;
        b=jMR0Ms2hTpz59a8IjIpEcf9I6jR0/cV7pLFFFVq5mo1UrEF5jP1RqSF4Pedo1AvqoV
         OGh9YM/eiadazm5KOW6MGCAUk9XAoSXQwWWnNw2bkIxK7u6nQRB4NjrVR2jWJuWNmAFy
         snwkNo68zT20XJgb/VZfHNV4HaPwZ+6xadqR9O22zBlq2QJVHIrUNrqbLBB/Wk4EwKlF
         rsTVoIvKKUJE4lMF9uuw33cqnBB3O5ptlv53PuozsZdUT2GDIEa8mPlutn5uPD02YPTn
         rBUQC8Urp9rQp7qzXzM3JkMsuDUMbwS6Iy0Ny25gQN+BzsWdh3Hg8jbPwcVzRwuG8/l9
         KMdA==
X-Gm-Message-State: AOAM533eFfppvanjMpb3fA9Oo++F1ZtYp7p1wc0reT8VF/KVrCyqK+mh
        VeHIGp9ElCOpiThiGs02F+7nIAosEFs=
X-Google-Smtp-Source: ABdhPJyUoqVjAETUcrULRELCyToxuWwkLc7K4b8aUUbe94smj4INKpqVoaNCiCZo1YLyEvFggzXxFA==
X-Received: by 2002:a92:c7c7:: with SMTP id g7mr2060359ilk.304.1596045071272;
        Wed, 29 Jul 2020 10:51:11 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s8sm1359747iow.11.2020.07.29.10.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 10:51:10 -0700 (PDT)
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
Date:   Wed, 29 Jul 2020 11:51:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/29/20 4:10 AM, Jiufei Xue wrote:
> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
> supported. Add two new interfaces: io_uring_wait_cqes2(),
> io_uring_wait_cqe_timeout2() for applications to use this feature.

Why add new new interfaces, when the old ones already pass in the
timeout? Surely they could just use this new feature, instead of the
internal timeout, if it's available?

> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 0505a4f..6176a63 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -56,6 +56,7 @@ struct io_uring {
>  	struct io_uring_sq sq;
>  	struct io_uring_cq cq;
>  	unsigned flags;
> +	unsigned features;
>  	int ring_fd;
>  };

This breaks the API, as it changes the size of the ring...

-- 
Jens Axboe

