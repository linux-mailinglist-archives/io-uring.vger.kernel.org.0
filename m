Return-Path: <io-uring+bounces-12740-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DsxGQGHumnSXgIAu9opvQ
	(envelope-from <io-uring+bounces-12740-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 12:05:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDF22BA770
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 12:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 118EB318F1E6
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 10:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78973BC680;
	Wed, 18 Mar 2026 10:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="Y+F4gIrC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B23AE194
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831542; cv=pass; b=hPFTPfZpSU58n6p6TjM41h2bJArfW9ey4U1uCTjBSjMo4b/aDYj3VMHcrr5hK7J4Rmv09HmfQiI/z5k+H4pWCb8C4ST/FibcuZVwLxpKE2uEQRlhJHcsChRESyPLodsBMuxLSKMG5w0ZR7JvoNGMfGn7lKtnOlrNyeRZmHmQTA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831542; c=relaxed/simple;
	bh=LVVELEXkmiKTU/p+oy+of4jebFSUmNrxF9w9nex4moo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BdZ0gO+QHRYIH9GdMkC+tSWxZ/OZTaYnzgTHpWBosYgpGF4iDsjueqvsp03B7QD+g6BVJR1qaZa77eEz2Zy21FaimEz1gQNu2ZiOwL4wdc6o04HSqMkRmWt9E/Tj2mDxDN/IqUX2z4LAS5+FdcVW7rwmZSfqJ0hq/tbbcbwbO4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=Y+F4gIrC; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79a60975dc5so23527287b3.0
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 03:58:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773831537; cv=none;
        d=google.com; s=arc-20240605;
        b=QBWyqudfrbG4zIQ+iSY2BUgEe6veIdXWm4k9xYOCYZDu4evETsZXeBgWvJQSjcx7Gm
         hbfTirwfvaCmRLxxlTVC6K/Tcy8FwKUPhQMYvB9xc5O5kdN1pKDa8e8CB8xLNtio9FHo
         ydp/wu6F99xkCf62w8Wqux36GyrrEV2l/GCQzlwB/KC6nGFWg4xkCuMyzhnAyuCZlmuo
         xDjNA7N0bCaVH9QuvMn5Bj9ako6bFtSaoHJCPYc6nDO6dGPIcMSCjQZNENNeEQVaL0FG
         lSGzCkRpSnqVhVg+tGHvlD+rV1fue+b0zi4wbesLhIDbm80YPopS0YI1ggk++8Y8VHAR
         2WGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LVVELEXkmiKTU/p+oy+of4jebFSUmNrxF9w9nex4moo=;
        fh=l++AwiaSekbr+mKG+iBLlfcHm3SqBIXMzPtEyIvtIUs=;
        b=F+WStdf9BjXcsHoia2mU8OLoTP028QjCPv1BOl8mLiTcZWOqJ7XlCPE7yKeseol5F5
         8pUO6D/i+lvhja0WQ3X5p7QDIswbiWA188FldmiquEPRk4BhI0+caleXA9r+mma9qGzo
         JpTPA22LE76vkZM9XgnqXGV9lw+SIBLKXeBPCNCx8Fy/IXYQG5O4ZAf+/BHYeMcSHP0B
         r+8tP/4OK7NSm5k5HpZXHuUFdQtOm9Wmv+yvH7sMLgwn9cDmLWEct+GVdhtDLVO4yobA
         DQxDnf1IT/0sx+ROyS2ZSAcUlfl4GOYjVJEQUylxEvfuKyFmqBNyTp1aXLjEIH0OcusS
         wkuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773831537; x=1774436337; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVVELEXkmiKTU/p+oy+of4jebFSUmNrxF9w9nex4moo=;
        b=Y+F4gIrCy3AlMDM7CSYzAY8MdpN5nfDAenVYSS8jF8/QGMe0BtbaqtvpoNu4HHsdwI
         eCHGz033wV+iu7o9yHNzl8ab1W8iVYNVNBYMUrCHRQLI9DZgf1n+KJ5WGJM874ZC8E1f
         V8AfDwxwo6eY0vCZpRljMsNdbb7jgkZbz3BUBCDiRZdtki+wXyJ231XN2e5CQzBOtHl2
         RNzehobgF8tA59rhsLrK604RjKLDzwzujNWXDWsClMTvJ5qFhXeMw/pwvPnR1XkeD7qu
         tmTv/A7/XayQthiGv4k2dz99RPffdzi9GNohb9QPIB0xHVtAoLzYczErYFx/GTFFdjmi
         QFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773831537; x=1774436337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LVVELEXkmiKTU/p+oy+of4jebFSUmNrxF9w9nex4moo=;
        b=fJzxKQ6rNBNJJPHWrGHdoVdh61xQCxfFz2j7TButaPVhiERdpG2Bxm/iQnnHzJ+9zf
         D0BNXKAjq49TDuC6DmdO+594rQM/3FdY75kAwSBd/skpvSEP7JFdrEwtG4Nr12Tl/7kR
         lJglc6OKZm2cXDTdLEJcKtEXBnEK8glWz5moSSWqW5oRlp6DYzD2cS8GPS/etL8aY2vf
         b+fPloaXv+eByTpMt5lHD2CO/NfYg4ROfckBkDnEwzslEqEFvy+VtqFomDNIr4tXMJ/2
         rl8IaHwH9VoIFl6fkao5ehbicWF9fhh194UrHuxU1d5JpygtlcoVFRxPYNnFtrgbIzOx
         m2xA==
X-Forwarded-Encrypted: i=1; AJvYcCWKScnMI2fgjRjl9/XLSGkmcvm6Y9nrUl8aTB2p9pCs6edRqyotY+NyRvBe7y7qAiDZAfGPbSEopg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1SQtRc3OUgM1+EU1UXloYnYWlhWXKBtlDkrxSP2HFA2Gprp34
	enQK3nwjOYwZP1ckD/y0IM16F5XTiOwyiRj7xeRf5RW3vaFHJ9UYeCWQjEkhmjekcWNtWTWa7Uz
	XkGqtF9sZ4znPZtxqsOlX40iB69D6rQ7wb+28Q/snIQ==
X-Gm-Gg: ATEYQzyfgaYdgu0moI9hkorKp5kE6AlR6AMCjrMVhP6imGZKA0uoqpnK91fqvvgoATX
	tFBduQ/8MyDFIia8FCGZKwjCEGyfOMUnv4REwqPyIBA1xkpfYtLvgcWwiYmwaYuLoPst2wDaPY3
	mDvDSPTZS47yuYIpctNl0xhhsm+EoR2rRO0hEAryG+us3RqswOo1ria2keQYPrqUxgVja8CjOG6
	e1P8pkwsbDlLrncRSqhZWdmnaiIYklpGk1DZpj2GbkiwaN/dp0o2uj4o2UFlRSuWLVooridF9p3
	p0ppnWs=
X-Received: by 2002:a05:690c:c50e:b0:79a:3a33:933 with SMTP id
 00721157ae682-79a71ad413dmr29714557b3.31.1773831537485; Wed, 18 Mar 2026
 03:58:57 -0700 (PDT)
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
 <CAEf4BzbnfyhCqp0ne=2gRnVxp-mdGmuZwDeFRyhRYH+eDcz2-w@mail.gmail.com>
 <20260312130255.6476e560@gandalf.local.home> <CAO7JXPgHYZ9zF1HFahb2447X85YRZCQQBHB6ihOwKSDtiZi8kQ@mail.gmail.com>
 <20260317120049.6a60fa88@gandalf.local.home> <6ca9f884-9566-4a82-9995-4c802a0bf8a0@efficios.com>
In-Reply-To: <6ca9f884-9566-4a82-9995-4c802a0bf8a0@efficios.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Wed, 18 Mar 2026 06:58:46 -0400
X-Gm-Features: AaiRm52iP799baA3h48fwfLjW02Pe87nEMlmDoXLIPKYRV2LFYQQkuww_KlSUU0
Message-ID: <CAO7JXPgbERfc_P+aPFB1+nR5ua3mZGbhdkbxCr0TFR4Cr6Khuw@mail.gmail.com>
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii.nakryiko@gmail.com>, 
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
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[bitbyteword.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12740-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[bitbyteword.org];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[goodmis.org,gmail.com,infradead.org,ilvokhin.com,kernel.org,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,hansenpartnership.com,oracle.com,fb.com,suse.com];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[73];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vineeth@bitbyteword.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[bitbyteword.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,efficios.com:email,bitbyteword.org:dkim,bitbyteword.org:email]
X-Rspamd-Queue-Id: BDDF22BA770
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 17, 2026 at 12:02=E2=80=AFPM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> On 2026-03-17 12:00, Steven Rostedt wrote:
> > On Fri, 13 Mar 2026 10:02:32 -0400
> > Vineeth Remanan Pillai <vineeth@bitbyteword.org> wrote:
> >
> >>>
> >>> Perhaps: call_trace_foo() ?
> >>>
> >> call_trace_foo has one collision with the tracepoint
> >> sched_update_nr_running and a function
> >> call_trace_sched_update_nr_running. I had considered this and later
> >> moved to trace_invoke_foo() because of the collision. But I can rename
> >> call_trace_sched_update_nr_running to something else if call_trace_foo
> >> is the general consensus.
> >
> > OK, then lets go with: trace_call__foo()
> >
> > The double underscore should prevent any name collisions.
> >
> > Does anyone have an objections?
> I'm OK with it.
>
Great thanks! I shall send a v2 with s/trace_invoke_foo/trace_call__foo/ so=
on.

Thanks,
Vineeth

