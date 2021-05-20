Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1821938B00B
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhETNek (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237927AbhETNeI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 09:34:08 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AACC061574
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 06:32:46 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h6so15244251ila.7
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 06:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ARdDRR9ZQJsos7KtqC2U0bV0OO/hA2OqKfbmkxmsGtg=;
        b=1UlhoSCY8HZr8qWBbzZsLjoc3ja1MTaBx61t9heHae//SYumRLOo6ubCXMLSwBkSE5
         YM2W80U3L7QCIsq2njJZyV6o+91sled9Msw23nMsWG1C1NAa1/DGytMRgZpgvBALl+jX
         HwL1nMUtHPNjSAte94GB02EVSuX7p40oeBApIRstwgTRHzGpR6W6nQipX5AdRJUh7fEe
         Gglb1kzjMkdfcR0Bmz2K1zUm7QUfeM1OMzBKpRWnOiCWPBQBQR55BhT0UBO6oOMPWbto
         JVobbbv/MP3HSpnW4phjGxbFbLSP2FBZ0ZvCd2ugkjSa+sN0GQ1+MlOzVbAJp5HK7LX5
         d63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARdDRR9ZQJsos7KtqC2U0bV0OO/hA2OqKfbmkxmsGtg=;
        b=F/M23lsjWsqqAuDl/CfsdnHD/+XG8NVU+K+0Ni/HdUeNl1rsc9pi0SYBz+hM3Xz1kM
         Nv9lIXfb/2yAVqRH0t0Ag0Kp2peIkBkOYf1iOnhd/+UZfWhMwFFamm95DEfmBDPUc6zg
         UgsTUT6+q0+9aoD/Jf+Cwm9BdiwCXqIZqk5DBPpG1D7NyEti0mQMqYM08RcEsMUgn94F
         3qHZpL3CXcihqntImnE/fEEzhESkspD1fWUH5UZsSV5BvCCCtmEhlGkWbOLkXuI2t8+T
         mCH4F2b7Pg3FLCWj8VQr1fzUvN3zIKQIx7pl+rx8oztsgzq/kOVUzLqxeFyGLaWr35Ac
         m3xg==
X-Gm-Message-State: AOAM5325FsnONVMILH1ri5cf5R5dREG4+zSmJ3FB9UnolBN21Tvh08Nn
        ewUKvY5THlq6Te9p2gLlb4j+6Q==
X-Google-Smtp-Source: ABdhPJwGWlcQvGX1SIofytINvnxPA1OeJzwYXkQhwyew6llh4Vz5Yd91L9oz/kECF30JqB9ENYtlJw==
X-Received: by 2002:a05:6e02:c5:: with SMTP id r5mr4687342ilq.48.1621517565836;
        Thu, 20 May 2021 06:32:45 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q5sm2878179ilv.19.2021.05.20.06.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 06:32:45 -0700 (PDT)
Subject: Re: [PATCH] Add IORING_FEAT_FILES_SKIP feature flag
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
Cc:     noah <goldstein.w.n@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20210518161241.10532-1-sir@cmpwn.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2bbb982d-c9a4-8029-83e8-3041327e04dc@kernel.dk>
Date:   Thu, 20 May 2021 07:32:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210518161241.10532-1-sir@cmpwn.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/21 10:12 AM, Drew DeVault wrote:
> This is aliased to IORING_FEAT_NATIVE_WORKERS, which was shipped in the
> same kernel release. A separate flag is useful because the features are
> unrelated, so user code testing for IORING_FEAT_NATIVE_WORKERS before
> using FILES_SKIP is not very obvious in intent.
> 
> Signed-off-by: Drew DeVault <sir@cmpwn.com>
> ---
>  man/io_uring_register.2         | 10 ++++++++--
>  src/include/liburing/io_uring.h |  1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
> index 5326a87..c71ce40 100644
> --- a/man/io_uring_register.2
> +++ b/man/io_uring_register.2
> @@ -156,8 +156,14 @@ since 5.5.
>  File descriptors can be skipped if they are set to
>  .B IORING_REGISTER_FILES_SKIP.
>  Skipping an fd will not touch the file associated with the previous
> -fd at that index. Available since 5.12.
> -
> +fd at that index. Available since 5.12. Availability of this feature is
> +indicated by the presence of the
> +.B IORING_FEAT_FILES_SKIP
> +bit in the
> +.I features
> +field of the
> +.I io_uring_params
> +structure.
>  
>  .TP
>  .B IORING_UNREGISTER_FILES
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
> index 5a3cb90..091dcf7 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -285,6 +285,7 @@ struct io_uring_params {
>  #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
>  #define IORING_FEAT_EXT_ARG		(1U << 8)
>  #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
> +#define IORING_FEAT_FILES_SKIP		IORING_FEAT_NATIVE_WORKERS

I don't think this is a great idea. It can be used as a "probably we have
this feature" in userspace, but I don't like aliasing on the kernel side.


-- 
Jens Axboe

