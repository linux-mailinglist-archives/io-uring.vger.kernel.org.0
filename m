Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABDA21CB4D
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 22:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgGLU0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 16:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgGLU0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 16:26:36 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7FCC061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 13:26:35 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f2so4539750plr.8
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 13:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=im+u6qB7pIU6QDozfinT8rG/sZhU3XfR+U7R+V1tE9w=;
        b=k6GvFcKqASMaGXURnQQBEAXocgC4jX3r+UtS9DUsNj0tWbtXWNCtrtzlYe0PvezM81
         tVBUa05OxZhSAJL88ppaigP0PUX+ShSpvrOjjECum/rRp+C3uuAOIXRaIv6WMNN8fcTn
         8x0UwTfqM2xs4p8iKahR99eDCGYIdk1fXj8RqzFkpGovNH5Rpsx+BS6Vu6fskoDT5WdF
         eLgOjDBMOgtQwjb/mIclBAwIMSm7DRb+F8HslU2xeYecWN86YXVeBXcyaT47p5Qknuzw
         NJ/a4I6ieHxNyx5Scg2ameGq0gRPmwO02rGSsrLfUwornGtGRG+fXpuFbYoBE4TpkAmK
         7D0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=im+u6qB7pIU6QDozfinT8rG/sZhU3XfR+U7R+V1tE9w=;
        b=nz2rFoJdWZEO1wftybHDI3k5ONFsqxKpfD7znLMTW+aGaGecbHSed17Sg8jefavZbw
         7bSTd+Iskbbh3ZgLdyAavnL7dTKjm5DECynG8f5L2iE279SGKdJiiotm8nByq9lLPT96
         xd+TqEXFZUtERIGK1zo7piDUpS5F2Ccz0Yzc1sxJSKdlVLxf00qDlhKm/b5gAhH7X97/
         /sqjdNhrdkTJyPU3C2LXvS22JghykSMB0kzExSRdLnTX6lwNT4Wgs06H8zHPC2rJWYc7
         +EcKA8UY2S2QGIVBBI3CZ6MsyDBfge002CuIRCcUME3KHy9ZXhQxFc2zBG+lowjZ7y48
         UQhA==
X-Gm-Message-State: AOAM5314m7loVba5nmb0uNF2rnZTgkhMqpoZ50CO5Tq27i26SetK6buL
        JsSZphHhh2PTzViAgRaVFGNOJKJhxjjvZA==
X-Google-Smtp-Source: ABdhPJxvSATWX3VyEwugal6KF6HamcIatalqa+hxmR//DZyuoOOEetKqc6dIzLuRoizmcnUzpaSwpA==
X-Received: by 2002:a17:902:b714:: with SMTP id d20mr54321820pls.318.1594585594994;
        Sun, 12 Jul 2020 13:26:34 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v11sm14030273pfc.108.2020.07.12.13.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 13:26:34 -0700 (PDT)
Subject: Re: [PATCH 5.9 0/3] send/recv msghdr init cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594571075.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a29e3fa3-0d43-13fb-05e2-11b418ad2ddf@kernel.dk>
Date:   Sun, 12 Jul 2020 14:26:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1594571075.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/20 11:41 AM, Pavel Begunkov wrote:
> A follow-up for the "msg_name" fix, cleaning it up and
> deduplicating error prone parts.

Thanks, applied.

-- 
Jens Axboe

