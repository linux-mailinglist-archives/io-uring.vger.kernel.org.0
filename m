Return-Path: <io-uring+bounces-9254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1F4B3193E
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48B17AC4895
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 13:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0153043CE;
	Fri, 22 Aug 2025 13:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AbPhbJoU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2088D302CAD
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 13:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755868566; cv=none; b=OvUh7iKnCAPbUBlVGb8+z2D53S3yOH0f99LCh1HxNlv31DdDr3n1rHfgWI/u0Gmg1/tBi19lrDcEcI9hhbtLF0NaVBsW8h/iLZWdC++KeLd0fFDkhkOt8qZpViXKqp1DSMruybCwQkVc4yNAdww8QCc0zqbfAWLaGZ5WAQ9bjCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755868566; c=relaxed/simple;
	bh=l2Sm6sv6p4ErXN0KaVHnzrB0OVEtiMpLBWYfcO8tO/I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pnel3cDFPsS7ipxC2iyMkRCJmu4FHO3WfIhgKigU0FE747Urbr6TQGnIjFCshSJMompGa8U2RNrTr+y1ZT2xa/vqt/cXY72D2PJ1UGIDn9HpN+BapC/4Aur5c6DKBGKoHKqJ13SyNhY+TYZ+P+/tdSmSKJuplcDX/Qq/8rkEjK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AbPhbJoU; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3e584a51a3fso10686235ab.2
        for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 06:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755868560; x=1756473360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ChtfhCgL1EpoGk3Z/33gec9/dKyHFTisaYWwNs7uKSU=;
        b=AbPhbJoU6AaNxnYDflXDWJZdISCRvuNn1Sal7PSbiHOW636APjQDpI6csJnjOiZhM3
         OLfuGvFNnLFVmrWVf8LWiAwyeWPLVNG5cC20P1UuxwW/Y1HV+pG42rsDmbu/DfcrEkdC
         36HHOtrcOaToCXUpD9JDzw1ZlAAzhNPw+IrZRrYPpZzVRBU40HfxUvgZdNbWEn3wqVnK
         QUKPdk7nj+6F7oDZmwi6blicIvRcsiD1zI2ii9Cp0v99GGsav3bPg14AKxIGX/AV9oUt
         +h5/ibsI9J/dn0DKoX8COwdfwdUugAzv9Kf/y3nQs6vp1CA15uLIYZAg7a4DAJ3L3eGT
         y+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755868560; x=1756473360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ChtfhCgL1EpoGk3Z/33gec9/dKyHFTisaYWwNs7uKSU=;
        b=nkMJID1U8TZOGk1QFCx+7P78O/6p8Zad52tBzP60LOMH0jTIUKyC+jaWu/dEhaKq4J
         W7twe9AZneotFRDm2JaejLYZcz14dNCH6iUBcCFj6OEq8uT3IXlcSF2uzEVBwmEpFXXa
         IIEy7gvJprGGiM9UhgKz6vwu6X8fuMJdGjFiw28gSkdOCWOsTRcUFOCOviU2lrsSZFda
         n18VOAf1uyjrcxSXDPoyyiRibz6wrjPNbiLbTp5c/04gs/y7foxGc0OXKERx7+YJF5k2
         7VcMx1Tyhj/8zSDT0KPSpGmiPv6VCIN0PqQr4GVEUeYFPql6KmRJxtH1wUvmuu8oCnln
         sNoQ==
X-Gm-Message-State: AOJu0YzYhTXIYkotyK/KsCzMWdyhwoeZK9+oj4DbU6Ct6zVZPh9gii1u
	N7GqiDd5wqRdGqbYuEnzN0JZc64C5fZ1JQy/b3x3+j5pvM42f3AdnoukEaH8ha//H0/1WFUPEfD
	D8zRl
X-Gm-Gg: ASbGncuKwJ8kd2xlu0ifGAXfFa62343nJX91ACnGYt68QDYhHhUpSVGTB0HcY09FJPk
	zCM4wLdWRCqfCjRJedkrIS8F5oDbVAr4BAdFQr6oo9+z63QH+dtmK8UIm2RTiCKAz8tx3ej1OCO
	bH0DzobyAO8OdyvQ5VOJKbmep/ZVil36ybwBikWy60piflsCQ3UH6KfFvSgL3ZwZuOth2f6fa8U
	+pshYe7Pk15QPl8mFhOPR+/26n7QZ+JyUOoCyhghXDlRTWDGEfUkQ/qTql4Ze4OfJriFLArFHdK
	D30sPB0cEMuuFrZZfKMycgV/l70PCTMmaOYztMZWeMUgcJciwn++hNfDDxkSA/7B9deziulOnU7
	QZoiOsQ==
X-Google-Smtp-Source: AGHT+IEqrZCbSNKU+HqF4mvhH2J7ykAS0/7LhIWTHxsM0hl++RYRUn1GdS4zK0VhACTznB8uo164+g==
X-Received: by 2002:a05:6e02:2511:b0:3e2:a40e:d29f with SMTP id e9e14a558f8ab-3e920da9c6amr51454585ab.9.1755868560030;
        Fri, 22 Aug 2025 06:16:00 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e679121sm89355595ab.30.2025.08.22.06.15.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 06:15:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Saner ->async_data handling
Date: Fri, 22 Aug 2025 07:14:45 -0600
Message-ID: <20250822131557.891602-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Just two minor fixes - one for an issue where futex was handling
->async_data setting and clearing inconsistently wrt REQ_F_ASYNC_DATA,
and then a followup that just ensures that other opcode handlers can't
mess this up.

 io_uring/futex.c    | 3 +++
 io_uring/io_uring.c | 1 +
 2 files changed, 4 insertions(+)

-- 
Jens Axboe


