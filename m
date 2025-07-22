Return-Path: <io-uring+bounces-8776-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B436B0DC0A
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 15:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40D1A3ABC01
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 13:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E562EA15A;
	Tue, 22 Jul 2025 13:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SrK6JIU7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797CB2EA48A
	for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192439; cv=none; b=Vx2+Rk2h8gqZko/iCV9t/aYE4r/vFm2x5ZL785KMtojNSeFczUA7V1/xLHXS87fsbZY44wxG/ScweioENTOH0HCvQMYpiXW2WET353GyYIi7ApBXtwijvTEFv4PpTjzSQ+rLkp1woMd6wns9yg1aqJRdxLmqTYxadvmyd24qy+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192439; c=relaxed/simple;
	bh=X+6WKa37YeGdTpSsUgBPKRQ0ha4JuQYk7mXhrDyUA8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EN/socgOEMQRVi8cJo6UAWmG7EBs7gSWenrK1MhY5js1z4pSu07Jz1AqpE0q22yCbCnyyCv8fpVFK0/u0dwjtdEIaWdIkf8wtvowNO8zXWPnGJWPFiG2/KvdLn74KRE3Xh78hKhqk32fxyfZ335HOl6wdwOLSRpLQuaDEVJk8TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SrK6JIU7; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-879c737bcebso226440039f.0
        for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 06:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753192436; x=1753797236; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r80FNHbgGav8HfaJ0V6RkXNFNbTEZ+XI5znWw0crh2Q=;
        b=SrK6JIU72CATvAOgZIaEflk6YUo5oAfm1Lb/oR++puGKE9xJ4BhFfoOkSRenu5oRpc
         OBV9mtd6Mvujxe/0XAfvC9C5ZiB3XE+uT2EpJJDHqXzuilOJLtNpkub93/V1ThSvsVij
         52ynwwxrDKRWW6X1Bho5wXJns7ayOldJm3pchQTs5mLvnL9fLBVdWpBvYVCPLZuBJ9J5
         I+JRGWtrL5zrA8sZgaKYEIJoKp6r8NY0Y3bMTiPIAeK3VROyu3xCnnijDctGjIT/DhnS
         joVCCLOf9K7oTl7D8ZTp2Ofcg2CgVZT4tEbXk0qzcZWPeElyTcTIDUJY6ZXBV5b1PZP+
         W3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753192436; x=1753797236;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r80FNHbgGav8HfaJ0V6RkXNFNbTEZ+XI5znWw0crh2Q=;
        b=qjBchMKdDJTVFp+zQAM768FeLOY0y8+7Aet54Nrolb21B49PwvLZDsCU40iunFq/RH
         f4Rhs9yikzLmswfk5WXuNwzN2QMnIMDSPUMiidQ/RPwjS5j1A8oFQ7XpIR+w22QyfhG1
         jkCEjOGI6CMpPgbQq9vdR7Fu/JS08iWQDFF8Bi7kS8Zc0zUt9gdumvbbwt/niRgR6yKw
         LMuI1GhK2A0xTIGKVS+XlItvMMuDdLaTIJXn1PM0qwHXh3SpdesGF86nm6Y8MUvu0geO
         LWBojdl6/SAytJK6qX3+YhxArjtSN6HxfXoQJHjiPFdK8r7dQCc4Vnu4tuCyVC/9OFL7
         LXrA==
X-Forwarded-Encrypted: i=1; AJvYcCVeaJT66PsEVIwJckjPM9t7S818OoqVW38rw9xFzqYD18N9GbUn65hnLEquxfEl0drZtICbtidzjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YweBFtQspR4s83CWylJzwgxh9JfhP5KmoW2fOTgrH2mSUFWVYPX
	Mz44AiptS111vxpHy7WX3jBr9JSzxHm9DZUsoAAgfX5H9R4IXoUJwrUyfSrmzw9C59Y=
X-Gm-Gg: ASbGncutUwmOBDFkS5N05aBW6hVsB8IkrvMQWgw9oXwgU5tc9x3RG5FX/dUFnxquAxn
	RJLC7/Qk+ltBwY3EpWxdzUBw3XK00wP22iSKqW4l1eYYlqqKn6bbKh0JVjjXI91dhlJCjHEGJEO
	E1V9HsSv1chXSTN65n4N+AH5HcUg1tTySvkDFVHuSkWFeZLeVnTbnrrgc4j/Dcxqq87J7gz/nZ/
	2kHAnWv9TSS3SCT7EdfkAWaP1FUo3Ioa7H6eVR1PmVLocczNvjAW5Dad305bfg14OS1ONhTFgUa
	fw6/EI5rTFD5IJH1ojfMxXeo9U7RUXs77CO3DxZ4KFMXPIFNv8cJISvBMyp9k3AmPVKfl39p5bf
	vqe7E+fjZNYkEtGYdh40=
X-Google-Smtp-Source: AGHT+IGFRfbNKh6jX1zH9KAk0DUbpXwcYXi40U/N+ZaBrRvAfIYWQkKSZlimYZGTE9iRtDWrW71sLg==
X-Received: by 2002:a05:6e02:4515:10b0:3e2:c21d:ea12 with SMTP id e9e14a558f8ab-3e2c21debf0mr20016665ab.7.1753192436556;
        Tue, 22 Jul 2025 06:53:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e298133d14sm31439775ab.10.2025.07.22.06.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 06:53:56 -0700 (PDT)
Message-ID: <8320bd2b-b6d2-4ed8-84c6-cb04999e9f53@kernel.dk>
Date: Tue, 22 Jul 2025 07:53:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_poll_remove_entries
To: Ian Abbott <abbotti@mev.co.uk>
Cc: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, hsweeten@visionengravers.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
 <9385a1a6-8c10-4eb5-9ab9-87aaeb6a7766@kernel.dk>
 <ede52bb4-c418-45c0-b133-4b5fb6682b04@kernel.dk>
 <d407c9f1-e625-4153-930f-6e44d82b32b5@kernel.dk>
 <20250722134724.6671e45b@ian-deb>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250722134724.6671e45b@ian-deb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> Thanks for your investigation and initial fix. I think dev->attach_lock
> needs to be write-locked before calling is_device_busy() and released
> after comedi_device_detach() (although that also write-locks it, so we
> need to refactor that). Otherwise, someone could get added to the
> wait_head after is_device_busy() returns.

Looked at this one post coffee, and this looks good to me. If the
->cancel() part is all fine with attach_lock being held, this looks like
the simplest solution to the issue.

I still think the whole busy notion etc needs rethinking in comedi, it
should follow a more idiomatic approach rather than be special. But
that's really separate from this fix.

-- 
Jens Axboe

