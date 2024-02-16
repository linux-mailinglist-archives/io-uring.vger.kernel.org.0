Return-Path: <io-uring+bounces-615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14ED0858604
	for <lists+io-uring@lfdr.de>; Fri, 16 Feb 2024 20:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6B3A1F22D9F
	for <lists+io-uring@lfdr.de>; Fri, 16 Feb 2024 19:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9A71353FF;
	Fri, 16 Feb 2024 19:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="abC51myd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F5135A52
	for <io-uring@vger.kernel.org>; Fri, 16 Feb 2024 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708110719; cv=none; b=ThU5xFqsxe6mcBjXznKmpZkZASF58y++pzwJ53PZGKr5Ghnp/3x3FpG9cvrLKYZCrVjS4UqePrATKcKEw69iHdoWVpbjvwGaVQ0mb+8nRs9rlhPcki7pOLR6VvBFlTvXH1RKQmn3QX/o1/iBkal/H3F7PJbcwCcdJiw8qgElaoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708110719; c=relaxed/simple;
	bh=kHUDr0PTxyKwhH57JWGC2qEFrzARDIu/vPrd13kAbyo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=rB3R7402hmV+WUcSjDHh3pd3+yzToGUyEcQXZHwaNHCdBD/pnH/ech9Xv+XEoKpPiYLRct02z/onHqD8fC6ewhRPfHISZEoMhPA9T46TzAkhBOVdOtAf+nAvjxmsdFpSj4ugjelTbnaArtlqZhH24zLJwjGRKoq/q7p1BAZkXkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=abC51myd; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3641b8f88f6so1300065ab.0
        for <io-uring@vger.kernel.org>; Fri, 16 Feb 2024 11:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708110714; x=1708715514; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/mMu3JgCxBOjGSeVnFiLiEJtvJMseCvPi0ssk+qPn1M=;
        b=abC51mydz3YAWJk9BnmwF3bZ79qqkm5zhaboxlxzxH5+YDsvuZY2aurW4tOvzzZEic
         HRlsg9WbEwY3e6X6TuEsyEccGjfU5pDJ2dJj/Go3/ru/TO81sY1nzCxZy9+zQu6xal24
         PAsO8jHK7zhyWDSYqMTDbgiCHtgjTAsuUDczy+DXCyBr1pkEL9NCVU0dP1kcH0LusJwg
         S0lUJESzmCpIgUJhCn4C1nSm0esTkTy9yR97PE7DVw6KeVkRVen8jTCjlqX6tICoi3sT
         jgpo6HAtVBrop/fnkNTugFGgGC9hJx5tCSRW7qzUEHnrNeSPgtZtL3QkOjKY2YvdT1HO
         ysZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708110714; x=1708715514;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/mMu3JgCxBOjGSeVnFiLiEJtvJMseCvPi0ssk+qPn1M=;
        b=wPZKvlQQSvkrphgVyXperhrTvQfYWSCCl3uw01+emtauVB1cN3r25HaqDTKg4ynXM5
         P3v3Vev0hoJK56KWh5pu35aJznle763LMTk59oZqAFaSejdlPDV45qOT+RCBtWt5QfL5
         EVLJF8TSl8NjXIYslg8oFaS6mmOg4QltHK+0ibdUdLNVGj29FbyjFJtNczymIR9ym4Bf
         ndCPtd5KL7okj7HG/wltEFhwpxgmsh3MPCjcErHkYhJ1jGXPQZ26YkB8RXFeow1Ufrew
         rR99VzCA/Nji49VzZkS4EdKsSFTY8aKYkRDaDZiS0ruwNEbsG3i3bVz8mA0b2lPhHCdJ
         GmHQ==
X-Gm-Message-State: AOJu0YwfuTbDiDvgOUsUkIy7swMP1wlU5frXGWD3BcM5R93yhJkbrBr8
	/oEqK2P8me728r8ubnyamTyi+KD6OoqBx2kPYXxbNV78fxIJOCDYtOBDZZ3B6oE1kMJL+DU02ab
	1
X-Google-Smtp-Source: AGHT+IHIUhyE6Ex6LmSAcyo38XrAxj/8iJVB1MEHOTQSLeYkDCzjwPbokkZu2MQYuDS1hdU84NB1HQ==
X-Received: by 2002:a05:6e02:1a4c:b0:363:b9d6:126a with SMTP id u12-20020a056e021a4c00b00363b9d6126amr5484762ilv.1.1708110714448;
        Fri, 16 Feb 2024 11:11:54 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cd4-20020a056e02320400b00363797f6b00sm650283ilb.8.2024.02.16.11.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 11:11:53 -0800 (PST)
Message-ID: <117cdb52-5e35-475b-8a05-e6f4da70849c@kernel.dk>
Date: Fri, 16 Feb 2024 12:11:53 -0700
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
Subject: [GIT PULL] io_uring fix for 6.8-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for a regression in how overflow is handled for
multishot accept requests. Please pull!


The following changes since commit 72bd80252feeb3bef8724230ee15d9f7ab541c6e:

  io_uring/net: fix sr->len for IORING_OP_RECV with MSG_WAITALL and buffers (2024-02-01 06:42:36 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-02-16

for you to fetch changes up to a37ee9e117ef73bbc2f5c0b31911afd52d229861:

  io_uring/net: fix multishot accept overflow handling (2024-02-14 18:30:19 -0700)

----------------------------------------------------------------
io_uring-6.8-2024-02-16

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/net: fix multishot accept overflow handling

 io_uring/net.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
Jens Axboe


