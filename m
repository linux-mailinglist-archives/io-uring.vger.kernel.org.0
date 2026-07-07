Return-Path: <io-uring+bounces-13913-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 55QyLhwXTWqauwEAu9opvQ
	(envelope-from <io-uring+bounces-13913-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 17:11:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD3C71D0E0
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 17:11:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IU15Ta2+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13913-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13913-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BF2D430D7033
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2026 14:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BD536C59E;
	Tue,  7 Jul 2026 14:56:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B23D36AB7C
	for <io-uring@vger.kernel.org>; Tue,  7 Jul 2026 14:56:12 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436174; cv=none; b=evhQ+3qnsEIVwOdc9r4amNQFij/5PKyJthP52351yoK08sq9UAg7OyeoFBN0oX7l87XtZsHPj+m1OlqnVGENGb76aGTnQjLYWfwTAJRk6LfJcb/Rtf6KVGXsUgtO4ytiTqHGiBVfdnye/aLIJZB8zIBddCHMNG7yAZKEm9DSKME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436174; c=relaxed/simple;
	bh=K77ln5y8tAHPKmL0aq0j8pZ8eXefV7njhUIVqubjCxg=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=ROi2Sz+wazNnqeSRhiqppEnyUQidU3Z7KUtkXDguID62OjllLVsMFITSE30mGkL1h+7bdAmyCEmm7e+iUb3EowRQLwUzNsqTYFkgt0/EBlpqS/xwTd28i7GayEoNm4UgWy6Wudz6bR8yfMlxJmvMDwU4J+Vj/vknIuYIm5LJSVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IU15Ta2+; arc=none smtp.client-ip=170.10.133.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783436171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m0ahHUuIVyHJfy+2S/IEOeQjY1lP3GYYwMV8mrPeN9Q=;
	b=IU15Ta2+WJgRNs3b64w4YzATnAJUMyyq79BFnEXih6UIZIVPmMpRianfu+tpIm0WylgOyE
	4WKjgKwXdCVH7FZefHMa0LoIA/UKagyHo4QI3qX2lJqxUqp1SZ4ZXmfz5eg32egX/YQZxM
	JAIfiN68aWWpZa5gIivKpdOj2BHNKZ4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-8XCOAJJPMwSuPe8Ztvs9Lg-1; Tue,
 07 Jul 2026 10:56:05 -0400
X-MC-Unique: 8XCOAJJPMwSuPe8Ztvs9Lg-1
X-Mimecast-MFC-AGG-ID: 8XCOAJJPMwSuPe8Ztvs9Lg_1783436165
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87AD31806CB2;
	Tue,  7 Jul 2026 14:56:04 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.80.166])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56E9C3000C13;
	Tue,  7 Jul 2026 14:56:03 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk,  io-uring@vger.kernel.org,  ammarfaizi2@gnuweeb.org
Subject: Re: [PATCH liburing 0/3] Convert manpages to markdown
References: <20260706214132.2841060-1-krisman@suse.de>
	<x49fr1vvvbe.fsf@segfault.usersys.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 07 Jul 2026 10:56:01 -0400
In-Reply-To: <x49fr1vvvbe.fsf@segfault.usersys.redhat.com> (Jeff Moyer's
	message of "Tue, 07 Jul 2026 08:27:33 -0400")
Message-ID: <x494iiax30e.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
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
	TAGGED_FROM(0.00)[bounces-13913-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2AD3C71D0E0

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi, Gabriel,
>
> Gabriel Krisman Bertazi <krisman@suse.de> writes:
>
>> This obviously adds a build dependency on pandoc, which is already
>> packaged by any sane distro out there.  The configure file is updated to
>> check for that.
>
> I guess RHEL is not a sane distribution, then.  :)  pandoc was abandoned
> in favor of ghc-pandoc, and RHEL does not ship a haskell compiler.  It
> would make RHEL packaging considerably easier if the generated man pages
> continued to be part of the upstream git tree.  If that's not acceptable,

Sorry, they don't need to be part of the git tree.  If they were a part
of the release tarballs, that would be sufficient.

Cheers,
Jeff

> then I can work around the problem, but it will be a pain.  At the very
> least, please make generation of the man pages optional via configure.
>
> Thanks!
> Jeff


