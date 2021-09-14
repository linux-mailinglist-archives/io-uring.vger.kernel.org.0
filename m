Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6C040B339
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 17:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhINPhi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbhINPhi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 11:37:38 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF555C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:36:20 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b10so17638644ioq.9
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C9KjrGTjtEKa5zyiW78rJOVO9vcDQas0j4TSzQbeysA=;
        b=LkL62gXWIBRTW2gJuZu7So3rXqAN2rOy0gWVQe9iBL1kZW6HhijCSSEU02RlcAC19i
         g5/0xV0CavKSFnpTGStBDEM+3RoLvLgfec4mmriHyHww15Q/PB7QV+ge20T9FJHjrh3h
         dMIdLjykgdyOPNAk1gkMgPktI9QgI4b4ETxeY36zSCaeXYZQ6XQRtEotlc8dRlomZI2F
         eVz5d4n0TVXvZKxmcfu/UvY6pAa93mJZfqmXFIT44vdbmCXPQQYEKh6305MwjcKDGEuX
         kYvo7WPNA6nKsYN48u6yioRDX3CTgkDW89AhIMcczqo9WLkxVnUqjXp5ciqxcbeFuPDu
         SYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C9KjrGTjtEKa5zyiW78rJOVO9vcDQas0j4TSzQbeysA=;
        b=pLQC4axAi2UpMQRpDu346TpGt145BZrl8ua8vQtBf+HBZ7IJBl0Rc1blb9C1BvA3nK
         1f4wjrj6mZijjfbowPNl5Z8miE+YyNsDubt+vCWW+vzqSID063Y2YW7Hiytu69QQRR0Y
         92xIeD71j95toI6jEoSD/TxA8Ak1f1ZxxHO5xjaoy+NUk7tnvYmevDE2Y/hpuVOQp/LT
         VvrWTxlm0miHHXsDZgoKjKXW2JV8ySO5Qku1DtU3ieN0n8e9wDZ1M3uU/Ig7qpHYRreQ
         XtxCMnhWuQuJLe8d2+HimEdHZ2xYYUcjAVDPkhNgzOrr6w98gtJqzzyyrW3NxqJ7wQoE
         KTnA==
X-Gm-Message-State: AOAM532dBgmLMn041lCu1Gej84TIFkMrGe/yHGPL1FJHGn/tvwIGWSbq
        atUOvHC09uC2fq15vMypH3ZbmA==
X-Google-Smtp-Source: ABdhPJzS1zL+VJn0O/h6bPEMqM7fuFduvVbPI1o1/Giglyi3sQ/bfMI/QkKjiKq+uJ24PHzMCaqycw==
X-Received: by 2002:a05:6638:35ac:: with SMTP id v44mr5275304jal.48.1631633780106;
        Tue, 14 Sep 2021 08:36:20 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id ay26sm4899966iob.9.2021.09.14.08.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 08:36:19 -0700 (PDT)
Subject: Re: [PATCH v2 5.15] io_uring: auto-removal for direct open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <997aadc0-0b8d-e42b-242d-670cccd0b59c@kernel.dk>
Date:   Tue, 14 Sep 2021 09:36:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 9:12 AM, Pavel Begunkov wrote:
> It might be inconvenient that direct open/accept deviates from the
> update semantics and fails if the slot is taken instead of removing a
> file sitting there. Implement this auto-removal.
> 
> Note that removal might need to allocate and so may fail. However, if an
> empty slot is specified, it's guaraneed to not fail on the fd
> installation side for valid userspace programs. It's needed for users
> who can't tolerate such failures, e.g. accept where the other end
> never retries.
> 
> Suggested-by: Franz-B. Tuneke <franz-bernhard.tuneke@tu-dortmund.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> v2: simplify io_rsrc_node_switch_start() handling
> 
>  fs/io_uring.c | 52 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 34 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a864a94364c6..58c0cbfdd128 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8287,11 +8287,27 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
>  #endif
>  }
>  
> +static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
> +				 struct io_rsrc_node *node, void *rsrc)
> +{
> +	struct io_rsrc_put *prsrc;
> +
> +	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
> +	if (!prsrc)
> +		return -ENOMEM;
> +
> +	prsrc->tag = *io_get_tag_slot(data, idx);
> +	prsrc->rsrc = rsrc;
> +	list_add(&prsrc->list, &node->rsrc_list);
> +	return 0;
> +}

I know this code is just being moved, but I tend to like making the
expected/fast path inline:

prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
if (prsrc) {
	prsrc->tag = *io_get_tag_slot(data, idx);
	prsrc->rsrc = rsrc;
	list_add(&prsrc->list, &node->rsrc_list);
	return 0;
}
return -ENOMEM;

-- 
Jens Axboe

