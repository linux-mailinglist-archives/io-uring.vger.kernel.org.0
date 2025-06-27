Return-Path: <io-uring+bounces-8511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2A0AEBB50
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C10AE1C26F4D
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57D52E88BF;
	Fri, 27 Jun 2025 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FNzlvT3H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FAE2E92C7;
	Fri, 27 Jun 2025 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036983; cv=none; b=lv1C7deN3u5zEbPf6RjWbBe4+y5OTHFJUBU05yFUCUN2brCiN6KRIQLaoD7k3ONdVSGnKpM5LCbx4Mjj9GxUpE2j1rqelDJSqYTg8GGWerpS4Xz1ta2MvAS8j63kXt+ak0RfcFH3HS3nxveRGZKIk8JOdL6lqb/bSjyUPk1K5w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036983; c=relaxed/simple;
	bh=t+f6rX3w4xlusMkmqSZ6hI63agsZzYsRPQkVghduXl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrEn5pB8AOMz19YbOQl6zLMA/wo0o4F/rMQwb403mrOKJ0Vece4auj/mZBOa0BMS9F5emHs6UTN6k9OPbWP8uvVQ1tNnLVO5ItwqBiHducKfTfQ/irh6rkN8UUYPLN5/SGCBxTgDHHprcT824C2GjNrs7KDugHtfgA3jLeuWyvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FNzlvT3H; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad883afdf0cso439672766b.0;
        Fri, 27 Jun 2025 08:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036978; x=1751641778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wkcKconIajPlkNpXoc2+RGKTPswyf6ZT5ZP2qLcpYQ=;
        b=FNzlvT3HN+sfIdoXTAWBFFHHj5fDfBZZO27Nf3vKdLRN9hDQZKHgeQcRzH/+k1OzQ5
         KqCvtL45fI0WMKvEkzF250H1k7Psji9vTh1BXddy/aV350lYBfabVb2RVJvuNOJJy9IP
         LrE0fy+kok3QzmYliAycPNbPUcb7vTlAF3u0AZY/enfPr9I8rnHskqZzGurEd0R2fb5J
         vTKHb3ZO0g4f6JOa5ZG9ZDhBG7aFiKq9W3DWYS294iia2EN8IA2qJDYLKYF3Np2+s5N5
         GzqnJxpadwwptEejM+ixkOtnXVCWkdTfz0+fi8PoZKHomXu4Flff7KacZk4mcXr1soHo
         TzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036978; x=1751641778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7wkcKconIajPlkNpXoc2+RGKTPswyf6ZT5ZP2qLcpYQ=;
        b=ZABBh1URkZCCDdXX8HA4VdTXodk8zDNqNdx9fubKsQguK5ympknTXE5YdCCdIe7UQJ
         hNFwMRi0DL718vT+X8MV3JE6ip+lQ3O5dL+l1xdPbOBlBHubMBLn9NFqnZhGAMdRhkRM
         66q6YUa1fZJTq+Npjr+FnhgsBWZ65Nj7bkwwRO/anfPNu/iS+NcAgl6g581Hn5kXJu6t
         cWvJvSqKhIqZSUEO9+bgpU8BFtYv639QBaXysDT2bNygGIhJ5/DbgRx52oN43wDizFF6
         xElLns3VUk1uVknet7FS+hFhJZ1hA2cxBFa2GJmnTZ4CegskS086bt+9j88GTb3pqtcH
         lFVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdyVsOvB4o0623YINzwUXlbVyoMjZ//UOXRxkIXTG8p2022O+u4FrC3yH8Sk4x8cneFHiN7Yt3E7PZxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbBYh7iKMforgr4S4p4lzp7meqgfgf7zylWTTH5uLPexsMW6Zw
	yR7/SkUzdVj/UiUsbuUFURtITqs71puetepkhdGswMBcK1xfL3Pr1lFI7181+w==
X-Gm-Gg: ASbGncuOinxoW1fqyljNp4hbWXWNip9nt165PI6zi/7zg/p3Hp4RuN8BmzCEArjxAeE
	lEaNJv45ej66t+EycxzGBxhEF1VxYQzUepbqI4nMhfsu/JklaDIq0jcNu1i0CpW8EO4EMZxIaHU
	wPVfwTrwkZMuwBBZMYWDmqcGckauErNbppWqpmm6D+1Z7wkNIXduPIIzsRSZWVs1rX+z55kM8n4
	y7UGAPL5Upf/y+cqiItc0cfpj4iHpGibkauutRoxoyS2agMMidStrtk3f14t8KWPinMCwoyGR23
	0RtMc7SbHxLZD367/sG3DQ2EJb/fxMtC/afZUXqu7kMKNgvMWI+EtH9qOlLMkByADr7rLMl48uJ
	h
X-Google-Smtp-Source: AGHT+IG9bytAnaxECDeI4HYr6CPYTTXP/6RfPwmtBJI0OPbHOa1VZ53IIjpM3ep6pvmZsW8jwWZQLw==
X-Received: by 2002:a17:906:dc8a:b0:adb:3345:7594 with SMTP id a640c23a62f3a-ae34fd463eemr295747166b.9.1751036977798;
        Fri, 27 Jun 2025 08:09:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 12/12] io_uring/rw: enable dma registered buffers
Date: Fri, 27 Jun 2025 16:10:39 +0100
Message-ID: <dcb53f0011913630e246b7e57ef6872f3716e762.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable dmabuf registered buffer from the read-write path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index cfcd7d26d8dc..78ac6a86521c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -372,8 +372,8 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 	if (io->bytes_done)
 		return 0;
 
-	ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
-				issue_flags);
+	ret = __io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
+				  issue_flags, IO_REGBUF_IMPORT_ALLOW_DMA);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
-- 
2.49.0


