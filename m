Return-Path: <io-uring+bounces-7165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C89A6C211
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87203464BAF
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 18:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC30C22B8D7;
	Fri, 21 Mar 2025 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lO+RZUuy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBC78F5B
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580226; cv=none; b=jJQ2GMf6q9P4UZ+64YwBwnxs1NBy7rdRY9fWTPcXQ05XtnmEBn+vJytCbvGvPCis2Iy7ZvgJXGNMIv+Q6YeAwiVR7/jq9EcWG3hbpmQryKyTtccW852VjKS0w6ambtHOL8upV9OsW7hnGKIrAj78pL0a4JZAkF+6wLBYOrVlgPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580226; c=relaxed/simple;
	bh=C2Ovl/ql9v52vTluBwm7mzhfy5adAruZ1YvCzz/rizI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XUSRMIPprLwehKCYiBdyBqKExVc6lJzfdVbzZepnk22RU2pYXc48Zkx5ku0oecj4wj0YkudwbX2bXvQyUnDUfaamPm1VJX5oGYuBUDGMNIT9qlJt7P/uijmoEelQyD6oX7j9Aw4ZKX5HxgaMKgTFQTrCOLUvKc5AXPfwnUTrBLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lO+RZUuy; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abbb12bea54so166272566b.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 11:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742580223; x=1743185023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ihZzH21oCqcApq+l0ox4pVhNkKTYm6orKVZ/tzPoNp8=;
        b=lO+RZUuyn0eMAK2M1NnloJFA0YcPBrDpdvB6kMzuVsXZ5THxUyCPW8JYbqqLbF+uWs
         BdPb/A0yGk66IJpe3GS7xAyneRyGFslfifFDPtr5PwnWYpPYdNohjYN7u+/SzlHgy3Vu
         UiouYQbrtNm8T1GZKEm6a8bPtsZrpoYA/zpBHPpO6bR7+6Jb6YfsNRXl3wzxGJeHZMyV
         1MzBN27a9LuiaTypu5hpZyI7RNlX+ENL+dhdlZ/DNBihaDsO4HBjAzQawTMdl/7KoPni
         3f7zA5lUcD2iSz8Rbw50QjCx5d5/qo1GKYplonOn98hfCtCbtjF1ljt9lP/lbuh2PwYE
         aBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580223; x=1743185023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihZzH21oCqcApq+l0ox4pVhNkKTYm6orKVZ/tzPoNp8=;
        b=d0A/8X+91jWFfLdc4gU5pydN+USpBDQi3BceBNEhda7ucOwAXcKIaRBjHVCR8AwsXn
         UMn84ku0yYbPLIzVVNEJhM973hz05cx0HyWnAj1xB9lUR6MYyXSrExcJKVwN9VdrZAHe
         KpSO+c/XIR3YsB/wKsNxiujMY+/pnIkb1Mktx8QrdfYH0taezkRVrc3a+cYHzl7Tv9Z5
         44//TJVz/qtiuxt766PJ1tJFUsKudPhZ9/RyOlXdUAJ3BfuJnZPlqHq7jwThbKRpoYFk
         qmk7B2GlDZUKuLDt9MjIfITAHpE0D47a5CspDs2yCDRV2dSpeszSIQghRusf4UIHnKcW
         xSAA==
X-Gm-Message-State: AOJu0YwiqdsZdIBhaxXTyIC/jD/XB6D5GrBxdp4Bwyj2O8b8+q48Pg0o
	1buxuf8EWVhc3HtOlqmyz1FPmkCmDPEDb3UTWZbs2gi1XdBMuzxrhHcoIw==
X-Gm-Gg: ASbGnctjXM9a/yWTEWi3Uo69EYPWn5+KYYF3f9TdtOvi+eiU4SJMNDMCvotDR89xHrg
	OJMCwn3fdAuaMx1+pnd2GJeiSggDTe4cywtfi9TCJS6xjClbBKBvq1Ob1moX3LTuBuSWxyYMlw1
	MwQPiC2TIigRViISH4IBDdzlELNPd6J/RXl1EqxMDWIT35woEY1lsgoMGgJ/+IQPKXi7K7VnWmZ
	mTkGHJYkUsgDwL5qElgT9LKq6+zmttq4DXJUuSabOLToQz60nPrWeriR47+mvU6Lj574QW9IBgh
	PJVN1ZB1mfg/jkn3z0diFIilxhBebxMf311hB1E+cVfNb2Iz1FQiPgnJVA==
X-Google-Smtp-Source: AGHT+IFNhIxIYJ0gKLtEz7qqzTSXNjlNoTedjD3ki8uYtzuS/MRazjLrrGnfVHmQDmLGhQULQ+IucQ==
X-Received: by 2002:a17:907:94d0:b0:ac2:dcb9:d2d4 with SMTP id a640c23a62f3a-ac3f2116cfdmr437020866b.14.1742580222583;
        Fri, 21 Mar 2025 11:03:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8d3d2dsm191646266b.60.2025.03.21.11.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 11:03:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 0/2] cmd infra for caching iovec/bvec
Date: Fri, 21 Mar 2025 18:04:32 +0000
Message-ID: <cover.1742579999.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add infrastructure that is going to be used by commands for importing
vectored registered buffers. It can also be reused later for iovec
caching.

v2: clear the vec on first ->async_data allocation
    fix a memory leak

Pavel Begunkov (2):
  io_uring/cmd: add iovec cache for commands
  io_uring/cmd: introduce io_uring_cmd_import_fixed_vec

 include/linux/io_uring/cmd.h | 13 ++++++++++++
 io_uring/io_uring.c          |  5 +++--
 io_uring/opdef.c             |  1 +
 io_uring/uring_cmd.c         | 39 +++++++++++++++++++++++++++++++++++-
 io_uring/uring_cmd.h         | 11 ++++++++++
 5 files changed, 66 insertions(+), 3 deletions(-)

-- 
2.48.1


