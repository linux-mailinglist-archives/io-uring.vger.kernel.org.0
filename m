Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B11A67C2
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 16:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgDMOSi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 10:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730519AbgDMOSh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 10:18:37 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA05C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 07:18:37 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h11so3423437plr.11
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 07:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WmlHjWB28xV+x10AABgfyF1aAfabij82nRyzXHjqcYk=;
        b=GbrrIMhUMYgw9hi+UJoRsm+pJBALjxfhlORAgzc2t+nHVnJb5huAcaI9eKL2cYgb0R
         wsjZcUOJW2h+KHbbG0h6od1GoV61dqrD+ff7iCUnqj0Uv0t1KgQ89+C9HboYcfn0Phw0
         ucvi50VCC4c4Z2UzORp9eaW755jnDsiO3KzQAmtoZGx9kWbBultji9mOKoF3i/p607K2
         R3C+fUOjkyxWzmiS0J5GJnIPpfjpL4Yeg63HVzqMCzji8oSK6S4NkMfshKFt3yZ03DHe
         1u+ceabdpRgXvNlmW9rVa3E489at9i9rK5tFCfmVTYTq0afkAEYl3usOwFqDNJV9dTIT
         kj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WmlHjWB28xV+x10AABgfyF1aAfabij82nRyzXHjqcYk=;
        b=WcIDFbXRlyCoxmtSa8BJaNs6q00ZiCxRxu1YsdxN1Xha5hLXIv3gtjl8+T1mgVSiCr
         YR4ZaXkmKFIDQEyVhgLQA7iUiD9S5yx+V6H1GdC9O71R17ctih8BaxB4lhVbht6rw0L0
         qDLnl3dkoFyaFHVKwTQSYSE7poucEWGzWqa1Ez7sViwYYHgnVAqlGNVKaR2RQR/yI/oC
         yr/K98WZcQTDwN4/egEMnSGqSZB6WXVu0jwFxfAhX7nhdY+rzN1iFt9isCu/yAggFEuj
         olgfGItc32w7yLtHABebQUnctDmZsrwWwtIHccqyvSxlh5ucPtJPEJ24JxniYNNhuFwx
         n5sg==
X-Gm-Message-State: AGi0PuY7kyOxSx4sCSNzdxmI2f8+dNUxSLLWEqChgc0FlcbqRNdiaLyn
        CGtAgwmCoWqhEsLtmrKBr7FPDWbYv7HoZw==
X-Google-Smtp-Source: APiQypIENyZEUpZU5UE/kNyxIZzWHKLivIw89SArZNlMFPfEvm2sRbQLRx7TQbwBv9ba1abQyb5zfw==
X-Received: by 2002:a17:90a:65c8:: with SMTP id i8mr21723518pjs.156.1586787516661;
        Mon, 13 Apr 2020 07:18:36 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x27sm8942367pfj.74.2020.04.13.07.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 07:18:36 -0700 (PDT)
Subject: Re: [LIBURING PATCH] sq_ring_needs_enter: check whether there are
 sqes when SQPOLL is not enabled
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200413071940.5156-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <949512f3-9739-5514-2daa-1ee224d85b90@kernel.dk>
Date:   Mon, 13 Apr 2020 08:18:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200413071940.5156-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/20 1:19 AM, Xiaoguang Wang wrote:
> Indeed I'm not sure this patch is necessary, robust applications
> should not call io_uring_submit when there are not sqes to submmit.
> But still try to add this check, I have seen some applications which
> call io_uring_submit(), but there are not sqes to submit.

Hmm, not sure it's worth complicating the submit path for that case.
A high performant application should not call io_uring_submit() if
it didn't queue anything new. Is this a common case you've seen?

-- 
Jens Axboe

