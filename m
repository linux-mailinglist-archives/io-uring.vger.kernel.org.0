Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5143FA758
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 21:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhH1Tgp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 15:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhH1Tgp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 15:36:45 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C48C061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 12:35:54 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id e186so13665270iof.12
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 12:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/Q4kJfGQJTZTPMK8a83THXbdmyDUSjR/NrVN9WKp4QM=;
        b=kpr6yVyOV1bzANXajv/hMCM5C4uHtt1cWOBMQezenakpTTV8uO5bL3ghAjKT+ghuyZ
         d+0GjN0uJ7LbHie1HwIJVdpmCi4UrcGBNa1oFJLikoN4Sm3htuzLwhxtpXPVMD9cerkR
         pw6LdW2s9Pe6gsiQ8P/tu6RdcDPvCMfpT9sQoxJJPXa78eAX/iBGI4EMFgg9YKIYX/+t
         GDOPBybbPjW9QKaE4ZuZXhNV6rst5yR35W/5LVS+nmt3XHh7SX6BMQ9P9S1aCrrAn97O
         tb6TYqSHvjR65rQkBjhoOo1CJ4MrlSew7WcPhWlX5Ggm1uS0Lll+WIlvCCM+lVJLJ2wG
         3woQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Q4kJfGQJTZTPMK8a83THXbdmyDUSjR/NrVN9WKp4QM=;
        b=oQ9T5luQInl0V6cWbVOMLn1csdQi31mp555N+Rq5DyRZ8m+plmBT5tCX0gI5074waH
         zxrwgY+M9YWw/0jjEHNP7y8lt0x+Pj3HiYmPzvWyN10iDsDHM/XqdGBt4XpQOWYvJxb4
         PqI4AnNbCEx5yS35zx0XSLqVZ4iHxN5Ogb6eCMid0ITh9DILebAhIo2fq4wJl854/Rzr
         0Bx8qKcFC7CVNKI6P+1y3IxsOe1lYSqrl1upxup6LCmcUAXyDtbjWs4NX/gggXBmbq0Z
         zus2qLVd9GrtbOCbZCFD2VS62gEClCvGKbiukPoS9XjDM/rXIlE7/gx5ggpkuQv+Y146
         D+uQ==
X-Gm-Message-State: AOAM5319XbtJrRSP9lMElc6jDb36l+8kSzJ7lplyz/LtFDDZ0SkwMt4A
        8QSxmzfFLEB1fmCiwF6Z1KsMtOJQ80zzbQ==
X-Google-Smtp-Source: ABdhPJxmB7lECIZya7nKXCeYt+MfjS8VjHGBGgtQu1AlUnMEC/+PA0fJO7ZNAP6FPjA8Btgfa25owQ==
X-Received: by 2002:a6b:8bcf:: with SMTP id n198mr2812977iod.178.1630179353431;
        Sat, 28 Aug 2021 12:35:53 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p19sm5562392ilj.58.2021.08.28.12.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Aug 2021 12:35:52 -0700 (PDT)
Subject: Re: [DRAFT liburing] man: document new register/update API
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <17729362b172d19efe3dc51ab812f38461f51cc0.1630178128.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18f42215-e1e1-fcb4-1d3a-cae75812a0b6@kernel.dk>
Date:   Sat, 28 Aug 2021 13:35:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <17729362b172d19efe3dc51ab812f38461f51cc0.1630178128.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/21 1:18 PM, Pavel Begunkov wrote:
> Document
> - IORING_REGISTER_FILES2
> - IORING_REGISTER_FILES_UPDATE2,
> - IORING_REGISTER_BUFFERS2
> - IORING_REGISTER_BUFFERS_UPDATE,
> 
> And add a couple of words on registered resources (buffers, files)
> tagging.

Just a few comments below.

> @@ -95,6 +95,92 @@ wait for those to finish before proceeding.
>  An application need not unregister buffers explicitly before shutting
>  down the io_uring instance. Available since 5.1.
>  
> +.TP
> +.B IORING_REGISTER_BUFFERS2
> +Register buffers for I/O. similar to
> +.B IORING_REGISTER_BUFFERS
> +but aims to have a more extensible ABI.
> +
> +.I arg
> +points to a
> +.I struct io_uring_rsrc_register,
> +.I nr_args
> +should be set to the number of bytes in the structure.
> +
> +Field
> +.I data

I'd do:

The
.I data
field contains...

> +contains a pointer to a
> +.I struct iovec
> +array of
> +.I nr
> +entries.
> +.I tags
> +field should either be 0, then tagging is disabled, or point to an array

The
.I tags
field shoud be...

> +Note that resource updates, e.g.
> +.B IORING_REGISTER_BUFFERS_UPDATE,
> +don't necessarily deallocates resources by the time it returns, but they might

deallocate

> +be hold alive until all requests using it complete.

s/hold/held

> +
> +Available since 5.13.
> +
> +.PP
> +.in +8n
> +.EX
> +struct io_uring_rsrc_register {
> +    __u32 nr;
> +    __u32 resv;
> +    __u64 resv2;
> +    __aligned_u64 data;
> +    __aligned_u64 tags;
> +};

Move this up to where it's initially mentioned?

> @@ -138,6 +224,36 @@ Files are automatically unregistered when the io_uring instance is
>  torn down. An application need only unregister if it wishes to
>  register a new set of fds. Available since 5.1.
>  
> +.TP
> +.B IORING_REGISTER_FILES2
> +Register files for I/O. similar to
> +.B IORING_REGISTER_FILES.
> +
> +.I arg
> +points to a
> +.I struct io_uring_rsrc_register,
> +.I nr_args
> +should be set to the number of bytes in the structure.
> +
> +Field
> +.I data

The
.I data
field

> +contains a pointer to an array of
> +.I nr
> +file descriptors (signed 32 bit integers).
> +.I tags
> +field should either be 0 or or point to an array of
> +.I nr
> +"tags" (unsigned 64 bit integers). See
> +.B IORING_REGISTER_BUFFERS2
> +for more info on resource tagging.
> +
> +Note that resource updates, e.g.
> +.B IORING_REGISTER_FILES_UPDATE,
> +don't necessarily deallocates resources, but might hold it until all

deallocate

Just minor stuff, apart from that looks pretty good to me.

-- 
Jens Axboe

