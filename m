Return-Path: <io-uring+bounces-10494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD32DC46C1A
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 14:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28CCB3B11DB
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 13:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AAEC1AF4D5;
	Mon, 10 Nov 2025 13:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HM5SconO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672EC1A704B
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762779849; cv=none; b=VLfhZNpEKoHYYVDBzS43zQt8M06hl+urfbubSw73E/kNKAaxw3k5FD18sZl3aVpzOM49war7uNLHjZKomB9o2qjv/8qKcKLAss0ArBM38yVeDgGbVpXbktw95tKntvNqdMm3bXTsgCpAbkibQDsu4YpRcWpmS3Dv77AEdTYWyBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762779849; c=relaxed/simple;
	bh=woSxWyxl9GF9+nzCmzD2wBsEdD09CZ251Gbm9sja21Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SYGznqO5uJeorGZCSWV7Oz2O2MViqeTSt/tkNuMLSdMgFDeQVOxOsngMqnKsmJWLaxzmirl90tx2efltL5X7dd4rMPh3klDQBhLxsfKEr4WVHjEy+tPDZPcp9oG0LwrmkKsWu7FuC9AbibiaPMyL6nDeSDM4wxPipAPoFfExLOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HM5SconO; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b2dc17965so1542391f8f.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 05:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762779843; x=1763384643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OiknMB+LG5sJ2LAKvd9iAn3bn9qxsQNFJhba8/3mUGQ=;
        b=HM5SconOBIBqESZEmDXmGLZX2k2NfZEi/fO1VTbOkVgkjQGFMw9V2dKuRazZ0cqSqq
         h+FHFzn0O1X0zQBSSRZKfyxvE2yCQV3DV86NCZBBi6O9jJGn97BIiqKVdyekCgBUDbgN
         d0E55r624wUKsXmfocH6G/Iqf2lO5oAMXYZjXHjI+p46mQ4mSGd/zPYOboCIeepz45qh
         kBwmrWhFXVz/zZ42lz0aj+Er/ls+ELu3VZrl/b8ZkW7z14ymdGFZI07TOmz0V9YPxl2D
         hJgb0rTILQk5XAmo1Awn1ddwNrmgvSRCcb9K62KukKFxAzMAHLKbJsoQejI5Y0MtJHuX
         TWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762779843; x=1763384643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiknMB+LG5sJ2LAKvd9iAn3bn9qxsQNFJhba8/3mUGQ=;
        b=jG4IUoUeNXGWd4HJDmplYqRbmiEzP3dG6AgrLjTDrQGnUhvCXetbAV+i8Tovugu/jN
         ZuXT77E3WA00Zla7PiZ/iSffnMZhU8nA4mwKd7/FvwsbNSOTA4LfteVBGNvtmGZVIuC9
         wiHn9KwV703vO2LNBFZd5PQDM0bZMLwmRwqyA8RifSpAq4FDhlywTZqZInd/rFFVLXou
         6iBAftG/BG/1VhwBClJNzKn7DS8tNIIByWMOAOiSwKnFUcfEbNmlBRt19W/9BLmMgOXR
         Q/fZ3V+dZ9BndQohZN1FE1HvmwAS1GFLettrkqHlE8FDDa+6iI79+AtVvhvZeXkc/D37
         3Qpw==
X-Gm-Message-State: AOJu0Yw79+enG7mGc/Ned5k3/ztjlB+5hosTPwxPcK2fnI46xYM3G0bz
	l2nOaCU8d0QtVM1UgemAJwo0KEsCs7VMGppiBGTiINV3axug0viwzCIo3P4ylg==
X-Gm-Gg: ASbGnctA4Ygsx7/Gj7o2PqPIVM7qmiiwqiQ63euzHTAE5BLIeE70o/7f6s5lLSF2ZA0
	PD9FWBGe3r1dIoW5hTfMNpktpyWGPTz2ETzOsZY5XR46R+JjYM6iYD/cp+AqDMCMiCGnAPKk89L
	8Npvy4rN2wAOxXfww1sMgAV1+y0AhHc95RAZcGnB5TmMWN9lZwPZUMh9MyKXK+A8++SfNlygY0W
	hyKJ61dhx1xrG+oXhqt2I6kpj/fSnwDVG5iNiQKkMl7aaL/U7a0glsruPgt1c/lJI6GqvowMcf6
	9BMbFS8MHEfujHLWl7vOxfeH4W2qVnnhxCt9AHE9NmY+eHjT7DPZnoK1+4G0Ru/MSSdwFY9gLh3
	J2TpbUo8IgRguMU/nAS4t+IEOhTHAPuEwMqw/3ESJ0nMED5V59smt5dPc9RYlCyKbRbNBNCyGIO
	UoxxXrUOpBkOTqVw==
X-Google-Smtp-Source: AGHT+IEprUUrAyOTIMbQ9SzZ+KZ29HcDTtWFxP9p7JinwxAvPDS7SkcXhsk3tarGNjxmKRAiZSCzCQ==
X-Received: by 2002:a05:6000:2a8a:b0:42b:3825:2ab4 with SMTP id ffacd0b85a97d-42b38253072mr3098779f8f.52.1762779843130;
        Mon, 10 Nov 2025 05:04:03 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b2e96441dsm14731950f8f.23.2025.11.10.05.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:04:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6.18] io_uring/query: return number of available queries
Date: Mon, 10 Nov 2025 13:03:53 +0000
Message-ID: <bbf6e697e5b298ebf4f42644ce23ef6df33e6e53.1762700289.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's useful to know which query opcodes are available. Extend the
structure and return that. It's a trivial change, and even though it can
be painlessly extended later, it'd still require adding a v2 of the
structure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Note: the query interface is extendible, but it's still best to avoid
changing structure sizes as it may cause trouble for multi component
application using different definitions. So the extensions would look
like creating a v2 of the structure and migrating all kernel code to
it. Also, tests work just fine even without updating the structure
just as intended.

 include/uapi/linux/io_uring/query.h | 3 +++
 io_uring/query.c                    | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
index 5d754322a27c..3539ccbfd064 100644
--- a/include/uapi/linux/io_uring/query.h
+++ b/include/uapi/linux/io_uring/query.h
@@ -36,6 +36,9 @@ struct io_uring_query_opcode {
 	__u64	enter_flags;
 	/* Bitmask of all supported IOSQE_* flags */
 	__u64	sqe_flags;
+	/* The number of available query opcodes */
+	__u32	nr_query_opcodes;
+	__u32	__pad;
 };
 
 #endif
diff --git a/io_uring/query.c b/io_uring/query.c
index 645301bd2c82..cf02893ba911 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -20,6 +20,8 @@ static ssize_t io_query_ops(void *data)
 	e->ring_setup_flags = IORING_SETUP_FLAGS;
 	e->enter_flags = IORING_ENTER_FLAGS;
 	e->sqe_flags = SQE_VALID_FLAGS;
+	e->nr_query_opcodes = __IO_URING_QUERY_MAX;
+	e->__pad = 0;
 	return sizeof(*e);
 }
 
-- 
2.49.0


