Return-Path: <io-uring+bounces-7907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F36EBAAF3D1
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 08:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD5817BA952
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 06:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8021EE03D;
	Thu,  8 May 2025 06:37:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8921A8F84
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686248; cv=none; b=bK7P7ZdLgt0aNSAAaQ0ewNo3WDpMEr2GlI0vEHS9pbk4K3tF59/0kub5+qBMx5sLQUuTv6lcCFcrvzfIsJ/acIwpHmDii+Etl0juuhYqhue0fKX1HJkmdLsGsSucnebP+C9mtcrugFiHMsnp/OidredyWGw/IOSyRXDH9cNM29M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686248; c=relaxed/simple;
	bh=BpdyRPzWyshNO/A0zLN7/iY4irJzrMscj6dqp0SKPjY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THnkjhQXrYXCHVsQft5WW2xEbAr9f3iJ01xKB+5k5zi2D8h012B8ugIQ/kqDAq/Q3EWaGvlh71slQUUeb0NJ/KbMvU4M1s/rRSMEx1+3JKIyJi+x/wSQA9/tMsJxS77OBJ0tLGWStgc5un0xyogPfcKLl0ZU8DvQNaMeOg9adjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZtMpQ1rJVznffG;
	Thu,  8 May 2025 14:35:58 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 68898140258;
	Thu,  8 May 2025 14:37:16 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 8 May
 2025 14:37:16 +0800
Date: Thu, 8 May 2025 14:26:09 +0800
From: Long Li <leo.lilong@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>, <leo.lilong@huaweicloud.com>,
	<axboe@kernel.dk>
CC: <yangerkun@huawei.com>, <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: update parameter name in io_pin_pages function
 declaration
Message-ID: <aBxOgeZS7UlI3SSd@localhost.localdomain>
References: <20250425113241.2017508-1-leo.lilong@huaweicloud.com>
 <92a8fd11-ddd8-4ab3-a983-ff5c4cedefc2@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <92a8fd11-ddd8-4ab3-a983-ff5c4cedefc2@gmail.com>
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Apr 25, 2025 at 12:47:00PM +0100, Pavel Begunkov wrote:
> On 4/25/25 12:32, leo.lilong@huaweicloud.com wrote:
> > From: Long Li <leo.lilong@huawei.com>
> > 
> > Fix inconsistent first parameter name in io_pin_pages between declaration
> > and implementation. Renamed `ubuf` to `uaddr` for better clarity.
> > 
> > Fixes: 1943f96b3816 ("io_uring: unify io_pin_pages()")
> 
> I'm split on whether such patches make sense, slightly leaning
> that they don't, but regardless, why is it a fix and which
> problem exactly does it "fix"?
> 

You're right - this is not actually a "fix" as it only changes a parameter
name for consistency and clarity. I'll resend the patch without the fix tag.

Thanks,
Long Li

> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >   io_uring/memmap.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/io_uring/memmap.h b/io_uring/memmap.h
> > index dad0aa5b1b45..b9415a766c26 100644
> > --- a/io_uring/memmap.h
> > +++ b/io_uring/memmap.h
> > @@ -4,7 +4,7 @@
> >   #define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
> >   #define IORING_MAP_OFF_ZCRX_REGION		0x30000000ULL
> > -struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
> > +struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages);
> >   #ifndef CONFIG_MMU
> >   unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
> 
> -- 
> Pavel Begunkov
> 

