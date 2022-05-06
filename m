Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B26151DADB
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 16:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353799AbiEFOqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 10:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiEFOqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 10:46:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF6A6AA43
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 07:42:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id s14so7645765plk.8
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 07:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fCciWKwTtYjCwNzpF3uMXMWEkDONEDvB+Ly+sSMPNak=;
        b=wrOqFYEkCQ+YzMwOOjALqGyukOLH/diDf+vy0c4cJ6aUqtB8BbdvUtYl+g0KilNVK5
         pMAaA4i/fIZrgiohj11pnygG6BWoFBl5CEBN5OCAk+08Z2C7toBtfO/n3mkUcxs4vnGJ
         ZB3dgLdk1A8/KseauRYWHj4YZLqB4Oq1zyLER7Enj6OiG6zAdNX95r2NSN8PK+TAfgDQ
         4tduZsKli4CGnthIWFnM/C/QweWo1k2Ye3edNEoI3YLGXwBXKtpdajYuhDzlhMSYQ4hY
         oit9H/vw9iinaHjQW9gLh86OATlS2XnCl69HA/ssRStZ7YjeiwQhjdRYGbpOg8uO+WpR
         hBpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fCciWKwTtYjCwNzpF3uMXMWEkDONEDvB+Ly+sSMPNak=;
        b=ht9GDLUrXnI2QtJrvnJ7bJxM9j9dyMod3RQkBEJZhYIheIy2VLZNN+PSdtLdBhEsd4
         tnyDzP50aQZotl7xwM+XXlKl+Cx8ZyyNxpKFp1RoB6uX2+MNXRFjYIvAralZOmVp3hz+
         sh+tiL8CgP8fNRu6NCkxVhqUtOnL2qzX7onOmCmC/DWYVb4mPvXs67gcVntqt+0VNILV
         KOpX52JTRn0UgaQZa3h16l+bX9w1xjN/fdoWPJkBnzEvtfl4sJlEs6budpCXV8qlO6lC
         aT4GLg18MGVbMGOpjBw4cMkjVWrxMCBIe4yqiAux4uz7SJeCk7cEVdN/sO2BZh8QHJic
         6a3A==
X-Gm-Message-State: AOAM531upVplUVhTmWhznax5CX5grYnr0eZ4Xh/pQzHpQcSx9tRUgNrw
        UmytnCIeY3G2Can0JbtjyJOwJg==
X-Google-Smtp-Source: ABdhPJzPtNv0cBFsNLBY6bdCulNip6hoEv6/qyGMEUFFiMrRWalrbdojDjQvkYWP5OH9bWQFKANPFA==
X-Received: by 2002:a17:90b:4a05:b0:1dc:1a2c:8c69 with SMTP id kk5-20020a17090b4a0500b001dc1a2c8c69mr12603286pjb.9.1651848155723;
        Fri, 06 May 2022 07:42:35 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0015e8d4eb216sm1901124plx.96.2022.05.06.07.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 07:42:35 -0700 (PDT)
Message-ID: <afb1be12-5284-79bf-8006-26448e594443@kernel.dk>
Date:   Fri, 6 May 2022 08:42:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5/5] io_uring: implement multishot mode for accept
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-6-haoxu.linux@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220506070102.26032-6-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 1:01 AM, Hao Xu wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0a83ecc457d1..9febe7774dc3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1254,6 +1254,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
>  static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
>  static void io_eventfd_signal(struct io_ring_ctx *ctx);
>  static void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
> +static void io_poll_remove_entries(struct io_kiocb *req);
>  
>  static struct kmem_cache *req_cachep;
>  
> @@ -5690,24 +5691,29 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_accept *accept = &req->accept;
> +	bool multishot;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> -	if (sqe->ioprio || sqe->len || sqe->buf_index)
> +	if (sqe->len || sqe->buf_index)
>  		return -EINVAL;
>  
>  	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>  	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>  	accept->flags = READ_ONCE(sqe->accept_flags);
>  	accept->nofile = rlimit(RLIMIT_NOFILE);
> +	multishot = !!(READ_ONCE(sqe->ioprio) & IORING_ACCEPT_MULTISHOT);

I tend to like:

	multishot = READ_ONCE(sqe->ioprio) & IORING_ACCEPT_MULTISHOT) != 0;

as I think it's more readable. But I think we really want it ala:

	u16 poll_flags;

	poll_flags = READ_ONCE(sqe->ioprio);
	if (poll_flags & ~IORING_ACCEPT_MULTISHOT)
		return -EINVAL;

	...

to ensure that we can add more flags later, hence only accepting this
single flag right now.

Do we need REQ_F_APOLL_MULTI_POLLED, or can we just store whether this
is a multishot request in struct io_accept?

> @@ -5760,7 +5774,35 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  		ret = io_install_fixed_file(req, file, issue_flags,
>  					    accept->file_slot - 1);
>  	}
> -	__io_req_complete(req, issue_flags, ret, 0);
> +
> +	if (req->flags & REQ_F_APOLL_MULTISHOT) {
> +		if (ret >= 0) {
> +			bool filled;
> +
> +			spin_lock(&ctx->completion_lock);
> +			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
> +						 IORING_CQE_F_MORE);
> +			io_commit_cqring(ctx);
> +			spin_unlock(&ctx->completion_lock);
> +			if (unlikely(!filled)) {
> +				io_poll_clean(req);
> +				return -ECANCELED;
> +			}
> +			io_cqring_ev_posted(ctx);
> +			goto retry;
> +		} else {
> +			/*
> +			 * the apoll multishot req should handle poll
> +			 * cancellation by itself since the upper layer
> +			 * who called io_queue_sqe() cannot get errors
> +			 * happened here.
> +			 */
> +			io_poll_clean(req);
> +			return ret;
> +		}
> +	} else {
> +		__io_req_complete(req, issue_flags, ret, 0);
> +	}
>  	return 0;
>  }

I'd probably just make that:

	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
		__io_req_complete(req, issue_flags, ret, 0);
		return 0;
	}
	if (ret >= 0) {
		bool filled;

		spin_lock(&ctx->completion_lock);
		filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
					 IORING_CQE_F_MORE);
		io_commit_cqring(ctx);
		spin_unlock(&ctx->completion_lock);
		if (filled) {
			io_cqring_ev_posted(ctx);
			goto retry;
		}
		/* fall through to error case */
		ret = -ECANCELED;
	}

	/*
	 * the apoll multishot req should handle poll
	 * cancellation by itself since the upper layer
	 * who called io_queue_sqe() cannot get errors
	 * happened here.
	 */
	io_poll_clean(req);
	return ret;

which I think is a lot easier to read and keeps the indentation at a
manageable level and reduces duplicate code.

-- 
Jens Axboe

