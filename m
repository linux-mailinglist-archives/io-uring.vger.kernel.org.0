Return-Path: <io-uring+bounces-12877-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHhyCsuIxmlELgUAu9opvQ
	(envelope-from <io-uring+bounces-12877-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 14:40:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB573456D2
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 14:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 029183008C31
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 13:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A336734DB6C;
	Fri, 27 Mar 2026 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MrMRd71l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F832116F4
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774618608; cv=none; b=hA8/7gVOC4LxHPMmswniBgRLo/vy8mRjTYGkFv3bezX5ZqpvzgWuN4KwF/HvyEC8o4XrY7Aib8Omch0XUDpotoMBrgzgQfUWDJCv3Kk29IohdSYTgcvCQQ/lBaUGEYxUSs8hI46Sn0t0i8AGbidUzQ7BXahzJ+lkSkj1lBGfbCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774618608; c=relaxed/simple;
	bh=pJQVinBMNJRuBf2gZPMAG/Ciak+6Lx7H22KFah+YM2o=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=AJj+BOOuFr7H6hJQ5QIW5PnI6UHWqBhW38hsTGNkYXt/QUXmJ4P0NXKaM5r49UW+hj8rGh3w/gV5sE3zJ5kggCrcZLqkAQ0mR2SKndqg3nT2pAKIo4VPzSinqPzE8Ex4vK6O5MyMUiOek0x7wkVW0U5s/o+bAqeJXZtBefubrEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MrMRd71l; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-467161c4ba7so1222703b6e.0
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 06:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774618605; x=1775223405; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzdyYXou7tTRjdmVLFI7D/JGyioB4G6NLkIYSFbnPCY=;
        b=MrMRd71lO4rQt2rh20n4hnoNanpUtn4njPCObwkWNn0TCaa9csKwT+RqVuTXWl8ghh
         h/tT9Am1IXGMVxbveewilC/tlAfvjcboI09Li1yxEIleROKNM1lQp/sLBZBpj9i7evox
         Wo26mhbIlN0RT5d5O53zu01Huioz5OavglWV90D4TrEUVQqJunJV8E2S0jbut5VhLDE5
         i5pYjX3/0RSPQQgpB3A5Ezw97u+us5G/TtEvN5WdTimwaug4Cmhyvm9qckyLEDPZVC6r
         MLBP1WrKuxSZAWSxaioBu0VBmPbylf4n9z6MjdzGaWVFj3EKHecLkqePK+dPhvA8vMAF
         a5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774618605; x=1775223405;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SzdyYXou7tTRjdmVLFI7D/JGyioB4G6NLkIYSFbnPCY=;
        b=hZ33zZvRCCcZIWdSQSFv6Ydr8HmuN2sjE3YQUBRqcK+CcwW8MPf5izALZNLcqTeIP4
         Th4c39McSLNeVci43FV37whbpk3V8QIokXGogz+FgylYBdh//hn9YSOsEABx0vbkUY2v
         +wpDx4Ymnl4y+rCh1FQFGXg56+80TB2xNbD06b7m0wyuC5pDIRsNRQM67PKI5FZ+mPQF
         WilwGST77tXbuWqBCNtZFOZ7J0Yh27Li2HtqkXnuwBG/74wYGXVMYw/12V4E1OJCbUsS
         31k/3YKGv2RnbWlO+j6OQAmbP28W7O0gtwajBPuD1JhNaN2zdDldpEA6+FNrakM4AZQ4
         fV9w==
X-Gm-Message-State: AOJu0YwEswqVUpIQt5A7VookOFj5EN/Cw3UL2KW49rnrrt/NUDVzX6vl
	xUwi9A5TLPqLE5K+mJFTbYmwGUn7BzTwlHkmtNQjAUTb2bTvDltmNb60jMSyGj54S3+WfbbY1vW
	+Tfe5gQc=
X-Gm-Gg: ATEYQzzI2PWy/GhnMXr7JJZcAy9RWIxDPACNF/nOuSDYDArL/+fOPRoIJ6TdookBZJk
	9KVOo+Tt8w/bZVGLMikH/ImhzvdvtEJ37ciQ06CFbQsCg//+bddIC9uOF0b/FgjM2zDFmcDdpbr
	c1k8gnpe3Y7LVl6KX693bz9WA2HGcTFaA+mZ171yCZCGyY5LJJCJVTKnCGzG5ITwZbBEjCWnpw2
	kuQr3LhiSlhjaeXO6erpXNDIfVBgSLAaUxM5XVplOokPRJj7bTKsyDXmUpAfywvZoeXIBEKUu7H
	Vz/eazMRIEl18nC0hJLzylok0MHXuEi5WV40f97SJYZWHw1uYdq9VvzTsbo5JBB62Hfbvuncj/J
	gCTXWtWVKQJbd2pWZ69HtV/39PJcdPvtyT7zpv5YhyeHbXSngpMaoaoPV+vyGCcVjvzfEOyl0HT
	ZbLM2xjswdYPgJAvXbBo0wL+aedsONH2nKots2BVh9ylBnLlTLdk0ikTmBu5bshG3EDylxN9lRK
	4XvCPgOGQ==
X-Received: by 2002:a05:6808:6703:b0:467:5f1:fcac with SMTP id 5614622812f47-46a8ae34624mr981567b6e.5.1774618604966;
        Fri, 27 Mar 2026 06:36:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46a7797b65asm2670120b6e.2.2026.03.27.06.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 06:36:44 -0700 (PDT)
Message-ID: <73a85c3b-70d0-4834-9fde-aaafaa879538@kernel.dk>
Date: Fri, 27 Mar 2026 07:36:43 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.0-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12877-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: BEB573456D2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

Just two small fixes, both fixing regressions added in the fdinfo code
in 6.19 with the SQE mixed size support. Please pull!


The following changes since commit 418eab7a6f3c002d8e64d6e95ec27118017019af:

  io_uring/kbuf: propagate BUF_MORE through early buffer commit path (2026-03-19 15:09:48 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260327

for you to fetch changes up to 5170efd9c344c68a8075dcb8ed38d3f8a60e7ed4:

  io_uring/fdinfo: fix OOB read in SQE_MIXED wrap check (2026-03-26 20:28:28 -0600)

----------------------------------------------------------------
io_uring-7.0-20260327

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/fdinfo: fix SQE_MIXED SQE displaying

Nicholas Carlini (1):
      io_uring/fdinfo: fix OOB read in SQE_MIXED wrap check

 io_uring/fdinfo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
Jens Axboe


