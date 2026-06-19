Return-Path: <io-uring+bounces-13782-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ikb9BVvBNGoigQYAu9opvQ
	(envelope-from <io-uring+bounces-13782-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:11:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB636A3C23
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:11:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qv3mMbuA;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13782-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13782-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5953430EF682
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 04:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168E0331EA1;
	Fri, 19 Jun 2026 04:07:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5DC331EAD;
	Fri, 19 Jun 2026 04:07:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781842046; cv=none; b=OqjSEI6J/ApGrJ9rg9prqyBA2rKxr2Hnrg+KNWVsDMIIlLcXARh8seg/KDUO9BE5Vtbefr+PAPkMOIjvcPKHiR/g6cjCga1aK63CYdsp1y+GBVHAUyuqienUkb58S1X2hsg2j1Dg3ck2Yv4BHvTj7e/ztLLQM3kECiXKkq5OKuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781842046; c=relaxed/simple;
	bh=FTOGV0IcZ3HP1J4Rz+C5FGe0WbFuAs7UdWEPpj+TEBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=livuMAblXGju1GEjBO+5IIGOjkhzPmRp5mW07sU/RpcMkowgwlqR9P3oW1KWQb7RCBzX96hxwbdfv3jHCte6avqzuyNKhZQUxgSSnN6DLPlXyOK02drihFUQYs8foC8rZ6bim/OE3jnJ3I9J5cKLU0HYODUgO6dC9yIGzwE8cQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qv3mMbuA; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81FE1F000E9;
	Fri, 19 Jun 2026 04:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781842044;
	bh=otxLglsZFBQirL9yFBv0Oki6Sn0lIscC3dBfyTEk0hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qv3mMbuAHwAaILbgyHrPHLf3RTkjWKy6DeXQLVGVCJdMaoiMADKc6b15+NAGwkJTI
	 QD+b3k02wYZRdxdsHcNz9Jg493GURf7y9QvkIxvDs+XHLSECh90iplKi6K6MeCzPKv
	 aq6VxTig3mu1wwEOr2oYWY3oN1vYBaiRFFs4x7LNObYE1BJmHgzcdYjiWj95pBzj0R
	 QST/6vRay03IShJqYIo5KFY23kIt31Q7M93dX+/dJAMTM6Jv0EAwy0Rauw2mpz9UMI
	 ltyW6e3VWTEg6V1XBLNU2ScxVbth8lU8n5GJFJ/Hoa16oytACKXum4uZLUAaCUetsJ
	 ecdYOW2/W4AFg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-7.0.y] io_uring/net: Avoid msghdr on op_connect/op_bind async data
Date: Fri, 19 Jun 2026 00:07:06 -0400
Message-ID: <20260618-reply-item041-iouring-70@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260617192722.3041610-1-krisman@suse.de>
References: <20260617192722.3041610-1-krisman@suse.de>
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
	FORGED_RECIPIENTS(0.00)[m:gregkh@linuxfoundation.org,m:stable@vger.kernel.org,m:sashal@kernel.org,m:io-uring@vger.kernel.org,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13782-lists,io-uring=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8AB636A3C23

>  [PATCH stable-7.0.y] io_uring/net: Avoid msghdr on op_connect/op_bind
>  async data

Queued for 7.0, thanks.

--
Thanks,
Sasha

