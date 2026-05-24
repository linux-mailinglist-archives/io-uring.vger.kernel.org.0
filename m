Return-Path: <io-uring+bounces-13496-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KF3WNZrqEmpt5QYAu9opvQ
	(envelope-from <io-uring+bounces-13496-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 14:10:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8A55C24BB
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 14:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3AC163003D18
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 12:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2AF3955EC;
	Sun, 24 May 2026 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFphP/mn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8796A35B632;
	Sun, 24 May 2026 12:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779624600; cv=none; b=ilkPKX6Ir1kpgU1+FNVOGs7eVoDMwzbYIdbpPVEwU1m50gv4qZnyMHXF4w3pL0FAORW6nFPET8mTxp7sv0YmUOaBQ4hj91NKfBPe/Ta8G7p4vWkZ2gJNPf5+aVW3JyTAn7BULWW6A9OfIfcQsRmpa4hQlWvh40KL/vweGsOIKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779624600; c=relaxed/simple;
	bh=3HzAmxbHLtK3XRYOD+GQMkne8MWGT7yxsAMYToruO1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkJZrAOLHFhbn4eijzrq5EIPQkHJQDVe3JV3/5AK0wM9nhF0Z1UGdS/eLF/0u1EdDxvphoALGKXVumavuuxt3JkKiNMPB6csGF/vbBC+OybSIgaxp0lOe+C1flE04SsBtZd+fOoEaVZx+tvEZ1A7QvBMu0MMBa5z6y90RTgQOys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFphP/mn; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB1D1F000E9;
	Sun, 24 May 2026 12:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779624595;
	bh=t73p2I3zof5OTdzUFh0Y+Fxp//BaqZzHgLjsEtNLW6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFphP/mnuCu+yAOF/UBWdhtysq7RTxU0LpbYu8vGwe4T8OxOeRgtI//gn5Jw2YfS9
	 O0fKz3VuSn4ZTRCz7kskaHOODc0yCs49cFa7+dciqIFxyDKlqXBU9+V2+NgXOVW6s4
	 jOZz42NiQgmCUsHXvZfg64Q98bxMOtCtsmhiLn4Y+PmJXuwLjavWJRWXOmlQQpTpQz
	 VmzLcHQkbQg0uNPI/69x8/hPIvJL0oH196f0u4iPw4zLEzNChkbqFcRH424qgGfh6f
	 Nnb2h6AtxLTgt3eYRrpBdP3ooVuezvD/+AyHgzCKK7rshbnL3BN6try8VT193L/Ave
	 RjqbWwUMfQ9Hg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Li Zetao <lizetao1@huawei.com>,
	Robert Garcia <rob_garcia@163.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] io_uring: prevent opcode speculation
Date: Sun, 24 May 2026 08:09:52 -0400
Message-ID: <20260524-stable-item010a-queued@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260521054919.87373-1-rob_garcia@163.com>
References: <20260521054919.87373-1-rob_garcia@163.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13496-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,kernel.dk,huawei.com,163.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: BE8A55C24BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Queued for 6.1, thanks.

-- 
Thanks,
Sasha

