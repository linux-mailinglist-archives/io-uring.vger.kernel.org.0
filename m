Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEB81BE284
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 17:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgD2PYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 11:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgD2PYo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 11:24:44 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE16C03C1AD
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:24:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t11so1174691pgg.2
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pjrubsb9WEGqYiIfmWvQ04MQ/+CZXPnDhzXHzxcQPAs=;
        b=rbqJCW7vpQX9wC5tskAZN+r/oqRNSurDmWmwsxIL77R2+NyJX8FzfCB1HXkSsNzC7r
         fxaoCZ5dHScxdysB2kslE8psvkE9tdz+DGBcycKiDwURP5aInlxEmoh4Zt1AN0UY8r+J
         5NTtw1/MgZdtjkCSylVzrZml18FTYXTJvx4tUw31zDZAdBSGHMTG9CNkmxiNduzXvQZG
         Q0y6H44AbsTPciiVre+bp6eNBou9Q6ubwww4DzQOLlrESW57nfejqH223lh2sjlD++WZ
         98bQmyxr/3PeT9dOvO9KSk4VCaRU3jk4xcPFU+JFMsm2PVF0eid2iHIv7Mc64h0bTtj0
         FxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pjrubsb9WEGqYiIfmWvQ04MQ/+CZXPnDhzXHzxcQPAs=;
        b=sjK7bqFGHuv8+8QKr739eU3JnvgglAZAvC3Fxl+vxpfDRGi+wgniqzCRdhVvaVuccW
         tiikWhSqwPqrcVlRpi12mwXqGvUNM9VmE5bhtFRVk733e2DKFFONymodsOZaNMcPcX0l
         vjXFagfdLYS74Boo3SPoiNQnXm8Y3b3eFIm8cweXybfAbGalXZeHk2ssby8V4lUh2xt+
         THLwEDJtKKitO5KuBsid37uChufjDVUdHQqw3mHPOdVNeWJyTk7YP0NbFKl8yJX81zz9
         gKw6lEZPMB0aeyKhw7vfCDA/LLX/AnvtA6znVPvj6N/5KKlXji5F/jBUoYLW4WZ9EB7c
         bNVw==
X-Gm-Message-State: AGi0PuYn0MEdTjcH4ReF9swy27bB++Yp0iWORaHxT4QPWLszMXZNExss
        0TCxWZxb0nmkd/THsi2bu39OS6t3Ko7s9g==
X-Google-Smtp-Source: APiQypKa3LFmgDCKxZpP+Gb+YNogsoAI0bmJr9EylIEdNGHDjnm8Z4rBIDukrPD2/ghpYbk77/XNqg==
X-Received: by 2002:a63:4f0f:: with SMTP id d15mr20345060pgb.339.1588173882533;
        Wed, 29 Apr 2020 08:24:42 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w69sm1363162pff.168.2020.04.29.08.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 08:24:41 -0700 (PDT)
Subject: Re: Build 0.6 version fail on musl libc
To:     =?UTF-8?Q?Milan_P=2e_Stani=c4=87?= <mps@arvanta.net>,
        io-uring@vger.kernel.org
References: <20200428192956.GA32615@arya.arvanta.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
Date:   Wed, 29 Apr 2020 09:24:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428192956.GA32615@arya.arvanta.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/20 1:29 PM, Milan P. Stanić wrote:
> Hello,
> 
> I'm liburing Alpine Linux maintainer
> (https://git.alpinelinux.org/aports/tree/testing/liburing)
> 
> I tried to upgrade to 0.6 from 0.5 version but I got errors:
> include/liburing/compat.h:6:2: error: unknown type name 'int64_t'
> and
> include/liburing.h:196:17: error: unknown type name 'loff_t'; did you mean 'off_t'?
> 
> musl libc have /usr/include/fcntl.h in which loff_t is defined with:
> #define loff_t off_t
> and I tried to include it in include/liburing.h but this didn't helped.
> 
> After this I created this patch:
> ------
> --- a/src/include/liburing.h	2020-04-13 18:50:21.000000000 +0200
> +++ b/src/include/liburing.h	2020-04-23 21:43:15.923487287 +0200
> @@ -193,8 +193,8 @@
>  }
>  
>  static inline void io_uring_prep_splice(struct io_uring_sqe *sqe,
> -					int fd_in, loff_t off_in,
> -					int fd_out, loff_t off_out,
> +					int fd_in, off_t off_in,
> +					int fd_out, off_t off_out,
>  					unsigned int nbytes,
>  					unsigned int splice_flags)
>  {
> ------
> with which version 0.6 builds fine but I suspect this is not proper fix.
> 
> Could you, please, give me advice what will be proper fix these changes?

Not sure what the best fix is there, for 32-bit, your change will truncate
the offset to 32-bit as off_t is only 4 bytes there. At least that's the
case for me, maybe musl is different if it just has a nasty define for
them.

Maybe best to just make them uint64_t or something like that.

-- 
Jens Axboe

