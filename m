Return-Path: <io-uring+bounces-12401-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKw/HKzWnWk0SQQAu9opvQ
	(envelope-from <io-uring+bounces-12401-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:49:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFE618A0DC
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AD63C3065E41
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 16:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759403A9002;
	Tue, 24 Feb 2026 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoPVAeEc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538DF3A9001
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951649; cv=none; b=dbY/dm7RDyMLekKXsJJjI8/MMV0CZlSAJYBHJgoPU+AaGWKk+Pz2IAOO26dk/tG703x7fpb9zRtnfC2Rn+1EJCouob+rpGe06dfqnDXcRtuE6KxrQDeOCkJ++3ZQa9pybZFSfOGawS0u31mZ9Z5C8vglm0ceMFa4Q6DuPY2nvbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951649; c=relaxed/simple;
	bh=sNdlCgiEAxCP4ahus7HXFaJDVIXCiOWiyQ8RdI3+ug4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyrIuaVkhVfX8pGz0a3jN6WMlT+DJICjxc8SMWaBaMoDf5rQQIswKxq5uBJYgXo9uUZXMdoHr13cTBydk790+8qsd3JRdueh/7d924tR4See+zYOr3oj0cOAkMNjtlQ1HfUG4o/VYfwQ2sLVMHbn5r1BjGtcu4Qmcf0eBN3Jq0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoPVAeEc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B26C116D0;
	Tue, 24 Feb 2026 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771951649;
	bh=sNdlCgiEAxCP4ahus7HXFaJDVIXCiOWiyQ8RdI3+ug4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NoPVAeEcBoEQMQOUiDgAnjcY+6XlrjpkYBCIQ2wNMiuYdTKFWWGwbf0tLPEs9oRbL
	 CK45ZAYWGeZ62xGCzkJHToiS2U0LG9vRBAasaGDz9Wo+8hKiFAtNhK3lv98M7FCTPn
	 yWh/8x4bVTIebyT4SVpfDfczrLiwMTZ6UQAAzT/qnugBx08OEMcbDpTNmD7aNo332A
	 n5cNw/MyyHhlnaHtkmduf8KTVkvgY+ZXjFGc0g2UdupiSS07PPOlKFfQXayKS2hkva
	 dA/GR/zfpgcnYknqx25bcNIMmtYghZYpEEmxUMRcDlfVZ+58nMXNhSqZSlpmdf7JPM
	 dWlLW+aaxm44g==
Date: Tue, 24 Feb 2026 09:47:27 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/2] io_uring/timeout: READ_ONCE sqe->addr
Message-ID: <aZ3WH6S7TjyvPd5V@kbusch-mbp>
References: <cover.1771949518.git.asml.silence@gmail.com>
 <8deca9c11a924888d317b4666c93c6ed2e719cee.1771949518.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8deca9c11a924888d317b4666c93c6ed2e719cee.1771949518.git.asml.silence@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12401-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1BFE618A0DC
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 04:12:10PM +0000, Pavel Begunkov wrote:
> @@ -557,7 +557,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
>  	data->req = req;
>  	data->flags = flags;
>  
> -	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
> +	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
>  		return -EFAULT;

Should io_timeout_remove_prep() get the same update? Otherwise looks
good.

