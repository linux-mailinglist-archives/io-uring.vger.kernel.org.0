Return-Path: <io-uring+bounces-1830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8288BFFF2
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 16:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CBD01C20C5E
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 14:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA46E84A39;
	Wed,  8 May 2024 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MgfI07sc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7227D182CC
	for <io-uring@vger.kernel.org>; Wed,  8 May 2024 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715178451; cv=none; b=X/HSh0wG6NJJOpS+WVMBHTamBF+cmmVXXJDWotxtJS5n0EDBauhQ8WGLNQKqT/BvZoBzZYErx/MwKptT21+smT1znT90FY/y5xN1VJdggACRl2b0dG0wVDQHN8tDUjLSyYJqpyVkctvsRhybisd/HZKYL7wdMvgfjaLEhSMWgfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715178451; c=relaxed/simple;
	bh=p8nai2ZAlYhtwxLIrH2p691jOjKJRRrZOPxqu1yc39o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SiJFSvpA0c5HMSGG+6NCxC/qDfppLzn16d/jtd7O+DgbWMfjvY+Oryi/POVAzFA5UbOuSyK/DqJerp5ZuOWmifCHi/u9rEJ9OBc1lV3koZk5auw4C/f/IOUN8PFmlDlpbDkKqUjx03jIcuNJ/wuwDkV595JvMZwgnbJRqHV/J+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MgfI07sc; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7e1856fda57so16474039f.1
        for <io-uring@vger.kernel.org>; Wed, 08 May 2024 07:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715178447; x=1715783247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2djfWTBbW2y2tcbRKSDXWtWG+o4dv/dLxrRWgHoKOGA=;
        b=MgfI07scapvKj5mFCF2m0+UBxh79U3pZlhrft8wQydKCmtMwYYhnzyUKbt/7Qf4laY
         lFP4ypGZPpBEwISHh2R9Sxe28GlU0CEjNB3FVJlYMPKap9hlKPMI391yQvGA/MfYPb8+
         3en5391GMip/kv9SDtT0J/22Qhi5Jw+4GxyljZacQ7RIfm13B9ZNZHq1ZU3WuT1RYR7l
         Al06WW6y03fJG0nmFSf0azPHERuUHWgtQfLUrDYiGYQh+bFksoCjcRheV+/LMs+WLj9r
         OSJF6UkGniwiTa33o8wd+t6E1h8iC8dgrYOAHFT8ncHJIiyM0LX+GUAHb/+15thO8aHc
         i8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715178447; x=1715783247;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2djfWTBbW2y2tcbRKSDXWtWG+o4dv/dLxrRWgHoKOGA=;
        b=kh6OhHGHP1XzKyBXKQkWBHA+DdUmDwWCohaWl1+1bBNZ2pq9xc/+YvfYC8doEbRPSS
         e8pnyPEgAV4yp+oWuv3FufPFW/tStUhSogcYxOOeRyn4MGVn935O6OF1lScAPvOt13Hq
         RCoBeEl22ibMCYRt38F4qcszyuSnYNDYKF623ddDImEirF+H5r+m4Cj44AI0eqTViojI
         aNKQ+BQpDep2/pxVtzV4bKrGqr+8c3lOhwWpapB3pP8kxfv9BV5wuJzEFDfGSMegusrW
         PKgG3FngQiJxfNtBbv829DOULRFeaFMer4qA9D9pTSxsyY+BVqj2zESeKiBukAyEb0iD
         K9Og==
X-Gm-Message-State: AOJu0YzJ9mSHqT5tyv8/2wiadbg3Ci93jveZV5exiYQgqorUdTfAF+MQ
	9lzyY8k+J23TYm8ijbgRT7l6Jycx/BEHWkz2bZ3ROkDvFzSU/3fR2FJNdlX6JDVIzqNms2nC6cV
	8
X-Google-Smtp-Source: AGHT+IGliWdJCBVrTH97EuTWCHQaRj+078ob+A1FJJC1h1UHLvUafcCE+vDnhpk2Zaeu/EN7OcZx0Q==
X-Received: by 2002:a05:6e02:1647:b0:368:974b:f7c7 with SMTP id e9e14a558f8ab-36caeb48b66mr32493305ab.0.1715178447553;
        Wed, 08 May 2024 07:27:27 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k10-20020a92c24a000000b0036c6ebd0455sm3180672ilo.88.2024.05.08.07.27.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 07:27:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Accept tweaks
Date: Wed,  8 May 2024 08:25:35 -0600
Message-ID: <20240508142725.91273-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Add support for a forced nonblock accept attempt, returning -EAGAIN
if nothing is there to accept rather than arm poll. This is similar to
similarly provided "-EAGAIN is final" for other opcodes.

Add support for doing polling first on accept. Again similar to support
we have for eg recv/recvmsg on relying on poll before initiating the
first accept request, avoiding expensive setup only to tear it down and
wait for a retry.

 include/uapi/linux/io_uring.h |  2 ++
 io_uring/net.c                | 22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

-- 
Jens Axboe


