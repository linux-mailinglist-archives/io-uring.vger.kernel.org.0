Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E8036B387
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 14:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhDZMyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 08:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbhDZMx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 08:53:29 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412BEC061756
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 05:52:48 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so1503678pjb.4
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 05:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pvHuTTRvu3dqKlBUowkHr2MzHQoOwsFjVpAFUDJTe34=;
        b=o+vJrGun2/dJdUi4n8ksg6UbFFP6F7n5g/1xioCB1RNzNg4eAUHR097Sg0RE00C1/+
         KBLFzqlwLPHVxmFxGPwPahZ2ZIvLzhRJ32v+P8tZJbG+Ir27D9OiBXeihKI8Es/YRGSS
         u1BSBYz/X11eMkDi0Btkan5vMUvaMDHOyvYfQtStk70dZ7OScSii16Flwllc5X8md8Xt
         K6+LVNwENtxg6wHPy3ghdLhui+wluykPSaIZWkutwsIdYHqIyoGEGIKsDVA0Z6Uf/10T
         +MsBTcuStqmY3FqCCdIjq2zWnqrY3cx6nfD9QPJ1xoLPx7Q0fySIcLEeVyMdZiogMIRW
         DPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pvHuTTRvu3dqKlBUowkHr2MzHQoOwsFjVpAFUDJTe34=;
        b=p+Egcw0hq1IJo/JgIBOdHu4eGCvkB77HjzVs7X45B38Uv3Q/nu+xn44zl8n6CR2b/w
         vS4KcZatQF6wgrkwSj3XHi2bMcrPA0emeGzpv0GNjot8AcRg+phyB12QYHQ9VEViRpSu
         EPSeIAms5mtADX3NzJIuj6gcPbhxLRedRqT4pK5ZDo7ImWxOhuKbEZIfwtiDoGOVdIl8
         TMJ8StGfxBy2+pdh7+P5wWqTgHwOKectFkAbH0kR9gkbDBDSPj0cxJJ2xur2RuEuumt6
         MRwPBdJAIDbQSGffLznZfPM1d3mtFUGMVsn2//k/gHCREchU7ARCXD2I9gftm15Ur8Fy
         NA5Q==
X-Gm-Message-State: AOAM530aH6lMBSo2RKwW+zW37MWyFf7pDJRu0b9YpFodFXpY7aH0ddpe
        eJtYSl91fJSl7/T8dCArbdJoHA==
X-Google-Smtp-Source: ABdhPJxySmudKVeg9KHxeKwyhIijJlOQ+/ThlXz/HrWJuuEqCfXY/aGlnVI6CSJIBq+y1h7i2PZjtg==
X-Received: by 2002:a17:90b:60a:: with SMTP id gb10mr23151230pjb.71.1619441567760;
        Mon, 26 Apr 2021 05:52:47 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j29sm11113089pgl.30.2021.04.26.05.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 05:52:47 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix invalid error check after malloc
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
References: <d28eb1bc4384284f69dbce35b9f70c115ff6176f.1619392565.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1ca67df2-d38f-4e78-15e8-a860aec7edea@kernel.dk>
Date:   Mon, 26 Apr 2021 06:52:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d28eb1bc4384284f69dbce35b9f70c115ff6176f.1619392565.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/21 5:16 PM, Pavel Begunkov wrote:
> Now we allocate io_mapped_ubuf instead of bvec, so we clearly have to
> check its address after allocation.

Applied, thanks.

-- 
Jens Axboe

