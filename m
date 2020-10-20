Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B1F293E4C
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407893AbgJTOKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 10:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407885AbgJTOKX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 10:10:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8BFC061755
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:10:23 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b8so3452978ioh.11
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SBaSBfu656qhq7C4RR+jeL1RKTbB8xV6zGrQBr8G28k=;
        b=A8e9tmxR9EHDHL+Pe/ZDawFtyXseIO2dF09yQ6CNuKcLY9Sy7deV3MT2fZmh7uTv9Q
         nt5dBabVWnlVqn0fvNQz2dv9G7kBJ47JK1O0NHBm5ugoc/NVEZHzf+7wBnGiIpIxonu9
         9H8pCkNwG0008Oa4K11JKIKg7A7SLa3zQXl/PDd95Lw/CvLC+riVWxZy2cLrMicvCe0R
         sKjawOwxhy+Qr6vnvj5nk2y9YAy2TyfzlqditOEB1967iz4PXtRcQg4l6QCyeQSl+lZ9
         QuLHJDOwFjWyOXggFTL6pdUZFcNBKaHbg2JXd1z3C96OiS4ePj3Y44J0Oyd4RJ2wu88A
         5gCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SBaSBfu656qhq7C4RR+jeL1RKTbB8xV6zGrQBr8G28k=;
        b=Zv8ja6FnPkcAb1KN7WbVz4voksr1DLq7iuwNkQukeiGMIIxz8191bPPrZzD5hdXQxr
         D403KuYyhYBNIB00Rtj6jZFbq8pj1hCH8JWAuOpfUl3LBhzn1138FTxpRcVwtbmEao3S
         DntdRehxJW25ARfB49c0+9rqzwTM0J76GmAwnq4RrAoscESAlav7MRjyN3aCH7If2X7P
         rADDBBDb9sBjOzy395rNgsx/rxWD276kRYmzqHrGXAazCkpeFm3vpEOCrhafwzVy7Oy3
         m3m9TyXxgbItSsfoCdr2TtTNXglXCA+yATxBSRnYNhwEgjMf4LADwHLa26K/07AyB4qE
         RJVg==
X-Gm-Message-State: AOAM5336vYgnDT52dFhTWzWBu2vlJ2s85m4BtOTnabH7y0tNIhsE6DMZ
        OHQ1ta6z6IXwGO1i4TNeRqP+Y0HoASY6XA==
X-Google-Smtp-Source: ABdhPJz40gxxODT00lVEnACVSnNj5esoL9nz1bySkNgK5IkQ+L14TdRkjDwHFrtU37feMGnpjA5S2w==
X-Received: by 2002:a02:234f:: with SMTP id u76mr2197991jau.117.1603203022568;
        Tue, 20 Oct 2020 07:10:22 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e11sm2051590ilp.7.2020.10.20.07.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:10:22 -0700 (PDT)
Subject: Re: [PATCH for-5.10 0/7] another pack of random cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1603011899.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0e249e38-66b5-50b3-2ecc-5f6503728dc4@kernel.dk>
Date:   Tue, 20 Oct 2020 08:10:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1603011899.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/20 3:17 AM, Pavel Begunkov wrote:
> Nothing particularly interesting, just flushing patches that are
> simple and straightforward.

LGTM, applied.

-- 
Jens Axboe

