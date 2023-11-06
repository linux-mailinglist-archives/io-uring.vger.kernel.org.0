Return-Path: <io-uring+bounces-31-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 475207E27A1
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86A7DB20C83
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 14:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3EF28DB1;
	Mon,  6 Nov 2023 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K5KZ1d4P"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6C428DAD
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 14:50:09 +0000 (UTC)
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058C9112
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 06:50:08 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-35904093540so6142875ab.1
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 06:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699282207; x=1699887007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GMW4W7juQ5BCKOpgveSeRJzDG2envXble1OCghV6dRE=;
        b=K5KZ1d4PtTHrYTNwEL8A5+xO4q7Hkr09J/ltZUan1rBnoD5rne1dX8qAmBZwoFzpe4
         Bo1iOXqCBEbbPSSyfoAJW2O+DSbKPdwHB6p2WokfpDnaPed+6fUQ5H2nEaPHWqpirJce
         Eq1sd+YiBZNIP3Ceo8jnogbkCSitfBPE0KS8w4r4iLMNafVKd5P6eUNfxrllPgr5s8KF
         tbKq3XN3gB8d5qKFQ0eciZQsVh/j79FarwW5er7mX4JK390A7uJM7nEu2ZXINsdzQWmT
         9JyBeWfNRdYMfm40Up902zNLsNg69055WkgjSp/dxFcG/NW6KwvdMBrucZLJvdwY3TOM
         x/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699282207; x=1699887007;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GMW4W7juQ5BCKOpgveSeRJzDG2envXble1OCghV6dRE=;
        b=XS3ZEtjIRNFUfPJLreelfhOHZ5jvRa6rMnOnEaDnb3t7TpbJ6R8hZF8JHRYeNx9sTN
         BD58OtUI0ZDwVm/djW98fUyCKldOkb7eDkzpU3PRFXqHyZEw6WURlOEHIk8JQCWH45P6
         VK1yDdHOzGz3kBwIoxqz+rib8oMD5ijhLGKqqPSPguqXS1Eyp2bBuUE5G9/fuPBF0ShS
         /jhe8UEut9n4c9mDmgjJ4Avm3ZWxFQTLZllNkGIs5UVY3ZRFOEN9Jov/0VHSlyP4ZzAF
         PJATUsJlubzKWee3gjsOGwgiZojrTV8sUCpBSSYI0PkwhFJZRihCunw8S4V3BgLot7aw
         onCQ==
X-Gm-Message-State: AOJu0YzuynP9nR7CKWlzs9P67u03jnha4iAQ41xY32LhRajpYQehtZKy
	JQBY45276OoHUinJRDFzSDqfUdp1qIYXp5PrA4dBbw==
X-Google-Smtp-Source: AGHT+IECvJMElX+laNZFYipQSK3KRKeK3oeN5OIkKlFYvqkVw1G9qyMS/WNJLnJIblj2kwUD7Cy/VA==
X-Received: by 2002:a05:6602:1c6:b0:79f:8cd3:fd0e with SMTP id w6-20020a05660201c600b0079f8cd3fd0emr27464711iot.1.1699282206976;
        Mon, 06 Nov 2023 06:50:06 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t2-20020a6b0902000000b0079fdbe2be51sm2378375ioi.2.2023.11.06.06.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 06:50:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dyudaken@gmail.com
Subject: [PATCHSET 0/2] Cleanup read/write prep handling
Date: Mon,  6 Nov 2023 07:47:48 -0700
Message-ID: <20231106144844.71910-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Rather than have opcode checking in the generic read/write prep handler,
add separate prep handlers for the opcodes that need special attention.

No functional changes intended in these patches, just a cleanup to make
it easier to read/follow.

-- 
Jens Axboe



