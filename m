Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FB23A8B44
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFOVlk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhFOVlk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:41:40 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F865C06175F
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:39:35 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so447865otl.0
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CVEv/IgDHzRWElqNAWTEDnLSe7O3k6kaEe7gdNKBwXs=;
        b=L7xnKUuBZnqcumMzDuO51h3ey7Upob+cfoa9yJzYNKjrprkDxr6Lvyk9hh3EeWcND1
         obGIVDNN5GP+2fZL1kRLpnDklbdretnXhk5xG8M782Li0lJT8pjLUluKOxxQok4wYoc6
         5hU2Re9fJj8zyxg3Zqn9OtVcW9hgzegr0UyHVzzKKibLfrY7feATVBs9RdcSFEuH9KB7
         JVx8AQdqljz1vxP16CMmeIAjihCuczkgM5I2Qm8qXRTegl2rekwJNR131ZljD5EY9HC0
         oqCQkjcrvzAtdvg49IunU8NI+mosF1ZaJLo61UsbP6RB1dMjzQRV9IoVeeTALlchSgsl
         JXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CVEv/IgDHzRWElqNAWTEDnLSe7O3k6kaEe7gdNKBwXs=;
        b=DY7aOid+1voh+ZgbTW2ZBGcsCs3/Tga2YcmFR5fh5mok3UGghsCKxXrPRJ99GwPuzL
         d8bmO4cCyBHUZOwBm+Pu23QzRNuwPwK6nnlBSDPKm8w8PFY6XL941yPpQ+9TyWPEjdP8
         XiVeKCdmR9Ao7hGAkkdzLxjqeq6Ci1dxLaW+j30D22kSQmu2qLXmLeac346IN47I+GTW
         QnMUv+Ncb0RkA9Ol9HYmXzd6oGzR/DNTwn410ayURtPwXro50aeEdH8iO3FnNCeEsd1O
         KSCNHolrPK3pGJvij9uJN6CgWcpFr+i4lHKt2KPIgwyM2Lq7BRtKu3hKdaE2rtUIzZW2
         RnmQ==
X-Gm-Message-State: AOAM533RWxVVQHi8rZwflXBaDakq4FDFpUOcSjc8qV6CnkdTUaZeIGWV
        L61gJUWKslIZQZ3J2stCgmgqYw==
X-Google-Smtp-Source: ABdhPJzpIzcrtFLmozksgx/FN5kkj2i/e/VGxdP5QqTdJZnr11gu97Em+EN5wpKa/S90U58uzpK+Gg==
X-Received: by 2002:a9d:7b45:: with SMTP id f5mr1057063oto.183.1623793174961;
        Tue, 15 Jun 2021 14:39:34 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x199sm30093oif.5.2021.06.15.14.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:39:34 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Fix comment of io_get_sqe
To:     Fam Zheng <fam.zheng@bytedance.com>, linux-kernel@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        fam@euphon.net
References: <20210604164256.12242-1-fam.zheng@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e12382b6-5c29-c8c0-6874-ad5e2befce1e@kernel.dk>
Date:   Tue, 15 Jun 2021 15:39:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210604164256.12242-1-fam.zheng@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/4/21 10:42 AM, Fam Zheng wrote:
> The sqe_ptr argument has been gone since 709b302faddf (io_uring:
> simplify io_get_sqring, 2020-04-08), made the return value of the
> function. Update the comment accordingly.

Applied, thanks.

-- 
Jens Axboe

