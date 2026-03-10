Return-Path: <io-uring+bounces-12629-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cXhVIKGasGnhlAIAu9opvQ
	(envelope-from <io-uring+bounces-12629-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 23:26:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1FE3258E2F
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 23:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0FE8B303F57D
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 22:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8842E39DBD8;
	Tue, 10 Mar 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMy2nOqh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6215536B059;
	Tue, 10 Mar 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773181595; cv=none; b=mbra+PHpKH59RiAAUVmRN0HXNCq/YLoF+TTCcTNUha6LQayQ2/2F8JC/htDj/J1ycBTpWLN8uFg72yqLesnH6xbqFGF4/RrQC62Ny/Pgo0NmJqI0L9y+h9heHETKStLzIXodCKOi49+P1VX6Dw3GHvXAqQbfgXZMqfyuZ1T+icY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773181595; c=relaxed/simple;
	bh=MiJVL62qsCyYZ8Q9hg91dFKxbXDSYJtJCUMeT8RSe5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzltQDOc+47yBPp0UPHlO4i4FKpoaSqmmNkaeaCq7fGV62QgBj/UT60LKHRQJ4KJuS+AFPzUKqOrzuWo62c7UAPa3BxDf75geRITydfZqPiUgTuZoEZANJea6V7XcwAERW2lTJrWOeNyB8zcvoJTpb2UxeNYLgIsouekBdCwpsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMy2nOqh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8FBC19423;
	Tue, 10 Mar 2026 22:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773181595;
	bh=MiJVL62qsCyYZ8Q9hg91dFKxbXDSYJtJCUMeT8RSe5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tMy2nOqh+lVisv69GNVkSEJt9g1Qr03MTTHGiOse6QUzZ53kMuiZ9S3G/hr+PrjWV
	 WXXccBj9JrPQmy+65UMvGxFAzUZGCzx+HL+lsh9m3ng4XtJEjlbzkcehgnVDGbr2jf
	 H7401RW21twx1DfnOyOgWcLmrhAwXMDz+aPc0CjPkfj0bQd1FAXpGtXdwVCf7MXT2W
	 qK+qK1HU5qRHWQyisgFCoJkoMB443UUFJwY0t765rBOzGtuwhhRck7uNrNws1O+Ezh
	 /MPIXuSi4KPVpBWwO5VDi42YtNab2U1otLRJr4Smmely+UMIFs/EU8EnVUrIQv+lhO
	 Xb0W5tD+XouiA==
Date: Tue, 10 Mar 2026 23:26:32 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
	kunit-dev@googlegroups.com, linux-doc@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, netfs@lists.linux.dev,
	io-uring@vger.kernel.org, audit@vger.kernel.org,
	rcu@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Christian Loehle <christian.loehle@arm.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kthread: remove kthread_exit()
Message-ID: <abCamDkRssM8QUVa@pavilion.home>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
 <20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
X-Rspamd-Queue-Id: E1FE3258E2F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12629-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frederic@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Le Tue, Mar 10, 2026 at 03:56:09PM +0100, Christian Brauner a écrit :
> In 28aaa9c39945 ("kthread: consolidate kthread exit paths to prevent use-after-free")
> we folded kthread_exit() into do_exit() when we fixed a nasty UAF bug.
> We left kthread_exit() around as an alias to do_exit(). Remove it
> completely.

Thanks for fixing that UAF! I unfortunately missed it.

> 
> Reported-by: Christian Loehle <christian.loehle@arm.com>
> Link: https://lore.kernel.org/1ff1bce2-8bb4-463c-a631-16e14f4ea7e2@arm.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

