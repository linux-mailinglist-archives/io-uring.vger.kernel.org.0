Return-Path: <io-uring+bounces-8297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C338CAD4221
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 20:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CEB0189F165
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 18:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB37219312;
	Tue, 10 Jun 2025 18:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBgRirzm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E89126BF7;
	Tue, 10 Jun 2025 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749581073; cv=none; b=jk4+p745YPw2Ww1nGKrVhGKTGP2r/SthZ5XUoAwiIZRqmOStqE20NgP35JMguQ0o1F92XhXIzCLvCpa3k0hFzEPhTvK3c0o2z42sjlHyyGkWEKyhY4lgN3yu50gJANTwOXdBXvzy6qFABa3sJ6gqL8KR6Ga+dO2qKb9Ll7EZz0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749581073; c=relaxed/simple;
	bh=WkFdBhl00OAvMPH/Upoj7ym0tJBNgtALXYOwZP55BSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVBWtVtydrii1reArT5Mh7PXuF9rNQ7Pm6Hv/OaSKdfBoTlH2M1cYs8Xn5Gp636dW7tjib0yoq4o/Dv3z3k7LPhLtkgHD45kZh+hn8BmmLR1+VXUfpAFCp19sgYAtsyfsLGJ6hwyBwQCF1LcPf8rEME7VDJf5To9KYjLM6o9W5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBgRirzm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A263C4CEED;
	Tue, 10 Jun 2025 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749581073;
	bh=WkFdBhl00OAvMPH/Upoj7ym0tJBNgtALXYOwZP55BSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vBgRirzmyXNJVgMmlyOhEbbclAvZ6iresrSU/uU3THrTDhmcrOvgNh2oTxbGNJrhx
	 hX4urmhe1oEzvwI18Y+jijmxVqiyig/p1ascOaOoqmF0emxS3xkTEgPkRz3s+otM0b
	 EgXeTjUMgaIYU8BwFVDFSItBWt0Zg20J+igOCe80c8JyDfbEjZqnAU3dxQ8a0eY/1i
	 9c6GJqU5PUzXy6E9nZQQoZx8V9vcW5pwY//ClV4B2q4LTZYCopc53xcEyj2jVMu8Aq
	 ibHFPCIcfe3CkeJ+tTsukLV7q4XoTZGquJAYjf1bnGB3/jAHyVx52ShBaubWh/m84D
	 DUPYiPn3VFE/A==
Date: Tue, 10 Jun 2025 12:44:31 -0600
From: Keith Busch <kbusch@kernel.org>
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] io_uring: fix use-after-free of sq->thread in
 __io_uring_show_fdinfo()
Message-ID: <aEh9DxZ0AQSSranB@kbusch-mbp>
References: <20250610171801.70960-1-superman.xpt@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610171801.70960-1-superman.xpt@gmail.com>

On Tue, Jun 10, 2025 at 10:18:01AM -0700, Penglei Jiang wrote:
> @@ -379,7 +380,8 @@ static int io_sq_thread(void *data)
>  		io_sq_tw(&retry_list, UINT_MAX);
>  
>  	io_uring_cancel_generic(true, sqd);
> -	sqd->thread = NULL;
> +	rcu_assign_pointer(sqd->thread, NULL);

I believe this will fail a sparse check without adding the "__rcu" type
annotation on the struct's "thread" member.

