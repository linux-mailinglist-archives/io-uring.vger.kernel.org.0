Return-Path: <io-uring+bounces-273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E30180AF67
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 23:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B89B31F2107E
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 22:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DC258AD1;
	Fri,  8 Dec 2023 22:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7XiswUB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70EE58115
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 22:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C431C433C7;
	Fri,  8 Dec 2023 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702073288;
	bh=L0M8Ljrk48TmGVfwfE56aB+2v/LagH+O2qtc8/HFYEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H7XiswUBlcaaZ/6czcgZlgkOvxzUwWGfdwwHZoKgS6s633ayPzaklnjCogycTKQzz
	 EXAHrhtzozWTdSYIRjM128EdYlLRGVv+OiS8kNRTOuJQgDtzjotdwX4Os1tXtknyRq
	 n5vFGOg8ODmo65pwO7E7NzCkNZRMlFXFoD3B+MIeVTYhkBGKGkfO967pgayh+SE+Pa
	 ziL3oABLzUpxRIhhIxVUuPopvk04AfoSwvJXfJ/xFMlhX++S+SeMqd67L7/AD1XLEZ
	 FwWE/pcfrzDCcJTit3hzTa6zPEHQyjZLaHWbDxD4yNoCV8zRTBYsZoxMRQX3URuErM
	 MhA9iCHpmLa3Q==
Date: Fri, 8 Dec 2023 23:08:04 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/openclose: add support for
 IORING_OP_FIXED_FD_INSTALL
Message-ID: <20231208-rausnehmen-intrigieren-0a3de99f22e8@brauner>
References: <df0e24ff-f3a0-4818-8282-2a4e03b7b5a6@kernel.dk>
 <20231208-leihwagen-losen-e751332ab864@brauner>
 <0fb8b75c-e4cf-427b-bc30-a35d95585e1f@kernel.dk>
 <20231208-dreisatz-loyal-2db8f6e89158@brauner>
 <20e85938-21c6-4c93-a737-a3a4bfc75500@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20e85938-21c6-4c93-a737-a3a4bfc75500@kernel.dk>

> > Meh, new opcode would suck. Don't deviate from the standard apis then.
> 
> Not a new opcode, it'd just be a flag for that opcode. We default to
> O_CLOEXEC is nothing is given, and you can do:
> 
> io_uring_prep_fixed_fd_install(sqe, fixed_index, IORING_FIXED_FD_NO_CLOEXEC);
> 
> to simply set that flag to turn it off. Only reason I bring it up as a
> bit annoying is that it'd be cleaner to have it be part of the O_*
> namespace as O_NOCLOEXEC, but it's not a huge deal.
> 
> It retains the part you cared about, which is making O_CLOEXEC the
> default, but retains the option of turning it off rather than needing to
> do an fcntl() to retrieve flags, mask it, then another fcntl().

Ok, sounds good.

