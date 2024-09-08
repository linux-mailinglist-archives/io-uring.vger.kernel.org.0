Return-Path: <io-uring+bounces-3087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7098D970808
	for <lists+io-uring@lfdr.de>; Sun,  8 Sep 2024 16:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C2F21C20FFA
	for <lists+io-uring@lfdr.de>; Sun,  8 Sep 2024 14:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AD31482E2;
	Sun,  8 Sep 2024 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSqy+/+k"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFBB219ED;
	Sun,  8 Sep 2024 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725805007; cv=none; b=l3YOzEjsyhVsKac/K8otvJu8sttC6woMYdVH3N2l8bfWD3sKPHx0E3vCCA8BDyMTG2G1IpbI6DB2voiu2F1BtFRM02KL0JuCla4CwVltm7Ok9YzgJGNHJyEFGMdr06Y8P3oAzQdk+cwHAWqmOkktKFTuYZi4KyZiJ7E4VrTrOf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725805007; c=relaxed/simple;
	bh=pHNcDJMehNmwTcOYCBIameuZ6HiWdQJwHyiKfvLIY8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZPAXy3K5AfJFpDXwB9IuWFBhXUXSYxx2iMe95jl+bk/sKXDkmBiKgam9eAFhjLMELRlAPhnoABiYd79PrxAksf/7VKJB9opolw9pIVKBNQ/H+EqeJEGCRlO5nJQ4tmpO4Y5C9IktJ1DLr0p+93HcX1YleT7ryoQf9zYf/GpR+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSqy+/+k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B5FC4CEC3;
	Sun,  8 Sep 2024 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725805006;
	bh=pHNcDJMehNmwTcOYCBIameuZ6HiWdQJwHyiKfvLIY8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XSqy+/+kdluC1CjQkeYdtNPTUkphQW9laD+Y0PqZXfQELl6u//b5nCnOC3pljdUet
	 WoUieKz59s8IOUk+pQfViI29EdnlQ+K1pSHPlqX8UFXDfsafGfTUAWanYohvcF0d5S
	 VLZvmBCeErNcxwXg9I9wusnZA38QGuWgNFeAk8cw=
Date: Sun, 8 Sep 2024 16:16:44 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org,
	cgroups@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
	dqminh@cloudflare.com, longman@redhat.com,
	adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
Subject: Re: [PATCH][6.1][0/2] io_uring: Do not set PF_NO_SETAFFINITY on
 poller threads
Message-ID: <2024090835-manhood-attentive-c829@gregkh>
References: <20240906095321.388613-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906095321.388613-1-felix.moessbauer@siemens.com>

On Fri, Sep 06, 2024 at 11:53:19AM +0200, Felix Moessbauer wrote:
> Setting the PF_NO_SETAFFINITY flag creates problems in combination with
> cpuset operations (see commit messages for details). To mitigate this, fixes have
> been written to remove the flag from the poller threads, which landed in v6.3. We
> need them in v6.1 as well.

All queued up, thanks.

greg k-h

