Return-Path: <io-uring+bounces-13698-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bKKKHsw0LGquNgQAu9opvQ
	(envelope-from <io-uring+bounces-13698-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:33:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EFB767AF5E
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:33:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=veZzV8KG;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13698-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13698-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 03E133005175
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 16:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1043368B8;
	Fri, 12 Jun 2026 16:27:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C261A33985
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 16:27:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281628; cv=none; b=YGsEao57xbwAeOXTSp5TDC4RoHeQZuF1VJi8T7RSxx/WUBgzrBh1j7Ch72lLAvldTzMLFfc66IWxinkgkOc+uAIzC75VySx3ppXVp9uS0K11yk+lXjDqzv7bQmi9tWjgOECr23FpiduX0y4uw3D+4JupUw41u5J5leoK0iBKyfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281628; c=relaxed/simple;
	bh=q85fA0z8ZRnH+iKGZjgnPQ6WELKNUoE0mAq68NGwH2M=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=XURzhuSlzWaPBuIKhh09BfzgJbWhspXQ/hZ8Kmj7+ZoYuWMUa9SFxhHmr+ktM6Z9PfzE4O8hqD34ORRtwhj7MARo9Hmp1L+n44QSECOqAWBX1MBxAcOmGQESpj4PYCkhoyzcwX/nyZ0lwlN4fenEl782TFAyerGX1AGTg3PlUP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=veZzV8KG; arc=none smtp.client-ip=209.85.167.178
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4864a8e80bbso704117b6e.0
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 09:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781281626; x=1781886426; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2MDdSziVv1nFaimA2o7z7Te+TZ8eVtdz4atBPWXgG0=;
        b=veZzV8KGaAK/dqEVhvl0mjljw7J31C6aSloWqPha+xN2l5GPZ5/c7OmNZhZHTb6NOk
         t13sFjKsZcR533DxgiH6Y+nCEEd0WfgvEm7A21Z4L8mMplPgwaKVQ9W47PjBA3zR2XGx
         p7c3PN4xjbK+d6qY5x8xxz4Xkb18FMjJFwQCD9TaDzklJ/y6NbLx3/XpgJtzNjzGcLOK
         mCl1H69GmNpjIl77bi+YJsTLo6cuW+UsslGGfifwNaexqREo/J7f/02mSUJ46KYaoeHy
         ciFbzZ5X3iG7BOTdl3g2+5hjMbci5IKqsXQYxJu8OR8r2S5D+xmvufUYlYTBrFCZW8Cx
         1R1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781281626; x=1781886426;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C2MDdSziVv1nFaimA2o7z7Te+TZ8eVtdz4atBPWXgG0=;
        b=SV2D42isFxLV6yMBkQM1Ev/kf/Gt0jkrkKEFqZEfcox1G3p7XNMnznYZI9h/66rSa6
         EO/PVk7a3UNycZwGKnYRW86d0pN4JRupEa1ZkkZxsklGg6g1YLcmdmnVCqxwgcK/VF4z
         r4g/05mOMDSz/M51ZN5zmO3aRvUQQbhjWE3hJaSmSJOoeOTX2tug96+cJ5DbRPIzJZtR
         VmDWAQMdjXbB4fYZWDRfMnzzZqFOA8Soq8M/9Jun1u0Hno7GtxkyHlaeEkCKFWsmvKfQ
         s1KShvbB962c25DKAq0m4qRq0ZiS6iXkPz6DUf9LEfMconQ10JmWVoGxi1R3WhZlosVq
         vY5A==
X-Gm-Message-State: AOJu0Yy2A1DTFJwgnpr4N7EXkgYWsaRw+nXQQXD1dCsZt6cZdEaRWO95
	v1ZZ0Y924JdZL3hN4M9h3Z3RZpwRD3fTWLyHNgsDm2sg3DRBRtzwZ6JOcC6Uat0a53xTEAFzUpG
	4vrKf9Os=
X-Gm-Gg: Acq92OGqdtzZ4yraZDSZUC0E3QVWz9GaE2MATNSE0asjkE5vFBdmiTRc/NVAIP3S+Q7
	8AeN/9YRvKQbFI7jR7Vw6RRWQ42DeSwkxAiIv1hwVaojT4laVjyS/nqMjPHdXzbD8f+QuSQLUQY
	iD4Z7aC+zw+y/72MXH3MexG7vTbWVMF+rP7L0lHm4meuUUVeGitRK2tPrCC5p2JTnlQJR4f0gCp
	YMHzQEwiKoa08JJQ/dm+NDMZiMlTwgzQsce+uEmZ/aKrhq5ikFARdE+ffRcwTAb3p9PvOMWcxrg
	COA3AuPXDCGh/2HeK9raAPBJH5Q4fBa6etRW+9dDfqh798wrTTu++UTMa8l/cmwW+zbtzD4wiyU
	LVTo00JzwN/xByR3ad+hluRmjjD0+nLirbtFflMXJ0CLJ+ka9G4+xkFpqiaMfMknK4VYI1K5xE/
	uRvEkmK5HxYr103oQlMvjFxwEILdWBgfrLz8r2BkNI5vOfpiaUfrLY64fDOmwIqLbAjpNEs9YiN
	q+MSr/lEQ==
X-Received: by 2002:a05:6808:5147:b0:47c:be93:9212 with SMTP id 5614622812f47-4872f426d86mr2482043b6e.18.1781281625698;
        Fri, 12 Jun 2026 09:27:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4873157dc2asm1193880b6e.13.2026.06.12.09.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 09:27:04 -0700 (PDT)
Message-ID: <98373ad8-4777-489c-9cef-1ff9227c63a4@kernel.dk>
Date: Fri, 12 Jun 2026 10:27:03 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.1-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13698-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6EFB767AF5E

Hi Linus,

Two small fixes for io_uring, that should go into the final 7.1 release,
both heading to stable. This pull request contains:

- Tweak for an off-by-one in the CQ ring accounting for the min wait
  support.

- Don't truncate end buffer length for a bundle, as the transfer might
  not happen. It's not required in the first place, as the completion
  side handles this condition already.

Please pull!


The following changes since commit ed46f39c47eb5530a9c161481a2080d3a869cfaf:

  io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle recv retries (2026-06-05 05:20:25 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260611

for you to fetch changes up to 29fe1bd01b99714f3136f922230a643c2742cda9:

  io_uring/wait: fix min_timeout behavior (2026-06-07 16:12:32 -0600)

----------------------------------------------------------------
io_uring-7.1-20260611

----------------------------------------------------------------
Christian A. Ehrhardt (1):
      io_uring/wait: fix min_timeout behavior

Jens Axboe (1):
      io_uring/kbuf: don't truncate end buffer for bundles

 io_uring/kbuf.c | 1 -
 io_uring/wait.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
Jens Axboe


