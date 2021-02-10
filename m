Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10ADB315D0C
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 03:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhBJCQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 21:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhBJCO6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 21:14:58 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82B7C061574
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 18:14:12 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t11so217002pgu.8
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 18:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bX64/yrxq5mONNaCVjbaABljFRIPhr3WMRZ36a8ebg0=;
        b=lADcy4st1POULePNR4ThfNrerBejVdOtCx1etTXorsiedCIRIp0JwtA2oUlCLeqqhS
         xaHhLNjaMD1TGe88h6pKRjKonuMk48uvQmDonSvixMk9IPzMy27dPFMSivmyDZdFCqpc
         BlAHL5TsUUA90yo0Y9n5teWvDqNr5M0fJuH3q9JB+56196NWl9xadFLaYbQVUZG7i13R
         6/7BCNxuGUOh2FcSlUNKITskuDcipbsWWi7v7PHLmS89aZSYcW7wpOeZVQOOC2ibI3Uf
         /YQeQkHnFEPpjW7yxzpUC01b4BNTIILFDh1bgdPWslZvvnt4hQH/NGyFNfHLvSBYQLez
         yz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bX64/yrxq5mONNaCVjbaABljFRIPhr3WMRZ36a8ebg0=;
        b=P7qg/0h5Oht9lmLnwRkRAPGYZmmcbvxE3ezmewaawMcL0kxlKsJdI2R7tr7uXV8oaN
         MwUXE1g3yD783VDKHfOZfS+8fN1kWJoItH0hHXkt3t41lyJqggTdOJd+vBVG7LHpqTME
         KNO68TgcqdMnh2mtTx0Sbgz0eJgMQ5AGvIK/p47fI2u6HhSyuAu5F8VXvaDdLgRrW16R
         J2NMD1VvNz+cqHJPjpnZcautB0AO+xBjrN7MeZB8S4E4BAMigebUXIGvbGxaj2LA6he2
         X2zWUe9BJLfLLoW+f000gOnrqNyWKp1MOTIoBWjAcJh+bF9/5EXFd1FNof8W4KwiavQH
         Eeog==
X-Gm-Message-State: AOAM5328hpWdTeQeF+lC8VUi/LkTT/5wr1qvYk9wE0Ns8Ubls5n9Zlcc
        5uCYtRN9wS1QrGJjNPwD8VJKWrdZAIP/rA==
X-Google-Smtp-Source: ABdhPJxpOG3iwxL+0TkeTpISjvA5csFGt9ZAolMl0FE3U2Q3pFdc3eyZK4k8dz02qc0a5rgML/3E8Q==
X-Received: by 2002:a63:4966:: with SMTP id y38mr876322pgk.428.1612923251866;
        Tue, 09 Feb 2021 18:14:11 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x28sm201439pfq.168.2021.02.09.18.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 18:14:11 -0800 (PST)
Subject: Re: [PATCH 13/17] io_uring: use persistent request cache
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
 <df890f4c676ee944fb9d389dece05243418e153a.1612915326.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e6e9233-4461-be87-9598-53078087b1d3@kernel.dk>
Date:   Tue, 9 Feb 2021 19:14:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <df890f4c676ee944fb9d389dece05243418e153a.1612915326.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/21 5:03 PM, Pavel Begunkov wrote:
> @@ -1343,10 +1343,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>  	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
>  	init_llist_head(&ctx->rsrc_put_llist);
>  
> -	submit_state = &ctx->submit_state;
> -	submit_state->comp.nr = 0;
> -	submit_state->file_refs = 0;
> -	submit_state->free_reqs = 0;
> +	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
>  	return ctx;
>  err:
>  	kfree(ctx->cancel_hash);

This just needs to be folded into "io_uring: don't reinit submit state every time"
as 'ctx' is zeroed on alloc. Except the list init, of course.

-- 
Jens Axboe

