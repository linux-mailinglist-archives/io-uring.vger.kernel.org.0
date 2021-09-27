Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FEB419512
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhI0NaP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 09:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhI0NaP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 09:30:15 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51610C061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:28:37 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id k13so3925260ilo.7
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kOwDZK03h3X4osF97oR+VxM6NUnj/bLMaEJeUWT5MzA=;
        b=nOMnqje+UKjXF0dDEl7EydvexrgmSz0Kj7JENib3VemEyS4TrGjzaw6xKOe90o73Rz
         226uoNIXCHS1gxSS+8+g99kh9edteZl/NvmoyyPO3Qb82pR7X3tAYpb39hWy4O23sXuH
         gZHkNPIlHdJl1+9BHyPySnq1D2X5R5Oh+zzQsFodWJzDXc9alWX4UGapEX7J+aWUmOv1
         6t20Yjh9Qppb90lDI/GpQnGQbLrl1RHxT98lTha24/PSliHyp6o5aBivE1YqvbFTwILO
         wQjWnN+n9naDIRp6qZrjpGW4qZQtrJtOjPIDWPLOlN5e68pbSw4PbhACebFUvwA0elWu
         su7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kOwDZK03h3X4osF97oR+VxM6NUnj/bLMaEJeUWT5MzA=;
        b=fd2IBEl7DpwDH6t9cFt4pChUt0nGLKuFskXe6aC1sOo6O0ZheXGBcF/tbfz+3I2zRb
         323pVt0gM3ko/NQBxI+tQOnBxRy/NNkhYQZT9ed4+BVpRSKqvqhhfBRhfzcsFSsUeVrD
         Tmfp7LGWtfwjh1uY6dHn2iNK+9fv3KuVD5D3PeaMLMPhIj/FrD6NfRjof9FMztRl5x+4
         IaZuJM7piUswXlqGRxWq9moc6ByMGRYDuR1gpmR7URHHS3fxoXZFXExx6BdhAdPJM+zN
         fbUV31tyX+Wv3dYKlJrc71qOUs9PNsN+zgYkGP2eJFH8w8X47xbrwx31J6qbdcVSpFhC
         QhSg==
X-Gm-Message-State: AOAM532nPTfi11AsP1CCp+/igNunrbkiTk5XsPnAtCXRWEEUkSwNYMP4
        Eugq19EfGMSTmb7wuKY2heQ/Xzp9DhQs9IVQwpk=
X-Google-Smtp-Source: ABdhPJze2e26y1M8PKIosJlBDUKGtTzlDnmwWHad5plq5/74s3CKEuprk+PxCo81qP/9WwSV7tuHFQ==
X-Received: by 2002:a92:d5c5:: with SMTP id d5mr50451ilq.36.1632749316499;
        Mon, 27 Sep 2021 06:28:36 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z10sm8639258iot.30.2021.09.27.06.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 06:28:35 -0700 (PDT)
Subject: Re: [PATCH liburing 2/2] test/accept-link: Add `srand()` for better
 randomness
To:     Ammar Faizi <ammarfaizi2@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20210927043744.162792-1-ammarfaizi2@gmail.com>
 <20210927043744.162792-3-ammarfaizi2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e5e3e4c-5f42-8a17-a051-d7e6a5ced9c9@kernel.dk>
Date:   Mon, 27 Sep 2021 07:28:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210927043744.162792-3-ammarfaizi2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/21 10:37 PM, Ammar Faizi wrote:
> The use of `rand()` should be accompanied by `srand()`.

The idiomatic way that I usually do it for these tests is:

srand(getpid());

Shouldn't really matter, but we may as well keep it consistent.

-- 
Jens Axboe

