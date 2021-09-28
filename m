Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625FA41AD99
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 13:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbhI1LKm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 07:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbhI1LKl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 07:10:41 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B33C061575
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 04:09:02 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso2470428wme.0
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 04:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tvPF2CwZd0CYkK+CdSnDHl69mV4z2/uXXNojmmwcyJE=;
        b=iNk1GAC8jDz5l2PQlvnrkLA3L4DUzIxOiAQBf+Pzm2DC5Cv8OKm/gUg4iVqy4JP7xS
         Az/glNFSzZOulXxZuElOw5YmrFRImTR9Ej2jFiIKRh7PG122MLdaeZX6yVcnvDOiN1p0
         UyblwqxfGwV1XAE38V+sw5pGe1J5Yr7D/RFcDDzu8yt2YcRTBBnJEcRag6t8OEBVcOV/
         q4RDvSkjRpuMXD3+IEdaIv6si4LpnY/3hfIhc31bkPkVnEIxUkrdHFTLr+PZyK2d4LYu
         784/hq9yAzwEx39vgur2BdGKTlGPKN7dewQvwaK+eJijzDNmbTKlvGsHenKEF6mPo1uh
         Gugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tvPF2CwZd0CYkK+CdSnDHl69mV4z2/uXXNojmmwcyJE=;
        b=FZebXBgS7ddrUolXgZ4nx3aPnDXOXY0R3oG/7blMqb/OUrUVon8Ef3sO4MovNotG0o
         YRz//9xtYg/J2sSiGp5TJi4fGjxegKmNtod6AscxvAyelEGPTVuxggLdARPSo+E+ffaS
         x3H9hDvYdco6xEdRRXK8B/Emig7hBWVVK8aQRmu9YD59ZXc+nwnS6eW3Sf+IEcLEjn+z
         pZZYSeSfGa2OjnFdXVtw6zpiTsd/nv0xA9aYiJdpPU+LMonrCP3cWoEMxSMUKTYnKh4H
         ZWWFXcSrWtNZHjdkXxbwrI7ykSamR38cjrQVD7LWHyKXQs1jb/rmFJu+SiYqljb/88jC
         Togg==
X-Gm-Message-State: AOAM531PwziATNoXiBdKhHd8iNoUOCntCGnGRQ3ZETm7Mu9sCHlVXu2Y
        p1IewObT3SQaMLFo+bGOfqooIci3wuE=
X-Google-Smtp-Source: ABdhPJy26pO8RfBJ9hhtN/0Si9Tws6XV+ObD+mur3u8Ya7etim+ypUYz9MjXIccpF1YOD4ec+haX3Q==
X-Received: by 2002:a1c:7f11:: with SMTP id a17mr4051675wmd.166.1632827341078;
        Tue, 28 Sep 2021 04:09:01 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id p12sm2747162wrm.90.2021.09.28.04.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 04:09:00 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-2-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/8] io-wq: code clean for io_wq_add_work_after()
Message-ID: <ec45dd61-194b-3611-dcd6-2a5440099575@gmail.com>
Date:   Tue, 28 Sep 2021 12:08:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927061721.180806-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/21 7:17 AM, Hao Xu wrote:
> Remove a local variable.

It's there to help alias analysis, which usually can't do anything
with pointer heavy logic. Compare ASMs below, before and after
respectively:
	testq	%rax, %rax	# next

replaced with
	cmpq	$0, (%rdi)	#, node_2(D)->next

One extra memory dereference and a bigger binary


=====================================================

wq_list_add_after:
# fs/io_uring.c:271: 	struct io_wq_work_node *next = pos->next;
	movq	(%rsi), %rax	# pos_3(D)->next, next
# fs/io_uring.c:273: 	pos->next = node;
	movq	%rdi, (%rsi)	# node, pos_3(D)->next
# fs/io_uring.c:275: 	if (!next)
	testq	%rax, %rax	# next
# fs/io_uring.c:274: 	node->next = next;
	movq	%rax, (%rdi)	# next, node_5(D)->next
# fs/io_uring.c:275: 	if (!next)
	je	.L5927	#,
	ret	
.L5927:
# fs/io_uring.c:276: 		list->last = node;
	movq	%rdi, 8(%rdx)	# node, list_8(D)->last
	ret	

=====================================================

wq_list_add_after:
# fs/io-wq.h:48: 	node->next = pos->next;
	movq	(%rsi), %rax	# pos_3(D)->next, _5
# fs/io-wq.h:48: 	node->next = pos->next;
	movq	%rax, (%rdi)	# _5, node_2(D)->next
# fs/io-wq.h:49: 	pos->next = node;
	movq	%rdi, (%rsi)	# node, pos_3(D)->next
# fs/io-wq.h:50: 	if (!node->next)
	cmpq	$0, (%rdi)	#, node_2(D)->next
	je	.L5924	#,
	ret	
.L5924:
# fs/io-wq.h:51: 		list->last = node;
	movq	%rdi, 8(%rdx)	# node, list_4(D)->last
	ret	


> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.h | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index bf5c4c533760..8369a51b65c0 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -33,11 +33,9 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>  				     struct io_wq_work_node *pos,
>  				     struct io_wq_work_list *list)
>  {
> -	struct io_wq_work_node *next = pos->next;
> -
> +	node->next = pos->next;
>  	pos->next = node;
> -	node->next = next;
> -	if (!next)
> +	if (!node->next)
>  		list->last = node;
>  }
>  
> 

-- 
Pavel Begunkov
