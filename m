Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18140322C25
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 15:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhBWOXO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 09:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhBWOWz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 09:22:55 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730E3C06174A
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 06:22:15 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id u8so17194589ior.13
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 06:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nJsaQS4LjmSI0jlXl//pGNbiIk97QSZkq7uxylCoXHc=;
        b=K413w/W7RnndI7l2MYjX8CmMqOEKhBJdNwVOLYd11po0hN3CNTysXjAQk+aHFrG50C
         8/i+iaiikqHsczrMW/5Ik6ic7C7prnEtrluOYjUG9+eQlgn2B8XJ+8sTiKW+fmW21Fv7
         xua/JSc1thU1YFDH8WZqBVFCNgCyDxrlW6t1X9cfv+e5ndU2ZHpHhjgaXX24DZnIqMpA
         /vFt6zyUua5LIt/m+bPAqQ+x/evm+LrfhZgPYnlqx9YT3b+Om9kJ10H6TMNFVwx8RUZk
         sGMd9xMKS1+sMHnYINvak2NhDYL3hBTN1XDp+FdgEGhY+orbI9SoqPhBeseKzzSFNSMc
         yKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJsaQS4LjmSI0jlXl//pGNbiIk97QSZkq7uxylCoXHc=;
        b=MbI2rzpIWv7ml11LSKaTquWTUIiMyqp/gGI4s5jGd4esPBPclAblL+Y28JxRA/Wkey
         83PuS2UC2RZt/0rmUd6Epk6cJ/Ctt99OTKRuTtPVrs6gSimYN7HdXgCA4KHbR4jhm6S0
         cQLcHHba3WY20RayptWAGCb92hY+v1GPgwRsneQ83t4eCPzUIVnU2eTnDziU+kP5erBF
         T/sQjRdqyODbqLOxL2iIicEE1nZ+6JaiYGoFZSS4l1yY/cVngCyBeLD5pis6u3a4wTdp
         iQZcWzlzJSNpuukXwtJwvakqqy5o+r0m6Lbi0FxBPVqmFyezQTazgKM+nEQlNa6y15G/
         MqZA==
X-Gm-Message-State: AOAM530cPUpaoN3HPOUZkhPLZ/Q004G6OBjWdwJt1zPaofDVdO5nlGQa
        MbebY2KjS7CIvfMPBx5TK1uakpuVoMa6lqeJ
X-Google-Smtp-Source: ABdhPJyCyiaQJEX9PToy9ZZJLJ1lMs9wKfsbM7B0/igfAxw1CEgNzlDmJyaqMyHV6zNVH1AlYixNIw==
X-Received: by 2002:a05:6638:22c5:: with SMTP id j5mr28082434jat.89.1614090134790;
        Tue, 23 Feb 2021 06:22:14 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c16sm7264173ils.2.2021.02.23.06.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 06:22:14 -0800 (PST)
Subject: Re: [PATCH v2 1/1] io_uring: allocate memory for overflowed CQEs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <a5e833abf8f7a55a38337e5c099f7d0f0aa8746d.1614083504.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <02fb8f5f-3f97-5945-06cd-c155574847e5@kernel.dk>
Date:   Tue, 23 Feb 2021 07:22:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a5e833abf8f7a55a38337e5c099f7d0f0aa8746d.1614083504.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 5:40 AM, Pavel Begunkov wrote:
> +	if (!ctx->cq_overflow_flushed &&
> +	    !atomic_read(&req->task->io_uring->in_idle)) {
> +		struct io_overflow_cqe *ocqe = kmalloc(sizeof(*ocqe), GFP_KERNEL);

This needs to be GFP_ATOMIC. And we should probably make it GFP_ATOMIC |
__GFP_ACCOUNT to ensure it gets accounted, since the list could grow
pretty big potentially.

-- 
Jens Axboe

