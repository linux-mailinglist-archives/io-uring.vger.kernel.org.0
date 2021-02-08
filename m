Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E486D3137C7
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 16:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhBHPbB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 10:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbhBHP2G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 10:28:06 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD70AC06178C
        for <io-uring@vger.kernel.org>; Mon,  8 Feb 2021 07:27:18 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id y5so13081607ilg.4
        for <io-uring@vger.kernel.org>; Mon, 08 Feb 2021 07:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rWA5lYRxu9f9oKL/yyhzl2icZOvsnq36zU7+Pmn24pg=;
        b=bUTr6ilYhEP3pfY0dyIPzsVeflcdho76BNi9RWa0djdO3aBkfdqcP8c+ZNNN8uwa24
         N/rq/BlvJ72WQDeeYvvUybx27RiCo9UKfk0SSv0CtJj9qoujX1eDYntRwdpSl8c9+Wjm
         zRvCNT9n2M/TG7vOqiRUV3Z+X078GugEwBNQrCHEX3a4mTamreAe2qeFNszKIijY9kUV
         RZOrqTChs5fR95P7STs7p4GjPeguxQsEbqGbSG3XA3OoaPWfxszMC9sUboz4dWznxu4x
         iJy9me0ppwUYiATqNDXewMtt+p3Ip/qMwVba/7+S2q31OfWkzIzlgga7A7Suwk2T8lg6
         Y0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rWA5lYRxu9f9oKL/yyhzl2icZOvsnq36zU7+Pmn24pg=;
        b=OFFpezVEBJlUZ0euU+O3r+S4znE1W9KxcPHiZKk7eblIHI8TP4PAG59oaTlyxnbjk8
         Ycyb6ZT05pe83wKQiz38wzYMlRi+wlQtiNs6knkgQbZJUSoc4baFB/msVhefvrHxK7f/
         VIA23Au8E5HUZYr4/QM/80GluSmee6bnXb+77c4nh6a3kXWDInUS533TfTVTCPh85o5B
         Hk5q0QDwTd7fajmiTOnF+t/o6rypNH8x0X8Z7h3toyJgr2Ibs9D4iCSwBtENFOAWIBND
         gdIwt1DiVuzOANBhOiuPZ38F0uDxFmsFTppZUmMmRTN0J5Q9CjisnNtF5kp6yjzYVOio
         iNGw==
X-Gm-Message-State: AOAM531vch5gQ/4nxWtLRkmWvW/9cYy7+AwQsvCtTtiMLJkMBMPhmSsM
        XYAqx1A+hNFEypF47TJIbkmGBS9buB7uqIc2
X-Google-Smtp-Source: ABdhPJw01aAcVZLmPAUBCC56/LHLPNwYeXOCTQxMCkxLyOpF5+zPjKrbNESb/5Y6E2WiB4v8engcRg==
X-Received: by 2002:a92:c269:: with SMTP id h9mr15515138ild.239.1612798037830;
        Mon, 08 Feb 2021 07:27:17 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r9sm9063968ill.72.2021.02.08.07.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:27:17 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: cancel SQPOLL reqs acress exec
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <a50e2df51707fc1de3708fe087e08b3aa16f492a.1612737169.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fb823f26-3257-bc7c-4b2c-7837e4b7e3c6@kernel.dk>
Date:   Mon, 8 Feb 2021 08:27:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a50e2df51707fc1de3708fe087e08b3aa16f492a.1612737169.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/21 3:34 PM, Pavel Begunkov wrote:
> For SQPOLL rings tctx_inflight() always returns zero, so it might skip
> doing full cancellion. It's fine because we jam all sqpoll submissions
> in any case and do go through files cancel for them, but not nice.
> 
> Do the intended full cancellation, by mimicing __io_uring_task_cancel()
> waiting but impersonating SQPOLL task.

LGTM, applied.

-- 
Jens Axboe

