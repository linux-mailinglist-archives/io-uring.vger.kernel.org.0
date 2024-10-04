Return-Path: <io-uring+bounces-3418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5FBE9906E3
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 16:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20AA21C20AF6
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 14:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C24D1AA78A;
	Fri,  4 Oct 2024 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wk9elIy5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5891C1AA786
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728053688; cv=none; b=bpLL0Dl2RXA7z4ymQTsY24e3ee+sjAQDAR+POCqxagQ9Zg7K5Eyu0KfkqLnQPvoh1oUyiGNx8glRg3vRBNFmtpzwzHJDWOT8ooex046PHVYJHyRV9q5D3gzrWuF0oXtHSb13U/02TGjASZpPu3H5ljDOcOvg3wY1NLHyeYL2S5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728053688; c=relaxed/simple;
	bh=iFlqM/ohuJcObeE3+HHFCK0q3NbeUMUljz8J3QBFc+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKugxC0HNYFEho2il0HRF6lx5wLmuV18KVpsxYM/5NxGH1iBf0jT1OtdgfsLFIkGyUMp4pf49BMdQXFqHjCSIUzFv4bxpmH1kdCeAV3BxLoQ6M+mLrd2om22h0NKBVm0bv4vPswLaFiNVgDt9R165nHdNbvTbRVRNuX9v0Lja+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wk9elIy5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42cbb08a1a5so21837945e9.3
        for <io-uring@vger.kernel.org>; Fri, 04 Oct 2024 07:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728053684; x=1728658484; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uqquvNKsdWNyDiNvOott7gXpE5/NyCqIDU2AWNo3dSg=;
        b=wk9elIy578JD1wd6Pxm4weCCaWJgunxiX5XsxhUfNWTeSXTs7kI079f56DpViQse3c
         EUdqbvA2v3lUtHLFsNmK0cBmcpNG6/KR3KAdjGbdePUMQ6Dwx3uzMbbLpmfusekyKsn/
         N82JpDAXF0KWzHQrrZFNhAIjfCu63TDUlZf9BSS3TB57UmSNKlY9u8z198qJbtAA7pnz
         FKi66Eprgo3p8rgulwpz5MdlVPG2MpmVKS3kDVg/usUi/IaPIB+iRZrQE1R0Rlu3fsT9
         n7+cCY4oxcmq/pgKHL4cUrcfDQyhNcPCjKRqujfvq8ba8cncn3CU1V3Ni+8t9WxSyR1d
         ZLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728053684; x=1728658484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqquvNKsdWNyDiNvOott7gXpE5/NyCqIDU2AWNo3dSg=;
        b=jkWXx22upoEMOjYZvD8zV8jCOV/ILwEZprKFMzJdb04dinYoKMdrkl8f/1KfBle2eQ
         gWyIzHoHDlUAWR+euvPf7xUulEqOxAWluV+FbJzYgVS/zjkflh8Z8wqi9LdrmJekDwlW
         OeoSov0g7I304uQCYVcAh+6fnJendxxV1AdfsiG7naSUh70VdmXpEyF32CCyAS/uI9AR
         Sai9o7gpTytw8YXFr/gxL0zy+WtDqK3LVnfJEs754ZBOu5c1k1zptc7neLA4tQm8Vi58
         lmO2Dct3vHhf8Nq9gj3Wmzx7lr9NYPG7OAOAeuor/NlnoqGxySoj91dC/pK2Edz7m8ge
         Xjaw==
X-Gm-Message-State: AOJu0Yxfs6ad8nqgmkmNk86uQ1fmnKDcr7ckMJop11TaELR9W9ekgKlG
	wbkM0JGXx5HPH0+pvD/oXsx+91/z26lznPOAVVHgOHTDIJ+vy44XW+y3rcide8kAV0dHBgfODVi
	K
X-Google-Smtp-Source: AGHT+IHNqKYz3prAQ2oUtLhdMp0C4cUSSxI+yNPB1nUsOuqY8NwS/oOmu0Qu+dJxgZsY9uopKqoFsA==
X-Received: by 2002:a05:600c:3b8a:b0:42c:b95c:65ba with SMTP id 5b1f17b1804b1-42f85a6ca96mr20090495e9.6.1728053684515;
        Fri, 04 Oct 2024 07:54:44 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86b244b5sm17433045e9.23.2024.10.04.07.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 07:54:44 -0700 (PDT)
Date: Fri, 4 Oct 2024 17:54:36 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [bug report] io_uring/poll: get rid of unlocked cancel hash
Message-ID: <a1763e60-1561-48a2-babf-07c3c2161ff0@stanley.mountain>
References: <e6c1c02e-ffe7-4bf0-8ea4-57e6b88d47ce@stanley.mountain>
 <2f2cc702-609b-4e69-be1a-a373e74692f4@kernel.dk>
 <7d658ea9-44be-493c-9d68-957f293883c8@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d658ea9-44be-493c-9d68-957f293883c8@kernel.dk>

On Fri, Oct 04, 2024 at 07:54:32AM -0600, Jens Axboe wrote:
> On 10/4/24 7:50 AM, Jens Axboe wrote:
> > On 10/4/24 3:00 AM, Dan Carpenter wrote:
> >> Hello Jens Axboe,
> >>
> >> Commit 313314db5bcb ("io_uring/poll: get rid of unlocked cancel
> >> hash") from Sep 30, 2024 (linux-next), leads to the following Smatch
> >> static checker warning:
> >>
> >> 	io_uring/poll.c:932 io_poll_remove()
> >> 	warn: duplicate check 'ret2' (previous on line 930)
> >>
> >> io_uring/poll.c
> >>     919 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
> >>     920 {
> >>     921         struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
> >>     922         struct io_ring_ctx *ctx = req->ctx;
> >>     923         struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
> >>     924         struct io_kiocb *preq;
> >>     925         int ret2, ret = 0;
> >>     926 
> >>     927         io_ring_submit_lock(ctx, issue_flags);
> >>     928         preq = io_poll_find(ctx, true, &cd);
> >>     929         ret2 = io_poll_disarm(preq);
> >>     930         if (!ret2)
> >>     931                 goto found;
> >> --> 932         if (ret2) {
> >>     933                 ret = ret2;
> >>     934                 goto out;
> >>     935         }
> >>
> >> A lot of the function is dead code now.  ;)
> > 
> > Thanks, will revisit and fold in a fix!
> 
> Should just need this incremental. There's no dead code as far as I can
> see, just a needless found label and jump.
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 69382da48c00..217d667e0622 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -940,13 +940,10 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
>  	ret2 = io_poll_disarm(preq);
>  	if (bucket)
>  		spin_unlock(&bucket->lock);
> -	if (!ret2)
> -		goto found;

Oh.  I thought this was a goto out.  That explains how the code was passing
tests.  That was an easy fix.

regards,
dan carpenter

>  	if (ret2) {
>  		ret = ret2;
>  		goto out;
>  	}
> -found:
>  	if (WARN_ON_ONCE(preq->opcode != IORING_OP_POLL_ADD)) {
>  		ret = -EFAULT;
>  		goto out;
> 
> -- 
> Jens Axboe

