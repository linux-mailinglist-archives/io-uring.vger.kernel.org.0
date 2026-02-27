Return-Path: <io-uring+bounces-12449-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wISXBU6koWlxvQQAu9opvQ
	(envelope-from <io-uring+bounces-12449-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 15:03:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9083A1B84CC
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 15:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B8737313EF9E
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 13:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C073E95B3;
	Fri, 27 Feb 2026 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2QwUA9R0"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A240FD88;
	Fri, 27 Feb 2026 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772200755; cv=none; b=fAZoVdLXOPclPRjqotPB12s4fNhmCoULIYt/Y1ihsO9egIWBxMfTs18heirws3WI8YBn0H4Cjg6lhJ4gXCFPEu2BnPUdlQy6UGdJMXcHUl+PIBJwLC/86fir/c9Gu2Xeb/mySWgSVYEl+8G/domfjjwwsaQr10LcBQRiP6Tynkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772200755; c=relaxed/simple;
	bh=nuTEiMssSi7LvBedjeYz1hXrRFEBjLCGAXYMn3qYrUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j8bwReHsFcxyIQYcf70p4gbf1OfxO2zhwUbTeHTA+JbA/s0y5+uTjggB4MirZRtNLN7TkOx23zvq+llpU2A4R994gIeihM/cVF/kID6qC+aD0N4sUE66uqu8iIP8bFHwEUXN6MNHePC8F3vvQOB12y4KgAtpOl2IWVDRPKZsxlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2QwUA9R0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=XceXl/pjD5Y0CR6J1iyzg+eNnR24KgcZ7ue4PZPyOBA=; b=2QwUA9R0QldWaUiCLRTIlRCNaz
	79tLB7aGtVUJ1nRaXHvqoolSDGNzDzJ+U1n6yYejZv1zZ0SzljG8KD60QQnOz4S2jgkDqGrMGCKjM
	wg/U/5iSRFMeeHIXW8mOZzsbL3qouiEaMOG8vEYXjJeT8HSgC+7sVbsKrAt5Q9CRJna5OWQbFpv9w
	x65BRY0wbMOMYgQv7/cBqr8+rhWECcsziDD2MAD+RndMArzAaouuw5r2kT/fapHAzSXpeoYTCIZ7E
	iKdzXGf4ju9uy5sPYHJ6OmZNJFYBGJ/KTXnhlfFhByZoWRNLwdsPVK9EN+swD1QtRRTwdVNOI2sQ1
	PxYomh5ur74WwNHrYizth6rWPmsAT59kftebWuQdD5vhTBZwKgtP+Q8FrGW+yfMVIqH8rgIpCHMdD
	qkJ3ZiAoSsOw3Gx0SbrXaveR5U0v2F5si4NTH/jiPsY6X8Fc/KEW9cmhDftPhMjLzCRlt1nt1r4dp
	HDu5aMcVO/j3AAlCGGTrZizQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vvyMy-00000008z8P-1KJA;
	Fri, 27 Feb 2026 13:59:04 +0000
Message-ID: <ad61f286-5a4b-4ec7-9586-6fbf58e961bd@samba.org>
Date: Fri, 27 Feb 2026 14:59:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: don't fail linked ops when done_io > 0
To: Hannes Furmans <hannes@p2p.industries>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Hannes Furmans <hannes@stillwind.ai>
References: <20260226220310.758404-1-hannes@stillwind.ai>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260226220310.758404-1-hannes@stillwind.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samba.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[samba.org:s=42];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12449-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[samba.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[metze@samba.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9083A1B84CC
X-Rspamd-Action: no action

Hi Hannes,

Am 26.02.26 um 23:03 schrieb Hannes Furmans:
> When io_uring recv/send with MSG_WAITALL accumulates partial data
> through done_io and then encounters an error or EOF, req_set_fail()
> sets REQ_F_FAIL despite the CQE result being positive (done_io bytes).
> io_disarm_next() then sees REQ_F_FAIL and cancels all linked operations
> with -ECANCELED, even though the user-visible result indicates success.
> 
> This manifests in two code paths:
> 
> 1) Direct completion: io_recv/io_send fall through to req_set_fail()
>     when ret < min_ret, even if done_io > 0. The CQE shows done_io
>     (positive) but REQ_F_FAIL severs the link chain.
> 
> 2) io-wq fallback: after APOLL_MAX_RETRY (128) poll retries, the
>     request moves to io-wq. io_recv returns IOU_RETRY from the
>     MSG_WAITALL retry path, io-wq fails the request with -EAGAIN, and
>     io_req_defer_failed -> io_sendrecv_fail overwrites cqe.res with
>     done_io but leaves REQ_F_FAIL set.
> 
> Fix this by:
> - Not calling req_set_fail() when done_io > 0 in io_recv, io_recvmsg,
>    io_send, io_sendmsg, io_send_zc, io_sendmsg_zc
> - Clearing REQ_F_FAIL in io_sendrecv_fail() when done_io > 0
> 
> This makes MSG_WAITALL partial completions consistent with
> non-MSG_WAITALL behavior, where positive results never sever the
> IO_LINK chain.
> 
> Reproducer: MSG_WAITALL recv via IO_LINK -> write on a UNIX socketpair
> where the sender closes after partial data. The recv CQE shows positive
> bytes but the linked write gets -ECANCELED.
> 
> Fixes: 0031275d119e ("io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL")

That's by design, if a MSG_WAITALL calls fails it means
not call data the caller expected arrived or were sent.
When there's a LINK after that the linked operation likely
relies on all expected data being processed! Otherwise
the message stream can get out of sync and causes corruption.

Let's assume I want to send a message header with
IO_SEND linked with a IO_SPLICE to send the payload.

If IO_SEND returns short the situation needs to be
recovered by the caller instead of letting the
IO_SPLICE give more data to the socket.

So the current behavior is exactly what MSG_WAITALL
gives you. If you don't want that why are you using it
at all?

metze

