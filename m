Return-Path: <io-uring+bounces-8433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 106A5AE0DF7
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 21:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FFD13B2FB9
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 19:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB70221D98;
	Thu, 19 Jun 2025 19:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="e2b/efYD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FEC23B625
	for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 19:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750361280; cv=none; b=ntEv2h27Ngt0M46jPRXYgOxxhOTSI0LeRVjwwcVoQbFfg0vNhjmeVzLABjgGAV+EbwtZzWGzc9uyLcwG/OTwKIzSQIHwh3ziizXjH6ZP6zU2wu40+mwn1wPJRzc18TJUmDknLg7Yd/+gCulD3vQKYj+22PBqHcAELhxo1yuwb6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750361280; c=relaxed/simple;
	bh=7hNsEhABE0MDxTWghxo/fSZvRqPJ7Q0SQ5s7b9NdLn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBfhDbWN83rjhBtEcNsGSBVlue0YK2LBeQeMC5d7byuqO4Bl/tZ+gYk4ipU1KEVhBTPOYfQ9zDxzm/cinFRY4FM5hnRFDwqTXyvc2J9Gkb5+IKEw8GwzUwl1G61jZBJYWYHIgukM/HNKnUgx8MrzELuHrTzuz/V9iwr14x0AVh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=e2b/efYD; arc=none smtp.client-ip=209.85.160.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-4a43f17c42bso1250471cf.2
        for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 12:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1750361278; x=1750966078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sL/gnD+RoXyhkM+7is5bQz7YiFPCrbWYEFKrkuC7LHU=;
        b=e2b/efYDRBZyc9OlMjY3ceghHYSrNX2WOvBeiFN5gV0gBxeFRToOmbD5ufcp/d9/TV
         9QahCsh0Fm1XJhyLYrj2por/u/V2lfbjtxw4Zp+0agUFCdn6Qffusmho0FBduO/5lyAN
         /UfsU5N0JmNUPJJERhAACR3pCZhdMh0g7/ZdNzeIgoBUr3uJQkliQVI7m7kAk0U0NpA0
         ef88hXzzgkorLbc415WY7m3EfayI7bm5HoSmEczwQ9Mbnk7RG4Itq4J66JuXfPEa6EzU
         d5tGdy5LCTrO3XliKIYCm+9TtKgmyXFBOxQLn76kR4iP24OQogvKN8h2zwa/qV/40KZ9
         7RbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750361278; x=1750966078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sL/gnD+RoXyhkM+7is5bQz7YiFPCrbWYEFKrkuC7LHU=;
        b=NgJoKOKHsKnLoJboI5dSR4gatiRPwgTQgtgFYjrmREUj96BLNqO/skV/F1UL1IhhqI
         9WHQEVPfkqOfmtDtPhzuLjHnItZot9zOkOxVMLmHVFb22yurVLuLBevXnyhLt9uIjB06
         UOVrtF64dlqQUF0E5gDwc1CEtecQTEKz5plpRa0n9wupe0RBj/JPHUAEsBGUuR1BnqR0
         5/XGV4jrWlImhhcd8KDdRa/r5shwt2uUU4M7TSepkzKD6HdBTX/yyjVZceRJcjM0flvZ
         AdnaVpvrv40Wybqd6qwFffySNzbwDI5Z+TH9PAwwdzPSxULErFIlQPxxVhjO1dKybX46
         XfLA==
X-Forwarded-Encrypted: i=1; AJvYcCU7lsQuoW/r+JQVDQIW/JMpMuILpi73hbW+UYNKmyxX5yuLU9Z5mcjWCQ477FJ3A9oV6Fe57TUsqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoaQsjMzF/f8L3pysARmt/cVRAPCYi0TBTiv0XXqEyr4SeyQsM
	qeXM+QDIF0q4yNZ1ynOiDeYRUIuKgD4sNTLeM0zFxhP4m/zMNiuheWrUlp8mtp8qJem8lVU8ssB
	jyGPW+KFgUHz4fMFarLu0tuR90ZM4tsBEFlcG
X-Gm-Gg: ASbGncvDPGRCNNDPdVxoLtBbThzIOX+KV9IF7RQiPwKQkJQF1hknG1hrcO6vFBvMgc5
	pbCQcaKn6ojNQGf6eGPiQPOgBkUZ6n1VAi3/1ypIxWKU7xuVMlRhrxFKi+jcZY48+2loATU9C7c
	VrVJLUSp7m2IxtZmmdOy1o9RfcGHbSBv9zq3+STwq9XQrOjUjpeky8wJp1R92ZU7RfsyfS0h3ZB
	GL8VQM47aW8NU8+tpKoIHNctFou7ZA5o56FbxdxpdIGJHHjq5+r+umcxYgjmW+8GkVDJ4Y7ni3J
	pSylABJ8u5mc8U5uCEcMloH383+ArTDPF07OKbHTBOcBfeDiP5vkzHo=
X-Google-Smtp-Source: AGHT+IHzFp7Ayin7ZLuxdt5epZwacsJfi24ByOHXtA/2tQ3yV9AYUgiGyGENqzR3VrIwLw6XQlKq/HIcpRov
X-Received: by 2002:ac8:5704:0:b0:4a5:a4d8:3a6b with SMTP id d75a77b69052e-4a77a1aecc3mr1743701cf.2.1750361277885;
        Thu, 19 Jun 2025 12:27:57 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-4a77a157998sm71631cf.13.2025.06.19.12.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 12:27:57 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D4B483400E6;
	Thu, 19 Jun 2025 13:27:56 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id D2579E4410B; Thu, 19 Jun 2025 13:27:56 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Mark Harmstone <maharmstone@fb.com>,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 2/4] io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
Date: Thu, 19 Jun 2025 13:27:46 -0600
Message-ID: <20250619192748.3602122-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250619192748.3602122-1-csander@purestorage.com>
References: <20250619192748.3602122-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a flag IORING_URING_CMD_REISSUE that ->uring_cmd() implementations
can use to tell whether this is the first or subsequent issue of the
uring_cmd. This will allow ->uring_cmd() implementations to store
information in the io_uring_cmd's pdu across issues.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 2 ++
 io_uring/uring_cmd.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 53408124c1e5..29892f54e0ac 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -6,10 +6,12 @@
 #include <linux/io_uring_types.h>
 #include <linux/blk-mq.h>
 
 /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
 #define IORING_URING_CMD_CANCELABLE	(1U << 30)
+/* io_uring_cmd is being issued again */
+#define IORING_URING_CMD_REISSUE	(1U << 31)
 
 struct io_uring_cmd {
 	struct file	*file;
 	const struct io_uring_sqe *sqe;
 	/* callback to defer completions to task context */
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 929cad6ee326..7cddc4c1c554 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -257,10 +257,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 			req->iopoll_start = ktime_get_ns();
 		}
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
+	if (ret == -EAGAIN)
+		ioucmd->flags |= IORING_URING_CMD_REISSUE;
 	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
 		return ret;
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
-- 
2.45.2


