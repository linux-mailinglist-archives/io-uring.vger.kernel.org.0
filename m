Return-Path: <io-uring+bounces-13654-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9skEMrxNKGqQBwMAu9opvQ
	(envelope-from <io-uring+bounces-13654-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 19:30:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FA4662F7D
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 19:30:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=janestreet.com header.s=google header.b=14GHb+ju;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=OsAttRF9;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13654-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13654-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61A753167771
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2026 17:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FAF4C041E;
	Tue,  9 Jun 2026 17:15:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C16E4BCADB
	for <io-uring@vger.kernel.org>; Tue,  9 Jun 2026 17:15:19 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781025320; cv=fail; b=jtL8jhcr/DFeans+yhT/W2eDOp+3QKtRrerCGNtRg1OxNMFRLJGkqCznd2lQph6oz5gJTWqthHvv7AflbaN/HhoTWEksIL+gLWcjqOU/gsok2VK7j0AI86nYluEWDKHxf9NCEZAo/AsldCPR+7mP3wIJpr81f/moha1pDZe7xao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781025320; c=relaxed/simple;
	bh=2inTUhdt8YIA2l57282yKhLtyF6GdP0EAnIKVqphNjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TOu04JlHClz+iN1f7WE32643wE5dpDF63ryKAm4qCtjaGb1FBIsL3jMFkGwkQ3hIchKRDN6Wh6D3+zLuqVObQEPbFT4U7J4P+qSEESwxPYznLBNr5LFyi6wWAGjBPzO1vKMPIHWh74kKnzi+HwjIv8D38AjpcpiFBNvqHbglqJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=14GHb+ju; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=OsAttRF9; arc=fail smtp.client-ip=64.215.233.18
Received: from mail-ed1-f72.google.com ([209.85.208.72])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1wX02p-00000008bJd-0Ymb
 	for io-uring@vger.kernel.org;
 	Tue, 09 Jun 2026 13:15:19 -0400
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-68fa01a8b02so768789a12.1
         for <io-uring@vger.kernel.org>; Tue, 09 Jun 2026 10:15:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781025318; cv=none;
         d=google.com; s=arc-20240605;
         b=ET3+8yafv9z8iOhlmRe2SVX2CGsKNmWHyO1n8EP/YCyo7YZxNpCSRgWyJL+ppbBmAD
          57UxQu7Z2dCEdA2qrx7GfHntiPQXL6yOjZQgoi/WfpjIQyrrVuffYlFmG2HvNSpCa3lH
          EliXxL2hYAoRMh/Vac/Es0AzqBVP9z7ACuSpnoZ9U3PlKaY4eUaKSmaAtcpV1GnRMxHX
          IwXthTKvtklREvv8zbFyWY+jgz4ehyIF1qg6Chx5XCabLLZhX+2utz6cMe6nmryzM61Y
          erdfRIagVXoTLoCj/jDVJRe/vpMd76+QRi50GroKMTxkVSgwuqI3eEo8H08mVSjb/ZLQ
          cKQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
         fh=eObh+s0nZk1KJwxisye/9JOUxD8xACieyXB52tibkSk=;
         b=NZ/l1o0hHPBR4/SK8+b477MRPfY6k6FCo7FtP+N7yFL+YZzbJLg8ZlErvYGcKW8bH0
          dOkDGQrV61LHTXF6WPNHJsA+BaEtOIpGmjh089dXqtNj6FhyqElyBjAxfHWBo658DtBq
          xZzIUBxMng6eMm481uMBjJc1dUO7WjP5Oa9fizj4ZU22XIHNYhgQrSJ7jhX62vjmA247
          39agWH9moL1+JMR7RYpRW6Ph/XDukPcoUhADbnZ7hIyw8zU9eqDZupXoclpJrOKeKFSe
          TeB/IRnFCEl+8rmdUsntMucrpz9Ny3k+ldchnCkcWD6GrJEdSexb1by8lHj6tvGhWbvY
          b28A==;
         darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1781025318; x=1781630118; darn=vger.kernel.org;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:from:to:cc:subject:date
          :message-id:reply-to;
         bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
         b=14GHb+ju2esx3Wgg5mmRt5GlrxqrjzQSjDzjgES+bcWzonX1Le6Wjr34/Y9S0yFT+m
          NHwejsCJoUWIia+KzYYZFkDup3N+2hO+uLUSGtGKAytHhT8bIr2/nAUGDi9kdgFNPtSJ
          n8siNmQHrCaZFjEJiaNMulUYVPCnZCGoNuXGE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1781025319;
  bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
  h=References:In-Reply-To:From:Date:Subject:To:Cc;
  b=OsAttRF9A4gQ2eRBDcfe43o5nODESb7KmJT8LACsb13IbhagJp9DD8ZE5HdTJxM+f
  4uSdWtM0rfhdgXD1CR2nipSPQfRkoGiWbSdMQIJYQGCChr8fojcPdfU+x8lcICuPHY
  lUZxKdToTDngPfmQqNx5YrQXypz9p5eyFqt3hvY6RNUgPXTZS9KLAaxfdwu5qQnf5M
  T8B5Jwp7UwFzlXKS9Wbzhmw2odCgOw5u5D2sUsW7C/72t5aJuRuA92bto9Sohbxb6n
  0fueYHomh8LAWQ9RqviM+wHraTq+JingrKtdekDUKoYKyNxvvbFcTXujG7LCWvgcEb
  CyvKWjIWm/8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1781025318; x=1781630118;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
          :to:cc:subject:date:message-id:reply-to;
         bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
         b=Da68N7NKH7ja9oL1AQ07byNuXYDSwjNkegnOyfVB5v9FcMSD2nWY873Z/xJ2W7zllD
          LG+DfbC7cjRf8toICAZGjA/ccmMpiiiX1ozYUcsDtsHjjSbTsUY4y+p8NQNSkTx0sjYo
          URN4rlzAlYaoVFzpgPO1FwVpGG5O5TnJadHkXk1ty/2zk0Msi9/VBAm71uDp5lCthxw2
          MoC1uC2YTrpKSfBz0haZrSQ82NiN5gyb1aX5QyNtEVvOr+BvLvWoYdqiKFNwiT4XcwAI
          xpw+5iOcnwZVTGAhb1r+xwGkEjABZ1/1DdBYQChew5OdHEqrjW4Y4NHWpOIVOlrOmrtW
          bIrg==
X-Forwarded-Encrypted: i=1; AFNElJ8x0wYuG3nmwIh2GX6+Vmi7QuyBslxvb+9HIk0znq98ERQc6WTxzbzPhlYoLCdIKukCT/xCRw1Szg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9mh06VJ9N05fcZpK5mFFXrZUXo3WxiOL0xBTsCSBzEIYD/CtQ
 	AUI0cclSNQgAWNQALlcdbSLQZ83NBbcMJPq8tU3RyqSyW9uYo+cUF4oVH23hHoi/1wHgSUEY10A
 	t8AEJvBIoRrkjdtPRm45tzUHGpFadgHcViSvYNjiCfQEqIgi7UkJcdqa4gK9CswnzhDoxeqQgDy
 	rapuRZmTNUeiauKXX5xHjvVjjkZ13siGb03w==
X-Gm-Gg: Acq92OE99XjTfBxW2EfUklNkW63sgQh4hVw50phTo5td6tBfprAsgUQ/qUdmahZR5dv
 	tBut7K2TdHSZc8e8CXhqgbNo44UHhY3yDC1CWw+f+TxLPfQ9ozSmFCYs8uWB7UnVht3pcOlQVOb
 	xIrcHRrjHkfMB9wCFdLMTXlyzAcENwvm56Ozx08cx9u/m1tK/c3Yj1WbdZJ9etkL2y1ZGW7FPpN
 	oAE6u1yEyji6jpI
X-Received: by 2002:a05:6402:524f:b0:68d:b17a:543c with SMTP id 4fb4d7f45d1cf-68ff2186061mr8591386a12.12.1781025317822;
         Tue, 09 Jun 2026 10:15:17 -0700 (PDT)
X-Received: by 2002:a05:6402:524f:b0:68d:b17a:543c with SMTP id
  4fb4d7f45d1cf-68ff2186061mr8591366a12.12.1781025317308; Tue, 09 Jun 2026
  10:15:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
  <aiLxe-9Sub8cI3Py@bfoster> <aibns0xP6IVVNWh3@bfoster> <CAAH4uRB+Bh9UEVEW8Sb2yM4YhB-Q5UJ6KJJXari3DDF3n3S+-g@mail.gmail.com>
  <aig9Vm2a_13bPc5G@bfoster>
In-Reply-To: <aig9Vm2a_13bPc5G@bfoster>
From: Gregg Leventhal <gleventhal@janestreet.com>
Date: Tue, 9 Jun 2026 13:14:40 -0400
X-Gm-Features: AVVi8CccMZBf_W2neiPGuRO8YpErMCyF7o_iyXweU0WZ58K3osa4MMBejEkzuNY
Message-ID: <CAFN_u7ELBj3YKncm6HA4-QUNyi-a3qPDEYxuLP+skVhm-r87uw@mail.gmail.com>
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
  re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Hagberg <ehagberg@janestreet.com>, hch@infradead.org, djwong@kernel.org, 
 	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[janestreet.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[janestreet.com:s=google,janestreet.com:s=waixah];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13654-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:bfoster@redhat.com,m:ehagberg@janestreet.com,m:hch@infradead.org,m:djwong@kernel.org,m:linux-xfs@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[gleventhal@janestreet.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[janestreet.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gleventhal@janestreet.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,mail.gmail.com:mid,janestreet.com:dkim,janestreet.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 11FA4662F7D

I reproduce it by running 25 ~ concurrent instances of the attached reprodu=
cer,
each writing its own file, on an otherwise-idle 15 GB VM:

  DIR=3D$(mktemp -d /tmp/uring.XXXXXX)
  for i in {1..25}; do
      ./repro_uring_dup "$DIR/file_$i" 120 48 &
  done
...
*** CORRUPTION DETECTED in /tmp/UmgK/file_17.1 ***
  bytes kernel said it wrote (sum of CQE results): 53621960
  actual file size:                                56218824
  extra (duplicated) bytes:                        2596864
  first mismatching offset: 6791168 (0x67a000)  page_aligned=3DYES
    expected u64 848896 but found 524288 (content from byte offset
4194304 reappeared here)
  (file kept for inspection)



  wait

*** CORRUPTION DETECTED in /tmp/Gznx/file_18.2 ***
  bytes kernel said it wrote (sum of CQE results): 58112616
  actual file size:                                60303976
  extra (duplicated) bytes:                        2191360
  first mismatching offset: 2191360 (0x217000)  page_aligned=3DYES
    expected u64 273920 but found 0 (content from byte offset 0 reappeared =
here)
  (file kept for inspection)


On Tue, Jun 9, 2026 at 12:20=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
>
> On Mon, Jun 08, 2026 at 01:17:10PM -0400, Eric Hagberg wrote:
> > On Mon, Jun 8, 2026 at 12:03=E2=80=AFPM Brian Foster <bfoster@redhat.co=
m> wrote:
> > > Another idea that came to mind is to try and just replace the -EAGAIN
> > > return sequence from the low level iterator with a flag that triggers
> > > -EAGAIN from the next iter advance. The idea here is to allow the wri=
te
> > > to return partial completion (i.e. so no iov_iter revert) without hav=
ing
> > > to return an error from the lowest level in the stack. I had claude c=
ome
> > > up with a quick patch [1] for reference/experimentation.
> > >
> > > This is based on v6.12 stable and compile tested only. It needs more
> > > review and testing in general but might be worth throwing your
> > > reproducer at if you can..?
> >
> > With that patch applied, the reproducer runs clean - no errors - and
> > gets roughly the same performance (maybe slightly better) as when run
> > against a 6.18 kernel on the same VM.
> >
>
> Thanks for testing. I'll look into some more regression testing of this
> patch and try to clean it up and post it for proper review for stable.
>
> Are you using the reproducer program in your original mail to test? If
> so, does it require some concurrent memory pressure to reproduce, and
> are you using anything in particular for that?
>
> That test seems small enough that we could potentially include it in
> fstests, though I'm still not so sure about the mem pressure part..
> Since you guys wrote the test, any interest in porting into fstests? If
> not I can look into it.
>
> Brian
>
> > Thanks,
> > -Eric
> >
>

