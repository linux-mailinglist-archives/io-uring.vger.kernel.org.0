Return-Path: <io-uring+bounces-1181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D10E885B24
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 15:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32636284D85
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 14:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C1584FBE;
	Thu, 21 Mar 2024 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vm2CGJbF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09741E534
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711032519; cv=none; b=ttbyJqzq/wAexBFaiPoLWe5WKpiMsEUonEuUDTR7X+dkzt8oGqvMbYAzGWaojiDpYSebdEZarKNKiIqONtQJ8eYlmMj0B4kQvH6x7lk0cvn8X+hnifD2M9IDvJBaR+CXvT15fG9/GXrcObk1g/V/5Kj4gRqeOiORDd02l43K74Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711032519; c=relaxed/simple;
	bh=X080L+osf6qdAVps3tPiD+s2ytyW+fr7fuM6du6dPjU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LOnyLUl3+3aEDGy00iCyZZwezz1IeglAOYWBT2e7oAGUYdQgw0E8C6GLhnt62E+fPwfTk1o33IzkDBg8haD/tQEoZL9+1P02iCbp0SndsX+K65FfMNc9v6KT0JCL5MJyWE3PXmuO27m0WrqguB0N7AVWxLpXp6Wf9Glo+LYByf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vm2CGJbF; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7c86e6f649aso7018739f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 07:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711032514; x=1711637314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=yFS86vgVEV+hU7s5O+NaPMpakfcqr2bZCllPVSfKWNE=;
        b=Vm2CGJbFBzBNQfhoFOB6sG/i9I/Zvf+GEH3ouh0FiDNK/okvgMx/3y2xjt1SmdklCF
         vRvMRm3W0CV1TDU860UhTnA/3zOMyp2K50LodOpDywhZlzDHt2/aRWzHBmYorCJgP+EU
         SOLYKqsCMqVd1ahzuigWC8eR/cPpuWD4hDyiiIA8pmFRT58aT6ym9TIscoiVFbRg0aEE
         Drjobtr/vCHjg+K6RMnnhdWx1E0NQO+oo1iNrMyFpvDZbzErLCOXFmQefjD/YA2xDAS3
         ExgrqoPACjQxSUj2uvgfpfRqaKCFiTOl0FqNAw7wntTST/b2mGlcZl+SLH+F46kiUWVK
         Tb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711032514; x=1711637314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yFS86vgVEV+hU7s5O+NaPMpakfcqr2bZCllPVSfKWNE=;
        b=Uz2cRwwDxzHErVKvXRRrDqHkv1Mv1Z1V8xnoHLMOX4p533Ck7vavd23H+fp0en1ENl
         nnDtlm4h3TjmXzqdCO9ekPO40XWdq0dI0uPfCt/KjkIiA4PueW4BdHGxMwD5AY0HXhNz
         zKZ98MD3wDfrrHuqhGAgtNwWVld44XOeNu0/lZd3C65aW0Ohj0t7z7a1nIJ5Bqt3RNv6
         lvY4WCUOCllgpkzxObHEnPiryXEiPfpbLx8yOOLVlT6TaTSkRqVQaou1zxSU6Gb94eV4
         On2mk4Eu+fhmaevImr72nVV1CdV7oNmOwoO0J5TovSM3asU+mBNTWM7ByGg7FEhDMjhi
         APFw==
X-Gm-Message-State: AOJu0Yz8xN5zW5lCw5oszQw0qcwXTTMkA5Mu71eO2PP0pMYGQzdYPuEd
	TteFpdf/FVo75PNpqSox2epUxrurdZwW05YyKSNk3FMmidQhtCJODikN5vA/1qoYreAkNIsvNOU
	V
X-Google-Smtp-Source: AGHT+IFZ6gZttEGwDqjXmVe4XKEApxYUWwQaXCZdLDOK/eZK3i9mt2BMb4QNtggZ2/gm0478Eb7usg==
X-Received: by 2002:a5d:9b87:0:b0:7cf:272f:a3af with SMTP id r7-20020a5d9b87000000b007cf272fa3afmr3125549iom.2.1711032514444;
        Thu, 21 Mar 2024 07:48:34 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0047bed9ff286sm250835jao.31.2024.03.21.07.48.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 07:48:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/6] Switch kbuf mappings to vm_insert_pages()
Date: Thu, 21 Mar 2024 08:44:55 -0600
Message-ID: <20240321144831.58602-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series cleans up kbuf management a bit.

First two patches get rid of our array of buffer_lists, as in my testing
there's no discernable difference between the xarray lookup and our
array. This also then gets rid of any difference between lower and higher
buffer group IDs, which is nice.

Patch 3 starts using vmap for the non-mmap case for provided buffer
rings, which means we can clean up the buffer indexing in
io_ring_buffer_select() as well as there's now no difference between
how we handle mmap vs gup versionf of buffer lists.

Patches 4 and 5 are prep patches for patch 6, which switches the mmap
buffer_list variant away from remap_pfn_range() and uses
vm_insert_pages() instead.

This is how it should've been done initially, and as per the diffstat,
it's a nice reduction in code as well.

 include/linux/io_uring_types.h |   4 -
 io_uring/io_uring.c            |  32 ++---
 io_uring/io_uring.h            |   3 -
 io_uring/kbuf.c                | 298 ++++++++++++++---------------------------
 io_uring/kbuf.h                |   8 +-
 mm/nommu.c                     |   7 +
 6 files changed, 119 insertions(+), 233 deletions(-)

-- 
Jens Axboe


