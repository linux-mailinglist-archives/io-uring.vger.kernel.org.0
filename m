Return-Path: <io-uring+bounces-13783-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id G7umJGDBNGomgQYAu9opvQ
	(envelope-from <io-uring+bounces-13783-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:11:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 543956A3C2D
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:11:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vr/OeAre";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13783-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13783-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A124F30F25E5
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 04:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D20331EDD;
	Fri, 19 Jun 2026 04:07:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4B432B106;
	Fri, 19 Jun 2026 04:07:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781842047; cv=none; b=oSm3SY5zqLoCAt7AEYqoOBMNsIYhh0z3Kq7EERFPd4rJ1u1Itc1dUfPEpcxTkzLRFTOZ21OHz9TwDw43dbFKMlz39ynQpBDLQMy6ijdONDg5CMU6Jn23QWR8SoHTJ4shdIK5BdK3Nkwc1LOCxq7FZf5kYQu3AG9IV7xyOD+q3oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781842047; c=relaxed/simple;
	bh=lDb9e+3B4yyaiFNA/GWkzAxmfKkdsgwyopNeUaoUPHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7MmgGHEf3042p87PlImjW0Lj7wljjj9qrNdRK2GlvUvImxb0EuReZYdICs+DmWaKIlU2lSaYwiw8BGpIJP5v4fK77bQsnq0ibqXnuVhRhnjcZryyfkeEB7y567CWIfHAB/8J/ig9DuJvVIJbI/KWVOjuUciH4ImSX7Uc2IhGOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vr/OeAre; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A6F1F00A3F;
	Fri, 19 Jun 2026 04:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781842045;
	bh=cmffGm2q1sv7KOg5Cs5YvudtBs1bHVco7b37JKfPXlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vr/OeAreSOAVJFm7ql2EuBuqiI5RL3rYoEKMyXABhZqZEHwBPxag0TiLs7m2ZG4PQ
	 OzGdSDtBzgGta6ffMPebv23nLWnsOFvw0i6jYA6J2eijn+h0KTZIGEnZK8jD7Juc++
	 3TVnWqPjd/wq6mrMLpT/BjZ5SOXMjs9/rnFsfKV3NUnnADqclvnGGpH/R61Qa8rEip
	 c8ohLIwVIck+VvmhzkWfFkr1X0SkPoNpezEG6tasYLdfmEmlld1NL7epi3RDldwNvu
	 V0RCLVf85UElUQLlhLSPOMaPeMcsViqY8784PasUWXuErV2LmeUEv0Ux/PQLZzbOUD
	 fzQMeOXgbQOrg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-7.1.y] io_uring/net: Avoid msghdr on op_connect/op_bind async data
Date: Fri, 19 Jun 2026 00:07:07 -0400
Message-ID: <20260618-reply-item042-iouring-71@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260617174947.2975419-1-krisman@suse.de>
References: <20260617174947.2975419-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:stable@vger.kernel.org,m:sashal@kernel.org,m:io-uring@vger.kernel.org,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13783-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 543956A3C2D

>  [PATCH stable-7.1.y] io_uring/net: Avoid msghdr on op_connect/op_bind
>  async data

Queued for 7.1, thanks.

--
Thanks,
Sasha

