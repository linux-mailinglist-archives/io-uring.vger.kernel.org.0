Return-Path: <io-uring+bounces-1351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A988C894491
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:58:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F7262826FD
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B883FE55;
	Mon,  1 Apr 2024 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lUGL+ImY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F0A1DFF4
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994282; cv=none; b=hzF3afHBeim68rDzUkABYXD8kOsaXVzfacHR26aLINnyUytiXInNcg0cTrS6Oadfx0OREGfWKHPw6GmnVplIfgOD/VmC2U70wA+6Gjvchw9rImkje63Djf6SndMwJTsEFxmjxmr198dBm3K36uaySsSB1oR76K+DZxkRmnu4Id0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994282; c=relaxed/simple;
	bh=5Jz2OOAw7oqo5nt4BkFhwv9vyOKby0aKyYqoMsaRB94=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ak8ZWoIlnZvPBvHz9MOciKBuN3HGESy71927MREPy46WkzFXSodn/6hh+XemcOzLCNq5W3d/ny6NPTOOwF6CiTUz5yfgdsToSe6h4y9Latb+zMLmK6ikxSn2/bXIYta6fSrZrKbdUCsKUcZwAjHQdFpOsU/CLzSErOcbdcnh09I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lUGL+ImY; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3688f1b7848so2659455ab.0
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711994279; x=1712599079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=785KIdfNnCqjHoAwmgVF+ccyEIlScy6T+xqDbn6TTFY=;
        b=lUGL+ImYZODG1wPLxRWBhuCTJSkG9LWW+vmRX6GQcztmKnik0L3fn0FNqxDto2Emru
         mtR2OkmU7IGNH5+vp+lkJG2ss31iZl9sc5fa58/0M6j5XHUFjxtH7KN4Y57pwaMLJ0//
         eSBSM+YE6mYoxlCvkf/q4swh9NgeK+JCP9DoKlfQDvpx79Uo3J0ZY/noRBmCBmqIM8qD
         3KNs58toOWHmzI3D2Woo4yXpgfBN+A6mtH7HmVt7nIloSG/fZqNjn0Nw7VIy2Y0hHWp8
         t4wiTvVTX9XgBB9ptNe7qRRu+kk1qw0vfkidta3xcee8dLWNIKp+VFhi59xhFhlSs+O5
         toSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711994279; x=1712599079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=785KIdfNnCqjHoAwmgVF+ccyEIlScy6T+xqDbn6TTFY=;
        b=tJ0R9EXaG1IYcRR3NspQrXXfPxIGCNMhn6Wl5pZfM4ftO1xoqAsKL3ODy6WWMAYAdF
         SpchYMdSHVT4RM3+/IFtZByR+2aCQhFrkL7O+0vtX9EeI2+84C9Fd/1f4L7xmXsUZgMg
         nAAN98NHMSs73ezzf9qD+eMleX/ndBL7VnxN05NdZVRsfdgWxifyi2JeyxF52P0fBzCT
         Jr1zeREUcNwPbA/Wx3VR/gH2lXSQUe2XUuS0lLWU5uQ4S76Dj9jx6UDjvr+4hZdOwoHB
         069GI3B75mHs39XMOe39r0PEJt+thlVYqfrg9TxtOk2RsKzflBWkcH+lM7J9pc9ociAs
         UjTg==
X-Gm-Message-State: AOJu0YxdGfKCEmrdDv7FofQpxpd8u+4BhgBsfNKJFgUOhlVxiJdWmfPh
	m+tE1OkG1PYxpPFLCDwwnBjYhOiPUnZ1quGr5NNS7XQCqChoUGolxj007MfRZEM9Ay7XcWS3riR
	0
X-Google-Smtp-Source: AGHT+IF2TisXjjuN8Mq/kzVRJHZhg+OMX6ripbyaFcI+cNzddNRy/Yk7Aqm9Ot+ou7kgdXFbc+9Y4Q==
X-Received: by 2002:a6b:f118:0:b0:7d0:c4db:39f2 with SMTP id e24-20020a6bf118000000b007d0c4db39f2mr3870348iog.2.1711994279515;
        Mon, 01 Apr 2024 10:57:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ge9-20020a056638680900b0047730da740dsm2685669jab.49.2024.04.01.10.57.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 10:57:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/4] Cleanup and improve MSG_RING performance
Date: Mon,  1 Apr 2024 11:56:25 -0600
Message-ID: <20240401175757.1054072-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Hi,

MSG_RING rolls its own task_work handling, which there's really no need
for. Rather, it should use the generic io_uring infrastructure for this.

Add a helper for remote execution, and switch over MSG_RING to use it.
This both cleans up the code, and improves performance of this opcode
considerably.

 io_uring/io_uring.c | 30 ++++++++++++++++------
 io_uring/io_uring.h |  2 ++
 io_uring/msg_ring.c | 62 +++++++++++++++++++++------------------------
 3 files changed, 53 insertions(+), 41 deletions(-)

Changes since v2:
- Ensure fd install locking is correct

-- 
Jens Axboe



