Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE99C5540F0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 05:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiFVDeN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 23:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiFVDeM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 23:34:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D228985
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 20:34:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p5so9036205pjt.2
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 20:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fssPZHnY3pmx7DCRJn9uEs/dFGqtI3gSoaU+XPcPyYE=;
        b=JXwKetkmZZhaiUTTvDqqHrsiK8/jybDzxhI4DsPXKPedMYdH/vHB41pqwB4zXwQtla
         NG2u4PGlIU77M97lxv16nUZ9I1BTQRfXw9VY5wGQbbTDNNNdgf/AbIXplN17drNgvjwC
         OdeCX3d5XRvUdv9l/h388bR/ewPw7pFgSlK1rFcrUG0b/tQdecQFKcPkhc+1i2GYi9Gd
         ufyJk2LK5JfoLFAt4LtM5ZLsDdshdn7FHnzg6IkZTS1fwuQBWBq7RzE8ft4g9zVKRSay
         GGs1vppr91u0tTUwy7vZM/xO6MXzwKuL7bxc2PyG3+Vb41scAmRPeOKrD8lik2RhjOz0
         K15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fssPZHnY3pmx7DCRJn9uEs/dFGqtI3gSoaU+XPcPyYE=;
        b=0zi6GSSm+buFvOH+v9kmZWe53xNGm70DaL3uGW5ZSHljYtwYSDfvjF5TzdcfJeojvW
         b22CPdGS2Aajj6EbgLDKjTRjLYslfyY6PpRm00HOQE3QXKYwkw0yo6SjoY2m+mT10LEX
         O34+Dxvh5rRhSnO7gz2YW+ucGYf3KTTDCEL3v6zhaeCsa0pXicsj/xxCeA0GqhA/Hiia
         mG7GwuIHUKkFi91G4GluILbMCTLlwetG4yfHrw0yPzRodwir0ACjH/YN0LFtJQ5Amkcg
         9KaHlitwKvMUx/9dH5JE6s28bynm3D50JtEl9Hk33IyFwgDPk0bCbd0Ynu2l6riLP2Tq
         hupA==
X-Gm-Message-State: AJIora8B50u8HPHzIULA08zxUv2/Q6azSA1zG7l7Cur44yCzqSH8xwCu
        SoXksKr2b9AhffUBHiBExKzNTzhNfWkiaQ==
X-Google-Smtp-Source: AGRyM1tt6cw39IWhNRfr3Pjo7gkyqpEBq16unBMkaP1tM+Ul5Jp2t8nnfZCJHf/iUj1K0FAaKLIfgQ==
X-Received: by 2002:a17:90a:1c09:b0:1ea:91d4:5a7f with SMTP id s9-20020a17090a1c0900b001ea91d45a7fmr47237516pjs.232.1655868850169;
        Tue, 21 Jun 2022 20:34:10 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902768900b00163ffe73300sm11435716pll.137.2022.06.21.20.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 20:34:09 -0700 (PDT)
Message-ID: <dc244beb-b260-450e-6678-e1e7fe9e057c@kernel.dk>
Date:   Tue, 21 Jun 2022 21:34:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19 1/3] io_uring: fail links when poll fails
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655852245.git.asml.silence@gmail.com>
 <a78aad962460f9fdfe4aa4c0b62425c88f9415bc.1655852245.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a78aad962460f9fdfe4aa4c0b62425c88f9415bc.1655852245.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/22 5:00 PM, Pavel Begunkov wrote:
> Don't forget to cancel all linked requests of poll request when
> __io_arm_poll_handler() failed.
> 
> Fixes: aa43477b04025 ("io_uring: poll rework")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index dffa85d4dc7a..d5ea3c6167b5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7405,6 +7405,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>  	ipt.pt._qproc = io_poll_queue_proc;
>  
>  	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
> +	if (!ret && ipt.error)
> +		req_set_fail(req);
>  	ret = ret ?: ipt.error;
>  	if (ret)
>  		__io_req_complete(req, issue_flags, ret, 0);

We could make this:

	if (!ret && ipt.error) {
		req_set_fail(req);
		ret = ipt.error;
	}

and kill that ternary, but we could also then go a bit further with the
completion. So let's just leave that for 5.20.


-- 
Jens Axboe

