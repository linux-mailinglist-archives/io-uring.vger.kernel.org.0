Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8E6404007
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 21:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhIHT6n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 15:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbhIHT6l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 15:58:41 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96057C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 12:57:33 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id b200so4823136iof.13
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 12:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yvQpJnoSQ4wBB7LK029sNXL0ejfbhmaiIEzvB9Ouprg=;
        b=hsPexRPtgYLz1cajAlxTveXBnIEoYVix3KjhMGUt8CjNuK5rPjqEuN2Ze4QcVfcJmL
         cNMT1T3cZeuqhZgB9wqT5NNXtVQeQSYppMStIHqy3+e058beCdSjyNgfVEBIp7iZxgLP
         2XzovAYICqdfA+s1g1Wp5y9duQMaiV8xgFjA1030HYmcLh78CI1Ixbal+CLzedH5NyiZ
         ZLnpWFEOzfisBn7C2eDlBSJ4lg+LE+l5OIiF9KhIS9gjTzCHEq3GWE44hbQtd8Tbjsfp
         6L0m6OorNqPgw4LOAaUklhHcMrpGlex50FLwmhh48bc2S/jqhxfcFZNqVF9yWHM8ICkA
         2clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yvQpJnoSQ4wBB7LK029sNXL0ejfbhmaiIEzvB9Ouprg=;
        b=XaIIs0kY9tTHi2Qy4X17gRxzVY9ym8lfs4hMs8t3ZgXu1J0zrMBuVROQnm3Rc47nZG
         +FXMy4sxo8SyFa/JH+AIN036mxzyKr7mSPbCxv8S2qQMA+n4gInz+LWQR1pS2IaEft6G
         1cZm7v16CeVjPhIWyd69A9KXXDL/SStKFveAMTn0or9Nf5XrnKKdNmFTArPtwkzZ28AA
         nK/frzYARLdAfvE0j088q4I2yD74dCuepgGjtGwMfHD+xo0t4DKgAt5RqFUItZ/MpoMd
         vZwa82MU9dNBr0ZT+EH8Er3wI7pQzMXpnFXUp6OWPWlMChob+Af0fSMnWLd1xLU3YtaL
         780Q==
X-Gm-Message-State: AOAM531Amel5IGUgDJLkiz8yx3lSHVysSHXDJuPS09+QoZgZFttK9CLO
        DBzFDjVz9nFL8tWHjNvKmbimTNfqg1f6nA==
X-Google-Smtp-Source: ABdhPJz3ZZEuQX9k3JkxQzCoSUXGunpfWhHuJ9FxQx6FSV7j3eWImtRJj5rTK57iCHD8aQ68HHryLw==
X-Received: by 2002:a05:6602:38e:: with SMTP id f14mr1869iov.62.1631131052775;
        Wed, 08 Sep 2021 12:57:32 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id x2sm28357ilh.46.2021.09.08.12.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 12:57:32 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix missing mb() before waitqueue_active
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2982e53bcea2274006ed435ee2a77197107d8a29.1631130542.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bd0b0727-d0ac-7f2a-323d-39411edbe45d@kernel.dk>
Date:   Wed, 8 Sep 2021 13:57:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2982e53bcea2274006ed435ee2a77197107d8a29.1631130542.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 1:49 PM, Pavel Begunkov wrote:
> In case of !SQPOLL, io_cqring_ev_posted_iopoll() doesn't provide a
> memory barrier required by waitqueue_active(&ctx->poll_wait). There is
> a wq_has_sleeper(), which does smb_mb() inside, but it's called only for
> SQPOLL.

We can probably get rid of the need to even do so by having the slow
path (eg someone waiting on cq_wait or poll_wait) a bit more expensive,
but this should do for now.

-- 
Jens Axboe

