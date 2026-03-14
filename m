Return-Path: <io-uring+bounces-12668-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NoFK7iqtGk1rwAAu9opvQ
	(envelope-from <io-uring+bounces-12668-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 01:24:24 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A0D28AE8E
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 01:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F1D330A004E
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 00:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B952248AF;
	Sat, 14 Mar 2026 00:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0nggihj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6C91E1DFC;
	Sat, 14 Mar 2026 00:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773447857; cv=none; b=OmkocTklgA31pph7YOFzSAPAIu9zBaDf4y45ruIhU0+40SD0g/vLUJ7qimS2NoWqjMLV1VnwcOzEEMoNfFwCtJp11/tE55yrT/tlaOaf/te6EbxJXo5rPn3UsJ+BGfgL3hd5/fnKrokdT+gM4fx1cJodd0sUuGlZ9NWiLxeKbtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773447857; c=relaxed/simple;
	bh=WQRXpjIwf6KYkSpJNf4xnZTekqBOFUxWV+yK0mOoxb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IuXgEA8LGhFGAY716oX5be948llbvXznJxvd45NbEuNc0+F6rONKtXKYfWsPqkyhToOiDU0x9i09RVRYOv1NEaLi90l2V7mzYTW5u5is/EJ21nH6vc8euzuipTFjZN/qNJMlKrtJJbLKBCgHsYrSpZkuemFfRjcR4XX5iP4fVxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0nggihj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088E7C19421;
	Sat, 14 Mar 2026 00:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773447856;
	bh=WQRXpjIwf6KYkSpJNf4xnZTekqBOFUxWV+yK0mOoxb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i0nggihjXmXTKML8sut6lB5srcFWHmMKN3tSb0vnbiKDcMNVltZU2CmPxcxFrG3o3
	 nQrXA1wQ5YuTbmhgcTPNORS+379TzqDGm/7lSrQ1+WOrB6YJhRCIjKA7zUUcBgPch0
	 EYChM4p2xmMbNvogwcdaYFHJ9nHAZ56sOZLrj4G67jwJtQWWuJzeM6LK+rXxZtPvPL
	 7hsCy1/fez24lkAmdr6y8xZG7yqBOpidyJ0h37yL3W7fcEPRQk675mEsDmHjbA8Xn+
	 hN93oY8bX37rGdXAEkgAe3QI7f5zrI2DHLm42gIk1V7HmETARtzUHgwH52MHcPBfBz
	 VF6ZMYEbGWSgg==
Date: Fri, 13 Mar 2026 18:24:12 -0600
From: Keith Busch <kbusch@kernel.org>
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
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
Message-ID: <abSqrJ1J59RQC47U@kbusch-mbp>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <20260312150523.2054552-2-vineeth@bitbyteword.org>
 <20260312111255.7925b4e2@gandalf.local.home>
 <CAO7JXPhg-Etspj9YahZrq8cmZ2K6AGWDrMnHO+oD96P_SmOLBw@mail.gmail.com>
 <20260312155326.GB1282955@noisy.programming.kicks-ass.net>
 <CAO7JXPiu8-LE_gG001_GQLoGVYakPdzmH2SXLqfzJjEUxbn1Rw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO7JXPiu8-LE_gG001_GQLoGVYakPdzmH2SXLqfzJjEUxbn1Rw@mail.gmail.com>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12668-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,goodmis.org,ilvokhin.com,kernel.org,efficios.com,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,hansenpartnership.com,oracle.com,fb.com,suse.com];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[73];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 15A0D28AE8E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 12, 2026 at 12:05:37PM -0400, Vineeth Remanan Pillai wrote:
> On Thu, Mar 12, 2026 at 11:53 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > That seems like an unreasonable waste of energy. You could've had claude
> > write a Coccinelle script for you and saved a ton of tokens.
> 
> Yeah true, Steve also mentioned this to me offline. Haven't used
> Coccinelle before, but now I know :-)

[+ Chris Mason]

At the risk of creating a distraction...

This discussion got me thinking the right skill loaded should have the
AI implicitly use coccinelle to generate the patchset rather than do it
by hand. You could prompt with simple language for a pattern
substitution rather than explicitly request coccinelle, and it should
generate a patch set using a script rather than spending tokens on doing
it "by hand".

I sent such a "skill" to Chris' kernel "review-prompts":

  https://github.com/masoncl/review-prompts/pull/35

I used patch one from this series as the starting point and let the AI
figure the rest out. The result actually found additional patterns that
could take advantage of the optimisation that this series did not
include. The resulting kernel tree that the above github pull request
references cost 2.8k tokens to create with the skill.

