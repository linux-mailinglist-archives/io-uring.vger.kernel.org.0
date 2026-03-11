Return-Path: <io-uring+bounces-12631-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLG0OA+xsGnGmAIAu9opvQ
	(envelope-from <io-uring+bounces-12631-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 01:02:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 556F6259758
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 01:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0FB8931258A5
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 00:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523C52A1BF;
	Wed, 11 Mar 2026 00:02:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0E628F5;
	Wed, 11 Mar 2026 00:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773187341; cv=none; b=VMb0drDCQYkjprcAwMqr63QT9mgJ5cRWE+QZEIXn8JpSfDvax7sNctFDjuKiIA70EUn1na7b10jFb2niXieMoQy1n24IBcP/1dZtIPxV1+58d1brDu0MSlLlgZCGDMGJj1yWGK3GHEnFZWGPBvgDV6OsZ1bHFkBWq1044gihUXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773187341; c=relaxed/simple;
	bh=smzvbB4nmsoWyjvlw6IqwQZpGTU4rmIBF86uCfM5iSI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZ7SZw8AML/61LYZF+cYH3QVClpOnHegGEKkHaYUPO71sjzYDiM5Q+n4lFaME/6BEsW2e1BZyMolXCAJSu5lYFDt+iIzDok/b+Wt2L0EsMSmi2OBcG9piL8W4T14/fiz+ZcJEAo8snm/H1rLrULkiXmcSICjsos5XMZOMusthos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BCB113A961;
	Wed, 11 Mar 2026 00:02:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 85BFC20027;
	Wed, 11 Mar 2026 00:02:06 +0000 (UTC)
Date: Tue, 10 Mar 2026 20:02:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-nfs@vger.kernel.org, bpf@vger.kernel.org, kunit-dev@googlegroups.com,
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 netfs@lists.linux.dev, io-uring@vger.kernel.org, audit@vger.kernel.org,
 rcu@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, Christian Loehle
 <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] tree-wide: rename do_exit() to task_exit()
Message-ID: <20260310200217.451cf37e@gandalf.local.home>
In-Reply-To: <20260310-work-kernel-exit-v2-2-30711759d87b@kernel.org>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
	<20260310-work-kernel-exit-v2-2-30711759d87b@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5bg3rrg18jbru7uwkfxn1hbh397psca6
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18LHCHZ+vV3JFPf+Z89JvS/nvAKMsv+FAI=
X-HE-Tag: 1773187326-98008
X-HE-Meta: U2FsdGVkX1/3tMWPLwyG4JCc4wkqvh9SiSPSlhJp6Tv4W/fwSwUFhWXG3UBrBxSzLq3p72eu37Xu4WWh77aTVVkk97xFw9hCg2Tn+gfwvdW114asIqtfy8xHhNrVuERS2G/65ce3/BsvZjC5d8Vnvs35vga+tnTJklfjQ+UttgL5bwbjp5oOgQNdAzx3oibQ4Mzt0N8V0YHeM+nhQRgwSGhlB1291Y2eHefZmXFBYTpQLIIP1XDBd9pac8iHtBZirKQZfE9I0NK+xzIHdGI0aui4vMm56FkppnHJDf/mUfgi8cC8UEAJB61JKAsSDfwj7R599Re8N4CNbTJgYcDwKo1gfVDZt4y9
X-Rspamd-Queue-Id: 556F6259758
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.649];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,io-uring@vger.kernel.org];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12631-lists,io-uring=lfdr.de];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,gandalf.local.home:mid]
X-Rspamd-Action: no action

On Tue, 10 Mar 2026 15:56:10 +0100
Christian Brauner <brauner@kernel.org> wrote:

> diff --git a/tools/testing/selftests/bpf/progs/tracing_failure.c b/tools/testing/selftests/bpf/progs/tracing_failure.c
> index 65e485c4468c..5144f4cc5787 100644
> --- a/tools/testing/selftests/bpf/progs/tracing_failure.c
> +++ b/tools/testing/selftests/bpf/progs/tracing_failure.c
> @@ -25,7 +25,7 @@ int BPF_PROG(tracing_deny)
>  	return 0;
>  }
>  
> -SEC("?fexit/do_exit")
> +SEC("?fexit/task_exit")
>  int BPF_PROG(fexit_noreturns)
>  {
>  	return 0;
> diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
> index fee479295e2f..7e00d8ecd110 100644
> --- a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
> +++ b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
> @@ -82,7 +82,7 @@ check_error 'f vfs_read arg1=^'			# NO_ARG_BODY
>  # multiprobe errors
>  if grep -q "Create/append/" README && grep -q "imm-value" README; then
>  echo "f:fprobes/testevent $FUNCTION_FORK" > dynamic_events
> -check_error '^f:fprobes/testevent do_exit%return'	# DIFF_PROBE_TYPE
> +check_error '^f:fprobes/testevent task_exit%return'	# DIFF_PROBE_TYPE
>  
>  # Explicitly use printf "%s" to not interpret \1
>  printf "%s" "f:fprobes/testevent $FUNCTION_FORK abcd=\\1" > dynamic_events
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
> index f0d5b7777ed7..a95e3824690a 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
> @@ -5,7 +5,7 @@
>  
>  # Choose 2 symbols for target
>  SYM1=$FUNCTION_FORK
> -SYM2=do_exit
> +SYM2=task_exit
>  EVENT_NAME=kprobes/testevent
>  
>  DEF1="p:$EVENT_NAME $SYM1"
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
> index 8f1c58f0c239..b55ea3c05cfa 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
> @@ -87,7 +87,7 @@ esac
>  # multiprobe errors
>  if grep -q "Create/append/" README && grep -q "imm-value" README; then
>  echo "p:kprobes/testevent $FUNCTION_FORK" > kprobe_events
> -check_error '^r:kprobes/testevent do_exit'	# DIFF_PROBE_TYPE
> +check_error '^r:kprobes/testevent task_exit'	# DIFF_PROBE_TYPE
>  
>  # Explicitly use printf "%s" to not interpret \1
>  printf "%s" "p:kprobes/testevent $FUNCTION_FORK abcd=\\1" > kprobe_events

These tests need to pass on old kernels too. So we can't just do a
"s/do_exit/task_exit/" conversion. It needs to test for task_exit first,
and if not found, fallback to do_exit.

See how we handled the _do_fork() > kernel_clone() rename:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/ftrace/test.d/functions#n182

-- Steve

