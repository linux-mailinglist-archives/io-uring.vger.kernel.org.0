Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10AA1C60F0
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 21:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEETSd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 15:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEETSc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 15:18:32 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FB8C061A0F
        for <io-uring@vger.kernel.org>; Tue,  5 May 2020 12:18:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id a4so1511119pgc.0
        for <io-uring@vger.kernel.org>; Tue, 05 May 2020 12:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/kEC787mKQxNi0qbvwmAl11V6a/lzRflpysQCy52p50=;
        b=MT0IhGetGkZ6JHol3/7Wjd1M58j+cUubWWzRSx/WKiWIecHXqAQgD3uTNgnVGYulg6
         XQLFwjWuUkZpxBt2F1QyQq2hGIoxnp88j8qn+qMT1bEwW1iKk2N9t+sZ38PKgLqLSOwJ
         CoIG+cvgVKVny7+qFCCaphmBdvFYrVwSyCshKJR90Bl0N0lMHeVVOYBGXHHIeZQVLZSZ
         tlr4M//56yd3/F5r+2M8emO+je9/U3WmpydpuuDqxJwic8AgHv2MuK86hll/U14iROnC
         zlk2Q/ZVkmCxBVooO5jrnH7HbLmFIDzPHM5UOe9aC3VVSY8wzCnBncZink1DNUuSRtzz
         b0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/kEC787mKQxNi0qbvwmAl11V6a/lzRflpysQCy52p50=;
        b=C7hAGb7qC0dI1BMF8QbtEqpnn2r6c5Ht9aNIX4kRmwFZQHWLb/8xUfb+hqENqQRIr6
         C3i+nWR5H20gH7zBUL0t4+B4UYVhrkt2qVVIXn+eWrezEiJuzih5P9ZDfM/tih5S0X9n
         7fD5/p3AOpTjKxUVjlcajepOXmSd4KTQ0AUJQwf1xNN36zOp1wSnJ44gtidlCvAGORKS
         awUcxsHNGd1ouHqaKZ29pN25glQisbjqb95CxzyvioSg1h4nnkFeSfZNbL1u3XHOsC3b
         mEdQKsgzAOswfXzvUrEx7CV1jBKVA0OrdP7GklICAX4JW8PHUJKqVIzBqgqZdbu9ALnV
         hY5A==
X-Gm-Message-State: AGi0PubQz26nN6j1xR7akgzEW4BXTMQCulHcPERZq3yQibEikyODtQOk
        WPvA7TuBEY5uPOFadu60qpqBSEDmfUaupA==
X-Google-Smtp-Source: APiQypJyUasmwHoYhmSXlLa6NTOHKG+shKnnpG++uy4k8792w4gvAw6thVKd+TK/O/eMime4O+JQWQ==
X-Received: by 2002:a62:1c89:: with SMTP id c131mr4295647pfc.164.1588706312040;
        Tue, 05 May 2020 12:18:32 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u3sm2625149pfn.217.2020.05.05.12.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 12:18:31 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: handle -EFAULT properly in io_uring_setup()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200505082853.28411-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d800138c-4e25-e429-ffe2-5fcf5277185d@kernel.dk>
Date:   Tue, 5 May 2020 13:18:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505082853.28411-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/20 2:28 AM, Xiaoguang Wang wrote:
> If copy_to_user() in io_uring_setup() failed, we'll leak many kernel
> resources, which will be recycled until process terminates. This bug
> can be reproduced by using mprotect to set params to PROT_READ. To fix
> this issue, refactor io_uring_create() a bit to add a new 'struct
> io_uring_params __user *params' parameter and move the copy_to_user()
> in io_uring_setup() to io_uring_setup(), if copy_to_user() failed,
> we can free kernel resource properly.

Applied, thanks!

-- 
Jens Axboe

