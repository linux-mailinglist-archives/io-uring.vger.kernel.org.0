Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B931716D
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 21:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhBJUbk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 15:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbhBJUba (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 15:31:30 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC15C061786
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 12:30:49 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id m6so2061385pfk.1
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 12:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/lRGGIajraTc6NfibNVU0/W7E6hXpE6eI6sQ2gu4U6o=;
        b=i22b7dpySVNtkZp9FncVx3Dq9bsI17cBjPBU+cxpoT6oQIZO1K84B7USO0vUh8ffX8
         pjMDef7QLzopIWi8fZBr7WBMLAzVE5D2VV2JKkWVAJhVeRKdMXyemtk8ITGRAjI1WbgB
         e6lmdUjzqCRec0WWYMpUkmc02qt8N1DRwG7F7q3aK6Tgf+IAhnWTehhYQ4HpbnWB8qee
         TAQpS0e7zjZT0hOVK4QJ3eOo5WWLeP4UKjeDb2Y53ZeWXm66DdoocFsKsPhf9uy6XzxI
         Kh/uGsDx8LNkJnqD0vvLe3j3ef43bs/+rplukrVPwrGfMnphAEahnDXyeoIZku1MjwYK
         OujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/lRGGIajraTc6NfibNVU0/W7E6hXpE6eI6sQ2gu4U6o=;
        b=XS1F5awoLCJwlU/ddAzlINy3zE3V4AOEyj4iWg+ds8+vlZly4I6kZ7as/e4PKtsdSv
         9RVG8CdoL2mer8F5mNBn3KUPiJn0YkJ7rEh+v5fMAeUGRl2gyDz9RtKBF4Sc5Jtb84b5
         dEp4lBz7hGkDoGDpqliS4NsS79nlO+giOc4nGNWFvpqrdGorD8viyBvh4Xf8teyF0Yrx
         TvKpRuBhHG1YJLMM2x+jzAZDR7yDERIajkONjosAX1qiWrbMUKIRNuqMaezgR7mAAIfN
         mjjk+V9wcYYHfmCcsK2pC/CwQOvkPogUpI+xn2xKaAFLseuKu87ksF2DzPjLrW8rRuZz
         J4FA==
X-Gm-Message-State: AOAM531xTD1Ft5nRcdv8lK/fZl5YrEbSFSpWyNN37XabzHV4WUCwqZc0
        Mh9nCQmrOWA/CMT+ALbp/JFpB2hcwyepnA==
X-Google-Smtp-Source: ABdhPJz0HYu1TnfjHM0F2jnLa1z9x4q5aGLCJpd/kEOEMknObNPISTQH80KOwPbvbZvaGtdZA/iPuQ==
X-Received: by 2002:a62:1995:0:b029:1c0:c4d8:adcb with SMTP id 143-20020a6219950000b02901c0c4d8adcbmr4721403pfz.60.1612989048593;
        Wed, 10 Feb 2021 12:30:48 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21c1::194c? ([2620:10d:c090:400::5:a5c1])
        by smtp.gmail.com with ESMTPSA id h15sm3199352pfo.193.2021.02.10.12.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 12:30:48 -0800 (PST)
Subject: Re: [PATCH 0/2] SQPOLL cancel files fix
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612957420.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5d8e20d9-ddf8-a327-1d5e-3cc9b00e8113@kernel.dk>
Date:   Wed, 10 Feb 2021 13:30:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1612957420.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/21 4:45 AM, Pavel Begunkov wrote:
> 2/2 is for the recent syzbot report. Quick and dirty, but easy to
> backport. I plan to restructure (and clean) task vs files cancel later.
> 
> Pavel Begunkov (2):
>   io_uring: cancel files inflight counting
>   io_uring; fix files cancel hangs
> 
>  fs/io_uring.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)

Applied 2/2 for now, thanks.

-- 
Jens Axboe

