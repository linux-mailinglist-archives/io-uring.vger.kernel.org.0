Return-Path: <io-uring+bounces-5152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A939DE85C
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 15:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E40C163710
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539A84C9D;
	Fri, 29 Nov 2024 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ajW7rprp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09451DA23
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732890294; cv=none; b=n3SnydJwGfanf0ZDRpPY66FjrT/ns1Slo7DiThBQ0/9ssHLvisIBCUMHeb+idGM/H9FvvZWnW6Ltq2gLasF2zZWZiegN9NuRLu6t7wp8S879yFwWYJUSFFuvHoPtkFczV5Idlj9rGWKcmImyYUQrAlDm/C80KYKk10opgT5izw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732890294; c=relaxed/simple;
	bh=78/GHYILp3TDWgld2pBYkjmeZ7jNr8iurkPDdI+F4os=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=AHx4FGrnm59gGslRIwHkXWmTF1oJfHK3i99/GHzPl4e8O8GYU+OuAix6LaTxoqkhzB2VbbcCxRkR5iEiuTI/N9xDjYiL+gmKAksW+omelTuJYXtKGM/bUvQ9BKHL8fVpL8YpneedpwGxmONblQumZELkT0xBE+FzveUNsufXCuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ajW7rprp; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7fc8f0598cdso2018857a12.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 06:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732890290; x=1733495090; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5z1pyNfiiMsXiyKiAhr3SDLSW0JkO7tlykp1i5DiBc=;
        b=ajW7rprpIHEO+g1QPSGXp8Z15Qg2jwrFtki1KDyZPLFRs6XltErIncMz7bd5nd3MUR
         HejAhsoDMJXXW9ikNl1R2rRig62AOlAcEvMFOGtyzVnuUkKKSakIhnJ711TXHA0rdDgS
         cmOl1eJyH8Wj5Mp1SCHuJQ1qMTJf2lxM9DkKzi0cw8SHgzPbn7pMGZC/9vHrNAMFEaRc
         /yW39AxdXt51tIkFuTkmiaOjxhCIkQXxKqUFnoLYA/Y/30NzFzLJKRPNqg8HeRqOjUnD
         fGG0Xq7jJK8mS3RC8AAsX3XbqvOrxPU0YRp1FGgP1gWVyisMIu1Kuht1twVf/o0HBPbT
         LTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732890290; x=1733495090;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c5z1pyNfiiMsXiyKiAhr3SDLSW0JkO7tlykp1i5DiBc=;
        b=eezsLj2bNBbADHHErtzv5nb/nIXmE40x6YlTRiKx7FOc0DijnrYEAvA2hsLyG3zCuF
         GeDNHBuu9GkVC5rL3fODiIK74KwoCk1L3FQUPP1kDc68gkliF8ysSp4DNgFZvLPbDT70
         GjL4LdZTICHjJLBBbX51f3708/GszI5u87gFsXG6RV/PiY2u4u64LSNwK1w72jJ7Z2Zs
         5jwvYVj17uHWHh3OTwRAuQcvZ0D9Emc9VSyohXG3n6RaoXwZ34js7L8eU4UDBxo2I6Pm
         KX/hCzI/dMVon8LXndrPIGauza8Mp/ijck1Cpwp44zLK413n+Z4G4D4EosV0Axraoa7Y
         yc3A==
X-Gm-Message-State: AOJu0Yz5qmrs20qB3EC4KipJD5K61aYNmLjglLJ81j7k2l/bBTBmGa3b
	TWeQ+ZvtDs309JPcItKJL/WtnhhfhANFXcNqrK1/Mf8Iq9ufRgYuv/YGXQ+/Tu6udoYaaZh7RXQ
	W
X-Gm-Gg: ASbGncsf5GDJTsL84X+l3RnjsFVwq5ktBz7QpTA2s6uPURu1JBy0xieN9OacmnowMB2
	NXgWcMw7ilHADSmLg99UatR4JFSEU5Q+7EIX8ZMIGJNufaBAHFxT7haSc4+GtvVriK4ebuB97Hl
	HKTaToPlyoRBdumq/BNQ5H+l0WS+ZlWtiYSdrXcGA6vmCWEfHKKIuRdDjKJEbJzXt1QcpUvcRVU
	zt/jm+FxtAFpimqJH0Y5AiwH84FWdtdaCTfGHitBGgdlNU=
X-Google-Smtp-Source: AGHT+IGv/ozhMRhhEpkVKWHelm9EXL8mB5s3CDg+3MSHdDSpf0Sx3LXQnSwlpTjzxLxsQ53kAITKKQ==
X-Received: by 2002:a05:6a20:734b:b0:1e0:c713:9a92 with SMTP id adf61e73a8af0-1e0ec7fcc77mr13722373637.6.1732890290212;
        Fri, 29 Nov 2024 06:24:50 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fc9c2f7802sm3143655a12.27.2024.11.29.06.24.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 06:24:49 -0800 (PST)
Message-ID: <7c857055-1ab8-4525-b9c1-5de6e6d1c3d6@kernel.dk>
Date: Fri, 29 Nov 2024 07:24:48 -0700
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
Subject: [PATCH] io_uring/tctx: work around xa_store() allocation error issue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot triggered the following WARN_ON:

WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51

which is the

WARN_ON_ONCE(!xa_empty(&tctx->xa));

sanity check in __io_uring_free() when a io_uring_task is going through
its final put. The syzbot test case includes injecting memory allocation
failures, and it very much looks like xa_store() can fail one of its
memory allocations and end up with ->head being non-NULL even though no
entries exist in the xarray.

Until this issue gets sorted out, work around it by attempting to
iterate entries in our xarray, and WARN_ON_ONCE() if one is found.

Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/673c1643.050a0220.87769.0066.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 503f3ff8bc4f..adc6e42c14df 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -47,8 +47,19 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 void __io_uring_free(struct task_struct *tsk)
 {
 	struct io_uring_task *tctx = tsk->io_uring;
+	struct io_tctx_node *node;
+	unsigned long index;
 
-	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	/*
+	 * Fault injection forcing allocation errors in the xa_store() path
+	 * can lead to xa_empty() returning false, even though no actual
+	 * node is stored in the xarray. Until that gets sorted out, attempt
+	 * an iteration here and warn if any entries are found.
+	 */
+	xa_for_each(&tctx->xa, index, node) {
+		WARN_ON_ONCE(1);
+		break;
+	}
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
-- 
Jens Axboe


