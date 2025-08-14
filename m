Return-Path: <io-uring+bounces-8963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58183B2732A
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 01:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06D4AA20093
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 23:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A540623BCEE;
	Thu, 14 Aug 2025 23:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFpMjYpx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363131F582E;
	Thu, 14 Aug 2025 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215507; cv=none; b=d/ItSYKP74t5afcapMYnI3SXR7Ziu9V1kuJ5PwT/v1itkoK+FaGZbXlvMqgAqhpArkiVnHK+WE7SQ7ZsFZOF76Kvh30Y8mtFrpSc1dIvdRpNKAvxZbBqfXnZgZuOoYz6gPNEWw9cPN/zcS7T2xk4RohlA+8haHoE8cj8V/mYok8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215507; c=relaxed/simple;
	bh=1ns97hV698YGI/iUrH9Ye925P9XeJon0wUG6G8gM9tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTVyLjoYfhIFdAUeJKADKFNsp3ic7Gh8rmJqvwxn3FpU9IDBOdwYav/Z8HvF1C0DbZacf6R3hn7ZgmHfwaSEMn+l5wjDPHC5LVaWaAs4EXDnRWu9g0/wVaZi+Tp7Oa4TaMN4TDsqmcqOno04oO8etsw7lpBasKODwvOU54gKIGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nFpMjYpx; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76e2eb09041so1419618b3a.3;
        Thu, 14 Aug 2025 16:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215505; x=1755820305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAUnQdsuqeNSGtsge48OujX10wBW2XrhUGj2n4eD92E=;
        b=nFpMjYpxLNgs8i0gvlyuSmyMyBw/+NSOxlvhW8lwbaqpRuzkNOSkJm003sRx1fEy4x
         BZXkP9xRdgmFUVaIkMavFaBW+L7bikKHC4Av1CoFK8HK9TdMDqgCiiRcqgugtjr66d/H
         asPjhrUGZGxGtPe19NF81TszIjp1FeoXsEyx4JmvJpf7O1aqFd/8ov303yLH29iDHTX1
         b/AkxajFzw+m3yG9+KztfcVQ5/jAYxSQS7V109SF2WkM545W0nXJSTbKMPBJPlDXISE9
         SavaiGek6uN82rDV73RQdgtjNh6qKOwUOfm+3OjZ66EwZb1lopnq7B+4GrMIwRYcrzT3
         hfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215505; x=1755820305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bAUnQdsuqeNSGtsge48OujX10wBW2XrhUGj2n4eD92E=;
        b=l/r9/z09KJ7wjv9AgUhYLpqfHPvJQ9kIW93kVfMh0Sz49NFf5L4oJrdtAXlfiy6nsu
         eHr8kn1x+QQoS/FyAUIguiFUANYJkSKKJVFBRZjLhQ7C3tcUDfCtYNQ0rZbK2yV7q6Vk
         kNYhgLDUvZTUMZaRWs2hgcWc9YMa5tu536IOi9D9C+lC+wJfCFlR3ClKknWaVlpMg5km
         UP/DXGKw3Ul1dXxf4DSRPhR7sG6chEKi3Rs08RnUNpUOmZsT17Bpmgu6d+svFd69+qQC
         +3iluFQG0wtAKqFljptXCw9jqr6j8rBinMoBRFiII6i8iy68E0qmalaiwHkfr4Moa3j5
         50uw==
X-Forwarded-Encrypted: i=1; AJvYcCW0E7kHfafRp/ZnJbBg3qJ3f41d0gP4L61ouOPRiwFZVEWv201aC+8AdLtdH2Bez5FENOaNV4EOJNl2aMzk@vger.kernel.org, AJvYcCWzJanFFnMmhbZ/LoHY0UDaKAwftv9asj2OeXizgQCxMNLsCnjPpJUua3eDPWtqPt8xDowwNmJ+Ykt+@vger.kernel.org
X-Gm-Message-State: AOJu0YwtUBn+wlIrhjkt4UU7s7akvT3aNz7xogbQtpK5Uf39NFazX6Mf
	Yl2Ly8rlB7YfSCW7CfOCeGRk90VPv4dHOUgkzrfrRRsUdhHBZ0/cCn+1yz8Fz96D/H8=
X-Gm-Gg: ASbGncuBxi2RR+uoPpOtxPzOOOSJ7fnghIyUCyYCuHYTr5NBqNs0vnAkdebUDIqFVAg
	d6V35sk739zZ9/vxvNFzcuC5kniZoVVoZZ33fdXey7g34HqqG9I4bOtt3RdX4mk4H8gQw7dzy91
	uHxkXnR1H+xBQmvFv30VMpYsxFf4PWxMpNPCRcHVFwEajZFbqau4w95rxtFtPnmb7cJYjeYMIAS
	TVsql5aIBDmQYfIm17hbp15qm+uPPbIg8o7ePI7oUivsnRX3HjHPA+Lq2n7FdXiFUjcp9t8lhda
	QzdIgLfRGK4jIk9XMqePVOWb+b083sVvd1WrKb8GexU9Wwj80+Bs7sC3whjF5BicT7vDVHDvkqd
	AAqSspBUNYas39Bue9gFkJRLi
X-Google-Smtp-Source: AGHT+IETy2UIMuLmp3H5Yjo6EPD8Q6jWBRvcuv16CimtoRzc3JTyucdDdyYpe+H7KjjPFmxSibVSKg==
X-Received: by 2002:a17:903:198e:b0:240:640a:c576 with SMTP id d9443c01a7336-2446d73a930mr811295ad.15.1755215505162;
        Thu, 14 Aug 2025 16:51:45 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233100c1d0sm2974721a91.17.2025.08.14.16.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:51:44 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 3/6] fhandle: do_handle_open() should get FD with user flags
Date: Thu, 14 Aug 2025 17:54:28 -0600
Message-ID: <20250814235431.995876-4-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814235431.995876-1-tahbertschinger@gmail.com>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In f07c7cc4684a, do_handle_open() was switched to use the automatic
cleanup method for getting a FD. In that change it was also switched
to pass O_CLOEXEC unconditionally to get_unused_fd_flags() instead
of passing the user-specified flags.

I don't see anything in that commit description that indicates this was
intentional, so I am assuming it was an oversight.

With this fix, the FD will again be opened with, or without, O_CLOEXEC
according to what the user requested.

Fixes: f07c7cc4684a ("fhandle: simplify error handling")
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/fhandle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 57da648ca866..dbb273a26214 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -409,7 +409,7 @@ static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 	if (retval)
 		return retval;
 
-	CLASS(get_unused_fd, fd)(O_CLOEXEC);
+	CLASS(get_unused_fd, fd)(open_flag);
 	if (fd < 0)
 		return fd;
 
-- 
2.50.1


