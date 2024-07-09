Return-Path: <io-uring+bounces-2472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2815592BCDC
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 16:27:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6C70281CD8
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 14:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F6B18F2CA;
	Tue,  9 Jul 2024 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hn9XRD3Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C672A28E3;
	Tue,  9 Jul 2024 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720535239; cv=none; b=ulzCXJB9/ro7cL8NaifrV+anrWN9pDULCVjk2U6Yy1nEGk4q3gNx1IMqGr26sbEILknCNqzDZXzegLjX3ijX1Pipj4h3xko5Y3ebmQOa4Hrtz32DRxjfae5k51gcpy4ZjEAmG/iS6lwdTariwUfDJND2NzADimwT/H9wLS/N9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720535239; c=relaxed/simple;
	bh=bHNv1krS9O5CIeSOoJnUpX6Ug1/E9aV2zd53v+b/avU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N+Nm6Jvo8Ix7J4yOuIQZlfjcQmaGjLSeCu1ZN6nKmruPNWfv18LYNk6eL+Ir3WPc9AAET8PuvNhKWzBLzy6oooutpVtBmTivnm62FRXeeaC6URvRpED95KvsVTFJcJ3V0ZGDni7uqcmiteaOuf90sQ1EgPNGYooM73pYR+2zKlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hn9XRD3Z; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77cc73d35fso674195766b.0;
        Tue, 09 Jul 2024 07:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720535235; x=1721140035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9QclN47byu9Xsdx9H2EcxAZbTcZCWWyzPecO9Rq5PJc=;
        b=Hn9XRD3Z2VSIHymu2qSDXAmEP6OJYU03NdEuFf/tNJai/bVY8ROb2Y4Zr1JzQtCsWs
         Fi63Cvha1tWSRQz691wMdRfOSyTmCpGt32zgJ0EED2ppcwWrqSjoJzMnK81/mqTr5e1R
         E1t89RMp8ZIlBFq1Cv4VvKLoVoXdSgGXHzf2M0vbJfhqDXf+mi5glRpjQknIL23DPiyh
         DfBRw+lkyuEsZibx9ZuCDGrmQGodz3eXfCbuiI4K5CpxULwAHa9vtpPEJ3xJ+xO4sj2c
         7wVxNLiRYxqgazhlBoEvk6fTFQ/Li56v2vBFA01O0+gBdP0vrAjXw2bPmcnVyZStSSxx
         KtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720535235; x=1721140035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QclN47byu9Xsdx9H2EcxAZbTcZCWWyzPecO9Rq5PJc=;
        b=aa/VaJkAHWFQi7XXi8imDKknAxstTL47PjJqPyT3sVLsOxrMVctMRWncKPykcnuc/n
         t/oh80fb8nJlK2fsqS8Evxjq23K7v9cTlh704iZwrGAYyehxeLvUIeqDpX5i+RbgRxs5
         1sQYidi80d+zdpXF1/5d0C9E3HKM/eryhsyPtTm148Szc5hz6qs1pCIcxy9vsQibbXww
         AitYa2TyGMqPQku84xEBg50cmwhLqEyXEAHSDj6VBP65gjnW5aJv3qts4mjpkAwQnmv3
         Y58MnHYdkMZ7vms9KrPkdzXJ8crIQJZZpCFOY7Gq9GNECBl2Vf6pLd0XRSie3fSMMoOB
         lUxg==
X-Forwarded-Encrypted: i=1; AJvYcCVQ7hN3wG7pC/wPkYNuSLiofAWDBJy9BjyyEmojw7oVpCTKx8ijduTWN1zMLexdll6cC2HHGiPTtrN4mn6ZHvlScfZJrUYnyIhOZO94
X-Gm-Message-State: AOJu0Yw7wKxZdUf8qTtBkdCQ//kmf1ix2GAhDgd5a2Lh+dlNiRfYxAaI
	Uij6W69HMwb9R9jd60eQav789H0Q+hCBgxHZhkPBkxoZdO3ILITDysW6dw==
X-Google-Smtp-Source: AGHT+IH1y3e4HfEfqP5LJUiu4bOdu+aOc2qNqQ3met9dnj/nm8W4IDL/dWaG26JTKatlGgZw6e2FCw==
X-Received: by 2002:a17:906:f74e:b0:a77:dd70:a161 with SMTP id a640c23a62f3a-a780d22e117mr193894366b.10.1720535235197;
        Tue, 09 Jul 2024 07:27:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff21esm80649966b.135.2024.07.09.07.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 07:27:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 0/2] fix task_work interation with freezing
Date: Tue,  9 Jul 2024 15:27:17 +0100
Message-ID: <cover.1720534425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's reported [1] that a task_work queued at a wrong time can prevent
freezing and make the tasks to spin in get_signal() taking 100%
of CPU. Patch 1 is a preparation. Patch 2 addresses the issue.

[1] https://github.com/systemd/systemd/issues/33626

v2: move task_work_run() into do_freezer_trap()
    change Fixes tag

Pavel Begunkov (2):
  io_uring/io-wq: limit retrying worker initialisation
  kernel: rerun task_work while freezing in get_signal()

 io_uring/io-wq.c | 10 +++++++---
 kernel/signal.c  |  8 ++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.44.0


