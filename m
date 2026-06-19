Return-Path: <io-uring+bounces-13781-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id pBqrIkXBNGocgQYAu9opvQ
	(envelope-from <io-uring+bounces-13781-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:10:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D36F6A3C1C
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:10:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9a21yLU;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13781-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13781-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 441CD30E5CAF
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 04:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5A1331EDD;
	Fri, 19 Jun 2026 04:07:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A958D279DB1;
	Fri, 19 Jun 2026 04:07:23 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781842044; cv=none; b=l6PcfwI4HUEeVF7syUoe8CGaojvtzEdGK/h4wXM4RQptIef2MMtfFq7MQkpnUsbWP2GIAbxUOM8lXGg+9bxiwunr9iDPmZaHcCvJcgN46xlx+SuCIO48rYvPkF54h3186wcge05InxLmwnA70onoucjDbZy6e+qVTnMf6kZQvUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781842044; c=relaxed/simple;
	bh=eZaw6MJbBtmdq7ttzn5uCSQOrJ0FgDezbbOeK10asas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM1UaBV3hqZwTmMv9U0qVcLJEgDv8wnArsVHhIXUQgreR8cmf38QYfjNbtAr7EUwhhgs6BmH+dpE385U5UP8f1pSmW6uxAu4FOteewpaHfQB4LxlXDEytL/NzdnkmR8f0lxqGPNhjFoO1KfMWMq8kxeDRg/67ZvDYf2132cCZjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9a21yLU; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FDB1F00A3A;
	Fri, 19 Jun 2026 04:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781842043;
	bh=AKEfgz24t9uQweUkrwjuC12FE1DAVbSKnw7B7l+0MaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9a21yLUrBaqg+XdhpsvCD4MTABQl5Fc8KInp0eH10cG592JFalpXW9mTJdE6NBSs
	 jkW6xSFXr8N03XL+I6JI+Uzv/MEDZO8M1BgK+eaKS75S9oOZSXL8iPEnZ24DuOeCcs
	 YN3XmuIToMKIORi2EwL5Lr2IJIYwn/hx6iZtsGOzJ53IvmHlH2J1MmWKcsK/igO8rH
	 dF0SDD7SIoRsxqQmHB1vl46MLy0FnI85RNekz+mrJSNqI4ygXZuvBjQzMx9S5M2ZMh
	 oh0DngoifHv10SXElgAwJlZWpeisvLMH5OfcJVYqHYZIYD32RyFnpHz6HFx6bfAMgC
	 sscbah7tlDcvw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-6.12.y] io_uring/net: Avoid msghdr on op_connect/op_bind async data
Date: Fri, 19 Jun 2026 00:07:05 -0400
Message-ID: <20260618-reply-item040-iouring-612@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260617175158.2977825-1-krisman@suse.de>
References: <20260617175158.2977825-1-krisman@suse.de>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-13781-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 4D36F6A3C1C

>  [PATCH stable-6.12.y] io_uring/net: Avoid msghdr on op_connect/op_bind
>  async data

Queued for 6.12, thanks.

--
Thanks,
Sasha

