Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF1219694
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 05:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGIDZH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 23:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgGIDZG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 23:25:06 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C06C08C5DD
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 20:25:06 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d10so254603pll.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 20:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=deFlbzkfMfRMfRuQ/QU9968LuaI6fXYErNVqNwLy8as=;
        b=XfXxLQhprQL4NnAPivi9oxxga+lkbU6keLLx0IU9ns311y+Px8w7PHpAvp64BESVN1
         kApTUyFPpte5GFuHFeS/tqgxuf+JfeKB/NfsCfL4/Q7xLCmt77fIxD8L1nsveweR5Z3U
         stZYA/J8PALWqAOyibX4wC/1mOzF7QgXrVOfRcKrsGPN+zRi5kVsmiu/7GSmraV76z1u
         9ZTiQ1RhmoRrRMw6K/K2zqK3S1fpXNCaMYko6BfG9diP84SEITRpvXXOBEAMHkSzA6Bn
         Z8NbKFFJdzezBHtv/nlht3avdMXFd1UzEOBG0W8I0Mpfku36kQjtIxFh7Q/lo58UxnOj
         k9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=deFlbzkfMfRMfRuQ/QU9968LuaI6fXYErNVqNwLy8as=;
        b=RnSJpiG0V3lEc3OOhhjV/iJ0i9WXkDuw+gNRwxALsDN9iTX7idYOuCe7h2ZWRCh2XC
         95I91WmF1lI68Bl+tGskhZyVk6//kzi1aGvcK8jdPMlnOQgDC0tpenKNvUeIYt8w1Lz8
         B79oVYTVbK/vCWN3Hv4rQaHPoshJRXbiq7p9iOk4dR7AGqvCyzIgQskJnCKQI3XdqW1l
         WN/4Cd5Zhhq3y16VRWV0NjX6+luuTVk2bOmf8J1PoqM4dv7TrlF/+C+AJVNF/AHWCW1L
         4vKiY56PJgS8uzDAeZcIdS8Ew2HAHD2SbPWlClNvX0PfjTprrLEAzU0quV9GLuP5fcWl
         HZAQ==
X-Gm-Message-State: AOAM533Ktj6TO2ShvGcBCBy+XMaCFw5MiVif+TtCNKZGjvMetqwQg+5K
        aOVfONJ9oBeA+7trH2E+4YMFIw==
X-Google-Smtp-Source: ABdhPJz560zuzQ7gzwQLW5ElxrPuuMfP9mKyVDEbkWsInO/9g2BC0r+xIW94+9fByxAUgBsOGZ5Jmw==
X-Received: by 2002:a17:90b:4005:: with SMTP id ie5mr12867035pjb.147.1594265105583;
        Wed, 08 Jul 2020 20:25:05 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y198sm1043506pfg.116.2020.07.08.20.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 20:25:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] fs: Remove kiocb->ki_complete
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200708222637.23046-3-willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a0d5c015-1985-280e-2253-8e2663b234e9@kernel.dk>
Date:   Wed, 8 Jul 2020 21:25:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708222637.23046-3-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 4:26 PM, Matthew Wilcox (Oracle) wrote:
> +void unregister_kiocb_completion(int id)
> +{
> +	ki_cmpls[id - 1] = NULL;
> +}
> +EXPORT_SYMBOL(unregister_kiocb_completion);

This should have a limit check (<= 0 || > max).

>  void complete_kiocb(struct kiocb *iocb, long ret, long ret2)
>  {
> -	iocb->ki_complete(iocb, ret, ret2);
> +	unsigned int id = kiocb_completion_id(iocb);
> +
> +	if (id > 0)
> +		ki_cmpls[id - 1](iocb, ret, ret2);
>  }

I'd make id == 0 be a dummy funciton to avoid this branch.

-- 
Jens Axboe

