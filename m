Return-Path: <io-uring+bounces-9672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 054B9B500B4
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04CD61C61983
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 15:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A2A350D77;
	Tue,  9 Sep 2025 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="D+rjuMHT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53333EB14
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757430732; cv=none; b=CjFZU9Ms5evAXWoRFfTjfLZ2NHlEAb1H6NSCrscv4SK5QVgNbjRKy0jHxBd+iaq7F7dxpwXbbGH/m9/RILoR/JQSiAl7CpgF8+5Eg7It247kOJ/ORHvqttWpZBUCWMOWdVEqn1Nms+7E1ZVZbUG4IxhldoOveb0v7KRZws2m2Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757430732; c=relaxed/simple;
	bh=E668IyIeG+84R+hdpDgevawUv5gOsKsetEFExalbIMw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=W8Slc8EMUEDIinEwty+zk7hcVrfCNO1mRdYbbzRoWlzjKq8pP/Imc/XtXVu2RowW9Th7isnQdjDXwoS/JQk0dEslQ1kALMVjRUPLZzo/ZwKAVCHgeTBbJbEeUlyl1vRsi8tiNIeOyIpNP7N2OTGf6GjKrNU8qtVU9k1f2WhmlZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=D+rjuMHT; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-403a893fb4bso15216085ab.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 08:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757430730; x=1758035530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGG5rQwVwfbUEFHBIHE6Jp/hJoWP5qSvz5i+EjjCumI=;
        b=D+rjuMHTEcUjErDiHFiSkAsDzdFVw3mdV4h6zfq9+/JSeWdCTIyEHrLSLwDG0xcvcD
         H8mvedcTeLAvFNDtDa9aBo2DS4JtPfm7BOc7ypp3fxbNfzFA59sE3zLPrqoZWaNhvwN+
         Fab/SLTPxqhljJxzJulf31HKAuoZS6WpQinLgkjVYYNyjsanlO1nIsuoV/3/nRcVuZS7
         90WgNfqJWdDixiLulpy0CPo9gFU9p93QvQBiuGYbU1sZrjqgYfF8Fc480wUXRcoVpQ2A
         Cy3WGkcoHi8RDjgBP4ZLGQnEhmgHCcpzM9wSUTqpmQnDr+fuhVrRKx2JNGwfOVOauVsD
         5uGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757430730; x=1758035530;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hGG5rQwVwfbUEFHBIHE6Jp/hJoWP5qSvz5i+EjjCumI=;
        b=K0vEdt98351rhZCsV9VPUde82LHgkmyUgbPsq6j5T7quMqAniIuXxGew4Yavn1Ewag
         p+yhC/XRLgqFED2YwcdPy87JufHJRe/+9rbx9ESVteFIQADwnsrNrY7mNrD4zk3SeTPP
         4hf7Z+zM7LJoDtHiTNedGtgQgRQpKqYdCiy1/HEZ3OgRYZwLJDdQpqNsPx74AjuQAzwx
         o2XmlfxtC0JJocZzMptq5pF/0sFIPjHiwTj7Drl6OgaF2AFpgNBA+cUX+dlj389GD9KO
         ThX2uz9pLMQsHKXHzmBP/+XP+8lvZNoMSOdn6yaacqhJZSIbNnYJS7xufUua1FRlgO1X
         ok0w==
X-Forwarded-Encrypted: i=1; AJvYcCXpe7ED86An9+i89xrZNeE9x8ICAPZkW7gx0R52Qf/KUAJuCASXIywZ9CrQpEgVORyJSHrWT0zY+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkmUWISATuFypjK6fbr1y+uYwbJ6el8IriWlLHuYGEgtEMKSLk
	csXFe3KNKZEt6+bdDtnfMqy4yAEwralxm6M/yMZ/BD7Xh1uMHFhN2jQEzRroi6WFBaJedRiMQv2
	aFiZf
X-Gm-Gg: ASbGnctVVcUH6JfcNdb4mYv11NankEXCWK7JjNTWLheuq8sOTFsrNDVVjd0MOjylMh9
	pGnH7gFQyGhc1wA06g09B5cuQrgUV1YhmC3h+C3K8tknDtnuUOAXFXnUoCgHKT28DEd2iTQkL2D
	SJcoJGyzd+9kU1yLprosGjRuAXvetZvDDDxfqOJqjF32d9Ozekcbmg8U8+/aQr7SzYfJO7FCOfd
	MqWrllhEo2tGqfBs6XEGhl2ePJLqk8wOAKf/vWIvMH+3aAz4yReseBoTI8x4B4AZto6x3CCOE/q
	sY2n25GRXzjpmzOMrLIVQVjLDdsGtAEOIxWyDOfyWnMtGzumgTw78ZvOxtUXTOlThIUBqtw/YxO
	nZ6y/kodnle5y6w==
X-Google-Smtp-Source: AGHT+IE9u3vDQncMxxM8j9Ij46XNpe0a4PnRGD7u2h1ZJwct0QO39CLJSeGr/oy3OM0Hl4LRJhoZpQ==
X-Received: by 2002:a92:ca0b:0:b0:40c:cf06:ea2a with SMTP id e9e14a558f8ab-40ccf06eaf4mr82148275ab.2.1757430730068;
        Tue, 09 Sep 2025 08:12:10 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-51020b6d937sm7590679173.80.2025.09.09.08.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:12:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
 Marco Crivellari <marco.crivellari@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Michal Hocko <mhocko@suse.com>, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250905090240.102790-1-marco.crivellari@suse.com>
References: <20250905090240.102790-1-marco.crivellari@suse.com>
Subject: Re: [PATCH 0/2] io_uring: replace wq users and add WQ_PERCPU to
 alloc_workqueue() users
Message-Id: <175743072926.109608.13668500662715928702.b4-ty@kernel.dk>
Date: Tue, 09 Sep 2025 09:12:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 05 Sep 2025 11:02:38 +0200, Marco Crivellari wrote:
> Below is a summary of a discussion about the Workqueue API and cpu isolation
> considerations. Details and more information are available here:
> 
>         "workqueue: Always use wq_select_unbound_cpu() for WORK_CPU_UNBOUND."
>         https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> 
> === Current situation: problems ===
> 
> [...]

Applied, thanks!

[1/2] io_uring: replace use of system_wq with system_percpu_wq
      commit: e92f5c03d32409c957864f9bc611872861f8157e
[2/2] io_uring: replace use of system_unbound_wq with system_dfl_wq
      commit: 59cfd1fa5a5b87969190c3178180d025ee9251a7

Best regards,
-- 
Jens Axboe




