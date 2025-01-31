Return-Path: <io-uring+bounces-6196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F08A24038
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5524163FC6
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196E91E3DEF;
	Fri, 31 Jan 2025 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/gEDdB8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF3E1E3784
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340665; cv=none; b=YdCCYxbFH/NWptHZvtBBxko0+ZjjWndc17hh9Ytc42eBYVeab7lrPwuPdjwUcL4p5uQ7X1LyKXnLeyzn48u1I/ZAQHgD/kR6tIISE3OauKH5od2zkh+85S1CVnD4M4gIyHGTikoPqjGpR3Kxz+l4qwnskzHjvvz9ZctSqgnLkzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340665; c=relaxed/simple;
	bh=oXKFHYMS/RZdScD4yop9m0FZSwlVv7Y5lTa9LAJNTaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j+zNHsXUCe1rqfnRs5P+A2hvxGESAB0GD9hhB/5SYfvycAKbh99mhwNmM4U1P9ZUY2eedKN9mDkKKjrW/VepWXrOSWau3DAK9uOmr6JYHO9NTpEcQPuiTSfjynE+5oyo6Ci2CcfNUcOtP+2dMVIf3GQKAggaPVeg2iwhwpVm8do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/gEDdB8; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab6ed8a3f6aso304681366b.2
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738340661; x=1738945461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ui0Jm5CfCS/o+sL3E0wNQDjbQXG4rdOa9HNz0TZRKLM=;
        b=h/gEDdB863FKUa598Y6qeX+p58GOHtmr3uuNSIoJq8lWUUKm5BZk1n0Em6bhVsZpAJ
         glXVD71/4VabMXL73Z/wrPD2up4DQNC+63LAm+AUyCUvDsfhyq+Oj6RwQsjxyLtnlzmk
         OH+prk33LzqcVtxm+s+6jrv5yzujwnPj9hhEzpztBLKAx1ei3K3ocMoqmBqktNElkh2y
         KvUUh74XCXoJF6pdq2FsFuHoOWpCydk6tzgP3C7dpLYpG96fcov7YqiOIs/otz8gWQm0
         kiqgKeSg7UlpF0n9yC75W1KLv48ydSJ/dmUOJAgJK/pGOwCtHscxfE4rK2zjZu2aBzSD
         20Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340661; x=1738945461;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ui0Jm5CfCS/o+sL3E0wNQDjbQXG4rdOa9HNz0TZRKLM=;
        b=NWrs0kMtu2Gin0H7mm3ePzTBn8jKm72MjnPjeIQ/CzJsBy8Z8pMRV4ZPDdL9VoivH3
         /5+SejAeZZj1/MsVk8N5NzfTl87VIC8nz088wAQ/tAhBKOM4vn3toge/SYrHSqHilxoT
         sdVICR8fIgv/1jNaxkFtWZlhuVJ+Vf7nE9SAOYOnz/7yUevv9LhklpANln0A+biWXsf9
         8TBcemclbQXHkyOT6bGroZKH8O1FTZ1EXpQ4zMSCmlv3h1dQTUL653avHg/nHbbnAYVE
         OyYCcSuNQr61txqpegG/Ck4lzGRl1NWxdSCEFfTHsA5EekFyKBsEVy6lkRtbNx/ohfYD
         J4pQ==
X-Gm-Message-State: AOJu0YxMZksN2NMgYhZpS7PhcQFwm+VANwEFJfViEaDwyBeYBMmTFL5Q
	tIshyj/ObOwP3uMAapyt/UCaAviFcWOu/tDB43lrG4JtB7qw3q1lJNJ2VQ==
X-Gm-Gg: ASbGncvhWcnqMcLovy/95KMZG+qBftzqrArbCjA5+W+uJZ3yErht3xfjBGzVp69wEDc
	MLOTBfnNS/V1fFejyUroxK2jK0QTEIRc3JEJ2uJMKqbqfi4cR7BPCZUB2yl3zcDoy3CHSl8yY2I
	LYCSWSbC3RtzCPdITVoP4J5v1t4rmKfWnaqTfPkrQhmlatiLd2SlycVsR6AliAugjQLDM7ZDaFE
	l+LNrLcuW2kyH68FpaJYD9aElCDlNNxHPXYK0O2SVdxOrUWxJP6JwkyEFCjv3rbauZs2OJVtu0=
X-Google-Smtp-Source: AGHT+IGzD11qHxP83fjFDp35CjO4E073mOOkOBUkBK3xTZS+CJMVl/x164/pCzItUs+vvwPfMQP1pg==
X-Received: by 2002:a17:907:7b9f:b0:ab6:36fd:e3aa with SMTP id a640c23a62f3a-ab6cfcb33damr1331754166b.6.1738340661051;
        Fri, 31 Jan 2025 08:24:21 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a56587sm323292266b.175.2025.01.31.08.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 08:24:20 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/3] check errors in early init
Date: Fri, 31 Jan 2025 16:24:20 +0000
Message-ID: <cover.1738339723.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do the diligence of checking if any of the (inicall) io_uring_init()
fail and if so return an error.

Pavel Begunkov (3):
  io_uring: propagate req cache creation errors
  io_uring: propagate io_buffer creation errors
  io_uring: check for iowq alloc_workqueue errors

 io_uring/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.47.1


