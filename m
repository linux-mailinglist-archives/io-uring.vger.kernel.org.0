Return-Path: <io-uring+bounces-9874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5809B9AC76
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 17:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76A7A3A8926
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 15:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A733126D0;
	Wed, 24 Sep 2025 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sHptJ7YI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00873115A1
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758729249; cv=none; b=NRzgy6MPa8rOnl7qGejeQlPF/SaVDa9YGu82tgN6ocQzOTdQkkN/Vqja0dmIx1kqa/9E/qCpxHAAB/P+NHW0y3bGM6s8wj3MPCniCxtBJllMz7lcVS3kJgVBDbx79EI8AlcOP5URF4ndKpNBJ+L9eBXmT97PbGKzah3DUNN1eis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758729249; c=relaxed/simple;
	bh=hT5rpDXaC25omgBKnhBmLUolkFHxc2Agy6fqDLOdJRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCswpldIC35ghLyBMh/2NvdYcLRPPXITCElHd+n0cHanWtlzjTa5UjWFvFKwxd2POvVry2S+pkXD/Nn6q0QQiIbL54jUx7DdK3DYtiRlFwAp63N+FuICjGXcJVfpOPh+h779sGbTwvW9Fn9Jg58wp6W44i4R09tGED6TpqHUY9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sHptJ7YI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43100C4CEF0;
	Wed, 24 Sep 2025 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758729249;
	bh=hT5rpDXaC25omgBKnhBmLUolkFHxc2Agy6fqDLOdJRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sHptJ7YIANxHykknNyfhv/YScJ5Q/8pUynAKxcHGrjH6tngKQ+WdbuQz5eJgnf/31
	 S/BjiYolRC2LVROkVdGrRvvIXCslNqzxah2TKIzxG7xIDZDY3/kWV+IZt5tqjk32nO
	 1geyOxSaoTKJkenMjOpsj20gxHm3xmR6Tvr3fyuG2KzNI91nFEEspTDQo0X945jFQ8
	 Z0peQqgOgUkboyR5ayF12qGuKcoNP5dpwrw45DVOe13/C4zsVCK9AgiQ0/9dJgFJW9
	 0Eb6xvpCBVbEtrj0kCWzOJbjaqVh46GLG0PrCsYRL4aIeRr0RdIDqf06oKt8APG88Q
	 BnMVyYvPiXTfw==
Date: Wed, 24 Sep 2025 09:54:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, csander@purestorage.com,
	ming.lei@redhat.com
Subject: Re: [PATCHv3 0/3] io_uring: mixed submission queue size support
Message-ID: <aNQUH1KBWwcWc_V_@kbusch-mbp>
References: <20250924151210.619099-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924151210.619099-1-kbusch@meta.com>

Resend for missing subject... I keep pointing to the wrong directory
after merging the liburing and kernel cover letters.

On Wed, Sep 24, 2025 at 08:12:06AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Previous version:
> 
>   https://lore.kernel.org/io-uring/20250904192716.3064736-1-kbusch@meta.com/
> 
> The CQ supports mixed size entries, so why not for SQ's too? There are
> use cases that currently allocate different queues just to keep these
> things separated, but we can efficiently handle both cases in a single
> ring.
> 
> Changes since v2:
> 
>  - Define 128B opcodes to be used on mixed SQs. This is done instead of
>    using the last SQE flags bit to generically identify a command as
>    such. The new opcodes are valid only on a mixed SQ.
> 
>  - Fixed up the accounting of sqes left to dispatch. The big sqes on a
>    mixed sq count for two entries, so previously would have fetched too
>    many.
> 
>  - liburing won't bother submitting the nop-skip for the wrap-around
>    condition if there are not enoungh free entries for the big-sqe.
> 
> kernel:
> 
> Keith Busch (1):
>   io_uring: add support for IORING_SETUP_SQE_MIXED
> 
>  include/uapi/linux/io_uring.h |  8 ++++++++
>  io_uring/fdinfo.c             | 34 +++++++++++++++++++++++++++-------
>  io_uring/io_uring.c           | 27 +++++++++++++++++++++++----
>  io_uring/io_uring.h           |  8 +++++---
>  io_uring/opdef.c              | 26 ++++++++++++++++++++++++++
>  io_uring/opdef.h              |  2 ++
>  io_uring/register.c           |  2 +-
>  io_uring/uring_cmd.c          | 12 ++++++++++--
>  io_uring/uring_cmd.h          |  1 +
>  9 files changed, 103 insertions(+), 17 deletions(-)
> 
> liburing:
> 
> Keith Busch (3):
>   Add support IORING_SETUP_SQE_MIXED
>   Add nop testing for IORING_SETUP_SQE_MIXED
>   Add mixed sqe test for uring commands
> 
>  src/include/liburing.h          |  50 +++++++++++
>  src/include/liburing/io_uring.h |  11 +++
>  test/Makefile                   |   3 +
>  test/sqe-mixed-bad-wrap.c       |  89 ++++++++++++++++++++
>  test/sqe-mixed-nop.c            |  82 ++++++++++++++++++
>  test/sqe-mixed-uring_cmd.c      | 142 ++++++++++++++++++++++++++++++++
>  6 files changed, 377 insertions(+)
>  create mode 100644 test/sqe-mixed-bad-wrap.c
>  create mode 100644 test/sqe-mixed-nop.c
>  create mode 100644 test/sqe-mixed-uring_cmd.c
> 
> -- 
> 2.47.3
> 
> 

