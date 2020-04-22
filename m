Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFD21B4EB1
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 22:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgDVU5w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 16:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgDVU5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 16:57:51 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF7DC03C1A9
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 13:57:50 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r4so1714131pgg.4
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 13:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kGfGRgXGjVkICvhpzd7gCDD3lVHSo1VK3pDsFN/4mBw=;
        b=I3tensVx5DaKsFA4H7Iq5IXaWTATgBoWoVEPuOMV92ne1973/SvRwvsoqttsjTttRb
         Uosvo1tUeeaz4LthLc0S6aBkfmXyve7vMmZE6SAd3U0vC65lZE9ZrsEmPYPjOfXwfpxx
         k5zpfHHdKkrNh+5VKPaIiask/TdFxfUMZkLXZmElAzwD8lGAmsapoGmLttdBiQ8kRBZi
         ICvJ7+9uyKCN8rQkv3A9B1VCeE0Gjv7OBHHqJcUno0tG/38Y/DH5AhRY//WoXSZXErYw
         Kjy68yFxsL1ZJtmcM9g+8V70DKy+uHD7zxHB9PT3wrjWMo4ptVtQlr75ree/HcYPi86A
         jw5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kGfGRgXGjVkICvhpzd7gCDD3lVHSo1VK3pDsFN/4mBw=;
        b=EBvDWj2g3hKBFMtcId7/MJMD6oNmmRtgLyp4zcEWUVtet1mU+rlejxmYfQUCbZjZcN
         Wa6RxLycgc1q4lfmg3rBqke1dlLE4eWC0obAYoetr8MVcCstDl/E3LlAd8dyNH9rf7b+
         ecaGIZ5tsmivPW6rjlri9jM4RkAM0c+uf3qhsd590YrCFYUjASMwpMzpSLkPJRdFikSg
         PdcnsdKYtB43h7obGciOD3njyYKneDFuq2INwkL5n92aFvf4vditcsk8CpWOVUSkQlbn
         K770bCpVoiD8kFEg9Qedp8v2vSvdCWv3iwe1v/GtvPvQEhFelovKI8YkXPUUcaLLuftd
         T+dg==
X-Gm-Message-State: AGi0Puab2id1utjkukzNFmyhX5V5b79GtSrdc0DVmxWLzFla2h1QIls4
        sDUHeKEQt3VQ1WJ5VxahMBHD7GiSaljnHg==
X-Google-Smtp-Source: APiQypLv6wLAs0aJOI4wnsweBtuhaBTb/b403KkGoYEYkBCuI8BRftt90hWNQL7BpoF06fDFyakw3g==
X-Received: by 2002:a63:554c:: with SMTP id f12mr890792pgm.163.1587589068165;
        Wed, 22 Apr 2020 13:57:48 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e7sm398277pfh.161.2020.04.22.13.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 13:57:47 -0700 (PDT)
Subject: Re: io_uring_peek_cqe and EAGAIN
To:     William Dauchy <wdauchy@gmail.com>, io-uring@vger.kernel.org
References: <20200420162748.GA43918@dontpanic>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2e16eecf-9866-9730-ee06-c7d38ac85aa4@kernel.dk>
Date:   Wed, 22 Apr 2020 14:57:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420162748.GA43918@dontpanic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/20 10:27 AM, William Dauchy wrote:
> Hello,
> 
> While doing some tests which are open/read/close files I saw that I
> was getting -EAGAIN return value sometimesi on io_uring_peek_cqe,
> and more often after dropping caches.
> In parrallel, when reading examples provided by liburing, we can see
> that getting this error is making the example fail (such as in
> io_uring-cp). So I was wondering whether it was stupid to change the
> example to something like:
> 
> diff --git a/examples/io_uring-cp.c b/examples/io_uring-cp.c
> index cc7a227..2d6d190 100644
> --- a/examples/io_uring-cp.c
> +++ b/examples/io_uring-cp.c
> @@ -170,11 +170,11 @@ static int copy_file(struct io_uring *ring, off_t insize)
>      ret = io_uring_wait_cqe(ring, &cqe);
>      got_comp = 1;
>     } else {
> -    ret = io_uring_peek_cqe(ring, &cqe);
> -    if (ret == -EAGAIN) {
> -     cqe = NULL;
> -     ret = 0;
> -    }
> +    do {
> +     ret = io_uring_peek_cqe(ring, &cqe)
> +     if (ret != -EAGAIN)
> +      break;
> +    } while (1);

I don't think the change is correct. That's not saying that the original
code is necessarily correct, though! Basically there are two cases there:

1) We haven't gotten a completion yet, we'll wait for it.
2) We already found at least one completion. We don't want
   to _wait_ for more, but we can peek and see if there are more.

Hence we don't want to turn case 2 into a loop, we should just
continue.

How is it currently failing for you?

-- 
Jens Axboe

