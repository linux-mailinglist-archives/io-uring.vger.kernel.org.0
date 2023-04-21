Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EEE6EB09F
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 19:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjDURf7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 13:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjDURf6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 13:35:58 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C81B59F9
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 10:35:57 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b9f00640eso509975b3a.0
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 10:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682098556; x=1684690556;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r/mJ/VjOxPO/J8QuuypwEENO9K3r8k38isr2LlmMEFg=;
        b=XZwUt/YPv5G9da4ipP69kGI6lWga8H4QxNnwfA39J1lebC3iQywy/m+sWDP/KCZNK1
         Dfw6a864OhwkqL0ZOdV8wTG7H/T27+18/840b6aX/vfsX1kH3zJmiRPz/isqbOiwM9+o
         wUsyzerOHnyKjHjnop2KUX+P5KJYshXOY4l3lQl9JnLjLfXqf5DMuZ+AO8sL9yeQ/V4B
         YiYW3WilO21S5X4bW6kHJCwZyMTeRJf6A0QQ85s3QIHhSdzTF4zPj1AfMkiCLbAib9de
         YKCETFRB5U7VXhjflX/B5KaqtJ50do+76NyVdcixN/Q4YpJNwRhLikTkQKmJSyitD8uL
         6oZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682098556; x=1684690556;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r/mJ/VjOxPO/J8QuuypwEENO9K3r8k38isr2LlmMEFg=;
        b=eOrxQhCBZZ/WRn9K7Igo4tll2ZiRF6rqIbZRgy3xmxpOSz87tEbaELucNhXpE5cetI
         ohllhJfY6hGc8tl/TrqNwBJEl3qnpsOllPa3hcjjimwsMBaVA03+Rfg9sC/YwySc35TG
         bdFyO6ZGR3wF5CP8baa0Iq/s9qO4JxRJT/2ATOlffNul9Xxy0T/HoKtm8dP3BtfBZ8T6
         uRcloIkjX2wfskwHKR9kVS1HB8VaOfhdxE2XYQvrlCr7sh1sX05JfeNgehRV2Znr8t/k
         MhywVxOFzE5GHj7NPXowpUI3Z//nBSvc73N520eqR316g9tYNriASAZHgCbjg4IdpXFm
         CwZg==
X-Gm-Message-State: AAQBX9ekua+7mfGo61EnTVZ9ag7FfhNZxv0pPH2G/RLTtsc8XEohhgwM
        qkyaCRBLl7mGKz/4HiiXqcW/mQ==
X-Google-Smtp-Source: AKy350YWzfrHTRavHDl7+6Rx9aw4U52JeUW8bIGUDOJ8tP+cHux9srPwBCRsSvujlVarlJJK8O9ucA==
X-Received: by 2002:a05:6a20:5496:b0:f1:f884:f0dd with SMTP id i22-20020a056a20549600b000f1f884f0ddmr7260065pzk.2.1682098556570;
        Fri, 21 Apr 2023 10:35:56 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e13-20020a63db0d000000b0050f7208b4bcsm2872399pgg.89.2023.04.21.10.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 10:35:56 -0700 (PDT)
Message-ID: <d8f47d6c-8353-5aa7-a41a-14e4cc047dc9@kernel.dk>
Date:   Fri, 21 Apr 2023 11:35:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 1/1] io_uring: honor I/O nowait flag for read/write
Content-Language: en-US
To:     Chaitanya Kulkarni <kch@nvidia.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20230421172822.8053-1-kch@nvidia.com>
 <20230421172822.8053-2-kch@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230421172822.8053-2-kch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/23 11:28?AM, Chaitanya Kulkarni wrote:
> When IO_URING_F_NONBLOCK is set on io_kiocb req->flag in io_write() or
> io_read() IOCB_NOWAIT is set for kiocb when passed it to the respective
> rw_iter callback. This sets REQ_NOWAIT for underlaying I/O. The result
> is low level driver always sees block layer request as REQ_NOWAIT even
> if user has submitted request with nowait = 0 e.g. fio nowait=0.
> 
> That is not consistent behaviour with other fio ioengine such as
> libaio as it will issue non REQ_NOWAIT request with REQ_NOWAIT:-
> 
> libaio nowait = 0:-
> null_blk: fio:null_handle_rq 1288 *NOWAIT=FALSE* REQ_OP_WRITE
> 
> libaio nowait = 1:-
> null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE
> 
> * Without this patch with fio ioengine io_uring :-
> ---------------------------------------------------
> 
> iouring nowait = 0:-
> null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE
> 
> iouring nowait = 1:-
> null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE
> 
> * With this patch with fio ioengine io_uring :-
> ---------------------------------------------------
> 
> iouring nowait = 0:-
> null_blk: fio:null_handle_rq 1307 *REQ_NOWAIT=FALSE* WRITE
> 
> iouring nowait = 1:
> null_blk: fio:null_handle_rq 1307 *REQ_NOWAIT=TRUE* WRITE
> 
> Instead of only relying on IO_URING_F_NONBLOCK blindly in io_read() and
> io_write(), also make sure io_kiocb->io_rw->flags is set to RWF_NOWAIT
> before we mark kiocb->ki_flags = IOCB_NOWAIT.
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  io_uring/rw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 3f118ed46e4f..4b3a2c1df5f2 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -745,7 +745,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  	req->cqe.res = iov_iter_count(&s->iter);
>  
> -	if (force_nonblock) {
> +	if (force_nonblock && (rw->flags & RWF_NOWAIT)) {
>  		/* If the file doesn't support async, just async punt */
>  		if (unlikely(!io_file_supports_nowait(req))) {
>  			ret = io_setup_async_rw(req, iovec, s, true);
> @@ -877,7 +877,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  	req->cqe.res = iov_iter_count(&s->iter);
>  
> -	if (force_nonblock) {
> +	if (force_nonblock && (rw->flags & RWF_NOWAIT)) {
>  		/* If the file doesn't support async, just async punt */
>  		if (unlikely(!io_file_supports_nowait(req)))
>  			goto copy_iov;

This is wrong. libaio doesn't care if it blocks for submission, and this
is actually one of the complains of aio/libaio. Is it async? Maybe?
io_uring, on the other hand, tries much harder to not block for
submission. Because if you do block, you've now starved your issue
pipeline. And how do you do that? By always having NOWAIT set on the
request, unless you are in a context (io-wq) where you want to block in
case you have to.

This has _nothing_ to do with the user setting RWF_NOWAIT or not, only
change for that is that if we did have that set, then we should
obviously not retry from blocking context. Rather, the io should be
complete with whatever we originally got (typically -EAGAIN).

-- 
Jens Axboe

