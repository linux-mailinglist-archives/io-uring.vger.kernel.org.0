Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFCC40B415
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhINQEO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 12:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhINQEK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 12:04:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175C1C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 09:02:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id kt8so30064529ejb.13
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 09:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LUbsbXBkZk0uojYbK5hceP7IikyYD4AV4g7EN9KC1SA=;
        b=PC6fSu9uVb+M5WTnJ+BKzvm7GIsul0H9nzDfhg3wWANxrqtN0tyDz5xLnN8sQCwhFw
         M8aFjWiaqFe7eGBmRmGDR2xy+ucUQLIuK1vT5ZX18p41LuBXL5h5mkTYuuDKY8g7jfQL
         SQD9OjDjzQ/Ohg/YvrlM0Nu0rK8Bz4F+kNyqDJxpYC+VlYzMaTYxQl/5LQI684geyyTe
         hJfeh9i05BEz1V6t2ykapd+RU64pScXi/m3dOxzMPDVPu37QjyxOL+9JguVDfOCUg+MZ
         xwsbbGGRXneC7hFylH3vPaLxiU+PLcIzjq+nSgMKj9EhlgJiMi3IJU08x7k082ktNdz9
         dsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LUbsbXBkZk0uojYbK5hceP7IikyYD4AV4g7EN9KC1SA=;
        b=iDeHlWYJjZz5Ss9sHPsIZ7bJS8YSU68D8nQOm5zbudpU63D575qiAZR9IHi+/6ddmF
         C8tPB5LLrqZlC+6fOgUgdbxO3LDx+dMVTT4aiiE+aVT539Z3p9yyn4p/9jgGCvZbcKDJ
         dQHZeGFig7+Mf6ByAZftZ5OiNViOQyTmp9Sk7NlO6iNC8RJ3BTL8erxmzHy8xLM8Xgi5
         onvmBSjYYJuyceucqyPjbutYDYaAuQ6dRDSAGR8U4Ue86toeMystw74MbSvzV0Oqig5n
         SoOn7N47Ds2e+BdWTy+ZHS23Akc+n1f59wimImu7HMB0ia1bi48RdVpbTGrCfrXooYdH
         P0xQ==
X-Gm-Message-State: AOAM532UO5YrkWSnlJgdC7eOdDTwUPrAVSPeZF2NEZ+/w12IRtvz6my7
        idaVZR8dUOecFXSEyh0nU4J6cRBhXKY=
X-Google-Smtp-Source: ABdhPJy60eK70YIu14zrvcKDPdiVXS/hY7e7cF7Go+yZHNdstAUthVnmskaTV8fYoZ98lgU7QqIWQQ==
X-Received: by 2002:a17:907:76ee:: with SMTP id kg14mr19245312ejc.90.1631635371160;
        Tue, 14 Sep 2021 09:02:51 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id i13sm5454268edc.48.2021.09.14.09.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:02:50 -0700 (PDT)
Subject: Re: [PATCH liburing] man/io_uring_enter.2: update notes about direct
 open/accept
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <b988dc36ebe655dc5b67e02c7916bd1c68c27421.1631635202.git.asml.silence@gmail.com>
Message-ID: <5efb3fbd-418c-db52-a056-3c0da2405044@gmail.com>
Date:   Tue, 14 Sep 2021 17:02:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b988dc36ebe655dc5b67e02c7916bd1c68c27421.1631635202.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 5:00 PM, Pavel Begunkov wrote:
> Reflect recent changes in the man, i.e. direct open/accept now would try
> to remove a file from the fixed file table if the slot they target is
> already taken.

Nope, need to add a line about actually removing old files. Please ignore


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  man/io_uring_enter.2 | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
> index ad86961..037f31e 100644
> --- a/man/io_uring_enter.2
> +++ b/man/io_uring_enter.2
> @@ -517,10 +517,9 @@ field is set to a positive number, the file won't be installed into the
>  normal file table as usual but will be placed into the fixed file table at index
>  .I file_index - 1.
>  In this case, instead of returning a file descriptor, the result will contain
> -either 0 on success or an error. If there is already a file registered at this
> -index, the request will fail with
> -.B -EBADF.
> -Only io_uring has access to such files and no other syscall can use them. See
> +either 0 on success or an error. If the index points to a valid empty slot, the
> +installation is guaranteed to not fail. Please note that only io_uring has
> +access to such files and no other syscall can use them. See
>  .B IOSQE_FIXED_FILE
>  and
>  .B IORING_REGISTER_FILES.
> @@ -656,10 +655,9 @@ field is set to a positive number, the file won't be installed into the
>  normal file table as usual but will be placed into the fixed file table at index
>  .I file_index - 1.
>  In this case, instead of returning a file descriptor, the result will contain
> -either 0 on success or an error. If there is already a file registered at this
> -index, the request will fail with
> -.B -EBADF.
> -Only io_uring has access to such files and no other syscall can use them. See
> +either 0 on success or an error. If the index points to a valid empty slot, the
> +installation is guaranteed to not fail. Please note that only io_uring has
> +access to such files and no other syscall can use them. See
>  .B IOSQE_FIXED_FILE
>  and
>  .B IORING_REGISTER_FILES.
> @@ -692,10 +690,9 @@ field is set to a positive number, the file won't be installed into the
>  normal file table as usual but will be placed into the fixed file table at index
>  .I file_index - 1.
>  In this case, instead of returning a file descriptor, the result will contain
> -either 0 on success or an error. If there is already a file registered at this
> -index, the request will fail with
> -.B -EBADF.
> -Only io_uring has access to such files and no other syscall can use them. See
> +either 0 on success or an error. If the index points to a valid empty slot, the
> +installation is guaranteed to not fail. Please note that only io_uring has
> +access to such files and no other syscall can use them. See
>  .B IOSQE_FIXED_FILE
>  and
>  .B IORING_REGISTER_FILES.
> 

-- 
Pavel Begunkov
