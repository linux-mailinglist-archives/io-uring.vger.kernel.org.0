Return-Path: <io-uring+bounces-11930-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JqWF1uGeGmqqgEAu9opvQ
	(envelope-from <io-uring+bounces-11930-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:33:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC87391C4C
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D39EC30157F9
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 09:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA26C2E041D;
	Tue, 27 Jan 2026 09:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXv9/+LX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77EA2C0F7A;
	Tue, 27 Jan 2026 09:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506392; cv=none; b=UVonqXaWUeQmYslhxLcFg4Kg8DfM2WGDfACWrBVluYXwSZXnpKPpm7cna1qPsjHiHqFLuPYCbR/LM+YhaQP0+nyI4Lm3L5ILLKFWpWbSmLg3esPnPUREZfiUofHaflTc/VPyFJjGpfmthoqJnj7+MeeATfCaHnr8Py9UG2LjUt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506392; c=relaxed/simple;
	bh=l7gtfz9wLnqUfZ514EYSJGlTFXP9EmVZMkhQZviu+mU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vz1UXxT/f2JPJ9o46Fo6d1cGLdiGRW5k57NeBPpZuK5dItCaX9kIbwFyNz8/3IAAH1Zr6PHW2ErW+QtXzMRskh7rJgEFdKKz2mb77lJfwHRdU4kOTndTcWNwL8cJv+j3bIAt9lsZvdUD+bk62y1bHbiQWUUJ/UR4b+NUKJXDC5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXv9/+LX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDFAC116C6;
	Tue, 27 Jan 2026 09:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769506392;
	bh=l7gtfz9wLnqUfZ514EYSJGlTFXP9EmVZMkhQZviu+mU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RXv9/+LX0eIJzVRj9yl3B/6ixjTpJCrQMOk9WaFdBwARVvruMnu42KCBJfELoZr9R
	 b1Brrunnwl+DDCy8rqqpsS6OcLpkOSNZHdQIvmvUCJKkJvtFYSfajeG4KGEq/SZxxK
	 5BI8hHPTZhfVvKrAtl0LIBKRWJVANcelg+0hdeTRwBASkH7ayrivSF3SD5+VKtiUnZ
	 /zlo9pE9A+d5UCR67izMrd1+YVMySc8fyoodJQ2+6ihXuW5H99Ao6bsqLR8gx8f24D
	 niV9ZhKwGBPZj8d8DXY2QeVGd4jM/w3HeMTLxNsjFskBDIdxlTNNaqGBseh5ie5kco
	 3oHcdGd3LpAWg==
Date: Tue, 27 Jan 2026 10:33:07 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, jannh@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] io_uring/bpf_filter: allow filtering on contents of
 struct open_how
Message-ID: <20260127-spazieren-jungtier-40a179f972c4@brauner>
References: <20260119235456.1722452-1-axboe@kernel.dk>
 <20260119235456.1722452-4-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260119235456.1722452-4-axboe@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11930-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DC87391C4C
X-Rspamd-Action: no action

On Mon, Jan 19, 2026 at 04:54:26PM -0700, Jens Axboe wrote:
> This adds custom filtering for IORING_OP_OPENAT and IORING_OP_OPENAT2,
> where the open_how flags, mode, and resolve can be checked by filters.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/uapi/linux/io_uring/bpf_filter.h | 5 +++++
>  io_uring/bpf_filter.c                    | 5 +++++
>  io_uring/openclose.c                     | 9 +++++++++
>  io_uring/openclose.h                     | 3 +++
>  4 files changed, 22 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
> index ad6961be5efa..7f468628c491 100644
> --- a/include/uapi/linux/io_uring/bpf_filter.h
> +++ b/include/uapi/linux/io_uring/bpf_filter.h
> @@ -22,6 +22,11 @@ struct io_uring_bpf_ctx {
>  			__u32	type;
>  			__u32	protocol;
>  		} socket;
> +		struct {
> +			__u64	flags;
> +			__u64	mode;
> +			__u64	resolve;
> +		} open;

So openat2()'s struct is extensible and there are plans to extend it to
include e.g., upgrade masks to restrict how a file descriptor can be
reopened. And in general there's the potential that this gets extended
with additional fields. So if it's workable I would add a size argument
in here to communicate to the bpf program what io_uring currently knows
about/is able to filter on. That should be fairly simple and doesn't
require you to change a whole lot?

