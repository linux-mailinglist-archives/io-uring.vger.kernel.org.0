Return-Path: <io-uring+bounces-7843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 266B2AAC132
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93082468A11
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 10:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A12E2750EB;
	Tue,  6 May 2025 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NET/2BTF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76BF263C9E
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 10:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746526844; cv=none; b=Usta7O7Nvdo67YRFzwQSfZNIPUAOmdlRfS6J7drv8xuSNI+6U7WaRhegMyJnnVC8r7JQwV281scy/JleLkDIcNSTMHzwsyGZRxPThiY7f3JmfygUUa4FjQ3a2mOch/0jpr7AnGgBA9M/OjiDx2l88FtNfde8Yl5XxEYZK9OxuUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746526844; c=relaxed/simple;
	bh=Wqd8TARfo9JZZ7Y9cW5Khr/m4jnh8D8IiXwKpXkGCzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lqZvHL+2bRmqZ7eVIrcfD0/TGcmvFPC4LypbVe6DSxhj62FLubS+lFs9LU4bnB22kK8au0IZje62vz5wfYYvO63+mSaUWeABFxXSy40DRrJTqVO2fmuOm2dfglShZwdhy8Vk7KhApNhWx4qw9d1gdOahW4XkAV/fc/VjZYfX7Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NET/2BTF; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso264760766b.0
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 03:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746526839; x=1747131639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dRtZJ5aKHUXgrNYcmbGN5CAZ269CJ6Q+V5kfaipkZ78=;
        b=NET/2BTFIx2J+iyIsg6BoJMXOdKzmfyFgdVQT8RKFhnNUclu6GbRDHRTZY2Iszdl1/
         3DKkOqLW6l5vIhP/VXyhhxuIlPPar7HfCUSwqbF34656hxGS+UUMWBTFP7PPxydSsuDS
         tXlgvtFzkABlHllAwOhdf6r0b+f1vCPVZxX/1jL6ZnbAk7ss8FWh4n7q9Ddi6mnzs4mC
         Jj1C16N4vt2d9xJNVm1s22ajEWiXuUWMSfCML/QpD/KQpfx748+Sev6ChgwYmjPVqogg
         T3FXXoQjwV6Tpwy30iZxcxeYurRStJYR8HQH6dWAIqzSS+p01UrBM6PhmK9KOl0RkUEJ
         5LyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746526839; x=1747131639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dRtZJ5aKHUXgrNYcmbGN5CAZ269CJ6Q+V5kfaipkZ78=;
        b=tkPzdyhkmHEnRs/fqMw07FSW4DrOoBIZZxF9+FZXBxaz50f9FEqAHGnD4z4j7HAFim
         bmys1xJYSoir3EPi/C6jAG/0vbPkn90Cu04CK39VoTRFwsRTTCWW1uQUiDzVpVmpH5mQ
         Mc8wHgFfxUEWLW/1VVuyKQHh/1SDq/xPm0QVmNRRBUGEmCQKkN29WpKr3Scra2VhxfT5
         VfjHdWG8bxUw+Vgr+08uVN4Cf2lGL/W77Wofel74L5dL54q4d6SfiZi8T7QAHks6DT+4
         AVfo+wpThGgIa9xGOgqjdESrKJCqK23dBI76E1wXsCyrncgApQOcsyvVvCTz6l6mpOIi
         KMBA==
X-Gm-Message-State: AOJu0YwiGpcO/VT2jWMUyMw6LyC9tn07JcYCErLzdDEdXT6S/M2fu27j
	VJwayEBA0hs8+JN4zoPiddE290EJLQYTUrH3UcTVfuh/wauoZw5kAlNQxA==
X-Gm-Gg: ASbGncuVD1qH7NJgElo/WlVBNs/nKJhhXewVnQxFyoll4NGdk1S43+xijdzaRnn5rRu
	ozFHC9etCcPcvRW6EZrwRfG5yzQL+T62+AWuHjOYZrpiwLkAtURtsJzstHAV+9YyBK1FqLRsuw5
	tOSLzn3GmvOPWpP/BUUbT46DRJeQktVw10kIywwhMH7eCKNkZm2HSHCZ40LwzA9fa9eh7ciEF7M
	AO0Gd/QA3ZWU7mSIOPx3MoWI+FEo1YqP0neswgcKZzam/xLqlqMaSHwtm64zsnIfUubiz05bdbY
	jckMFiaMU+q1HjKTzq5WdX+g
X-Google-Smtp-Source: AGHT+IHSqvRaI1m2LhaRNmtQYDKXqMuNNqMyOa44M3vb+XRNcWEFA2JBytBzcmATkbDp6UdYBSgelA==
X-Received: by 2002:a17:906:f587:b0:ac7:3916:327c with SMTP id a640c23a62f3a-ad1a4b38850mr1008612966b.59.1746526838117;
        Tue, 06 May 2025 03:20:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b5bd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891a2df5sm671750566b.38.2025.05.06.03.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 03:20:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/2] add example for using dmabuf backed zcrx
Date: Tue,  6 May 2025 11:21:49 +0100
Message-ID: <cover.1746526793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the headers and add a option to create a dmabuf backed area
in the zcrx example.

Pavel Begunkov (2):
  Update io_uring.h with zcrx dmabuf interface
  examples/zcrx: udmabuf backed areas

 examples/zcrx.c                 | 55 +++++++++++++++++++++++++++++++++
 src/include/liburing/io_uring.h |  6 +++-
 2 files changed, 60 insertions(+), 1 deletion(-)

-- 
2.48.1


