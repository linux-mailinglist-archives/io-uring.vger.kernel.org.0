Return-Path: <io-uring+bounces-12656-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKgeMs3hsmmWQgAAu9opvQ
	(envelope-from <io-uring+bounces-12656-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:54:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B55F8274FB4
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:54:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D89C33039366
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1113DA7E2;
	Thu, 12 Mar 2026 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X0043a9Z"
X-Original-To: io-uring@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DF33B5830;
	Thu, 12 Mar 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330873; cv=none; b=n+1p8aoGtiERH6XNeh4C8LvljKvCgkupPA9jxmG4jU12LXghG3vnNskqysU34wiyaSH6KtGniJ18vt86qGD4MPZRcOAgVAEmmWuUMOVmxENABHt5KiJWIYjN7vQaECdaZwUxSVFdfru1dJ6V4YyDZj+FbH1vBjKCCycJDnF6Hoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330873; c=relaxed/simple;
	bh=vlTgds1DWS3jGqCfYHFILlvQj6g5aLpvbOAdG84ObyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXbUc+4fLfaxDpKrMupYcEB7JguT0ss3BcvOmEwE5G7Lrc8M7vLER6OMGJxNxsp21iC83vX9CPQNK+GMysznyPwppFfIsAW7YB2I2HHpbRQVuzZABqd6B6Gb6AUGWyag7W4iMBe/InKX+pemfjOABzSFcjM2U9Uuy39Qf1qtilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X0043a9Z; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J91GOtlULKSH0FD7uF5RTiGJtASwj8AkgmOe2gJa2aA=; b=X0043a9ZKmQ5lGEE/t+XcPXFVN
	jM7ZyVnJzwZCmV+Zph8ti/BGxxXp59cn+7UjXHQnCcs6XNV84+tCSlLfbeNPFj2Zj2h7LFxX6oEnc
	FnFHUpqkRZW4EZ2R1SgXnDyAv9sJ3YzPnrAjcKHTjKulEsLuD7KnCJc+FC+BaWW/MMBfx0AEwSlSV
	VY05Jj+AW+eqnZ0pt4QkRZ1YWlM81rkx+hhROS50f4HrizvygY2gRYDep3A/B3jh+n0k1HpRdnhxE
	ixlMP1y3J5SzEHoWl4dv/SfcGuqj01VmwaMxErjIBFTwGp4SA4KvkVOR6h7bOB0ld/zvCw2HH1+J/
	LBFQr7oA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0iMn-00000001WNG-3QpJ;
	Thu, 12 Mar 2026 15:54:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5586730049C; Thu, 12 Mar 2026 16:54:29 +0100 (CET)
Date: Thu, 12 Mar 2026 16:54:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org,
	bpf@vger.kernel.org, linux-sctp@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, dev@openvswitch.org,
	Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz <koby.elbaz@intel.com>,
	dri-devel@lists.freedesktop.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Len Brown <lenb@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-pm@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linaro-mm-sig@lists.linaro.org, Eddie James <eajames@linux.ibm.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Joel Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>, amd-gfx@lists.freedesktop.org,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
	linux-spi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
Message-ID: <20260312155429.GC1282955@noisy.programming.kicks-ass.net>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com>
 <20260312112354.3dd99e36@gandalf.local.home>
 <219d015d-076b-4c80-8f63-88569115fdad@efficios.com>
 <20260312114041.5193c729@gandalf.local.home>
 <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[goodmis.org,bitbyteword.org,ilvokhin.com,kernel.org,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,hansenpartnership.com,oracle.com,fb.com,suse.com];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12656-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[72];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,efficios.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,noisy.programming.kicks-ass.net:mid]
X-Rspamd-Queue-Id: B55F8274FB4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 12, 2026 at 11:49:23AM -0400, Mathieu Desnoyers wrote:
> On 2026-03-12 11:40, Steven Rostedt wrote:
> > On Thu, 12 Mar 2026 11:28:07 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > > Note, Vineeth came up with the naming. I would have done "do" but when I
> > > > saw "invoke" I thought it sounded better.
> > > 
> > > It works as long as you don't have a tracing subsystem called
> > > "invoke", then you get into identifier clash territory.
> > 
> > True. Perhaps we should do the double underscore trick.
> > 
> > Instead of:  trace_invoke_foo()
> > 
> > use:  trace_invoke__foo()
> > 
> > 
> > Which will make it more visible to what the trace event is.
> > 
> > Hmm, we probably should have used: trace__foo() for all tracepoints, as
> > there's still functions that are called trace_foo() that are not
> > tracepoints :-p
> 
> One certain way to eliminate identifier clash would be to go for a
> prefix to "trace_", e.g.

Oh, I know!, call them __do_trace_##foo().

/me runs like hell



