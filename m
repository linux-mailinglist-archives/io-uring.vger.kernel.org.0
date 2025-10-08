Return-Path: <io-uring+bounces-9928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E937BC4DAE
	for <lists+io-uring@lfdr.de>; Wed, 08 Oct 2025 14:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5EEB19E1E73
	for <lists+io-uring@lfdr.de>; Wed,  8 Oct 2025 12:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924672494FE;
	Wed,  8 Oct 2025 12:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3wOw4R+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFADC248883
	for <io-uring@vger.kernel.org>; Wed,  8 Oct 2025 12:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759927052; cv=none; b=pay2yUSos1HNCkjrcKhxWGg25GWfOpH+EXCTLapTBkih0Oaf00thQww0pODjcre5lm9FMO6QLHnbQugslJQSrcD61pphtiQA6mjYfTJUcnnnqPCXjrqsOczZ4ivpR0TtFl+xfFaoaIezNk0s5A+RT2YvKXpBl8nwpdfhyHimlAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759927052; c=relaxed/simple;
	bh=V0yyKxqZgbFO/0v6WO5ujCe0dE9JkSsBVJjkd3iB3MY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U3piYmuTbUxAsYvkZp0QDJlowOwLlvMaWbFrCYCmvfjuLozManzgZUT7RQy5cY8i3UKRTm3SwI53RJA+vv5L0kNCgx/wnbD919JCOPqJPrA4YW24L+A6ANmyN0wSKXpLKv2eqKYBDtllFaVlLMjdsvKAx08+DFYUIfJZK3vYQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3wOw4R+; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso6590203f8f.2
        for <io-uring@vger.kernel.org>; Wed, 08 Oct 2025 05:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759927049; x=1760531849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E2TnAZHPDozLT5yZkEQn3hUFYpt7Se4zx7CRpBYQteU=;
        b=O3wOw4R+3mpFzsTbjWPo7xmxvqC7o9eL/zeXWB6zf6doU/HrlHW4xirCdykDrCJtOs
         EagQgH4HgbcqUUNii1c2i3ATcavt8Anh47RfErpDDyNhtOBLQ4XjIoUWdWk6CNGtGwCO
         CVDzt1AsUktpk2O0H1Q9C3D7rsAEWNZHyX3KWrRVhhq2UQgulYfGgCWmckp1mRjxyEyP
         2Eu1QRqpcyFF+zNPEattuAQvWMDUcCfIK4Rus9k3sAjhfuG30SaMP7+THnHrMFiqp+CW
         aflVMijw1EPXB4DEZzq2c7TYbYDSoNyL4Jgd5VweG7sfYrrhGouT6qsY5g2XppccsIhd
         97OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759927049; x=1760531849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E2TnAZHPDozLT5yZkEQn3hUFYpt7Se4zx7CRpBYQteU=;
        b=QPSBpZ369nzcJOStkJ+33CQtbE30Aqw0MHf9n8FzFGc+WtRmNlo8JJ9WcHGnE9IkGZ
         4Y1UJ/VFsL86NbeuCORqgLIOCXpHfV2UOX5QUtuQSts0gqEFRJFSc0Zkmw2oKffcxJOK
         3zmyt8TF7rGpOKwt+5340zH9/bYB0z7m6uNepxxZiP/IsJrFWm31XdzVrbDd7I3dxYXq
         nWJLB6FgDMOXYtrUKKrFUNjdhf6oWRw4RK3GlNpUCtm78MDi6vG0wB746WE2YPTLhHF6
         PEJV8BvayOjV4HRojVdCl42gtsmcYoM88VoYRH4erGIloP6kQxJzEdkhaDJ19x0ueGqZ
         y0NQ==
X-Gm-Message-State: AOJu0Ywj3fdfQ2eJW5uywgYi2ekXVaUE7IefZsUXtgiVyDrwbWjOUMof
	lY+k3yjIP5nDGEpnXOpOwxWL21uAXsT8eW4FT7hgHVEM5LmSg2eykJ9I+G9gjw==
X-Gm-Gg: ASbGncunIbu/j1O6F9HbOj3t6ft2mS/FYUXb8Pi0aq+UMJS7hP+kgr1Uz5ppVjyzpzv
	5AJ2BpeEPGK9pMsfgLco3TtIR/Ukg6L7ETjYFk64Tjteb9ScqGvNHmKf1dHfEppGXgGX4h1u0zi
	90LvIHLtbiOmjzGaw5T5sKN0MWH5EoLBEz0039kln4RbbmPvdxvMZ4sRJj8nLfzUUS8lp8XE3DI
	O12gYp2vDu3CPr4FsbI66YiyM+EjGZOfC9ELF8vgk8UQY3EkgVE+gJKacRxOS4QOXK7D+y7Y7qX
	YScULQCrd8lGhR6Z+7WwA8/0kpBbeJ6rlXJmYq9PPUHbXWXZpciBMPUK1FMSFlEaPusIPlijikW
	tvXeeBgDdx3Rp4KWH2QGlXrgOqVwLjGrS6mZPmgoO
X-Google-Smtp-Source: AGHT+IFw4s1qDph/qnRfxEwZxh0I5sK3smzwrgDVM16o1rujr89ogmGIxIuGoFXY4FIUDR/y29IEaw==
X-Received: by 2002:a05:6000:438a:b0:425:86ae:b0b with SMTP id ffacd0b85a97d-4266e7d9330mr2343788f8f.38.1759927048667;
        Wed, 08 Oct 2025 05:37:28 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b002])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6b8bsm29727055f8f.4.2025.10.08.05.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 05:37:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: increment fallback loop src offset
Date: Wed,  8 Oct 2025 13:39:01 +0100
Message-ID: <1b3a55134d4a9a39acab74b8566bf99864393efc.1759914262.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't forget to adjust the source offset in io_copy_page(), otherwise
it'll be copying into the same location in some cases for highmem
setups.

Fixes: e67645bb7f3f4 ("io_uring/zcrx: prepare fallback for larger pages")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index eb023c4bc0ff..0a43acbdef98 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1079,6 +1079,7 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
 
 		cc->size -= n;
 		cc->offset += n;
+		src_offset += n;
 		len -= n;
 		copied += n;
 	}
-- 
2.49.0


