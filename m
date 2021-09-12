Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37516407F5F
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhILSYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbhILSYs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:24:48 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A4DC061760
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:23:33 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id j18so9174080ioj.8
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QIVNSqeNUb3QDKP6hyfwTzhoVDIVNB+30w749kRpbQY=;
        b=tahrwqsBTWRAkkAjtoGvfBDAEv6Qsx94OEkkZfr//KNEQezQzyz0h6lInCRswWnmvg
         BuA67Mb1IbpLl28hVuKMy8g+9bSH5DJQwaBSM+Ljlhdzvwf5vx7ibtWvY5vRpZkjw+Rb
         e9Ld14BcE4ZV+kqVCqnjoLdtHd3rmiYaSzNHAFO6PBwEIulTOCl8ZtAkKRj6N07AE+a6
         lo+3Ce8RMz1E3gVZPxZMB8vpqqh9R1vuqRlf0JNY5eAfpvbNpjbAGEBnd/zlQ8Df3lHa
         p2gHxZ2krDwkvp4ZytYhNKUl28ElH956XDlkqfbUOiK5S0zatBs87mZr/iXWo0NyLRXU
         9sOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QIVNSqeNUb3QDKP6hyfwTzhoVDIVNB+30w749kRpbQY=;
        b=gBHosx9glBsW3ttBJO28cTohePw6ciDP8ZAYg+eGRDlMD/xpKOGB43YEhALkqBEFz/
         v18dOT+np/pOsSuwaLHh4uZxC3NVWYVrk3PbcXgyZnqBx3UKov2q3oMez4GxbYqw8Oxz
         2X9pqaKUJ+tMXmDEpGTWQRjzPKxZ/+0lUbiHkT4UrN+UphFXUPW2UYpz81fT3UN7fJoz
         CJqwNlgUCXe1VtExObvaAVkz8ggx7DAazjcOG9AK+kDWpJ14lbyqSZGSIN+xkLJrr16S
         9Vx9Dc3uuRKVvuoBq/kl0w+HWNfDtkBTcO1i9xz5qOe2bCPwXFgZjY5N9AmnItHQKxGM
         ynXQ==
X-Gm-Message-State: AOAM532FpBVBk/EcY921vnLyjUbN/EbifAfv49T9nZ4IyPxCBYTj8m0c
        iirVJeJeakvyHfQDPBp+ay/Chg==
X-Google-Smtp-Source: ABdhPJxY3v8oBNW+YAjOEmFj6CUw/D3cidqqn5YU7iyWw0qcqdlSuy8KbY4W5dzpynAspdNCpgYiYA==
X-Received: by 2002:a05:6638:1926:: with SMTP id p38mr6408858jal.18.1631471013259;
        Sun, 12 Sep 2021 11:23:33 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n2sm3215325ile.86.2021.09.12.11.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:23:32 -0700 (PDT)
Subject: Re: [PATCH 4/4] io-wq: fix potential race of acct->nr_workers
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-5-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53acd463-f132-6f9a-0486-7ea647274b44@kernel.dk>
Date:   Sun, 12 Sep 2021 12:23:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210911194052.28063-5-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 1:40 PM, Hao Xu wrote:
> Given max_worker is 1, and we currently have 1 running and it is
> exiting. There may be race like:
>  io_wqe_enqueue                   worker1
>                                no work there and timeout
>                                unlock(wqe->lock)
>  ->insert work
>                                -->io_worker_exit
>  lock(wqe->lock)
>  ->if(!nr_workers) //it's still 1
>  unlock(wqe->lock)
>     goto run_cancel
>                                   lock(wqe->lock)
>                                   nr_workers--
>                                   ->dec_running
>                                     ->worker creation fails
>                                   unlock(wqe->lock)
> 
> We enqueued one work but there is no workers, causes hung.

This one also looks good, applied.

-- 
Jens Axboe

