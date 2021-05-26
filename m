Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA02C391AB3
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 16:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbhEZOuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 10:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbhEZOuB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 10:50:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5D6C061574;
        Wed, 26 May 2021 07:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=i12QN3k1Tx5XUIu4xVRX9QpdAYSA31nNcwjPD4JZxkc=; b=2TIu2UJrcTqMVTH2j4C98tCw8W
        TH2EtmYvxomVmV40AEpx0HWLRv9yrPBvQWZZIBDE5M5ks4DkYNq3KgQQ5sATRyEde5B9jWqxpShgb
        Lj5JgkROe7cS9VaksEdTvwZaOEwP/m96qBga+yeVKz6AhFTMa5XpPOFD5Urf9SSxMy25uL4Mb2eM0
        8jH91tq6dJsXAUv6JlAQH70Z5il1jUdXR36rIXnZ6zJKSmnmNRoE6GnKOwEC1dQoqCY0wOEtnnCPi
        OF0T9Rsib2QF3dq356G/mmyG4z+DxymB30qzLRW0vmelE43ErKBPLKeyDeFKe3rlCdJ+7H4jEbBZl
        LiXmWzI2VdiotZy00PCArVLOOUVTynMljh91LenUME7CFUDD/zcyHC5M3iTLc4+OHVTWGT2yv1rNF
        ZwuIdHWAxMowTTbxOpSG/BVyeojejbi48aEt7nXnM3CeuLzUChDOEzvfN1TyM7vXCCLYgbhVT+FPd
        KkaOeTejAWT2cFs5V1+aP2Rs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llupc-0000TW-3O; Wed, 26 May 2021 14:48:24 +0000
To:     Paul Moore <paul@paul-moore.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163382536.8379.3124023175473604584.stgit@sifl>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH 7/9] lsm,io_uring: add LSM hooks to io_uring
Message-ID: <00bede98-1bea-e3bc-b0a6-f038dc75c08d@samba.org>
Date:   Wed, 26 May 2021 16:48:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <162163382536.8379.3124023175473604584.stgit@sifl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Paul,

>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -6537,6 +6538,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		if (!req->work.creds)
>  			return -EINVAL;
>  		get_cred(req->work.creds);
> +		ret = security_uring_override_creds(req->work.creds);
> +		if (ret) {
> +			put_cred(req->work.creds);
> +			return ret;
> +		}

Why are you calling this per requests, shouldn't this be done in
io_register_personality()?

I'm also not sure if this really gains anything as io_register_personality()
only captures the value of get_current_cred(), so the process already has changed to
the credentials (at least once for the io_uring_register(IORING_REGISTER_PERSONALITY)
call).

metze
