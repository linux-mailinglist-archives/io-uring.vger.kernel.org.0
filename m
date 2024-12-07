Return-Path: <io-uring+bounces-5292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7FDA9E805C
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 16:11:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95D4D18840C5
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 15:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F3F433B1;
	Sat,  7 Dec 2024 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ExRQeJ0u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045D41E529
	for <io-uring@vger.kernel.org>; Sat,  7 Dec 2024 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733584270; cv=none; b=AEICCfBuyEnONg/cBOuCSea/RFUF0RuRnjVs0rvve8kVbtkah04rBwFiocTg44HW9bp1J63yZjx40TvL4K1gVDednESR88XdiqHfrgZJ8sudD1kiMO1wSuD4dYRQ0ptrPllQvIycENNCIEahpRFBwEUF+O7tp3M8GvTLPO9Ad6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733584270; c=relaxed/simple;
	bh=7+nkaJFUigPqj5R0nsttHa9oYYBNa0x/Kdmte/n7WkE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nNHmHEde4CIPQwI0jRpo7Ugt0SeZHZ6y3nmvg/01PrZ0mjv/6sEkPaW1PaxcL/w9nlF4uPieZEudE5mcgn0hV2rlAEAFQy34yscoYsaU+pKqMsUnpBT++SaaggexZr1EbioTCYUUggFGtSR3LX6fFhesl0JQdhuyMVCGKOy2OyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ExRQeJ0u; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7252fba4de1so3406347b3a.0
        for <io-uring@vger.kernel.org>; Sat, 07 Dec 2024 07:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733584265; x=1734189065; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eN+ekEYNhjejT+AamC9S3TeKF5/tsiKlYYtilf30CjQ=;
        b=ExRQeJ0uQRw3JyOlnJHutc3c/tsBydX74GEjm8MPC/ddd/M3to+WFKc3U/gmQ+Owch
         rYBmurgl1G4SAYzRb5ykIl/4YvuDrzfxp1hXxuR+fqeYBWaQXso6kc9n1xmjwLl2eulG
         0mypPlFmRGngOumym0hYjUqcp+/MMOdi9xcHJ1SHd3jEteio9GPx3ljvkzwu4ifYlnkc
         CCJO4iD4j0BQh2gLdTBOdeTFYm8mzH3sCgRb6yGDAHdrzn4YC0rvuSacDdkHdOH9gdHg
         M8nCNFr9DJIoq1SuecRdaxzhzxhXmZPLS9/pShD22p2/SLYhXhp6KCI8XOFxCo/9l4iw
         GfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733584265; x=1734189065;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eN+ekEYNhjejT+AamC9S3TeKF5/tsiKlYYtilf30CjQ=;
        b=xJBCH2mlMfuqi8+5xn6yXXyym1HDQEPn/wT63Y/WHaPEEYbOhkkCgGAJdySoI71+ru
         eZdxJFvqSCWbAV5ZYZn2DC6L9NXE9EWCXtqKnr0vZaYfr/N/p21SJX49POThF81pNIn2
         nrLpxr9ulPHH2iS7PxWu2n7H4u3QSHCKgmO0ESwsKNixJFxdD8U/71u0ANXtIgZNLNed
         mZNyXhnm5jVsl3dFH4OFT6MDmYg/dgpTRRPzJ3PHneZr5dbpeb5+/rI1DrMLX1O/apm0
         asiHdW90kJv7QeonrIwjHTJe9rydEMbDeyO0I+/cZkleqYfqd/rcQ0KS8tPsQDpGE3wf
         yFhQ==
X-Gm-Message-State: AOJu0YxQ71fWnt0YvrXs1q3HOeFHy6FNi8jJp0CRyVFAjLlnciVvMat4
	oJXH0dh3K29qfzHld5AUYPpvR4tbDHyxkrN3zkcEi4odaP5Ux4ogDkSSnP58Dp8=
X-Gm-Gg: ASbGnctNWWaDVWWUoWtpDC3ghtoVt7FFM5Vs+JwBenxYxFzfkRADhtNpDRze0zFZ/cl
	HeuIgVeCUuBSSucOVP5kpgOqhe++LI7ZdblYYdwdKBgPMh/uLiIBAqxzJOpZRzNxvn+pZJEEWaF
	/HRu7jxHbvYZPPGo/XXh13nJ+gjHaD+SpX7IBtuObMToBXj61Y6JLRMfGNV6oN9pi5pYv9McwyA
	pR7VwH7h8GPPEbiKQnzVUQuYi2K/YZ0jMxa4vpoYlemy2fpxtM=
X-Google-Smtp-Source: AGHT+IF+CUv5SFQQsGhLzzpZMfOEo8A2hIkmI9dqaAdperNt2QT9+bBE4stmfbIj56HkiRcGwkILLw==
X-Received: by 2002:a05:6a00:2d29:b0:71e:67e7:1a4c with SMTP id d2e1a72fcca58-725b8154712mr12588714b3a.12.1733584264916;
        Sat, 07 Dec 2024 07:11:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fd413c315esm451391a12.34.2024.12.07.07.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Dec 2024 07:11:04 -0800 (PST)
Message-ID: <56e8e005-6c33-49ef-8ce8-deb852ea5e84@kernel.dk>
Date: Sat, 7 Dec 2024 08:11:03 -0700
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
Subject: [GIT PULL] io_uring fix for 6.13-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for a parameter type which affects 32-bit. Please
pull!


The following changes since commit cdd30ebb1b9f36159d66f088b61aee264e649d7a:

  module: Convert symbol namespace to string literal (2024-12-02 11:34:44 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20241207

for you to fetch changes up to a07d2d7930c75e6bf88683b376d09ab1f3fed2aa:

  io_uring: Change res2 parameter type in io_uring_cmd_done (2024-12-03 06:33:13 -0700)

----------------------------------------------------------------
io_uring-6.13-20241207

----------------------------------------------------------------
Bernd Schubert (1):
      io_uring: Change res2 parameter type in io_uring_cmd_done

 include/linux/io_uring/cmd.h | 4 ++--
 io_uring/uring_cmd.c         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Jens Axboe


