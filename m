Return-Path: <io-uring+bounces-12660-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HdLE93vsmlBRAAAu9opvQ
	(envelope-from <io-uring+bounces-12660-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 17:54:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF2A276068
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 17:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CBA19300F788
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2C43E8697;
	Thu, 12 Mar 2026 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFrQITnb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146E6390C99
	for <io-uring@vger.kernel.org>; Thu, 12 Mar 2026 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334485; cv=pass; b=lkbhuz8AyFjXOuXtmwOVYmQa+GXscgMFl17QUqH6ihy9/Pxh8K7phq1s8hOMox5SAOV0jEkJOxSoC30o3DnPS2XUj1G1OBys2+kUeEmOmU2Wbzt1uBWEUByAsQ3q0bvCjkJJHqxsqG8Mwgt8Quzvi58OH9kT0kEZ89ISGLpK9ZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334485; c=relaxed/simple;
	bh=0ivvtg/7i339ZQR+9yPgWn9tEIiWD5JfW0IrpKNu4D4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b3YCi91R+5bAnc3pO4T1k1sqdm2NvLO7xWR2id8mjQfOVChpkFBZjo/iyIetrF3ldqR6pSvKuFUVO4njV3V4HC7pljs3R89lS8XGpV6/+piZ5MEZX9iFdQeT9lZ4rMBLQEHdH6PKoFAK/IVXgY711K9FeSEBJZpdua7B9HBljtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFrQITnb; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35a1dd9c842so316898a91.1
        for <io-uring@vger.kernel.org>; Thu, 12 Mar 2026 09:54:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773334483; cv=none;
        d=google.com; s=arc-20240605;
        b=ZYbIs++MqhqDlwgXClPOoS3EJ6Q3nuQuApKkKwTsHSoSiaylUAvDBgAVpMUNJPu58M
         XCr7r9eIToIy3Wg/pv9wzolcUiyDdPLZJtTdRu/MXM4UhMUsV95zjTTplZNuqkeKvfqe
         SQJQfFru8E17DROj/t817XBcFcG2zB/7hAUEVUJAz3MFDmkuMl9k+8ZJ6L+ck4TGiPle
         sAoCVOEfJMxpZjyEcEA7HXe0xTYgoLB6UBeMyArBiG9NgrODf24CzPPrzTyUcqNcBz8l
         MfVRsxnS4hMk/wqD4im1zDgt2gkeWSkk4iM32YFYCbjjydO9GxLILTyRfNTkZ/PFXmPs
         Nu0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+kWy5KRAZzJ0k+gfnUe4+KiD3cukw8nZMNARL7dWDnQ=;
        fh=rAMYctAjFG1o8hwD3Uwa1SmE7Dnb0aNJ01LLdLXMbDA=;
        b=MOR8pfKA+Lwag4cyHi6yajEBbng0JNbLcBszFrvqX/lq8YyPmRcgxAr/1Z1o+lfjBr
         UZa8q9rUrfiqNohVJ4vC80Wo9rR6wBt/DYXjIq+scA7QylXQFJFKRSPdUzM2p+dqSS3v
         eaAyY7JDc8Yhnb83j/R20I3WLbWS0e9PwqJSYL5nL7eXx37bY6ifqy+A3ej1BLpPILe2
         q6lvxnWqEdsKNXzGdsRJ1J1tQHnwT/ZoQ+V2A3jC6cxATGVy5pQX45DkpDjmYuc6CcBn
         3gVSDjVrsqehYd6pvi3fS2J2C36aJP4HTQh/2UlywYKPl0ewhWvtIj4ql0Wb1Fj3PiMH
         Yx9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773334483; x=1773939283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kWy5KRAZzJ0k+gfnUe4+KiD3cukw8nZMNARL7dWDnQ=;
        b=kFrQITnbSdq6fGGAo1Qs91MmVTz356ySgdYWMhoXz+qDA2sI5h/kKKPobud1lef9Qq
         Vnjg2VUjWxY13G90CmzMMLIGG1mhAwthMdOZYeJon+O+0g87Kr6AJ417GKQwYBg4ntGg
         crbqh1wylitW5W3iDY0c9cFEY7XSz1kk+X6ijp5ETi+DfQfNFfcOE0+jm8SyHkpkeZCH
         z7cnWY15WdETUtxAXisuTIbTwonAFvkgAQR0r46HDiAaLCOdaFl6hAZomSDbAEI+l/d2
         UjnUvLY2rcGWyZPKGUWcqGXGW+Udo+G6jXAxvhMluPCc79Lf1wiRS3jOdfepdDepHnRM
         dA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334483; x=1773939283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+kWy5KRAZzJ0k+gfnUe4+KiD3cukw8nZMNARL7dWDnQ=;
        b=pWknW0BH25AZj4UnVtY5O1Ca+9KvmzNAmxADtKYlGVWZIisELHtTlgblXxfdO8H0C+
         mAIpX/JWEuDLqbQetWx7tS+xnk8epJC+90UdhYPAQ4xB39kdbWpZngIciLhFEDVVy6VG
         g5jK8H+5ogT9Z/L8oFk4Mk6EMt9fvRBG1GGOcb9HE8gBqqzp1aXGXYMDYC/mNReaZztU
         P1iEO2k3tdQDxv1i24CMRv87lDJ117OvePxXcH07GLLPB/sCe1qhEIsJS4LgqUd9cMdw
         /HYz6D51a0yeSgbjIGKlMeMIB5K6u8donrWmQYXRuYm+VYrAXGLwmgI0Isx+KjPKlI68
         oscg==
X-Forwarded-Encrypted: i=1; AJvYcCViG573H88ClYnWa8Nq8Wg2aiJj19mbq0h6dIlIX5llsCP2ZltfILAsNDnBbCreBdNhDUDCp+oWTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx6t+KkHvDApU5vkY1sSiEYpbVS9LZj2T2NmAohhvU7i9i5mFh
	/8Qy9eKjEnUPVSq45WliF6vxG1E32E+Pnsh4QmUCrCEBaCzVLG9pebaAL/Bb9GUfZvRBqZ7a9lU
	nrTp4SqvwnSy/u80aU7OnqxfqAU2rcFk=
X-Gm-Gg: ATEYQzy4+ILTO0vGyKLffbh/QGnA1Yr1XcLp/WnluYn8junq4d8cbM1Gqm3F94E/Him
	BoYU9Um26eqI9GHoCW4xZcf62frQkvT9IhZKRggB6mVaCHVL/JsH12OVB1JOHEf2NWaefB3eMj+
	JINP5SrBB+TibpnRYvVXUN8RyJW8wABdymPJH6I6jmusVaHRHZRmXZFAYO1E9re9z8B3JFVTpqY
	PdlK5THstK4DfeWBpLXu9jiuc0cM/Pu5x5RH4jVb03xU1is+VYIOcm0BtNDvb2lfCljHXcDV/4r
	yHLdU543czS35tWlTkJxQZ4=
X-Received: by 2002:a17:90b:288e:b0:359:8d0d:5905 with SMTP id
 98e67ed59e1d1-35a21eba194mr250522a91.9.1773334483388; Thu, 12 Mar 2026
 09:54:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com> <20260312112354.3dd99e36@gandalf.local.home>
 <219d015d-076b-4c80-8f63-88569115fdad@efficios.com> <20260312114041.5193c729@gandalf.local.home>
 <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com> <CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
In-Reply-To: <CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 12 Mar 2026 09:54:29 -0700
X-Gm-Features: AaiRm51tg7oVvkVGab0X55k0oYxIuUltKNvtNsrbO-Cw57of2y67mwv1ziUvJS0
Message-ID: <CAEf4BzbnfyhCqp0ne=2gRnVxp-mdGmuZwDeFRyhRYH+eDcz2-w@mail.gmail.com>
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	io-uring@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Jon Maloy <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, 
	Eelco Chaudron <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, 
	bpf@vger.kernel.org, linux-sctp@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net, dev@openvswitch.org, 
	Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz <koby.elbaz@intel.com>, 
	dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Len Brown <lenb@kernel.org>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, 
	linux-pm@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>, 
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, 
	Eddie James <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Joel Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>, 
	=?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[efficios.com,goodmis.org,infradead.org,ilvokhin.com,kernel.org,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,hansenpartnership.com,oracle.com,fb.com,suse.com];
	TAGGED_FROM(0.00)[bounces-12660-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[73];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andriinakryiko@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 9AF2A276068
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 12, 2026 at 9:15=E2=80=AFAM Vineeth Remanan Pillai
<vineeth@bitbyteword.org> wrote:
>
> On Thu, Mar 12, 2026 at 11:49=E2=80=AFAM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > On 2026-03-12 11:40, Steven Rostedt wrote:
> > > On Thu, 12 Mar 2026 11:28:07 -0400
> > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > >
> > >>> Note, Vineeth came up with the naming. I would have done "do" but w=
hen I
> > >>> saw "invoke" I thought it sounded better.
> > >>
> > >> It works as long as you don't have a tracing subsystem called
> > >> "invoke", then you get into identifier clash territory.
> > >
> > > True. Perhaps we should do the double underscore trick.
> > >
> > > Instead of:  trace_invoke_foo()
> > >
> > > use:  trace_invoke__foo()
> > >
> > >
> > > Which will make it more visible to what the trace event is.
> > >
> > > Hmm, we probably should have used: trace__foo() for all tracepoints, =
as
> > > there's still functions that are called trace_foo() that are not
> > > tracepoints :-p
> >
> > One certain way to eliminate identifier clash would be to go for a
> > prefix to "trace_", e.g.
> >
> > do_trace_foo()
> > call_trace_foo()
>
> This was the initial idea, but it had conflict in the existing source:
> call_trace_sched_update_nr_running. do_trace_##name also had
> collisions when I checked. So, went with trace_invoke_##name. Did not
> check rest of the suggestions here though.
>
> Thanks,
> Vineeth
>
> > emit_trace_foo()
> > __trace_foo()

this seems like the best approach, IMO. double-underscored variants
are usually used for some specialized/internal version of a function
when we know that some conditions are correct (e.g., lock is already
taken, or something like that). Which fits here: trace_xxx() will
check if tracepoint is enabled, while __trace_xxx() will not check and
just invoke the tracepoint? It's short, it's distinct, and it says "I
know what I am doing".

> > invoke_trace_foo()
> > dispatch_trace_foo()
> >
> > Thanks,
> >
> > Mathieu
> >
> >
> >
> > --
> > Mathieu Desnoyers
> > EfficiOS Inc.
> > https://www.efficios.com
>

