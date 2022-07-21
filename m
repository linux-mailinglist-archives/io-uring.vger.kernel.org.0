Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03B57C97D
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 13:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiGULEW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 07:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiGULEV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 07:04:21 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19858823B1;
        Thu, 21 Jul 2022 04:04:20 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso3075859wmq.1;
        Thu, 21 Jul 2022 04:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8D+GFUIwup8GiQ8wjmlmzozYYzES0Ij/KI+KIVTEcZc=;
        b=abQvjliig+GNco1BwRCs/Zn5AwJua3Y6ei6pvepVNQnUAOPz0mz6Jj8WCe/ti6dzmV
         1YKEKJLcusSAW0SBd6mUdS/ZjVWJdnM3AGGTyrVnoXD0eOVlGPX3ZDcDI0ibUQ+wpHZp
         R9x8rFQ9wzA5ZOVhEomhwoxffaAEWH1Hsjc3Zgs36amjzB9hjAMI4Q1Depz1UU5nnkb0
         AjDdFUaPLaKkrrdWnpxGDUNYvcT3vFd/9qdl0UQqDtH6ekZsod8e40pk8cJE1teIAsI5
         DlRpHHS8EINOosu92+DCQr9+DgZVFPBbpIcUGjq0q5vG9+aesF/a0yuTZAPnCVJiTg2Z
         oJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8D+GFUIwup8GiQ8wjmlmzozYYzES0Ij/KI+KIVTEcZc=;
        b=7m/J0cMzpLA9fpz9p9jjxI3WbkqSgK8wjCdDswSNKwwF1gfd4Sb+fZiMCT1vdA7nYm
         8RWcBo0FeZ+uTj9yFky6WDPqvtO4uZmV4w2FNnaN4tmI1z/CWUj0WopdTAyJOdIL7m/c
         sbEIn73VM7cQ5DZSP0MtmSxr4ILsUHrzLzcitRkAjjpy0Ij7CDHCW2RTQrjuBTZEfls+
         e9dek17KCLx8R5KPKjpmWkmTDmPBJ5Ar/t3GweNX0s7V62wkEktzvDuhJRW6uc5k5hPt
         MY+xQJm9Lqi9OOdth9kla2WZOBbB/+p8h2B0B7fzhppu4XzYck/BtXO1J4F2V9pPbZKO
         1apg==
X-Gm-Message-State: AJIora+ooAnpnjLuYyjB2BJqAIJL5M/MwFsOzTONhfTIn0xKOyNTo75k
        toZ5IeFuWtVT1hcq1JVtEo0=
X-Google-Smtp-Source: AGRyM1vj7SaUwrZ1mj0cTngJgXlM9DRz8+gGUk9Zz3R1chZEav61jPNVXgQhl36feXdPeqyF7e5YpA==
X-Received: by 2002:a05:600c:a4c:b0:39c:6517:1136 with SMTP id c12-20020a05600c0a4c00b0039c65171136mr7943198wmq.12.1658401458325;
        Thu, 21 Jul 2022 04:04:18 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:e2e2])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c058900b0039c54bb28f2sm1478105wmd.36.2022.07.21.04.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 04:04:17 -0700 (PDT)
Message-ID: <a53873bd-2ba0-9ac2-fe17-4c878e332dd3@gmail.com>
Date:   Thu, 21 Jul 2022 12:03:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] io_uring: fix free of unallocated buffer list
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com, linux-kernel@vger.kernel.org,
        Dipanjan Das <mail.dipanjan.das@gmail.com>
References: <20220721110115.3964104-1-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220721110115.3964104-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/22 12:01, Dylan Yudaken wrote:
> in the error path of io_register_pbuf_ring, only free bl if it was
> allocated.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
> Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>   fs/io_uring.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a01ea49f3017..2b7bb62c7805 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -12931,7 +12931,7 @@ static int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>   {
>   	struct io_uring_buf_ring *br;
>   	struct io_uring_buf_reg reg;
> -	struct io_buffer_list *bl;
> +	struct io_buffer_list *bl, *free_bl = NULL;
>   	struct page **pages;
>   	int nr_pages;
>   
> @@ -12963,7 +12963,7 @@ static int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>   		if (bl->buf_nr_pages || !list_empty(&bl->buf_list))
>   			return -EEXIST;
>   	} else {
> -		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
> +		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
>   		if (!bl)
>   			return -ENOMEM;
>   	}
> @@ -12972,7 +12972,7 @@ static int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>   			     struct_size(br, bufs, reg.ring_entries),
>   			     &nr_pages);
>   	if (IS_ERR(pages)) {
> -		kfree(bl);
> +		kfree(free_bl);
>   		return PTR_ERR(pages);
>   	}
>   
> 
> base-commit: ff6992735ade75aae3e35d16b17da1008d753d28

-- 
Pavel Begunkov
