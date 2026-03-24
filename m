Return-Path: <io-uring+bounces-12819-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOP+Nnigwmm3fQQAu9opvQ
	(envelope-from <io-uring+bounces-12819-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 15:32:24 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4598530A324
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 15:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BFEA3047525
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 14:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5193FEB3D;
	Tue, 24 Mar 2026 14:28:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC053624BC;
	Tue, 24 Mar 2026 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774362484; cv=none; b=h3iPYxXvfn0HYV7ftl81qTGxxKBG2lf/F0Qg3hhLshSQL1MV+BSDizgUyiJkbdJF8qy9SuWMkK5899VCqoQB1EaX96zgWHQF6KepC4Gx91RDol7GHEAcNut1k0//iKz8e5Ii9c2aB5p5PFtDfVWYCeU/kwz/EuZgs3WGn8PkyAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774362484; c=relaxed/simple;
	bh=Tli2X3y0LVZah9JzvHCs3qERanTby0V0BrV4nXSA3Js=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EDiC7YBWVSVjd1xuN7MVDRcf1lwlemnAX/FkCSHp/Ezdt1+m+mPid5mVMNdulCjbxsxh4eT78D7rBs8HwjJ/iKvV8gjj9zg0VDoo27Fby5ccARnIYHDa1LrGYzOUjtE/gLloBphqYFyF+ujqub7B3s3H2caxCrixTxF3dwC49Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F17D9396F;
	Tue, 24 Mar 2026 14:27:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id DC83180011;
	Tue, 24 Mar 2026 14:27:20 +0000 (UTC)
Date: Tue, 24 Mar 2026 10:28:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Jens
 Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo
 Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Jon
 Maloy <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, Eelco
 Chaudron <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, dev@openvswitch.org, Jiri Pirko
 <jiri@resnulli.us>, Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz
 <koby.elbaz@intel.com>, dri-devel@lists.freedesktop.org, "Rafael J.
 Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
 "Gautham R. Shenoy" <gautham.shenoy@amd.com>, Huang Rui
 <ray.huang@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, Len
 Brown <lenb@kernel.org>, Srinivas Pandruvada
 <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org, MyungJoo
 Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>,
 Chanwoo Choi <cw00.choi@samsung.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 linaro-mm-sig@lists.linaro.org, Eddie James <eajames@linux.ibm.com>, Andrew
 Jeffery <andrew@codeconstruct.com.au>, Joel Stanley <joel@jms.id.au>,
 linux-fsi@lists.ozlabs.org, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>, Danilo
 Krummrich <dakr@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Philipp Stanner <phasta@kernel.org>, Harry Wentland
 <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
 amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, Benjamin
 Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, Wolfram Sang
 <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, Mark Brown
 <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>,
 Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chris
 Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andrew
 Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>,
 linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/19] tracepoint: Avoid double static_branch
 evaluation at guarded call sites
Message-ID: <20260324102802.4f8af148@gandalf.local.home>
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rgnt1g9q8d9rzsk6azwgoui85joqhwik
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19u4yDoihzmlvbQbp4GBKk4Sx0FsrK0H8g=
X-HE-Tag: 1774362440-296898
X-HE-Meta: U2FsdGVkX18Kg3NfvHLPV0rnp3UrERb/HeySVgjR0PuCDys+LVJ4s2L8fsy1rJHv82yu9UO4h+xU9iEx3z3YFKVS1OFx2Vvti4rEmq0enV2xaTwbpZ+YWf60TFzb8QMlheid4NsXOVqOYcFPHCn+ZrWqPDCdrmq0l+tkyLSeYhbpJixFuANIjXhtSBZInyEBtAAqHPqUuWZ3PdZupXAY7JMTASH2KNw+CMFxYOXnDTbb38gpzJzBKiUcyoxK6GlO0db0aEPLlOAMHWKzcQEu5msgaweBGFFWtD9G0uWRbe+OcS9gBl+SI1CDJFvGCt0Z8gh5xinNWW7KF0gSIEh3ZlA0AO0+B5wCRjivVxgdquYH5bWbk7CtReb5es0u0tOp
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[infradead.org,ilvokhin.com,kernel.org,efficios.com,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,resnulli.us,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,HansenPartnership.com,oracle.com,fb.com,suse.com,linutronix.de,linux-foundation.org,kvack.org,alien8.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12819-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[80];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bitbyteword.org:email,gandalf.local.home:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4598530A324
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 23 Mar 2026 12:00:19 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

> When a caller already guards a tracepoint with an explicit enabled check:
> 
>   if (trace_foo_enabled() && cond)
>       trace_foo(args);

Thanks Vineeth!

I'm going to start pulling in this series. I'll take the first patch, and
then any patch that has an Acked-by or Reviewed-by from the maintainer.

For patches without acks, I'll leave alone and then after the first patch
gets merged into mainline, the maintainers could pull in their own patches
at their own convenience. Unless of course they speak up now if they want
me to take them ;-)

-- Steve

