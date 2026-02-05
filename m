Return-Path: <io-uring+bounces-12068-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KExOUQYhWmx8QMAu9opvQ
	(envelope-from <io-uring+bounces-12068-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 23:23:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BD5F808F
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 23:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB0B73011840
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 22:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FB3330651;
	Thu,  5 Feb 2026 22:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pXJwcsXe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FF72652A2
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 22:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770330177; cv=none; b=Kzp9v8J2+qsilQG/F5DnUR2blOlJLhcYpXhdQrjoYTodGmMckuSQcF3fZkjhPuSl+sNb9piHtEvXxMkbbeSaCCR/y7Q5Md4C5K0Q60p6h1xi82W9PU4x9lkd2aiX0am0oWr963DJ/JgJlZ56EDMuy8uOfgzZvDo282zguallQQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770330177; c=relaxed/simple;
	bh=FV/PdWhpienRVeJWy7X9iTaI7HoTGn4GyAaE+QKFzAM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=BRKhN7JlGBYEpRDcGqCGNW5HcuJlBp1qK6Ri7RwygHL8+wyRSEIHp4Zv58GTRvwxBc3Obrd5xbatL+ww7DNFLVc7OBb9QWSoR4PXoSIox1mSS99txNtqqbk88Q85EcZmB3cxNQOjymSuyegqDBWEkiAMRxpeyZPR5O1SqUjFlMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pXJwcsXe; arc=none smtp.client-ip=209.85.167.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-45f015a3259so27460b6e.2
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 14:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770330175; x=1770934975; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97scOZgIU5PeZrOz9xhnBClTJq2XWUQebvECkOlBsZU=;
        b=pXJwcsXedjc2RLMf5Zu51qv5ORKTZY9TjMgCB0a4wq07vZPqbf2G9AtkAqmXnDqYYB
         bCom2afBMLvGazVQ7OtAhSXKrCpmVbHC8KGACk2bUEfT0rEe/0K2MwWO91mHaYigaW72
         HRMI3h/xjpwD70Ax70e3FZfFQN8uXlFOAkpcEayUzPCGNBkEiQo7p6YEX+F+MImbtJbQ
         nCbJgCo9Mw1PHE7PxEd/0bCPGqEt1pqGI2eGbE11p8NzE5Xyr0PVpvXVYQ3bkmoeJysb
         qyt9ZLaR7Qiiujd0y3QHDUkEccAPW3ibrNT7MAKw15N0jkuYApVrVEZmyk96ZHfebDPp
         h2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770330175; x=1770934975;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=97scOZgIU5PeZrOz9xhnBClTJq2XWUQebvECkOlBsZU=;
        b=EtXjlTVmzH1UDnoJL2NW1rJyva2YhSyw04Kd5/SEq2Mple79dPZw0LFGWqd7vWLYVX
         9XgQTeEC3UcOFQ3n9ykV8LwPPVlLuVGBSIdGvt8oQWidDWdH7IwWjCrLfQfvzdKZaoQB
         hc3bauJvbQZlfAZLbBV0wII3ihAGm//yBQhNQ/k+eXPpGFvhBmiKMFeNzNoqD4pZpWjw
         1HOq83LIDdZtOMLifT/vFzMzhra4ON2e2vFXgx6QEQ03yW+2a1qlscqCLsXCWbNx0KOq
         60zgNdgQQdBk19Dc777EI8OiVfqb+ZE4v+00e8sU0MjDl74voamU3T/J7l8hg/SrwOj4
         sWWw==
X-Gm-Message-State: AOJu0YzvtjVCGqlQLOMwYlGxUjH89QbeTm7swWfA/opHgdecUjSWcbPt
	XsZLPa1YGfBve2AOXw/rpCD/uaxbil4EpP2d6/UDWPi//ksoKGWSwHSaSFshZtXUC1GJXPkVWSk
	+Dq6uttY=
X-Gm-Gg: AZuq6aKkMWZc6/WKUomGJ6/zqzLLtBnfBgmDSOQ7e3ReHGM1kwxTE3hA+QWkIqwT36R
	a19DYeipaJmwJhyJTkfLU++YfGYtjSn8vrMgt5er8L0kXFvhu5/5BDJVEz14mgFxow5+Ku2lO4p
	+SbqyhORCmA5NmwShowhLYSHJZTU5Y1Cjo6fbu0njhu+LXWHDbCQeoX270LnvD6n+J0j0hF0bgb
	GeucowYzDMRIlz9mKk3nfDL2eAELeV/eJp2qjuUEQbScp2SY1pux7q5UQpAwXrt8l1NDSzfN0pv
	QRo9H4PqRV67I0c5FAbC7qT+qLXUcf6nOJVNT2siOocw1r0QoWca8lmwTQJDgq7jQw+ahgajrdy
	2k4KtaQoVpetduPpgLCaERGtdgemQNFB6zsOgCDfzCD5Ackbvq92IRHhljfjwj8fTpPMb9BcGMT
	DXHOaflfiA+Y+Hc+xayEt5IObQl6Jadu2GUKiDBGJJ+Nb87Uvd/M8+GO+cv8H+mfooSOC8BHFnV
	dJ5elpb
X-Received: by 2002:a05:6808:23d1:b0:45e:a749:81ed with SMTP id 5614622812f47-462fca3a963mr450639b6e.25.1770330175437;
        Thu, 05 Feb 2026 14:22:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462fe9a12f5sm191055b6e.5.2026.02.05.14.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 14:22:54 -0800 (PST)
Message-ID: <1a5a4c44-e073-43e1-8eec-59d8c3bac2b4@kernel.dk>
Date: Thu, 5 Feb 2026 15:22:54 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.19-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12068-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 38BD5F808F
X-Rspamd-Action: no action

Hi Linus,

A set of small fixes that should go into the final release of the 6.19
kernel. This pull request contains:

- Two small fixes for zcrx

- Two small fixes for fdinfo, where one is just killing a superflous
  newline.

Please pull!


The following changes since commit 145e0074392587606aa5df353d0e761f0b8357d5:

  selftests/io_uring: support NO_SQARRAY in miniliburing (2026-01-21 07:55:13 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260205

for you to fetch changes up to 38cfdd9dd279473a73814df9fd7e6e716951d361:

  io_uring/fdinfo: be a bit nicer when looping a lot of SQEs/CQEs (2026-02-03 10:58:32 -0700)

----------------------------------------------------------------
io_uring-6.19-20260205

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/fdinfo: kill unnecessary newline feed in CQE32 printing
      io_uring/fdinfo: be a bit nicer when looping a lot of SQEs/CQEs

Pavel Begunkov (2):
      io_uring/zcrx: fix page array leak
      io_uring/zcrx: fix rq flush locking

 io_uring/fdinfo.c | 13 +++++++++----
 io_uring/zcrx.c   |  9 +++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

-- 
Jens Axboe


