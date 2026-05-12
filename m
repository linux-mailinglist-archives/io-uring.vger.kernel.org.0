Return-Path: <io-uring+bounces-13289-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDMTGoaEA2ot6wEAu9opvQ
	(envelope-from <io-uring+bounces-13289-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB60A528D1F
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1060A30477F4
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 19:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8852D350A05;
	Tue, 12 May 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxWYI2wc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6597F2F8E9B;
	Tue, 12 May 2026 19:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615427; cv=none; b=I3AFTaG/V1QVa93F5qMdDd5cwwZP9gDeaDAKiHKOJAS4/QOOgODl9j5ujjhFQ6K3HENH8KaLSRJiQm0dHwoLYYpLzNiGQL0EmKhH4QsOOgrjgMJyPuCbwPBkue/S0tzwwiwc80Bf7hOesaSzIDZmI/OA/JzRI46DU3dgzZXeUrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615427; c=relaxed/simple;
	bh=yutGWzZd9bLDvk3hSnpaLW1RsRfw1eEooO3Xgdh5p/4=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=ELUeBUCJIHnXzPkPNybwNPJIDW3Qn534VKhNMi31oM6zG/V11vijgBElUunaK3fg2CXRNLyLyjkTpC1ISXd+9/TOVNOT8RhGGQvMT9+jkUU7m0+SRfyzLJplKzrD0r3FMKa1ZTuiR3OmSXoP1jzMZzfnbqW8cVxNcnX+GdQBZxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxWYI2wc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA92C2BCB0;
	Tue, 12 May 2026 19:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778615426;
	bh=yutGWzZd9bLDvk3hSnpaLW1RsRfw1eEooO3Xgdh5p/4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=LxWYI2wcmcAj3wsEt6gVenl8qdmJHQ4uApP2ikXfTxbyeUefQsTsh64rFYNYbiwsK
	 4vnMXe3eXXB39BmNoCv2W4e5Su/+0HLtFAdZUSp0eQR2Ded8ow1eZ8yLFY2rlv9KEo
	 q/eIErxDixtjVO2p6nlzoWN8UFakuybzC8B3oAzXDdyrogocCDThtLllJHggv5LqY/
	 7zxuBnUnaSz1XCLN/Cze4swZgd8iVS4P49Cv0/ypGbeckCWkVaPdQGIK9gq8poo+L2
	 AAfWOnDkF2YrCcJckdQiygXPWi6N0u4aX18cqVeWGY1abHoweGfoga7lqDXGLLA6f9
	 OwqCQ2bu87quw==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCHSET 0/5] io_uring related epoll cleanups
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 brauner@kernel.org
In-Reply-To: <20260503085101.112698-1-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
Date: Tue, 12 May 2026 21:50:21 +0200
Message-Id: <177861542127.846060.15247420422293788438.b4-review@b4>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=690; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yutGWzZd9bLDvk3hSnpaLW1RsRfw1eEooO3Xgdh5p/4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQxtzQGzm6ueuIdlh9aJiR9pW5yO1ugxNurJ+5tlG88E
 pm4UqKro5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLlaowM59Oa+3M+cR0M+OpY
 sXzaSr75bRsU2WS2dmxfsSy1Qfq4AcP/4NWH97+KdZ4t1nO5sHbG7rNi13rXnS4LZrhsVqF10iu
 SBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: BB60A528D1F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13289-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Action: no action

On Sun, 03 May 2026 02:49:11 -0600, Jens Axboe <axboe@kernel.dk> wrote:
> Hi,
> 
> One of the nastier things about epoll is how it allows nesting contexts
> inside each other, leading to the necessity of loop detection and the
> issues that have come with that.
> 
> I don't believe there's any reason to support nesting on the io_uring
> side, in fact IORING_OP_EPOLL_CTL is a historical mistake, imho. But
> let's at least try and contain the damage and disallow nested contexts
> from our side.

I can stuff the epoll preliminaries onto

vfs-7.2.eventpoll

which is where the refactor I did lives and you can just pull it.

-- 
Christian Brauner <brauner@kernel.org>

