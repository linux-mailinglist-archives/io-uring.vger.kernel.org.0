Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C74C353973
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 21:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhDDTQV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 15:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhDDTQU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 15:16:20 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCDFC061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 12:16:15 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g15so6911115pfq.3
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 12:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=y1FPjtfOMTEnxTFqUT3o260xk6NVke5n2bURqmw4yRw=;
        b=0o8qq3kZA9MnuwNJOdvekRAV64f6p047E8+iZ3UdHnY8F3imewjHN22cKh4Tr0FOPk
         CPgSOPjODjmqg8aOq+zgeT/QgVjFegWGGo4od7NCXICVTYDgK+11Rnx+9Me6BMA4C4pz
         74B/NBSvQZ5CaYe9zml5qq1BSPfZ/b/FHcdrc2f7aw9jE9IuLOV72esxiDdmDqIDBqcj
         tmG9YP2MAvegZRr1D+DAqRxhpjIHjMz3KDPnAh4CEuEA+mXrBYeeq8s9gD5xaTSZiNiE
         hqtui/OU4mMXYmni/vlN1byilI3h/5zffVZkiR4d5/vKKIDlwU5x+3mtf9Wy+Tmg5/be
         Lpwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y1FPjtfOMTEnxTFqUT3o260xk6NVke5n2bURqmw4yRw=;
        b=nsW+gfZ7RNWggu8u+RQ8rUP624xbMszKY38ETLv3+jatDE4AJFOGxy2Ht5iLrYJhaM
         6ZoiM7GHLbuJ6k879+0vr8KLjTCLIDrl1OWef7gDvoedZCVywswTQEt0Iya76xwRDUyx
         yKt0UD90wmpwsqFelfgnJ9YjQdPlu99r58T7b4NviwrWceRwPyzYWTZicIxWpzBD4gEd
         qZnmA720kUKPF5MIs4R/M2IEKQPslIIgiQKKLVgHXkLhZ2XQuKjSgk7MiuCAVRcvxsL8
         k0/KjcmQJ0hqsVeQY4Qy8GmQaQQorTqKedF8x/GceSW4Zs+XaAXkeqSPMJtnMNU2hNFt
         ZaiQ==
X-Gm-Message-State: AOAM53030xDkoIHtU7sruBZqXFgU4PxHs4sUWs7uGPc/zUL7D6IT1ab7
        NhHvAg2nOMiL8u3tJaG7EZTdTG9pfql/XA==
X-Google-Smtp-Source: ABdhPJwx4z3EuKED+jBN2PSvEEUtaYgkgg8Xxu2AI+v3M9Mag5BtGqxQ6Seywvcb/EDlzb/mDYtL6w==
X-Received: by 2002:a63:2e47:: with SMTP id u68mr20514138pgu.6.1617563774235;
        Sun, 04 Apr 2021 12:16:14 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 195sm13344859pge.7.2021.04.04.12.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 12:16:13 -0700 (PDT)
Subject: Re: [PATCH v4 00/26] ctx wide rsrc nodes +
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1617287883.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <66e81bc8-02ea-3f61-60e6-b7fd8acd48a2@kernel.dk>
Date:   Sun, 4 Apr 2021 13:16:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/1/21 8:43 AM, Pavel Begunkov wrote:
> 1-7 implement ctx wide rsrc nodes. The main idea here is to make make
> rsrc nodes (aka ref nodes) to be per ctx rather than per rsrc_data, that
> is a requirement for having multiple resource types. All the meat to it
> in 7/7. Btw improve rsrc API, because it was too easy to misuse.
> 
> Others are further cleanups

Applied 1-9, and 10-26 - #10 needs some love with the recent changes.

-- 
Jens Axboe

