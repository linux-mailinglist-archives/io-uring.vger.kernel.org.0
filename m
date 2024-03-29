Return-Path: <io-uring+bounces-1332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 037038924F7
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 21:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81C15B231D2
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 20:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEF313B596;
	Fri, 29 Mar 2024 20:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tTmi2XJU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D3513AA3C
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 20:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711743168; cv=none; b=GGyRjL+SFe+7UolB/YZVH+2Y889rU81E036aCY6ZxTwLNl8xHXjAZqDKJKzNpFNJfHv52v1d9gt/IxfLb+wnAml5I/K7a4b8yE0Th7e1vVHmFK1iXnsohaMs97IHHngpX9RIO47bij0HnNKhhbuKW0g7novgLQpthfSJOWmGtO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711743168; c=relaxed/simple;
	bh=kv+g5MQuy7su6KE+7OThkyhMjrORU4Wt7X4kzlL5VKU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dxhwZT8AQk0UXm14juWAQxQElBOWSHRTW8PsC9vufnye/JoTXmcLFsJ/QAv7pdPFi1Ul3xrjhA+QFasUoX+NkflW15aAPQ7QIA+SQqQhf5kU6T6P9ck5xbOFOoaz1y9hl0G85gLoFVMZeTdqm54q384fkNlWF4UK0pFv1aL6lOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tTmi2XJU; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ea729f2e38so419891b3a.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 13:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711743164; x=1712347964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+h+WTEzwg1VElvX+uiS1Bz+uysimIWk4DUQqtbkEY8=;
        b=tTmi2XJUOMvp2g+QQqxKlCz05N0VO1SgM54czD23L/lDUYXBunAPnwZg8XcaAu7IeZ
         dMIKw206ccPq+XNoMZSMN6y2tuqeF3YGjZ7cO5/QNBkj10RPLFcVezzHyr2CZ4z/8wO3
         NrL5GAWBb6ToqRFnFOTBPxcWneaa2lp8If+9S21rdmEnKje9PmMLFg0NVs5FTPW9+rBI
         2wGBILl09Qxz1kFP8cQ+gKVbnzQu51OzocCxjdqLJmg67YEUezY1zGekHYtmx2KVu98x
         uSEElCTGS0xyrEVpaOJ/GG+ASA+vTzR4ytak7who76Rgnxoy15ybSdObfjYWNiTqEVN4
         7Btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711743164; x=1712347964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+h+WTEzwg1VElvX+uiS1Bz+uysimIWk4DUQqtbkEY8=;
        b=JW7K3zWxA9oQjWFY1rC8lq+6bJ/Gv3NQ1PAjbiSyxvVqLxjGjsAlLUvc3OH/Ctk7Lp
         7l5d8xihxq9GRtfqmKigBjNK7wI+HxmHPTh3oYjlRwJxH7MUT82wJEyCXAgcghPeAukW
         Uijt4LaTaqQ/ixi7CiL8uXtA5BPtmOC4Ca3HSZbTW3AOWdFkYzYkqwdcpGzdlDxeDfU0
         0WG4/YB/IfcH21M1wsN5T+ZBRCMzr4e+2toSA0bBfQQtQyxk7CA5nDnbV9Wrw24WZPu3
         xhi0BuHOCU+IQcu2e7Az/lNYC0cJxVnY+Iys71ci3eg+2n1Tdmhb717XGnCU6aHh1HDx
         witQ==
X-Gm-Message-State: AOJu0YxJ2g4LPjuAQ5DGlYUptmEu1DbTCacvmpEStAqcZn8BC2E+h/Q2
	5LHDBznI42+p0ynukZW0YgkWE9+rzPXWWwXKNJVZh87cPlOQnmDbiDILQrmuEHdq4cwUeMNtboW
	p
X-Google-Smtp-Source: AGHT+IHav+vDXUgZ4aacErxSwP8qjU4AD43m+vExJylLl8uqdBWVy9CXrEmOQjmJ+bUJJ3MkFVz+VA==
X-Received: by 2002:a05:6a00:23cb:b0:6ea:b9a1:63c6 with SMTP id g11-20020a056a0023cb00b006eab9a163c6mr3801841pfc.1.1711743163611;
        Fri, 29 Mar 2024 13:12:43 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:40c6])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7810b000000b006ea90941b22sm3388728pfi.40.2024.03.29.13.12.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:12:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] Cleanup and improve MSG_RING performance
Date: Fri, 29 Mar 2024 14:09:27 -0600
Message-ID: <20240329201241.874888-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

MSG_RING rolls its own task_work handling, which there's really no need
for. Rather, it should use the generic io_uring infrastructure for this.

Add a helper for remote execution, and switch over MSG_RING to use it.
This both cleans up the code, and improves performance of this opcode
considerably.

Changes since v1:
- Only pass in ctx, not both ctx and task (Pavel)
- Fix io_req_task_work_add_remote() not using passed in 'ctx' for
  flags check
- Get rid of unneeded references on the io_kiocb

 io_uring/io_uring.c | 30 ++++++++++++++++++++++--------
 io_uring/io_uring.h |  2 ++
 io_uring/msg_ring.c | 34 ++++++++++------------------------
 3 files changed, 34 insertions(+), 32 deletions(-)

-- 
Jens Axboe


