Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0C3206AB
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 19:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhBTSeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 13:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBTSeg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 13:34:36 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1031CC061786
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:33:56 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t25so7508729pga.2
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HioyY/zbAPIj+crROh/DfoA2KnW7IXNNFbS9q3Mxe14=;
        b=uOplQez0BO2rqWZ16Itp9ZCHA2RTFTX52FzEt771e53F+oV/3YfJeAy9oRGu9Sn3ta
         dCC0irhSPwD9wR82eMmIZeO/PkT9rTnA2wqrGZO65qmJ3tz1SiM4DKBw51nIGumID5cM
         WqDVmVA8I/p379cPwZ8kiobKoenpYBsTHbzYyKxtFt7aTK3Oh05aBcaBQtHK3wkXsSD/
         BLegPhnYkxIr9jiUzDeQrD7UopceR94i6Neojkhfcw5FZfqGcSzgGFJ0pb26Ih6QL3Q7
         a4Qa0G3jomFox2bhW382FQJ61s6yStZA2SAui0EL6kAVS8oqLK8gFiI68DDHCGVWJ0/5
         P4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HioyY/zbAPIj+crROh/DfoA2KnW7IXNNFbS9q3Mxe14=;
        b=nlIGdr3IvnHWAKQwtHicFdq6Gc8EdZpQghH0HhyOFx85A6TzqU9Tj6mwhn8BZVXECw
         OyBROF+oVqL/Q8SkyGUG3QxJ6ZBP0zWuUu7Ojk0dpLy3Ii00LLrcTEZM9XH4IOYSgIST
         BcdZ2LuU0Q7GjDogbb3wgFjxQIuwRu8hSIjKT1t1F/hoM6015OrvemhzFpKKERwhUY9u
         FkWvJhqG3XO2jMjpCNylQ7XEL3CeTY6fPELjCPQ5OYPZT9Wb2nNBI7oaGtF+ymWV1Xjz
         fLwsYI7IIkPuxg/fpG3N7egiPw+0N0G/Eilp8RLb3J4OZt1pOC+nRbVIDnT1MDYoc/7d
         XQuA==
X-Gm-Message-State: AOAM530kvY3mY47EzvI5xFnpnUl/f1ZrXBYWjfDufqiIYVU2yyNALucn
        PVZutE2OR5FN+F6y856V9/DChxYFrJjWcA==
X-Google-Smtp-Source: ABdhPJzKF08LB6rAEJ3VEi/BcZ9C37d8XKJc7akZr2WoS21HKUPOqq8m+Hp+755di0c7xt7ZpmGhfw==
X-Received: by 2002:a63:7f10:: with SMTP id a16mr13568715pgd.416.1613846033431;
        Sat, 20 Feb 2021 10:33:53 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id js15sm4602193pjb.37.2021.02.20.10.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 10:33:52 -0800 (PST)
Subject: Re: [PATCH v2 0/4] rsrc quiesce fixes/hardening v2
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613844023.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7fe93a5f-085d-9c57-38bf-c7271721bbc3@kernel.dk>
Date:   Sat, 20 Feb 2021 11:33:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613844023.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/21 11:03 AM, Pavel Begunkov wrote:
> v2: concurrent quiesce avoidance (Hao)
>     resurrect-release patch
> 
> Pavel Begunkov (4):
>   io_uring: zero ref_node after killing it
>   io_uring: fix io_rsrc_ref_quiesce races
>   io_uring: keep generic rsrc infra generic
>   io_uring: wait potential ->release() on resurrect
> 
>  fs/io_uring.c | 96 ++++++++++++++++++++++++---------------------------
>  1 file changed, 45 insertions(+), 51 deletions(-)

Thanks, replaced existing series.

-- 
Jens Axboe

