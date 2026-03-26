Return-Path: <io-uring+bounces-12865-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKS/IwKNxGlr0QQAu9opvQ
	(envelope-from <io-uring+bounces-12865-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 02:33:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0830632DF06
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 02:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94355302800C
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 01:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD82370D79;
	Thu, 26 Mar 2026 01:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLfhqhkz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FBAF4F1;
	Thu, 26 Mar 2026 01:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774488531; cv=none; b=PfZcJtRbXoGVAEVhBuPV/c8amRd0+d9nPDDbcTRhcSRkSlozRgxI4LJvZx1N/VrC80RHM3LZ/ocKuQPJV2arhQoYk01jYtCCA0qkqOho9eL/k0wiHSDMoc/DEqUrWTYJt3YsffIBxctROBTU7nowukEM4Y3mghA7t7ve9zuE9P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774488531; c=relaxed/simple;
	bh=0Cq7OMqDyz29Hy/YQIvOOTgh39yp/jjxAwDycnlq/O0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WUy6Adt/wTSA2KclWJzTRK3DBM6NvXfdRYO9O51OS3uJiN2S7VmuEBVqfV8fJKFB2cSIbxPioovUs2hkuyPWfq91a2RmVbTK4c8EEq1oxtWUObO/STRlK9n4A+qNfMA5NFkC4CyQ1uy1srPr8fUy2zIJnxggaM3wMmZZPJef4YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLfhqhkz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3592AC4CEF7;
	Thu, 26 Mar 2026 01:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774488531;
	bh=0Cq7OMqDyz29Hy/YQIvOOTgh39yp/jjxAwDycnlq/O0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MLfhqhkzsxa7tc0jHzhytzV6qchl81dHU9KAPgpYRYmOHYLzk4wblKHPtqEHyv28p
	 Q/b1ZGVBAKVMA2DtsWIH4xs0i1VJ2p7crVWlc/njQGIq3j2rxJcz4zZlqQtGtXSKGY
	 qE7kmn3skAAmdHpynUh6G1IcDYzRBpRJQJ2v9dHtuEYl1SHM9u79m3ODxDTtFbRHwF
	 TrXVRIXikjQcC748T/h8YzRRuj5Is74hno4IqadGPqhCATzpJM+vXtHmT1645lImlw
	 xbcKSEnaeY6vjDCFgor9rDZ7RPAf5TB+nN0PUncVs3G3ToCrGTMxxDR5q52eHlIdvK
	 yL93d9yknBOTA==
Date: Thu, 26 Mar 2026 10:28:40 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra
 <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Jon Maloy
 <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, Eelco Chaudron
 <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, dev@openvswitch.org, Jiri Pirko
 <jiri@resnulli.us>, Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz
 <koby.elbaz@intel.com>, dri-devel@lists.freedesktop.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar
 <viresh.kumar@linaro.org>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
 Huang Rui <ray.huang@amd.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Len Brown <lenb@kernel.org>, Srinivas
 Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org,
 MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park
 <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Sumit Semwal
 <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, Eddie James
 <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, Joel
 Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alex Deucher
 <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, Matthew
 Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, Harry
 Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
 amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, Benjamin
 Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, Wolfram Sang
 <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, Mark Brown
 <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>,
 Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Thomas Gleixner
 <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, SeongJae
 Park <sj@kernel.org>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/19] tracepoint: Add trace_call__##name() API
Message-Id: <20260326102840.80a270ec818fea7e000aeef4@kernel.org>
In-Reply-To: <20260323160052.17528-2-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
	<20260323160052.17528-2-vineeth@bitbyteword.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[goodmis.org,infradead.org,ilvokhin.com,kernel.org,efficios.com,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,resnulli.us,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,HansenPartnership.com,oracle.com,fb.com,suse.com,linutronix.de,linux-foundation.org,kvack.org,alien8.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12865-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[81];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mhiramat@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:email,bitbyteword.org:email,goodmis.org:email]
X-Rspamd-Queue-Id: 0830632DF06
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 23 Mar 2026 12:00:20 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

> Add trace_call__##name() as a companion to trace_##name().  When a
> caller already guards a tracepoint with an explicit enabled check:
> 
>   if (trace_foo_enabled() && cond)
>       trace_foo(args);
> 
> trace_foo() internally repeats the static_branch_unlikely() test, which
> the compiler cannot fold since static branches are patched binary
> instructions.  This results in two static-branch evaluations for every
> guarded call site.
> 
> trace_call__##name() calls __do_trace_##name() directly, skipping the
> redundant static-branch re-check.  This avoids leaking the internal
> __do_trace_##name() symbol into call sites while still eliminating the
> double evaluation:
> 
>   if (trace_foo_enabled() && cond)
>       trace_invoke_foo(args);   /* calls __do_trace_foo() directly */

nit: trace_call_foo() instead of trace_invoke_foo()?

Anyway looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>


> 
> Three locations are updated:
> - __DECLARE_TRACE: invoke form omits static_branch_unlikely, retains
>   the LOCKDEP RCU-watching assertion.
> - __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
> - !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
>   when tracepoints are compiled out.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Assisted-by: Claude:claude-sonnet-4-6
> ---
>  include/linux/tracepoint.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 22ca1c8b54f32..ed969705341f1 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -294,6 +294,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  			WARN_ONCE(!rcu_is_watching(),			\
>  				  "RCU not watching for tracepoint");	\
>  		}							\
> +	}								\
> +	static inline void trace_call__##name(proto)			\
> +	{								\
> +		__do_trace_##name(args);				\
>  	}
>  
>  #define __DECLARE_TRACE_SYSCALL(name, proto, args, data_proto)		\
> @@ -313,6 +317,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  			WARN_ONCE(!rcu_is_watching(),			\
>  				  "RCU not watching for tracepoint");	\
>  		}							\
> +	}								\
> +	static inline void trace_call__##name(proto)			\
> +	{								\
> +		might_fault();						\
> +		__do_trace_##name(args);				\
>  	}
>  
>  /*
> @@ -398,6 +407,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  #define __DECLARE_TRACE_COMMON(name, proto, args, data_proto)		\
>  	static inline void trace_##name(proto)				\
>  	{ }								\
> +	static inline void trace_call__##name(proto)			\
> +	{ }								\
>  	static inline int						\
>  	register_trace_##name(void (*probe)(data_proto),		\
>  			      void *data)				\
> -- 
> 2.53.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

