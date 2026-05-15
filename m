Return-Path: <io-uring+bounces-13352-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHG6GP4pB2rgsQIAu9opvQ
	(envelope-from <io-uring+bounces-13352-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:13:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4765511DD
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF7CF30107F0
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4D147D93B;
	Fri, 15 May 2026 14:04:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA28C481FD3;
	Fri, 15 May 2026 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853891; cv=none; b=FzKVs6I7VX9MYLx+GmgZlODJwoyYAeKHhldVnb0w+j3tnPT1dhFjBFso/MzUaKmVob6Dna7giDEC65U8mdS8rTy1PsQCL0+X6gVgz/ZZ4kXk+q/uXKceiWiVo6ZAWN3k8Rv0LbGQgCe8BhjQLW2/0W49qONOAIy7Ybyc/v2/fQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853891; c=relaxed/simple;
	bh=a4rLErMOWg6d2WSQIOfFnoxXjYJCxR1igfe3YIucAS0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cZ8R6QPgFLnvHuGI6aBx/M2UGGpLlUk+r1vd4ARd0/z3MGNFC9Pdg5p1LQPWycRLX1TJnD6Mt+eZF7AAcoCOjq53Tx274yB+yBYqX6fxBzjRpDX3pTxaW+Z6Mnh2HLacAWzz0eS8iig9rgnEePwGlGiY49grDkE8oP2rKqBSia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F294A1A00EC;
	Fri, 15 May 2026 14:04:42 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 28EEE2F;
	Fri, 15 May 2026 14:04:41 +0000 (UTC)
Date: Fri, 15 May 2026 10:04:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 01/11] io_uring: Use trace_call__##name() at guarded
 tracepoint call sites
Message-ID: <20260515100448.715589f6@gandalf.local.home>
In-Reply-To: <20260515135903.2238731-1-vineeth@bitbyteword.org>
References: <20260515135903.2238731-1-vineeth@bitbyteword.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1t3hq8tyz3pe3o9kjmeyc47tpw6jt155
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/dwOBiOhHojBhVtxMJ+MTplucGfB4fjAI=
X-HE-Tag: 1778853881-800517
X-HE-Meta: U2FsdGVkX1+X/nbcDBP9T8AusXahy0hJ5Uuv85d1hYx9Dfg0hmDH/oRGpX/nNIVyFFNgKNH+NyDEriaAcMLDn6XoYUnmfghv+aPNa6iPXu3yzJ2ZnHxrG1O0dBtATR2j5L8FnWdcMgXzFpH/5Xa9LGexRU2oHyeV3TSRTjtkMj4cQEixXnZE3vXk/YX6WOR8c0erMi6MjFeROn2Hx9JZocacFwLCIo9H0ul7Po/ElvW9a+W/EMGFZ1TdEHAV4kRzrIXTKjg2lHzFGUM+9gJj8YIjw678LxWFP70l7BYpqkqsA9mPw/Yr9kSfXbvVolBDBy1fH4E9ewEQSzJasKDo3Jah+4yAIPxobPDOTjYmicGyEFLUhoyOfmcUYjnzMcYwJAmyTPVAYra213DsdzZwoGVb2MsRjnsYZgbTcGK/6EHuPpusrmqxmsxFJHhHfjVrtgy0mb/xUKnza6lWWueyZsJM5N2XnMCK9y68dsBOo58L7gPCK5m/uAUSs45w/vleNX+RjKpXQcw=
X-Rspamd-Queue-Id: DD4765511DD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[io-uring];
	R_DKIM_NA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13352-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[goodmis.org:email,bitbyteword.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:email,gandalf.local.home:mid]
X-Rspamd-Action: no action

On Fri, 15 May 2026 09:59:03 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

> From: Vineeth Pillai <vineeth@bitbyteword.org>
> 

Hi Vineeth,

> Replace trace_foo() with the new trace_call__foo() at sites already
> guarded by trace_foo_enabled(), avoiding a redundant
> static_branch_unlikely() re-evaluation inside the tracepoint.
> trace_call__foo() calls the tracepoint callbacks directly without
> utilizing the static branch again.
> 

> Original v2 series:
> https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vineeth@bitbyteword.org/
> 
> Parts of the original v2 series have already been merged in mainline.
> This patch is being reposted as a follow-up cleanup for the remaining
> unmerged pieces.

This part should go below the '---'. There's no reason to add it to the git
change log.

You should probably also state that these can now go in individually as all
the dependencies are upstream.

> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Assisted-by: Claude:claude-sonnet-4-6
> ---

  <<here>>

Thanks,

-- Steve

>  io_uring/io_uring.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index e612a66ee80e..1b657b714373 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -312,7 +312,7 @@ static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
>  	}
>  
>  	if (trace_io_uring_complete_enabled())
> -		trace_io_uring_complete(req->ctx, req, cqe);
> +		trace_call__io_uring_complete(req->ctx, req, cqe);
>  	return true;
>  }
>  


