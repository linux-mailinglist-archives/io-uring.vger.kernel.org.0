Return-Path: <io-uring+bounces-688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D028622AD
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 06:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B64F3285AB0
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 05:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE2B12B66;
	Sat, 24 Feb 2024 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="E3tF6ecH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F29C12E51
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 05:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708751269; cv=none; b=pZM/goMOiCG2kbP8CzQ9qnaK7tSjCAtcPIg+wtAP0hv2/Qyr93M5H5rKU0DKQEaEIxYnEdfKQAsWfFaIH+TBiotmeeR7PQ0Gr7o+TFNTYBwsxjAzflWbbG3ukTDbZp/Ga74yre1Qt5ueOC+eTDlG3onREIECx4pmYE+mJVrDR4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708751269; c=relaxed/simple;
	bh=HTtofWdLtXwoxkpmkidgtk48vDW4ybgbqrBGySc2op8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/pY0aIymxYjeuMBZfZhXLOKAgi8N9bg5PeujsqVF7voxFVVIakHwOmEctONxZ+0pqFFeuBr5vN2ERjbSSzYyuHCh0NoH6GjiPr6saFIJ+GrKl7Gff8LLWvheCNqxSfbsBzs9pmVHSeqEJ0ghPmGbJzTN3JBOtVJOl7BHEk1nfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=E3tF6ecH; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5d3912c9a83so1130871a12.3
        for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 21:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708751267; x=1709356067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pu+yQ8ayliskgpsY+U87x70jpuMRyp1SCw69OCNtbRo=;
        b=E3tF6ecHd0/wgQVshDwR57s8BruJMhWWAhJjmI4zwQkvJJmwPXknDTjj4IDLMsneag
         kjbcfyAYZPV5F7WRcm6pkB9HlpwHkbegCn9+HXDGJBXV2mdfWpkuSIlLE1a6h+AAZyq0
         RRstJLUPZuZbjFeldKqBta0QxkoeLgPW1QOqHKi8gJ9FmItXPQcsDk6wqAnXOyRECv77
         H3EEpcPI2QDRxbFxN6HE1t1Zvw8eoGYLf0d0DetTuTy6i5DH1Xe1X6pSeFdnJIjINNKO
         q5IRnO6DdJaWryAm1AGB2r+A+fXo5DbkYFvdASZpLls1OD8VBfSqOt+9n3U3Aaqe8Nm/
         jROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708751267; x=1709356067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pu+yQ8ayliskgpsY+U87x70jpuMRyp1SCw69OCNtbRo=;
        b=MDS1m0inFPRXo+O3GlVOGfjiCnlgPp5jQNiCT3LxCjmJJfXne+nkrL3FgOrMJoOPNn
         jsLmYbT52xafQHA0yJ5vontx5tUcCRycY/T581coJzZDjP1g2vq8W9337KkglZ82+T71
         +65+xVBz1LgvETNvHDE8TKJg6597/TWUX900BTbHqeCYVwgxgJNnd5gjNX2nrZADurkP
         8/HnyAmA1VFcAzqdzjP0w5re3vKW/El+sMtADPZOX6DYvCS09yypqCw+qbZPizykoZIJ
         y+8uGNSa9Slxyq1HqJdRVXZbXrGkTCuKNzSEp3liHAdeFhbDICW5ixZT+2x7QnCs7qk9
         rcIg==
X-Gm-Message-State: AOJu0YyQTP3SNCbUsxYnyTEnjoYe9jNI84seKdA+B6njoMAmUVkfXBT3
	sStaDCT/Ratxvc+lblA9iH7BL6wT577CL1rldBOs/Kzt1jkU3Utm3XhOYHn8NyTwuQeA43k+due
	H
X-Google-Smtp-Source: AGHT+IGItOlvDj83o2wA2R0Pi+tKpcvSo53OvRY7H+uoJFw8IQ6W55Ar/0E30AazRbxQemOUZGXf4A==
X-Received: by 2002:a05:6a20:d046:b0:19f:ce3:5aee with SMTP id hv6-20020a056a20d04600b0019f0ce35aeemr1604447pzb.8.1708751266991;
        Fri, 23 Feb 2024 21:07:46 -0800 (PST)
Received: from localhost (fwdproxy-prn-006.fbsv.net. [2a03:2880:ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id y6-20020a62ce06000000b006e39d08cb3asm340896pfg.167.2024.02.23.21.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 21:07:46 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 2/4] liburing: add examples/proxy to .gitignore
Date: Fri, 23 Feb 2024 21:07:33 -0800
Message-ID: <20240224050735.1759733-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240224050735.1759733-1-dw@davidwei.uk>
References: <20240224050735.1759733-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

Also re-ordered to be alphabetical.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 .gitignore | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index d355c59..f08cbe9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -21,10 +21,11 @@
 /examples/link-cp
 /examples/napi-busy-poll-client
 /examples/napi-busy-poll-server
-/examples/ucontext-cp
 /examples/poll-bench
-/examples/send-zerocopy
+/examples/proxy
 /examples/rsrc-update-bench
+/examples/send-zerocopy
+/examples/ucontext-cp
 
 /test/*.t
 /test/*.dmesg
-- 
2.43.0


