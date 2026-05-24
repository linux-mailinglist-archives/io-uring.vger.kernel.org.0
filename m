Return-Path: <io-uring+bounces-13497-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPZVAnrrEmpt5QYAu9opvQ
	(envelope-from <io-uring+bounces-13497-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 14:13:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 852105C252E
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 14:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E61C30356E3
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 12:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40907395ADF;
	Sun, 24 May 2026 12:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AY6UigMz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB603955DB;
	Sun, 24 May 2026 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779624602; cv=none; b=t2OxVLVwI8I7RVCbm9Gne3SKu94mFwFCrwOgpLt7tvhfCkP2iOoOffjoO3ZifQZLhVlnbseje0yFLYD+9vyt7Q/ZHGm91wywnl5u8CzctXuRGyslux1Qp/mt52LigGYgrkRN+z/0JEZJULV9cqx7tb6v4yBXp7/4ZlOA7SaCGvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779624602; c=relaxed/simple;
	bh=IfzhtYOedGSjoatkdkGxhn7N/mpWTGdAGstC2y/P7Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7e7OAkguxvuMtx5Hq9BAhhOOhAqr+ZIFzM21IAs68YIMn5q64u+aGa6trhePmME5EU2sdqO6s7eX/B9sajoNX/Z7PbRfSHsBjGeGhDPM9klLGHZTPXshBcTFvaE8P6KxboNaFt9X6NAXj/gSVe/jJJotQjs+93gEt6PDSX5kOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AY6UigMz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C7E1F00A3A;
	Sun, 24 May 2026 12:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779624599;
	bh=B/QylLt9HVKlK8T1JVIaY7wYcc2y4/ntSZS0rGmUiwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AY6UigMz/7YvehoynYgZnUaTyudH12tAoZWDzREIJf038fg7qLYIrfXCJKWOUeLC1
	 KBYcOJD1ZvuUZ24e8Yu83z5hKRA31cn8qH0k+muuVc8LrqQLHrWQ2LToJCGBYicCiq
	 0GaYP1YiHuAPLuGT0JoucPncIm2H/Hu7LU3iBlkEbuk3sOPxlXf5x0MCf3K3G1LWBt
	 GpYtNLSIFe/O8UHO9/ysYQIlNdjRwi7xuVLSaIdUY0gg7foiMMHw7T5pyP534dSnlr
	 L/HSHCCPvYwDoWTLjYQQsEvVP+PHAVcBn5fqLqEmugzxYxpsMCkSwmG5bNsk0bcUIW
	 86lby+ZKLXVHQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Li Zetao <lizetao1@huawei.com>,
	Robert Garcia <rob_garcia@163.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15.y] io_uring: prevent opcode speculation
Date: Sun, 24 May 2026 08:09:55 -0400
Message-ID: <20260524-stable-item010b-queued@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520062833.2563847-1-rob_garcia@163.com>
References: <20260520062833.2563847-1-rob_garcia@163.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13497-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 852105C252E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Queued for 5.15, thanks.

-- 
Thanks,
Sasha

