Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42CB3B22E1
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 00:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWWE6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 18:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWWE5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 18:04:57 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D54BC061574;
        Wed, 23 Jun 2021 15:02:38 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m18so4303797wrv.2;
        Wed, 23 Jun 2021 15:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=du/+9bci9BS1zxPiO5bZhcvo8DRuSdwuL5QAgI4buTI=;
        b=pfmCYYJ18anm5/1Y5MeQ7PEl0yrPZ+ANXlgkmEuViWHPOQlbwj7QNCE4CP6M/BT/Mc
         Nq9x9eN/BxTxohygov9RWOgv2jp4biRPitzbBku+fVqS0sfklkzDm0alpTOL56LhDh4n
         wHX6jcc22rDU3ysV1MFYon1IX2N0ooi0hpn5+0TzUzzQbDN/3ggg2fCiT2s/fGrjKud3
         2MG4kP/m9e3iosFP+hAeJzvYPLv/LZ+DaENihkt/RbHaiodt7aeQWOdm2CgeQhZbWRwm
         o6gL57ordpwIqrwVLkJuUfgh1fqQcMg1Y+Fb8KxPWrSL8vdand5xAkglqmAeAgX+K1df
         oSEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=du/+9bci9BS1zxPiO5bZhcvo8DRuSdwuL5QAgI4buTI=;
        b=hiktt6zwfDXIyXRDgVedW3Y2+WFUBOwGq1/vSihTP8kwM/Uqc+2SXRSjHi73aI499C
         nyQmlpJbPrTlGo8CDQSuQGkmF5PU6qUqnduyicUVk0rbwWgnEahrGA+r6PqzbWtgNO3w
         SpQuMPAdfwUVOHBxFSY+l1FeJsKONsRDc5txJl68H8R27REq5nVBxxg3yStl/hxSi7+5
         5J/HURvUzEZwb3vCav7L1y5kCNk+6s3lptQ6e5Z4ZPdWQ3XkIe45IHfC2fyelxrbFIt2
         34hZ8euA1Yq7lm/PymgOMQ++ith/ycrmEFgbTbVaSkW2NAY04qLq92V+ULNncjWWb1/L
         6D5Q==
X-Gm-Message-State: AOAM532Lvg+zdDbzNQBszTIFTtCbbJuMIKTynjpY5qd9R5tiWZm+1w6H
        BLj3DL6KEDhKZMPlK8b2za0AljnzX09WeeDj
X-Google-Smtp-Source: ABdhPJydcjVEBq9H3dvdvryL7wL9RQ3Alx2d7OhAr8VUAqFTffjN08PBA+7H1w7dbRIpx5FsdgFieQ==
X-Received: by 2002:a5d:45c5:: with SMTP id b5mr316612wrs.221.1624485756956;
        Wed, 23 Jun 2021 15:02:36 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id p20sm1028853wma.19.2021.06.23.15.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 15:02:36 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] io_uring: Fix race condition when sqp thread goes
 to sleep
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1624473200.git.olivier@trillion01.com>
 <d1419dc32ec6a97b453bee34dc03fa6a02797142.1624473200.git.olivier@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <876d12ba-b71c-ba49-342e-6ad59b8dea15@gmail.com>
Date:   Wed, 23 Jun 2021 23:02:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d1419dc32ec6a97b453bee34dc03fa6a02797142.1624473200.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 7:50 PM, Olivier Langlois wrote:
> If an asynchronous completion happens before the task is preparing
> itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
> will not wake up the sqp thread.

Looks good, the bug should be pretty old.

Cc: stable@vger.kernel.org
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fc8637f591a6..7c545fa66f31 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6902,7 +6902,7 @@ static int io_sq_thread(void *data)
>  		}
>  
>  		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
> -		if (!io_sqd_events_pending(sqd)) {
> +		if (!io_sqd_events_pending(sqd) && !io_run_task_work()) {
>  			needs_sched = true;
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>  				io_ring_set_wakeup_flag(ctx);
> 

-- 
Pavel Begunkov
