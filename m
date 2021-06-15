Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0543D3A7E1D
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 14:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhFOMYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 08:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhFOMYI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 08:24:08 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76AC061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 05:22:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m18so18098596wrv.2
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 05:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+DM3Gl5WxXHrfJDVPqxRqNnu1j/7vX1DG9QcNT7CtR8=;
        b=XZPHdJyS/G3G0m6pGB2DoltixFlbVXNLOFzZV0S29Fs+9j3QrOVdwuwVVvL5g6h/1v
         fNX7o3aCN5vbQHeOjXq5YyC8vWb3JOhGj459b/RkB0GracAZM+uwNRJ20CKp+N+6ARDq
         vWbWVUOdnEjzMjG0IxVVELZlZqnMQ+D9xYdcpDzbagPkm46X/3WCaopL2t3bhSjjtoXc
         dWfu055Rw3u0GcoQc45uFKfUIqgrpIZql+xvD3eMFA+QdFzzKr+KMDFzYFGTV7Hf6rqE
         QCMvwTxR5NN1OmANhfw5HT69LqtH4UxFmswRcjGwUzRqHovIXDwUyZfhl7Sa8lEcaJWO
         zDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+DM3Gl5WxXHrfJDVPqxRqNnu1j/7vX1DG9QcNT7CtR8=;
        b=fiYD+Oi2AI+hE06FatI6qCeUqF4k2PGJkHA7ZlGdOPudGyIt7AasJBPPGsj4d9ZJQN
         cxadqzF3PHWR0qU31WYZABCzmCyLRWq44phxymeDjBpCvzB3E/hOfsAlVUIb/ubkz89J
         jYNxF83dwwa30wh8aalxoJh7IvTmjvXBzFoKL4Tl+ZzvLMALTWG5FN7phv5hKroRPw5B
         zDVbByBxr3rknWJyjhJX0vNgBj0Ug6MqdshW1ZsAPIgeV/206CN6NM4v81PrZF69hvaN
         eEnVFctciDQKUUOiWIorZXQ9fAgBDvf8n0LhE8tpvweCZ2NB9+6aOlp65MnPhGklYGLw
         yVNA==
X-Gm-Message-State: AOAM531Kdtr60h65jtGWOVCS2FIU7iJg+1MUHjdIlIZbKIwh1obQZF4A
        OpB31n0ZO4jn/QXtu/VRoqIu08U8Kc/br+1Q
X-Google-Smtp-Source: ABdhPJzcEJFayCRjOzW/azcCSPOp35dCvNwmSfxF6eRCtbtZLz7xpp5Z1edw3EZ6rfIOyu/E6ri42g==
X-Received: by 2002:adf:e7d0:: with SMTP id e16mr24344626wrn.202.1623759722189;
        Tue, 15 Jun 2021 05:22:02 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id p16sm19357806wrs.52.2021.06.15.05.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 05:22:01 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: fix min types mismatch in table alloc
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>
References: <50f420a956bca070a43810d4a805293ed54f39d8.1623759527.git.asml.silence@gmail.com>
Message-ID: <4f387273-ae69-facf-5715-98bc4c416402@gmail.com>
Date:   Tue, 15 Jun 2021 13:21:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <50f420a956bca070a43810d4a805293ed54f39d8.1623759527.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 1:20 PM, Pavel Begunkov wrote:
> fs/io_uring.c: In function 'io_alloc_page_table':
> include/linux/minmax.h:20:28: warning: comparison of distinct pointer
> 	types lacks a cast

Build issues are nasty. Jens, I'd guess you want to fold it in

> Cast everything to size_t using min_t.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 9123c8ffce16 ("io_uring: add helpers for 2 level table alloc")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 315fb5df5054..a06c07210696 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7089,7 +7089,7 @@ static void **io_alloc_page_table(size_t size)
>  		return NULL;
>  
>  	for (i = 0; i < nr_tables; i++) {
> -		unsigned int this_size = min(size, PAGE_SIZE);
> +		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
>  
>  		table[i] = kzalloc(this_size, GFP_KERNEL);
>  		if (!table[i]) {
> 

-- 
Pavel Begunkov
