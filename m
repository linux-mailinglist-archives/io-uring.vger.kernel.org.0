Return-Path: <io-uring+bounces-12574-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ij1sGy0+qmnGNwEAu9opvQ
	(envelope-from <io-uring+bounces-12574-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 03:38:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B59B121AA5E
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 03:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09A53302350C
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2026 02:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F2F33ADA7;
	Fri,  6 Mar 2026 02:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cJqcfVqg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E402325228D
	for <io-uring@vger.kernel.org>; Fri,  6 Mar 2026 02:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772764713; cv=none; b=dPhsXlozOJ6TGiaxU93bPqxMpNHbpEIzpb2HJKT8kgcOzucLDfRMKLNq5yUrKt4+UTf+xdfJXtTTOn+bFfaxFo2alIoKgWNgYuddfwl+trWAz4OOw/fzcXmOoqNNa+bgAKa8YePztQqfklWThfoc59ofISZrawD4A5W7l4WXhqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772764713; c=relaxed/simple;
	bh=WqmphJ06VqQKf+a+vO4B/VaYeywvZO6ijiQP1ISLdtU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=KZeOc/s9jMLn5+tOzzg3zzAZuWTaRD4MN3rl4+KXSGvjlI/fQK3yVq1YqgMWt8/8qw49z5eFxbJc6sM+nfU+/vd/xfxMlXt8cWcxDDcPVS6oIkRMKbySILpMyjtAe0YOcymJ+Q9a/71FL72gCKjriCdyLFQ5qhhKA0FCW9cpjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cJqcfVqg; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-64aea64bf15so7987015d50.2
        for <io-uring@vger.kernel.org>; Thu, 05 Mar 2026 18:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772764709; x=1773369509; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzCjzCRhw8yPGe03/6B57XPGC7RYOdrxURk6FqO5Bn4=;
        b=cJqcfVqg8AFt/IlBuFcoC8Ch7FuPHZcmOw+aZ/LlZ9WQIQx3bpNuDvxi6Xc6hYPxcB
         GWfrmmIIkf7Ar4XKaCFe5Jj9vNZv8BDaZt53WRsbs7G+aLvsLgzTa5dsrnuX2xi6acom
         p1bLfnn1NenLhjkHM2ik1OqLKsBRBRwFfqTU14d6+/Nln5X3tNidCXQ9efXeoOHLGUr1
         +CyPu7Dn6UvxiU9GFg9qv+jm7Vo4OXkBhsGsWVHTtoRCqefJpgJ9u2x3bfyD29G1rTq5
         UfQ0EF6RnnDqIBiq9OA260LCgrbtUHH7rV0Mk14HkMj0UhSBAy4lG9SlkiVuGuBX9LcC
         +zfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772764709; x=1773369509;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BzCjzCRhw8yPGe03/6B57XPGC7RYOdrxURk6FqO5Bn4=;
        b=pGNH1MGx4JVAcWxmaxJB5tBONH95k+qRGSHK7J54fQktLrIWeWilXlrQFQ6rMmR3An
         ZjF//KBALZ/fFGrjuvdHByfyEbmsEk/2qdZ1CQxaLJR2xHbVWq/iEBJTBo7HeUQhMzD3
         hs2DQ+2CmIZNwF7P/RqkYqIRc1sJODlSkj0ipUdWkNUaeDuSH3XVU6K+2pY4vbvcB2W5
         DVePJ/s1WzOAmFKP38jzrowTsr+la1YSur6SBVhlDXY/rhgGoRyZeE0qZpR+apflS42W
         FkHc8KCIciLxD/INDpqsVd3OltKHMeYyz3qi5Bn0vPBX3HqDeyKUVuScTCUnLUYEfPk1
         UkPw==
X-Gm-Message-State: AOJu0YxCEm/TPsKha3OQIPoI2jaQcrTteu9pyc3Oq9oADZOqDQpZUifP
	0d1TPqf7oxdoDSJ4DWp5noywxmcST1/UDRcYMCxxIMsN0WglywJbkQwEP9IITYFmRmFGIB6p743
	TkBzjd/I=
X-Gm-Gg: ATEYQzy4XBO/F5VygHcieN+bjA0Y2FKo3+K/ON4fATpJ72eIEXOm0o+iW9Y1YjA1DA3
	H0qu9Jd3wZ/420zNtjvTj4ur7+V8nF7NqFl7xM4XbLtxk8uT+/QYQWLUqin0iCo4WZY+/E7SZYa
	4T2DjEh1kHhT+j546KWn/ScJavgzMv0YlYoHNbNwxYvADypDxJhBYJb/NQ1vZV83+hQyJqFlIm8
	J02YA3vleJdGzWLzbRmfo3FDsC2rihlzQXeG3j4TkEqXc1hWK0yP3D02i+OHABdBIUnBKbSC2v4
	b6Ql3XoV0pf4gqnKg7Qv3ycKcxHxUr6WgDZAi9Dx9S/IKCE16tCIEABeg63sWwq5On01xt7T+Rn
	evJmYhqAds9Sb4oZGByts9dhHQb01/Qy/QrxxMNXDViW1A3xk7e3iuUirOOljtqjGJQOd+0+wjo
	51VH32MTyIqmxiwbirIA0WbgUwJP0saE54NhbO2IFVMQbTSXxN8P0155zn5NQCQheyfneQT+RAp
	EDV1pIjFpiUbShwPg==
X-Received: by 2002:a05:690e:1a9b:b0:64c:f32c:73d1 with SMTP id 956f58d0204a3-64d142c7ea0mr522242d50.61.1772764709549;
        Thu, 05 Mar 2026 18:38:29 -0800 (PST)
Received: from ?IPV6:2601:703:4183:37b0::7115? ([2601:703:4183:37b0::7115])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64d175e3061sm94046d50.6.2026.03.05.18.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 18:38:29 -0800 (PST)
Message-ID: <f6932cf1-66e0-4278-ab58-37a368b0c5d4@kernel.dk>
Date: Thu, 5 Mar 2026 19:38:21 -0700
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
Subject: [GIT PULL] io_uring fixes for 7.0-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B59B121AA5E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12574-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hi Linus,

Just a small collection of minor fixes that should go into the 7.0
kernel release. This pull request contains:

- Fix a typo in the mock_file help text.

- Fix a comment regarding IORING_SETUP_TASKRUN_FLAG in the io_uring.h
  UAPI header.

- Use READ_ONCE() for reading refill queue entries.

- Reject SEND_VECTORIZED for fixed buffer sends, as it isn't
  implemented. Currently this flag is silently ignored. This is in
  preparation for making these work, but first we need a fixup so that
  older kernels will correctly reject them.

- Ensure "0" means default for the rx page size.

Please pull!


The following changes since commit 85f6c439a69afe4fa8a688512e586971e97e273a:

  io_uring/timeout: READ_ONCE sqe->addr (2026-02-25 08:36:05 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260305

for you to fetch changes up to 531bb98a030cc1073bd7ed9a502c0a3a781e92ee:

  io_uring/zcrx: use READ_ONCE with user shared RQEs (2026-03-04 06:30:39 -0700)

----------------------------------------------------------------
io_uring-7.0-20260305

----------------------------------------------------------------
J. Neuschäfer (1):
      io_uring/mock: Fix typo in help text

Jakub Kicinski (1):
      io_uring/zcrx: don't set rx_page_size when not requested

Jens Axboe (1):
      io_uring: correct comment for IORING_SETUP_TASKRUN_FLAG

Pavel Begunkov (2):
      io_uring/net: reject SEND_VECTORIZED when unsupported
      io_uring/zcrx: use READ_ONCE with user shared RQEs

 include/uapi/linux/io_uring.h | 3 ++-
 init/Kconfig                  | 2 +-
 io_uring/net.c                | 2 ++
 io_uring/zcrx.c               | 8 +++++---
 4 files changed, 10 insertions(+), 5 deletions(-)

-- 
Jens Axboe


