Return-Path: <io-uring+bounces-13292-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAZEF6GEA2ot6wEAu9opvQ
	(envelope-from <io-uring+bounces-13292-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7490528D4C
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD79A3049976
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 19:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ECCB2F8E9B;
	Tue, 12 May 2026 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcwovLbk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6D325B0BF;
	Tue, 12 May 2026 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615431; cv=none; b=DglixO4XV3hmRF08v46rLBlBd6dyfwlmUjz4DmZwqXeitfoyn3KLc3sFv5ph4D0Irl5/jC2lBioS3WVHtA7YnugxlOOZ0IPwHkZjGpYjWghIW4cILQ47ugLswj3pcb34fxPy6wBu54N3f+TiVQbP6fOX7W7fRfU6mWj0j+wkSPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615431; c=relaxed/simple;
	bh=quV50xJUF4B89NC6QlxLz3LLOUtCoOoGDD8Yzucw708=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=hBuPc9pp69uPb6j8ispcsWSExy2GYqfKaveHXbLBFHm2ZiQShBythLD5ezAxwaYzMQ5q7otkWQtLUcyyMpyD8biHz1aFrhBkMuho8lOm6F0oQaMqf36A1YnOz6oRMGdZcfdxIM4RuJYa8z+vtpN1bm0YvApGqu6bTSoMdgD/tEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcwovLbk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BD5C2BCF5;
	Tue, 12 May 2026 19:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778615431;
	bh=quV50xJUF4B89NC6QlxLz3LLOUtCoOoGDD8Yzucw708=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=GcwovLbkQGbWIbQ6ipK2ISEhaj74oyEtBBCoUIPtYEK3gGGgn3svyvGe1Kpt8akpN
	 +tlDAJ6TBEhtHpA8RrK8kZDrYtI1rlZGrd+Izv7mfROBXtkBtmwe8jIlVHmygAOBCI
	 UJrGf+jqGBvi9b6MqU2Fr4ZQzyWfkDCFzGzyK4UwMQzlEfZmxJ0n1/ZxU4sygTG4lH
	 +B+BeQerKbieDOJyme7Ok7mcdSwsyQz4LqkEDWxb42/5z0Ut4CwbanSQilDqIuzp+1
	 CgF0XoH9Ryko7XxMgj7ODHLlXw6Xe35JgEwtB5n/PEk84UGNEpWngwRU4kYZXle/Wu
	 +qEcwkeRpu/7w==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/5] eventpoll: add file based control interface
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 brauner@kernel.org
In-Reply-To: <20260503085101.112698-4-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
 <20260503085101.112698-4-axboe@kernel.dk>
Date: Tue, 12 May 2026 21:50:21 +0200
Message-Id: <177861542130.846060.12151691690322065378.b4-review@b4>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=663; i=brauner@kernel.org;
 h=from:subject:message-id; bh=quV50xJUF4B89NC6QlxLz3LLOUtCoOoGDD8Yzucw708=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQxtzTWPixOkpFrcWIsK7e7s+v6z92ntdI6L27mO73N9
 ITyxBP2HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZsoGRYcazEMaZXHdOcttm
 PDXq38lU9l3qd9ea1hrWnv57XQd9HRj+B7w5HzG54pF81blZv2vyXDYL1S8y2G9zaIb87byi/8d
 zOAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: D7490528D4C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13292-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Sun, 03 May 2026 02:49:14 -0600, Jens Axboe <axboe@kernel.dk> wrote:
> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
> index 7bf30e9f90d7..4a6fe989810b 100644
> --- a/include/linux/eventpoll.h
> +++ b/include/linux/eventpoll.h
> @@ -61,6 +61,13 @@ static inline void eventpoll_release(struct file *file)
>  	eventpoll_release_file(file);
>  }
>  
> +struct epoll_filefd {
> +	struct file *file;
> +	int fd;
> +} __packed;

Since you're exposing this in a header now can we please rename this to:

struct epoll_key

This weird {file, fd} pairing is strange enough as it is.

-- 
Christian Brauner <brauner@kernel.org>

