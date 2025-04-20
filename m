Return-Path: <io-uring+bounces-7579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD30EA9478F
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 13:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7204163B3D
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304B2197A8A;
	Sun, 20 Apr 2025 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rsy8TjZS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6996E1FDA
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 11:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745148226; cv=none; b=dTIxaEMefs+hKTi7Qn9Xt3+hteXtCJ8dBn522jaK5XuDPZMypSa5pFVdjeAbkpfKclrvA8zVujL7+jCRxL2MinWrLidJSzhKrXBXu6UOVdqYKT/w4J2YI9KFx3Nj0Swwt6/qDWJ4N1hWZ3pws47cz39s27mVj9iW7haw4nIfpk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745148226; c=relaxed/simple;
	bh=OD/M2d5VH7y0lQEZeisajSXpoThzjJk0HQ7ognkU3OM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DLMX8RTeeodKK/VX8K7JRCJ0c/+bEJokCLLQThtLorCw2P8deKcjuqIZW2JocV5DqtK9ny7Kbfy7SSraFNqoS99AxKJnX1kmDLOnRJGIxOzXK9ELETFNKt22XMCjCOKnpX0GX4fQAFXUWD/jElqkBmwvbnjgWdgYKmJiUtZ8t1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rsy8TjZS; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3912d2c89ecso2906612f8f.2
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 04:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745148222; x=1745753022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0P0h8zc8t/nvvuFrLhf8Xkfhk3bszj4I7536mrLJRmk=;
        b=Rsy8TjZS3bHMzBOjbKn26fT2YopTN9fY3zLo5LF/bi1s5mntkc6EzP77TH/7bz+732
         z+WVo1hOtWLp0kw0obvWtg3yukQ6bgxkVaUis4uT7e4TE3wjGOOYTYCPP/N/k9zTzdxl
         61YonjN+Vnb5EBjm267UZ/FELms2Klt1/lVOFEk/diHUP1qu8H46swEmeSc9/1hltc9T
         4KtgGJnlEXcKsixXI9XiJ2Xo5KKWlGgkEvwignAs/WrodCA7WXYDXIt46LAOa/LXs8GP
         AYX4/g9oApu9/V+svbolxh/RVpmmvmlqZkubsHmLeL8D+kTVZm84bvAmMF0rN82r3f0F
         /39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745148222; x=1745753022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0P0h8zc8t/nvvuFrLhf8Xkfhk3bszj4I7536mrLJRmk=;
        b=k3smFPjK5iNtkdalFPv36awTL6YZ61v9xwJfCXnNha9U8g8aXC5TY+IEeAoYR81RCU
         56JEwNkss/c+UhpMSz3caPU76q/jdfSgOsstO9Ec50Yik64FRAS8hVXrVDeTQ/Q/B/nL
         pTj+u48GWem5nKtemMeN4/xUSDgDvDzShZ1rG46PJ2K/kH7NogspiFV9TKNuh1AK9YXZ
         V8sdVVvfN2V5rLP2ax77w4ebY9upAz9hLLdIUldKgUSHHsmfEpn0Z3Oh+8yno9R9lmhs
         O6hgcBbIdfQIo7LiYP+XhGl5e5zh8lRo6UjzG380EQ3h8Egh7wEw5bIRmr2nHkS2A/GB
         jMgg==
X-Gm-Message-State: AOJu0YxUH4lMAU1tlvnAGd0tUpOnaGGm/n4hgEQu6QQjqSL1OGo7FpPr
	apBqa/6UjvmExVShv8oysJSRZTLeZZGX5gLa/QLDOu7KiQuEKXwFH7Q3LQ==
X-Gm-Gg: ASbGncuffSDjN9J5C5KnwAnLHcYMwpR/YrcdVcz8iZvAtd7KtshIqXpAA6KTGrYUU8n
	VYQzKc9JzgstWCaJJclxlY8Pd5nZSTQM39iQngvcxlnOFgds/7JHjhfcf1CUjvG6IZYB4IlazsS
	lYnjlW2z/SYWN6b0Un3rHXQmMjTTh3QEMG7F0lliuiMaEN+ftVdDF3Wra/uuxQ43oVOVsL2IpJS
	byXDAsC67t4ym5Q/4j7lmVM56TIl1gSf1pULB3V7BkhY09KNUXRa7fIJ3rQ44esX0wxirgBJzaI
	DPl+Xx38lRScf53LZRaqLqYjyx9I208hncFaD1QmQHljfrK4vipD7A==
X-Google-Smtp-Source: AGHT+IE830Cpq/eutL+Ft+mjp19XKPIBpa10u3db8lKQNDSAq8gZCpCz5kZFADTFk8S8F40Re52ckw==
X-Received: by 2002:a5d:584e:0:b0:391:41c9:7a87 with SMTP id ffacd0b85a97d-39efbaf5562mr6788427f8f.51.1745148221961;
        Sun, 20 Apr 2025 04:23:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5bbd35sm94447125e9.22.2025.04.20.04.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 04:23:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 0/3] zcrx refill queue allocation modes
Date: Sun, 20 Apr 2025 12:24:45 +0100
Message-ID: <cover.1745146129.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Random patches for zcrx. Path 1 removes oneshot mode as it doesn't
give a good example, and Patch 3 allows to kernel allocations for
the refill queue.

Pavel Begunkov (3):
  examples: remove zcrx size limiting
  examples/zcrx: constants for request types
  examples/zcrx: add refill queue allocation modes

 examples/zcrx.c | 100 +++++++++++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 44 deletions(-)

-- 
2.48.1


