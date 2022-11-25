Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76304638B9A
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 14:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiKYNwh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 08:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiKYNwe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 08:52:34 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B039FE7
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:52:31 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id q7so5981185wrr.8
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kw4a3/ZwbwYPEFvTqY52SNsPOfdsXrqwIzmUF+ckwnY=;
        b=QuFTFRyPELeplfSLGVxPfiCYTuhcJ29PPy5BUU2TZCiGowuJ3+qAzGu88s/pYDzNSv
         NY0HdpbZXhuYxiB4a9cQbhcSV1pvm8Nfi3+CruygZTRG1YWhR8wqQqweqJMrpircDWXc
         y/NmU/cv09hYMwmZtk5Cwt8N6TsAmFflp83taskjHwmxZg5oax9xwGTS2L4mY1LR42wb
         qCoJfedXuGGGMbwGusFRKosMEFzQV33G2rKWLsawRenc9gjlHgXIhClhvPUdTlPV5lO9
         DwBxo0eQbfuqkyq8pkZUIdCnBVlij03/zV5uHyKXLvO2vEV9p2j7MGzAePOj6y2dyRbS
         ibjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kw4a3/ZwbwYPEFvTqY52SNsPOfdsXrqwIzmUF+ckwnY=;
        b=ctjRbvRP3D9rtIOgjR1e59V/gUJc92gHSkBqIvoVKNo0IoRfn/7sgBeClX5hk/FdHK
         pqUujsCsCXVd5ak58DAbHks5qwhWRz7FErZlk37KpEgScKv93LBdJpY0RVbx3bFyylBm
         PaNBCIDBCCaHQdADY2Fwfh4Xi4SbvniWL2blrvDJIGep2GisfAOJA32zoU/hQbbVeXE7
         5i8FwHUK7TprsOvOYjSmUP5AyhDG6sAcyQ56lbXJ/q8riK6GElPOMJUx3nWDRWA+3SRT
         yN53wTUDrIDWOfIAZfIc/W3tTqJ8Uw8bgC6gDQbTRKUnzD1seGvgTHx0KQhU9Y5+sC1t
         jeuA==
X-Gm-Message-State: ANoB5pn9bpxf2LKJ6IPATGvwwIVzQLvKDSPWvPWT00S8nrjPTrlQCTo4
        tQ+k7g3gIzAc8OF4j8bfHo3fB/EcZgA=
X-Google-Smtp-Source: AA0mqf6l7VK8ODFfUvX5+3u1+fZ8OObWAkAS+dd2Kga8tlQQjEmIDp/w8ocR0diV0l3Ut6tM7108VQ==
X-Received: by 2002:adf:e283:0:b0:236:58e5:290d with SMTP id v3-20020adfe283000000b0023658e5290dmr17469325wri.2.1669384349810;
        Fri, 25 Nov 2022 05:52:29 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:d8c5])
        by smtp.gmail.com with ESMTPSA id n3-20020a05600c3b8300b003cfa81e2eb4sm6191658wms.38.2022.11.25.05.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 05:52:29 -0800 (PST)
Message-ID: <99745f3e-9956-9a7a-b3e2-ef46422d2b26@gmail.com>
Date:   Fri, 25 Nov 2022 13:51:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 1/2] io_uring: cmpxchg for poll arm refs release
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1668963050.git.asml.silence@gmail.com>
 <0c95251624397ea6def568ff040cad2d7926fd51.1668963050.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0c95251624397ea6def568ff040cad2d7926fd51.1668963050.git.asml.silence@gmail.com>
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

On 11/20/22 16:57, Pavel Begunkov wrote:
> Replace atomically substracting the ownership reference at the end of
> arming a poll with a cmpxchg. We try to release ownership by setting 0
> assuming that poll_refs didn't change while we were arming. If it did
> change, we keep the ownership and use it to queue a tw, which is fully
> capable to process all events and (even tolerates spurious wake ups).
> 
> It's a bit more elegant as we reduce races b/w setting the cancellation
> flag and getting refs with this release, and with that we don't have to
> worry about any kinds of underflows. It's not the fastest path for
> polling. The performance difference b/w cmpxchg and atomic dec is
> usually negligible and it's not the fastest path.

Jens, can you add a couple of tags? Not a fix but the second patch
depends on it but applies cleanly even without 1/2, which may mess
things up.

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/poll.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 055632e9092a..1b78b527075d 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -518,7 +518,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   				 unsigned issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> -	int v;
>   
>   	INIT_HLIST_NODE(&req->hash_node);
>   	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
> @@ -586,11 +585,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   
>   	if (ipt->owning) {
>   		/*
> -		 * Release ownership. If someone tried to queue a tw while it was
> -		 * locked, kick it off for them.
> +		 * Try to release ownership. If we see a change of state, e.g.
> +		 * poll was waken up, queue up a tw, it'll deal with it.
>   		 */
> -		v = atomic_dec_return(&req->poll_refs);
> -		if (unlikely(v & IO_POLL_REF_MASK))
> +		if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
>   			__io_poll_execute(req, 0);
>   	}
>   	return 0;

-- 
Pavel Begunkov
