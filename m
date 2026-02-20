Return-Path: <io-uring+bounces-12350-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGRyCvlumGkoIgMAu9opvQ
	(envelope-from <io-uring+bounces-12350-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 15:26:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9444A168531
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 15:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD0C3306464D
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 14:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4725F34CFB9;
	Fri, 20 Feb 2026 14:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahGVCc4b"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0444F34AAF6
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771597525; cv=none; b=q+V7F4dwWFebBa1Y60WofVAyYtlNwQzF2oNZA6qoUIo3jmW9IJhSewess6rRCgZrdJ2AJmgVcATHiaw/b0SCvYX3k946Wev8bNecO6jSbijUWSlygBxEOPYeeBlqx5z8I9TDKHMnErFsFdu0lDinJdYwlX28jRERYA7qIGYMc9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771597525; c=relaxed/simple;
	bh=7vk7xriKXoRQGQlD46W7++l4AUcFxEXIvWXuwB2t37Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKTf+zEegZv7fXcfAVrJ8kxEPoNurS8MUKMvz8RXWNYBrX5I7f0cHZpByC16YgtXzNzbZKEIupC0hfiFPaUIbifOdh/9EirFwCX+9Kpj9eTCrrEp3WGFjESn5u4ITtQ0n7f2a9NaLWAS0MkVSP6Ly3Z0lFAqslOnW5KPTfdiRpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahGVCc4b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771597523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OECCMeypFHxrRoOewaiO0T6PUMLs0FQsh+k5BaXKk4g=;
	b=ahGVCc4bZsKlN79yOtzesoFpbWJNVtTFjDGP3kx8zUnH/YMRWH789+fCnHWNhhh+jfgRKH
	uhpJWsffn/SFRebyM+aPFEoG3kdPngD8Ih/wOfh9hw/lpsVkQNlTk1ZzZHWP3L2HQMeO/b
	mZOeywZmgNiwD9Phl8rZ6zYd7pocTJQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-j29xDchaMBKLccF3kU7JhQ-1; Fri,
 20 Feb 2026 09:25:19 -0500
X-MC-Unique: j29xDchaMBKLccF3kU7JhQ-1
X-Mimecast-MFC-AGG-ID: j29xDchaMBKLccF3kU7JhQ_1771597518
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 465CB1800366;
	Fri, 20 Feb 2026 14:25:17 +0000 (UTC)
Received: from fedora (unknown [10.72.116.11])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4F271954117;
	Fri, 20 Feb 2026 14:25:09 +0000 (UTC)
Date: Fri, 20 Feb 2026 22:25:04 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, Anuj gupta <anuj1072538@gmail.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 0/4] io_uring/uring_cmd: allow non-iopoll cmds with
 IORING_SETUP_IOPOLL
Message-ID: <aZhuwOku9lFe33UM@fedora>
References: <20260219172228.429479-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219172228.429479-1-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,lst.de,kernel.org,grimberg.me,vger.kernel.org,lists.infradead.org,gmail.com,samsung.com];
	TAGGED_FROM(0.00)[bounces-12350-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9444A168531
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 10:22:23AM -0700, Caleb Sander Mateos wrote:
> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
> requests issued to it to support iopoll. This prevents, for example,
> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> zero-copy buffer registrations are performed using a uring_cmd. There's
> no technical reason why these non-iopoll uring_cmds can't be supported.
> They will either complete synchronously or via an external mechanism
> that calls io_uring_cmd_done(), so they don't need to be polled.

For sync uring command, it is fine to support for IOPOLL.

However, there are async uring command, which may be completed in irq
context, or in multishot way, at least the later isn't supported in
io_do_iopoll() yet.


Thanks, 
Ming


