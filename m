Return-Path: <io-uring+bounces-6054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F5A4A19BCF
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 01:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D837188D78B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 00:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426C846B5;
	Thu, 23 Jan 2025 00:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uFMbUwoo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2261DFE8
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 00:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737592351; cv=none; b=euQ5jpr54D17eE9Q+cOEGWQszcUnYQm/qd4ih0atcuVSvhGqFKJmbdmoONzB98oV3+kheRxVSZInBWNy7aDPlYVGj8HvABFLvcSfGVKj2r8Qmpcvf8q8CvKLiEGNmOLSS3Z0QYB9PR1xBup2f0PijtiY+4+o8s94y1A1pRRiZWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737592351; c=relaxed/simple;
	bh=7nATugSeGc2Uwh5wrb3lV0SPpNfUD8EOgHQGxEzGg18=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=Q5CBIGEow9Uar2Y3mZRubdnzhRfVAHFQTwvQxGnbGi2b3ta0/a0HMDj/UoaoTLkMHHFiQ5JYe20r3FNWDKi93UXtFBxCA/RqNxXkPIAnJC0BbwrhtVcXuCpypsf3fYCh8d/rB7sByHHXPGCPGAOsP3ys9gbGmRlU83/PXvtfHeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uFMbUwoo; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ce85545983so1277065ab.0
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 16:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737592348; x=1738197148; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7V2ioFfzxL2YVmuaP9xru2Gw9+UmYZ6MZlSVF+MOTk=;
        b=uFMbUwooah0w5mHTEZy7K2f1E/aLDk/pmeuzSU7GM12QLM24Y2q0yCwPmT7gntNEQE
         46wAQ9BjhvIVoUs02UuRSeygLSsZ1ym+dIFR17afQQPkO4y+4df/j7SQzVQiBfIo8NQC
         s6r0MwKIarFxs/cJB2y/I+EStt3HmUHqncp/Vr7BPPnOwAPESxYtjCPfhH8XdcCqe1J+
         1IiAwl6m7nhBglXPc2/rRTbtH2fdNoTRnlny1Yn4qidmaqoKdDO1IzF8qx9gmWfBqvof
         YToZmAGRc7yiCOlrpbPi+zdUgOpIFEvzIJ7fFx4B5iV8/4pXEiO+DN/fDBF+RC/fHvQE
         vCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737592348; x=1738197148;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p7V2ioFfzxL2YVmuaP9xru2Gw9+UmYZ6MZlSVF+MOTk=;
        b=KjxuAWDKvRzgTbU8Pho4fO+PxmQLGlDv9XdbMemGczpL3+qGwSgD47WWxgthJFijQF
         8QiUeFVbLPjmZvU0QZXrkdUPAFQM2qhAccnWvH8HviTmBJC2XUiDueOduuUul3LWWHCN
         ySBsL6lCi05AVYynDNkRlGxAnRK5KVzYuYDe4G+Ofu9ccKlwS7kCGS2UC2TyqOTNTkEg
         Kq9ZnrzNCnuNIECc+mV8bkUZ0nGeiZGHen+eRwsGebtxiaosnWdXrbInJXz+ichZUP68
         ee97ngPM+H/UPb7fslMlXcanZWcUMMRsVZKiFBGMYvqKXgL6TO5aUuGpBUurtcvy1jOQ
         8nnQ==
X-Gm-Message-State: AOJu0YyZT5DsZq8cmsaOAwmfEa24710J9niEBUA37fA/hkugf64DecaW
	r0hepVZj2z+pD1hGU4cs38DUQm/yH3nbpXXg5hiAeLiCs2II5xFTIN7Lj952QEmyBJZgD60Z1zj
	w
X-Gm-Gg: ASbGnctUE4hUgLOKvyKlMdnZtj5tcirpAWamOwkvtYOtnsPSHknXxcn6UA1bZycCzDd
	XmZv+hw13h6opHbPeExQMOle2mkdEjN3dPFF4EyPXHV4/sFVbjey4HX272S1S8ZyZhYnn8t4FR6
	EaXOqj3iH9zzIxQJMhJ5FOf/9gdEcc+ySH7tGWHwPvII+NIYrRoGksGWS1ahBVS5b05wwGvDzgF
	knPmKJTPbWWPk/GO5V/LHCHGudnUay850dwzOuShN6cljRT6t4Vb9EtLtviXqARoaA=
X-Google-Smtp-Source: AGHT+IFZ04wFQU3KRgfgRbrT2AQDpeJ2gyPKzQTnP8ato1K1ze+W7haIlGdV9FTpOj7eL3S2sIdASw==
X-Received: by 2002:a05:6e02:450b:b0:3a7:e1c3:11f5 with SMTP id e9e14a558f8ab-3cfbc16e8d6mr12103065ab.6.1737592347817;
        Wed, 22 Jan 2025 16:32:27 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cfb4ceb471sm7112945ab.22.2025.01.22.16.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 16:32:27 -0800 (PST)
Message-ID: <5301f9fd-70e3-4156-bfe2-864adda9b71d@kernel.dk>
Date: Wed, 22 Jan 2025 17:32:26 -0700
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
Subject: [PATCH] io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()
Cc: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_uring_cmd_sock() does a read of cmd->sqe->cmd_op, which may look
like it's the userspace shared SQE, but it's a copy at this point.
Use cmd->cmd_op rather than dip into the allocated SQE copy - it's
both simpler and faster and leaves less room for confusion.

Link: https://lore.kernel.org/r/20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index fc94c465a985..3993c9339ac7 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -350,7 +350,7 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!prot || !prot->ioctl)
 		return -EOPNOTSUPP;
 
-	switch (cmd->sqe->cmd_op) {
+	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)
-- 
Jens Axboe


