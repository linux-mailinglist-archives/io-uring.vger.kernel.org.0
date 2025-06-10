Return-Path: <io-uring+bounces-8306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E45DDAD4463
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 23:05:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CF3E3A5EA2
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 21:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F3B267AF0;
	Tue, 10 Jun 2025 21:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqsJVPik"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4454B267AE3
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 21:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749589499; cv=none; b=IBSIbFFDFkDFvF3jUI8vtIDYCkM8pfaz9Yi/IZ0r4siN/QwxwCJpc61MLZr3n9RZRR3eJyP51ooRhZ248aDpdfy8OjXCcsMT/7LfnB+DoQxg8+zz0IPf7ec4YRAsfziHryJ04kQ7hIWytRuedLw9ljlMqQJpyu64agHrf2ASOJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749589499; c=relaxed/simple;
	bh=CkV77ezpS1Vtxji4e6Sv1e3GGdTNpjSU+/KAlY3Ay5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvZRC3o5QEU81eExzCpjs7ibhMFICCsqwMPA4DV9bHMqsnjG7XbZ4wczz6H19nRbPgOQ4f9t9lDz6HuvOn2Es9wpal8LDRKqd2aYhmeD6z/3OKg3qFSnLFVtNgPe6n3pI4arwSkYC7UIR5cj92Dk9EbOwp4YQVt3qaWg95hXUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqsJVPik; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912BDC4CEF5;
	Tue, 10 Jun 2025 21:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749589498;
	bh=CkV77ezpS1Vtxji4e6Sv1e3GGdTNpjSU+/KAlY3Ay5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DqsJVPik7z0N51s4aR6evXO+Xs7Ri77drpJmGd2MeoSOzkxXzUO/0HYJO/lkvc+4Q
	 KOieUW1S8cQmbfiILouRiXtXYK3WsfhAQnFuLBb7ZnzEyQk7DgvdP8fjLH+Cs1T2zW
	 Gv9QF5ajObmeJdDDqr7Eg5qMBHgjURPWoimhOIJ0eG42nEDURxpnt2kLrA7U2UT4Tr
	 Umtrlx7eH1uKMILUD6kneM4DgXLlFbV/mkjgkXYgdFlJOC/6kc6dcrWt3wGjuxwB7o
	 ZHaAoSRFad4VLKGnM33NtahytzXjdzFS03bL5nU1UazcC7ZjpAETYAd8/H249edZb9
	 QkRMvtnWhfibg==
Date: Tue, 10 Jun 2025 15:04:56 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	superman.xpt@gmail.com
Subject: Re: [PATCH] io_uring: consistently use rcu semantics with sqpoll
 thread
Message-ID: <aEid-Nx11aEPT6Fd@kbusch-mbp>
References: <20250610193028.2032495-1-kbusch@meta.com>
 <c2f09260-46c8-4108-b190-232c025947df@kernel.dk>
 <aEiToYXiUneeNFq_@kbusch-mbp>
 <f0e4a1f5-0571-4a69-afef-e8c845f19f47@kernel.dk>
 <b482578b-3418-4f97-b676-41986630a5ee@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b482578b-3418-4f97-b676-41986630a5ee@kernel.dk>

On Tue, Jun 10, 2025 at 02:52:28PM -0600, Jens Axboe wrote:
> Ah we can probably get by with just a bit more work, something like
> this per section should do it.

Nice, and it clears up the data_race() usage with the assignment and
access both under the sqd mutex.
 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 0625a421626f..8852e104ed68 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -46,13 +46,18 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
>  void io_sq_thread_park(struct io_sq_data *sqd)
>  	__acquires(&sqd->lock)
>  {
> -	WARN_ON_ONCE(data_race(sqd->thread) == current);
> +	struct task_struct *tsk;
>  
>  	atomic_inc(&sqd->park_pending);
>  	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
>  	mutex_lock(&sqd->lock);
> -	if (sqd->thread)
> -		wake_up_process(sqd->thread);
> +	rcu_read_lock();
> +	tsk = rcu_dereference(sqd->thread);
> +	if (tsk) {
> +		WARN_ON_ONCE(tsk == current);
> +		wake_up_process(tsk);
> +	}
> +	rcu_read_unlock();
>  }
>  
>  void io_sq_thread_stop(struct io_sq_data *sqd)
> 
> -- 
> Jens Axboe

