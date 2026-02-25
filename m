Return-Path: <io-uring+bounces-12408-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABVGEza/nmn1XAQAu9opvQ
	(envelope-from <io-uring+bounces-12408-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:21:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DA5FB194D5F
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9325C3011795
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 09:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C8C3806D8;
	Wed, 25 Feb 2026 09:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mIH9eEuY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0337419B;
	Wed, 25 Feb 2026 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772010886; cv=none; b=hsrZdI4tSSanEfcIbQmvvTbyqydYPdfaifnTlZ8Pga6+Z3JogHSajxnMVjuhgWiBZXhGCcX5HLEsb4YACRMLAoRWPR9m4O+niPInXng4YmCcg8qVCUbALCRLt05xnPA2jx4uQqMX0f7DFh0SHoxQ6DGT96vzyyzq5KND/RU2VcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772010886; c=relaxed/simple;
	bh=p25+5pv7NVZmKWEKuRjfwdQ6ErbXfWp0m5SN4Bks0XI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqfXilt5jwg6IX+SmHHul4gOPMJvmuy4etJ7MZ55oq2/fhC7L5k61oY+QxxgRgWOndEdSjXJEqAkni1cO8ZAmjqCSoVJbZbtbx2sTWgg4DAJDLyca5n7rLrXMKB+i27QjktuVB/SkRN8z+6GZItomnEe6MZPGTM1fan3VQ4uPqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mIH9eEuY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DEEC116D0;
	Wed, 25 Feb 2026 09:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772010886;
	bh=p25+5pv7NVZmKWEKuRjfwdQ6ErbXfWp0m5SN4Bks0XI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mIH9eEuYj/i0juLEtIdKqUN1r9o8OYN+mDL8pLrD0iulqzOW5IsanB783jYLKRgVm
	 YlLvCPqT+8O6ploD0lHhcQD/zPKsiVZ485zBqPcE+Wzp1NkgYn6vQI2KCf0wxsMYFZ
	 pPxCEcDlPykOs8VxaZdSBztOy/yvBnk5KqBxyX1sgZGh4LcU6K2++eoSlVnmXBb+4L
	 SExM6s6MPLGVP0Xc2AHURmZScuxYzpe6UmV8oEd+EtzNtSHL3lohpf6EEc8UKa2eKm
	 FU9r/Ii1Xxv1gF52gzOprhZ7UF6OE/7/7UIpZoxEoh4+cH9PZK4e/FxNMufbVdfuX9
	 Dkfk8ARplvrlg==
Date: Wed, 25 Feb 2026 09:14:38 +0000
From: Simon Horman <horms@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, asml.silence@gmail.com, axboe@kernel.dk,
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
	almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
Message-ID: <aZ69fs1_OsqkQfQ2@horms.kernel.org>
References: <20260224061424.11219-1-byungchul@sk.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12408-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,skhynix.com,oracle.com,kernel.org,lunn.ch,suse.cz,nvidia.com,infradead.org,redhat.com,davemloft.net,google.com,gmail.com,kernel.dk,fomichev.me,davidwei.uk];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[horms@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,horms.kernel.org:mid,sk.com:email]
X-Rspamd-Queue-Id: DA5FB194D5F
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 03:14:24PM +0900, Byungchul Park wrote:
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Reviewed-by: Simon Horman <horms@kernel.org>


