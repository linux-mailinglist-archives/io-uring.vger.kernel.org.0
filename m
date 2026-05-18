Return-Path: <io-uring+bounces-13402-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMQwKuAtC2plEQUAu9opvQ
	(envelope-from <io-uring+bounces-13402-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:18:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2238556FC6B
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A29F326DA13
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5973F8EC0;
	Mon, 18 May 2026 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=berkoc.com header.i=@berkoc.com header.b="icce/ZVo";
	dkim=temperror (0-bit key) header.d=berkoc.com header.i=@berkoc.com header.b="MuYzFaPs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-01.1984.is (mail-01.1984.is [185.112.145.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E782C3259;
	Mon, 18 May 2026 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.112.145.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114805; cv=none; b=LCS36DQX+KwfW7WX38k4LTslvlWCls3HrI8b/V5lO4ugegcEmFydrJ0m0PCR2QW9lW0iZNg/jXP27HCfudxLy+O2l3M5JsGK3JroUapuWFub+cRQltWN17aF164kik+1KARQEF+RyLLqfUzLaYL4I0kii+7bvF9Oq7wYvR9hJ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114805; c=relaxed/simple;
	bh=6/3Bmy3SlFTGmZjZnqOGwGw9MTWGgv8VdupJ47MSV9c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=YN5euPohpUOrBGxXfH97T8XLW6aTATofR+nGRtVi6NgItjiRmPNMz1RuEnRSKafBir7dxB+1d/ZN+HJ37Zs94uUZb2g1cAUtryT8PxFTgATJ+/E6Bl6sAzIrH9y99L4tL5OoQWL2H9wk8hB20/7qeKu93qFZM9wZx3g7Yee5+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=berkoc.com; spf=pass smtp.mailfrom=berkoc.com; dkim=pass (2048-bit key) header.d=berkoc.com header.i=@berkoc.com header.b=icce/ZVo; dkim=temperror (0-bit key) header.d=berkoc.com header.i=@berkoc.com header.b=MuYzFaPs; arc=none smtp.client-ip=185.112.145.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=berkoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkoc.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=berkoc.com;
	s=1984; h=MIME-Version:Content-Type:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6/3Bmy3SlFTGmZjZnqOGwGw9MTWGgv8VdupJ47MSV9c=; b=icce/ZVoFWBC2E4Y7wvu+bS9qX
	CT2taSx3VhKrB9qASUgBO4Nid8aefXEpZdgZVjB5kTB9BQltIkg7JrP4f54UnQDYx6lYwR8yRo26G
	8FjfKaWzoP/uQ/a2ncHsub+tlO5pnhblKW1Vivbaz/1aXI3xfzpUmSVCiwiAhk2BtUPcNPMX8PAfA
	V8UR+ZXICadH8bOGnT8dJ6DjwfUe2e0WwEZtEImNMz2irrwchiecVP2cvqvZ2QTocpTQb65tCwQjR
	stMI/LfF9HGhwQ1dNr2suzDupVbyCSal5J0egHQTrFDEReGwrG/fyO7kRbbfRP+99/5EyVc/zoRZ/
	6x3FI6IA==;
Received: from localhost
	by mail-01.1984.is with utf8esmtp (Exim 4.96)
	(envelope-from <me@berkoc.com>)
	id 1wOz1e-001hPX-1K;
	Mon, 18 May 2026 14:33:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=berkoc.com;
 i=@berkoc.com; q=dns/txt; s=me; t=1779114770; h=message-id : date :
 subject : cc : to : from : sender : reply-to;
 bh=6/3Bmy3SlFTGmZjZnqOGwGw9MTWGgv8VdupJ47MSV9c=;
 b=MuYzFaPsoNCIUknTxqdQmQB/W3w0mJLCRVb7OF5tJpS01uRfMRvLtP1TKHBBnh9hLeM/V
 tcf++nqa+lpRqXNZqOXSF8vmm/y9udRWORdkRsDxhk6m7krNFbUuzuho8HDi8HoGZQHLY3d
 c9G8daMNkXco0aE/UvFhTxpKpY45XQ60O50ix/1kEbYgV+D2vCdu2pe/bgK66Er+pIUFRjb
 2QKONW+aFxgqOLX+K9zNJoBsrM7bewQfxtwHcL5Sscs2vksPkLEqz2jJHha8uJ7XFvhDpqh
 4/EkU1OknIYgo+9k7H/JddI6Jkwvq8uoO2KeBuIgDJgRRrL5jGBXJ3EtlSgA==
From: Berkant Koc <me@berkoc.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
 Miklos Szeredi <miklos@szeredi.hu>,
 security@kernel.org,
 Joanne Koong <joannelkoong@gmail.com>,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>,
 fuse-devel <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing last fuse_dev
In-Reply-To: <2889c98c-21e8-47eb-903a-ea40bf5c8c04@ddn.com>
References: <20260517-fuse-uaf-patch2@berkoc.com> <2889c98c-21e8-47eb-903a-ea40bf5c8c04@ddn.com>
Date: Mon, 18 May 2026 16:32:18 +0200
Message-ID: <20260518143218.7c7c1689.clarification@berkoc.com>
Content-Type: text/plain; charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Score: -0.2 (/)
X-Authenticated-User: me@berkoc.com
X-Sender-Address: me@berkoc.com
X-Spamd-Result: default: False [4.14 / 15.00];
	SEM_URIBL_FRESH15(3.00)[berkoc.com:dkim];
	SUSPICIOUS_RECIPS(1.50)[];
	R_DKIM_ALLOW(-0.20)[berkoc.com:s=me];
	MAILLIST(-0.15)[generic];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13402-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[berkoc.com: no valid DMARC record];
	RCVD_TLS_LAST(0.00)[];
	DKIM_MIXED(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	GREYLIST(0.00)[pass,body];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	R_DKIM_REJECT(0.00)[berkoc.com:s=1984];
	FREEMAIL_CC(0.00)[linuxfoundation.org,szeredi.hu,kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	DKIM_TRACE(0.00)[berkoc.com:-,berkoc.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@berkoc.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	R_SPF_ALLOW(0.00)[+ip6:2600:3c04:e001:36c::/64:c];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=1];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 2238556FC6B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 18 May 2026 11:47:00 +0000, Bernd Schubert <bschubert@ddn.com> wrote:
> Would it be possible for you to test the attached patch?

Reproducer and KASAN harness from the PATCH 2/2 series are staged.
Two-arm plan: revert vs apply, race-widening debug hunk kept in both
arms, 2x50 iterations each against torvalds/master tip, KASAN + lockdep
+ kmemleak enabled. Results back within the day once the base resolves.

Blocker before I build. The patch references ring->chan and chan->conn.
On mainline fs/fuse/dev_uring_i.h declares struct fuse_ring with
struct fuse_conn *fc at line 110, no chan member; grep fuse_chan
across fs/fuse/ returns zero hits. As-is the patch fails to compile
with "struct fuse_ring has no member named chan".

Is this based on a DDN topic branch that introduces a fuse_chan
abstraction not yet upstream? If so, point me at the base tree or
branch URL and I will rebase the test against that. If the references
were meant to be ring->fc and fc against current mainline, confirm and
I will adjust before the run.

Assisted-by: Claude:claude-opus-4-7 berkoc-pipeline

