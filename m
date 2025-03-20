Return-Path: <io-uring+bounces-7152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CEDA6AACC
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 17:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AD2518936C4
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 16:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C351EB9F6;
	Thu, 20 Mar 2025 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="k8+7Yl+L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB263597C
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742487008; cv=none; b=Y3ecPTNP8rPFadtcPVuvYMRbhuM7IvN4bmHb2VuV9JblxT7BHEtofbYahaMUOiEWoWZ574eQCfbznry5TydTywOJNUW29yXoSzuMVqmgGoGbJKX4bAv3tuUS3BeNdJAoHOZWefeg3IeDqHNu9VVNIhRVDdOqbPPRFSlfDIyC50c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742487008; c=relaxed/simple;
	bh=8Cl+MQIg4WHzzZNmEIM+eK5se2qBbKPb4qs91E7rNPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cD8lieo5YdKQ2tuhiZzMSVtPyqz9f8QVLWMeZ3vLQ8WW8DYgMHwQ5aI/MnxsQYXvBkGP/ur8C+BjB29NqdvqHjP2I16CFOMAyjB/kbs/CrbyMza7QjWf8ycQDmQPxRh7fzGPxzQEst5MmtMdJzXsb59w2gQbOd5qL65t8H/8iRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=k8+7Yl+L; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22548a28d0cso26610385ad.3
        for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 09:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742487005; x=1743091805; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qUdUXUFCvJW9zFlXHHcD9YlzbUxFoXXptuBKlu8C0TQ=;
        b=k8+7Yl+LqTgMT6WTJjdwz172vALflx6HRGI+If0ejAcNYQ+dFZodwOldCn+BHITq+p
         7RBfva/6k+MwGGGn8U0HTHrZRC5DJPf5ud14TycLmCX73bXOnCQIvwoY8Yk2o/Nzh7/4
         s/F1Dlak1WisYFHIRvuLYbzZ6QhjtlKZABR78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742487005; x=1743091805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUdUXUFCvJW9zFlXHHcD9YlzbUxFoXXptuBKlu8C0TQ=;
        b=rVbdll5oGql5x88OcNZnVmgcDuhJzBlMKktKKR/FoSbrpimYQCuwLtQQZajoorJ6xv
         V6pg5jB4h0LQIdNBafs3QNIbmfyA4dwPqNuso/joqIgkmtIyF8dXmsO2UuAJkolM0r7E
         FeEPpUwgh/9f/L3wAuMeYcQrjFznWe37qS5NCQ1nK4eARtaVAEfcTY381rr+t6Bla8UD
         6uByqmYC3JH6uCmsBdo/FdRNb8S5PX2uSfWSnpfYDDrgVCAnhFMjCpHA+RrBu9Hm5MTg
         fOysq3HnudHIJCj0T99KhyXTEl1cS6FaIa4J/+BJRlby+gRi2lG9yiEAptNXfC7sMEd3
         Kt0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWOS8fNx0vpunShKZ5JO/MexQbXKAdBSu7pOz0kqcY19EEXRwpR2ZTwYHnEt1BVJTiKPi68hXPBgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnY2pUnapJXJT8DuWEwiorHTAsEkhpDLHxYd+hdBqTjTg1+7hb
	Vw204IPqVte0+Fh8CJ6NuSYn3wQNaxS8pEdWAGryeonLoHjHilWedx4BBKncJQedXMsM+s7WSKj
	v
X-Gm-Gg: ASbGncuDNmrpT0tpDQrNCc/rhDUO2uc3eHoSOIX2rgzteyOs0HIW4/nWr8FM8BeRqfd
	4t63YsEISxDMNNsuQ0HUn87i+EeMUbOLKzSCulA6SLgHigdHDoagjpe7Hi9oR+QxjPQKJ5fq94d
	19Wh7ngK8o2vZIWzvcv2p01tApYeOpznePQibfQz0G1agRcXy/q+jOtd4Jy3rYz830LmLWcv3Cu
	fuSV1dyBo3eW9wNoCQxYr2Vayc4lL5OxyikRM+mfOHA9AIw4SM+yfm8mAjbCygrGY3eP6vCJnZ5
	lWwut5XRvdoI+UNFg9N6vV0UBLH8s5rjoXM298ULxusV0NqJr3ujfkuFqrNwkxUGCCTxRub+4yC
	R
X-Google-Smtp-Source: AGHT+IFkwpk2JEQYn31dAuhvUrxsa+7Xm/Ntb/s0UDsg6lyyXCycmlVUTKPqIReWtnBspXfiHRADZw==
X-Received: by 2002:a05:6a00:22d2:b0:737:6fdf:bb69 with SMTP id d2e1a72fcca58-739059b4d2cmr113077b3a.13.1742487005393;
        Thu, 20 Mar 2025 09:10:05 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73730ca057csm10750423b3a.48.2025.03.20.09.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 09:10:04 -0700 (PDT)
Date: Fri, 21 Mar 2025 01:10:00 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, dsterba@suse.cz,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: (subset) [RFC PATCH v5 0/5] introduce
 io_uring_cmd_import_fixed_vec
Message-ID: <Z9w92CmC51cLN3PD@sidongui-MacBookPro.local>
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <174239798984.85082.13872425373891225169.b4-ty@kernel.dk>
 <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
 <20250319170710.GK32661@suse.cz>
 <4ba22ceb-d910-4d2c-addb-dc8bcb6dfd91@kernel.dk>
 <Z9tzvz_4IDzMUOFb@sidongui-MacBookPro.local>
 <27ae3273-f861-4581-afb9-96064be449a4@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27ae3273-f861-4581-afb9-96064be449a4@gmail.com>

On Thu, Mar 20, 2025 at 12:04:33PM +0000, Pavel Begunkov wrote:
> On 3/20/25 01:47, Sidong Yang wrote:
> > On Wed, Mar 19, 2025 at 11:10:07AM -0600, Jens Axboe wrote:
> > > On 3/19/25 11:07 AM, David Sterba wrote:
> > > > On Wed, Mar 19, 2025 at 09:27:37AM -0600, Jens Axboe wrote:
> > > > > On 3/19/25 9:26 AM, Jens Axboe wrote:
> > > > > > 
> > > > > > On Wed, 19 Mar 2025 06:12:46 +0000, Sidong Yang wrote:
> > > > > > > This patche series introduce io_uring_cmd_import_vec. With this function,
> > > > > > > Multiple fixed buffer could be used in uring cmd. It's vectored version
> > > > > > > for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> > > > > > > for new api for encoded read/write in btrfs by using uring cmd.
> > > > > > > 
> > > > > > > There was approximately 10 percent of performance improvements through benchmark.
> > > > > > > The benchmark code is in
> > > > > > > https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
> > > > > > > 
> > > > > > > [...]
> > > > > > 
> > > > > > Applied, thanks!
> > > > > > 
> > > > > > [1/5] io_uring: rename the data cmd cache
> > > > > >        commit: 575e7b0629d4bd485517c40ff20676180476f5f9
> > > > > > [2/5] io_uring/cmd: don't expose entire cmd async data
> > > > > >        commit: 5f14404bfa245a156915ee44c827edc56655b067
> > > > > > [3/5] io_uring/cmd: add iovec cache for commands
> > > > > >        commit: fe549edab6c3b7995b58450e31232566b383a249
> > > > > > [4/5] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
> > > > > >        commit: b24cb04c1e072ecd859a98b2e4258ca8fe8d2d4d
> > > > > 
> > > > > 1-4 look pretty straight forward to me - I'll be happy to queue the
> > > > > btrfs one as well if the btrfs people are happy with it, just didn't
> > > > > want to assume anything here.
> > > > 
> > > > For 6.15 is too late so it makes more sense to take it through the btrfs
> > > > patches targetting 6.16.
> > > 
> > > No problem - Sidong, guessing you probably want to resend patch 5/5 once
> > > btrfs has a next branch based on 6.15-rc1 or later.
> > 
> > Thanks, I'll resend only patch 5/5 then.
> 
> And please do send the fix, that should always be done first,
> especially if it conflicts with the current patch as they usually
> go to different trees and the fix might need to be backported.

Sorry to forget to cc you Pavel.
https://lore.kernel.org/linux-btrfs/20250319180416.GL32661@twin.jikos.cz/T/#t

Thanks,
Sidong
> 
> -- 
> Pavel Begunkov
> 

