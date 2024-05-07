Return-Path: <io-uring+bounces-1797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 045D48BDE17
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 11:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B34092838B0
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 09:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0885714D710;
	Tue,  7 May 2024 09:25:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4267A14D6F7;
	Tue,  7 May 2024 09:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073900; cv=none; b=lsjdMGKZLN/DxciwslB4TQI9Ki2KlALkWAwRHcC1Q1hMocWeVf2DzqOdMOYNN4J8y/bXgXf0/AdOye1/clRwGiJu89KtA2C4FPhSnItkgn6ngI3Oyv8x3mFDolEsStmPYveq1XDxNdhR3OFk72jctebhFsKcNJgH+sUjMDVFALc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073900; c=relaxed/simple;
	bh=mQrVvuYAmIbMH2pxD87U8V+5xXOMf85klw/GJGaV+pI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TxAfPPjVQdZHnp/jVCb4wh3vM4EP86GR93WRidPWcuiInyqeLQUbf9BVUozzVc5Phk2+gFUhdeHnWwGAGQ+/Z+AKZG1Aa499CNUAwbxEKYIhG/WOBBnRjsjUybcXJwk61pQtjc847Hs3/R8Kcy4w5bJ6YFXYuX775f9H5sEe2YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-51fea3031c3so3595586e87.0;
        Tue, 07 May 2024 02:24:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715073897; x=1715678697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81GUQm3vwN8xocFlhMIqJVo/4Smzd/esO3k/Ovg30WI=;
        b=paanElRrM7vIlWl4mdKAIi42S4x76jJvkQ1lWOIHw77bNRdsKtNKj9fMGm8X4F3k1W
         46R0YqW01BV2YcQiAtYK/JsFVM6T2oFNZZBDGxsP/57Va8DBMq0tt+wCu1yscaD1sOoY
         coI00LghqiX1wNnuEsV3ozQrjxdeXmcKbweoTgtx46NeySCZHByUX4VAmCw2/UhGpf77
         ohJyE3xYO+kH7b6wYw6d2p/t0HugI0233wN7PmKc+pylS8Wahp1bguKtTtgIlSPOGiEi
         f6YBBbtKbySgA8wLmJkszydMSjeTqGYinh2iFXIynSnVH/zE18u1XskSima2EQxjA191
         rfWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW05SpfDSj2D67uriQmb/iSMiz2+qawBsM4jnjgAVtRXn/PQB38ewWgEmRnA3iG1gd+VomJZFfxfTMMfMkPwETo7gmQCl9HSJMmYTfML+rruxQShKfzPKQ0z2vkBgZ7nCZ+aDcqrTs=
X-Gm-Message-State: AOJu0Yx9RzYt50wgmSQ27cF1ZzwDlTslvP0lItx4yexn+YS9//1Px3eq
	vEIlfczoNu9VKS3pndUucunv4j4GoUr0fLPWFhUqUsPxF2aQYlJL
X-Google-Smtp-Source: AGHT+IHWEHU5g3Q/Pypyrg5Ehr/eQ3vKbRWnH/wm9dE2eUNoPttWNKTuqoVqex3ABfqh/kfNoyPrpQ==
X-Received: by 2002:a19:2d45:0:b0:51d:9f10:71b7 with SMTP id t5-20020a192d45000000b0051d9f1071b7mr9798993lft.28.1715073897027;
        Tue, 07 May 2024 02:24:57 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-119.fbsv.net. [2a03:2880:30ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090648cc00b00a59a874136fsm4034621ejt.214.2024.05.07.02.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 02:24:56 -0700 (PDT)
Date: Tue, 7 May 2024 02:24:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, leit@meta.com,
	"open list:IO_URING" <io-uring@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
Message-ID: <ZjnzZhcOQ/xVDU3e@gmail.com>
References: <20240503173711.2211911-1-leitao@debian.org>
 <b5f7b99c-053d-4df5-9b2b-aaca48e6f7bd@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5f7b99c-053d-4df5-9b2b-aaca48e6f7bd@kernel.dk>

Hello Jens,

On Fri, May 03, 2024 at 12:41:38PM -0600, Jens Axboe wrote:
> On 5/3/24 11:37 AM, Breno Leitao wrote:
> > @@ -631,7 +631,8 @@ static int io_wq_worker(void *data)
> >  	bool exit_mask = false, last_timeout = false;
> >  	char buf[TASK_COMM_LEN];
> >  
> > -	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
> > +	set_bit(IO_WORKER_F_UP, &worker->flags);
> > +	set_bit(IO_WORKER_F_RUNNING, &worker->flags);
> 
> You could probably just use WRITE_ONCE() here with the mask, as it's
> setup side.

Nice, I didn't know we could mix and match regular operations and
set_bits(). Digging a bit further, I got that this is possible.

Thanks for the feedback.

