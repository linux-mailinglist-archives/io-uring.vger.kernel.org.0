Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD6553209
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 14:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiFUM3M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 08:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiFUM3J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 08:29:09 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C2F6275
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 05:29:08 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e25so14845864wrc.13
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 05:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8Wj+XQMw0Th2g5k2/0z3Ja7QSCwmpg1z35xuHUgBzBU=;
        b=YszW5JHNve6t0HzDdbHR2sdCzA+Y9SfhAohYJYhWNxhDcaYnDksa3jW0om1hycctn3
         Prp4k2jHaB8Pl3P0yNHIO9nF5eZRB28Yf0UsO47Q2SzRRR3GTRLLIDjfIP5dzePDukkU
         6IEyuXgjd1lhcB3Qm8Bal395RHSZInCTrKEHTTYxFTgVadjXj7XGQ65akS+FOzLxwo0V
         /lURFhT0SbMrEkyWgwFA8MBfY4RUc07feEwOVlza9Qxll9J5MGEvt4UiTe7WarJiPgAp
         PCjZa+NPELA2TT5xyXj7okYOc5u1XWb+GuPywKGP9/+x8oRC0Lhg/x6GxG9qr9dIE8uh
         CCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Wj+XQMw0Th2g5k2/0z3Ja7QSCwmpg1z35xuHUgBzBU=;
        b=nTzA87o/ragnmv86OSblPVS4e2dBRgBsW7CYbGxTq1uDF16ZucjdIBA/yI0YLAiviN
         Xn/7V7AeSL+ONs8MlrR4rm2ZTtoBoopdtRL1vlhl8Q7eiuZJrhSJBZev09wxQy1vV3y+
         8aOpK6cQfDfIp/xB1P1TafVO9M6+j2yAXlg8TYDD26/nZmbbXckSeRw0n4QjkFZkO9Zb
         p8KSoI53U9YPCPQem1fPS61KzoBxaKKIXvAIPcgZNOCK+2sXOxWZykBfXjGbqzceaOOn
         vfGA1UmGNbCPKIcmm1q4uHzBDgfH23GJqmYh58SQtZE+Qe/afyN15VgSEMN9nrvunx5b
         4dzQ==
X-Gm-Message-State: AJIora8WWRD/l3rt8ZDy0o9tp7XWkwvw7b+wVv5cgPbNH9wMkc88q+84
        Pcc5hBMZO40WHI5EdG8+ZQ6U19eeWriGMg==
X-Google-Smtp-Source: AGRyM1vbuxGVOM6U4BdRApoUdMSs0E36fntG5ZxN+0F7OH1LVhseSCrq5b66c5R6P+dcCzw6YXzEEA==
X-Received: by 2002:adf:e196:0:b0:219:f3c7:fd88 with SMTP id az22-20020adfe196000000b00219f3c7fd88mr28486848wrb.402.1655814546651;
        Tue, 21 Jun 2022 05:29:06 -0700 (PDT)
Received: from [192.168.43.77] (82-132-235-103.dab.02.net. [82.132.235.103])
        by smtp.gmail.com with ESMTPSA id h81-20020a1c2154000000b0039c41686421sm20729636wmh.17.2022.06.21.05.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 05:29:06 -0700 (PDT)
Message-ID: <ef08ee61-20de-fb1f-d1d0-5877a1f62d4c@gmail.com>
Date:   Tue, 21 Jun 2022 13:28:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.19] io_uring: fix req->apoll_events
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/22 13:25, Pavel Begunkov wrote:
> apoll_events should be set once in the beginning of poll arming just as
> poll->events and not change after. However, currently io_uring resets it
> on each __io_poll_execute() for no clear reason. There is also a place
> in __io_arm_poll_handler() where we add EPOLLONESHOT to downgrade a
> multishot, but forget to do the same thing with ->apoll_events, which is
> buggy.
> 
> Fixes: 81459350d581e ("io_uring: cache req->apoll->events in req->cflags")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 87c65a358678..ebda9a565fc0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6954,7 +6954,8 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>   		io_req_complete_failed(req, ret);
>   }
>   
> -static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
> +static void __io_poll_execute(struct io_kiocb *req, int mask,
> +			      __poll_t __maybe_unused events)

Killing @events would add extra rebase conflicts, so left it here and will
send a clean up for 5.20.

>   {
>   	req->cqe.res = mask;
>   	/*
> @@ -6963,7 +6964,6 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
>   	 * CPU. We want to avoid pulling in req->apoll->events for that
>   	 * case.
>   	 */
> -	req->apoll_events = events;
>   	if (req->opcode == IORING_OP_POLL_ADD)
>   		req->io_task_work.func = io_poll_task_func;
>   	else
> @@ -7114,6 +7114,8 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   	io_init_poll_iocb(poll, mask, io_poll_wake);
>   	poll->file = req->file;
>   
> +	req->apoll_events = poll->events;
> +
>   	ipt->pt._key = mask;
>   	ipt->req = req;
>   	ipt->error = 0;
> @@ -7144,8 +7146,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   
>   	if (mask) {
>   		/* can't multishot if failed, just queue the event we've got */
> -		if (unlikely(ipt->error || !ipt->nr_entries))
> +		if (unlikely(ipt->error || !ipt->nr_entries)) {
>   			poll->events |= EPOLLONESHOT;
> +			req->apoll_events |= EPOLLONESHOT;
> +		}
>   		__io_poll_execute(req, mask, poll->events);
>   		return 0;
>   	}
> @@ -7392,7 +7396,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>   		return -EINVAL;
>   
>   	io_req_set_refcount(req);
> -	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
> +	poll->events = io_poll_parse_events(sqe, flags);
>   	return 0;
>   }
>   

-- 
Pavel Begunkov
