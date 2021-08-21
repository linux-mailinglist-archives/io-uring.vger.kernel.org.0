Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDB83F3AC1
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 15:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhHUNUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 09:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbhHUNTf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 09:19:35 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EF5C061575
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 06:18:56 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id y18so210850ioc.1
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 06:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=V8Tug0Lx4Vi7W+IVCKLW7gSEzqTp4vzgkZJsx4Gx51U=;
        b=exUIIMht/DP25KZeuHNw4Ih0xUuKtFE1x1p8QwXGMS+diEyIQhF6tO1iE9DQBlW0vt
         JnS0gIQXlmmTpnVWQjMJ8g3OTMPfeSmL8dfh+Orb0Jw2lAJS6B0FxkBnMnTdAaiHZsQe
         CdzUZk8LYi2no6SdWYbe61uqEJQfuSDVLRwvxwwYQGyxCT1fxyGFPnJSlpNNWd4lAeE2
         DSZ5rtCT9bZhWEVw0m1tZ7cKwv2mbzhX5z6HZMo9DusoCwaP3m4CDhT9Ds9l8/A70UOS
         7DQq+sYiBg6+oW9zprNUasV0ITm62fKHtu+alHb8iauSiDKnAUu5tnoW7+OHvtDrh+qs
         ktPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V8Tug0Lx4Vi7W+IVCKLW7gSEzqTp4vzgkZJsx4Gx51U=;
        b=lwM9MqF6NAa2yrsfEqiL+aKvlIeZAyHZjxqiSq1p2B8YQ5qcgNSjRuE48qzalZCS39
         R9ZwxP1g+CAdz9HO4Kz0HXQUoEHkSRhgURjkDEcMSXouvlpVeDATOFUpwvEXKYjLDi6s
         Fuopobv40V74Ub9ctmBW8P0Cgw1/IeTPVHtq5HfN/WvF51QgDhFfFKoytK0Z5EKMrJs/
         hZV5XMz1OCTTRQQUtroSLhqHZqMwC5uUWH5HCTAIKr6TdwlZVeCRGgKbqgf97088eHPw
         hW3UNzZUn1Yo8gdWQ2Or1Li2vnJpeIaAZpIEtNQfBjaBnAimXL7hXN8YIlwL4DJnBDg7
         KaKw==
X-Gm-Message-State: AOAM533jQWo/6yeWQKtRxm13ze9aZlRzLZN6UNLx1JOAwiUOyQDTk6O4
        dDIOOOD5FRquGZr1TeDXcQxnfesK6ee7weSO
X-Google-Smtp-Source: ABdhPJxj4EJzJYER+clb97M80OIQm6e9rd+N433tyjX6zsyRJZO1IODu1voKWTOOBcYQ/5zYCsr+UQ==
X-Received: by 2002:a02:cb05:: with SMTP id j5mr22334708jap.94.1629551935488;
        Sat, 21 Aug 2021 06:18:55 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t15sm5030268iog.26.2021.08.21.06.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 06:18:55 -0700 (PDT)
Subject: Re: [PATCH 0/3] changes around fixed rsrc
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629451684.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1929aac2-14ca-789e-fe6f-faebd858abb4@kernel.dk>
Date:   Sat, 21 Aug 2021 07:18:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629451684.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 3:36 AM, Pavel Begunkov wrote:
> 1-2 put some limits on the fixed file tables sizes, files and
> buffers.
> 
> 3/3 adds compatibility checks for ->splice_fd_in, for all requests
> buy rw and some others, see the patch message.
> 
> All based on 5.15 and merked stable, looks to me as the best way.
> 
> Pavel Begunkov (3):
>   io_uring: limit fixed table size by RLIMIT_NOFILE
>   io_uring: place fixed tables under memcg limits
>   io_uring: add ->splice_fd_in checks
> 
>  fs/io_uring.c | 61 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 25 deletions(-)

Applied - especially 3/3 will be a bit of a stable pain. Nothing difficult,
just needs attention for each version...

-- 
Jens Axboe

