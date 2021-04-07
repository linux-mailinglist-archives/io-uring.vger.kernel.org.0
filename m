Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966063570F1
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 17:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353845AbhDGPuK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 11:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353979AbhDGPtw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 11:49:52 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BABC06175F
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 08:49:42 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f29so10915298pgm.8
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 08:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EpfFOmh/8CqD+x0HpoxtJuTwJ5ogyZIAg5ckuy4Bd04=;
        b=teAoYhjNhnySarkPIzbo3tQhvwV1GIIhRUtYzblt4FBW2LS/QIVYMIhI4gsrccqB2a
         TJ1bvH33CAp0z2WkEV3+sFst+QbG9fPpAG+etI7iivKt2op3fcSesbn5SyrjfxMEeHlb
         rrQfZtJfFSyKVVnzbhqRLgNxSLO1zIKwuWbrt50L7EK2pCl5AU9Hd/ohpEiRJjbJ7V5o
         s4zzgDjy96a2enHb3RQ+Qzb05oJ389C9cevc+XDbZ08jnvfvrJOe+Um9XOfkwL8wzszo
         IoPt+FpdOiao0NDYfafTFblZ920SL4g2YqN+5hH5s/TDo0WazRPpqS+WjoZh6QcGFx9v
         kmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EpfFOmh/8CqD+x0HpoxtJuTwJ5ogyZIAg5ckuy4Bd04=;
        b=Vz6A3ERhd2s9X2BRQ6RJ3dOV+/57D9Dng9mWfS7Qrv/hgxyILZRZrHVEkTZx3XwXXj
         PpIQwjkEj3exWmiZHmekUB14dUJIcF48F6gIKWIiXYViFeS32PZzpa7AbZT5dpnFbjbG
         knFnQ5PkNXNwrM51IA9jQWOFsD0i0Ib9DeEG6P3JqdnLu0WNIoLjemI3aMXlLBVmX8jQ
         CI2yZfSSKt08SgocQoz4Qea8rEVrJh9P4vLo3ZXawJYDiiNmfwNbeVN3CJ5a2Ms+/Rp+
         F2SWpWmdn+AXKYFakX+2qTR8ETsso/FDtht/0op2hxHZult6vFD9L96TY1Za4/VALHsv
         9unQ==
X-Gm-Message-State: AOAM531xbe1AJzbr+ZTZY8ESAxekFULh9XrKdIRumFxlEtpXYWVwl05F
        H/7c6vo/lue2gzsjz+H0fEfef98jPreLYQ==
X-Google-Smtp-Source: ABdhPJzuVmIv6tfGf3H04RA0aKAiHw/Cmbo3lNdWiosgQCDpSWwxXUYiy7XRVyVPgCkHnSk1VPchwQ==
X-Received: by 2002:a05:6a00:2da:b029:202:7800:567 with SMTP id b26-20020a056a0002dab029020278000567mr3236588pft.71.1617810581796;
        Wed, 07 Apr 2021 08:49:41 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w3sm5515778pjg.7.2021.04.07.08.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 08:49:41 -0700 (PDT)
Subject: Re: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
Date:   Wed, 7 Apr 2021 09:49:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/21 5:23 AM, Hao Xu wrote:
> more tests comming, send this out first for comments.
> 
> Hao Xu (3):
>   io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
>   io_uring: maintain drain logic for multishot requests
>   io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
> 
>  fs/io_uring.c                 | 34 +++++++++++++++++++++++++++++-----
>  include/uapi/linux/io_uring.h |  8 +++-----
>  2 files changed, 32 insertions(+), 10 deletions(-)

Let's do the simple cq_extra first. I don't see a huge need to add an
IOSQE flag for this, probably best to just keep this on a per opcode
basis for now, which also then limits the code path to just touching
poll for now, as nothing else supports multishot CQEs at this point.

-- 
Jens Axboe

