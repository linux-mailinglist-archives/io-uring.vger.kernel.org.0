Return-Path: <io-uring+bounces-12943-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iLzNKSjWz2kQ1AYAu9opvQ
	(envelope-from <io-uring+bounces-12943-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 17:00:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EB15F395766
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 17:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BD1430131C0
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 14:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4584638AC97;
	Fri,  3 Apr 2026 14:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="UhFB02fI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D9D3B3895
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775228096; cv=none; b=okWaShAVcH37GLzXQm64ApohGObtIQJSk+2tukvXkAI5SF94SH1EIRnEl1JDCS1mo3AXIyBehxifTTcgwllS+6szymV+c2zbzfcIuyuB9NJE8qMo2sBuxw7ko6FkcTbSDUuuUdsXMuDuDSuu8BNzPSgoZKrmRTT3H/QioTRBjI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775228096; c=relaxed/simple;
	bh=9xpRLN/nUQvIX4pEqEPZ98wK9xpjtZBp27/MrfasTKg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=J24I7TuJ7XLNA45WEjpDfL6r4Ef60GQ2YNJIiYFHHKfUtyzFHdqpKOUAoMdXEXKz7JfJjYe0/8aWjAQyrRUQs0DkFFDh0u5QEtEEE83dJ5Vemg0cr0s5JxzgbjYzLVt6AaFTU8bOUAE+aFT2IqgqDrB3sV3DeukXaYJXUPhGRDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UhFB02fI; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d1872504cbso1881801a34.0
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 07:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775228092; x=1775832892; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHdP2bq9QelHgLsN7wfBeg+8vaCz9sy8ReVk0ctNPi4=;
        b=UhFB02fIgpG/oZTIIzxnzk4iE2VybEJu4FF/kkVup1WwWcCSFLrrWEtC4AE7cWFl/0
         gTCRPFuOMge1t0WbyagkWqInm06Hgv/0arIlTEEy9PbYbE9hxJ82xpG9D9kwziRtlzLH
         Hir2lG/EWQMoprRk875TXCPS6UUadVs5t2kwHnh4waIsMl3iEGuGo9NEQGHioQlIstV5
         KdBJRQm8Uub1ngHnpcmeNfwngole4zkmfvsr4B3emUBjAJAD9V/XuK2XT570miuV8C1O
         fZb0t7gQoZahgMUgd6XVvLoFJERjXpM6mUXISf0bcPDhrddj9kGVWh1nP+dWDXBkPFyI
         jNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775228092; x=1775832892;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHdP2bq9QelHgLsN7wfBeg+8vaCz9sy8ReVk0ctNPi4=;
        b=ezlbfGSoGQv5ySzSRIdqDpixh9ii4KFU3C2Cq71ZBChvP8wLmN99L6hpEJ9bRyVWwg
         WolVCRG2yA0gyWmI2Y8IbMoBjgVG0EfNw5UJieHs8aAdcXKR1it+H8xS56sf96MS9oTQ
         gR5J7R49dE1fTbAgRi1761j+Leixk2wLPXJuj3HEp8AmX/sioOhn7wfpKmBVTApGeV6F
         SO2rRTQ7gYoC9mtl3hvLXug7dyxOxf5MDJ86ZUqJCvJ0oYZB2FN9iAjUIaq7DDHLdBV1
         V/zTGGXARYQgc15a6cVV0iDQ5MRXtg8b2H1tNwUB8dOWpnMZtI84yZg5P6fYpPU3SJl0
         P4jQ==
X-Gm-Message-State: AOJu0YziiYaDiSscxyfT55VD69e5XX/MuklyPrj7D0Cp15Qw3m+0/JHn
	o80j7XQERhr+cCOP5O5/NddWEbN8YDecu8aCINPk4fWeMZWS3l5ZDu/X2Wad3kpDL1XYjIK23qi
	YENWt
X-Gm-Gg: ATEYQzz+4hz9QHhHsHWFKfEj8UNm56cCk2Az6jhwWEXRPOVuT5NfCh7mR/9l2kXe4Hr
	GFaPGRx3+oRLsVDAYrZIALIj22Vl1lnns9r1Kp/mb84c3ndmWnP9Y/Es8k2ulV534m2FSnjJikD
	FCMmqWuLcYHAGDVNWLO3ftLk7gRmjL8oLNwk+EvThyjPYX97ooqP8U0QchJaVLQqIs3g6Jqb1XG
	U10UPsxemQ809IFlLeSSQEdnk0aEP6yCnA/vL5P4ppk8kwmv1toka9HB4sjDbdp30PDLd6qgxPx
	Twtifsm2t60PoqTLRtTlohy2qr6vz+CBYmXmsPN6jfsYzdhvMKHqlrlEiCnMj+lCyhjm3wu3NC7
	N23ENH1DsaQyYE0k4j6EigLXEIYDDqVmSRucF2l/HuupHfRRhvUTDJBq2sOoS4NUT7b09Gdgr+m
	27C5ASVxTzrogBINpfYt7JMRlaRcm/krRSGbIKuL7OwidPj1UpJJkOKCFZY6+CLCdJU27i6pNN1
	FfYKPal
X-Received: by 2002:a05:6830:65c5:10b0:7db:9910:de8d with SMTP id 46e09a7af769-7dbabc2ee95mr2562090a34.7.1775228092562;
        Fri, 03 Apr 2026 07:54:52 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbb5c96485sm2077139a34.22.2026.04.03.07.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 07:54:51 -0700 (PDT)
Message-ID: <20d0c66c-191f-4021-baf7-4a846e6e985f@kernel.dk>
Date: Fri, 3 Apr 2026 08:54:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 7.0-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12943-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: EB15F395766
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

A set of patches for io_uring that should go into the 7.0 kernel
release. This pull request contains:

- A previous patch in this release covered the case of the rings being
  RCU protected during resize, but it missed a few spots. This patch
  covers the rest.

- Fix the cBPF filters when COW'ed, introduced in this merge window.

- Fix for an attempt to import a zero sized buffer.

- Fix for a missing clamp in importing bundle buffers.

Please pull!


The following changes since commit 5170efd9c344c68a8075dcb8ed38d3f8a60e7ed4:

  io_uring/fdinfo: fix OOB read in SQE_MIXED wrap check (2026-03-26 20:28:28 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260403

for you to fetch changes up to aa35dd6bdd033dea8aa3e20cbbbe10e06b2d044f:

  io_uring/bpf_filters: retain COW'ed settings on parse failures (2026-04-01 08:34:14 -0600)

----------------------------------------------------------------
io_uring-7.0-20260403

----------------------------------------------------------------
Jens Axboe (2):
      io_uring: protect remaining lockless ctx->rings accesses with RCU
      io_uring/bpf_filters: retain COW'ed settings on parse failures

Junxi Qian (1):
      io_uring/net: fix slab-out-of-bounds read in io_bundle_nbufs()

Qi Tang (1):
      io_uring/rsrc: reject zero-length fixed buffer import

 io_uring/io_uring.c |  7 +++++--
 io_uring/io_uring.h | 34 +++++++++++++++++++++++++++++-----
 io_uring/net.c      |  4 ++++
 io_uring/register.c | 10 +++++++++-
 io_uring/rsrc.c     |  4 ++++
 io_uring/wait.c     | 50 +++++++++++++++++++++++++++++++-------------------
 io_uring/wait.h     |  7 +++++--
 7 files changed, 87 insertions(+), 29 deletions(-)

-- 
Jens Axboe


