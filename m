Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DACF1F9A6C
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 16:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgFOOgl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 10:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgFOOgk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 10:36:40 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF58C061A0E
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 07:36:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x11so1486160plo.7
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 07:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OPFwe+TS3vCkuuZ3f18wQryqRUbd6s31TUgQzBSJoXo=;
        b=q6dEN2mfJbRIYat8/OKF0msqfX0qUR3LPQsdpFpqOonJpdyytfwxzAusk6W8bDB5B1
         1PeRW5ktsXadCUbVoeef5NQ8zlH8idSe0pI6XMWxmrfwSVPlNSHH4K4UIhXt2+TkEG4I
         wHp7fLW4mo4A9Jzb8XGpFsPhOrL3X2C04+H+3FHd2AsvSiU3SyrZJOkNMfKlxbPLMa8m
         v2CHwBfi0+GsF0vTS6ea/1YxCdLxv15SUP29fEQdKjbayFjrG5RON+mW6rn6JJxGHid4
         zr+ABBvrauCQP5JwLGKdsXbYuBq/ehQTgBBCIhFE4Gg056R+5SfUrXbJTfUr0YzggVio
         U0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OPFwe+TS3vCkuuZ3f18wQryqRUbd6s31TUgQzBSJoXo=;
        b=COVKPMPQhwWCiKTvKVgvSRPnCrgbcswrQ55lZRcZI6P5TmIj5vKFydzv0VsdSW+05E
         d35lthzfNkn64VYIBTZ1Ebvo6arsPkut91i8HCRJed2bX9P4DzWCgTiWT2xMyv/y3X9a
         Hzs1AP1u+PlW9csU0pTmFZrz4c7v+JbKg6eda3UhX1gPWYbU7xOS9FVpCnBzUEtxKvD3
         QKLZJg2Q9FYyeS6SA6md3k5a5+CvUS90cM7qSC8ECg6B2lvIS5Mh40QpIsmdg3LPt3TS
         4guMPImQX8ovrTiUkNJvx1JnY3HppNSxqT2fWKWmRMJqIh2vh40utTxMq+92qmf4SDKe
         ujyA==
X-Gm-Message-State: AOAM5315Rp0UHTmUomXDm69hTUlCTJCJ9Du+UtpkKzmQk4aqLb/U8t96
        YoILGQN+4vEeKOAQZNx9pO8nK6ZPwXFK8w==
X-Google-Smtp-Source: ABdhPJyq1XHSBWRKOpDebgXs3kFD19B0QiB/9Uj1SOFkJebwvnajqGed3DRNVvJgZFzpDqdL3iZSpw==
X-Received: by 2002:a17:902:ed14:: with SMTP id b20mr10512133pld.173.1592231799196;
        Mon, 15 Jun 2020 07:36:39 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b23sm12047479pgs.33.2020.06.15.07.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 07:36:38 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: add memory barrier to synchronize
 io_kiocb's result and iopoll_completed
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200615092450.3241-1-xiaoguang.wang@linux.alibaba.com>
 <20200615092450.3241-3-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a11acc23-1ad6-2281-4712-e78e46f414d7@kernel.dk>
Date:   Mon, 15 Jun 2020 08:36:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200615092450.3241-3-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/20 3:24 AM, Xiaoguang Wang wrote:
> In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
> completed are two independent store operations, to ensure that once
> iopoll_completed is ture and then req->result must been perceived by
> the cpu executing io_do_iopoll(), proper memory barrier should be used.
> 
> And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
> we'll need to issue this io request using io-wq again. In order to just
> issue a single smp_rmb() on the completion side, move the re-submit work
> to io_iopoll_complete().

Did you actually test this one?

> @@ -1736,11 +1748,20 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  {
>  	struct req_batch rb;
>  	struct io_kiocb *req;
> +	LIST_HEAD(again);
> +
> +	/* order with ->result store in io_complete_rw_iopoll() */
> +	smp_rmb();
>  
>  	rb.to_free = rb.need_iter = 0;
>  	while (!list_empty(done)) {
>  		int cflags = 0;
>  
> +		if (READ_ONCE(req->result) == -EAGAIN) {
> +			req->iopoll_completed = 0;
> +			list_move_tail(&req->list, &again);
> +			continue;
> +		}
>  		req = list_first_entry(done, struct io_kiocb, list);
>  		list_del(&req->list);
>  

You're using 'req' here before you initialize it...

-- 
Jens Axboe

