Return-Path: <io-uring+bounces-12655-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Gp+OInhsmmWQgAAu9opvQ
	(envelope-from <io-uring+bounces-12655-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:53:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5087274F1E
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E05433020EE2
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044783B5830;
	Thu, 12 Mar 2026 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P6jfkVRh"
X-Original-To: io-uring@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C182BE02A;
	Thu, 12 Mar 2026 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330813; cv=none; b=isfAZ/e1wsUr9EKAdIijQW+bfWF/GAOurjrukC7vsBBJciL5XKulxL+4VBGKJOH6bS7qw5Ep1PHqm+XW+52+7ZNFPUcoYPgs3VPN/xKnv4PvVgOZVdPM2cmnWgQthajX2uI+ise3sf2EunA07QBDxrX6xIu/GS+r8PkuNSZkIXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330813; c=relaxed/simple;
	bh=PkJcY5jw3a/IMyywYskRQhFWglzwewQyVwQJhJNMB14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEwStlk8ZgB5bu8LSqakDOgX/qOmA+iY6iZX88eV2sHAlem4qEVZnL+6cCZAvbR8PVpUq/isakLMPxTTTT23XNGU4W6ZF1gaPkn+u+GinJ3m+wNwZuUZ094x7LudMyZCe1RqDphca2exTIKS2QLzcDFnIafWr2Hfrjz27KJ2P+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P6jfkVRh; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=5pK/vbHjomF7ZCz8kPkvw2tTjUJzJ46B59krQRBArKA=; b=P6jfkVRhJlvjsFD7S+pYuzAuv4
	MLDDYDxGdAfivMXXxo/ZUVApw1nd+jENAw0Lyqc4uWfI7XnqjHOAqA7ttXYJsxG4TAasEr7BjpDWo
	aIeA1snKPi45aV1ULkpxeeIBktxDuhCSFmRpLsMt1+ttYrsG44v3EOWhuPyWXdpRzlHxyEOn74GDA
	Z1CGVzkjGPeaU2YAiJd8rj+ihgYeubYRKoTBEzXo+qEnQBbcOv9+Up7MVLIY/DcZTAGZThMyG8xOO
	o5W6SO+boLGEUOkS89Aq38o86dricntUVfJsA834gNk6HDFKQEuSPpArtEtoOedubfSWkO9Rzjeky
	ZIr57Svw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0iLn-00000001W9W-22gb;
	Thu, 12 Mar 2026 15:53:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6325030049C; Thu, 12 Mar 2026 16:53:26 +0100 (CET)
Date: Thu, 12 Mar 2026 16:53:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: Re: [PATCH 01/15] tracepoint: Add trace_invoke_##name() API
Message-ID: <20260312155326.GB1282955@noisy.programming.kicks-ass.net>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <20260312150523.2054552-2-vineeth@bitbyteword.org>
 <20260312111255.7925b4e2@gandalf.local.home>
 <CAO7JXPhg-Etspj9YahZrq8cmZ2K6AGWDrMnHO+oD96P_SmOLBw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO7JXPhg-Etspj9YahZrq8cmZ2K6AGWDrMnHO+oD96P_SmOLBw@mail.gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[goodmis.org,ilvokhin.com,kernel.org,efficios.com,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,hansenpartnership.com,oracle.com,fb.com,suse.com];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12655-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[72];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,goodmis.org:email,bitbyteword.org:email]
X-Rspamd-Queue-Id: A5087274F1E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 12, 2026 at 11:39:06AM -0400, Vineeth Remanan Pillai wrote:
> On Thu, Mar 12, 2026 at 11:13 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu, 12 Mar 2026 11:04:56 -0400
> > "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
> >
> > > Add trace_invoke_##name() as a companion to trace_##name().  When a
> > > caller already guards a tracepoint with an explicit enabled check:
> > >
> > >   if (trace_foo_enabled() && cond)
> > >       trace_foo(args);
> > >
> > > trace_foo() internally repeats the static_branch_unlikely() test, which
> > > the compiler cannot fold since static branches are patched binary
> > > instructions.  This results in two static-branch evaluations for every
> > > guarded call site.
> > >
> > > trace_invoke_##name() calls __do_trace_##name() directly, skipping the
> > > redundant static-branch re-check.  This avoids leaking the internal
> > > __do_trace_##name() symbol into call sites while still eliminating the
> > > double evaluation:
> > >
> > >   if (trace_foo_enabled() && cond)
> > >       trace_invoke_foo(args);   /* calls __do_trace_foo() directly */
> > >
> > > Three locations are updated:
> > > - __DECLARE_TRACE: invoke form omits static_branch_unlikely, retains
> > >   the LOCKDEP RCU-watching assertion.
> > > - __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
> > > - !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
> > >   when tracepoints are compiled out.
> > >
> > > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > > Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> > > Assisted-by: Claude:claude-sonnet-4-6
> >
> > I'm guessing Claude helped with the other patches. Did it really help with this one?
> >
> 
> Claude wrote and build tested the whole series based on my guidance
> and prompt :-). I verified the series before sending it out, but
> claude did the initial work.

That seems like an unreasonable waste of energy. You could've had claude
write a Coccinelle script for you and saved a ton of tokens.

