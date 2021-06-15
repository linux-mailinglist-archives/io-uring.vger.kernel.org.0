Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330193A8B56
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFOVq4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFOVqz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:46:55 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55CFC061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:44:50 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id x196so123447oif.10
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dt7Vsh5Y2hPjrHWO0/YqKaNk/fIDrGnh5yztqpB3c94=;
        b=KFW7pYHN4M+RhNCDetim2T2dKrNdXP9uTtCHiuUFl8bxCZqO9gNIDsM2FcYWVlagGW
         rHQRu13S/EBWV1gcI44UhtAdu0Wu8sCGsr/RS6K9RK2VrbwwKa8Ik0SPEQRVAdSf9Luy
         kRl8Bt6zbx+imKQNmIah6ZoCXK2+uTsH2+hKm22ulufWU2h9KdqqQ0Ydnq/xLiF9nD4t
         cluH9h0yb4ZuO6gLjPIdnXFkULHCCN5OMqaPbaMIEU43nwNdrnnMdRw+bsKzRNNZPJZd
         z382d1MTKgHxvS3tsF9NNAPIvEjRtaZHWt75dAX3eCv27oXgsYG0yrSrYU7r813G+38z
         vRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dt7Vsh5Y2hPjrHWO0/YqKaNk/fIDrGnh5yztqpB3c94=;
        b=rNHw1I2MzDuc8rUstZCnzW1G8YmrP8Rfb08t3kCr3qWrvqouB0pj/TbDydvjfEEZXn
         bwvicPcPkB2C+eTP77DzMBZqQItLHNj/ppS3lYsPb7gmC739dcdA3DatkhFZz2wG4IMn
         IHi6pzkfcaKJyu6y1facAa9uEG2oBMwh50B9HO8bjUKubvTJF8uvdynpwaRgHBRWaOJo
         yVAeuRPC1laUDvVt6qyF93BkfNmtz8beMWoc6M2bxu7L7My6YUABgqhVkng82R+/tViM
         //XrvSAJy0fsqXjqT1o/UBR6lE99v22lz67tebwVMun9Lqt3vRv/+vGxgKZFMGn0+9kN
         OTYA==
X-Gm-Message-State: AOAM533Gy60cegYypF0KLz2NH200Ln6PuRpX5PK2ETmpD/x9tMYmM5TC
        tHP1SRqsF6Nm5gAuHvPwJo6eF/7MtkOzNA==
X-Google-Smtp-Source: ABdhPJwUoSjdziqpQ19lvGfGNRAGzFci4fcQjTwmBMKi3BGP/yAn5lNfVfL5j39ROhPPG6PQcbl3jQ==
X-Received: by 2002:aca:b609:: with SMTP id g9mr4743826oif.141.1623793490116;
        Tue, 15 Jun 2021 14:44:50 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id e15sm29366oow.38.2021.06.15.14.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:44:49 -0700 (PDT)
Subject: Re: [PATCH for-next 0/3] further optimise drain
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1623772051.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <46651e27-9a4c-1ede-2577-070abeee9228@kernel.dk>
Date:   Tue, 15 Jun 2021 15:44:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1623772051.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 9:47 AM, Pavel Begunkov wrote:
> On top of "[PATCH 5.14 00/12] for-next optimisations"
> 
> The first two further optimise non-drain and rare-drain cases, so the
> overhead of it on the hot/generic path is minimal. With those, I'm more
> or less happy about draining.

Applied, thanks.

-- 
Jens Axboe

