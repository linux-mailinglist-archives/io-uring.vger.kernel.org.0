Return-Path: <io-uring+bounces-9593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1735DB4561F
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 13:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48B167ACF3F
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC28F2EC543;
	Fri,  5 Sep 2025 11:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jBR4rs3e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BA926AAB7
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757071120; cv=none; b=LGynU0BKMszyTJzmalXyMU7c4NFGcSPn8tlLjPMwbW15rRmHONfI9yechpBgj9kuyygQNYpafp25HnkoPbw2NQ0HTZjF81S0BMO7aAMIUQpsqPaQ6g0BgXP5sTMfayHtVjvKPxdWhUm9lAqiTKWUD05tv9mMvMQjgq5xExp8Hd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757071120; c=relaxed/simple;
	bh=8uTORwb3D00xnrSpwfZOhy7bUURRiYs+eOuaQJofs2w=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=J4LMYV6Vji67dhCUYr2+I729dyYbjE8FiAv1PLb2LR15uu0A8QWTPWOeRIn2Goe2VkuJfGPCQlL6gjYbaBiqisqyOwNDTKft0CPx0Mo69C5EgDeNmqYGiGBEv8d+UWbjFpT/3PW1t/Wi1ayUypwIO+Keyrr2/+k2g99PIVG3/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jBR4rs3e; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d60501806so20057997b3.2
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 04:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757071117; x=1757675917; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYJcA7s0keMR6OUcQiR8GwwIpU35oJtw3RFv33PV/Xc=;
        b=jBR4rs3e44+kHuBvgy8U6j9+9yq36nXXKEDyXG2M9Rr4L+HnOn435TcyHu1VAHGemf
         SeL7Hch2gRmGJ6Q2mMdUz4AMBWP+qjpS5L6S9AH1Vt8H6IwmuYhpdrsGyKTtttaSTC31
         M7sOeXVfiZyy/H2IYRAg+ymDqg8KIugFi/4eHnBky4qvxkBMxpYQlGCDmb+NkpXHaXit
         QIjMAl2Izt7ZQ9nL53X5GEYZ8wv13N3OGc4HFhaLaiEwe3alVeWIkaCLJDfnKqoA3fqX
         3V6UMO8Gm/WELA9s569dOXFK1jqnehader3UEjp49rPq39Vdrmf9kzrSQRaNoqKQ6L9e
         83LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757071117; x=1757675917;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qYJcA7s0keMR6OUcQiR8GwwIpU35oJtw3RFv33PV/Xc=;
        b=g4gcCy3iyKynHc9AiKES7r7PvQYtun3uCkOVxSzUjZ3yhwrQXuqSTw4yG9JcedbfTl
         mBlXWgoUP9Vl7lDKjJF817xrYEVM6cK19Pegi7mHMsSiSNcVetPpoTDpc+cMeBW39oa0
         q8UWQD8cTbgEze5gQXcLq3EJTOrB6hrVBmd2hLHQ7GlrUhdrzcAhV8Qy6HVL5Q7HpzVY
         IVlM+hiYiIQvsfi/T3KbFWa/SXzyyYQm4ghUmgHZz1hPRFQed8n1SK4vgaGuIfMX+3hg
         0b1f23lPVn5RC915EGDBjEmWzuliaOrMAjo3UbgeOpWTKdqeIG3xMpzav/pyB97jPzMu
         zqBg==
X-Gm-Message-State: AOJu0YyWR0GIRj9vBenuJwEKVpF2wnEpV3VcxYBU165n41/daz1k0L35
	ABjDs9HFtSyIs23YHUVxvljYctc8htRtp4AdKzhLXBerfnBEhtELCh7Mgp7js4Kqg+V/pELbW9J
	gZtBW
X-Gm-Gg: ASbGnctk+hOTQc5vTuXbjXSaOi8ylq+Nrwpa4ErIEGRxuiKWny2IqYkFsDzY8VrJuaK
	ylRYXOjVGg77p8VQwNaGKJbFccd3b9XWj+3dQMeUpDH7b5xm3N2m94nkBQlZCfNEsAkM0R1uMp/
	NSXdCOjMNfaR67UmMueJNnCtA14Wfy+oa+ihXWlpgT6GTw3o0IasWF4zuxULqx/fVknY7neKUj3
	JrgbpxBx6cABh+ojVE2QmDEJWtGsAFozf9QWsTmKIGI//zREpKhb59v/IEHaFTam0jG/c2kZFnG
	nyrbN8p0HGL0e7gPBdSPIrJ4DaJMT+5PQYsDf2fToED6OklazYg9iblrAMF3L50yRtuKj+teTYu
	aa4L6T10Y/ONI7wX6kV63JB+2/VJt
X-Google-Smtp-Source: AGHT+IFz8nD9ftFet+N7MFnk8OJxw+yKQq90YTUZ7DpsUk8JBOuEDAq+zECDttqqtH8ffaXgGbYukw==
X-Received: by 2002:a05:690c:630e:b0:71a:300c:d17e with SMTP id 00721157ae682-722763fa90bmr266792237b3.20.1757071117268;
        Fri, 05 Sep 2025 04:18:37 -0700 (PDT)
Received: from [10.0.3.24] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5ff8784525dsm2295744d50.3.2025.09.05.04.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 04:18:36 -0700 (PDT)
Message-ID: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
Date: Fri, 5 Sep 2025 05:18:36 -0600
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
Subject: [GIT PULL] io_uring fix for 6.17-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for an issue with the resource node rewrite that
happened a few releases ago. Please pull!


The following changes since commit 98b6fa62c84f2e129161e976a5b9b3cb4ccd117b:

  io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths (2025-08-28 05:48:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.17-20250905

for you to fetch changes up to 0f51a5c0a89921deca72e42583683e44ff742d06:

  io_uring/rsrc: initialize io_rsrc_data nodes array (2025-09-04 19:50:33 -0600)

----------------------------------------------------------------
io_uring-6.17-20250905

----------------------------------------------------------------
Caleb Sander Mateos (1):
      io_uring/rsrc: initialize io_rsrc_data nodes array

 io_uring/rsrc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Jens Axboe


