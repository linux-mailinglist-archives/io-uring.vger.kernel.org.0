Return-Path: <io-uring+bounces-8756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9396B0C0BD
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 11:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C65014E0553
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 09:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52B328D834;
	Mon, 21 Jul 2025 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I0T/+Nw3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3903920E71C
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 09:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753091698; cv=none; b=uxxlhM5M5huVfbCnqhu68scZ30HehQFM+sgAVR5UeCcYPTMTTQvInhLuqexIEDC89wUe5qyTZ6Fcv4xVCccDCeTeJtIJRbP7HPPJHhefePE9hKJzCG4/5QsN/gtjFm+yAOyJbUlPJxut0nmvJIIi1CuszgOww0FJJ+fAnz1mGpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753091698; c=relaxed/simple;
	bh=cz2blj75RaGzE2cTF8Co6ANwDdR71vKh8R8NStjskDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FMprr6lLT8uebTk1yd7gHbK7NeOJ1G2N2lXkk3tOin4MKo1wwdHT6igl8V2EFHtElsx/0fBsEwbPaq3NYdkv4ARP7/MwuvjyuVpXbTc7wDGxjvXBuWrujISfdgBGACDtGfXKfTGvLseExkDPhOdJ8Dcgyr6IkMOfI8eN7k7dUBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I0T/+Nw3; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aec5a714ae9so500678766b.3
        for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 02:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753091695; x=1753696495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UcTQ7GVi3lCtbPOV9mHnECzth1uHtBaGV+6dnil2z3s=;
        b=I0T/+Nw3tAmDtecm8cUDCzpehij72LST4iq3yWGyCr2F94I3wefLC01BygFRb5QCrc
         LfakFsQ7jkicvL5m5IG63+DN6fy2GyLQHlUhXo+KFIsOD/7S6aSY71+ZziBvZcTvzVf9
         2OaloohzsgixoBzKCvbOhILi6mannYx/oAsEK687AtLexqsI18uNjzUFOcvdeVuf1u9D
         mzR70pYL63hirFZWdL05V9PWjDh6naiul7Dww6ZuR6wp74roYQ3BU9GBzmhG/qC8g51D
         zodonXUKB7FzxbfBT2joeUMdRGxIiWOcQ3iuA5KayK1+9NGrUII7xUWITT0b0KniBTQr
         1ZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753091695; x=1753696495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UcTQ7GVi3lCtbPOV9mHnECzth1uHtBaGV+6dnil2z3s=;
        b=UHgF39l95bm4ddX8ok+fKDrlMxIf87Fz5pvepJdmBcjgWMfTFZ/cRHspf3zHLEGi1u
         F6XIYwb6YPOvo3ovbqO9WRkvKJu+PzaHfhdn0OTUr4/4dgvobbTE/QQxkW3RxqObnh9a
         LzW1sDCZvhDs8bzY89RHfq0QUvWHZAfVkK/kgp7KWP/TBkjdKd6uYwIMPz1r0jyqhrNd
         yABIQEwSUzSFXKdDVvIBUe6z+5rVa1pUtCEk2wBBuwklUZE5nD4YyS4GnYJr46xy+1CY
         m/xT/zFq1vMABpKqEniVyb+PxPp3ULkyq+wrSsvGyBwkbRJWLnLv/fi61+gW8HO6etQt
         reYA==
X-Gm-Message-State: AOJu0YzF1W3/D868rAlqoBz7cnO61hF/wo4uIuvEoh+AdrY7Ayb9ES2Q
	tEFfbhCOkynmt4CJ5l77l+ljhqoQ7FDKUTlIytqTbO1wTzxmx0JndMbus75obw==
X-Gm-Gg: ASbGncugKdLQloZW0m2S9t1DDIt6ttfV/PNj6WXoPtUH3jHB9zOqB0TfaJYduiaTpB6
	90mnzqmMpLamaXikwuTORL9Lm7jxQbURwYHD8zsyz73oYtk9IStwgsBR5SQ6Cp8jr+GtwKHSpaC
	UTrP5iYD3PmDovDSy8ExI5PwA8G6F+E1ucQQCS6tgeP7+SaeOlLQbJ7dAm/ZYq1iYTF4OOYCf3O
	ZNzc6SAx4B9B9tD6FDo1Gz337bqB1QRtiF9y3M5ulVcJxJyACqLc7esLNhMz38oL39uYTIcXks9
	AU0vvUXAvvVA7onVxSl5DLwAoMoy8X9kG9tgCnJZvhuJifuyP0hSaeQykIO92g8dKX3lCiGzyQK
	VaLkdDirH6jf3vfzT
X-Google-Smtp-Source: AGHT+IET7zdPuvcCVJlQv2c5idm0G023LDDwkmvgAxpVkgBDMDSKjFH9hJzSWg7xprMk4gaZwW4Gjg==
X-Received: by 2002:a17:907:c290:b0:ae9:876a:4f14 with SMTP id a640c23a62f3a-ae9c9ba50a9mr1890331166b.59.1753091694949;
        Mon, 21 Jul 2025 02:54:54 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:23d3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6caf6c00sm647506466b.157.2025.07.21.02.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 02:54:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH for-next 0/3] zcrx accounting fixes
Date: Mon, 21 Jul 2025 10:56:19 +0100
Message-ID: <cover.1753091564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A follow up on Dan's report + patch up possible page leaks
in io_zcrx_free_area().

Pavel Begunkov (3):
  io_uring/zcrx: fix null ifq on area destruction
  io_uring/zcrx: don't leak pages on account failure
  io_uring/zcrx: fix leaking pages on sg init fail

 io_uring/zcrx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

-- 
2.49.0


