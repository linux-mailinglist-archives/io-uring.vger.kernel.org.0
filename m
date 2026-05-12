Return-Path: <io-uring+bounces-13291-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMIZLouEA2ot6wEAu9opvQ
	(envelope-from <io-uring+bounces-13291-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A7368528D26
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5D4AF3024571
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 19:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03A9355F54;
	Tue, 12 May 2026 19:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpFAE5+n"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8E925B0BF;
	Tue, 12 May 2026 19:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615429; cv=none; b=DEMWoe879ScdqBPEn9r97oltNmk87DDX2CwZ28+w+PGaCfxiwbi2A7ewsAWDslttDNtkkYFQ8SV+C5pILoa2mrXy9UBzssmCVJ6i8iQAA/w3vd5spDOTYNaeSA8p+EXikT4aRCe9rffLkPZOTw+x1T4Eel40YcP1hyvTvHzuALk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615429; c=relaxed/simple;
	bh=xD5oHY2kBwY8+xhSB0HxeGN5kHhk+kjkFpw+L/n+UAA=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=rhZKpxQLYnc7pWSP7MkWvY5FaB+nR7WWGd5tpHLBRPZJzRRyIAgo62y4EJv/EFYSag6KILp9oAaHgUg/pSFRc+ginXJmwrm25rb7XhhmhNfWzjI2nbkj6ImcDgadF7Cbon3Iq7HxzxClzdYZ6r2EJL1Ona+8rNisl5qxfYl7wg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpFAE5+n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96E9C2BCC7;
	Tue, 12 May 2026 19:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778615429;
	bh=xD5oHY2kBwY8+xhSB0HxeGN5kHhk+kjkFpw+L/n+UAA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=XpFAE5+nOiJMuNkM76hyYbuko93QEpgS3ZrtbvPGqzoO51aFsMf3gQAm+aY67SSvP
	 Kh7sgIux7XQbbU+2EZPbRDbSDTvHoujyr4ZXFgeQDtQYaKiz/mggCEBEa7Lnd0Rn3V
	 vy5PXtA9xH1O6cC4zIPbYKWD7Ifv7IEV+aG+0iqgOPU2HjBFQzg6AXqlzOyThu09NX
	 wSIwRGI7qmnmT3aAy7DPi3XSFhqYVDnlReoateihdquedEWrEUVqygr90gCMm9uOqq
	 PSI4nFatWgAGB3sNKWReB9jSOPEogwbGkgemj3R+g5x921kwwc0jX9lA03pgWRczrZ
	 CBcT4DX9WZvFw==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/5] eventpoll: export is_file_epoll()
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 brauner@kernel.org
In-Reply-To: <20260503085101.112698-3-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
 <20260503085101.112698-3-axboe@kernel.dk>
Date: Tue, 12 May 2026 21:50:21 +0200
Message-Id: <177861542128.846060.17132431592313870733.b4-review@b4>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=647; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xD5oHY2kBwY8+xhSB0HxeGN5kHhk+kjkFpw+L/n+UAA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQxtzQmP+S5w2Yz16yMZzPTsusNnJ3MjfYH5zx4xfi7q
 HJt7MZ/HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5ycbwT6Hk6MR0v/MVHpJz
 Y299ChQKfrSv1Pr8ohX/o7i8xe8J7Wdk2PTPRLu/8VYgX4N5Q1MdY+as3KmPRVfxupX3rBCaeO4
 BBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: A7368528D26
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13291-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

# Add your code comments below. There is no need to trim or delete
# any existing content -- just insert your comments under the relevant
# lines of code. Lines starting with "> " are quoted diff context and
# lines starting with "| " are comments from other reviewers.
# The final email will be reformatted automatically to include only
# the sections that have your comments.
#
> Make is_file_epoll() available outside of epoll. This is in preparation
> from using it from io_uring.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Christian Brauner <brauner@kernel.org>

-- 
Christian Brauner <brauner@kernel.org>

