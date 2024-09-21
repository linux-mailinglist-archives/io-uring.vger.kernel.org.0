Return-Path: <io-uring+bounces-3246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B459797DC0B
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FD8A282EA5
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F8D15098F;
	Sat, 21 Sep 2024 08:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HCfdWHH+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0D62F41
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726905805; cv=none; b=HFdMSnSuCAkjV1fl0eGsJcHtVblOVP8V+jXgHUB5fGRX3yr0NZx/LdjCP0m5VlGxzv9fUXK0QZxHYI77w+K34zQjvJxNE1CpD+PSkWm8cuN/lzhxY82OdYwQtox6TSDD/xEWFFbcLAXkqIrHPOY/wbGaWo2Cz5OcTdrtp89xNP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726905805; c=relaxed/simple;
	bh=z3elXXEPxgoyBPNHo7XYr7/9XK8Gy7YbTUyUxvSDcPc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=q86nkbO0dS3L/6W3WCUI8gpvdMKvA1svHCaKmlKJaGX49LvwlhLvJNGOPuSrjViwxw6vzqs9RJYAnrRu2xyakfMKLZXj8WQvROphD/dbVLBEfnssmxcrLjm9DuOOQlVpsMnNLDzupOVroU/HFwkPZozfY+1UYAn16WCcvNX4kcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HCfdWHH+; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a86e9db75b9so403266466b.1
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726905798; x=1727510598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=UtZtX/WdGRU5wOeOLTRWyIjEH9aBgLRJiFV7Ber7eak=;
        b=HCfdWHH+zgrSOWisL+y/XhSX85HyvrsYuva1Y0SfYHC5oymZZmTzg7EcKjDCVjlOxf
         +vrsU+2KxIvJWvmFkIe2Bk5aMrdNIcFrAfqH/ouJ1UEFrbpEbzXQWdGuNptV8Rxl5bj+
         fWWdhOB8/a9NoUiZ9OEB0dwqJb5LAGyZ766ahXy2BfQofGc6KcgUKOoF7MESZlk5yIb0
         yi2lcZVdsFlSPfPwx5NSItpxS+zJVW/iKS2D20UHtvfnatvbreQNRHljpVRq4s1Qk+vU
         pOWUDxv9oJoNCR1fS+pmjDdXqS6QYa1QuC9WRqwgoFW2ll9pHwulbl+ehqSnTL40rVOd
         rPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726905798; x=1727510598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtZtX/WdGRU5wOeOLTRWyIjEH9aBgLRJiFV7Ber7eak=;
        b=uzzu8ZVdhz2x2SKtqm3LC+bD47doJomnBOGCFVqQLHWNsPPnh2/4aA7GjB7JiHdByo
         kar5VTdyzM1kI2VEv6THl3M7vJXl1WPymgGIVTMjG9Ww8ix75nnRbIGL1on7bpNUxJah
         weKhWF6Kki9TDGbBEbp1X4gBJit0MzbVhgnuzDeRAMOCQhcJPKPrnWwmPlVqKY2FMxQJ
         ldf/TUF8MTHZ+zKvx6T0sfiH4B0TbSu6gvNOfiX65epr7hJ/3uDX8kgHtKJ4+iQFab7t
         RQJ9S9ebVbmad9S02SkU5blqdKiZhQdnQD6R7FLhkCnHPzVAkXRlV+9wXRWEgCcJF1U7
         f7jQ==
X-Gm-Message-State: AOJu0YwRYR+wsge/2Zh6FjrYvQRUK2PQ++Si2CU5Mm/LMAHZYWnkk2Eh
	jYKNqTO6+iJEhlWXflwa1UcaKtF+MwRpTTppFP/MtGz7WHg50NKunPNH4S+zIVN5Jn7vdateLJx
	BTiTYv3rj
X-Google-Smtp-Source: AGHT+IE92XI6J9GCTIZ6CWwolsIzeh4WQlcywIJS9nESSTLY5gO37YQXEy1YvtrF9+egVfqj/JfwMA==
X-Received: by 2002:a17:907:f1d1:b0:a8d:14e4:f94a with SMTP id a640c23a62f3a-a90d508b54dmr463307666b.38.1726905797444;
        Sat, 21 Sep 2024 01:03:17 -0700 (PDT)
Received: from localhost.localdomain (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df51asm964583666b.148.2024.09.21.01.03.15
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 01:03:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET next 0/6] Move eventfd cq tracking into io_ev_fd
Date: Sat, 21 Sep 2024 01:59:46 -0600
Message-ID: <20240921080307.185186-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

For some reason this ended up being a series of 6 patches, when the
goal was really just to move evfd_last_cq_tail out of io_ring_ctx
and into struct io_ev_fd, where it belongs. But this slowly builds to
that goal, and the final patch does the move unceremoniously.

Patches are on top of current -git with for-6.12/io_uring pulled in.

 io_uring/eventfd.c | 137 ++++++++++++++++++++++++++++++---------------
 1 file changed, 92 insertions(+), 45 deletions(-)

-- 
Jens Axboe


