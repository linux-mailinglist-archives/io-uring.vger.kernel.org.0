Return-Path: <io-uring+bounces-12742-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wA9mBinCumkGbgIAu9opvQ
	(envelope-from <io-uring+bounces-12742-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 16:18:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F65A2BE07B
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 16:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A5B7230F4D7C
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 14:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8723D9044;
	Wed, 18 Mar 2026 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="XpJ1DAOP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87EB2D97AA
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773845508; cv=pass; b=Xf4UdcS4KDdtKbumu4khH8SI6ReTcLPxchXDf8RRbUa9Y+xjhpVqRuCE4uEC8BaeGr36Pzs+s7sQqPIYgoAdKxDu++g1gGaGoiMiBXL2To8qPaVxiy+SnvcdizJ3m3WfHrD2HUv0mF44Ln6BmgASJ9qZ4bq9XRooFsP8f2bS+nY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773845508; c=relaxed/simple;
	bh=1FISFWtjLoHF5EnuYPOgvH0ljgC076KLVSofovMd6Qc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T675kEVQH1dup4BM3hY5y1fikWRMWhzlCe/+DuDD9w/EzPEL/XNJoHwsBIOeG/QtZS8SG6gx5yJYL3MVTHkQp+xT0T7TTJJU2LdXPjU59DKzX4x2gNHsCPStItoeMQroq54TUaxsIxoPUaRfEktbthDApPbfVxi5s1JRpoVWYd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=XpJ1DAOP; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-64aedd812baso4288d50.3
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 07:51:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773845506; cv=none;
        d=google.com; s=arc-20240605;
        b=HEDn47SAdFqV+5X29RwVKUGOiVUfblS/CktIe2wkIx2j3mf9AVCmTqVu1Tk59RVTzC
         u+mAFnPmQf1IawXBI0mtidZporDR9Z1xiA65h/CtMkPhWWmZalV2IN2oEZ+9VnS6lWge
         pVsq7egFvKCpKPzqP9IeyO5ZCxigrGel1dlJMRxpUpwW1hXtNzkYUxXwCqblrIDemE5U
         QmDN33+n6znPfVHjEYDfvoMKGWwjYEYSXkm2tRzcA5b0r7q+5hyfAONQ6vGv7ALrV4bw
         qDNSnblS4oIbZfmiA6R5TcCl1CNphb+jdr4ZhkKrB0/yNqwOuuSDil66RSBYaZeE3xo6
         ePtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p+amKP2hSQ8rLALonagLiBWsS/hjEbvlJDIAKI1rnTk=;
        fh=uYrC5pLpAHzAacbvLfGNP80I/2/Zozq5MaeFXHFooBM=;
        b=NWblli6t/edxoR7lSJsn4uzOAEIdGTLMsd36SKsYM25dgEkKmDFwLL4jAtnjYkIgFT
         HBKRc29Bf0NmfBZyKjs91SfWrS3jTQqRdIe2FXGTIy7+LGukifG/my/BlRMB4EOi0Dhx
         Ne8K6lPsCZhznpbYdqQJF6uiLL0VBw8j/wDiX8Nqm51ppoNdvWKnCxUzsBYMWdsE0B9X
         bv5PnQY+yvqUrJGMnC+od3pA2Tq5lVjJ1IeuXJdjogq+R/jqoCkb+8QiUT2p/Imst9+G
         7dxy9+jWFde66osmhfhk0CVh/JXiZnQ5nvu/+4NgCFzji2siJZj5gCpN9/3LVRBjLD0u
         L30Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773845506; x=1774450306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+amKP2hSQ8rLALonagLiBWsS/hjEbvlJDIAKI1rnTk=;
        b=XpJ1DAOP/4nAdBA8pNInAjErrB1WwzEJFuO8HmuDUIYaj2cg/1BDSwWXXh5Ed05U3Q
         bEzFS7R7c7xsBrws3lVzQJLQQJFgLEij7/0GOiRjugLMEXl29wR670phhRL3ueHVm8QE
         3mz3euiuEHCK6YyC5OW3x2Sf/xMXOUyaKql0t8Ag/4IlnklPQeUzQu9MtNvM7KgvNSj9
         hU5W4AYkFS4Lly5PDu0SI8uDIrK3wmnvFYsRdI0BqlvFNxTf3dNc6SxGRMVenPGgKuF6
         VF6oqB961lMxoSCe2NtuaTM3bIoXQwAJBwR4oBLXTWquf4IytutPq6FXV/dGE2/rvbWz
         Kn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773845506; x=1774450306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p+amKP2hSQ8rLALonagLiBWsS/hjEbvlJDIAKI1rnTk=;
        b=ZddcRhyzclByjt8TDH5Uy3Ds5ca2oSbaDEbhf/nnwCGDuT2AQVIeW4hkOqvT/OFg96
         C3Fr7ZkH6waoA+hqWsKecXMPhiYLkq5ffoImicQJLha1pAol10qNatUyfafioJiU0LHo
         WjDvKO9vZHEfUYw5QdzNtleHMadTS+689VqRsTzxy3EBX+yjFDwtVnTd7D6ft7MCpntq
         bo5IwJcZzGV2kT1mWPUvHBprB7ZZCDoMR7EZdwaOanNsZVc6Ab43VZSufwCZwCc9lAE6
         7pRFl51s17XenxBWNfMyO4A6b6UTqCOI1OQcmIbJdAjVCM3aLRBqhZUO59jH9/H/APSI
         NjzA==
X-Forwarded-Encrypted: i=1; AJvYcCWvU/AY397+6TBkIDEVMq/G6/VqragLhzyZSFry31hGuQp4jKcNFg1/tUVvRop9ubYUbg7Sbfk7Uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkhrvPfeM5lPAQ6PlW883iXY0M6p9mlfTYeM8rasriZKyCX+sJ
	xYeqU/96FcMpF429+K4BFy1YoqpT3DbLBPRU5d6KG/Kyr6AaS4NceQRhJSGCPpW5M530t59LvQg
	seiLMOrNgwLxgLugmFlCOfuju+iFMnU+R7EliNzmCaw==
X-Gm-Gg: ATEYQzxHfp5Lz4Y1jE/zhrrWzZttztVdeWMM0DyG64ZGZWfl9cjEwqYMXST8iVArtiB
	c3FO9RlZgR5q53F3H2A+/jjTIUz78Pux3FQezC5mI7FBTOBM7oN+UGvx8UeEWoYkg21qE8q1fK1
	7i5+j9tPmoR2+wVTWfSuqGfznSwLXg9Z7sC8pHtqW0yiiMTbH4ZDgjAckgBn+B1yQk0ItJFGjCe
	JtwofqdzqwTV/Ti9tTlxLwEvM6VUseJWk92v48FXeD+yxmf/y9b57KcKZiTdQHyQi6EOSsl5ieh
	AwdsHCI=
X-Received: by 2002:a53:b74b:0:b0:64c:f001:f6b with SMTP id
 956f58d0204a3-64e912fb730mr2882157d50.9.1773845505787; Wed, 18 Mar 2026
 07:51:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <20260312150523.2054552-4-vineeth@bitbyteword.org> <abLapcC7YGYDyJ3L@kbusch-mbp>
 <20260312113816.01de2b53@gandalf.local.home>
In-Reply-To: <20260312113816.01de2b53@gandalf.local.home>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Wed, 18 Mar 2026 10:51:34 -0400
X-Gm-Features: AaiRm514xL8rsuaoYk7l-YfTLHyaymoFYPgJ2hsw1mDadffK5Tx7pElRtPxoCsU
Message-ID: <CAO7JXPhV=08g6AFKGmeaP8T9Uuck12Ky3ZmT8yXTJzZkJ5Gq9w@mail.gmail.com>
Subject: Re: [PATCH 03/15] io_uring: Use trace_invoke_##name() at guarded
 tracepoint call sites
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Keith Busch <kbusch@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[bitbyteword.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[bitbyteword.org];
	TAGGED_FROM(0.00)[bounces-12742-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[bitbyteword.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vineeth@bitbyteword.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid,bitbyteword.org:dkim,goodmis.org:email]
X-Rspamd-Queue-Id: 0F65A2BE07B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 12, 2026 at 11:38=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Thu, 12 Mar 2026 09:24:21 -0600
> Keith Busch <kbusch@kernel.org> wrote:
>
> > On Thu, Mar 12, 2026 at 11:04:58AM -0400, Vineeth Pillai (Google) wrote=
:
> > >     if (trace_io_uring_complete_enabled())
> > > -           trace_io_uring_complete(req->ctx, req, cqe);
> > > +           trace_invoke_io_uring_complete(req->ctx, req, cqe);
> >
> > Curious, this one doesn't follow that pattern of "if (enabed && cond)"
> > that this cover letter said it was addressing, so why doesn't this call
> > just drop the 'if' check and go straight to trace_io_uring_complete()? =
I
> > followed this usage to commit a0730c738309a06, which says that the
>
> You mean 'a0727c738309a06'? As I could not find the above 'a0730c738309a0=
6'
>
> > compiler was generating code to move args before checking if the trace
> > was enabled. That commit was a while ago though, and suggests to remove
>
> It was only 2023.
>
> > the check if that problem is solved. Is it still a problem?
>
> We should check.

I shall leave this patch as is for now.

> Which reminds me. There's other places that have that tracepoint_enabled(=
)
> in header files that do the above. The C wrapper functions should also
> convert the callback to the trace_invoke_<event>() call.
>

Thanks for pointing this out. I just had a look and its not too much.
But I feel it would be better to take it up as a new series. What do
you think?

Thanks,
Vineeth
> -- Steve

