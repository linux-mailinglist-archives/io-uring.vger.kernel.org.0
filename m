Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B594930515F
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbhA0EpZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404885AbhA0BaH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 20:30:07 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5E2C061574
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:22:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id n10so439102pgl.10
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=73Vz2cUm5dcJXTSpJc8l2ePNJ5YahQUrOWL0TUL/Zt0=;
        b=FUXfYZioyQVQDXplFIgSInhASGk4ggPhN7bxzl1BXFLfUgP/NSWFxtvkV6vndyhQDZ
         CQ9IwdsNNlJBsOsz+EkOYAv9IES2xAa/qc548RAqVXavBG47DoQy4yLdQIYokxn3UV49
         ixK+mmu60rgVeKt+YnuPZTu4xo0sEajHMa/cnp53HWoa3ADnP65HLBUUoU5lBb4d1Lg7
         miFLP01OrcitXa/NvR9IjZrEj4d7zrB0DLPs0rUECJP38kkC/BqVr4wqJiizBdhOZtTT
         Z56qf7jFjFBSOFylaryEu8ti+EKFi03Ot5zPK+KpfgNg8E8Rh5ssGXRIYB5CdseyYGiZ
         owEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73Vz2cUm5dcJXTSpJc8l2ePNJ5YahQUrOWL0TUL/Zt0=;
        b=CS3bTL4L3QcVbh+AOzd+ZUlo8wIP9bsX85V3ynnS8dx2+SZ6Q6tqhUJlzTYMv7ZwzO
         7U07GCHQ0N3k1qp1lJTjTaiZD/FMYN2GK2yAo/K8brg7m0kqRTpAXoCbG3ViEhABupLw
         WLM0twi0t9SN1VXzPYuB79JLOA19j4WlKAuriTG/wHukG2gvetRkCT4zhKODmWeCSQeB
         stvQTiBzNq1B+NNVtM2HUgWSiEMLorM7MTX71nDG1rrFzLjXph1xIj0lxegVvS0RAdXO
         tWmS3t/FbsIAxwr1tqRg6iJTui5bKjKS08HazWfnWo2g5Wv+HuEwWP+tJt8aawzuYom1
         V/Vg==
X-Gm-Message-State: AOAM533ryJeFJb5mTF1INrquf8sdA8LgX6u+VInaLicXxhXs7Uwd/g4F
        ASqhGz+poAbJk0T1iNgQXtkM+7eKfYG1tQ==
X-Google-Smtp-Source: ABdhPJymEjW3BIwtoXO0czWDpb+PRak+5Hp0gIurtegiqJWaGTthDpeRPea+7Ub18/eZ2x3K+0DRJQ==
X-Received: by 2002:a65:458e:: with SMTP id o14mr8404152pgq.444.1611710534756;
        Tue, 26 Jan 2021 17:22:14 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i67sm290539pfc.153.2021.01.26.17.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 17:22:14 -0800 (PST)
Subject: Re: [PATCH] MAINTAINERS: update io_uring section
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <4f7860f785c308d7341302b70a0e8a975586f611.1611710197.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <706b0b40-4c3d-67d4-7f40-ea74d2e14558@kernel.dk>
Date:   Tue, 26 Jan 2021 18:22:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4f7860f785c308d7341302b70a0e8a975586f611.1611710197.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/21 6:17 PM, Pavel Begunkov wrote:
> - add a missing file
> - add a reviewer
> - don't spam fsdevel
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 992fe3b0900a..f3accf0f63f9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6858,6 +6858,7 @@ M:	Alexander Viro <viro@zeniv.linux.org.uk>
>  L:	linux-fsdevel@vger.kernel.org
>  S:	Maintained
>  F:	fs/*
> +X:	fs/io_uring.c
>  F:	include/linux/fs.h
>  F:	include/linux/fs_types.h
>  F:	include/uapi/linux/fs.h

We should include fs/io-wq.[ch] as well.

-- 
Jens Axboe

