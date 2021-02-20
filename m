Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48F032023C
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 01:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBTA3l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 19:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBTA3k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 19:29:40 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69DCC061221
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 16:28:45 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id t11so6238340pgu.8
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 16:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kT2kE803nTH/o5x5uN2IT13c/TKzi4P9HlbUULtB0SY=;
        b=uwcZ12EIRIGfrtn1IDQOCaOGNiN9UKPyzTGd5GqllbWU3HvaljAX2Rd4Ji6MFC8rm0
         +yAw5YxYMULjvgmM0QHFHBSNneROvv3Ik/Jrr1+NL3OLd8L8qzWYvyboZpxqyaD0QrXc
         1KUZ/XdA476iIQTSusZXl5p8stM/O1Xc/aPI+7dMQtAE5HHzRf8TizGDCqx2quLWuWL1
         A+YkFwD3kYIECEy0d4cw+uZzkRN5nxlv+Q+fkznGjEA6a+I6DPAzU/0xrIcrB6IojL4z
         g1DWY2t3tDwsBOrO8PRgxVrJTAW8PS12G4Te6cKoYIuKnR3gWdL+gDFgRz2mEry47Fg0
         Bs4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kT2kE803nTH/o5x5uN2IT13c/TKzi4P9HlbUULtB0SY=;
        b=GAgFjQAdiIqG1Xaj3/HQDn65Ksqwxq5eDVeaSYsV4nMhd4rwST0AlZrz0Zej45KgQG
         01MYMnrqW8s6MNg0IYYq/oKWvOjQ65dHmeUPYh2ub4zWbh0L1oJKKXfx7qYgys9Cy6NL
         8T4Ar+hzRlH71So2jrEt884QVyu0hL3FJoZ74C1bAaGikOHMRx5AEsyIIw9I+ETQr7ft
         +QUJRQ0fJ8401lQ2/Fy2Ap3dtFmBqWk3jSaxASqpQQSpDhHTbod7Dj0g6P2EMCbOr+7E
         NX3ihTooCku+sx+osRk7VAnwgAkkObNeRmqfGHl8XJvyVi++pTprPls0qF4IIQnBUiFM
         SJow==
X-Gm-Message-State: AOAM530QLQ8Lb/DaCb+ntEaYgE+gXm0a7ja658gLPZmudlYIthZpIf6v
        kuy56QXdPfE2vPFxRHbtMuNwtayne6SGkQ==
X-Google-Smtp-Source: ABdhPJykGa5PpA2taXbVzK/xHNzFjqX/fMkkNKWgVIR0gN1SwvcNiW4IBLMrrCkWeyltFI48peHujg==
X-Received: by 2002:a63:1c08:: with SMTP id c8mr10603768pgc.228.1613780924838;
        Fri, 19 Feb 2021 16:28:44 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u15sm10620310pfm.130.2021.02.19.16.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 16:28:44 -0800 (PST)
Subject: Re: [PATCH 0/3] rsrc quiesce fixes/hardening
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613767375.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9fa77894-8213-af7d-8b9d-8aa29dfe54ee@kernel.dk>
Date:   Fri, 19 Feb 2021 17:28:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613767375.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 1:45 PM, Pavel Begunkov wrote:
> 1/3 addresses new races in io_rsrc_ref_quiesce(), others are hardenings.
> 
> Pavel Begunkov (3):
>   io_uring: zero ref_node after killing it
>   io_uring: fix io_rsrc_ref_quiesce races
>   io_uring: keep generic rsrc infra generic
> 
>  fs/io_uring.c | 65 +++++++++++++++++----------------------------------
>  1 file changed, 21 insertions(+), 44 deletions(-)

Looks (and tests) good to me, applied.

-- 
Jens Axboe

