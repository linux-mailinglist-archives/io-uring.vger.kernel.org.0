Return-Path: <io-uring+bounces-10078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A5BBF7C41
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 18:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6036446412D
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 16:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB343393DED;
	Tue, 21 Oct 2025 16:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pr1w1VXe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E85936CE0C
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 16:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761065115; cv=none; b=syb6HYXAJ4J7lFQiADFjQf6PjkjEv93Dep8ONX1EgIGUJ1y9pGgc5AotazwTZA3Dj1/cax6QR72AU5LVjvEc4Xyw+Hp8fh0igpgCax7tHjFi9FNqhg3Ftg/pQViCS/A+4RO2VSHAgrDk+1gxYzZpePvtI8VQX87AiVfgyXr3yIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761065115; c=relaxed/simple;
	bh=Z7aYf6EKKYfENasdtuGG37tfXe606jsfz5z0Mj7YNz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4TbyO4OWrKMDq9TKxKTUGisJCZbAjJQ2wPVlcrOiz5GBYjTJ3Wnyrez44F5WUWB4xo7sxq1M4pGAIDzII6A6R8Wm80hjX9aAD9e3PHyg1XCGFqInbeHPaAUk+M2gdmzSxG5V8mvui8rP1Q/xf6uUFWYl3H+wYWCYQQoWds8etQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pr1w1VXe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1743C4CEF7;
	Tue, 21 Oct 2025 16:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761065114;
	bh=Z7aYf6EKKYfENasdtuGG37tfXe606jsfz5z0Mj7YNz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pr1w1VXeldIhjIT+aTf8804x9Lhr8+2fzBagiKzWLDfmFXU90EKNhpPFb7NpfsYgc
	 RlOHoeeUz5SusTEfP6dbP+dOiYzPzrCKkH44OsZQv8qARBJo/KJ4O3rvxOJ0IlyuxF
	 RRqyl5dicFpK0IizBiN/KkG5hYBTIO3C+doMqpDJRDqy2qCqcrp+hHQ+KAlTd0gYSL
	 vx2jKuzznqsdEvDLh0F0/MQMVMYnWvYDMD+LQ9ZBR1zlWz2EMbs5z/JVyKCMrZQ967
	 rMs5z8lAvwCBYMB8wr61W7OSjPJF0fCorH9rOEm9X4tLYWmFDD4xscALe0jv4TqAu1
	 h7yC54myr53Kw==
Date: Tue, 21 Oct 2025 10:45:12 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	axboe@kernel.dk
Subject: Re: [PATCHv5 1/4] liburing: provide uring_cmd prep function
Message-ID: <aPe4mOU56C_dh2ky@kbusch-mbp>
References: <20251013180011.134131-1-kbusch@meta.com>
 <20251013180011.134131-4-kbusch@meta.com>
 <CADUfDZp-6s8QYAoeikMG98MhvfsZ0V-Vu_EGVoHUhthM=xth6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZp-6s8QYAoeikMG98MhvfsZ0V-Vu_EGVoHUhthM=xth6Q@mail.gmail.com>

On Sun, Oct 19, 2025 at 09:24:10AM -0700, Caleb Sander Mateos wrote:
> On Mon, Oct 13, 2025 at 11:00 AM Keith Busch <kbusch@meta.com> wrote:
> > +                                          int fd)
> > +       LIBURING_NOEXCEPT
> > +{
> > +       sqe->opcode = (__u8) IORING_OP_URING_CMD;
> 
> Casting the constant seems unnecessary. Do compilers really warn about this?

Oh, not necessary here, but the next patch wants the cast. This was
copied from io_uring_prep_rw(), which passes the 'opcode' as an 'int'
type. I don't know why that type was used, so just trying to match the
local convention.

But I digress, I'll move the cast to the next patch where it is actually
needed.
 
> > +                       io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, use_fd);
> 
> I guess this works because io_uring_prep_uring_cmd() doesn't touch
> sqe->buf_index or sqe->flags, but it seems like it would be less
> brittle to call io_uring_prep_uring_cmd() before setting any of the
> other sqe fields.

Good point, it happens to be "okay", but is safer to move the generic
init before initializing command specific fields.

