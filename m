Return-Path: <io-uring+bounces-7788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4ABAAA4D57
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 15:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E25F7188C3B3
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 13:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC8A25A359;
	Wed, 30 Apr 2025 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fXye02IT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3B4254852
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746019236; cv=none; b=pw2Nd4vE7S77QGDqW5ClouyxfZ3c8TIAQ9NaeVS8ONUiQL3LgwH87UHSH4svonuo4CAjC29dmfV5OPiLwt8AwX+IqhwhdmQjdqO44s59N1Z8X6gCW/iTYfrmaq29mDhRTgNLKY72Nyw3hzDc4VF9bEq1VSZkgBGOzigdtz2dKWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746019236; c=relaxed/simple;
	bh=0eFmUYgILcxq+Aa96fLO3XMiQA7OBWgNXp332ZXi6T0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=JrNxLA2DBb9ydEBQGnih+/cEtmCtnIfQYx3DYFd0qEIgw7Tm4eCO5TFR+4ZwpsHYDaIHoTf/rNasiHEdmIpL+7av7iAwlxKILx06nu9ZevesroEv1lUeDu1/xVPmOo4HrXgdPrLu3pMWQs8qGxd0p3aT897dYo5XFq5vhnrfKb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fXye02IT; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85e15dc8035so187277439f.0
        for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 06:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746019230; x=1746624030; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJkrDBQmU2DGIQW9dUTJ28X9ZuomwnHwa7eSUZZQyPA=;
        b=fXye02IToOG2xpn/LxoCkgvzQUnNIbehSieO9JSKEeVvoaFm/4DomHfJFB5/6M9WK0
         1jpN38LXRLJOUMVkaV8Sl8Fow6xRyoKE1AIPswvM8YyVx4a2+dI4FhPfuKkh/4J9M0OC
         qF6n/GScrJBE0hEYWxmbVMUsWIyb49DAuxVv34loWY4toVe8WGG+wi60JJxrlEfLQSOO
         VYa1xNgDiA3hOLcoqUcUFw6uNRVCtCeVzyuT80iZpAX17gO6m8mku1m/n8Swh5XGeeNx
         /nkJSgo0eIlf8RwsHkClrU/9jarPLLRkgrzTBfVwjjJ6dJdcah3c60kJu7tQH9vnJ9wH
         adlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746019230; x=1746624030;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yJkrDBQmU2DGIQW9dUTJ28X9ZuomwnHwa7eSUZZQyPA=;
        b=mqVL80Uf/822jMuhMm3jp4ZPRUeaXawKVtN9m8Yu+4MCadat0MizPja7W5b7jsRCP8
         jB9rB2c7tbXMgymPkDVawstlvRvDqgVaL1/QMmFgShcAIVs3J9Qkya+kh4uJgmQextgp
         nM/VsBBfpH3b12KuvcLv/j70dexW/USQAZvThrX15foMlR47XJLhKaECW3fAwqw8SC2N
         FLB5amkN6EuQThHWj0ChWQHMCDHx9yvq9L0ra2hXm+0rTUrnOFW8IUWhKYhr4kLLrson
         vYEtTKGyNsD6/0kgpbeMHf5ctaoUTPfc+6BVJ9kbLJMkfsMylWp5h6lBhNeP+LRT3Dpq
         UCkA==
X-Gm-Message-State: AOJu0Yw7iEn2Sp/fYGMfrlyz7eCbV3SWGgyyZ6JwqJ2+TS4mSD6bXf4a
	zrVVfNUda7y1jEi0foJYI8g+aSb19MqMnkWmSssZgbtgqBYa7maTwUknrRPu/PcVzRQ7Rue2kMy
	d
X-Gm-Gg: ASbGncuMhkxGVEUpFU2X3UyI53c7i1nH1763Fczn4P7YKyarigQNk9fKgrQqOYDcVII
	mz+j6giQq6qZ96ZnF9B8mVlp3JGURxmKBEis277OQDV3nxoMOSgjfO7dBM1/+zmcWMFKUdtZsX7
	A4oITPYMPTT0KXTU++Pruq+fkOFAtEoO4EvtTfbv/wTmktZfk4CC7pokuNLZ15yXPdHsqn7OVcf
	199JUEW135n9g4URavYnQzUnVxSxzHJdPtY7FoOk8JSQ67hIK2mT4Nf8slC24MHIRQRCEXiTgxx
	+uRWvT2P9SIH3ftQPCcoELqOCwMzyJwvwl8/
X-Google-Smtp-Source: AGHT+IHd/i1eeH1gwQWvVI6Kw8lJpesbgY2jMrMFWc2N6n8xlM+FvqgFHKDpJI7pOflfKlfLthZf/A==
X-Received: by 2002:a05:6602:b86:b0:861:6f49:626 with SMTP id ca18e2360f4ac-86497f92685mr269674939f.6.1746019229894;
        Wed, 30 Apr 2025 06:20:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f862e83662sm731364173.43.2025.04.30.06.20.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 06:20:29 -0700 (PDT)
Message-ID: <580faa83-869c-404a-a50a-ed8d35ba11d0@kernel.dk>
Date: Wed, 30 Apr 2025 07:20:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot complains about the cached sq head read, and it's totally right.
But we don't need to care, it's just reading fdinfo, and reading the
CQ or SQ tail/head entries are known racy in that they are just a view
into that very instant and may of course be outdated by the time they
are reported.

Annotate both the SQ head and CQ tail read with data_race() to avoid
this syzbot complaint.

Link: https://lore.kernel.org/io-uring/6811f6dc.050a0220.39e3a1.0d0e.GAE@google.com/
Reported-by: syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f60d0a9d505e..9414ca6d101c 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -123,11 +123,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	seq_printf(m, "SqMask:\t0x%x\n", sq_mask);
 	seq_printf(m, "SqHead:\t%u\n", sq_head);
 	seq_printf(m, "SqTail:\t%u\n", sq_tail);
-	seq_printf(m, "CachedSqHead:\t%u\n", ctx->cached_sq_head);
+	seq_printf(m, "CachedSqHead:\t%u\n", data_race(ctx->cached_sq_head));
 	seq_printf(m, "CqMask:\t0x%x\n", cq_mask);
 	seq_printf(m, "CqHead:\t%u\n", cq_head);
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
-	seq_printf(m, "CachedCqTail:\t%u\n", ctx->cached_cq_tail);
+	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
 	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
 	for (i = 0; i < sq_entries; i++) {

-- 
Jens Axboe


