Return-Path: <io-uring+bounces-11931-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJrBLniHeGk/qwEAu9opvQ
	(envelope-from <io-uring+bounces-11931-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:38:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CBE91D44
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3B9B300B475
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 09:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36AF26056C;
	Tue, 27 Jan 2026 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyFv8h9L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14A11DDC35;
	Tue, 27 Jan 2026 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506430; cv=none; b=ZP4tvR3UUXz2546PFD7uQgbHRFSFYICc2tI0+vAXirs+lZC08TLjRxs4y1n6JvuHpBqZcmI+1Ly7VjKy0wuuu1P4OlmQx4PHIomR01/GeQGcevuLwmYxDmtLfsbF55y5gyCHr9SbXAkzDIe40+FYHri2oShl4DQt4pMOe548VVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506430; c=relaxed/simple;
	bh=7v214KLPGOQwxE94+hjqWk4Ncb6OG66d8+uQGcySJz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TzK4CvC+GNvao+NLzQyhJNsjQMuqrbRGY2LjqfXUmg8PXVwF3dKAlS8XwP4D472w3bS/65FRkjkJ8o4TWCVo5OTBU/RvGnb7Km/vfhMJiPYZB8yOmCn/5UAZz1JefXi3zYVgapg6bIvDDFF8b80HzWPzhdXseAtlA3iX8lVPMw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyFv8h9L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418AEC116C6;
	Tue, 27 Jan 2026 09:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769506430;
	bh=7v214KLPGOQwxE94+hjqWk4Ncb6OG66d8+uQGcySJz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SyFv8h9LJEqCMT97gtGKiPl5URqE1IFLiuEx7GuvWmn0H+3z0WbMqi0+Ykg94e3L9
	 E/0OJAwYTb+8rashYEQ9+RmbUmG3PYx9xiQgeVO1x+6ACx6CGK2nj6w3YD7f+djNVR
	 /F/Vm38CYNVgr46LNJiJEUzO/cbGdT6avSLCg11BXYQIUPleEArVmUS1qK6krSQChN
	 aZpkxb0xj0M/V8xr+5Bs6jJ6nQ3NGDgL0BMlYBdlQYokb6nV4sUvb7HYeuM5aSyVCy
	 IDIBzKLdGJLG44qBEFi13bhaBNYJyVhG7yexUU61dL27HXbLFv93m4a8Ovum2O9pVd
	 rV578U4kjyDXQ==
Date: Tue, 27 Jan 2026 10:33:46 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, jannh@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] io_uring/bpf_filter: cache lookup table in
 ctx->bpf_filters
Message-ID: <20260127-akrobatisch-couch-5bba9980d78e@brauner>
References: <20260119235456.1722452-1-axboe@kernel.dk>
 <20260119235456.1722452-5-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260119235456.1722452-5-axboe@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11931-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: 14CBE91D44
X-Rspamd-Action: no action

On Mon, Jan 19, 2026 at 04:54:27PM -0700, Jens Axboe wrote:
> Currently a few pointer dereferences need to be made to both check if
> BPF filters are installed, and then also to retrieve the actual filter
> for the opcode. Cache the table in ctx->bpf_filters to avoid that.
> 
> Add a bit of debug info on ring exit to show if we ever got this wrong.
> Small risk of that given that the table is currently only updated in one
> spot, but once task forking is enabled, that will add one more spot.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

