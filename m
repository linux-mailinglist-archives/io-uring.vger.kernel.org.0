Return-Path: <io-uring+bounces-8483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0675AE7E54
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 12:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F12B189153A
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 10:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721CB221DB9;
	Wed, 25 Jun 2025 10:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BQXALOwF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3F129AB16;
	Wed, 25 Jun 2025 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750845654; cv=none; b=EgZ5kjR3E7raFwzmvbJhorLQ2ZMJYQ3LsYhwqMa7surTxm8rinasK+DR28+ErFaKgR1LzqYRP1glxEZQiiP26bM8Qqf/RDv+qWus0Tz7nmR9ILV7m1SFG8popM9HlFXOBNiveg3+t+Rb5zYtB219CqAlVvMufTb8smqxqraXP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750845654; c=relaxed/simple;
	bh=Jt3T0HQ3GeZ1y+N94xavrriGZmklMiW7iXKEQmfXT+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJR7HqZ+BEUQESRyWRx4HuQ6q0Pbu0STuq2yeOM9+bO1cv10fDl9Qwp0RSUvpZGZrIZ0ArO3RsZx+3/KJ+htel4vCNAP5jAH4lHUaKMKjs8nCYXmw/VpUY0APFcCmsysgDpn7tdX00nsBGJTkA7fzTuyN7D8KPEmUS7PPftViBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BQXALOwF; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-748f5a4a423so3721861b3a.1;
        Wed, 25 Jun 2025 03:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750845652; x=1751450452; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nE/xoeiXLoLfvvWXUYGG8I4opWimXJchag+i7e4+lY=;
        b=BQXALOwFp8ePKxBu7tqjFRsXRoWhfu9+MUjLIebAyJiINruIF3qWK2uCfLOm+38qzl
         oADinDjevRz1CMuvPnIY/333njj5/kLbRmNvtYxUYveNXuvOnLwifNXBWBmPwtGRl2G5
         1CyUcvjSy2RMgEFiTPAKXPJMvlEQR3QJrqo7mdES4HGXTezpHtYUce9q5gyQWQTqHK3O
         EwM0gUuXQ0c6Apr7m5qRFBTnsNf0SvTctYFTdLoSfqz2SLOZIoWKvYyyuDtTCf4wmEF/
         3wrNyNxounpVoGgVQ2HG+1wQE0xntusUjdG04Km1MT7MSPg3XGLuJ0BUZcko3KRCrh1f
         I7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750845652; x=1751450452;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/nE/xoeiXLoLfvvWXUYGG8I4opWimXJchag+i7e4+lY=;
        b=XVOri3GpraiXIRyslQQByfdVyvAh8MJoE5I72evyv5ooS5e/hr8dVYA6b4GWWvOb12
         ylLGzq8YFogE8hm/s10ZCyvtVqvlKoEq8UCDg0iioTgjieSNonV31kIHFjpTGy0oZxSK
         91FJK5wMym3axs11qgtIJhHgY2euX6G+UbeAVuJBKJdcRVEJLK5gGQHQywFFP8DpH2qh
         rQV/wWiqJircinuWCXjITWydimA4dEvmIz40X7RHJilLa3UkRQs1crFEKfGboLvfdGPK
         DtpPc+PVblOKlx0woT2FL3CqFPw9JM7Iq7WLI6tub4f27K1jKWv70gxskRWOO2Pub23F
         h1hA==
X-Forwarded-Encrypted: i=1; AJvYcCW2upXsqRBO18r7RL3wpN8brRd2SI54+2/6zUFOc8t1CGRd3RkxAHvnxpFlMCBPX65rZVyPDTDm6A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwB5aOnu9eCY4Tl7o82g41cuAp/LvfRG17lXM3lDSDqIEWJEaw3
	7ESYrfjd49ukB2893+RpzYRDSDrcqAkvGP6+qXb83YyTvBD+Xvq2aDL6
X-Gm-Gg: ASbGncvjN81dfkQVdy9m81xdoth/84JB7uWAmO9S4DRTXIZfRwnpT4M+PePbbKnpkah
	5IO+y/2bbnNV/aIRXlRhwfNk6xlUhdkXPbBb4feqZ0J64lOKDm2j+Vy0eFs1B06xHv+jq2P5r50
	SO6eAfHsMeRTKslQdrDUWJwS7ix1iWiCv+1DGdPvLoKjhFKPjF0YvTL1+NGYVfbSpqexrWsliB7
	457t/JdAoFaTQbltZdMrqM5dWc/JujAEnf/LPsh8hF6N/Zhd4xMN3hAxwA8xbV6rhENBZWnz65u
	+v4eCndDQqTfh2kM2ZoxqCZUcEx9zjN6S73UWiljG/FF9vCAfX+BJxzl01IukQn22Fz0Vt070T6
	tOtvCxQ==
X-Google-Smtp-Source: AGHT+IGe2/V/k4PpTXuJNGl/+i3mhT8xlzbiU3E4SpB2neBSdvprsnezlBbn0qsqleRJifV3SDrHAg==
X-Received: by 2002:a05:6a21:6d8b:b0:1f3:33bf:6640 with SMTP id adf61e73a8af0-2207f20ad67mr4404858637.18.1750845651728;
        Wed, 25 Jun 2025 03:00:51 -0700 (PDT)
Received: from localhost ([202.43.239.100])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f125d668sm10708354a12.54.2025.06.25.03.00.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Jun 2025 03:00:51 -0700 (PDT)
Date: Wed, 25 Jun 2025 18:00:49 +0800
From: Jiazi Li <jqqlijiazi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, "peixuan.qiu" <peixuan.qiu@transsion.com>,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] stacktrace: do not trace user stack for user_worker tasks
Message-ID: <20250625100049.GA17376@Jiazi.Li>
References: <20250623115914.12076-1-jqqlijiazi@gmail.com>
 <20250624130744.602c5b5f@batman.local.home>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624130744.602c5b5f@batman.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Jun 24, 2025 at 01:07:44PM -0400, Steven Rostedt wrote:
> On Mon, 23 Jun 2025 19:59:11 +0800
> Jiazi Li <jqqlijiazi@gmail.com> wrote:
> 
> > Tasks with PF_USER_WORKER flag also only run in kernel space,
> > so do not trace user stack for these tasks.
> 
> What exactly is the difference between PF_KTHREAD and PF_USER_WORKER?
> 
I think that apart from never return to user space, PF_USER_WORKER is
basically the same as user space task.
> Has all the locations that test for PF_KTHREAD been audited to make
> sure that PF_USER_WORKER isn't also needed?
> 
No.
> I'm working on other code that needs to differentiate between user
> tasks and kernel tasks, and having to have multiple flags to test is
> becoming quite a burden.
> 
Yes, so only check both PF_KTHREAD and PF_USER_WORKER before access 
user space stack?
> -- Steve
> 
> 
> > 
> > Signed-off-by: Jiazi Li <jqqlijiazi@gmail.com>
> > Signed-off-by: peixuan.qiu <peixuan.qiu@transsion.com>
> > ---
> >  kernel/stacktrace.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
> > index afb3c116da91..82fbccdd1a24 100644
> > --- a/kernel/stacktrace.c
> > +++ b/kernel/stacktrace.c
> > @@ -228,8 +228,8 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
> >  		.size	= size,
> >  	};
> >  
> > -	/* Trace user stack if not a kernel thread */
> > -	if (current->flags & PF_KTHREAD)
> > +	/* Skip tasks that do not return to userspace */
> > +	if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
> >  		return 0;
> >  
> >  	arch_stack_walk_user(consume_entry, &c, task_pt_regs(current));
> 

