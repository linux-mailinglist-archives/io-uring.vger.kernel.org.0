Return-Path: <io-uring+bounces-12967-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MB5GFvC102nLkgcAu9opvQ
	(envelope-from <io-uring+bounces-12967-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 15:32:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C433A3925
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 15:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F8CA3013028
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2026 13:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1A122D792;
	Mon,  6 Apr 2026 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+17s2hZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7FA2AD3D
	for <io-uring@vger.kernel.org>; Mon,  6 Apr 2026 13:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775482346; cv=none; b=mrpiNHwITqbyXNBQBZZf5nnXEbNP15j2oEsggpfP5F/57odFwqFgUZn1ehRZAtJoJdMnKM2nwG3JqfyAOk75c4qQwkol2jXrP3QeRp3ZJtmWK8ltu/ALexo9U+0RkNoz/+/YRFgY4ZwQCdBByF8kulDJBoarPxHSL4zPjoy1JU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775482346; c=relaxed/simple;
	bh=nEGEhv7+wnrY+VwBbxaJJpu0tm0sndWSC0QdwL8vhBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohbfMerk23ABA56ADTjqdWKQNChUqvbQOY51noptWv9M855hAhWt/eQQGXGBfL8K4Ek6fKx9plrniSdj7k2nNljgr/hguohC+Q7OSECKuq9E3/8inWXwDHrlVpLX6FAurT5bMWPx84uGBuEDbq7x60ytnK3PmC1ZWFVHNHF7hOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+17s2hZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775482344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nEGEhv7+wnrY+VwBbxaJJpu0tm0sndWSC0QdwL8vhBA=;
	b=N+17s2hZl3JKRkgyZOknKIvFNOIEsdmxZ2rQ9E+RNHcuKQj6J4X3m6H6HBTzZtJvr2mYg8
	OczKI9na8JCfB99NvMwNef3+EC9UfI7Pjv9tvM68zNfQrX//T4jCWtJfo4TuVbWzzaZsug
	t2Usj5bN+jKxDbO1d/iKnadZK/hgDRA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-7kzIwLppMRi8ybz9uyaYJQ-1; Mon,
 06 Apr 2026 09:32:17 -0400
X-MC-Unique: 7kzIwLppMRi8ybz9uyaYJQ-1
X-Mimecast-MFC-AGG-ID: 7kzIwLppMRi8ybz9uyaYJQ_1775482330
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5A261800365;
	Mon,  6 Apr 2026 13:32:09 +0000 (UTC)
Received: from fedora (unknown [10.44.32.11])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E10CD1800762;
	Mon,  6 Apr 2026 13:32:06 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  6 Apr 2026 15:32:09 +0200 (CEST)
Date: Mon, 6 Apr 2026 15:32:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kusaram Devineni <kusaram@devineni.in>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] signalfd: don't dequeue the forced fatal signals
Message-ID: <adO11c3GCmLDpgOg@redhat.com>
References: <adKJMRkQJXEwHs-j@redhat.com>
 <202604052136.440E9CFA44@keescook>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604052136.440E9CFA44@keescook>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12967-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oleg@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: C3C433A3925
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 04/05, Kees Cook wrote:
>
> Reviewed-by: Kees Cook <kees@kernel.org>

Thanks!

> Who should take this? I'm happy to add it to my seccomp tree if akpm (or
> maybe Christian wants it)?

I am obviously fine either way, but if nobody objects I'd prefer your tree.

To remind, we have another (slightly related) problem,
[RFC PATCH] ptrace: don't report syscall-exit if the tracee was killed by seccomp
https://lore.kernel.org/all/adKGb5vkyggMK-_l@redhat.com/
I still hope to send V2 "soon" ;)

This is certainly the seccomp material, so I think it would be better to route
both changes via the same tree. But again, I am fine either way, this is minor.

But. I forgot to add the "TODO" note into the changelog. And mk_sigmask() is
not a good name... I'll send V2 with these (cosmetic) changes in a minute,
I'll preserve your ACK.

Oleg.


