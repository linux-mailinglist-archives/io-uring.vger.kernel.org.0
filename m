Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E664C7AB5DD
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 18:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjIVQ2Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 12:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjIVQ2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 12:28:16 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057AD122
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 09:28:10 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-79f8df47bfbso24417339f.0
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 09:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695400089; x=1696004889; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+jPU27f/QOTZZXxzNL9Wl0Fky7mqQXSIEn4SbYQwmjw=;
        b=GAUsFId3Iz/HhEEWKyGi5wIBlrhta2f3Mwf2EP70fDrFCZ3tL+A73IuVctILXQe2ul
         liosSrHbvIT/OqLJau/gfaWDMxo9LSNrwacF53I74fyzspH6aQXxpTFAIsTw6ALt3WRE
         4/jgipyK1o+HAH0igUyXHcEF+b8m+8wD0cHzSW+uYBEVVWktaZO358HJmPvnmFUEvfge
         q28JBY4f/hCHhVIwKDjmRGCfGc2E0JmVFUjylrhU5/P+m9XWCvfxtlL+TIKd1sjO2KT5
         bl7zzpKj1mhXLhy78Z47n+7UypfrDWXM+VemH6dotJNAQMu0tuhgDGmCrqYuCnlO7ocN
         udAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400089; x=1696004889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+jPU27f/QOTZZXxzNL9Wl0Fky7mqQXSIEn4SbYQwmjw=;
        b=tOwKfoAkmWs9PKWPtqBNBw2Jv6zm4PVFsXuNvUkxrc4V8z1t4IqBrdoI0301RMkCG5
         vrdv40owdpu6eyUTvQObGZ9PUTcKHUkHF91qtYkxzc44zNJrC4iJmqsN7e0pLYcGKFjT
         VRVXJ927Gogv+EYm5Iv8Z6L+m6IavWH5gpkQUnhIjrUFNfah5bI/G/QiuQYhG+rz3YCf
         A/1eSpzEIdt8ZB126jO37wneRjj/EempdDTLbnFMognnDWeeYatKPtC62gVdc2ew7dwL
         N3kzxawYCJfXT9hBBKs52BgPb+CQFs1PKql3TDOzfJQptDAdjByR23s1A+lixai1Bfr5
         dvsw==
X-Gm-Message-State: AOJu0YwFFoGoa6HM3JhKF4NT5Ixdhsg0YGd3B3+gZJDJx4VUhpHMCsux
        ePDGbA4FvaeOrJD3YUkHMLG9ha3zhPHXtiz095h2BQ==
X-Google-Smtp-Source: AGHT+IGh7zQSr997B5ub842LyYZRMvYtZYNURY0DzOJ7kQB7BQcTYABXlU9nx4SaVN/TFCNBO0j5mQ==
X-Received: by 2002:a05:6602:3788:b0:792:7c78:55be with SMTP id be8-20020a056602378800b007927c7855bemr9268707iob.0.1695400089357;
        Fri, 22 Sep 2023 09:28:09 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n18-20020a056638121200b0042b0ce92dddsm1055745jas.161.2023.09.22.09.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 09:28:08 -0700 (PDT)
Message-ID: <c6f92395-fc15-4cd9-b685-1880c620d2b9@kernel.dk>
Date:   Fri, 22 Sep 2023 10:28:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] io_uring: cancelable uring_cmd
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
References: <20230922160943.2793779-1-ming.lei@redhat.com>
 <20230922160943.2793779-3-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230922160943.2793779-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/23 10:09 AM, Ming Lei wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 783ed0fff71b..1e3de74c2ba3 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3256,6 +3256,39 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
>  	return ret;
>  }
>  
> +static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> +		struct task_struct *task, bool cancel_all)
> +	__acquires(ctx->uring_lock)
> +{

Minor nit - I don't think the static checker will be happy with this, as
we're now called with it held already. Might not be a bad idea to add a:

lockdep_assert_held(&ctx->uring_lock);

at the start of the body, both for safety but also to document this
requirement.

-- 
Jens Axboe

