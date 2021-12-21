Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E868247B914
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 04:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhLUDpH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 22:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhLUDpH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 22:45:07 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D0CC06173E
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 19:45:07 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id k21so16021373ioh.4
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 19:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LiRATSfcL0WHDMuu5cadiflx7Px0RGfefhFEPlee57I=;
        b=EDKstOhUNAKb/CMJipkRosus0eVnYiD9WjmNICFPKHqAmv3lVWk8nkqwLB2994NdNW
         pIJY4L98JOE17vEppHyue7LFV1JkOCkGrFJn03fQp3HpkJ7CH6/+TbDK925xU48cVT/h
         fc3yshF9R5+9Zm4ZsQOspjlh+Rj0OnH94h/cpN4JNwdQWl+MxiqPb6coW3g1q61h+VjZ
         YOkpioqdo/xrVIlgdd4R0wdk1DX9d7nj1Km4XpGLvcl1YeK3x9yNvbsXiJqjLfKhlJNj
         8qtNOibEZ3Juq+rf1S9LzewQ0gEdX7cYzCFS/L1S1fFnLQdd0/GkScXgdrf+O8gjilFq
         kWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LiRATSfcL0WHDMuu5cadiflx7Px0RGfefhFEPlee57I=;
        b=xuYpYZkErr73b60jq3s1cY8/CJPqs1kGR9QFevk3aHxseCuE8Tneic/ILaG5M9Zr59
         Z8tYIvaxr8qPE9IJJwLKJIZFrfKzDCWsHwWoxx3OPeQb/m3Y3pGqeJeXeKTaqLalAll9
         1nE6SDqpdcGdmG4pK5WZNlewA1CJ/Ixawwp7wzFyTGerJBYCh5LAYNyCRoIJjb+yDsE/
         Lt/8skIZJadL4GxiLWYtE8SU+PdbHb6/ZmHG5fsVYzeXoiL27Ohcjcbwh7R1rY7t9lF8
         CinpvDd2+FriwDfSPXMjlemLYOZJ8N0u/f6oq+36n3wN1GL65KgNFpCfLYrIKoOCHkMx
         5obg==
X-Gm-Message-State: AOAM530D41TKlfgp/k1unLjOgUOgKuHgQyFk243m895rKXch0Wwu3VH4
        C8Cr29dpdF4okBm6Mdr7SZK+HQ==
X-Google-Smtp-Source: ABdhPJzmcq5nahDyyvJSGWaAasyzvTM8P9rt6FlKs+ABHdLFQiNWTeuLQL/Z3s/PHnb3++VtTid9NQ==
X-Received: by 2002:a05:6638:3454:: with SMTP id q20mr765825jav.77.1640058306603;
        Mon, 20 Dec 2021 19:45:06 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a9sm11144688ilv.13.2021.12.20.19.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 19:45:06 -0800 (PST)
Subject: Re: [RFC 00/13] uring-passthru for nvme
To:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
Cc:     hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
References: <CGME20211220142227epcas5p280851b0a62baa78379979eb81af7a096@epcas5p2.samsung.com>
 <20211220141734.12206-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fca4042f-6f44-62e2-0110-89c752ee71ea@kernel.dk>
Date:   Mon, 20 Dec 2021 20:45:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/21 7:17 AM, Kanchan Joshi wrote:
> Here is a revamped series on uring-passthru which is on top of Jens
> "nvme-passthru-wip.2" branch.
> https://git.kernel.dk/cgit/linux-block/commit/?h=nvme-passthru-wip.2
> 
> This scales much better than before with the addition of following:
> - plugging
> - passthru polling (sync and async; sync part comes from a patch that
>   Keith did earlier)
> - bio-cache (this is regardless of irq/polling since we submit/complete in
>   task-contex anyway. Currently kicks in when fixed-buffer option is
> also passed, but that's primarily to keep the plumbing simple)
> 
> Also the feedback from Christoph (previous fixed-buffer series) is in
> which has streamlined the plumbing.
> 
> I look forward to further feedback/comments.
> 
> KIOPS(512b) on P5800x looked like this:
> 
> QD    uring    pt    uring-poll    pt-poll
> 8      538     589      831         902
> 64     967     1131     1351        1378
> 256    1043    1230     1376        1429

These are nice results! Can you share all the job files or fio
invocations for each of these? I guess it's just two variants, with QD
varied between them?

We really (REALLY) should turn the nvme-wip branch into something
coherent, but at least with this we have some idea of an end result and
something that is testable. This looks so much better from the
performance POV than the earlier versions, passthrough _should_ be
faster than non-pt.

-- 
Jens Axboe

