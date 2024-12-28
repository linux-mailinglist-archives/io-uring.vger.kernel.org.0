Return-Path: <io-uring+bounces-5616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F369FDBAE
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 17:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9DD07A063B
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 16:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E2B38FAD;
	Sat, 28 Dec 2024 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bx0qXq/V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E8F1EB36
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 16:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735403457; cv=none; b=caJFeOOeO6P95wOwhM5KNFUx2niBbITYaKgNL9xDiUFr8MuLH5l2HcOVEXoY1C2lK3YJQ8KeeyEzvQ9bPkqqhL7IMTgtHZt24avaBPKfaSstrEUYaap2Ce4+huhf1ifHvR7JJKQcnwdlC4QO94Xztr4noHtGlb3KoZpgD5etARw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735403457; c=relaxed/simple;
	bh=Dze5htnHriHOeIg/dwjc1rX13HwwaUQLwbL+73w5SrM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=pUZOK9ZicXJ6TNH1fRv8KgeCmtTR3MfCf622xqm3rxHsVkNKFvP3syjKxxKqlCQ6O5uZ1PD1ixKBrK5zayMNkOWtZE/DMNv7qW91GrCwEXGd1bUZifheJ0s3m1tsx9Y3rwS5RlkWXYBtR1d75xb8vHcvN6D0BxvvqzeRH35ogNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bx0qXq/V; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f44353649aso8260684a91.0
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 08:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735403453; x=1736008253; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydKoEEgVwJTUIE2Tza+bQNizWVqs00QYfwU1EemJrcw=;
        b=bx0qXq/VU1VZ1PSokmvy8pQ7o/iBr0Ft8WXuBpys6ntr3Rt6jD0wB4giAXbrgug88z
         i1kxLshh8ozAZprJO5/Ks/9/tx5QCLEMoot6H57NzEDJrHtykVLuYd9GnzjsiwuY46D7
         XDHBdD5b6JdLi7SanSDqD0cxTPrukeUHQC6e41MASqVrCCS8YiL8oD3FwkrIVdEONr4S
         wo40TbLUeLPhQdV8HeQc8SqhcOA+d1CpvyihGcxSmUvTaW4QOLw4CAwkfm4JvoOVKK9Z
         hI1aQVlwDUmRaQIN0+wNrw4cZjdwjIlcX3xY0yMnLYuicH5SDPZwkgaJmxaG4gXZfdMk
         +RPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735403453; x=1736008253;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ydKoEEgVwJTUIE2Tza+bQNizWVqs00QYfwU1EemJrcw=;
        b=Y2U/SNnoD+p4ND4PqnM/yXd/9eTrkIEnCRz66JyeDxEaOGutmS+KzlvBnUkxtCIKZj
         +Vx1mDfPEZO8TDhhRoo/BAOb6/GeCR/eAec9KiaYYUTCuX4p0DoBMnGAFUIt+AZd3zff
         4Eyobq8VFahhCBbLdiXOvLcxEl74dLsDfE2o+CuiXGl6c9KwBfg/M6LO63frJkUOwEdY
         YEosCKNxK2w1RVTDEvWvAzndmuIUfHne3CtM7YOcLqkns9CMSbpQ5Z6vEg4AaLb5vRmQ
         U0fbnxPCK2hFdWP9itxVWJwxef0rCT5P2zd6MptEttvitZxweagv04pCsyfqqAdjyNcI
         FU+g==
X-Gm-Message-State: AOJu0YwlKdHy67PKxgym+91zNGlR3A/FsgeoTpMDxws/XVrfbh75f+NC
	fwR2S1cT6cZ9B9zPzYPUmcdC6crmCtpHr7etYxLdvGanBqKPpHft47a1kJZ25DixJ+njLbi3PCw
	I
X-Gm-Gg: ASbGnctHQDwNObsSITiPOPTpWcsmT763cMHAbKUmKsE2Ol2xiAQ5zH+eOd5EmOmng/G
	++vM+aVtvWopeTqdIqUQWF3i95mCuSzdFPmBxAg8686dOcZ8u1vhIzPDYsJQl52Zr8La+aVfSP8
	MiNlWwfedAfsEMd1wQfNbENlfrlcm6fS5b1ha1bnoWVot3Ucsc4xRW0N0OtwlgQLbZqFnhyNlOb
	dGSxgssCL+p2fLGpvpQlnhWej0x+u+nBicFxakeEEP+DKjdkbRlBg==
X-Google-Smtp-Source: AGHT+IGFQueoSsx7YH64y0By7AyBfWVotfcr7OsOgW7+2wjiKD3CQDXZqQpaXLiXHNReVaqSS62Quw==
X-Received: by 2002:a17:90a:d644:b0:2f4:47fc:7f18 with SMTP id 98e67ed59e1d1-2f452e22970mr46174304a91.10.1735403452853;
        Sat, 28 Dec 2024 08:30:52 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9d94c4sm151314685ad.115.2024.12.28.08.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2024 08:30:51 -0800 (PST)
Message-ID: <74951781-647c-4de0-9d4e-5485cf9f36af@kernel.dk>
Date: Sat, 28 Dec 2024 09:30:51 -0700
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
Subject: [GIT PULL] io_uring fix for 6.13-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for a theoretical issue with SQPOLL setup. Please
pull!


The following changes since commit dbd2ca9367eb19bc5e269b8c58b0b1514ada9156:

  io_uring: check if iowq is killed before queuing (2024-12-19 13:31:53 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20241228

for you to fetch changes up to e33ac68e5e21ec1292490dfe061e75c0dbdd3bd4:

  io_uring/sqpoll: fix sqpoll error handling races (2024-12-26 10:02:40 -0700)

----------------------------------------------------------------
io_uring-6.13-20241228

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring/sqpoll: fix sqpoll error handling races

 io_uring/sqpoll.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
Jens Axboe


