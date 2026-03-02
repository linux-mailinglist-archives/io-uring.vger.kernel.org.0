Return-Path: <io-uring+bounces-12531-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oHrNCHsFpmmzIwAAu9opvQ
	(envelope-from <io-uring+bounces-12531-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 22:47:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C311E402E
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 22:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0F61F309D257
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 21:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1E2388397;
	Mon,  2 Mar 2026 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaSSV0NR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1FC2D949B;
	Mon,  2 Mar 2026 20:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485125; cv=none; b=kgeJq2COA8Fx1AnDw5v9QroDzL7lns6fUUnmqhm3ATKuj0Sf2ImDrchBukurOSGyXNcddZIdbLUzHsIYFeXspcLLis6UNH9mTjfwKiHfxVtef7WC2TQoytsDuQRDZqFo6V9SFQhKbyIj2Oy8T4pCEaFJanaq/EUv2GWO1H0N1RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485125; c=relaxed/simple;
	bh=2EBUKM/WBoWlIQI1wT/XGIf4p8wOsibHPnBV5hseUGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sc/e+L6TvYu0mEniJcyIQ/b5JhmckQSVYjL5WNc2xTVlf/2UOwvqvpIb6UyWkpYxZI7Z04bG+BUEaZ5zAaOjPadu/ZfCJSJy6XJxWC5w4zytkep3iRuQdxr8SJt/tZkikUkMz0IUK4lvLYlmYycKuWRyd3xocTIf7PoiCiTyYKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaSSV0NR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B4CC19423;
	Mon,  2 Mar 2026 20:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772485124;
	bh=2EBUKM/WBoWlIQI1wT/XGIf4p8wOsibHPnBV5hseUGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BaSSV0NRw/ZhaVIcxLUKJVhzUaVjRJlLnyJR96qoOzPBZj0uz0gO3OvI95EyZcBe7
	 cLg0qnP2FSgMOWGwSyK71Murrv4jz8QUykgeM1q9ipIwu/k6CapDnyxmoTrHXD/LCp
	 3CE0Ij55JkFCy8QrPLUo08seErv61QxEinAobzwlNOUBEhz+WGZN6en5rPTqVGVs9/
	 fkFj1UirH8vYLq8lsFRihVwFz9f/edNFsDP9fWsFY0lZ1dm15q5knc9YnSsbRfs3RY
	 KvPDLTJPO3YVNNQBDEhvBWXrKB/lDE+1TIrx4NK04C3ECWM0A7IINtLzSFzNR0+52f
	 I6/8PbU5KQtyA==
Date: Mon, 2 Mar 2026 15:58:43 -0500
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: FAILED: Patch "io_uring/filetable: clamp alloc_hint to the
 configured alloc range" failed to apply to 6.1-stable tree
Message-ID: <aaX6AzNtFQ32exUW@laps>
References: <20260301014717.1711200-1-sashal@kernel.org>
 <eb41b6f9-08f4-4972-99d4-3340571830bc@kernel.dk>
 <8e84b6c3-e62d-4aef-90b7-a7a0e63d8a17@kernel.dk>
 <aaX2F5LGPcqaDXum@laps>
 <531cfe07-2a07-4bd2-be07-9cd78890e04f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <531cfe07-2a07-4bd2-be07-9cd78890e04f@kernel.dk>
X-Rspamd-Queue-Id: B6C311E402E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12531-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 01:45:51PM -0700, Jens Axboe wrote:
>On 3/2/26 1:41 PM, Sasha Levin wrote:
>> On Mon, Mar 02, 2026 at 01:38:37PM -0700, Jens Axboe wrote:
>>> On 3/1/26 6:15 AM, Jens Axboe wrote:
>>>> On 2/28/26 6:47 PM, Sasha Levin wrote:
>>>>> The patch below does not apply to the 6.1-stable tree.
>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>> tree, then please email the backport, including the original git commit
>>>>> id to <stable@vger.kernel.org>.
>>>>
>>>> And this one also picks cleanly into 6.1-stable. Not sure what is
>>>> going on at your end?
>>>
>>> Are these and the other "FAILED" false positives getting applied or
>>> not? I didn't hear anything back on any of them.
>>
>> Appologies for all of this. There's an explanation of what happened here:
>> https://lore.kernel.org/all/aaWWE5uQqz_eG69i@laps/
>>
>> These should be part of the -rc2 I did earlier today.
>
>Gotcha, yeah it's not easy to know when you don't hear back, either
>as a reply or as a new "added to stable" email. For those of us that
>do take stable seriously, I 100% need to know if something is landing
>or not.

You're right (and thanks for all the backports!). I had a plan to review all of
these again after the release, but I should have sent something out first.

-- 
Thanks,
Sasha

