Return-Path: <io-uring+bounces-13912-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 2edeBH7xTGqHsQEAu9opvQ
	(envelope-from <io-uring+bounces-13912-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 14:30:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8487871B5EE
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 14:30:53 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e7q5cnEq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13912-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13912-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0C6983051472
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2026 12:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A5240D59B;
	Tue,  7 Jul 2026 12:27:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4728640A92C
	for <io-uring@vger.kernel.org>; Tue,  7 Jul 2026 12:27:45 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783427266; cv=none; b=Ta1MaKrXAo+nl7mE5AWOrMWdOC1FNAQOhmtTJlzzFC0onmsIJVxnoBUtYWHIH+t34o4cRUi+oQBgptmIDm42ApI18cpOFulZ+/LjqUoh9XWUpA861sMPj3ka/hxjZvpKuR3wHLXZtVymc8kYp4kdA9905XQC/4xp1dgnTNkeY+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783427266; c=relaxed/simple;
	bh=BJE7c82a1VLRpoGtJjQwkeO2HySW71PN+hldZ5b0D3U=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=dOYSvGxbnS9IQXfMBzrA5iuYVC3/qrla6WyFvuYY5R65Frqv3xU66wpPCHD+RvcwvQOWxt3APYH+9CTs1G+BS1+zg2xk6ig2KqyrWAQUPZFLuquWsJPfoJvjQuZ+Jv0HkKfYtvJ0I+/3Zoa09VsM1kwfNlEE5/OdyJd1YrKygXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e7q5cnEq; arc=none smtp.client-ip=170.10.133.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783427264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RhIN1JvpN4E2cs5o/p8FQD9smEm0+1w2tY22BDEbKC8=;
	b=e7q5cnEqZUzLwOxAvo8BgGm1XSS93r9wDt+rxU9QfURT/la8H94nrFfCj/6T8wTHi2aqce
	cdS+QA3i4UeuGOIHiyb5MibPzQF9uVLFZOJB+Y/8Udv4QLldyV0N6XJe8ZaYuQVWHnlsvH
	eoIxJ+QHq9wfByyoMajQHPs6wovf9JU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-DSHbl5viNWCBgAtxowD4yw-1; Tue,
 07 Jul 2026 08:27:41 -0400
X-MC-Unique: DSHbl5viNWCBgAtxowD4yw-1
X-Mimecast-MFC-AGG-ID: DSHbl5viNWCBgAtxowD4yw_1783427260
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A5A91954B1E;
	Tue,  7 Jul 2026 12:27:37 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.80.166])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C09AB1955F76;
	Tue,  7 Jul 2026 12:27:35 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk,  io-uring@vger.kernel.org,  ammarfaizi2@gnuweeb.org
Subject: Re: [PATCH liburing 0/3] Convert manpages to markdown
References: <20260706214132.2841060-1-krisman@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 07 Jul 2026 08:27:33 -0400
In-Reply-To: <20260706214132.2841060-1-krisman@suse.de> (Gabriel Krisman
	Bertazi's message of "Mon, 6 Jul 2026 17:41:22 -0400")
Message-ID: <x49fr1vvvbe.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:ammarfaizi2@gnuweeb.org,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[jmoyer@redhat.com,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13912-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmoyer@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp,segfault.usersys.redhat.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8487871B5EE

Hi, Gabriel,

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> This obviously adds a build dependency on pandoc, which is already
> packaged by any sane distro out there.  The configure file is updated to
> check for that.

I guess RHEL is not a sane distribution, then.  :)  pandoc was abandoned
in favor of ghc-pandoc, and RHEL does not ship a haskell compiler.  It
would make RHEL packaging considerably easier if the generated man pages
continued to be part of the upstream git tree.  If that's not acceptable,
then I can work around the problem, but it will be a pain.  At the very
least, please make generation of the man pages optional via configure.

Thanks!
Jeff


