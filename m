Return-Path: <io-uring+bounces-597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C03EA853A9A
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 20:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A22A2854D2
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 19:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8927604C9;
	Tue, 13 Feb 2024 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NqdD1TSK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2855B1E0
	for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707851639; cv=none; b=lmXNI2htVrrq6HBsPDZN28/lCkYzFS0ZQNklHvupS2H6iLO/F6CVPRgWFZmMEj84kPtzzc+pmTP9B8lYV5SBi4V7vYf7umee9OJTnyyfVh6mwQ/X0qvkOwnRwtYbrl8FoDNojBebWNpecjuh9v74tRk5OvtB4g25OII6UDQ81g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707851639; c=relaxed/simple;
	bh=S/d4yJGt5fgKJBsTCU6HJk9bwNUyH+Dw9NyqzMgnr3g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gPcE1eFXOQFCH0fR9546+PsfhpSlmEyZ0tY0GXI1WHBs+5eSsHt3G09NqDwpVkOY87dPSQXnlSIbQV3RF6e8Z8p2OdcobrC5NnWPP9RROTLDrg/8bUse3xqK6VF01VekcSUPsqDIRIr+1akdqbwBTUQP3Rnqj8+VBul0dlg0jWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NqdD1TSK; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bff2f6080aso22262639f.1
        for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 11:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707851635; x=1708456435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9bSLuN55NFi/xrhJrkp0ByrrXaxcJkpRUfYxfdbMrBY=;
        b=NqdD1TSKNbCBG+TzWO+xng2fzivaU1vHMBb63/dEqzVJ0dYECl1jtewg7FoTCgYrBs
         MPr+4RKJjW6Z7oGLNGueoBHi5J9McZPnu+l3XKEQSlQMiSqRcRajJELCUEsGCerr90nW
         z5MWZlrV6KWOhXPcmTrdW1CG7FPxcJ3kZ/5DTKI787GXd/SAaXF4SFDJtAddAMHXMd0Z
         cHnwzsq8iJr+zRqCYTtF4sKNqmzG5ZxfA8enCSovTBVsbZJ1Jp6sIpBQrpyoPCTCD7k0
         65U2LzG4dcLUSVeZEnesFotucS9PvQOFexpBVIrSgh4vcOvv+ExixptwxbXWqO/dVLa+
         oGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707851635; x=1708456435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9bSLuN55NFi/xrhJrkp0ByrrXaxcJkpRUfYxfdbMrBY=;
        b=e/j00AnzNWK3tcMLUrwLemHT5mny+9jePWJYGsLVpRRd4gXstF9VVSOOFaYdgfivRP
         fJS+FL94S+agrlirVd+pvR+idF/RCq0sfKTpYPvppm2n1yESvh77gW1UhWnr5apVa2vX
         mhFwqFmudVGUOPCHiVWDqfEEML0zD1+gnmiTtAeERL9aMW+RnEb61cKJ/0aihLha4PpU
         HByDmz0TsyFTf8dBrkXNmZZJyXok70wCqBD43JehoAd+nfiriT+jsC9Eg7b/lv0I1nbi
         G1ppHK6m4bji/0hE+6P4aQXZUk+IGFg0UIwS117ZTWsgAI+NxU2Ikor+QOZeoc7x9AvO
         qc5Q==
X-Gm-Message-State: AOJu0YzMaSx4q7njr96P1ulafRyqXnUuIvnf5+LMaIVwcIb9mou2tiVv
	EqmNz7jLs7mYOQR81YAeCo8cU3wnLO/fIOj16cRpwhSLBsygOw77nTV6YTWPwjmIgOPFGKh1UG+
	P
X-Google-Smtp-Source: AGHT+IHAf19tBWCgHdAZjmHGiUb+dO8gEKBxiAXQrChBQ9E+H0a1IJMx861U8EHkx9kyOQ7g8oSJMA==
X-Received: by 2002:a5e:8c02:0:b0:7c4:6163:e62e with SMTP id n2-20020a5e8c02000000b007c46163e62emr624695ioj.1.1707851635077;
        Tue, 13 Feb 2024 11:13:55 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cz17-20020a0566384a1100b004713ef05d60sm2032176jab.96.2024.02.13.11.13.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 11:13:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Add support for batched min timeout
Date: Tue, 13 Feb 2024 12:03:37 -0700
Message-ID: <20240213191352.2452160-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Normal CQE waiting is generally either done with a timeout, or without
one. Outside of the timeout, the other key parameter is how many events
to wait for. If we ask for N events and we get that within the timeout,
then we return successfully. If we do not, then we return with -ETIME
and the application can then check how many CQEs are actually available,
if any.

This works fine, but we're increasingly using smaller timeouts in
applications for targeted batch waiting. Eg "give me N requests in T
usec". If the application has other things do do every T usec, this
works fine. But if it's an event loop that wants to process completions
to make progress, it's pointless to return after T usec if there's
nothing to do. The application can't really make T bigger reliably, as
this may be the target it has to meet at busier times of the day.

This patchset adds support for min timeout waiting, which adds a third
parameter to how waits are done. The N and T timeout remain, but we add
a min_timeout option, M. The batch is now defined by N and M. The
application can now say "give me N requests in M usec, but if none have
arrived, just sleep until T has passed". This allows for using a sane
N+M, while avoid waking and returning all the time if nothing happens.

The semantics are as follows:

- If M expires and no events are available, keep waiting until T has
  expired. This is identical to using N+T without setting M at all,
  except if an event arrives after M has expired, we return immediately.

- If M expires and events are available, return those even if it's
  less than N.

- If N events arrive before M expires, return those events. This is
  identical to T == M, and M not being set.

There's a liburing branch with test cases here:

https://git.kernel.dk/cgit/liburing/log/?h=min-wait

and the patches are on top of the current for-6.9/io_uring branch. They
can also be viewed here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-min-wait

 include/uapi/linux/io_uring.h |   3 +-
 io_uring/io_uring.c           | 155 ++++++++++++++++++++++++++++------
 io_uring/io_uring.h           |   4 +
 3 files changed, 133 insertions(+), 29 deletions(-)

-- 
Jens Axboe


