Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8430A21939E
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 00:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgGHWjQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 18:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGHWix (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 18:38:53 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7120CC08C5CE
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 15:38:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d4so47813pgk.4
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 15:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0IDR+Jdn/swMjriOk89kNCPU0czu+vBFpA+hJGhx0VU=;
        b=rg0dcHkxPIVVrYjkS34uSdILXxUhoqLXohzmIYDsJMLstyvORLpsfkj2HW06TsOpdW
         pPK8pUxjKa133FVWqYPrJMvTtY5DsTH5iPcIj71bWRo4I0a6/WuNJInZLBm/wqCEgPt4
         LPm71+MdEKvcACPKGkaUGxAxihomelQNS+TAgD4lm+TVlYRbuWIk81nhoomGM2yeUfIY
         He94kpz/oOD+0IPxf6i+5pN5dSJO1Ukp78RjPCkhgDWj++70sccbt+L+6OIYCRBcpQ03
         +rChcmq4N1f1Xz//Qv+2Pqxqe8deIcaVz7YkMSSX2ZdAU2flEY4HByWb0S4YkwVJp1Ey
         dj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0IDR+Jdn/swMjriOk89kNCPU0czu+vBFpA+hJGhx0VU=;
        b=bOyNygXiEG5y690xQCpl2w7IVY2ODnN24zvNyBX28XtEWzHyj9XT6tFdwYedbRu3iP
         glFTJAOHzlD/WglIsghJr1qB1TXyU8suU1gH6Akgwy7CRhqaEetjI0CCUiVbU3ttgsSq
         gOeN+O0w9UgO8rxpmZ+K4Gm3lgC0rnx02cEktdT6m+OuXUeIaKcFi7S9UaXPmqn0pShC
         QclASH/2Tv/Wbhe1qQs45X9QQJpbq1pfCLCafD5bD4Wu4GetJ3ywZd5alnRAGIlq5dWN
         ibrttStWW2IyM45XdDYJy30w3RGv6Y2sH2SGLETHJTqMfV0KcbzBSSolI2sXShXZ282P
         xMyQ==
X-Gm-Message-State: AOAM532o1e/rA5eFpztpMbdOY/Ubn9oRqEdXqP7O4uuxuKEHFEeE7RBH
        frsYjt4Bf4aNATGzHE/mz4VfmA==
X-Google-Smtp-Source: ABdhPJzU0QCgwB29x3U5ahxJfjqWMwTCjZWeHX8Ch1hjXQRSaxDVY/HeShauYg4FvnhP1AF82X9d2w==
X-Received: by 2002:a65:5682:: with SMTP id v2mr51087824pgs.231.1594247933001;
        Wed, 08 Jul 2020 15:38:53 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e5sm480906pjv.18.2020.07.08.15.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 15:38:52 -0700 (PDT)
Subject: Re: [PATCH 2/2] fs: Remove kiocb->ki_complete
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200708222637.23046-3-willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <33e0220c-242d-1856-9d4e-31528011a06e@kernel.dk>
Date:   Wed, 8 Jul 2020 16:38:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708222637.23046-3-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 4:26 PM, Matthew Wilcox (Oracle) wrote:
> @@ -341,12 +343,25 @@ struct kiocb {
>  	randomized_struct_fields_end
>  };
>  
> +static inline int kiocb_completion_id(struct kiocb *kiocb)
> +{
> +	return kiocb->ki_flags >> _IOCB_COMPLETION_SHIFT;
> +}
> +
> +static inline void kiocb_set_completion(struct kiocb *kiocb, int id)
> +{
> +	kiocb->ki_flags = (kiocb->ki_flags & (~IOCB_COMPLETION_FNS)) |
> +				(id << _IOCB_COMPLETION_SHIFT);
> +}
> +
>  static inline bool is_sync_kiocb(struct kiocb *kiocb)
>  {
> -	return kiocb->ki_complete == NULL;
> +	return kiocb_completion_id(kiocb) == 0;
>  }
>  
>  void complete_kiocb(struct kiocb *kiocb, long ret, long ret2);
> +int register_kiocb_completion(void (*)(struct kiocb *, long, long));
> +void unregister_kiocb_completion(int id);

Same here, you seem to mix and match whether you prefix with kiocb or
not. Why not make them all kiocb_*?

kiocb_register_completion() and so forth.

-- 
Jens Axboe

