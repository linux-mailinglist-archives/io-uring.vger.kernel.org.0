Return-Path: <io-uring+bounces-11991-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHigHpA9fGkxLgIAu9opvQ
	(envelope-from <io-uring+bounces-11991-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 06:11:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C68AAB737A
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 06:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B34C33004607
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 05:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E4733A9DE;
	Fri, 30 Jan 2026 05:11:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81AB33ADB2
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 05:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769749899; cv=none; b=jb46X7brEtn4+BSTRqT6TNuCV3xnriBT5tv7a0H26ccUdZUKQpsZFAjkKJhw016TB2Ujikokd9sHTyev1BXHZVxAsSzhZy1gSyFEJm6Kz+7wtWM887I37+Jp4EazoIFUELEabOu0OzpKrmusIBgAJXF49E+1EuM0hPGl8gaAxaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769749899; c=relaxed/simple;
	bh=8v2K594m3KmE92hW0yfTHjh+VNLNnc6wqO7vIS1f394=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFlq95TJ4v1yLxNDONnIgrsyoSurryMeShCVaadLeAoTJGDo5rmpRelBJOhgj3tbRL9wMVlA21b/oe3Tzy5NHV5yN1SOGW4TDOovwy9aelR0i4CPQdsCouPxDfA96dYtIyLAVSotou76ykDAG3fNF7JmCf17vZ47hJV7CL3mo2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8ACBC68AFE; Fri, 30 Jan 2026 06:11:26 +0100 (CET)
Date: Fri, 30 Jan 2026 06:11:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Govindarajulu Varadarajan <govind.varadar@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, ming.lei@redhat.com,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, miklos@szeredi.hu
Subject: Re: [PATCH 1/2] io_uring: Add size check for sqe->cmd
Message-ID: <20260130051125.GB32492@lst.de>
References: <20260129201347.411015-1-govind.varadar@gmail.com> <20260129201347.411015-2-govind.varadar@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129201347.411015-2-govind.varadar@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11991-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid]
X-Rspamd-Queue-Id: C68AAB737A
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 12:13:46PM -0800, Govindarajulu Varadarajan wrote:
> -	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
> +	const struct ublksrv_io_cmd *ub_src = IO_URING_SQE_CMD(cmd->sqe, struct ublksrv_io_cmd);

As Jens already said, no need for the shouting.  Also please break the
lines to keep things readable.

> -static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
> -{
> -	return sqe->cmd;
> -}
> +#define IO_URING_SQE128_CMD(sqe, type)	({						\
> +	BUILD_BUG_ON(sizeof(type) > ((2 * sizeof(struct io_uring_sqe)) -		\
> +				     offsetof(struct io_uring_sqe, cmd)));		\
> +	(type *)(sqe)->cmd;								\
> +})
> +
> +#define IO_URING_SQE_CMD(sqe, type)	({						\
> +	BUILD_BUG_ON(sizeof(type) > ((sizeof(struct io_uring_sqe)) -			\
> +				     offsetof(struct io_uring_sqe, cmd)));		\
> +	(type *)(sqe)->cmd;								\
> +})

I'm also not sure adding a BUILD_BUG_ON to every derefence is great for
compile times.  But I'm not really sure what would be a good other
place for it.


