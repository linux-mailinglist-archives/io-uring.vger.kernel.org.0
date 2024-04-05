Return-Path: <io-uring+bounces-1416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBF989A5D0
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 22:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A440C2832B4
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 20:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 763791327FD;
	Fri,  5 Apr 2024 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fwzdm0vN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255531C6A8
	for <io-uring@vger.kernel.org>; Fri,  5 Apr 2024 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712350021; cv=none; b=bxwns3xehKrtZoucezlU9N00J5vq3UBfmPrfH4okaoy6q8aOES/O4UDNDtDBbsYNQdHd4zedgEe9GmuNxDwaoguVQdVgDPPDhM1yRFLszBk3geLszoYidVguW+C++G+bq/W050qM65m9jA3/0ZhKZ5s+jDSdrPU/0X+CE7B2QgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712350021; c=relaxed/simple;
	bh=aWJGg6HJvOOMQqkaEgtKoFFJhgITUKTCMUDIkxVXFoc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=qZ46aqYHFsU+JPCT+3jkMLtjpML6bFZvdLefqwLMrBTqm6gIsX8GTzfk2do/rXM1TmvFmd5Lzp2Lv9ysjjEzo79WVGmop85fOeSoWcp+COgZz28qgVB8qSU7CSM8KdCyg6+u5NsJPevrV0s+LPijgrXzROhH3Jm9QRq8z3YKnrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fwzdm0vN; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-789db727eddso47752785a.1
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 13:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712350017; x=1712954817; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afFGFxtKg7DTIB3mZLaUxhofvUIHTy4KS1FNO3B8tt8=;
        b=Fwzdm0vNwYvIYfSf8/VLdL7PFIJvx0ChC7MGgE0PblMJNdNSOhelAXo10rXhcauX9G
         tNmJRA90dArw9/qjNS3Fl4o/TXvM+RtqTyj+rfhikUwF704NRKPfXKk4F3jGvxCk9uey
         WMtzy++8oU4HEsMN1/RFACQPiOzd4839/Fm5cJSAERVMfHskp6hg4HlXXsmitVrs1r/x
         kALYxGIIkOwiBmcMoeaDZY4IYDWAjxP7kMJlliqhU5QtBhfVV2oqK0/pshx3hLgGHnqp
         A8LnQbrb2xrHtIRKZCH6bcfn5jPRCGL2DbumjWquPVpHZzhMe6cxarFQxRbkoGNr9ZkU
         s7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712350017; x=1712954817;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=afFGFxtKg7DTIB3mZLaUxhofvUIHTy4KS1FNO3B8tt8=;
        b=JdNjnfoHnMwkHCmSvgEmIw4GtnHxUu1bUqLmEpYUdXrbtTB8gBQNdUtc0cUpNlEvSZ
         mc0Hhn6j0wpuQzrwe3cRRzV4H0Flub4Nq+QcrUFEouQdlOO36AaTwmYmU3IvwyQd2W7E
         hUZHtYun9rlBFkUhM74LkM4QRjHp/z5snDf5fod3ml/FpnrN88MrP/08G8IP7X5j3QVW
         3bkRfAebqDI11RaAjs2e+H5jySUxmJSrS/97YstlFJ2RouJBs7KMIZsMJMUGgZbesC5/
         H6Ww2mhL+lfKmZ5m2AGddG6CBLrKaqFYyUN/AmNNimC/bFWQzwYJvdoLqJFgs4fZ8u3a
         t6PA==
X-Gm-Message-State: AOJu0Yx1YWXFMDvdqLHVA0oBfz0miR67XyNrlq1QsPPGm3gWNkzmMLHg
	jzBHmlC5LWLNZf6qR3r3nwVoR4EgsVxUeONpaQaMTpTiQWNNFzV30NXtEzdc9cxh6jyJGnI51/w
	P
X-Google-Smtp-Source: AGHT+IGkP07f/yZV2f3ygQ1vmC+4/lHrSeQDsnlDcLkGd68MZeyKWaStn2rE4BtnG34DPvzm2IIxMg==
X-Received: by 2002:ad4:5c44:0:b0:699:278c:af6 with SMTP id a4-20020ad45c44000000b00699278c0af6mr2503626qva.6.1712350016770;
        Fri, 05 Apr 2024 13:46:56 -0700 (PDT)
Received: from [172.16.25.96] ([12.168.1.234])
        by smtp.gmail.com with ESMTPSA id do18-20020a056214097200b0069942d4cc06sm587601qvb.115.2024.04.05.13.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 13:46:55 -0700 (PDT)
Message-ID: <ceeb1b95-070a-4812-8a43-12a638da4c94@kernel.dk>
Date: Fri, 5 Apr 2024 14:46:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.9-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Some fixes that should go into the 6.9 kernel release:

- Backport of some fixes that came up during development of the 6.10
  io_uring patches. This includes some kbuf cleanups and reference
  fixes.

- Disable multishot read if we don't have NOWAIT support on the target

- Fix for a dependency issue with workqueue flushing

Please pull!


The following changes since commit 39cd87c4eb2b893354f3b850f916353f2658ae6f:

  Linux 6.9-rc2 (2024-03-31 14:32:39 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.9-20240405

for you to fetch changes up to 561e4f9451d65fc2f7eef564e0064373e3019793:

  io_uring/kbuf: hold io_buffer_list reference over mmap (2024-04-02 19:03:27 -0600)

----------------------------------------------------------------
io_uring-6.9-20240405

----------------------------------------------------------------
Jens Axboe (7):
      io_uring/rw: don't allow multishot reads without NOWAIT support
      io_uring: disable io-wq execution of multishot NOWAIT requests
      io_uring: use private workqueue for exit work
      io_uring/kbuf: get rid of lower BGID lists
      io_uring/kbuf: get rid of bl->is_ready
      io_uring/kbuf: protect io_buffer_list teardown with a reference
      io_uring/kbuf: hold io_buffer_list reference over mmap

 include/linux/io_uring_types.h |   1 -
 io_uring/io_uring.c            |  31 ++++++-----
 io_uring/kbuf.c                | 118 ++++++++++++++---------------------------
 io_uring/kbuf.h                |   8 +--
 io_uring/rw.c                  |   9 +++-
 5 files changed, 73 insertions(+), 94 deletions(-)

-- 
Jens Axboe


