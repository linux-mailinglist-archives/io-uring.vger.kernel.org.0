Return-Path: <io-uring+bounces-12958-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 66ejOCMe0Wk4FgcAu9opvQ
	(envelope-from <io-uring+bounces-12958-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 04 Apr 2026 16:20:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D60539B569
	for <lists+io-uring@lfdr.de>; Sat, 04 Apr 2026 16:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5872300C005
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2026 14:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D7A273D77;
	Sat,  4 Apr 2026 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DFgIw/65"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD97523EAA6
	for <io-uring@vger.kernel.org>; Sat,  4 Apr 2026 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775312416; cv=none; b=kmCCLD1dUgfqljCyUlYGvZt7ihaiIf0LSxX6awgB32jMZqUJwHkudsEiQMCyRucPJ0tYAXy3F2hgUNS/Gilg3rF0cwcNTbeL481kJob/EPiUrmV/dEfvXjfRHCXrB5kvcm7BJZFkypPTbFjYGgHcNQbwMvMHrgVPMwb/TChekRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775312416; c=relaxed/simple;
	bh=yEQDuRUfs5EyLrZ7zKv7FNBoctv6lGcLCBYn5ggxPCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/TYysyM613UuAre91ltvwBmHyxQKg2xCnREW1oMwkG3yOqm0fd0ZSsZ+9JOs5+FbNG05+hmSvOylrT11fiIhnLoNhDRVSy0lLm7EC2i6KFXArQ0i4coDBo2n3UtcoaJZXKiMzJmZoDKeie9UtKEmvmwfH8p2tn1WnW2FgeYqtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DFgIw/65; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775312414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6gSuSK98E/rohFhWGKFH+2MI05lw+frFAC61yNsoPo0=;
	b=DFgIw/65I9ZUwZS4odntN+IBaQutEjs9iKoSQLgHxBeudDHwGFn9HvDzR03MjnvIToxpXs
	ortv3JD4FuCMp5HZTx01iXjkHF7eQ3z4hkesGZ6VtXPsOark45JRUtudH+2zHkXgYd5c9I
	WyI6A5n1j8y6doS/Ux9HU4VCPCybw/o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-5dGWPv1DPSOfiGrMap3eFA-1; Sat,
 04 Apr 2026 10:20:11 -0400
X-MC-Unique: 5dGWPv1DPSOfiGrMap3eFA-1
X-Mimecast-MFC-AGG-ID: 5dGWPv1DPSOfiGrMap3eFA_1775312410
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E0B21956094;
	Sat,  4 Apr 2026 14:20:09 +0000 (UTC)
Received: from fedora (unknown [10.44.32.11])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 901FF19560A6;
	Sat,  4 Apr 2026 14:20:06 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat,  4 Apr 2026 16:20:09 +0200 (CEST)
Date: Sat, 4 Apr 2026 16:20:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>
Cc: io-uring@vger.kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org,
	luto@amacapital.net, syzkaller-bugs@googlegroups.com,
	wad@chromium.org, Kusaram Devineni <kusaram@devineni.in>
Subject: Re: [syzbot] [io-uring?] WARNING in __secure_computing
Message-ID: <adEeFek83DrfiJOa@redhat.com>
References: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12958-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oleg@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,0a4c46806941297fecb9];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3D60539B569
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 02/17, syzbot wrote:
>
> WARNING: kernel/seccomp.c:1407 at __secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407, CPU#1: syz.0.17/6077

#syz test

So signalfd_dequeue() is called by get_signal() -> task_work_run(), the work
was queued by io_uring... Thanks Kusaram.

Obviously this is not the right fix (and we should not blame io_uring), but
lets test to ensure.

Oleg.
---

diff --git a/fs/signalfd.c b/fs/signalfd.c
index dff53745e352..8819dea943f8 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -158,6 +158,9 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
 
+	if (current->seccomp.mode == SECCOMP_MODE_FILTER + 1) // SECCOMP_MODE_DEAD
+		return -EINTR;
+
 	spin_lock_irq(&current->sighand->siglock);
 	ret = dequeue_signal(&ctx->sigmask, info, &type);
 	switch (ret) {


