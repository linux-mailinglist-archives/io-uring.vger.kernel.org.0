Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE96F4443
	for <lists+io-uring@lfdr.de>; Tue,  2 May 2023 14:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbjEBMvn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 May 2023 08:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjEBMvm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 May 2023 08:51:42 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAF9CE
        for <io-uring@vger.kernel.org>; Tue,  2 May 2023 05:51:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-959a3e2dc72so756288266b.2
        for <io-uring@vger.kernel.org>; Tue, 02 May 2023 05:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683031899; x=1685623899;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xIu0owOeF7vNS0D98Vsx6MNfPXSJ2bGaP3kA6qe2EBU=;
        b=HuG/l1YO15ZlQA5RY5BFWmQmWnSZ3bNQeT6IF0IZkuvEzlx5HEKpa/xgiYKvp1PV6q
         5TkJYqyzdOja+ewPKXh8dlVxDlXVRUkr6D5k+Z82jm51WzeYdlQQXphHTl0/htutjyI8
         q9xaEbo3Fjc/UpP9Alsos3IhFsEhUvsT8e9zxdIWNQHf7pT1ifoRRRZtx6JVN05T5l6G
         f3mPLGgw0LCR8PxEr7Up84Z2nbrvt/MKgJSEICPvRXffHzdkVfLR0MRXBgSiu7LZpRJg
         +KTcTv6dLARNdNy8PBpn73MoxoD3cnUyfCm/4TeIrXUAw2UZiI0aS51wHnxee3/Epdck
         JQiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683031899; x=1685623899;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIu0owOeF7vNS0D98Vsx6MNfPXSJ2bGaP3kA6qe2EBU=;
        b=KorbGrEu/z5IMgODD5TxttrXlbqsrOXYngUqwXx/MRQsi2DnKMAlZ22Lrm86+h09Jc
         YGR8+d0Sx0LOMaX8K9vG/FLYVV2sCdR9XzxtcR9HC3M0i5c8UJ2DqxTb5dSM/A2+duwb
         8cGS4tJI+hWh2kzG0TYtR5RKV+mPS8BMhxEv954a8P2tmzkqfZTTJhcUq7tauk7MfeFt
         6jN89t6ZUOAl7DpwzK+rWqtKj8QlRpafsCqz6qz5vj01EZFYZvhN+o51sZjZy8pJ0hXb
         12RtUJV99EHy1v+nfUK+djZBTkNiuDMRBxdaMD/YJRh6sBzNaW/RhewCJuqu8pK2hHrx
         aTYg==
X-Gm-Message-State: AC+VfDynododezu4x0PGQCG1tqNUPwXHw1axfi7dKbooUdEi/XtWgQWt
        9p/6grLjwRjoIURW/DWclnM=
X-Google-Smtp-Source: ACHHUZ5tGkvZgI+n2DTrDw62ZC8aUcRXrXk1MqqWzFyLmbfo0iq9uIzvL0dRMxnArrGAG7/VjEo++w==
X-Received: by 2002:a17:907:6e87:b0:94a:4107:3975 with SMTP id sh7-20020a1709076e8700b0094a41073975mr17846680ejc.76.1683031899270;
        Tue, 02 May 2023 05:51:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::20ef? ([2620:10d:c092:600::2:18ee])
        by smtp.gmail.com with ESMTPSA id bv7-20020a170907934700b00959c6cb82basm11080388ejc.105.2023.05.02.05.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 05:51:38 -0700 (PDT)
Message-ID: <b6cca1a6-304c-ae72-c45f-7ee3b43cf00c@gmail.com>
Date:   Tue, 2 May 2023 13:47:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
To:     Ben Noordhuis <info@bnoordhuis.nl>, io-uring@vger.kernel.org
References: <20230501185240.352642-1-info@bnoordhuis.nl>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230501185240.352642-1-info@bnoordhuis.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/23 19:52, Ben Noordhuis wrote:
> Libuv recently started using it so there is at least one consumer now.

It was rather deprecated because io_uring controlling epoll is a bad
idea and should never be used. One reason is that it means libuv still
uses epoll but not io_uring, and so the use of io_uring wouldn't seem
to make much sense. You're welcome to prove me wrong on that, why libuv
decided to use a deprecated API in the first place?
Sorry, but the warning is going to stay and libuv should revert the use
of epol_ctl requests.


> Link: https://github.com/libuv/libuv/pull/3979
> ---
>   io_uring/epoll.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/io_uring/epoll.c b/io_uring/epoll.c
> index 9aa74d2c80bc..89bff2068a19 100644
> --- a/io_uring/epoll.c
> +++ b/io_uring/epoll.c
> @@ -25,10 +25,6 @@ int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   {
>   	struct io_epoll *epoll = io_kiocb_to_cmd(req, struct io_epoll);
>   
> -	pr_warn_once("%s: epoll_ctl support in io_uring is deprecated and will "
> -		     "be removed in a future Linux kernel version.\n",
> -		     current->comm);
> -
>   	if (sqe->buf_index || sqe->splice_fd_in)
>   		return -EINVAL;
>   

-- 
Pavel Begunkov
