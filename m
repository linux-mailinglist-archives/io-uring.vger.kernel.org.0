Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D3337113
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 12:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhCKLWn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 06:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbhCKLWP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 06:22:15 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59B0C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 03:22:12 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso12953483wma.4
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 03:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zM/Pmjj2xeV+3MDDjmHEROSVY57aoJi4NiEwi63R/3k=;
        b=kPoTPmHNR0zwyVZI7UxNCZHFrGEJyKhAL5pVuoOcFggsSPvDz/OFIb2Fa/Gko2n4g7
         KIRBv+5TrTvxILJOwmvoX8JJ8aAnbICb09gUhlf05LX1rrqHaTIr63Y6S8oE8NC2W0/x
         AlIOwi52/d6aQ9Pskn9tVpH0IF/F13vEO4SZfMztkTOIaStyY4XjE6WtOr7LLEUF68Yv
         pQKmp1eposvQd7yKtAl2Yuh/NeMz31OPW9XiX6FFabidS4F0Ufndx4WccD85N1lqBriQ
         Suy0DNfDXCVfrVf7MIn+zeUKj3hXC/hz4cqKJ8/mHqtWiKE3Fmk55Y0GQT2dvF2R+NdB
         QoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zM/Pmjj2xeV+3MDDjmHEROSVY57aoJi4NiEwi63R/3k=;
        b=VXmEstzPoVPE7iCijz34Uq/Q2FF0M8YkQupEGA9mkiG2YavygmdjjHjfFLUk/PAe8r
         MYEdbjY3XpMvohVRuDfTww+7zS2aMvdCSXNVXXTiif8YxsvdcfSrwouaKmcijW96tX1V
         k43yr7qot1CGeKKwlOe9CVFSMKDF8QcenZaaVy9wZWi3e2/vD3+O/TjouBv4bSuF5QxY
         hOvvwERs13TfHbn7BxjqhUCj/T9ck5c/u+7SzrM1M6wyNhoDfQJvCXsSM6LctqlV9+q1
         f+Et2WumQXxqcCNxBjlh8N5tOif5WraLiy0+XV/8mUoT3hcVSv4WRrcNr0fTNA5zTJvh
         Phdg==
X-Gm-Message-State: AOAM530/XyY2YpxHODhz33pTnexRg7hwBRDgsy3kfV9zYf5S1IEr09UH
        seLL9oyFfbZY1h4FrstKeP8gNj85Rag=
X-Google-Smtp-Source: ABdhPJwjy/7M+2e34DvyKIX+c3lIwIFtZ0XQh9gqQzPi9kQPzcGlurA/tBPQTFFVnGbC20sB/EzW3g==
X-Received: by 2002:a1c:f406:: with SMTP id z6mr7925853wma.24.1615461731272;
        Thu, 11 Mar 2021 03:22:11 -0800 (PST)
Received: from [192.168.8.134] ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id y18sm3192044wrq.61.2021.03.11.03.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 03:22:10 -0800 (PST)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/3] io_uring: fix invalid ctx->sq_thread_idle
Message-ID: <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
Date:   Thu, 11 Mar 2021 11:18:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/03/2021 13:56, Stefan Metzmacher wrote:
> 
> Hi Pavel,
> 
> I wondered about the exact same change this morning, while researching
> the IORING_SETUP_ATTACH_WQ behavior :-)
> 
> It still seems to me that IORING_SETUP_ATTACH_WQ changed over time.
> As you introduced that flag, can you summaries it's behavior (and changes)
> over time (over the releases).

Not sure I remember the story in details, but from the beginning it was
for io-wq sharing only, then it had expanded to SQPOLL as well. Now it's
only about SQPOLL sharing, because of the recent io-wq changes that made
it per-task and shared by default.

In all cases it should be checking the passed in file, that should retain
the old behaviour of failing setup if the flag is set but wq_fd is not valid.

> 
> I'm wondering if ctx->sq_creds is really the only thing we need to take care of.

io-wq is not affected by IORING_SETUP_ATTACH_WQ. It's per-task and mimics
all the resources of the creator (on the moment of io-wq creation). Off
ATTACH_WQ topic, but that's almost matches what it has been before, and
with dropped unshare bit, should be totally same.

Regarding SQPOLL, it was always using resources of the first task, so
those are just reaped of from it, and not only some particular like
mm/files but all of them, like fork does, so should be safer.

Creds are just a special case because of that personality stuff, at least
if we add back iowq unshare handling.

> 
> Do we know about existing users of IORING_SETUP_ATTACH_WQ and their use case?

Have no clue.

> As mm, files and other things may differ now between sqe producer and the sq_thread.

It was always using mm/files of the ctx creator's task, aka ctx->sqo_task,
but right, for the sharing case those may be different b/w ctx, so looks
like a regression to me

-- 
Pavel Begunkov
