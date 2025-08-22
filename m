Return-Path: <io-uring+bounces-9250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CA5B318B9
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71D0D5E25FD
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 12:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F992FDC3D;
	Fri, 22 Aug 2025 12:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="DcKgRGWQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6BA302CCD
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755867403; cv=none; b=BP1hLOjGZwOWyeQSynBtjWQ5hezfCMiymqYLEU3EochToexYqWCrAgIPa6s+cFfc8pJbQ+kZ0sihFVFbT+o+BxnOoKnt7jujAMMDpADKs8b0k8ZR49s7ZawTv2nzBZry4S4HxYKNdDRksWAThY/aJcjbFgtD5VFXU5n+Tnz/8q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755867403; c=relaxed/simple;
	bh=QcgTbWambBF60BQIQEKWl9c7KUFGhDsO+zeYwk/r4Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxkPzrQnYZlnzrYte3qXl2nmQDFv7Ow35vV3bjXtkF4MzvNQlWwHKJfVeLkH3pJIQjleBK95uTvP5Dh5xCSDYMKYKgo5/iV1U/XzvlsOv5HYQ+pcgCld+8+bjKAjIt+CPc6ETHqMiRDEW4aLW1ZtiKcVN63WHikURyhp71jRceY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=DcKgRGWQ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e2eb20a64so2335752b3a.3
        for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 05:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1755867401; x=1756472201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ln9ocDQtv3JdgjgPJ2w8JqxkmO9wxFyJcAceGQE4xpc=;
        b=DcKgRGWQiqYEfSnw88Li/LRJS3kk/UzNzxPRjWTaWt18wLJKrdC83vkrxyKaizMQRa
         FW/3RJ2nh0Pmc8yljhdt9oDR+uBBDoziB8Ni+IL/O/dlDJPqCbzn4Buo8C2B8EFFF5W0
         dmSkcQRH2a2ENAJaIKYD+mdfGG5e3dDZAuQgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755867401; x=1756472201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ln9ocDQtv3JdgjgPJ2w8JqxkmO9wxFyJcAceGQE4xpc=;
        b=G9pTQP9uxyGbFTJHhe5xsYfXeowuliQMIzaFFRDNWtcDGTPJTt3GY7fl+KaO1wEer2
         Up0kEPF/cMSTs46jo1hHqEzD8uky3FNnWJEIfxhi3YklhPUD7et22tFK9rDNaCgbR0VX
         Icn8pZ0KaicedqbTjEq7/XCSznFexX4+zqabZk+iok4MH8doN4EWahGlXk8wNYY5WYNW
         KGqk2ooVVgJFENQWPz1UMVLdeJ9SDsQTN8B6kDj6+Ki5w3GTziEk81Qq4ygOpHoD1QEk
         H8GnVfZWr4Jq3JxWqVsUHtCtNru9sUjW2jrivmNnNj2LaL+zyKmP04JqH5/ZUyfj4dBp
         Qt3w==
X-Forwarded-Encrypted: i=1; AJvYcCWRHqKWcIr0V7Ihh7S5h5yJGobKk2PqdUt8hHHpOcJmytzwuZaTeFAi5Aab7R8Y6jNHqYMP7+3Pyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoMPxv4a+jFJBHVXin09lEMs4J2A1SwFJzJzA+yVRMrENGdok/
	gd+D8SSyBWF4FdnYGwbZEfV8JiULzl3Dt+zFeCA7H9k09z/VX3d1iS78u0bgsR5ZFfg=
X-Gm-Gg: ASbGnctCVVX4Ds6FnIz00nHn0uZBuMNh4QndKjKUgNTqT4dxY+uqcbFXpvrfOyaATxI
	V6wv2sGSn0ABHOHI5/pmq3zEi5bOlQoqfxzriQYWKrKsecwSUZ82gICGZWWBNbsbFf91gLWMCax
	FMjZtg7GUO7RQRldbb8Re+9ahlgW3DRy1PC2dw3JSskeTRa//j32WTIjIA3tcmycHlXW9XBFb8h
	OpEqh8ny4/jaufyzALcZIN5S49UfrfVGNcV9nJCuEfjH1aNc2FzBEd69NIh0+mKOJk/FlrJzdtX
	0caM0tFnhHB6qEaqfWF946yQj1ZX/c4lKnpT+Ody41lb97/lAdFFzcE7NMC79A50ccvyQWTGPId
	S2PxfOGzz6U9WgYiazoabXLF9H0j54+Rs5x0xTBgxh5iEaDVavX6owjkwpIG6pw==
X-Google-Smtp-Source: AGHT+IH1S3ZNnZrawdMbvtvsQWSSBWdj/g2T1gkOTrmr98XOtngGqtBjqHpAKjepX0TGtaqYnPrHTA==
X-Received: by 2002:a05:6a20:1585:b0:220:94b1:f1b8 with SMTP id adf61e73a8af0-2434092dc84mr4314487637.0.1755867401476;
        Fri, 22 Aug 2025 05:56:41 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4764003537sm7194544a12.25.2025.08.22.05.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 05:56:41 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in io_uring_cmd_prep() to avoid UB
Date: Fri, 22 Aug 2025 12:55:52 +0000
Message-ID: <20250822125555.8620-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822125555.8620-1-sidong.yang@furiosa.ai>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pdu field in io_uring_cmd may contain stale data when a request
object is recycled from the slab cache. Accessing uninitialized or
garbage memory can lead to undefined behavior in users of the pdu.

Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
each command starts from a well-defined state. This avoids exposing
uninitialized memory and prevents potential misinterpretation of data
from previous requests.

No functional change is intended other than guaranteeing that pdu is
always zero-initialized before use.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 io_uring/uring_cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 053bac89b6c0..2492525d4e43 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ac)
 		return -ENOMEM;
 	ioucmd->sqe = sqe;
+	memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
 	return 0;
 }
 
-- 
2.43.0


