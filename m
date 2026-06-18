Return-Path: <io-uring+bounces-13780-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id o4yVFCeGNGpoaQYAu9opvQ
	(envelope-from <io-uring+bounces-13780-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 01:58:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0E86A3231
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 01:58:30 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gnuweeb.org header.s=new2025 header.b=Vfieoh9F;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13780-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13780-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=gnuweeb.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 18CE73007BAE
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2026 23:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B553438A4;
	Thu, 18 Jun 2026 23:58:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444CF14ABE
	for <io-uring@vger.kernel.org>; Thu, 18 Jun 2026 23:58:26 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781827107; cv=none; b=bWDclxFT1AOTRZxr69n5XGSx8oH+ImOAAkcH4NW4yVZfngY0N7mYLkPnihonIJe1UWUL0zxvm7PqNQaGo+BUjNwQTIZ3d5IKaTK+rJmxOJnacO6Pf28WJHpkPBpXxU2wwdmOFf0it0Ri0dIWaKNkyefI5P7wxQPGnUfFy5Z+qJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781827107; c=relaxed/simple;
	bh=w4WPV8jqL+NvvAvUFjqfKDR49v8BZ20lyZG4rNoGTSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k6uT8gZRdVW2IoLFbcFeDirKtq9xlsEX72JdRY7BvPKzCZCSwRKFtQiPy63lL4qfDW0iq/5bvN4Jc2GtOkjr7z6YXEaG//fUL68pGY0+kc8EhIzBRfgHgUq2FL8LsfiZ6INo1utoEWN5vFAgZ7RRK3cp9Yn8RYg1Kp2JxrHKdSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=Vfieoh9F; arc=none smtp.client-ip=89.58.62.56
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1781826809;
	bh=w4WPV8jqL+NvvAvUFjqfKDR49v8BZ20lyZG4rNoGTSg=;
	h=Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=Vfieoh9FkrVP2v8RppqoH9agdCUSIffQE1kFu5oqYGSIepRNC6yJGUqeHYQ83C+l3
	 mMqG6ehZON/VdYkb4bK/Nb0Mh1K2/yTiWRhe12/5NXz8RrO24MHbCoxOr1OAT29dPI
	 CfxIpPZv9wU1xOQrtSkpmhBF8EGhA0044Jrt5H6AwRPgS/in9BZPWaX79A/gG9qzKA
	 f1oS3mz9Wl0SZt2iAQbAGr5XdwwbsOMh5FAdOIFIQHkq/VqOIe/A0bh+pTlCSTd08M
	 QdHt88/PBAtZ0vVCv/syAP7FestpEP9wk2nrvXhCx6ebGKIoMF92S9dEJs5aTE6M/1
	 doaaluzLL3SCw==
Received: from [10.0.0.2] (unknown [36.50.142.76])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id CBD27244397C;
	Thu, 18 Jun 2026 23:53:28 +0000 (UTC)
Message-ID: <4217902f-5b99-4592-aeea-9ac3804da325@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Fri, 19 Jun 2026 06:53:24 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH liburing] man: Convert manpages to markdown
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>,
 io-uring Mailing List <io-uring@vger.kernel.org>
References: <20260618230524.4088053-1-krisman@suse.de>
Content-Language: en-US
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Autocrypt: addr=ammarfaizi2@gnuweeb.org; keydata=
 xsBNBGECqsMBCADy9cU6jMSaJECZXmbOE1Sox1zeJXEy51BRQNOEKbsR0dnRNUCl2tUR1rxd
 M+8V9TQUInBxERJcOdbUKibS8PQRy1g8LKJO/yrrMN8SFqnxYyX8M3WDz1PWuJ7DZE4gECtj
 RPuYN978y9w7Hi6micjraQeXbNp1S7MxEk5AxtlokO6u6Mrdm1WRNDytagkY61PP+5lJwiQS
 XOqiSLyT/ydEbG/hdBiOTOEN4J8MxE+p2xwhHjSTvU4ehq1b6b6N62pIA0r6NMRtdqp0c+Qv
 3SVkTV8TVHcck60ZKaNtKQTsCObqUHKRurU1qmF6i2Zs+nfL/e+EtT0NVOVEipRZrkGXABEB
 AAHNJUFtbWFyIEZhaXppIDxhbW1hcmZhaXppMkBnbnV3ZWViLm9yZz7CwI4EEwEKADgCGwMF
 CwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCZ/1d1QAK
 CRA2T7o0/xcKS6fgCADlWw9ZPvM8Qv9Zdhle6zyCnwTnoZsadBnabY3NGFAo0YVNnByUy5HN
 inN92F1W71D06IrPJr/0rcCt1mJWM8TuQiU3LdEC+1Go99XA48x94grtxkZiBKKUmGU7HU4p
 5bdTj3Ki8HYCaaHz73VeLsPGvXc6uzMtHCHubErIvbf1VsXOuGo4xhxveT/RutKrJto81YWp
 zlrvbU8DJOvRuzBbNk/N/SgpyceVT+g3hAnoySUV1nweeNdnOZZ8LsH5bjCyJ8oq0n1NfngY
 u1BXSqCNKPh/QrVsXpvlWuvWog1k/GbtxQoIJ2lizJPrxA8kjUI/oQ/S9DDejiLD7yzXeUUw
 zjgEZ/1bwhIKKwYBBAGXVQEFAQEHQELDQDfZ2b77GoJFe9RHDa2xOd3X4QZPuRcqvwu2h74j
 AwEIB8LAfAQYAQoAJhYhBOiTcm3I5MDeO6IBBzZPujT/FwpLBQJn/VvCAhsMBQkI3sMOAAoJ
 EDZPujT/FwpLC9UH/Am+C8AQsDFNpTUWzkqEwTMAcXBES9sRr9Hx3AbysOuEF28LwAGaHlx9
 pn17tiusZcDQ3TnJnbp4pdUt6n1HYZqR04Nrkz7fbirFJQ214vHFov0lc8g26OdEVHWqHtKN
 GGAryZaaT2c8aqRX3X8BraFyjj35cFLKeUJDnKBWDt4ztvQnnHPi9GH74h1O/mglcMyM3EnM
 AOWKeYsHlJf98mt8gRamko7WOG473faeN1IO/iTZIdUEjzsTmzITehrqMm6FVFPFOUtmQG4M
 9X95XOk5hOL7VvJZpLc3lZdccyaWP2yJ14AX3QMBJjZuPpfDCJCVPb7PBa8fOWMghEO8hTo=
In-Reply-To: <20260618230524.4088053-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gnuweeb.org,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[gnuweeb.org:s=new2025];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13780-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[ammarfaizi2@gnuweeb.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[gnuweeb.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ammarfaizi2@gnuweeb.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CA0E86A3231

On 6/19/26 6:05 AM, Gabriel Krisman Bertazi wrote:
> This has been discussed for a while due to the ongoing pain of writing
> groff.  Now that we just had a release, convert the manpages to markdown
> and add infrastructure to generate back the groff automatically during
> compilation.

Wow, big changes:

   399 files changed, 11719 insertions(+), 18975 deletions(-)

Yeah, I agree that writing in GNU roff is more painful than writing in
markdown. Interesting patch.

Can we also word-wrap the markdown files? It's easier to read them in
raw if they're word-wrapped as well.

-- 
Ammar Faizi


