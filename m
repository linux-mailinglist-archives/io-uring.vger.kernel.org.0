Return-Path: <io-uring+bounces-12753-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFxIO3Mxu2kEggIAu9opvQ
	(envelope-from <io-uring+bounces-12753-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 00:12:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3DC2C3C1F
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 00:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A1633076B49
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 23:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C7135D5F2;
	Wed, 18 Mar 2026 23:12:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCB2345753;
	Wed, 18 Mar 2026 23:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773875551; cv=none; b=rIkKLv+mglAiFYArbeOUvZfJ0j2595Ek/r4y8fNJakjJCrYVMHWU3uk17pyuD3XjfpZ7A3tBrjhccGFmdlRBqYqi+qkEhPS6J5p2x+nhNgKGClp9a5Eqepza2d6MrcoA5v7hl8cJO6uBQyA/rGlAEGKm9863AOQTzEFbFijsm3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773875551; c=relaxed/simple;
	bh=JCh4IeE/Cn60D/pNAmjztbTuiNBWjjTZpNihj1Tve9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCOffRpAytYhlGLwfkI40vvEG4iUXtUnpHJgkQoL5pmEPwghKbGvMoknLhkTGI5s6Ta3ZpugBMjZZJAeIbbujlmudptXkkjeQfyNcJN4rYms+bjHeOvV01LnL8trD2+hTutLEILizZQ+gAVE6rz2RF4y98sJs7vlbB3BPcLOzGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F2241A01AB;
	Wed, 18 Mar 2026 23:12:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 729DB2D;
	Wed, 18 Mar 2026 23:12:17 +0000 (UTC)
Date: Wed, 18 Mar 2026 19:12:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-nfs@vger.kernel.org,
 bpf@vger.kernel.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, netfs@lists.linux.dev,
 io-uring@vger.kernel.org, audit@vger.kernel.org, rcu@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, Christian Loehle
 <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kthread: remove kthread_exit()
Message-ID: <20260318191246.21f5cae8@gandalf.local.home>
In-Reply-To: <20260311104736.51b53405@pumpkin>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
	<20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
	<20260311104736.51b53405@pumpkin>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k3okmar3gqwa3bym6uatb3yctgtgf59r
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18ZAlHD7zRdqyhWTgVQ561leKpKdrlCUw4=
X-HE-Tag: 1773875537-654795
X-HE-Meta: U2FsdGVkX1+7MRZYfjkh8tY3o0PNQxfTCp9CNyhqYR5NFfoxVPCM5iPNukWLzQIvK353tkgDvhZEdUedgHQ5QAkLbovGV5fvwkWyav20iib+DYA0dDHoYUnOxRBuEyIUuWk0DzuG1lL8+oddkej4s1MPcpQDwUN5GqInEA4qcRZLkJpWWxd7t1PfzHXZfqpOcF7WAx+PlcQksO8TPjRtlBOpPJasveRV7LExQmrExj38ijzYTXM4IkABls4ZOZgZxz6jQwh3Jnl0QSJRHa6iPYc7cT5zoaTdKKIxa3A6zx0cZRoh9me2qihdhYWm4g9GrHKVoLJDzQiYMqh11BNCWgZQJ5CMSezB
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12753-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.758];
	TAGGED_RCPT(0.00)[io-uring];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gandalf.local.home:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5F3DC2C3C1F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 11 Mar 2026 10:47:36 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> > -#define module_put_and_kthread_exit(code) kthread_exit(code)
> > +#define module_put_and_kthread_exit(code) do_exit(code)  
> 
> I'm intrigued...
> How does that actually know to do the module_put()?
> (I know it does one - otherwise my driver wouldn't unload.)

It's in the !CONFIG_MODULES section. No module_put() necessary. Only the
kthread_exit (do_exit) is needed.

-- Steve

