Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4AB49BB5B
	for <lists+io-uring@lfdr.de>; Tue, 25 Jan 2022 19:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiAYSfp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jan 2022 13:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiAYSfo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jan 2022 13:35:44 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FE9C06173D
        for <io-uring@vger.kernel.org>; Tue, 25 Jan 2022 10:35:44 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so1796931pjy.1
        for <io-uring@vger.kernel.org>; Tue, 25 Jan 2022 10:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=l7lUxEYolU+vrePYlAdUz/HMspuBnKr+CPn2t+D6Als=;
        b=adDbN80v/yzdqXnlwhZG3lQu7WKIfcd43UuporRcdZ1YPGKtpqXMKQm5lPnUmkHfK9
         GDpAht3amkKBrP7qYMMvXj6cTfUu2snK8ZAl5vys28r3PpApO27dZgnd1uhFDZvrZYWd
         QexX9WrZTVjkgnSNDCK1nC/5idOUOacS0EDbleqhmiADSHze5p6JHos9r+wHATkn8P6o
         ZtTAXy8dzcZrlEe9ykSCDmN1qm4e3G40XonL5l+3KsIO2VUzekWGAhs3Drs3vOTjAJpL
         QfIsGCOVrhvkw3YgHu/y9nmmha2rI2D2JW9juIGPKSJueKv1D/P9oMb72qj9iQjpCm+K
         J+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=l7lUxEYolU+vrePYlAdUz/HMspuBnKr+CPn2t+D6Als=;
        b=U/01JHj88Th9SWrdJ/XkTuLsW2+wpfgFFMmOq2X7exi8SLzfciFNxh+ixj0fPUexQY
         /k2OmI6ChL8CnRWFNAn77WyOzg4DdAvF41vBOdInYn/qOCZvc4ncE0J9nFB1uyxoUA/P
         Y9ZhM0ppFo5QX92efAf2djAsv/pTZj/GJYs0uDA7NPTb3QXAwX28mU/aR0ixZYDTvLMH
         6027qqRjIjNjY3Q033o+wEAu5WYtN0XTH/XFY0HUROif/7AN4PWHcEoFL9b2t5iEsxa+
         X47SWn9deBh698xV7sXTmgI/MssazutoGsGjEvrVR3OoxRpsaa4n+mCcQFDbDp6N2CAE
         aqBQ==
X-Gm-Message-State: AOAM533N3b+FIwGl5WEiAgG3QOhP2yK6V1cYNj5NaSC7wHKSEWbeVpNU
        BXdYYgB2OQgg0ievSQd9Tdq0Hw==
X-Google-Smtp-Source: ABdhPJw2yz0Lh1lxSqIHUG23Q4Ja1K10CXmGKanA/NSaFg52LBMwChb0J9jkka0yAdXUSotlq4JdbQ==
X-Received: by 2002:a17:902:8695:b0:149:cb5d:ddf1 with SMTP id g21-20020a170902869500b00149cb5dddf1mr20526862plo.103.1643135743371;
        Tue, 25 Jan 2022 10:35:43 -0800 (PST)
Received: from [2620:15c:29:204:6f7a:fc02:d37c:a8b0] ([2620:15c:29:204:6f7a:fc02:d37c:a8b0])
        by smtp.gmail.com with ESMTPSA id b9sm20373466pfm.154.2022.01.25.10.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 10:35:42 -0800 (PST)
Date:   Tue, 25 Jan 2022 10:35:42 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Shakeel Butt <shakeelb@google.com>
cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] mm: io_uring: allow oom-killer from io_uring_setup
In-Reply-To: <20220125051736.2981459-1-shakeelb@google.com>
Message-ID: <2bec4db-1533-2d39-77f9-bf613fc262d9@google.com>
References: <20220125051736.2981459-1-shakeelb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 24 Jan 2022, Shakeel Butt wrote:

> On an overcommitted system which is running multiple workloads of
> varying priorities, it is preferred to trigger an oom-killer to kill a
> low priority workload than to let the high priority workload receiving
> ENOMEMs. On our memory overcommitted systems, we are seeing a lot of
> ENOMEMs instead of oom-kills because io_uring_setup callchain is using
> __GFP_NORETRY gfp flag which avoids the oom-killer. Let's remove it and
> allow the oom-killer to kill a lower priority job.
> 

What is the size of the allocations that io_mem_alloc() is doing?

If get_order(size) > PAGE_ALLOC_COSTLY_ORDER, then this will fail even 
without the __GFP_NORETRY.  To make the guarantee that workloads are not 
receiving ENOMEM, it seems like we'd need to guarantee that allocations 
going through io_mem_alloc() are sufficiently small.

(And if we're really serious about it, then even something like a 
BUILD_BUG_ON().)

> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>  fs/io_uring.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e54c4127422e..d9eeb202363c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8928,10 +8928,9 @@ static void io_mem_free(void *ptr)
>  
>  static void *io_mem_alloc(size_t size)
>  {
> -	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
> -				__GFP_NORETRY | __GFP_ACCOUNT;
> +	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
>  
> -	return (void *) __get_free_pages(gfp_flags, get_order(size));
> +	return (void *) __get_free_pages(gfp, get_order(size));
>  }
>  
>  static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
> 
> 
> 
