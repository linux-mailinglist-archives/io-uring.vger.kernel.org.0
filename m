Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8113B32A5
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 17:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFXPhk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 11:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhFXPhk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 11:37:40 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB16C061574
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 08:35:20 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u11so7792174oiv.1
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 08:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yWsZrTmRzTgQ9b87Csr3yrt/5ftwonP3bLq7eEMOCME=;
        b=Wjm7W30YGrtlpG/K0jnKqEcToSMr9zlzzgq5kjB4IqQYuULU5Nr33llyOGL6bhRLKB
         g0El42M+58f2DwSpkhGab9yIMbNcCntCyyfPS8s9u0HCdbsQvFXuL3Va+t2wRRFbFepT
         6XxjWVHVbJW3Ey3Cy6ZLknG9HzYnNxeRBUOJEg56NeiIku8eWHCRZ8kGP3EXFLLucTwa
         3jEuJ3ddgSuRYw4eU4eCYX4k8T14S4C7fBKm/GrAtliV/sKIqKRBn5MrsMeb2O9BTQy3
         vmlRmn6pO+UkPHLZDJeqYhgV9pBd8OVYKyYjbXhcrL+/pKwep3WBPd3cpbtt6XMxv6fC
         x98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yWsZrTmRzTgQ9b87Csr3yrt/5ftwonP3bLq7eEMOCME=;
        b=tT3Nc4cEF5TUb0Wfgd8fZokH3AkECK21OPQwqZvPQke3f1ywfvRjQwV9DhjZwU+g81
         t7V+/A7gZ0oOMrjy9QU1r5X7ScZtmgkbNYmRcDxqDsx4+kDpWL5ig55qEnMV3vRuODfX
         vuGWuZV4MG3zRdZsyKaBGasqW/GeY6OSz+QQPlyqjrxk/fG+43geqCNrcnYYJymH1zWI
         ZjW+Qlr00FnzYV+CmzjzcMPgzEncgpOcNgLZ6kDqwtX9Of4yDIcG9xKIIWc9+utayDC5
         VVCke/UNbYBI98HfmE6s2LYDeSJTIUXvpdApd/qybHbHzMrCKV5wXLvxJeVXEKAK95NO
         GhvA==
X-Gm-Message-State: AOAM533WoTJfY0MRLEnuoFiPY9E+zWuacuytG1HVL9FtXlyenvPphDqT
        nhwwU7tLGqSIgL5cM4koW40ZQVXMbluftQ==
X-Google-Smtp-Source: ABdhPJxoALNrtNV84H3MN/gycTMfTm15KqD4457B2gRiZNR8u5dYyQqkS0XJHuxwSUPt7UFx2UlEMw==
X-Received: by 2002:a05:6808:1393:: with SMTP id c19mr4350473oiw.131.1624548919113;
        Thu, 24 Jun 2021 08:35:19 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id r1sm750610oth.19.2021.06.24.08.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 08:35:18 -0700 (PDT)
Subject: Re: [PATCH for-next 0/6] straightforward for-next cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1624543113.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6f96bb09-6056-774f-6b28-986d309099ae@kernel.dk>
Date:   Thu, 24 Jun 2021 09:35:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1624543113.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/24/21 8:09 AM, Pavel Begunkov wrote:
> On top of 5.14 + mkdir v6 and friends.
> 
> A bunch of small not related b/w each other cleanups.
> 
> Pavel Begunkov (6):
>   io_uring: don't change sqpoll creds if not needed
>   io_uring: refactor io_sq_thread()
>   io_uring: fix code style problems
>   io_uring: update sqe layout build checks
>   io_uring: simplify struct io_uring_sqe layout
>   io_uring: refactor io_openat2()
> 
>  fs/io_uring.c                 | 67 ++++++++++++++++++-----------------
>  include/uapi/linux/io_uring.h | 24 ++++++-------
>  2 files changed, 44 insertions(+), 47 deletions(-)

LGTM, applied, thanks.

-- 
Jens Axboe

