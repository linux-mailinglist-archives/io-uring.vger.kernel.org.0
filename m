Return-Path: <io-uring+bounces-8299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F245AD42AF
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 21:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5102B189C99E
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 19:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45272245014;
	Tue, 10 Jun 2025 19:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pyH3fla5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD7617597;
	Tue, 10 Jun 2025 19:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582774; cv=none; b=REtNbVh5in66Vofe8bSQOEZWZVI5RP6CwOTFUTW9ZxIO6KqPvMRTMWpYfJJSla8k9J4kb23KrGKcCHErI3tr4iFptqayWxhnz6gtjex+fzy1NMp6vc3hKOPTHgFuwaJiBCxQnb63Rmzdu9FqjXP0xRn6pOPC93fbGmU9eOaAHbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582774; c=relaxed/simple;
	bh=wz++l1yaux2JnXexyUIdq0mIG5nKuIU+1yPGLalEFBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8gDV+PdfqjKXzDYahWu9H0RFn85RDGYbcRmGSsSbY+Clwa+comwkqWBvAti4JkRjAaALknBMQdoJ8f/tdbupTt2CZa2aqBVb5HE2lhQ/ni1nnsq7y6r7xftjL0UOmTJyYbO9RrdBmmVbyrQ2fogwTNxzbP3kMaKldLyRyjAmcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pyH3fla5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F97C4CEED;
	Tue, 10 Jun 2025 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749582773;
	bh=wz++l1yaux2JnXexyUIdq0mIG5nKuIU+1yPGLalEFBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pyH3fla5fwi/sdBTPciXVxga/2QyRQlf4Ux0EVcJcQWbZysOGgGSh7WCuV58sOTRa
	 sigjvkhe0Ev44L+PfetMGbtIAkXoUiN1hujD4eDQWGM3D2qZ+qnGLS9ptTx0f9dGiA
	 VFbpPPGQPNdvh/k3X40hEvyIuTZOXEOYfplmpPLDT72aTev1LmAAfX0CztkQ+lBGyW
	 iV5AmDrcrelep707E5jEhovEU9wIIlGZi8Qc4AX2Ym+7Axn8PrGnmrv94v22BX/Yi0
	 z9FkJrII4BR6mWx+9cajZEsr46FS1iLKbTwuG2BbH9EGkD8d38hoCYBkL0KH6GX5/q
	 Zk4qaZT/ymgEg==
Date: Tue, 10 Jun 2025 13:12:51 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Penglei Jiang <superman.xpt@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] io_uring: fix use-after-free of sq->thread in
 __io_uring_show_fdinfo()
Message-ID: <aEiDs5J3Uy3NSK3m@kbusch-mbp>
References: <20250610171801.70960-1-superman.xpt@gmail.com>
 <aEh9DxZ0AQSSranB@kbusch-mbp>
 <48f61e8e-1de6-4737-9e58-145d4599b0c0@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f61e8e-1de6-4737-9e58-145d4599b0c0@kernel.dk>

On Tue, Jun 10, 2025 at 12:56:31PM -0600, Jens Axboe wrote:
> On 6/10/25 12:44 PM, Keith Busch wrote:
> > On Tue, Jun 10, 2025 at 10:18:01AM -0700, Penglei Jiang wrote:
> >> @@ -379,7 +380,8 @@ static int io_sq_thread(void *data)
> >>  		io_sq_tw(&retry_list, UINT_MAX);
> >>  
> >>  	io_uring_cancel_generic(true, sqd);
> >> -	sqd->thread = NULL;
> >> +	rcu_assign_pointer(sqd->thread, NULL);
> > 
> > I believe this will fail a sparse check without adding the "__rcu" type
> > annotation on the struct's "thread" member.
> 
> I think that only happens the other way around, eg accessing them directly
> when marked with __rcu. I could be entirely wrong, though...

I was just looking at rcu_assign_pointer():

  #define rcu_assign_pointer(p, v)                                              \
  do {                                                                          \
          uintptr_t _r_a_p__v = (uintptr_t)(v);                                 \
          rcu_check_sparse(p, __rcu);                                           \

And rcu_check_sparse expands to this when __CHECKER__ is enabled:

  #define rcu_check_sparse(p, space) \
          ((void)(((typeof(*p) space *)p) == p))

So whatever "p" is, rcu_assign_pointer's checker appears to want it to
be of a type annotated with "__rcu".

But I don't know for sure, so let's just try it and see!

  # make C=1 io_uring/sqpoll.o
  io_uring/sqpoll.c:273:17: error: incompatible types in comparison expression (different address spaces):
  io_uring/sqpoll.c:273:17:    struct task_struct [noderef] __rcu *
  io_uring/sqpoll.c:273:17:    struct task_struct *
  io_uring/sqpoll.c:383:9: error: incompatible types in comparison expression (different address spaces):
  io_uring/sqpoll.c:383:9:    struct task_struct [noderef] __rcu *
  io_uring/sqpoll.c:383:9:    struct task_struct *

