Return-Path: <io-uring+bounces-4900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E05829D4499
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 703B1B21D25
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCEC1BDAB5;
	Wed, 20 Nov 2024 23:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UaPqxad6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD281BBBE8
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145956; cv=none; b=bYNH6cmpXaiU8Ce1GlHyzZKS/tc8PtQqXvaL+ptXU3n826gIm0TpRh9JUvd6AnjEUfjqKFKw2yhcRhya7BWyWiSVP/QAtx9cnu6dRz+I5NctMg+0rsu5jVa16YVb0Vz+sUGGZ0O9b+unLo9TmkoNhnGsAAXNaNdXem99iAMyOn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145956; c=relaxed/simple;
	bh=pB1cMMFbneF4D3Lv5kAseRTZO2d2ETTvhkI8KxfYGHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+T1Fh4sonkMQgdOyxhYGEhscpeNSMml61twpIUhvMgVUbsO4I5M9tBR3p5jSpTTIjgafQNd3cB8AhaILcj+GnwIgPWhkhe1DakUfVFo0M1D3KsV3lwbNfBMRqTzZnyhaMY9i+UoWyTieGe77ZU6pQbXd8SkDg5i/A12fgYlt0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UaPqxad6; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cfddb70965so322313a12.0
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145952; x=1732750752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tXgJXDtDFSq476CPye8pfcZFMpdLSZxcF9g01KZS8a8=;
        b=UaPqxad6f4FFuMbzekfnrLvHRDB3//Vf/CmZy//evtvZPkFuzeel6spSo3viyz48nF
         lAgw+T75RAU4c0ReAC8ymLIthddGCQysK4ICZAbAe5Hy3EZOc+dxuzJeaGSoCE6Jrkda
         eX2nXTXwtnzkAUp2CIv4ECWI95N2q9bjFUbT/xDiYwTDnfZ1k1piqyB8jjBglODzItxa
         +53mxIWl4KzJETiIco96/OWnwlE8EGrWuMLxHavm8+WKbSZ5N/kaD9y7E/SEWYiEhBx2
         tT1o3JF0FcqEWwE4j9FB5117koxFDF0zwLW750aqFhqdP7Xy8tFrgjQSFoyYaQ5eLyFu
         RuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145952; x=1732750752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXgJXDtDFSq476CPye8pfcZFMpdLSZxcF9g01KZS8a8=;
        b=fr84OsjSLbl2evE2NS9pnPk0Kp4QpqqW1VAvdvoXtFo/H9RAak6jPvCjGeIdGdQ7rU
         BTn83PGwUoYgBmmGulWz1jBEpCFD0gHe6obdi53Q5n7St8Z50kpVxFibVq3MPAtd90pR
         CTtwp8VzbWIRrwlS9MZGh29nU2YDUR+kutaf6bNKiZ8YUulXrGdzF/0InNXb6jCHE0CL
         84olhcIegUzybfU3MtHPOx/TeXCOHk1uGZF0Vb6NUi/UVzfsUb2/FEjktRLrncy/SjZ+
         LAPbaBr0tKmWhH6+SMWzC7YiSORpe6SY1gFB6NoM4ugvW/mJ7Thk+zHGeQ95TnlpTNAO
         P/Eg==
X-Gm-Message-State: AOJu0Yx4JRN+gmeZzmRLKCqlLbc6MIYxVDYmxwdYeSUvKzu7nhI9x2vL
	rX6EEHIp673YQCbAs70kGT7SyXC0/ViOt9y6J3IfGeZ75stnLeMp2wmXfA==
X-Google-Smtp-Source: AGHT+IE6obVsRGb+zbPeFqW9Msx8P0fiyZNnWRd8QVRX/9RYCGsI0u4wmjqwjxqnD+tLJhpYGSBrGQ==
X-Received: by 2002:a17:907:5c7:b0:a99:46ff:f4e6 with SMTP id a640c23a62f3a-aa4dd76dbc4mr427136066b.61.1732145951972;
        Wed, 20 Nov 2024 15:39:11 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f418120fsm12544566b.78.2024.11.20.15.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:39:11 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/4] test kernel allocated regions
Date: Wed, 20 Nov 2024 23:39:47 +0000
Message-ID: <cover.1731987026.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 excersices one additional failure path for user provided regions,
and the rest test kernel allocated regions.

Pavel Begunkov (4):
  tests/reg-wait: test registering RO memory
  test/reg-wait: basic test + probing of kernel regions
  test/reg-wait: add allocation abstraction
  test/reg-wait: test kernel allocated regions

 test/reg-wait.c | 181 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 147 insertions(+), 34 deletions(-)

-- 
2.46.0


