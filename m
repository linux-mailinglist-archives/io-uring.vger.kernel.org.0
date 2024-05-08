Return-Path: <io-uring+bounces-1829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06A2C8BFFD3
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 16:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 379351C20F1E
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 14:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF9185279;
	Wed,  8 May 2024 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cWB9gKqa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762454FA3
	for <io-uring@vger.kernel.org>; Wed,  8 May 2024 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715178073; cv=none; b=nuUPQHjr74gIfueizzAqACS6tBBNqoYyCp/uyC0yUV+C9uemTkWi1Og4TxJ2FRddRhJLYgVMLGTRbVJkP1HIoAayCULD5RNoLYHDsKBSy9aiJasmB6W8QshzCwWfMdgbH0ySm6Vz8+p9XWD8PRUgZQ/AnmxF3kXmHaeK0EVn/4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715178073; c=relaxed/simple;
	bh=hLDlwhM1oUxd4YBGgkh22gACkhdJJzRv+8IVx2yWVgA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=aRwtB9151FJKRM5HpX4kiLUViv6smyNx30Wk02XN7dXjg0f9qMHNd1gsm2zldhnjizq9hW2/fW5RznsYYDNnTOyi64BzVLlm2DmPXMOf8yzpByGrDvntg0t3N7OVP4e2y/pUgNees1EBuFSiW+2YVI+LD5W2M268hf0pyAPXrK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cWB9gKqa; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7e195fd1d8eso5344239f.0
        for <io-uring@vger.kernel.org>; Wed, 08 May 2024 07:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715178068; x=1715782868; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2UKMChJmzWKP9gSvUj89ICj0oGGKm10pdoam9SNerjk=;
        b=cWB9gKqa1j4ddOFB/vL/XFpUneTDuOLE1JxDjCJbhnNz0UF+MjdXUj2tdUizsGCUzh
         7BMza8ave8nY4SKHwaP8vF3tkNuGZ8jqHZRIFk1vgCK18eg7Aq4JC1VQ6XEPpQ0Ts0yY
         UKk5fLyJ9R2yEa+yZhSYdLxi3cHfpBXtBKUi8skF2m+wMu5I8zJNyPwgEW1fovOsfOuT
         PUy0uJJtf4DoPqJIJghm1fJ+KF1FSMdqAx94YWEZTmz+xdtioFg9dVZ/y3CEXR8Fd1Hx
         1W2U8QBnNMIWq8G3MYQLgYDoBSWpGNAOAuNIWjxEtU5DkpAWdwX9Ga2KywD/ruK78yyo
         rvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715178068; x=1715782868;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2UKMChJmzWKP9gSvUj89ICj0oGGKm10pdoam9SNerjk=;
        b=nWbbGs9xY3nQrM+l9DDFHfBakHX8HCxMsimDBJRAeAgNmJI8xaEh23Eh6MV+p5uYcG
         ME0sHMaZweIVzkVYESOz/SrtjPafzdvcqCb/hEpjZLHsrWs6qJ+gMarlFHAATOMPknAi
         V+HElZbCBGnAoxfQqm94V0vZzIPybOGU7Xtc+BTekwn4onfZFhMTSCdx3OEcx8evRpf/
         ChwVOkbXSdBZYvWADj6+77vw6VBl3qyVurnWSSay2jr6Ko58uKPGpc/DVo3o9C2lMOwa
         tJ0hCXReCQ3mad4BD2F64XFQ8JvgDx56bxeTphV2BZAR082akgzNDKE/ull+IDq7wIzW
         Kjqg==
X-Gm-Message-State: AOJu0YxFRiQXtSJ/X/k8hxnK1StWIufDxA7EXcAq1tQFEiFWJjdDxCZJ
	yVa/aaO72sUIVL3kr21yq/7tNkIk1BPTAhycz9BdAM3t8sDHIgPbqJ0wUAsccA6k21PQ4K7/GQi
	X
X-Google-Smtp-Source: AGHT+IFDUcZslUcE/tQbMhhFS+bClYUeCMVUxQSlaCEF7xwjKJKt5Dk4sPfBlzQEOkaKMBHMBijSoA==
X-Received: by 2002:a6b:f319:0:b0:7de:b4dc:9b8f with SMTP id ca18e2360f4ac-7e18fd98a9emr279297139f.2.1715178067643;
        Wed, 08 May 2024 07:21:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id jj6-20020a0566388b8600b00482f679c6c9sm3586111jab.68.2024.05.08.07.21.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 07:21:06 -0700 (PDT)
Message-ID: <0dbe5c36-b2b0-4f56-8c80-f56e09213285@kernel.dk>
Date: Wed, 8 May 2024 08:21:06 -0600
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
Subject: [PATCH] io_uring/filetable: don't unnecessarily clear/reset bitmap
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If we're updating an existing slot, we clear the slot bitmap only to
set it again right after. Just leave the bit set rather than toggle
it off and on, and move the unused slot setting into the branch of
not already having a file occupy this slot.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 6e86e6188dbe..997c56d32ee6 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -84,12 +84,12 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 			return ret;
 
 		file_slot->file_ptr = 0;
-		io_file_bitmap_clear(&ctx->file_table, slot_index);
+	} else {
+		io_file_bitmap_set(&ctx->file_table, slot_index);
 	}
 
 	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 	io_fixed_file_set(file_slot, file);
-	io_file_bitmap_set(&ctx->file_table, slot_index);
 	return 0;
 }
 
-- 
Jens Axboe


