Return-Path: <io-uring+bounces-12360-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBygLnC0mWkgWQMAu9opvQ
	(envelope-from <io-uring+bounces-12360-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 21 Feb 2026 14:34:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B8416CEB5
	for <lists+io-uring@lfdr.de>; Sat, 21 Feb 2026 14:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1FA28300E25A
	for <lists+io-uring@lfdr.de>; Sat, 21 Feb 2026 13:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A08C137750;
	Sat, 21 Feb 2026 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LDh7rJ5R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E890A1C28E
	for <io-uring@vger.kernel.org>; Sat, 21 Feb 2026 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771680878; cv=none; b=RXowcaAgjbKTWZk94BCLUwxysKpHU5sepkU+2AbP7DRK9iSti/mIGJwO452o3lTX+yF3z7bGQJ51meWMQOOvsyKs+EH9zjiJLSTLxSsj59xXfFEjGB6Hx3YO6ZaFPImCtptU4oTONBJR5jI/owzuRm3KiTtp+BF4T9QpTcWZCiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771680878; c=relaxed/simple;
	bh=JVyj9pdjJLc45Q4WWx93kamdjb9RRROa/orUtGHKpmc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=UEsGlx2kZhGxNxwVJFjoiYWgnACiEIOmotoe3qsMti5l47A287+cxeulZGNyJjSvliuHShD1Z5qP8Oav/79T576HncRboAT6uh1gNd+Klo0qz3Com/9ZXEKncPzeo/rglT4ad7CT7WGSrI09YMuoyYtc1dWNMP4709MLPz/9s2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LDh7rJ5R; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d4ba9abbecso2870004a34.1
        for <io-uring@vger.kernel.org>; Sat, 21 Feb 2026 05:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771680874; x=1772285674; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oDnxLukRBRkPWfr+fgwJP9t3zemK//XLRS9Qpx+rqFY=;
        b=LDh7rJ5RWZ99CEUVOZXjVk8PF7pUORsq8VhFqYT9nzSjh/o5dPMp8pH73x0CEPmzD+
         Z+7FZLfa13NTydvKUuubLC6RCEsjLyYrfWDJ0vXfHcxEjup0qHRyYQJm8HuXrNtMNmjF
         Cg/SbC/WMNtcvghcf8uC49KsTsEYM+EY1bIIH0Ha2dxqk6169ass/zDnMNrzj6rn3kx0
         rq4IZpmzdlzqFVedF8tP8/gY2fSAlcx0VnkjKir1nJNYDg76L348N9c4qlIaLePiBGU7
         A3a8JDkz3bzF8ElOEekrVCQ2joCeoWvNJ8i3Vz7yCNnNSJNossFIeOMEujfvYdSKpTlB
         oW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771680874; x=1772285674;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oDnxLukRBRkPWfr+fgwJP9t3zemK//XLRS9Qpx+rqFY=;
        b=GMGj1angUndR6gDq+3Sjj9VrE6WjtA7B0Xtp7KXh96zVdMa9Pp/HSkkXhgwwcgajmv
         vlcCdMRiRdJsX1EKIlfe9FQtcc3nqh+Ol7hvEw5hJtekn7+yLZDFAwFBq60AMgnYOO9s
         dmngHK0nasSUSMv3DitxVZwVUferZGPXAUa36HjTPvNfWHzJyGDzKsKglbm7ewxkbOUp
         3b9Clq3WpYEf2p/HI9+/BcFRm38Hhxg60OsI14drGui39l1+hKbw1WWrj+ciMfj7svKr
         e4RdvXBRD4Qg5qbWB1vcZX3Ja0+limgf8LIY6k9CKv47FkszmBaSzbAwwIOQY3rtJSPZ
         L+gQ==
X-Gm-Message-State: AOJu0YxT0AR3byWnTQoprFkHwSZdZ01Bf05vLsslhq7ADy39Xw5iPdjj
	ftqsXrxvSoTlzt2Hn0PlJJDdJgQWFbJQuziZGV83rx3sNmvH7oNPfEqY7UmQJLRpi7xJmMAMpwM
	dmlWNKDNWVg==
X-Gm-Gg: AZuq6aI5n8O6JV8gSYGp93ADAfPPmu+M5dZ5CUvwAWU6vE29V2XMC+m6z0RhQqN1C2f
	3sfUwOPd9BjP66hSlB6lVTUrcOobFLzigg7YxvZJ4hm0k+7x0UcQe2rIOpCC2qJ3k5SqWJJ9OG2
	b6WUOfohD/GkT4K/1avEQb3P9vihOPzQrMRtxZUHoRUxIlAecilYrhgSB2Dd0LKjvtDQSMt6RZV
	F8DxFyiV6zpQjP+Dks/lv/iTRlEe5FukPbSGssdNe0/xzACL7JnuvOn4ZXlGGanL7BQaYB4eJeu
	xHBAO3TK2jUVUFgihlxtE2skhN3J1LFkIpzbGntQgSVSQpHZ713FeqZDW65mrNuU+rAWxA/01JW
	Ql+SV+UaiU4L2CTRWbtbURqus0D3W3IsdULULxR3j6uAZzywZPlWtv3HJOdg6Mz2bFgj8ejdZou
	AR9REWCiQEFwtpFq65gbrAnFYWw3SjYweg3Tq7XzrfYPh83HuVx2VJjlD1YPhi94c/uMngVKyTe
	NcrhVgJBTwOTw==
X-Received: by 2002:a05:6830:6adf:b0:7cf:d6d3:df0b with SMTP id 46e09a7af769-7d52bf19b05mr1778349a34.21.1771680874512;
        Sat, 21 Feb 2026 05:34:34 -0800 (PST)
Received: from [172.25.209.35] ([187.223.170.195])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52d038752sm2688429a34.17.2026.02.21.05.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Feb 2026 05:34:33 -0800 (PST)
Message-ID: <2b80b81c-42dd-49d1-9f89-f2cc78e9d3fa@kernel.dk>
Date: Sat, 21 Feb 2026 06:34:32 -0700
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
Subject: [GIT PULL] io_uring fixes for 7.0-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12360-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 33B8416CEB5
X-Rspamd-Action: no action

Hi Linus,

A few fixes did pop up for io_uring since I sent the pull request
earlier in the week, so let's flush those out for the -rc1 release. This
pull request contains:

- A fix for a missing URING_CMD128 opcode check, fixing an issue with
  the SQE mixed mode support introduced in 6.19. Merged late due to
  having multiple dependencies.

- Add sqe->cmd size checking for big SQEs, similar to what we have for
  normal sized SQEs.

- Fix a race condition in zcrx, that leads to a double free.

Please pull!


The following changes since commit 2961f841b025fb234860bac26dfb7fa7cb0fb122:

  Merge tag 'turbostat-2026.02.14' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux (2026-02-17 15:51:14 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-20260221

for you to fetch changes up to ea129e55c9e06a51a93c3f5ef3e32a6cfa3f8ec7:

  io_uring: Add size check for sqe->cmd (2026-02-19 07:26:26 -0700)

----------------------------------------------------------------
io_uring-20260221

----------------------------------------------------------------
Caleb Sander Mateos (1):
      io_uring: add IORING_OP_URING_CMD128 to opcode checks

Govindarajulu Varadarajan (1):
      io_uring: Add size check for sqe->cmd

Kai Aizen (1):
      io_uring/zcrx: fix user_ref race between scrub and refill paths

 drivers/block/ublk_drv.c     | 12 ++++++++----
 drivers/nvme/host/ioctl.c    |  3 ++-
 fs/fuse/dev_uring.c          |  6 ++++--
 include/linux/io_uring/cmd.h | 15 +++++++++++----
 io_uring/io_uring.h          |  6 ++++++
 io_uring/kbuf.c              |  2 +-
 io_uring/rw.c                |  4 ++--
 io_uring/zcrx.c              | 10 +++++++---
 8 files changed, 41 insertions(+), 17 deletions(-)

-- 
Jens Axboe


