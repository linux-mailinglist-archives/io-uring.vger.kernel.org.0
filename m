Return-Path: <io-uring+bounces-2330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8DB9165AA
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 13:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 282B9286DD1
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 11:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74FC1095B;
	Tue, 25 Jun 2024 11:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cI5dbOXS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E141145B32;
	Tue, 25 Jun 2024 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313257; cv=none; b=G2myj4I9DHQ2cUqoEP33t27zaukRtBsWmQe5ISMDzWQYOn1yzPnTQpPZs7QkJPcAaEFAVJdKdfw47qze1/D+3O/3b/y22EGZ4kFu1aB/sv5Rnctwm4RnEjT03q2hmXjzDjeQUoqZ1KoQPseZR3NGoHRaZqph6DftK0FTIQDkkNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313257; c=relaxed/simple;
	bh=0vIHAQ7YvjnLKfwQTv8MsCHk2eaPF3/En/Mr81Z6QRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoOILcBu6BAvvp8XxWy3NYBXtNTzAKV/q/fD4aBP1DTWPwFcMW1SBrfOqRuIxodyQqgTNM8zQVh/Xv3KgIde3n/n6SmsiJL3mZgOSaiVwijJTKzyxyXYfA2Z0xFTZfpCEGpoM+Pu8vK/pjan4GkZfK51z934e2sBxTEGiU/SV44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cI5dbOXS; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ebe0a81dc8so69581841fa.2;
        Tue, 25 Jun 2024 04:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719313254; x=1719918054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTaK8ifaWbHOYZsMnepqrh6GgtvKb4cednFDr4sSDjo=;
        b=cI5dbOXSFFw6vdSG08JzCC+WoMQ/rbijGZpbOmbeyuYKMt11zakhnybFew91tmUMD4
         S18f+GFEKf1s7TgET6/RWD/evXpe3Hmy5A8xs/IacQaSYrVJ2aVejMMdMc0JQMguw5rf
         iJHSENK3Hmxs8Xjv4b0Sf1hVxIJFfpBHHYv2ta0etc6/plSqIPx+h+afOZBuI96jSiCz
         XJ6hsyT/1+9JtZo6nffEBiPtHycbu7p5gWEbynkV2zJZeLUeoWlxaDWvKUY0XTLvsUz4
         Z1hBUlqo37dU2MGvsY2FLEVwqhR5g3N5Bvce9LDoYqlXUZ/v05n2/nhTCvGJGzrQ+xWj
         I7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719313254; x=1719918054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTaK8ifaWbHOYZsMnepqrh6GgtvKb4cednFDr4sSDjo=;
        b=N29hPRJN4andGlAmQR+mSNF+x2eNYYwu9bTFQ1brTLADi/QXFhIo/dozPHOevcOkh9
         rnDA+cDNYR3B1s45vOf3yXAPtlqtr6NxZtS3S1pifa3gK3/4ntlmIQUL3bUN0ONY42K7
         7NIuQYy8KrMRp5nBJYRUSx3JYjvv+4C1Ux2DCOq3eytrpBH4CgFIV3PDpSLGWx1rQ9pV
         D/1PAA/nNUNNJuJ95tD0rHH8EJKSggoGnkZUVHdy9Wan6qPwvSTVVWN5AsQgnh7Oi1KT
         BgSOS0ldXlEOUp5RAFF9V0TXDsQjva9+egaE/+DUpem5Tf/q2cVuOQlejHLcOLtTphJB
         Vtkw==
X-Forwarded-Encrypted: i=1; AJvYcCUBoG/egcjMVqjufSLy0EdZLDkiXoMEFhtmSfeDjl5GmBr9z8p7o9N+fUtQ/6a1boFY0Vt2oM43G8RN9SlfBXzHO9qqAm2225ZWtnw9K0gibHRSJORsTNfc3wocaBCyZSnlj/rq9PFiVr6nqHyqzamQetoTMostYfgSwMgTAnmf0TvNlT2G
X-Gm-Message-State: AOJu0YxL5Qyj0xkK9VYDNnHRSpf+0QlOKNtK+bivgFtRjE6E0H9hnzuo
	mkyb144a/E+pLdUf+2cHW0w90dFr1jVLFLTsoqmhnzt0fYoyunXR
X-Google-Smtp-Source: AGHT+IHpV9HXs0P4QbXTCeQhNYlDDBqrB2zbBl6B1KNa8va0iJtWcu6ToloiWeqSJ7giQ1iNQeXX6g==
X-Received: by 2002:a05:6512:3703:b0:52c:e4bf:d55d with SMTP id 2adb3069b0e04-52ce4bfd59fmr4509583e87.8.1719313254090;
        Tue, 25 Jun 2024 04:00:54 -0700 (PDT)
Received: from f.. (cst-prg-81-171.cust.vodafone.cz. [46.135.81.171])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a724162f037sm337272566b.194.2024.06.25.04.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 04:00:53 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	axboe@kernel.dk,
	torvalds@linux-foundation.org,
	xry111@xry111.site,
	loongarch@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 1/2] vfs: add CLASS fd_raw
Date: Tue, 25 Jun 2024 13:00:27 +0200
Message-ID: <20240625110029.606032-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625110029.606032-1-mjguzik@gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/file.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/file.h b/include/linux/file.h
index 169692cb1906..45d0f4800abd 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -84,6 +84,7 @@ static inline void fdput_pos(struct fd f)
 }
 
 DEFINE_CLASS(fd, struct fd, fdput(_T), fdget(fd), int fd)
+DEFINE_CLASS(fd_raw, struct fd, fdput(_T), fdget_raw(fd), int fd)
 
 extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
-- 
2.43.0


