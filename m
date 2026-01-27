Return-Path: <io-uring+bounces-11932-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HntJMqHeGk/qwEAu9opvQ
	(envelope-from <io-uring+bounces-11932-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:39:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2814691D76
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E45A301FF87
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 09:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002BD2E093F;
	Tue, 27 Jan 2026 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqMo1EL8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF995145348;
	Tue, 27 Jan 2026 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506463; cv=none; b=LRq1qDKf1Q8JbXJDK8s/SKR0Zc3nrSVLs80t380huENlEy4QglI0/VDmCQj6pWpTvHNsQBzIxas0Heka/VzCZ+Obf8lg9CwEokT0heEnM+QJ4Zv3168WpOx8ZE2vp4xamwbMQRCF05lWomPSxSIRN9PEK5eH/aWKrU9MI38oclI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506463; c=relaxed/simple;
	bh=Oeqde1iXFjF4bUaS30gl3n5AwzqPTBHOIALHv+J0baA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcBSPda4+cy9B0T+j1/ayyVRVyyPhNzsgojaClVVIRXsZ0J7/i8j588x9rEFVMkcZHo94n+aUUo2MHRtUcbKjfpvm44QKY8XVVVIUdai2sSInuBNAbn8ZHXODOyU2t43SUVL9NH6NHh5laKQv40DgfyD/3XugsHUsm0qiD5V3Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqMo1EL8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E3DC116C6;
	Tue, 27 Jan 2026 09:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769506463;
	bh=Oeqde1iXFjF4bUaS30gl3n5AwzqPTBHOIALHv+J0baA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QqMo1EL8kd5LZQOCimCtbh8gBS29Z8Db1w+fC6wj8BDv9Yj2rQyxW4BKH/C2n9Q7F
	 0pqt52SEZ+DfCbGHQAxvNVbrqA64D2Vt9UAM2Qc2Cqy4Z1IqtEzrMgX2CoHnEC1qQZ
	 xoX3cw051mf5GSq1PMx1ZsuyZ3XGzbHEK6ePQvuMYoLO9nyz+MLp2qT+/kkEHmZwfG
	 jEsrp4oNLj7kZ665ArwWQZ3hy3iYQ8SkObFQUmgeRI5+CJi0pWLPg+XpaMlUajxzjd
	 yHRgQMko6w4WuX7gBWw+5bjaridpMxu0IhhYEMXkxC2uDXF6KW8KqQ8HGNYy9ySQnw
	 rcNAjxS1DpJQA==
Date: Tue, 27 Jan 2026 10:34:19 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, jannh@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring/bpf_filter: add ref counts to struct
 io_bpf_filter
Message-ID: <20260127-strapazen-beziffern-e39606e85f2f@brauner>
References: <20260119235456.1722452-1-axboe@kernel.dk>
 <20260119235456.1722452-6-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260119235456.1722452-6-axboe@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11932-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2814691D76
X-Rspamd-Action: no action

On Mon, Jan 19, 2026 at 04:54:28PM -0700, Jens Axboe wrote:
> In preparation for allowing inheritance of BPF filters and filter
> tables, add a reference count to the filter. This allows multiple tables
> to safely include the same filter.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

