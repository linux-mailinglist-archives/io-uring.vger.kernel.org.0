Return-Path: <io-uring+bounces-10732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A269AC7C168
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 02:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1F52934EBC0
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 01:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B94D27FB12;
	Sat, 22 Nov 2025 01:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rIT4TU8n"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734B0610B;
	Sat, 22 Nov 2025 01:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763774454; cv=none; b=MGB1/KrOpfLnDNGZbbI6bkU7++dEq+rmcCNAI+7GEvRMG1DyVoE59XBkHw58OxOteWi4VX7QXc2+KngQyH5bprXZb4C9u+5ZwmQ/T+sMpBQ0aZSS9Q1UGgsw1Pu5Nvy9dXtTkWFm9dki8zZcEdfguyrvdHXJsH7wdnHojd21pSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763774454; c=relaxed/simple;
	bh=WtXQ8fU8ffL8uV5h3hbyMMzu0IGX8DPV0a3OKVCs858=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GWl3xQadcZVr1FH9f/do4QptgR4YYXJ6nUL8qOT6KapniXdjh2nWMsQv5Ksg9TU0yX9yGzI4x+ay/3z0tr76GRMMmlwSROsPwp/qonwaz7RpqFvwod+4VI0IQi5T6kjl0DVaxx4Hj2TxrTW9DKlA9SehczBX7SKCO+ecEiyzC84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rIT4TU8n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9068DC4CEF1;
	Sat, 22 Nov 2025 01:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763774454;
	bh=WtXQ8fU8ffL8uV5h3hbyMMzu0IGX8DPV0a3OKVCs858=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rIT4TU8nquhDGEFNOdzTl2BMeiXa7z5obds2CzTNPgp0B/olqxcPHEs1lrjPbXgdq
	 WDbKN0zPW2i4qmoO4+ofPWDYvfltUbnNdiTphbDoF8H30tmtsRjRW+ZpZbLdB0UVVj
	 scs+C05cXphUWISaB6WZGfgYjSiDuNVSUM3O51/Xqnr/REwTLXTHUakGiA3UW0A1xT
	 0E+neO9kpuJpaIgNZ1PVVsDl/EGui6iow+KwSsHjNbF7iLyY5O4K0fYpfvDFagI6Be
	 xYDvwo0DuqmBKvz30HXlW+ulUCp/nhjPuOVNMg3QwqEk2jI3edSZnpUm72qmqA1dK2
	 0UW/Jl5DdW/4Q==
Date: Fri, 21 Nov 2025 17:20:52 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn
 <willemb@google.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, Jens Axboe <axboe@kernel.dk>,
 netdev@vger.kernel.org, io-uring@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH v2 1/3] socket: Unify getsockname and getpeername
 implementation
Message-ID: <20251121172052.225f994d@kernel.org>
In-Reply-To: <20251121160954.88038-2-krisman@suse.de>
References: <20251121160954.88038-1-krisman@suse.de>
	<20251121160954.88038-2-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Nov 2025 11:09:46 -0500 Gabriel Krisman Bertazi wrote:
>  include/linux/socket.h |  4 +--
>  net/compat.c           |  4 +--
>  net/socket.c           | 55 ++++++++++--------------------------------

socket layer maintainers, please review

