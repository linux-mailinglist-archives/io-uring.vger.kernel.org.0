Return-Path: <io-uring+bounces-13416-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHbpLe06C2qWEwUAu9opvQ
	(envelope-from <io-uring+bounces-13416-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 18:14:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D71FB570AD3
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 18:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5ED09305B9F3
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540D13F8892;
	Mon, 18 May 2026 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=berkoc.com header.i=@berkoc.com header.b="GKcWAh2W";
	dkim=temperror (0-bit key) header.d=berkoc.com header.i=@berkoc.com header.b="ZnGExkOB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-03.1984.is (mail-03.1984.is [93.95.224.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1EF4F5E0;
	Mon, 18 May 2026 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.95.224.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779119333; cv=none; b=HtdTkGAc4ktzGJVenZNDbIP+8WaOiL6ZN5saNxaivUH3gqslByhYYxGP+i5nuVKmlIOs/vwhKKaL4xIz2VOiRWQXeuLyj7Kt2aEmk4Q2pymzC6vl5/MUbQNMPOQjOHdioTjxZcV56QV9sExYhj7/zg8H6JHOYnAufj/ZLED/H6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779119333; c=relaxed/simple;
	bh=+WT/fy8hwff9MZ5TxT11bC6B6arVnwBLx3eJG3ks/K0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=JmI36PdeZC+Du1MoV5t/9dcZinG9b30p16YFhBBnbjb2dozfRW46slf0Ky2YDJMwNlyas29BWUfyvAFSdHuXUUmyRzDYMFyqEjLZXQe2iQj7WfRLKhpbnVh3H/1uyUb+NbRQr82eFcAPUHtFVZN6zqgFnwSq0gAnTf5VZxQjoMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=berkoc.com; spf=pass smtp.mailfrom=berkoc.com; dkim=pass (2048-bit key) header.d=berkoc.com header.i=@berkoc.com header.b=GKcWAh2W; dkim=temperror (0-bit key) header.d=berkoc.com header.i=@berkoc.com header.b=ZnGExkOB; arc=none smtp.client-ip=93.95.224.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=berkoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkoc.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=berkoc.com;
	s=1984; h=MIME-Version:Content-Type:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+WT/fy8hwff9MZ5TxT11bC6B6arVnwBLx3eJG3ks/K0=; b=GKcWAh2WLkZZyMRp+tn1ZIfjN7
	m2ucTOaLCSiigd1GxUZCzYQ6nPzivLF7/qebHSntYwv/0oUzEBkexR4kaPG4Jua3rhM+M/XQQepyX
	OIOfvNQROeWyddeWCqqDW6j1tPLED8Uxbjja9HZ0o53mbvy2+QVgSqK2biq2H4eK3U5V0a26MCgnW
	XfXGPQYH1wVabPUfbOhdWlP9B33bqhzzyShuy5H1HgNWt2TWyvD8Mjv60DTC5uFlvs20IHRYcNKP/
	H9m9DPrMisW4CvTSjrN4pq6Y/QsGYkVJE/pd/rChlPj2YpjvIu7xVsjV0pWh+dxdBV9mD9bxw+lOb
	eOqcszNQ==;
Received: from localhost
	by mail-03.1984.is with utf8esmtp (Exim 4.96)
	(envelope-from <me@berkoc.com>)
	id 1wP0CS-003Rf7-1h;
	Mon, 18 May 2026 15:48:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=berkoc.com;
 i=@berkoc.com; q=dns/txt; s=me; t=1779119282; h=message-id : date :
 subject : cc : to : from : sender : reply-to;
 bh=+WT/fy8hwff9MZ5TxT11bC6B6arVnwBLx3eJG3ks/K0=;
 b=ZnGExkOBaZBR8oH09ikDICDpyxLd8/10xN3Tzl5d+tlhHXfF01Clz2itmBWNEivruoWot
 kpYpfhzoBAqY1V7JCW9bLS/3RLm//KAeJIIHF9KMW+zR8AYDd2XMBBov992u0Kh2fnNx2e0
 LgJPmpLnQybLwUpDP5RT+Cakg11YVLQdowwIFG2tfO8N0Ah04ngahWKYoIsvSLzIRRc5RPj
 clcqR/sLwD0Nxk9QDmWjo2caUAvKPBkHqLnaTyx9r6xUqUNeetPyquUFGNqMRhuDLq76IFO
 69RDi3QJ+FBzipf+oqnQCYkAcJ+twEQS7/kd1fmpi0EivHVAZ1uKxS3oopog==
From: Berkant Koc <me@berkoc.com>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Bernd Schubert <bschubert@ddn.com>,
 Greg KH <gregkh@linuxfoundation.org>,
 Miklos Szeredi <miklos@szeredi.hu>,
 security@kernel.org,
 Joanne Koong <joannelkoong@gmail.com>,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>,
 fuse-devel <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing last fuse_dev
In-Reply-To: <0e4f0d30-7ed0-431d-ac9a-874b046337cf@bsbernd.com>
References: <20260517-fuse-uaf-patch2@berkoc.com>
 <2889c98c-21e8-47eb-903a-ea40bf5c8c04@ddn.com>
 <20260518143218.7c7c1689.clarification@berkoc.com>
 <0e4f0d30-7ed0-431d-ac9a-874b046337cf@bsbernd.com>
Date: Mon, 18 May 2026 17:47:32 +0200
Message-ID: <20260518174732.bernd-fuse-for-next-ack@berkoc.com>
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
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_MIXED(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13416-lists,io-uring=lfdr.de];
	GREYLIST(0.00)[pass,body];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[berkoc.com: no valid DMARC record];
	FORGED_SENDER_MAILLIST(0.00)[];
	R_DKIM_REJECT(0.00)[berkoc.com:s=1984];
	DKIM_TRACE(0.00)[berkoc.com:-,berkoc.com:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_NEQ_ENVFROM(0.00)[me@berkoc.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FREEMAIL_CC(0.00)[ddn.com,linuxfoundation.org,szeredi.hu,kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	TAGGED_RCPT(0.00)[io-uring];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=1];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_ALLOW(0.00)[+ip6:2600:3c15:e001:75::/64:c];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,berkoc.com:mid,berkoc.com:dkim]
X-Rspamd-Queue-Id: D71FB570AD3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 18 May 2026 16:46:08 +0200, Bernd Schubert <bernd@bsbernd.com> wrote:
> Ah, it is based on Miklos' for-next branch, which is also in linux-next
> (I think). Yeah, we have a bit back port headache here.

Got it, that resolves the field-name confusion on my side. I will rebase
the test harness onto Miklos' fuse.git for-next tip (and cross-check
against linux-next), then rerun the two-arm comparison against that base:
revert vs apply with the abort/release race-widening kept in place,
2x50 iterations each under KASAN + lockdep + kmemleak, with full
splats and reproducer attached on report-back.

The stable-backport question is parked until the for-next arm lands
clean. Once the trace set is in hand I will fold the v6.14 field-name
delta into a separate backport note rather than mixing it into the
mainline result.

Assisted-by: Claude:claude-opus-4-7 berkoc-pipeline

