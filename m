Return-Path: <io-uring+bounces-186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3D4800064
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 01:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B1E21C20A3E
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 00:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5189263A;
	Fri,  1 Dec 2023 00:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pnn9FklW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B00D10F9
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 16:40:47 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-54c1cd8d239so1114885a12.0
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 16:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701391245; x=1701996045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ggEDdR7iUi99X4ofZr2Z499rH+j+tt5f49AUxEa0194=;
        b=Pnn9FklWDg6GIi4J50aOMbB82XuSFOc16j9MHcqlRwgiET9F3RM4s+kNYRKPYYvuKx
         k4cDu3SX/I8C9BWhSKPIxcetSwM8Hn/0IN0MIiVp+Y8z5gPmSVQF0g+dwUEuka8Z6X7/
         a4Z+Nv7P39YrNbEPiM4m/vz9S0MvUwRu0vC6inqh5k8SgcOR3r7KBj77EnN186vKo6v3
         fKJkLZP5S4cQ56cJNFr/wX+FYDWlWuCLIKxBDfFnII983ufOB8ZjFsqcJ+M8XHD2NSp0
         hnEq0PzVc3zuBJyyzJVlJVwxL6Ab3oKuZNWCehtke5u9A1/Uwtb028/ISgHYK2ml1KCJ
         TD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701391245; x=1701996045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ggEDdR7iUi99X4ofZr2Z499rH+j+tt5f49AUxEa0194=;
        b=jEGhyhEA3Dgh3lLQaoAA0fFYuDd9abeNPFJGK1Z8dn6IkRUr/jm7H5C23frWaOV6nG
         mRrVEOMfra/1H37XtT1JnmEE6ASzWcXiCZ6DVJRAq92MrJSu3Wr7DuqOlQoBD9ew++vE
         XA5qxG8FXv25GzfKeFK5rgD1H58jtdNhamUabUtyzziJH6u4sd8nApSC6tur5gFwPScM
         dX20o+WmegqVoq4ykVLrpteSM2seJ22j6Ij9brXpI06374vdaCXEKTxB4k9btvoZ1W/C
         Am61d/yTIFZhfB8P+vPeAWx5Vs++w4Mk7puzidm5Th+285VoAFSFfkt4pBHZ21ShgXc1
         oOIA==
X-Gm-Message-State: AOJu0YzV2Y9N8SqewZqfNwSPOCWjmxHdLu2LoBh4oWAB7StfvEqFDvrs
	caE0WFxaDzptzHBLra4FnNokqoIZTCY=
X-Google-Smtp-Source: AGHT+IFFPgtAJeLZB+MNtO9GHyP7p/v7nDiiW9PoLNe5dicB60nhfl0ogjgFuMJQ0q2aNI5JHmS1Pg==
X-Received: by 2002:a50:c30a:0:b0:54c:4837:9fd7 with SMTP id a10-20020a50c30a000000b0054c48379fd7mr159294edb.46.1701391244993;
        Thu, 30 Nov 2023 16:40:44 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.191])
        by smtp.gmail.com with ESMTPSA id ca25-20020aa7cd79000000b005489e55d95esm1059139edb.22.2023.11.30.16.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 16:40:44 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 0/2] inline execution ltimeout optimisation
Date: Fri,  1 Dec 2023 00:38:51 +0000
Message-ID: <cover.1701390926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patches are not related but put touch adjacent lines. First we improve
a little bit on post issue iopoll checks, and then return back a long
lost linked timeout optimisation.

Pavel Begunkov (2):
  io_uring: don't check iopoll if request completes
  io_uring: optimise ltimeout for inline execution

 io_uring/io_uring.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

-- 
2.43.0


