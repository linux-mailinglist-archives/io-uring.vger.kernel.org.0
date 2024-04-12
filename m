Return-Path: <io-uring+bounces-1523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A9C8A2EA8
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 867F41C221A1
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 12:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285295B68F;
	Fri, 12 Apr 2024 12:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CqZYA03l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F40D5A78A;
	Fri, 12 Apr 2024 12:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926541; cv=none; b=W1jGXDexmgkfbfdklBq4xJLeJEVYDTVzUhtEOrHQO+aCaV3zxlDMkE0wa/f/PUGZA+fjZlqJQ37tsJaMBD4D6xIjb8blxxargZRrsyC59KXCrk0WOktcli+n86nGFZ82+M/3edUsdjPlCQ/TTKatAaIIcfKY+b5pdXxm+xNSUYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926541; c=relaxed/simple;
	bh=Q8na8989lPX4iGF0V/+vD30mjBtKTgqBFdLY9v2vZhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAf5UMl8L/BqtWCP/EkN5oKidqx0AXF9wMfKNniGA5gdLn2sYsVkXSZLV5qMNUw3KNqCf6cJ/BYP1o7xaeckT/Xl314+cu5Ti75d0EweCcdtSssuVmAztr3odvvTKEJ7cdzNXi+TBAlwP9Ldntw4O/qiAIgpC3QD4T9IK7qQneQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CqZYA03l; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a4702457ccbso104473566b.3;
        Fri, 12 Apr 2024 05:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712926537; x=1713531337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVTfXmYQqBxum6R+kJh5DuD+n6/0VKxhzLhhkJxZnzw=;
        b=CqZYA03lTLNFnWzYBW0QNZaLAuwldnoc1aFzfKfnZutSo9J3QncrplDhwzpJZKkPbm
         s/Wra2kxGQP9+8xJe1r4zjuUWU28NjFiUBZiCIbX6tanX/1dxAA1tHzJAt7lZH39OO1t
         2KY4zk/pF8xxunAFP3WE5r3c+8SJbW2V+iD9ZQdL7DVktkKNBICX2oxE1oboZd8Sks0k
         0moSx3FIYteehiGwxiEDtEdiOxgJBg6Zq23x38gfVWtGXbosAeHDapRNlgZ6aS4Yv2Lj
         lN+YsvuZolVTG/pZ0/fNbCmZgqc/NMePbi66gA9AoIfjKCc1pHrOx4cOwwVo/ZIseKTd
         outA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712926537; x=1713531337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVTfXmYQqBxum6R+kJh5DuD+n6/0VKxhzLhhkJxZnzw=;
        b=FtR9TunXDMydM4LX4UqQ8V8GwXUbaxNsfU8KjuYZcx3M8wDHVFuhNGnkXtAzT4YSXa
         J4fMI8nOb2VhIcljBVkhAV9E303eF4oYzikv354+wF/1HjGSF0JTiaz1uJgKOR+WBeRn
         /5cs1GZnZgY8n0NrJhGhC1zVcx4cZHbWZefD+1Q+g6YQjVAPdIc2Shwo7DQW2a+MbU7g
         B0jLnzKOaJfZRfdUJIGwjB0liQCEGpIIdFYs4NQ/fAYRcRvcD8p+AWYYI4Lwv1xL84S2
         YdqarzZ0RpWOO3/jUzXCNPgSp52hGUipE8pLSubEUUP06IO3zXbR+zheD5LePw2Ft4IE
         dkAA==
X-Forwarded-Encrypted: i=1; AJvYcCVrqyZk/6yx3+AgLHWbltM0TgemBkuSZIUL7qe3aABCUi3ko5yZP9VjPFKVWvHYlcK2DsWhOi5fh6ejH5HIGvFR3UBX/oVa
X-Gm-Message-State: AOJu0Yz0UswXDyESLLkgraEXhlJEYxsCXi4O7T1Y2TzQvrUNB00QkReX
	QoCH8l9D3HsDI18F1jjHGyeLmRL68jr0eZQWpZPiQvSBDYZEslGsDrLi+Q==
X-Google-Smtp-Source: AGHT+IHLSWvEjOsq6SbkhT/2e/UDGw8ttbjpSUM29gvy3OTJNkR5p4MvxipTNIjZ+EjXAkvXsBFrTA==
X-Received: by 2002:a17:906:354d:b0:a52:3b53:d58d with SMTP id s13-20020a170906354d00b00a523b53d58dmr871663eja.19.1712926537483;
        Fri, 12 Apr 2024 05:55:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id qw17-20020a1709066a1100b00a473774b027sm1790903ejc.207.2024.04.12.05.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 05:55:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC 3/6] io_uring/notif: refactor io_tx_ubuf_complete()
Date: Fri, 12 Apr 2024 13:55:24 +0100
Message-ID: <e836a2182b2c3733fc131d8bff26953884313d67.1712923998.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712923998.git.asml.silence@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flip the dec_and_test if, so when we add more stuff later there is less
churn.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 7caaebf94312..5a8b2fdd67fd 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -37,10 +37,11 @@ static void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 			WRITE_ONCE(nd->zc_copied, true);
 	}
 
-	if (refcount_dec_and_test(&uarg->refcnt)) {
-		notif->io_task_work.func = io_notif_tw_complete;
-		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
-	}
+	if (!refcount_dec_and_test(&uarg->refcnt))
+		return;
+
+	notif->io_task_work.func = io_notif_tw_complete;
+	__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
 }
 
 static const struct ubuf_info_ops io_ubuf_ops = {
-- 
2.44.0


