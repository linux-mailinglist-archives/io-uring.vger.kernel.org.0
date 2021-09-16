Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C626E40DDC7
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 17:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhIPPTI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 11:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238471AbhIPPTF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 11:19:05 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01F0C061767
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 08:17:44 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b8so6938095ilh.12
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 08:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=42a3ZcBL9waQwJiXQYXY5yco7ecAEybNXK8FHnhM1Wk=;
        b=hHQVSu9Divcws3PYeypPwQQ1jsNRyLzwhaLaLGXWCtfF9ydwvX9y+N4DVbJ36QIyEU
         OLzie0OCCLToo3cOHkWw0BeqRO5AlTZKZH/hBin1Qp8Yo9yiyE4WSYn8V3/u7NWc5Txq
         IuGYUFhdPIrtVikWSLNp4JcM4jaxWGyb88ST3hHVlglKoEp3aI7BJPjDhenyHN+bsqxV
         cTTXfQRzBHkUoIi8JTeWewNYOB3bfgMpL7HJG/3p0R6tM3n/0r1QeXrqo5oCM1VeIu+F
         uh+m/9df2Yiv74RoXj3Hdk2Ms1BkKbASeLAOv/6YOLeees/+ANVnuX57rehr97jd7gtq
         zMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=42a3ZcBL9waQwJiXQYXY5yco7ecAEybNXK8FHnhM1Wk=;
        b=oYreK2sGFC5H58tv4T/8OjjkONR5JPPPlUNtPDI75xwPXh5w5na09bexIjgpjEizjK
         Zd9Hw/3IOK0ln9UmJV3sDove2DSG6vXqQIocIFJE6UjRZHCW5d6O/IYLPiuLj1ENEx0E
         6FmAwuFJshvn6SYZW8bzZLyZMNl4lc1siF7Nq3SlVZnL2/oqSPG99LX2lYdVoAXF4kJY
         Ups35MSh6Ei/4dzWF5KexBRV6uNYUF1dcnAWLs5gpC6oormtdTJ0XB1UKVuoQpGNyII8
         ZWpvNc4Riidrh+2U6HCiKFd289kWiTE0YxSnqURh4Qh+X8LOFiquHRHpPvgjbsFxk4d/
         OlQw==
X-Gm-Message-State: AOAM533XG+RkoUPWNLt81u9g2FUq/LL2NUID+PKTu6wicY2ErVZpBuw4
        aOwYBolNVqDMZc/0GyPuu/kwwdrniFNDn/PzaKE=
X-Google-Smtp-Source: ABdhPJwzuC6VgN+C+VEVD1yYSJPTvFMr+kmuTpcS5KFTdsm8Khwg/Hb0jhGT1Q6wu6p8xxnnzg91Zg==
X-Received: by 2002:a05:6e02:551:: with SMTP id i17mr4395412ils.281.1631805464113;
        Thu, 16 Sep 2021 08:17:44 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v13sm1814187iop.29.2021.09.16.08.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 08:17:43 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] Update .gitignore and fix 32-bit build
To:     Ammar Faizi <ammarfaizi2@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20210916042731.210100-1-ammarfaizi2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1c21b6c0-9c23-24f3-e37d-741674fc4972@kernel.dk>
Date:   Thu, 16 Sep 2021 09:17:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210916042731.210100-1-ammarfaizi2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 10:27 PM, Ammar Faizi wrote:
> - Add test/file-verify to .gitignore.
> - Fix 32-bit build
> 
> ----------------------------------------------------------------
> Ammar Faizi (2):
>       .gitignore: add `test/file-verify`
>       test/file-verify: fix 32-bit build -Werror=shift-count-overflow
> 
>  .gitignore         | 1 +
>  test/file-verify.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Jens Axboe

