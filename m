Return-Path: <io-uring+bounces-2799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE819551F4
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F6BA1C20CCC
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092111C3787;
	Fri, 16 Aug 2024 20:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bkfd+iNF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3289676F17
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 20:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841052; cv=none; b=toFtV5/1U6t77lMC5OpY+vIlIglKyEHbTvGg9uABRnZezgEIxEjIHBHRpda6n6ok4qsXt8wHzBrZzBB+XMf+9/o8Mlu4UdUypXRoPC2E4vaBlEqfmPdx82uUwvNYHAck5JO+Yd/eojc4uJK7bs5SOOmqxeXhyJHxV+zMtEEGiEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841052; c=relaxed/simple;
	bh=Tzy5AxUPmXR6I+c2QC9zQa9DkKWjcPzz0DFY9aFyfFw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dZt5MGy+XWXJ2ufjuPs7tFKEffaxy10YsdkHnvrig9tBAmKqM7/Ynp1/BEK12fqz/zjuskjmLaopQdCwPw0wUCzwTmuOmVTIiD9WvAGMO1pLIkk1BeafghVi0+YhQ3MWlgwcIeaXdlzcITj43ABAqVnN+6AORKXpNdiNfXz4MTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bkfd+iNF; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-78f86e56b4cso285154a12.3
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 13:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723841049; x=1724445849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ihF/Xw7p8kwr/Q607E/lQnUmy8wtLYkTpaAmAIi26ig=;
        b=Bkfd+iNFGb6fLvZnopwZTR6ll/awzcvD7r12rpCLJZ9lA1yFihTcLCh9oeniLPJMLq
         zygTxpufsXbsSFkBgU61dY0UihunepBynSjN3J1AF9sbeFgSc6NJegLu86gsjxU23Nzo
         zLyfxenu273iQCzxQLP7hCUoC72awu4DMi+AY6O/zixnUooRFX/slMZlNlH68zpMtXGc
         tp2k4f6j+QEGAoC1L38nvkt6HbdXoeVE/OdEXnkTamxH+CwiTPeTGOXQ/9ZaPidYkHNc
         9UDOtyHj2XyUHeQzLivlgL89LQfvPrxwPNzOIVUXxCyczFTHCvnrdjZbX7R838nXqIrp
         YYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841049; x=1724445849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ihF/Xw7p8kwr/Q607E/lQnUmy8wtLYkTpaAmAIi26ig=;
        b=F8r4UhsuCNOX7joY7NxQExz3jINA4aoPC7garUGupTORDBehsRIJ41s7gZDBymiyga
         VZ/pFa4lujHS1Qhj4FIF10zzl0GyF6jmsi3r14rhj2tlsR95QNe0UawY4z+OWcpLhF8I
         c2+wajtpsX3KjSMp+lKARbV9uxGuwCge3aYlDVdHMk16rqN8pJjZyUFK287+KAyeH7s3
         pkCoqTJSMAEswCLtnL8vlXTD4rdes45ctKjZVsLBUXYnF9pGS1wpJnPI5TyM8bUJaK/q
         zveuTjvz0c2ZWYe0dRU+df2tMQkppwh2qc2OT3zdr85PWXd/HS8FcUyTXGgHXk5gT4l6
         Gkxw==
X-Gm-Message-State: AOJu0YzUT47eMtsu78gN1PFZqTH4L78WnagW2shwwnULx/5pO9InCd9l
	ESQmFwn8g7K1Xv1ED0fKiKpcEN9q/AoZhf6z+CfsKEybltMCv9PhkJlC1mMOIPgL4+zKXOXcBKR
	y
X-Google-Smtp-Source: AGHT+IGejSeeyTMKx+3rCBQs4HgzCtgScggt1H2pG33N1IY19aTwyWdqTWltCHJMeNam+obpfhrsgQ==
X-Received: by 2002:a17:902:ce86:b0:202:156:c4b7 with SMTP id d9443c01a7336-2020404acb4mr28253255ad.7.1723841048829;
        Fri, 16 Aug 2024 13:44:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038a3d7sm29190995ad.186.2024.08.16.13.44.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 13:44:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/5] Add support for batched min timeout
Date: Fri, 16 Aug 2024 14:38:11 -0600
Message-ID: <20240816204302.85938-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

After somewhat of a lengthy delay from v2, here's v3 of this patchset.
We've now validated this actually makes sense and helps for production
workloads where there's a big gap between the peak and slow hours in
terms of load. Having a min time enables the same settings to be used
for peak hours (guaranteeing minimum response time), while avoiding
excessive context switches during lulls.

For a full description, see the v2 posting:

https://lore.kernel.org/io-uring/20240215161002.3044270-1-axboe@kernel.dk/

As before, there's a liburing branch with added test cases, it can be
found here:

https://git.kernel.dk/cgit/liburing/log/?h=min-wait

The patches are on top of for-6.12/io_uring, and with David Wei's
new iowait feat and enter flag added to avoid conflicts with that.

Changes since v2:
- Rebase on current 6.12 tree, which was mostly centered around Pavel's
  rework of the timeout handling and ABS_TIME additions
- Since there's now one more argument for io_cqring_wait(), wrap those
  output arguments in a struct ext_arg.

 include/uapi/linux/io_uring.h |   3 +-
 io_uring/io_uring.c           | 187 +++++++++++++++++++++++++---------
 io_uring/io_uring.h           |   4 +
 3 files changed, 147 insertions(+), 47 deletions(-)

-- 
Jens Axboe


