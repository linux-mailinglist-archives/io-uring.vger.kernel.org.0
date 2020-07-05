Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB809214FB2
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 23:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgGEVAv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 17:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgGEVAu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 17:00:50 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719CFC08C5DE
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 14:00:50 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so17470097pgq.1
        for <io-uring@vger.kernel.org>; Sun, 05 Jul 2020 14:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bufUwvRb4yy/35PtxLSIA3L2e6YgBS0471hx6c+GstA=;
        b=N3kJT8gTEH1WY2Ds60BxW/W7rgnScY269vLCmYtCXPVCXVbjq6XFoBe8sMdTH9k+l9
         ampNfLOofuJqXQVlSJHOiWKHMCJpgSfG+I2FNNWsWWyGmDI83WahiQ8M3oL8Ksc3nWzc
         O4j6QyqhUNEwVG59tV7VG0NPl+lrf32quMVRAOXsVGPdLAKBm3jKXZtkm+hNG+HtfdD+
         H4x829WDxvIySn3f6KijERoSMb2p87c957/ieo32VqE2rXCu+D/L/CF9e4XS6/su7q5H
         6sgcb0rbVUw+SsbYIP0W4LLfQFk/ug0npggIGlppH+rmFldP6fsoxiJmbG1cBi79TJ19
         5GPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bufUwvRb4yy/35PtxLSIA3L2e6YgBS0471hx6c+GstA=;
        b=ott0XvlI7ll4XPhZ4adCNM4xWthjFOjYqZr5xtB8ohguv60YCJwqMOnNmxFlUc7o++
         SK6ON6gFL69bCxrWdtqzaXNz204ltelYciEXtQdPnVBIts0KgwF6CTZnyzEsvHGR/zFk
         X4oJTpDuaXSto4NHlgGzDn0qkdhlzKW9agCGDjIQ7RFc+3fQnSxSgvFiOi0kMNPg2Fwk
         YXYIhhacfWYBx1aZpcdGlQ/K97dsRHbbCyf14LJIrIkM3a+x9f0Pk0T3DJFRKuL74Ust
         9IDrTxvA/X4EK+q0KUHLn8XVPy6UcFs2A/02vSzDIqNbY14Y6l1TwomBniKPkWKVuEU2
         kJHg==
X-Gm-Message-State: AOAM531F753ofoo/DfKME+6CMO3Ti3BblS+SDpcyK8RmIW7CzZQvApr+
        EkXP1oZyoAUZkyZzrsa1FV7E1A==
X-Google-Smtp-Source: ABdhPJyq9iZmf3H+Kg7Ji/N1gR7wlq1WD/uqrTdqauN5Nd3hoKPFzzFPzw3hOKK62GyXINbio4wMwQ==
X-Received: by 2002:a63:7a56:: with SMTP id j22mr37715625pgn.293.1593982849816;
        Sun, 05 Jul 2020 14:00:49 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g7sm15959583pfh.210.2020.07.05.14.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:00:49 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org
Cc:     hch@infradead.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
Date:   Sun, 5 Jul 2020 15:00:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/5/20 12:47 PM, Kanchan Joshi wrote:
> From: Selvakumar S <selvakuma.s1@samsung.com>
> 
> For zone-append, block-layer will return zone-relative offset via ret2
> of ki_complete interface. Make changes to collect it, and send to
> user-space using cqe->flags.
> 
> Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
> ---
>  fs/io_uring.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d8..cbde4df 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -402,6 +402,8 @@ struct io_rw {
>  	struct kiocb			kiocb;
>  	u64				addr;
>  	u64				len;
> +	/* zone-relative offset for append, in sectors */
> +	u32			append_offset;
>  };

I don't like this very much at all. As it stands, the first cacheline
of io_kiocb is set aside for request-private data. io_rw is already
exactly 64 bytes, which means that you're now growing io_rw beyond
a cacheline and increasing the size of io_kiocb as a whole.

Maybe you can reuse io_rw->len for this, as that is only used on the
submission side of things.

-- 
Jens Axboe

