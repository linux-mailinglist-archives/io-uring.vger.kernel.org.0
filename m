Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F7B3922F9
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 00:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhEZW5Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 18:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhEZW5Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 18:57:24 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CD5C061574;
        Wed, 26 May 2021 15:55:51 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n2so2783600wrm.0;
        Wed, 26 May 2021 15:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gPwm/bFLTQknXqSBHE8+frTItoBX1WvDbpLyvrh7WXw=;
        b=E+oZSERpm7nR3VDyMmDKRLV8fXzYHsjRoACZKthbjyJ3ya9KOTY2P2J/u0JErj/Kt2
         mvw2UTMeB6AXpar59SdVIwrRN91MeKQg4nDjD2sJpjlsjwo+69MRiWFtOXgJAo2RP6+e
         Tim+ecSMwwKUbci3USZAzuoq920NQdhVRgx479D6c9YnznR2/oTsbDIiIYczem+otiir
         oX+P5/0EGpSSIr0lb2grDSo2CQe7Hzzdl2xbtbwk1QxyGMBLouX28jAY8e5Q0icHJt0j
         BP+KvuxST7TZRGOx/esOm+iInBde+JLdrUfrtTvVQ70vUAEJHs+5noa/gy48M2ERneIX
         /bjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gPwm/bFLTQknXqSBHE8+frTItoBX1WvDbpLyvrh7WXw=;
        b=NDr1w6wo2v8qk1Dn8h55VIgsnjiWfL3Vz7qojrEw8OiTxxenj9GLQZ60jegySqZOyN
         WUG99SJjtMAKuy4bMtAUWPd4KlKZllGmDBTbpAxaCW9hS0rHzYIDgQ2RjEqAk274K1jr
         XmzLnnKc3zRbc2eeOK2MwFuyMxjJj55jWbBmSKnyZ7wNYpi74wyYfkcyWN4k8v96bdZQ
         oTzLGPDHXZVugHb28/DbAY3aiI6SXTkuAuvA9ZDDwVaSFy/wSSgq2qAJ2skkkAsYuaFR
         xNUE8L3jbn4kwngYL0RIghV7SeOvZiRFPP1yArwZH0ONxoyc2vsXqte7kzYFHeMILHcP
         p/tw==
X-Gm-Message-State: AOAM532Ym98tEYpW0RkCdKuy8R7oxRxr+QkCM2bOj7fFfy3QphMZp8A4
        U5TpjuRdT7h+gOIhX5DxUAK+k8H3etc=
X-Google-Smtp-Source: ABdhPJzF9Esks2jjeXzFwZFez3T5gxEJOb3T54ToweqH47/cdBJKZP8KVRuuixrS4JbCGeqj2UlkLw==
X-Received: by 2002:a5d:5052:: with SMTP id h18mr241222wrt.365.1622069749434;
        Wed, 26 May 2021 15:55:49 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.15])
        by smtp.gmail.com with ESMTPSA id f1sm460692wrr.63.2021.05.26.15.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 15:55:49 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Remove CONFIG_EXPERT
To:     "Justin M. Forbes" <jforbes@fedoraproject.org>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210526223445.317749-1-jforbes@fedoraproject.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <0d335e81-9a94-ca60-5659-bb46080b9242@gmail.com>
Date:   Wed, 26 May 2021 23:55:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210526223445.317749-1-jforbes@fedoraproject.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 11:34 PM, Justin M. Forbes wrote:
> While IO_URING has been in fairly heavy development, it is hidden behind
> CONFIG_EXPERT with a default of on.  It has been long enough now that I
> think we should remove EXPERT and allow users and distros to decide how
> they want this config option set without jumping through hoops.

Acked-by: Pavel Begunkov <asml.silence@gmail.com>


> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> ---
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 1ea12c64e4c9..0decca696bf7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1621,7 +1621,7 @@ config AIO
>  	  this option saves about 7k.
> 
>  config IO_URING
> -	bool "Enable IO uring support" if EXPERT
> +	bool "Enable IO uring support"
>  	select IO_WQ
>  	default y
>  	help
> 

-- 
Pavel Begunkov
