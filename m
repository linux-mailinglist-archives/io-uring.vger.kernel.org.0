Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E033D7E3
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 16:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCPPnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 11:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhCPPnS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 11:43:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B48C06174A
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 08:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=jk2Nswj7x26s8HzoXxrcKWz9+ZAxPLO+IO4tkFcAoRY=; b=nGTU9iE34wRKSYSrP497UhqcQE
        m+ZNRnDEY/r7naGJH/zBdpQE25xQg1IKcfA10H3RI8e6r4iS6qtHOy1NjX4BeH3FIOvc3NPqgiSW6
        bcRK95d6eI1At3l//Ir0cl9gy/pGqFUu4pKrXsGgLdGBenmchE4I1UMtvgV/Q5x/QSXHCmG4VQB5A
        usTQZiskXoJJpDp/hktO86uQySBTAouVcxf5loCCOih4ARfmaZUGeKNI2oJzAOX5OsLTvhghnrGGR
        SEsKwKQmYg6lmfA9hCAmVZQ1+inw+z6cN3a00wXQzPod1k+o7q5bvtAA9TyrZ0h/5IX8oHUQTs1lO
        zDmZXkOtj6YcuAec6DExjUVju40eEYZbOUpCqilUOCPRuAAzvNlpuufXjZvGR0OwPMInSjz5YZj0v
        5k7TMwvHCStKIdlSpdIx6wYMlD19ehWDFQnfaFTRgcxzt8IJod41Ec7Ku4VnPiz107kTRR2tAt2s+
        +GgC1WwrKplhrCgtNMOXVVEH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMBqi-0000rV-ME; Tue, 16 Mar 2021 15:43:12 +0000
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, chaitanya.kulkarni@wdc.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140233epcas5p372405e7cb302c61dba5e1094fa796513@epcas5p3.samsung.com>
 <20210316140126.24900-2-joshi.k@samsung.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH v3 1/3] io_uring: add helper for uring_cmd completion
 in submitter-task
Message-ID: <7a986342-f745-a084-fcb7-1d20a64a7f87@samba.org>
Date:   Tue, 16 Mar 2021 16:43:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210316140126.24900-2-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Kanchan,

> +static void uring_cmd_work(struct callback_head *cb)
> +{
> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> +	struct io_uring_cmd *cmd = &req->uring_cmd;
> +
> +	req->driver_cb(cmd);
> +}
> +int uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> +			void (*driver_cb)(struct io_uring_cmd *))
> +{
> +	int ret;
> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> +
> +	req->driver_cb = driver_cb;
> +	req->task_work.func = uring_cmd_work;
> +	ret = io_req_task_work_add(req);
> +	if (unlikely(ret)) {
> +		req->result = -ECANCELED;
> +		percpu_ref_get(&req->ctx->refs);
> +		io_req_task_work_add_fallback(req, io_req_task_cancel);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(uring_cmd_complete_in_task);

I think this should be have an io_ prefix:
io_uring_cmd_complete_in_task()

I'll let Jens comment if this is needed at all...

metze
