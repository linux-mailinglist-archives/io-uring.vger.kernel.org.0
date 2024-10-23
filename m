Return-Path: <io-uring+bounces-3950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 332F69ACFE3
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8CBE282483
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF941B85E2;
	Wed, 23 Oct 2024 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JVFj7AUa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1751C68A6
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700130; cv=none; b=qYKZkDVJqgEYO9x9r0Caokm4J5dt4KONuDygAwqlvlvUkCClrJGYe311NvICriwOg2eBmlUGsn2RkKvApSp2jdn7C5fK6WhGBDclSJNabJncz17vYDQSW5gcDQQeivtqptBW1ETgiWFTWQhR7Q9Rhx65FFLIH2vWsfyH/HBFdIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700130; c=relaxed/simple;
	bh=M7SIcfDSyze4gwAdde70S8EOV9SE1b+gGU1eYTuhqZU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=o6Q8EJL05SvdVECgGR/tOZMpmAf3ubN3X32RoXVJGQaow9KSliYuZTLOoJcgdojs6rIt/CV/gwkmMoJGWGMdR8HV6U15D75JgB7JKfCGrUWkOQZk9w5U4UAoxYNFqAelwRfGrUiRJEuCCztrRoBmGQDsAhJRXjGo2OGFOLZfbNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JVFj7AUa; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83ab21c26f1so278790439f.2
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700126; x=1730304926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=x8smg83XLh9aJy1Z4rj85Wiq4m8A4X+l1Zha13Oh+xc=;
        b=JVFj7AUaEZiz1Mj2YnLWI6oO1lJyKdT+FOW1AX494Ql6Cte8K1dPSNc+UyAbylB9gB
         nki4ORMTL0DsRfXLEpeXdM0DYOydRwIuKJB50rKLnA853zj9eVEQuPjwYjN9+qaysKBh
         XIbva5CTuyx9+Qp1TGgVSC0CX3FEb/F5/tx2wWNENYBsmxSoqkwkcAHCOg8KKNVAa0ie
         LdMW1Q+vB4zBLHRW98kMQsbHFJjEpY6h/hxkNeUnZ2n2WAZt2QLKj00XHPXgq4pssiuH
         iECx6TgnCGEJXgHHsLdwjX01FAHTNO+26Pjy+WAKRzc6tfbvCzhAKrdv83p1Ee7aQJCJ
         MuDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700126; x=1730304926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x8smg83XLh9aJy1Z4rj85Wiq4m8A4X+l1Zha13Oh+xc=;
        b=nFbUsxb+D7eRVLgeLjERr7H1INbJ2lk6vdxefufLmb1L9kQBCsg5XNuGT+M0iWQABQ
         ogDDO1mc1tY3uPJKQhEehCRqkSujgiaTOoM/i1Y6nAE6VmyJj0MVMRvnVjb7oGsxIDTM
         +OMH30+ojFWm6jwYEAKhq34LsW94xkglpOPwAVwhrkKapBAKhuHDaCo7xns3C5D7d28F
         2Pj9uPIbJdWNOgBIlIG+nbb4cg+DmFqeNSjne6Ww67Q9TkOh3X2GMpplS4EtQI5oV+ov
         2eeT+nB1f/RmOAzd8u7FRDehgVJqP+tpfy8pSwfOf3Y6wNyR+sYFyb3rQL0gXtoIUNbN
         ioyw==
X-Gm-Message-State: AOJu0Yz79NJrvkRjmmmEbN/r7seH4+j+LJf+QfWMY7Niq+L9Ndj2L8+e
	NNgmk+OvxFvSsF7MJeNe8oxitidMV0blcn1Ub/m9Cyoh3XXsrdRI2ftC9hqajwWi3NYE9YHgLxx
	b
X-Google-Smtp-Source: AGHT+IFqJdHsIeJS2MoNAgTUicumivuXAvhTKG5BUt9AaD+Ws6Y1E1pDWsnbJD4A8osLzB9vbGRk8A==
X-Received: by 2002:a05:6602:2dc3:b0:83a:b98e:9240 with SMTP id ca18e2360f4ac-83af63f61e1mr380968639f.10.1729700125543;
        Wed, 23 Oct 2024 09:15:25 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/7] Add support for provided registered buffers
Date: Wed, 23 Oct 2024 10:07:33 -0600
Message-ID: <20241023161522.1126423-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Normally a request can take a provided buffer, which means "pick a
buffer from group X and do IO to/from it", or it can use a registered
buffer, which means "use the buffer at index Y and do IO to/from it".
For things like O_DIRECT and network zero copy, registered buffers can
be used to speedup the operation, as they avoid repeated
get_user_pages() and page referencing calls for each IO operation.

Normal (non zero copy) send supports bundles, which is a way to pick
multiple provided buffers at once and send them. send zero copy only
supports registered buffers, and hence can only send a single buffer
at the time.

This patchset adds support for using a mix of provided and registered
buffers, where the provided buffers merely provide an index into which
registered buffers to use. This enables using provided buffers for
send zc in general, but also bundles where multiple buffers are picked.
This is done by changing how the provided buffers are intepreted.
Normally a provided buffer has an address, length, and buffer ID
associated with it. The address tells the kernel where the IO should
occur. If both fixed and provided buffers are asked for, the provided
buffer address field is instead an encoding of the registered buffer
index and the offset within that buffer. With that in place, using a
combination of the two can work.

Patches 1-4 are just cleanup and prep, patch 5 adds the basic
definition of what a fixed provided buffer looks like, patch 6 adds
support for kbuf to map into a bvec directly, and finally patch 7
adds support for send zero copy to use this mechanism.

More details available in the actual patches. Tested with kperf using
zero copy RX and TX, easily reaching 100G speeds with a single thread
doing 4k sends and receives.

Kernel tree here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-sendzc-provided

 include/uapi/linux/io_uring.h |   8 ++
 io_uring/kbuf.c               | 180 +++++++++++++++++++++++++++----
 io_uring/kbuf.h               |   9 +-
 io_uring/net.c                | 192 ++++++++++++++++++++++------------
 io_uring/net.h                |  10 +-
 io_uring/opdef.c              |   1 +
 6 files changed, 309 insertions(+), 91 deletions(-)

-- 
Jens Axboe


