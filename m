Return-Path: <io-uring+bounces-10657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A99B5C6C67D
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 03:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 6C1D9295DC
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 02:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8DB928850E;
	Wed, 19 Nov 2025 02:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cW3kC/S0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4463288C39
	for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 02:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763519796; cv=none; b=MG7Hel7b2xIhkVh13TAmtuhvqTuY1KTOFlGEeytdJIFjOVCsVv/8x0zIfSzrjerZtBbvt4Wa/KwRQA44Ljlw+Y/zx5GUAe3iRiMj9Mk92dfDZqX0NTv4iisWGntXODFzgULwLsxK0LfwUXv3f55KZYZTrlf9J9QFevePw8aqkhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763519796; c=relaxed/simple;
	bh=9VP/fc7/MSmvFXbL/uMJ4xdIkwibrd9NyuUDtov76S0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=r4grvaqFSsOPFJS8UfmEgLt7/vZQWqOarKiaVAAxzw4LBkbOTxY1jOcNvGvIapZOfOcdnzUywZF7xOCDmLxSPGpnH/oFth5coWzrHGWrOS/fnwQ041Gj1TTeZ7BPIB1PB30t+OoFUQ1rCMinlupuHNUBLT3yjo0ifcMnAFrK84M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cW3kC/S0; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-4331709968fso23711305ab.2
        for <io-uring@vger.kernel.org>; Tue, 18 Nov 2025 18:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763519790; x=1764124590; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KyHf2GC6e+BVj/TrmBEhI1EpGBIwPz1R0vNU3t16RxY=;
        b=cW3kC/S0vt6p0ErNrlIg4Hkc7U1r78m8f1+B5kd3G3XBOBn7OkbpuI6az6t07o5K5c
         AkJ8ShNGqOmwv6TKkt3T0Ja5+D2lFsz36AdsbYJIBB7jhYqhQWzRtxOTOuww82S+Nh4L
         1NpPbRjeKexMU5LlJsghKIGRo/vasnqNB+iDYP6Pdtmdgz/ZL1/l2L2YG1H1IJJEDdVF
         322AjgOtHY3MT+phMsqaMe7KngoAWLZwe9nnamRq5uQaR8KCLpG6RD0wzX/sz5qugok9
         yzMwl7kQQpXKVwbhpmLUwDgNod7Ko17nJBanatx8GqUHfC1I0vDT/cXLuOThG/NaskFr
         GhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763519790; x=1764124590;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KyHf2GC6e+BVj/TrmBEhI1EpGBIwPz1R0vNU3t16RxY=;
        b=XyNFhVgD9Erike5TpDEMcbMg7BHszW/k/hC2b50DQSEzeFVmBbvkxxmJ2+Tn5yeDim
         0kyawXX5wpgbG5daESFW4EkdCkpSeEzQZvaK7x8bWoIjJXZ5oZ29VojBMhZYssvcuEGR
         DPs2E4ZdGYze3bc52zYk1DnmVnlceeU6a05wyiOrEx0Tua+A96TLr9RrkeHpKC3AyeRU
         7rS+Or+0It46ZvMoIclOvH03sz6GyJTd1ceQABF3AWp15ZWSHKHxnrucmUftWV9Fdv0e
         hYzJMHWTF4ASNu9BMIJLvfNeCCT0UdOtboGNn+m/z23krR5yHGz+YKR6T+gVRNYl82RT
         ZG5w==
X-Gm-Message-State: AOJu0YzK/VpCZFrF9zmOT0mBIpwIGAV2GLETkceOwMyoImbidqDt19HP
	4tjQRRyUOj7yL8XH1DnCfpSQNS/7/CM4GhhZmrjXr3uLIsviW9OvnffErUQPeG+VqRgIWPkdgDi
	W6/6v
X-Gm-Gg: ASbGncsqmVEsvHz621mCFEuWyNcRb3I75RYCScMC5ExqQ0prQGp3VBDnsrwU9EURuPi
	oKsZA8tRxeiyq2JtuLFCHS80TanaysIZZJi6lv8qKvMlUHs1jGwh+Ahb5LtEh/3Uq9NCdw0LXC0
	XeYzoVYplbid/Q/l9HXaVBSWsXkHWj/M235vljNEKIZLlbXYvuhx5Yl/sB/NBiYtWjQIHoTjv66
	0eUYprng26568ERJtdau1F6M7O3hlsOCJJajhffowqh5BRv9UkTZew9RPS+mQ3tvsEkFFC/Mn0Y
	BruR6NOVuyzh6ybvl5e0E5iJouzipdpKl1wL0co9SgMpM19lvnT/faGYZheL0/KIE+Q+D33UgY6
	Io0VOI4NAkUQluh198JiSjvCaGL/cdomcARb4eGLwCcw8P7MqIa56PlBbLWTlhngCfjUtEg59Q5
	NPavfOHgQCwzXaYnFtpgNMNdiL0yhEXw==
X-Google-Smtp-Source: AGHT+IERUna0M9r1pXKpa6dZpvGgGWnaocpkx9sSSvvJZBfMQFa/QtYqS4ODhe+tKpAVi7xpSdnLsg==
X-Received: by 2002:a05:6e02:1a6c:b0:433:46fa:6a7a with SMTP id e9e14a558f8ab-4359fe88747mr9715735ab.25.1763519790627;
        Tue, 18 Nov 2025 18:36:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd33093bsm6871284173.42.2025.11.18.18.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 18:36:30 -0800 (PST)
Message-ID: <64459921-de76-4e5c-8f2b-52e63461d3d4@kernel.dk>
Date: Tue, 18 Nov 2025 19:36:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/register: use correct location for io_rings_layout
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous consolidated the ring size etc calculations into
io_prepare_config(), but missed updating io_register_resize_rings()
correctly to use the calculated values. As a result, it ended up using
on-stack uninitialized values, and hence either failed validating the
size correctly, or just failed resizing because the sizes were random.

This caused failures in the liburing regression tests:

[...]
Running test resize-rings.t
resize=-7
test_basic 3000 failed
Test resize-rings.t failed with ret 1
Running test resize-rings.t /dev/sda
resize=-7
test_basic 3000 failed
Test resize-rings.t failed with ret 1
Running test resize-rings.t /dev/nvme1n1
resize=-7
test_basic 3000 failed
Test resize-rings.t failed with ret 1
Running test resize-rings.t /dev/dm-0
resize=-7
test_basic 3000 failed
Test resize-rings.t failed with ret 1

because io_create_region() would return -E2BIG because of unintialized
reg->size values.

Adjust the struct io_rings_layout rl pointer to point to the correct
location, and remove the (now dead) __rl on stack struct.

Fixes: eb76ff6a6829 ("io_uring: pre-calculate scq layout")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/register.c b/io_uring/register.c
index fc66a5364483..db42f98562c4 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -403,7 +403,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
 	unsigned i, tail, old_head;
 	struct io_uring_params *p = &config.p;
-	struct io_rings_layout __rl, *rl = &__rl;
+	struct io_rings_layout *rl = &config.layout;
 	int ret;
 
 	memset(&config, 0, sizeof(config));

-- 
Jens Axboe


