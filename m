Return-Path: <io-uring+bounces-10932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E2CC9F5E8
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 15:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 97CA93001158
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 14:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A35306D58;
	Wed,  3 Dec 2025 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gco5qMX8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C412D30649B
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 14:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764773596; cv=none; b=popg82BzLgeHGQFktgre32cu+OX/IVbIySsgLnQiRH2nRF2V8FAhuMGfSAjM3hG+yICUxCXbrPm35dGzVc+KWlGW3GFqhHiTCGnZNAlX43xglT+zuiKU5HctcDarf3nDq1ULlJAA3mXCQ+q48ILiI7/aiH+Lq3RCfobmujLDoGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764773596; c=relaxed/simple;
	bh=yjrx4L3sajJjImVzdxgmjxLJPe1GoPkykXthqiJtIZQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZGIm4/Mj1FY2+xH4bU32GFDRlUeuXrgdHeGjRxC+pkxsI1cieiNDSax5QKqNpHJr/+yYDb8szoOtjrEENXY4EvLE5NlgSohy/V8/VmVazQw0nEUGvNmJe+jPnPNbvbG6KS5xyakYE8zYt1sqLj/ZAdsYZoANo9ttciumh3CwSzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gco5qMX8; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c765f41346so2923395a34.3
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 06:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764773594; x=1765378394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhFDBzldCBSrNy/0lQvoy7nCwrmDD18XBqrD7SpXNaY=;
        b=gco5qMX8NymPg3B4+FjFsPChtLnwG9r36nFQkkZSnx1A5ZRkwjROourvvOGVluwEMk
         d78HYLUhZujq+ikkVhyK6TQUKnrLX2h5dznix/fEpEg2bbHLLHZnqcIqERH5Eol/D01Z
         XGbq7PWqlb3GBf4X9ODFQwhxDWpnmCZPFYhODsOyUkcFCsEBHfbWx9riKZ8VRWPZq3cp
         n/28yyzX7NAJwdssZbg89ganx1s0nZovWlsIn2H5nSwYitb1VhRDbbsKtfxAj+fzU4iD
         st1n+lipsRksKu986cA2WQYBaSjJNJD8F2JmnSNam8UIDpHqMs9MzXmZv3DlX9pJsOBb
         Fx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764773594; x=1765378394;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AhFDBzldCBSrNy/0lQvoy7nCwrmDD18XBqrD7SpXNaY=;
        b=jRq8ateUb5W9c9hzT+fuAzhR/3zlNKvCpbbSzCBmKPFOemojQTBfqCuzVnv139ftNH
         Ej3+vAZnJZpgITvMJmfmJqGpuB/EuhaUGhaAjMX7/amLgzxNYlrTrSMvKyTtkkmdsWsk
         6eRU8Tez6PIQKi+kPUJ2FvF5fOOQbL87lwRX8PfQchyY1fIpxkS2xDFBN9Mx0HBtiZe2
         0+lqqeYixhBSg259ghz7uLmccwBHKQLgDmggEtoLW04UD8Y7euVBNzVvShsj7gh5LSZ0
         kNOgR29nYnmQqDURIB6I+79oZ9TLTi/o3BF//pOPcWg39JGuQuieSWkSZQEoWlw/t7z1
         XxrQ==
X-Gm-Message-State: AOJu0YzGSIdv1r7En5wvujGhGnB3k05vVAODTgDlbwUyZw9EAZrnAf54
	c2KIO2GBoy/z/hAkUvAFmdzCKI2dQSgjK/8uj0RSdM2VCYfAAOCuCEPb/I8DkQ8gZgg=
X-Gm-Gg: ASbGncu0mciU32JxrnEyhw/6CoOKanfItZvOQql/4hANt9IFrM43E6rXVcJpNzR1C1v
	cCdD6owlI4FQo6Cl6TJKyR8NTzJrmY5uItFYONSrVxPI1MC4hlB0wH3jQRsJ4FWwjhb6urvacCS
	EPJNt9iTfdrnLZcv4Xr6Ae6LPUz2SX1+dsewsHzNYFLGmSb/ifvDNF2QCkyJrexI8Vfrx8kLvJB
	R9YmQBCZfyGPaLZu/LrGI98ZUjaqwO0Sm99khvtKWVXKXg8YfCu93dfmLwpLqO6noXbaYmowIzg
	zsibEZ9s5QCMUh2ODPVPxorxAN6oWVTogZAXSHb06SBCezqL7Q0qBzP4AGrsXreaskeepyuvUYv
	y5Uxs1DNAmZJY/eKTDZ52qKogsUrFBW7axjqjRSYL8wcSVA4paav5uRIKfb5GL9w41TXvmJJMbN
	SAwQ==
X-Google-Smtp-Source: AGHT+IHyFhnXZ6FXNeMNq1Eg87AclDDvm19pylcYCAjLrlhFQgzujOLB2bzSm/z8cgcDPmQKgMAzAw==
X-Received: by 2002:a05:6830:4103:b0:7c7:63b6:89d3 with SMTP id 46e09a7af769-7c94db2e9e3mr1502956a34.19.1764773593819;
        Wed, 03 Dec 2025 06:53:13 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65933cc55bfsm5953139eaf.9.2025.12.03.06.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 06:53:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org
In-Reply-To: <20251202182132.3651026-1-csander@purestorage.com>
References: <20251202182132.3651026-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/trace: rename io_uring_queue_async_work event
 "rw" field
Message-Id: <176477359283.834078.538771620775282374.b4-ty@kernel.dk>
Date: Wed, 03 Dec 2025 07:53:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 02 Dec 2025 11:21:31 -0700, Caleb Sander Mateos wrote:
> The io_uring_queue_async_work tracepoint event stores an int rw field
> that represents whether the work item is hashed. Rename it to "hashed"
> and change its type to bool to more accurately reflect its value.
> 
> 

Applied, thanks!

[1/1] io_uring/trace: rename io_uring_queue_async_work event "rw" field
      commit: 4bab5940c31b5d8686c56fb3caafad83a5545a0d

Best regards,
-- 
Jens Axboe




