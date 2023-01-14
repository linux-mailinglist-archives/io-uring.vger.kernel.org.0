Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CB266AD04
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 18:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjANRTn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Jan 2023 12:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjANRTm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Jan 2023 12:19:42 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7939CB762
        for <io-uring@vger.kernel.org>; Sat, 14 Jan 2023 09:19:41 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id jn22so26395105plb.13
        for <io-uring@vger.kernel.org>; Sat, 14 Jan 2023 09:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VZKcqO8CvgbPzTQjXVpYsBM4EltM1ofB3aaqH1uEd20=;
        b=x0KXbUfPpTZzsja58Z6eQjfj4T/mPx+r9H6P1TKXeMf1NvVFdVkR7Q0kJUQRmqxcUr
         m9XY2WT2dMLxJcsoiddpViiGQ5f3mbHkBuWIbyFAx+260eYvIN8EPTZDh09Ls+Jg1DHI
         OqTafaP60mS0FBnYVT10JMzLsSzmlV8AgbOkVVsnuj/iq0UfXzBkF9oEAfShiyBWd3ZI
         DESCX/9ADGTcCyqPBk7Yd2GPf6QDYQGroXeQGITU0ovicMZDXl1B27AMaTpxlRCwtq6f
         7FS3GabEjS2hhnTd89B8vStgXC38rIGaeSfT0huwlZIvXOly44xZ4QC/IsJs9OBPqRSL
         Whcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VZKcqO8CvgbPzTQjXVpYsBM4EltM1ofB3aaqH1uEd20=;
        b=2dyZ2YCZDLFMu2V+C91hBSbcYYq0JYrHN8IPQIRr4KJjUIJdnoe86QC2Ipn/1eH6Yn
         7nQb+i4uDH9z/6nirnAkagAvZPrcEiYnW5NfppnSaAkPQMjB9oVcEqDzqHV/Hv35WdMb
         hDSeowQnZCEWlZyhAlJMnJ8x5njodxwXU1cnbJJ6cIRZiusY3ino0JwlV62LKfWAtzN1
         HtYyyvtITf8Uw7AiPZl5VcGjPUK5fS5tlfTDdHWzUX6JsfIu2tkv/7LwWKG1G2X1df48
         YGwlhAgJqK0J5TUuAZhRKkA6R1FRJprKiMU2Zz4rgNN+Dt1+6AD5Fbd5eacsmm26Aktw
         jYHA==
X-Gm-Message-State: AFqh2kpi40Sf61wzvW3yTBmdJ+KfkIUy2dCX69+Ld9GcP/ioj40RbVXz
        omA/tzcHYJD1t+1IrcUsN+0bVQ==
X-Google-Smtp-Source: AMrXdXt+BKv411JDYZmI+AygtBO2vkbQpV/+UgQEXqO9ZVhnHz5ZRni1zdObP2U0fPgj+eP3uzwsIQ==
X-Received: by 2002:a17:902:704a:b0:193:2d46:abe0 with SMTP id h10-20020a170902704a00b001932d46abe0mr907094plt.6.1673716780857;
        Sat, 14 Jan 2023 09:19:40 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b00192dda430ddsm16130291plh.123.2023.01.14.09.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 09:19:40 -0800 (PST)
Message-ID: <3d217e11-2732-2b85-39c5-1a3e2e3bb50b@kernel.dk>
Date:   Sat, 14 Jan 2023 10:19:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH v1 liburing 2/2] README: Explain about FFI support
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20230114095523.460879-1-ammar.faizi@intel.com>
 <20230114095523.460879-3-ammar.faizi@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230114095523.460879-3-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/23 2:55?AM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Tell people that they should use the FFI variants when they can't use
> 'static inline' functions defined in liburing.h.
> 
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  README | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/README b/README
> index 4dd59f6..7babb3b 100644
> --- a/README
> +++ b/README
> @@ -71,6 +71,25 @@ Building liburing
>  See './configure --help' for more information about build config options.
>  
>  
> +FFI support
> +-----------
> +
> +By default, the build results in 4 lib files:
> +
> +    2 shared libs:
> +
> +        liburing.so
> +        liburing-ffi.so
> +
> +    2 static libs:
> +
> +        liburing.a
> +        liburing-ffi.a
> +
> +For languages and applications that can't use 'static inline' functions in
> +liburing.h should use the FFI variants.

Maybe include something on why they can't use them? And that sentence would
be better as:

Languages and applications that can't use 'static inline' functions in
liburing.h should use the FFI variants.

-- 
Jens Axboe

