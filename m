Return-Path: <io-uring+bounces-11843-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iIksJiHYb2n8RwAAu9opvQ
	(envelope-from <io-uring+bounces-11843-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 20:31:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 816704A72C
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 20:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 35077A2B0CD
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED9F34D90B;
	Tue, 20 Jan 2026 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xm220QQE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552C834D4F6;
	Tue, 20 Jan 2026 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928838; cv=none; b=lWosGfGMRPRhGybhcHhjGCGcTgY0yPeOGasRsoyeTJCsfOAH0qUAp08rolizdJMhXnY7AMOIJmgjpPxEipC1ge0HzW4wlIzEar8XM0joOquusTgs0I42XlISFJP6EngHojh32mUps6H9ZJIqxHRU4cvfHoPSDTvd01xTSSmf26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928838; c=relaxed/simple;
	bh=ZPfFdIK7v9EtBydOu/jnCLimg+X7OzRP2hKOXMJQGeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRxBRhuhjMsniXIZEKZMqYrBWEG6VZ1p2NxfFNJgAZaciltQC3JWE88Le4WBVxKN6iBRnm72DJ3xlrQ9+hRuZFVRe0gRmxtmBVFcdChQajmWC5dibawEOQPDK8E3kQnNCF84B5+QUD5CsPaY6PhVsqZN/WFtB0A/TDDEzPowKjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xm220QQE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D5FC16AAE;
	Tue, 20 Jan 2026 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768928837;
	bh=ZPfFdIK7v9EtBydOu/jnCLimg+X7OzRP2hKOXMJQGeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xm220QQEAIGLnhBF0gVMlj9lJ+aHxgzq2jQTCVMcsjfBf3+QQfLkeprGCCoV1mOY2
	 cZ1ghn8M0K1uuhWqrW0ezxL97v7XSY6oUOyK+23vyIvhkMrDE6Rz5hHEScJQMoRm1F
	 N50fuiYEDQnHf/JwfkUECp79W7fzPU+C0CRooa2V8+3keGvyzAvtJEo17jrtRpxDHS
	 230WWqUia86hLvETM89/0oPzd0g0LVSMwO2qh2K6D44/IeH9fvJFFHO47tzodC7hhB
	 E+dRkqyuC0hZ0oGR6k7mSAddIynRD4V72cxMGWmk0gkt/kl6C0hTTeDISQ6FLYJ8Mt
	 IuHM8UOSoQKbA==
Date: Tue, 20 Jan 2026 10:07:15 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH V2 0/2] nvme: optimize passthrough IOPOLL completion for
 local ring context
Message-ID: <aW-2Q9Zv_UNX127Z@kbusch-mbp>
References: <20260116074641.665422-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116074641.665422-1-ming.lei@redhat.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11843-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 816704A72C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Jan 16, 2026 at 03:46:36PM +0800, Ming Lei wrote:
> Hello,
> 
> The 1st patch passes `struct io_comp_batch *` to rq_end_io_fn callback.
> 
> The 2nd patch completes IOPOLL uring_cmd inline in case of local ring
> context, and improves IOPS by ~10%.

Looks good to me. It feels a little unfortunate to have to add this
parameter to the callback just for this one use case, but maybe there'll
be new uses for it in the future.

Reviewed-by: Keith Busch <kbusch@kernel.org>

