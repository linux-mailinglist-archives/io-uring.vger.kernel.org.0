Return-Path: <io-uring+bounces-7158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7494AA6BB41
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 13:54:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51F371611E9
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 12:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1623225387;
	Fri, 21 Mar 2025 12:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qjPecHY5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22DD1DFF7
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742561598; cv=none; b=R/YJEnczdCicWBVH17NRJ8uKIC+gR5Ee0Y01KLYB3KA3Fh5qWpiF9IcKMSVZV1izWyEebrV5MGZNMYzCOw4GK7QVzAv7auhg/JpHNNJbPqJclLytxvUvyH+/HH1G/gVpyt5WWXxoKwa8EcDbK8xDnwsw8c/WIg5LgiWoyOdPpW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742561598; c=relaxed/simple;
	bh=Udx4Uhn1BG2vF+IoiodAHPV5P3oz6x12jyJLzP+8eXY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=S3/+JOePYGDGaw3T4tRNas8JOXkYfdXVgzyPjroCXqBlKpSDnXjdktWotYI1zQcVDyjIXQVYpBmgfn+2eqyt2lTal+Wxp546Yesl1cGixNNp+iPjYP/1ov/eBSLyAdnevxjtFbsuTKQTsJUPLmaGNE6PGXEjXDYtEstkZWfkPs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qjPecHY5; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85517db52a2so29825639f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 05:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742561595; x=1743166395; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUCKg3/+xXrrvJekXLSJWhwRvwxu/w1HdaWq77/UT2k=;
        b=qjPecHY5yUJyiHbX/He9087EPk6ldewH5HEz1NJlDU7t1e5UC9DPJVXzdiICZ3aQlG
         oeSxgYlfyX2akU6E7zbB5iHbJcatGc0SKv/FTE+ir9gMk4ttIfITzQpbCZM8DkHauJyD
         mHtnPbvc5Xv1JnqrnNiGEhoYOIycgcrWxQ6PnnlS1uTncEt02Khq8KVCRIM/kPs3bIty
         dJQ2mBkwbuNhWkOWffcN0rKA7bBAgAjOagVZljZ2gSp3qJoPdWhE3Uh/wlvWe7zu/8HN
         Mhuz0Aeez4RmTSM8ijS3XR7FZULOx8TzBxt/U3+SEEjEi1Ws8pRISwk4g+0PdEYOHZ8M
         F66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742561595; x=1743166395;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aUCKg3/+xXrrvJekXLSJWhwRvwxu/w1HdaWq77/UT2k=;
        b=vEtpn0HRf7Tr5azZ98Pq/CTr2YREzy0+O4UY90nSf+Qjed1mLvGANCONyaNRoILwOx
         da4PSGiikOfH2cnG5MUaClaXjwxje7XtEfKbUaey+fRswNfUIOvf7k+oWS6DnsfOgWsd
         XhxoYp2Oc1E9lg4H+OM2irhjS66qJF8QlNFF8Zb/Q1accR3ot6X8ynD+Gg1zQySBefBm
         fXWncYEKS2+BoINrQ8ZAv52Fbh3vv2/BHpf5xM24N1Ng7Jl2eraa+HZw5BwAZdviaVni
         ByMYjpiCvPyLysrhmFV53jtqCjvkqwkqZC4Ai3m6RYMmcOjpszHbn97p5Yn0YJ3l8/ke
         /7sA==
X-Gm-Message-State: AOJu0YyjYzwWaZwyZHTRTNOBp8/JIITpnx7mhoOwMDVPN6tGddpMfCu0
	QQxIphaoXz87VVdOJfWr9HNdCtJXY2hgMJtu+MGb7i5AFf/DWX083gw7nFWp1/jj75IkWbWNHRV
	U
X-Gm-Gg: ASbGncuTc8f6uliB9ETNhMzrwW4l7/etdzYfloSYidRMi5GeK9Z4z06Cxb8vtRS/PXH
	zxY5rPVEpRD6LmGRmgHYRrujzO7BFYEWG7YYAS7miWfugoKgDdUklVRTeWvA4FCRlkaOllX77nP
	A0m+P30W59xWAwIDRxGNTZWCjTEg65tV3LVN14GbepwBtXTokUncQC8eWBHGtkEBQGhfhHLisP4
	A+1jxe0k8JfNOI6SjaUr9QM4SxebOm4K2YGF8ZrlwOmt1AcRj4FtIdFOUUmpoax+lItkPWyFLOP
	Oq+3YbzVgIUMoPmPISYFNOu5aNLpNH9v+CknNoRA8g==
X-Google-Smtp-Source: AGHT+IEftpQOya4MD2ogE1fkINdBzdNWNrVjYfE8cgeBU7Ra7LsdWqbN5F24vPdfIt0KID69leRMcg==
X-Received: by 2002:a05:6e02:3d86:b0:3d3:ff09:432c with SMTP id e9e14a558f8ab-3d5960bf789mr38966805ab.4.1742561594676;
        Fri, 21 Mar 2025 05:53:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdb3ad7sm416756173.9.2025.03.21.05.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 05:53:14 -0700 (PDT)
Message-ID: <9f3a5862-cd77-462c-bb8a-3cc26f905391@kernel.dk>
Date: Fri, 21 Mar 2025 06:53:13 -0600
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
Subject: [GIT PULL] io_uring fix for 6.14-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Single fix heading to stable, fixing an issue with io_req_msg_cleanup()
sometimes too eagerly clearing cleanup flags.

Please pull!


The following changes since commit bcb0fda3c2da9fe4721d3e73d80e778c038e7d27:

  io_uring/rw: ensure reissue path is correctly handled for IOPOLL (2025-03-05 14:03:34 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.14-20250321

for you to fetch changes up to cc34d8330e036b6bffa88db9ea537bae6b03948f:

  io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally (2025-03-20 12:27:27 -0600)

----------------------------------------------------------------
io_uring-6.14-20250321

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally

 io_uring/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
Jens Axboe


