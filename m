Return-Path: <io-uring+bounces-13363-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SAgyBXFBB2oCvAIAu9opvQ
	(envelope-from <io-uring+bounces-13363-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:53:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DE4552704
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B567C3045A21
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198E2366820;
	Fri, 15 May 2026 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gd45DZ1s"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5006B305686;
	Fri, 15 May 2026 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778859934; cv=none; b=ldSCtBzSo/A9W1J+xLn41oSkFO9jFjkJNRQFW3F8cs/vx55iRNFyN8HX0IxLVnwyQ+EvxvCzCCGuPjnd1by7An2iljaLf5hQQBzJiKS/OT/N5ylxoLgLGKBGtMo6ZQDiIKa4a61i94g68HqkfqDBLsobmc8WzvJDoKY/k9SMhkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778859934; c=relaxed/simple;
	bh=/4GLlpJDaba2ZqlHGmRMz4y6aQ8KJ21bj25cclLcadw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWATC//8Zif3QJZTEnWoVvziCxQJ6RuhuvtIEihRNi/jKxcrutuopQRMtVXhVF2lAb2cB/KumLQqIoMgD/FuQGe02GmVG7ZmYAaRnlgTe2Iecqk2WmZvm/v20NE1Dl0A8jYovcPtuePh0sJCXBUFm+7+ax3Dr3U6HAB9rkO1Yr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gd45DZ1s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA80C2BCB7;
	Fri, 15 May 2026 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778859934;
	bh=/4GLlpJDaba2ZqlHGmRMz4y6aQ8KJ21bj25cclLcadw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gd45DZ1sHtXYtJkukpUEV577oFSWpOQ5XtjAHqYFy0emvruyIpW0f2pLnwvbYUiEe
	 4ERbfDJ8IRSz9irx4wjnf1zzzRyW8vH37hQDxWQkYhQNeIGSGbmD4BHVMlCAycmL80
	 iuFa+0A5ayItnZV4kwlOkNEeWWyQUxLkjcP9aqQEbs8Rlto6S6Zw+ux0qdqqIeiGgk
	 diPYs0PdoE/xUDSX/bGOQ+d6MnFQd05PzLeBWId4MufIDc/DFV/Zvn5Bk5D6MC1jEp
	 MCqYgK1eQC9C1wbwoNWXQqHULFtqB875vVVKfTx/q1OsMwSt6H/AbKTXr1BOceQwxf
	 pD3MYf57NZ7MA==
Date: Fri, 15 May 2026 09:45:31 -0600
From: Keith Busch <kbusch@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: propagate array_index_nospec opcode into
 req->opcode
Message-ID: <agc_m0rN3MN7ttAY@kbusch-mbp>
References: <20260515145812.1241925-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515145812.1241925-1-michael.bommarito@gmail.com>
X-Rspamd-Queue-Id: A8DE4552704
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13363-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com,huawei.com];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Fri, May 15, 2026 at 10:58:11AM -0400, Michael Bommarito wrote:
> The compiled change is one instruction (a single mov of the clamped
> byte to req->opcode); the cmp/sbb/and clamp triplet is unchanged.
> No functional change: array_index_nospec() is a no-op for opcodes in
> [0, IORING_OP_LAST), and out-of-range opcodes are still rejected at
> the bounds check above this assignment.  

Since the bounds check above already catches an invalid opcode, why does
it need to be re-initialized to the clamped value? Surely it's already
the same value if we've taken this path, no?

