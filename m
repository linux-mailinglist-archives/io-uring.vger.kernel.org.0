Return-Path: <io-uring+bounces-12294-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEUoCJ9vlGk0DwIAu9opvQ
	(envelope-from <io-uring+bounces-12294-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:39:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7466A14CB15
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C30F23055430
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 13:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B6832AAA2;
	Tue, 17 Feb 2026 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAu6dZre"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77417355039;
	Tue, 17 Feb 2026 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771335495; cv=none; b=SdjGMk+Pbc+4GtyB0k48wdl9Zahy7RfhqS24w+7LZsvXRo3fJ98DCdDXM0ArnNwhC+KhJFLkOdOxDpLCRLEsGCBekQnb/R0kF4mZSBE2/ygfoU48mdrnGYqZ0E7iuR+a9ZL5Fmq8xQthVNqK4oQFJk2JwDcUzJbnmSfw3t/8GOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771335495; c=relaxed/simple;
	bh=sc0NXuhGZ7mkQ+/oVQ8PUAqZ4/sIJ8xicG1GJovMlyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TA9HjrsjAr21WBqegWq1QFZFydtTJMY7cIiMsOHflXrnP5peMuWJf17E9o5aiOwVpbqKapsk3aN6Lh0bM8Lp4Ag3niFDepMq7Wm2e7kLPotmtZElMcC5b8g3Tz3MKUiydjzZuEYJpyEbAeFzKEBW0XIlA6Tz3+lLP6bQNglYyzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAu6dZre; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165BFC19424;
	Tue, 17 Feb 2026 13:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771335495;
	bh=sc0NXuhGZ7mkQ+/oVQ8PUAqZ4/sIJ8xicG1GJovMlyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DAu6dZreRWLBMDujSmZOwtoZ1nw4HAUcZWfnAgqpAohS6pAlEFm65ukWYbYNqRrxp
	 KxSv1XG8EBneEdl6A6/6bU1B7SuNpe5h6zoJX1B9F1XBfPd9haHmKHExemseU9T4ev
	 Gv8v8ySWtq+1sDZ1MItmJ8s9m0EhUzpPfLdEXv/gaJFXDOUPZuhedKUBXYgUWEWK3q
	 mguQNcV+qOl8H3W1el20s6ubk13IqBlWAjgYBYjuJzL7IqLblXmB3SBvMq3k5HNk1P
	 1725NSO/wP6xH35ehmlHUkNVCVVNd/NUt9E15ajJgEFQ9m5GYU/ExyM5T627Mq359O
	 WRQ0m/Goh+DMw==
Date: Tue, 17 Feb 2026 14:38:11 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 0/2] cBPF filter API adjustment
Message-ID: <20260217-botschaft-fugen-1c76dd0ff974@brauner>
References: <20260211150626.136826-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260211150626.136826-1-axboe@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12294-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7466A14CB15
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 08:01:16AM -0700, Jens Axboe wrote:
> Hi,
> 
> Christian brought up a good point on the API - what if the task and
> kernel differ on what the payload size is for an opcode? Currently
> there are two defined payloads, inside struct io_uring_bpf_ctx:
> 
> 	struct {
> 		__u32	family;
> 		__u32	type;
> 		__u32	protocol;
> 	} socket;
> 
> 	struct {
> 		__u64	flags;
> 		__u64	mode;
> 		__u64	resolve;
> 	} open;
> 
> and it could be a requirement that a filter exactly matches the payload
> that the kernel uses, if extensions have been made on the kernel side.
> Hence this small series updates the API slightly:
> 
> struct io_uring_bpf_filter adds a pdu_size field, which userspace can
> set to the size if expects. For an OPENAT/OPENAT2 filter, that would
> be sizeof(struct open) above. The kernel can validate that they match,
> where the mismatch policy is controlled by userspace. See patch 2 for
> details. In case of a mismatch that causes an error, the kernel side
> pdu_size is copied back to userspace.
> 
> Patch 1 exposes the pdu_size by shoving the filtering and pdu_size
> into the issue side definitions, and patch 2 implements the above
> size checking.
> 
> The liburing master branch has been updated as well for this, as
> copying back the pdu_size necessitates changing the API on that side.
> Test cases and man pages are updated as well.

Seems fine by me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

