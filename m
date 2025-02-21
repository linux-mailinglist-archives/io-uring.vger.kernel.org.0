Return-Path: <io-uring+bounces-6610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6230A3FC0B
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 373E6166813
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004371B85FD;
	Fri, 21 Feb 2025 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QVq2nxOS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE41F3FC1
	for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740156412; cv=none; b=JPPfDGol9rysuMkAJgl7GxRWtbyDgY3p0jq4p37G+fXIpdADC5KoaVHnFowiYBwJlxxJKKNSmDn3N/P/mwzWYTRpK0mAk0YctIoB7lMahlMnNajiBWW7yT30a0pxbmUbPqxgOkkSQU4EddjKHM8uArfjbTJE8D+9Dyb6mQVC3/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740156412; c=relaxed/simple;
	bh=PSmsEZnd72lytojDm66x/lvHZqQnklJvLtO630vVU8E=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=dPAWn+yuDPbHXrynNyyKYFHnytuTla4d6/cEhpUoACXhdRdccUa6EhaGQ8JIwx4L7N31kRnGNolb3ti7jUp72c6iYLlS+pr5NhCCgnvKkX+eRf6GexKpAt72CnzgZ0InWZdUXdf4xpEs3sirBhKTQiozLUYyf5gF9OxsqnP87Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QVq2nxOS; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso6994355ab.1
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 08:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740156410; x=1740761210; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWuqTcxpvtnmdIWtuY+mLIdyD8l5qwM9pbcebjTAzio=;
        b=QVq2nxOSkJODwrGbX0QRAh3AoyYb7yMYY9bjg9GQz4Eb1Kgw9JDYqohVzCex9bq2im
         aJvQ8Het9hfEgxCbpjy6xGioQHNh4/evMFYMPu/SVovLE2cguOdIqZQBC0BCZCjzeb6Z
         s5D/pNHfnM5q2rdUArNbuRwkBR5I9uo72o0rLoJhA9U4jvhpHOaX1JFKqdNb4Tu9paJz
         vSUiuFYMyJejSSc102EIH+hYOKQOYimLExiZp8jK4i6FfKWMDi75Lnz+J76uWcrI6HJW
         vQkG4BRsZbg/bP2CFz+V8Ogo55g+rRGRhRt6WCSo9aJYnh/hQtSzw9CYsAf5sv7yhlmr
         iIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740156410; x=1740761210;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qWuqTcxpvtnmdIWtuY+mLIdyD8l5qwM9pbcebjTAzio=;
        b=S9VCE/j2aw4H1OiGz5JGOv31WjW659C6szCjCtbAxTvCQmvSOccIW5xg/Kc/CDPD3z
         tOFB0+AwAXwjC+sTqu9P5fGMhy+UdLTv8+gxYkSpv8rXshYE6f8ldqcdVGDEAbPXTdD3
         AtZHSzAngzfqaEPsAnaIe+QOQNE8oV9fOts3QbnV3clKmJ0GCMzo+87P/nzVg8GYyMg5
         Se3dg4Zzz4RLY5DxO8OJKxYl4exBvq0YOR9YyIbl04OvmvIJJzCYydJZDhSYeyoAzFdA
         6+gGt/yAVSIMcrlKJiRJhwbTC/PP9pKlX8lSyxpoEKzn4GnOwxayVEXsRG3+dv8ImUOc
         tC1A==
X-Gm-Message-State: AOJu0YwzmD3xL4JlSDvfB35dkymCNlRr9CEuj0IKk6/4hMWRd5bw8jth
	P46TnU9xUyP/worWqkQ1o71CE8egu4jfxjhWuafIygZjF+S4/UbopMewzOFIU+KrTNKmOuObeTp
	P
X-Gm-Gg: ASbGncuWpuwIDkkTQDTeyENaTXFqkbj5gU1djeuixFAkZQM30iZQsoaZbtvgdwu2mWN
	lcTTAwKrARLKQe4TxElURYgWsYylDSXXImPRN51n8hw9Yc8UqUCoodrSgNzpzAznsju0VW8R80f
	HoRlGCXTFkySf4b00/wM/YT+tT5lzRFMTwBOBsMSkesd+IIehVk9hv1IfySzbDKVEuruF2LOGLP
	DWTeF/9IwAdVKWB7OBrq+p/+zQQbZVrldZ3X1ewiUufiZoTfdriaYqcuM7cD5zycxg6W9g2Whk0
	bkDBzC7/knX+o/mDTEfBTAk=
X-Google-Smtp-Source: AGHT+IHCcWtZc0YCKF1itxmPTELDmRC9z+Kl4gV7MHSlzmG1xOOWgkqNP/28fHT111K4yb2UNluR+Q==
X-Received: by 2002:a05:6e02:310d:b0:3d2:c9e0:de42 with SMTP id e9e14a558f8ab-3d2cae6c33cmr44173755ab.7.1740156409704;
        Fri, 21 Feb 2025 08:46:49 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2b207fa91sm16270755ab.46.2025.02.21.08.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 08:46:48 -0800 (PST)
Message-ID: <12ab89dd-5bcc-4d94-ade0-3856a1f35ec3@kernel.dk>
Date: Fri, 21 Feb 2025 09:46:48 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.14-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Some fixes for io_uring that should go into the 6.14 kernel release.
This pull request contains:

- Series fixing an issue with multishot read on pollable files that may
  return -EIOCBQUEUED from ->read_iter(). 4 small patches for that, the
  first one deliberately done in such a way that it'd be easy to
  backport.

- Remove some dead constant definitions.

- Use array_index_nospec() for opcode indexing.

- Work-around for worker creation retries in the presence of signals.

Please pull!


The following changes since commit d6211ebbdaa541af197b50b8dd8f22642ce0b87f:

  io_uring/uring_cmd: unconditionally copy SQEs at prep time (2025-02-13 10:24:39 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.14-20250221

for you to fetch changes up to 4614de748e78a295ee9b1f54ca87280b101fbdf0:

  io_uring/rw: clean up mshot forced sync mode (2025-02-19 13:42:22 -0700)

----------------------------------------------------------------
io_uring-6.14-20250221

----------------------------------------------------------------
Caleb Sander Mateos (1):
      io_uring/rsrc: remove unused constants

Jens Axboe (1):
      io_uring: fix spelling error in uapi io_uring.h

Pavel Begunkov (5):
      io_uring: prevent opcode speculation
      io_uring/rw: forbid multishot async reads
      io_uring/rw: don't directly use ki_complete
      io_uring/rw: move ki_complete init into prep
      io_uring/rw: clean up mshot forced sync mode

Uday Shankar (1):
      io-wq: backoff when retrying worker creation

 include/uapi/linux/io_uring.h |  2 +-
 io_uring/io-wq.c              | 23 ++++++++++++++++++-----
 io_uring/io_uring.c           |  2 ++
 io_uring/rsrc.h               |  6 ------
 io_uring/rw.c                 | 30 +++++++++++++++++++++---------
 5 files changed, 42 insertions(+), 21 deletions(-)


-- 
Jens Axboe


