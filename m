Return-Path: <io-uring+bounces-12810-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OF00Heq/wWlSWAQAu9opvQ
	(envelope-from <io-uring+bounces-12810-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 23:34:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 482952FE49C
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 23:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F8EF3055109
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 22:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9632137F729;
	Mon, 23 Mar 2026 22:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UE3wkJoQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C5535AC2D;
	Mon, 23 Mar 2026 22:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305155; cv=none; b=B/QqdlJ0f9h0KY26yOECqKkoCGtXqJRQmiQ6wT1GQYZhl5nckrs6S1eT+JPOfAwBhrhVn5e3/kF6BKE85yr9GKKlEECfQa6mZxRFz9H6cJ0lf9DGTfxLN9q0QX+V0/DRr3CmaGiQJJBMMvWhfpxuizWjusYtm+9x6n3oHr2SRMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305155; c=relaxed/simple;
	bh=TWBc2VswkxrIugCmPUsSjvAQATsEjGyfm2GbdqMcisI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZaCndbiYgX4l+722koXcZIR/dMt9SCCsm0iwZGwB4Q8H9sxFiqfn0v5TS9zZOYLhubHbi0UnTZv/XNBaWYyQ1qhQFhLlhsHTNDLZq60AOc9+kdMv2qtMzW78KvOwPZ4nKbLtoTcF+rWBvuJpoguQtzZnDXy9zbB6rYo8xFUUT9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UE3wkJoQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444DCC4CEF7;
	Mon, 23 Mar 2026 22:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774305155;
	bh=TWBc2VswkxrIugCmPUsSjvAQATsEjGyfm2GbdqMcisI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UE3wkJoQu5IBL2+lvYpZMIL1ReS2cmqQWndNlC4/IkejYebe96jAtR+XgYgweBi2k
	 8jwwmhq6ksAQXF2eZfSk8g9B8jF7+TsBwvBWz9MPuhNsdoUNamvZ/Ja4JODLh9Iqrk
	 ZEPDkVdc2vBV72ELk760ZPFeXDTH+fQI7Fbguij44OgD6X5T2mDs0m+scSZt1jriOW
	 avImKHWsaUKiSq+2w1C/zOu7/EXUP7fgGXyRFEiGrxH/6dXOZAaAAuYrsYilFSxnWU
	 dLWU+9gQiMKDJUmtCk9lxUPa4CyiZevrU5vwWGrlPplDnwfa105ECpRu6ImguffHft
	 3Vh3X83YKdwjQ==
Date: Mon, 23 Mar 2026 15:32:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, netdev@vger.kernel.org
Subject: Re: [PATCH io_uring-7.1 00/16] zcrx update for-7.1
Message-ID: <20260323153231.415f7172@kernel.org>
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12810-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 482952FE49C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 23 Mar 2026 12:43:49 +0000 Pavel Begunkov wrote:
> The series mostly consists of cleanups and preparation patches. Patch 1
> tries to close the if queue earlier at the start of io_ring_exit_work()
> as there are reports io_uring quisce taking too long leading to fails
> on attempts to reuse a queue. Patch 5 introduces a device-less mode,
> where there is only copy fallback and no dma/devices/page_pool/etc.
> Patches 11-12 start moving the memory provider API in the direction
> of passing netmem arrays instead of working with pp directly, which
> was suggested before.

LGTM, FWIW.

