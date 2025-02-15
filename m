Return-Path: <io-uring+bounces-6475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0161EA37015
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 19:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E7A57A408E
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 18:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291581EDA0E;
	Sat, 15 Feb 2025 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXr/7X1p"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F42351519A7;
	Sat, 15 Feb 2025 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739642883; cv=none; b=RhLP1fm8ZWaOOQLDogqQze9DSwNps+CX/HKuD21ctwtM7lhPXNWo+F2w5itNoLBTijzdDygu/SfIonKGr3vfKkTOaZIc4wC42rzTN/xM/cpQsrAQR0jQijl8WhIAZL10n31gChlk7bbunQK7N6YskwHKXl6KrN3n2faJ/uczwSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739642883; c=relaxed/simple;
	bh=uiRfLLSaYQVkerqiILMl8NyR1In0oQ7gCwBgazDEXPg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwwzhSSP+WR3M74PkVpPGsvpa1VqnaBin7th4e+AOMSJRUE2jTeb3vJaCobPpzFi7gWzvze3xrZ0XzI563n2CwhV2IG0OfjhoA2DpQXKYpaM8gYFqSzXzLb5eix5YMi/zNnZdSedvdRgatl1Ue/MFIXc9+r7WyR3A8zYlOX2cZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXr/7X1p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EB9C4CEDF;
	Sat, 15 Feb 2025 18:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739642882;
	bh=uiRfLLSaYQVkerqiILMl8NyR1In0oQ7gCwBgazDEXPg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eXr/7X1piMBCdIwrRutJpJ/AmPSY5lPTLSCj8mLn+YlPY2AfLRikJrbAbFkgxBxPB
	 mvpCheIFNQLIZ9kbtqjmcsR9Urx3DkApryqs35O8kRWP1PemwBU5WFZwJFoKYr4MtO
	 hR7yezDxmpvMT/KoxpwA/eAPEQOAEzXBs+6sL8byMeZr6+VmbI7hfdwb2mOt1SMaie
	 X6SSSZqtqABeeoT2jlt+PATq+43yXUYkDr/esJsix0Yy+5/eBF37QchiGa4v4cgMhU
	 m2aFWI4Xjba0MD3l2Chf9If7p0vTGKEPbkHVm1K15QDe/YHVD5l4mSyKd0QBNT4Xcf
	 X5qk6dh0kgGSQ==
Date: Sat, 15 Feb 2025 10:08:01 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>, lizetao <lizetao1@huawei.com>
Subject: Re: [PATCH v14 00/11] io_uring zero copy rx
Message-ID: <20250215100801.22c6fb39@kernel.org>
In-Reply-To: <20250215000947.789731-1-dw@davidwei.uk>
References: <20250215000947.789731-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Feb 2025 16:09:35 -0800 David Wei wrote:
> This patchset contains io_uring patches needed by a new io_uring request
> implementing zero copy rx into userspace pages, eliminating a kernel to
> user copy.

Acked-by: Jakub Kicinski <kuba@kernel.org>

