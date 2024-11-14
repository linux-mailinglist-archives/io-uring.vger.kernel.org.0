Return-Path: <io-uring+bounces-4671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4AD99C81CE
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DD601F233CD
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990611E8827;
	Thu, 14 Nov 2024 04:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXk0rxwX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4C41E882F
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 04:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557641; cv=none; b=vEYnyhZ/Swr3mCNfGh3xAazXzhUY4YU86r85Z6905dvjC7f5V/RIwzaPgf7biM5iO6amIy7u9BKviTq0pk59kb5QJ8LEf27VoQrSn599HlXqOndxnslpv3S+upkF/BuH7jPTHiGY0Vzis6AloqEZ5v3qZcEpO2z4P5Wice78Vi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557641; c=relaxed/simple;
	bh=eGfmk5pHWRmz/5IEyopxX540NFO23oPagEaL0p8rDAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfXNEe06U03uEhqTREMNhVfa1cW7XXwYXw4/1rAA+ioCDDFrib+OCAMtaN/4STF762FsSG/uwS+NFpyznGLjOZUiPTTSz52CSF5ac7hxWzIxfRfEHZxKayMk3kFdS+zHVtO4iUw3pLrVr7cq//CCwcjGsG280NWk9m7LBe47pN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NXk0rxwX; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-37ed7eb07a4so125410f8f.2
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 20:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731557638; x=1732162438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbuG+/DWjJeYlovcxNfbsJzRVRRM+t1Xz3YpJq8xpS0=;
        b=NXk0rxwXikeN/V1smIQABraEbwM+1IV3tUczzcRoUK7PPvxEPFIxCEgeHYTAgRtnLy
         vUCsJ87umG/jZtdOdR2KePjOaRibFVXEGo+lQCZ/FP9kk1jAZxpg8puFr334puCJl1F9
         FdYcFOo2AkQimlpXacx1qKyX0Le8RGatGs4+7bHzsrjKZGib7dJFCZH/i7UtTcAt+WkA
         5u7L7Lfr10dU7/6RXE/sa5q5QdRF8cpIRVNJmZWyiff16oyq6P5T8Pl2nbcjnhfTA1ug
         rS1V0drcZFCTbfYmpD8C5M7VeZ47SNSq5u8Y2JdW7FlnO5LEPVsviiC0jdMnQE3un836
         ctFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731557638; x=1732162438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LbuG+/DWjJeYlovcxNfbsJzRVRRM+t1Xz3YpJq8xpS0=;
        b=swHePCqlVOsh9cbG+i6F3pJFRyCNyuA+AqSeAWV5q/npMYhDJkxdvltjO1BJfceMJ0
         HVJLpbXDLx1nc8bZtddxpR0pLctE2pQ+H75KUjRXbfhpvvL0a9VE0xuW7dgCMWQ86X+e
         vehfXZ2raC7LX8CPhSMDYI0rLbBbtQqbw4t3+aP2NKBR85bT6FioItQicADBEgBY1Glw
         NHK0iuClpUEkoRFKIq4H4kUEFGl+hTrp9RkhfLiqGuSyrqo6xoU3KDbvFFWjN4THfNJd
         KE6VM31wms9eC1LcU/lDkjfbAjmGWNUldKmc9qPPXkvbHqKQdO075VY5ZFwT2+CpHZN+
         SlSQ==
X-Gm-Message-State: AOJu0YzN/adSRlI4aObq6tIJMfgP0sSGOHexehwsH/Gj6scxKtgovqSV
	WkwUmKZcz3iqrMbAuPQNx5DvsiJm7VPHp1mF3uK6eB8V8ZDJN04AFhGz8w==
X-Google-Smtp-Source: AGHT+IGqS0sdBB369z2SSe8Uw+6yFrfB6Z3f7GpElRqlh06aUVjAACDkQx2ilmhxZRUBC3pvBnMS2A==
X-Received: by 2002:a5d:47ac:0:b0:37d:5282:1339 with SMTP id ffacd0b85a97d-3820df6136cmr4287581f8f.22.1731557637993;
        Wed, 13 Nov 2024 20:13:57 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae311fbsm251936f8f.95.2024.11.13.20.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 20:13:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/6] io_uring: fortify io_pin_pages with a warning
Date: Thu, 14 Nov 2024 04:14:20 +0000
Message-ID: <d48e0c097cbd90fb47acaddb6c247596510d8cfc.1731556844.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731556844.git.asml.silence@gmail.com>
References: <cover.1731556844.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're a bit too frivolous with types of nr_pages arguments, converting
it to long and back to int, passing an unsigned int pointer as an int
pointer and so on. Shouldn't cause any problem but should be carefully
reviewed, but until then let's add a WARN_ON_ONCE check to be more
confident callers don't pass poorely checked arguents.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 85c66fa54956..6ab59c60dfd0 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -140,6 +140,8 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	nr_pages = end - start;
 	if (WARN_ON_ONCE(!nr_pages))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(nr_pages > INT_MAX))
+		return ERR_PTR(-EOVERFLOW);
 
 	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-- 
2.46.0


