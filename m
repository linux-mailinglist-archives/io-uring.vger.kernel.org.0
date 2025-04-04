Return-Path: <io-uring+bounces-7398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC17A7C0C5
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 17:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A17DA189B766
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 15:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622BA12B94;
	Fri,  4 Apr 2025 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C1fdfLQ7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF88D517
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743781358; cv=none; b=nNLB4GKz/EWRiIsrZDGl6z7CmEHvvaaGgQVP8QTTzmI1Czca5pC5fd90bUt+Fgq1eK8MhJsff0rTawEPqyaL6f89YIkn5QhxO2GIpO7alJmFaLmwk/ZIqPZ6Pe9/4gHCVwbAaD2Gs2xEjxuVtNuJ8k3fLhMU3I/4lQu8b2itf0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743781358; c=relaxed/simple;
	bh=PceV61ymG7Q8X/8p19v+SrECO/50bkOV9lzRa5YSJTw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=awSu0RV7RUFYQw/GqpMLomI3jMUqblUZyAVWeyWBS0tlYq2wi+ULrj6qgCWKSoN8jCaTbdKozmfz7yeaeGLNC6+WQwWGN4uqjxZeTjdr+N/hyVcvSZhMNrZsMGASoZ+AZKND1jPoRLg5SCr1Wtmvx6iID2TBtlnoB0byMSbNX3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C1fdfLQ7; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-854a68f5a9cso176104639f.0
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 08:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743781354; x=1744386154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vyR3/ts7XrZwFyduo7fQ4zI08nLBmZ0N84oS4ol+YbA=;
        b=C1fdfLQ7aK2QPVUdix5qA9IpmBXO11ySJb4i/Gtm6wCL+twnFZkxul578bKdOk1irB
         8sl+z9Kc+nn9skf9HjKRowd3ycHTtKmd6vIgUsQysKPuP9CKwvCOHIbv0TXuByyUiaL4
         NHVK6U6RFvaypPNGZgS7sQvSH7cpHIeP7OH8n9HL8Z7MbW96fBk2Vb/D91IapffAissQ
         2HtFektnSQ6YVUWt9JZ0CsJB+ILbs+92n7MVuxC8iVSD4el7MzmZ2qo0oMS9E7X3pWNh
         ivAX8ClQsjLW9uq8lNoiroiC3AAMpx30HzbyPbakD8pLoBBMVL2CAKe1MkqOWbK30Dj0
         VMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743781354; x=1744386154;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vyR3/ts7XrZwFyduo7fQ4zI08nLBmZ0N84oS4ol+YbA=;
        b=Hk1xwq21Xk4EUzwJBjTYDOaxHpI9l3XejCVxWl8MwimvhxZeOXsWUqxLUVbj2oXHfH
         HSIuCHkkjJelKcTd67akjs1ktaVNiDsQaBKnjIR/2vn6pW5qLpCBGA8zSdjx2E/bbcw5
         8NRD05fjYV/OZmODHbk1IxCTe9PRUDPHS1CnHT98fPc3wE1wOkuG9nzbfrXN8iBYH83y
         uV+y8+dSqzbV9V9Ql4E53Wf5bRqiQO5gSwZwJMp7JHepWjzAoPdpfN6SKd8vt17eQct6
         zXqPcLbXduEE7vyN6uTqrmgI2iGwWMTBk6WrzFx534lE5Gf1oJX3SGu7ZsPZBxA0xQNb
         utzg==
X-Gm-Message-State: AOJu0Yy8t3VPKAoFOykNRKA+HHUrXBklEAOQ/YuGrPLopLYzzD/Atdsz
	qsj0IkuGLZ4NsMPH1melb4ocvCnIIyawNxTpDZIsHxpqBbM4vdwbG/PaINUouJu85iPbxTr0je9
	q
X-Gm-Gg: ASbGncujhYpUdA0ppmFKTLRQAI2TDusik52FO41RTynzdUvldyGFgRhSgCyPhr/5Ea/
	n59qcZObgBOxNqOwoM2/1BiL9YNFszaTCmf1azWq7JfHMykmX9OKZOOitqMhZ15Y2KAQHMXlZG4
	P0A/nyBGiBJZ1QN4+mNj3WZPjwEgqvxPAQHFL5mdNaWRWs1h0fJPxQf4plO5JyFqF3gPsi8hLPE
	TjQKlL2OodhvK2uwWYMAggPaVMNTIzkcHRL+L6/zu4BFLD+b+1fLmkEALv3eAlz/XoYYh6lkRcD
	nfJBvxBv6F8iUNhXmMsa+nKYnNWzAKCQYjw=
X-Google-Smtp-Source: AGHT+IETkfcN8VpnvT2YCKkqPpynpNgQNVO5JEz2VU5Z1O9j9efwoRJ2SyIMrsmNuzxy8SqhKCkRpA==
X-Received: by 2002:a05:6602:36c3:b0:85b:3827:ecef with SMTP id ca18e2360f4ac-8611b511577mr499680139f.12.1743781354623;
        Fri, 04 Apr 2025 08:42:34 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5c4b46fsm867437173.58.2025.04.04.08.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 08:42:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com>
References: <c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix rsrc tagging on registration failure
Message-Id: <174378135395.1185702.3755291631441770888.b4-ty@kernel.dk>
Date: Fri, 04 Apr 2025 09:42:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 04 Apr 2025 15:46:34 +0100, Pavel Begunkov wrote:
> Buffer / file table registration is all or nothing, if fails all
> resources we might have partially registered are dropped and the table
> is killed. When that happens it doesn't suppose to post any rsrc tag
> CQEs, that would be a surprise to the user and it can't be handled.
> 
> 

Applied, thanks!

[1/1] io_uring: fix rsrc tagging on registration failure
      commit: ab6005f3912fff07330297aba08922d2456dcede

Best regards,
-- 
Jens Axboe




