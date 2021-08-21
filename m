Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26D3F3AF8
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhHUOZl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 10:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhHUOZl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 10:25:41 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94B3C061575;
        Sat, 21 Aug 2021 07:25:01 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q10so18555737wro.2;
        Sat, 21 Aug 2021 07:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DLjK+TCmc9BqCXwaEVOpZUxm3tmZlEUADQgsTwUiIcI=;
        b=OJeChMwKcJlTC5d0x5snzvzdVMSpJoOK2q615NGGJ0aMH7Kd/MGw87rj5cdBGDKzp3
         rD8gJ3cmdoOYufntUhAIhe45CoEgxaDNApEk4nusNQhGgbqPs7l/txQaiPLiPSrbBo+7
         5lgKXbUSlaw2TeUu2E5HjoPEOxmieMJc/0OOBALoCGiJMUAAgz9vhBVWCFXUcigM4ZsT
         WjeedD03pgZgxWD73XeIQLgZLS+vfz374a2DS/D93oZL/zzvif/xAcqkz7BevMRXbSN5
         /u1fRoaU4VLWS2SRWIt8X2ActZ+zqtiuECDskpmVdCatIDfTky+lQhBziILXDR60VoZ+
         whnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DLjK+TCmc9BqCXwaEVOpZUxm3tmZlEUADQgsTwUiIcI=;
        b=UxqILvYdyZxVIlRqy/Fi4jLXYs9ZXMLwlJdwmgIX4vyI8jsw5aEmvcyOt86rNMQQf/
         q2asaATZzhVgSDCKiTiREGONCsT3Fjyys+p3KhIzBZqq0bv/+Ro4KUzaJ2KU7yL28Hj8
         t8O2ugdvLOdo6gwKZcwqmFgwYoRcLMzfJ/W++MB7Dr/O9RmLueqmL0J8rdTOD8ybJHIH
         zzmbUWh+BIyXAwK0wghNDm4l77SiPMOJufKyZsja7VPKxaI0MHS537nShPfYK60xU5qg
         +ZrIOXHQZKHhgOMP/QoX+pyUMZu8sog0Tr6SSBOzxb+i9UP+KE+zf+J28O2E/bYormK5
         V0eQ==
X-Gm-Message-State: AOAM530w0nCRYIIsrBIJn7GjPVqSLRPSJwt91Wmf2JYoohrPysfrNbYT
        CO1vDsxZtE2eT3Ia9PrfJMk=
X-Google-Smtp-Source: ABdhPJygVgV/uwI57UhxLV4Uz/WhIThhKyoYc1v8ClxzcHcR0ljxE+3ObuhgwGftO+Jpl45ySaQ6ww==
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr4143703wrn.120.1629555900469;
        Sat, 21 Aug 2021 07:25:00 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id c2sm9237747wrs.60.2021.08.21.07.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 07:25:00 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] iter revert problems
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
References: <cover.1628780390.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3eaf5365-586d-700b-0277-e0889bfeb05d@gmail.com>
Date:   Sat, 21 Aug 2021 15:24:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1628780390.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 9:40 PM, Pavel Begunkov wrote:
> For the bug description see 2/2. As mentioned there the current problems
> is because of generic_write_checks(), but there was also a similar case
> fixed in 5.12, which should have been triggerable by normal
> write(2)/read(2) and others.
> 
> It may be better to enforce reexpands as a long term solution, but for
> now this patchset is quickier and easier to backport.

We need to do something with this, hopefully soon.


> v2: don't fail it has been justly fully reverted
> 
> Pavel Begunkov (2):
>   iov_iter: mark truncated iters
>   io_uring: don't retry with truncated iter
> 
>  fs/io_uring.c       | 16 ++++++++++++++++
>  include/linux/uio.h |  5 ++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 

-- 
Pavel Begunkov
