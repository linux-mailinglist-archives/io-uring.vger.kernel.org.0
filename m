Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C61F33406E
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 15:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCJOjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 09:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhCJOjA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 09:39:00 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307C7C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:39:00 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id i18so15698930ilq.13
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QJ0ukPgtz5TGY3PRDSVFM4IEPAIswm+7bTJV7Hz3sHs=;
        b=NOSnV8ITw/9ezc1c6Xz5Z+1LEWXiDOZWLf4KyvHtbcQy1jbAYfa8KekI+YpyZC8Jem
         w9inm/AePVFxtZOPEKmYxtADg0RLjSkpbt7uOcXQgqasfUZiUNWiK7EiQZZ7RcpKV8M4
         ZCzVTsJX8pBZJlPGr1AtYmJ+tqEzndgo+XqjDvgaXQaHlM70m+VZ8yBxWn1Df1hweADe
         kWtFtuWSW93TtTl3vo6grJmgFUmHVpdGnGhMRYybCcmAKL5E56E0ve0GsCE01Qxk/5V7
         SFi7h82ADt2GKTB9O9V1GXVfW7CMaFaB/Bdzcl2rBZzo0H6bWHya9beZHFotuPTskSLP
         tCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJ0ukPgtz5TGY3PRDSVFM4IEPAIswm+7bTJV7Hz3sHs=;
        b=eSCaolOSvG/MRV9gJj73P+IZUJWvG28xU/cAZSXn81oj25NuWU5wsubMq/PkCT3D+h
         BAz7zq8EuTlVQ8YtpqWAzaOgFrXbvgxXLEJPqNRwOq6bexFmLMSu7+k+LkGILlJGMIRt
         Pbw/4ooCnM+GctSeDWMlirVt3yvFKAakqf3GmgC0Q/mEXkCUYMa44ax6153fV8cDcwIP
         AEnpScjIk+p43HH6mSLhI1QN5/Fib29HHfHOmY6ie9lW+Fq6LHb4x4yw5s1sc19jjp0s
         ILt9osCylOaPDHJDqoJbxvDoQGQk9MyIio8glI23LNpUyr+KJQTZdP7w+nFlnE/CIH7E
         LxjA==
X-Gm-Message-State: AOAM53215OzVr+Top7Ha88M7swZSPc4MyS7F+RQ2cgeH1G8Se50W5QrN
        S7erxc1nu7JFoNZGZCjYkUX8CG/fPLbrVQ==
X-Google-Smtp-Source: ABdhPJymqki3C9FkA+URtqO4u6sxmFC9qC1n2oCPYoMCAiB82j52fTb4KU2+EuQom4kU8tIDQ7M5IQ==
X-Received: by 2002:a05:6e02:13a6:: with SMTP id h6mr2968114ilo.10.1615387139423;
        Wed, 10 Mar 2021 06:38:59 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t9sm9402594iln.61.2021.03.10.06.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:38:59 -0800 (PST)
Subject: Re: [PATCH 5.12 0/3] sqpoll fixes/cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <065ae599-f2ee-9aa4-c77c-5c3527152e2a@kernel.dk>
Date:   Wed, 10 Mar 2021 07:38:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615381765.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/21 6:13 AM, Pavel Begunkov wrote:
> All can go 5.12, but 1/3 is must have, 2/3 is much preferred to land
> 5.12. 3/3 is meh.
> 
> Pavel Begunkov (3):
>   io_uring: fix invalid ctx->sq_thread_idle
>   io_uring: remove indirect ctx into sqo injection
>   io_uring: simplify io_sqd_update_thread_idle()
> 
>  fs/io_uring.c | 41 ++++++++---------------------------------
>  1 file changed, 8 insertions(+), 33 deletions(-)

Thanks, added 1+2 for 5.12, and 3 for 5.13.

-- 
Jens Axboe

