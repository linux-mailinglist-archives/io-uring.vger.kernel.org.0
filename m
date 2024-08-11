Return-Path: <io-uring+bounces-2688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E2894DF76
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 03:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D3481C2094A
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 01:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31004689;
	Sun, 11 Aug 2024 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IqnK3oGl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DA14A18
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 01:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723340047; cv=none; b=UFMZ04eGcK3cxl+0DbJ1CROGemWp9Pl8fyoVNaBu4dbeQMQhYlHDLYrTnTPoAT4lJ7evmLn+lPfHjRuR2FPtA9hRjDRdJxitV9AX00qexTT1F07lXo7jPEpIHryYA8NBxrkOaTIDYYqjakzcWsekjqwxzFwx43dyoNFqNajKV1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723340047; c=relaxed/simple;
	bh=Krab8o4nZ/XoIDPca0J5UYW5MBYqhYlnEVRyv7fxXLY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=C36UUYRkdrXM0N1Y4E7U43yy5rRhkWTzhqdz/BEPUri0Ou1Pc8vystUj7+UtXf4Xdn9zlv/1MMvVC5nXtzIhxQQZG6RZflCkwmZgozqLn9ytMkoOkh2lxOwdDfe3ZFgqEIfIRItKtx/BhDSxHseJM39Qmctrp6hBgrHBLF9eVFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IqnK3oGl; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-81fdcd41e4cso10759439f.0
        for <io-uring@vger.kernel.org>; Sat, 10 Aug 2024 18:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723340042; x=1723944842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=AD0qOE0C4ijAtdRoM4tfqBAYlYiQnwPi2JOGjzKsZRE=;
        b=IqnK3oGlAME+hJDoiu2WQgpO5IOl7c5pfFpe8DTmJdI7GyCzLzXC0ME0JN/sZKz9uU
         qjMtixoTpqnaOL3m0Se+83yNLBUvvhpRwUOYJJk179Bv0qFX6Ux95kMuYmJbVegQ7VHv
         wfH67FEcuecEEuK2GoebTATnsQZJJ5G4+zjh7wa1tpolxZtpILN8cqooqDfGDgc87BrZ
         wk+7qzT52Fb+RUePdVpDYpj9fEmVmn5tSWDVGg/TMnUkCWexbCPVj+2w2W4eGGx5VDDO
         WgIZ34GCL+SSmXOEYXHHzFaa7plj8A2/MfQUWGT4vfttFNvXXw/FNYiO62FjVXhsOwLp
         pe2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723340042; x=1723944842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AD0qOE0C4ijAtdRoM4tfqBAYlYiQnwPi2JOGjzKsZRE=;
        b=uwfg1K8W9vilpT0Q4yKaSl01mP8bQXYLACzsDf6MZIs3QPTXRSvE9v+mkpUMscreYE
         eTo3InHMPCWoh4ICtQPsrd93ETU5dFrTsf1d4oi7+jLFqSGHeYBxbMr1U5EgzFmjfs04
         R+23cB0Bta3aF6bU11uYa8+7iaPwnvBFepHtopb/b7F5yMre16w1EIvR2RJtNGkuZdeD
         Mfkj3EkmUKVian8mxHav3/myc7jiCJEyXuRpIzvrPfKum9jzYOY/hDivmzQjhlrnk/TR
         KD5EVGTu6XKfmu0jBF8JGy7F4tS4B9BmeZEwQKYEYMZfCIf8MqCeiGRcUCyFFFtACI9x
         NuRQ==
X-Gm-Message-State: AOJu0YxD0PXiUuBOccIf/ZOeQAdpWFq+oZXml0PWKOPKOdpJ0k4dgoUU
	q628+XkCyybk1DQQbnCJC2bcUMCNl5ZTrs6U9oXJU0OFMyG3AOKC1SOPHcY8wybiY6rvyK4TAjN
	W
X-Google-Smtp-Source: AGHT+IFQzt5X+EgjQWZ9swM1rvbY4S/kDWCjzZSotLcz5Q8zTR0eXF63U31HWQcz52v+RECo9XTfgQ==
X-Received: by 2002:a05:6e02:1aa1:b0:375:a202:253b with SMTP id e9e14a558f8ab-39b86f65c70mr44362875ab.3.1723340041840;
        Sat, 10 Aug 2024 18:34:01 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c3dbea4389sm1852477a12.84.2024.08.10.18.34.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 18:34:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/3] Misc cleanups and improvements
Date: Sat, 10 Aug 2024 19:32:57 -0600
Message-ID: <20240811013359.7112-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Patch 1+3 are just cleanups found while doing other work, and patch 2
enables ITER_UBUF for provided buffer send mappings similar to what
we do on the receive side.

None of these should have functional changes.

-- 
Jens Axboe


