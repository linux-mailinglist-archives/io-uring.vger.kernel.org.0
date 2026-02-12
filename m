Return-Path: <io-uring+bounces-12179-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DxGIAm4jWl96AAAu9opvQ
	(envelope-from <io-uring+bounces-12179-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 12:22:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCB312CF5A
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 12:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61628308298F
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA653451BB;
	Thu, 12 Feb 2026 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2687BFWJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99406344DA9
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 11:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770895363; cv=none; b=hEiNlQWssXTAVkIPflE1+NmgJl57STSxSMsoVSbznOAvGcBcGqIWhZvQIDg30MQDzaxm6MvJAtGcEMmggnS9Hz6dDEJcAaSP4fpjdSoXgFdWwy5zis/m9DQzx1jXwPtecENtf3A8YJ5RBcSdoRIjk1BZ2r04q7u7FTdeoRJblmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770895363; c=relaxed/simple;
	bh=r8S+g/XKpjP5qK5PLtLl0Dz5Fb5x8pUqgE8UX2PbB5M=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=WD4oHhBT1pKZl2zXGyDmcMYVsbnMd3wGRSQNSEMzijbygPslMFvGUFFuN0vsRP4k9O7o51UTKyarT3VpdEg6Gw36XL1kAcHCnVtsPokUY3IJFW1b9kIvFJnWARgjuv/mlMIyJ//1+Pr52Y5ae8FG+5IREJnTqryeexaArQwD25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2687BFWJ; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-676815e147dso54920eaf.3
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 03:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770895360; x=1771500160; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYUKQPFrG9XZXM/vSsXcJfnCi4meMyT/KdhvALKcdpM=;
        b=2687BFWJMJoapQd3sK2D382YqcrV5C9PZLc4Axv6k9zBDq29RGBpvm4v38jSgdf/G9
         AEXPsO0WeIi3g6UmqW2TW47777AjPREBYWbvq16JEYmsAiCrgQ12RaUnrjSN/bdTjvxk
         heevcJIthdo9W1HBBA297okdh9XXppe0Xaum+ekHkU23aKrcsAp5vp1IcSUUiTE25ytx
         S8gVS7gsf+wnBZ/GPIQHd9BPmm//IMUK3/P/NhKc3qj4OWtvVyDYjrQ8varqt2vDSwD+
         htR27afL8eqliQRrVrqKMIzYr9Au08LOvRA9chNRimTCoe9WMIy9Uqr+3HGmy0hp5Hp1
         clPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770895360; x=1771500160;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zYUKQPFrG9XZXM/vSsXcJfnCi4meMyT/KdhvALKcdpM=;
        b=SEvdxusDsdVmehe4D5/HANc3Oqa8ANVoptZatMUJwcQ68uP92RtbZWoyaepDoCOZPC
         RNAEStCupCrHyeWAMzjrU5CR38Ac4mB7ZsRTwlrChIv6fzxTKM7AZmT81bz2mlTA5fKL
         c4YlVBQq1Q6JdFcnEewg93ZNyMGjH6pX9nfxsDn0IrFlg/ARXAOXkEXcJfR4WWGulp5T
         nH8yxERSH1x2l+zaQbDqYEYXEcdzpH2YPMAMrJ82uDpUj5o87uiazwketOdTj4rFUNMi
         KCmSXyYSUKkUtGUw8BLc1z36hXjYcxHD7Bwo7JyONW0oI4F9222th7WwrMCtIQ3Eo2Wi
         r/Hg==
X-Gm-Message-State: AOJu0YwXSzHxYwS3mL9awfPK1aZKWX33Lbgc5oWBDl67PM2r59dy1WRM
	6ZxjEl3l2uH+aLPkH/8LVAxFNmJrIaooLywt8Imm5vNx8DDyIYCg94udJtJH3HrT/j10mDQW6V2
	76XtPWpk=
X-Gm-Gg: AZuq6aLjsZbtiSkQmCNNKzhysiGuMZ6bcvX6eEa2/1txYAktFlFIVTSrCSSVxX+0QhF
	xIMXQ03w8vKZcIdGe5TrLLty2cxxUxZulQ5OxzGwVVLaGW9sn7cw/ULYHwO8WEuWdehwr+SYQ73
	cQ0c8fCc/AAgftpizvT58rzUwAb97OwGN+h6xepOFWfhp3mLL/wvBI9sC9VqZNZpZAkdrgm26mD
	napvplZ1Tf0Q7wcMP/BTcsywXxoE5b+W3BEnZSUrUoHFs4dVxayLvLW0Wgr2WwYCwIKYJ1cqIYD
	/I+0rMySAbx2vwNRtwoqcNBFtegg9aJh4hxb1Vgef/4pZ98iJOmct0mXT926rNhFoueynsSXYZY
	RCNurRzZMtdX4ryLiMlKQC/iZWVFd+3POhnb8lmwJrUWZQlAYkBYjLMckjDZZEXivUmF38kTYAx
	CaE0EOdoKfhH4Ern/VNGkdwoU6Qi4e1twk6VCU2G1kQ1vJdGmWKITojhf2n9ogIANCP436ZmpUz
	dary6dxLA==
X-Received: by 2002:a05:6820:188b:b0:662:f0cb:84c5 with SMTP id 006d021491bc7-675dbafc487mr621523eaf.34.1770895360521;
        Thu, 12 Feb 2026 03:22:40 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-674736da861sm2461198eaf.7.2026.02.12.03.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 03:22:39 -0800 (PST)
Message-ID: <7eff267c-a76a-43e1-87a5-d92148abdc7d@kernel.dk>
Date: Thu, 12 Feb 2026 04:22:38 -0700
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
Subject: [GIT PULL] Large buffer support for zcrx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12179-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: BFCB312CF5A
X-Rspamd-Action: no action

Hi Linus,

Now that the net PR is upstream, here's support for large buffers for
zcrx. Using larger (bigger than 4K) rx buffers can increase the effiency
of zcrx. For example, it's been shown that using 32K buffers can
decrease CPU usage by ~30% compared to 4K buffers. Please pull!

The following changes since commit d1de61db1536727c1cad049c09decff22e8b6dd7:

  io_uring/zcrx: document area chunking parameter (2026-01-14 02:13:37 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.0/io_uring-zcrx-large-buffers-20260206

for you to fetch changes up to 795663b4d160ba652959f1a46381c5e8b1342a53:

  io_uring/zcrx: implement large rx buffer support (2026-01-24 08:33:03 -0700)

----------------------------------------------------------------
for-7.0/io_uring-zcrx-large-buffers-20260206

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring/zcrx: implement large rx buffer support

 include/uapi/linux/io_uring.h |  2 +-
 io_uring/zcrx.c               | 38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 6 deletions(-)

-- 
Jens Axboe


