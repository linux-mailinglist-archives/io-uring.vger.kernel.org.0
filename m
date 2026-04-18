Return-Path: <io-uring+bounces-13065-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WC+nMFEO5GnLPwEAu9opvQ
	(envelope-from <io-uring+bounces-13065-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 19 Apr 2026 01:05:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4B94228BA
	for <lists+io-uring@lfdr.de>; Sun, 19 Apr 2026 01:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B70EB3014BC2
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2026 23:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13E0330B01;
	Sat, 18 Apr 2026 23:05:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFDD28B7DB;
	Sat, 18 Apr 2026 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776553544; cv=none; b=rJ2nZZTF0Xm/mnnQrtMSkPhrJt6isVsW6SmiaInSCfut+mx5fM7bq/4s5R1ZIGsFMvaSC+9Jegs6HVcDHoA6TgEltelucw+iFn8Au+mMwRHPqibld/tM/QduRkIFknB+xmT+dY1+8aK665/ad9+20dHPqxQJIMio/sO6Ik0p2OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776553544; c=relaxed/simple;
	bh=3gjC89xnGxxB+QjjXVBM8oQx83vQETJQ/FYuJTiiO18=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omedgi07McyVfk0Q+HIWV+a9F1cd3qJu6h1d+99LDTkvzyGAdp2ZKYAzvyloj0L64td14PgbyMpkj4DU6VD9t1hdCBW64ag9nhpwGjMA8es9OTkMrbz+pZFgxEwpGyopHjBQZSU+YPADKsreNjSfgpLC1k3ctAVN9G2Olws6H7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A610E4C26;
	Sat, 18 Apr 2026 23:05:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id D63C017;
	Sat, 18 Apr 2026 23:05:02 +0000 (UTC)
Date: Sat, 18 Apr 2026 19:04:56 -0400
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
Message-ID: <20260418190456.631df6f3@fedora>
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 14j39sducs3tg3aey13ys76m4wq4pf1a
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18uI1/Yo7/rI1+CwnTJAuzOiDhDTcHCmFM=
X-HE-Tag: 1776553502-227936
X-HE-Meta: U2FsdGVkX19V5aRBuQVgNrwFYqJny3DiV29cPCLORtmFjnJgNsHv2iodpq+DK7eFwvzFvhgzZ+I=
X-Spamd-Result: default: False [0.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[infradead.org,ilvokhin.com,kernel.org,efficios.com,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,resnulli.us,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,HansenPartnership.com,oracle.com,fb.com,suse.com,linutronix.de,linux-foundation.org,kvack.org,alien8.de];
	TAGGED_FROM(0.00)[bounces-13065-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[80];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bitbyteword.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2F4B94228BA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 23 Mar 2026 12:00:19 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

>   if (trace_foo_enabled() && cond)
>       trace_call__foo(args);   /* calls __do_trace_foo() directly */

Hi Vineeth,

Could you rebase this series on top of 7.1-rc1 when it comes out?
Several of these patches were accepted already. Obviously drop those.
They were the patches that added the feature, and any where the
maintainer acked the patch.

Now that the feature has been accepted, if you post the patch series
again after 7.1-rc1 with all the patches that haven't been accepted
yet, then the maintainers can simply take them directly. As the feature
is now accepted, there's no dependency on it, and they don't need to go
through the tracing tree.

Thanks,

-- Steve

