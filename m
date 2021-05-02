Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71725370DBE
	for <lists+io-uring@lfdr.de>; Sun,  2 May 2021 17:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhEBP4p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 11:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhEBP4o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 11:56:44 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5447AC06174A;
        Sun,  2 May 2021 08:55:52 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k128so1895465wmk.4;
        Sun, 02 May 2021 08:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4qSNjpnYVIrWjdPYzqg5I/2wMnH8TyjLJXPRqrLpUXY=;
        b=T/RsU0qUGKEeiTqc+DKhx+CgzqIe32Em9ieeJWEgxs+JgK1TiY6I/i4vptsQzh4uY6
         x7YmnfC8HbYAx2qVTXEViF46/0tkJMwgQXAzKvMGJg8XE0HE1iAR8o3s1f4cXKLf4rKn
         zCWtnhbUrltCXWk/cVu+StEjp42SQ/OCwYZrt655UkkAxlrCndvuJ5Mki9LWeR6AWaFG
         u9/H2SQnv4EU5B+4sswKvmt/CZD9v7Sfb/FMteFt2d4UL4WKh62QPgMu1h5fIvv1wSKE
         38q+GqsEotIoX/JqzYuX3HmmFeIDA9CsrrwDWaqKgv9/BAncWnj4PHAKcaQPReqZhwiJ
         6gEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4qSNjpnYVIrWjdPYzqg5I/2wMnH8TyjLJXPRqrLpUXY=;
        b=cPGmHnpfKtVfKyMPq5KiJg3pJ/iCTfONNSR5YZD4mr1PvqkGhVXTq7f+spWJtZhlOs
         5C9U0y9Wm6Px77aIBQuquA2pF7vOU3Exexo84sVvjejOG9P5obH8Od5/K6WMm6GzOGM+
         xaWDkCYT7V2UBsq1dhlgyLTU4lvr9tvVry1JZsO0eYmMRLAXb2DxAEQEpSjvHtUVNc/2
         jWSLtenXMmy9P/QyECGeHOEvO5gf8/uWTJIfkuPXO/lPSvdu1J5hPQG03GmxvnDqPX5a
         5gPxQUgku2/1y9FXq29fdcC+gEaXAtZgmgyuIZsq/z86dKV/2a3iFVeMWNBm89cIZQFZ
         6PXQ==
X-Gm-Message-State: AOAM5336NTSgMysllqYdLfew5i1oC9B9Yok0B5CHjaFbo4b1Ep7RH0tt
        hQRh0yzetWxpVXj4UIFV/dioDIorsU8=
X-Google-Smtp-Source: ABdhPJxhlEOgthBdZGeHO4K6jWKoQu1Vxem1SoNbkK7cpvD3FKpjYsbIdnmUsuU3OO7s+WiFMgv0Rw==
X-Received: by 2002:a05:600c:4a19:: with SMTP id c25mr16780867wmp.94.1619970950806;
        Sun, 02 May 2021 08:55:50 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.156])
        by smtp.gmail.com with ESMTPSA id f8sm8163830wmg.43.2021.05.02.08.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 08:55:50 -0700 (PDT)
Subject: Re: KASAN: stack-out-of-bounds Read in iov_iter_revert
To:     Palash Oswal <oswalpalash@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <CAGyP=7exAVOC0Er5VzmwL=HLih-wpmyDijEPVjGzUEj3SCYENA@mail.gmail.com>
 <4b2c435c-699b-b29f-6893-4beae6d004a9@gmail.com>
 <CAGyP=7cGLwtw=14JSfOd40x08Xsj3T2GCeWTjDf2z2v0nb8e9Q@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e968c546-fbfd-2fec-0380-af81df7c791f@gmail.com>
Date:   Sun, 2 May 2021 16:55:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7cGLwtw=14JSfOd40x08Xsj3T2GCeWTjDf2z2v0nb8e9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/21 4:13 PM, Palash Oswal wrote:
> On Sun, May 2, 2021 at 4:07 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> May be related to
>> http://mail.spinics.net/lists/io-uring/msg07874.html
>>
>> Was it raw bdev I/O, or a normal filesystem?
> 
> Normal filesystem.

To avoid delays when I get to it, can you tell what fs it was?
Just it case it is an fs specific deviation

-- 
Pavel Begunkov
