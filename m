Return-Path: <io-uring+bounces-10302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D2BC22AB5
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:13:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F32604EBCDC
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B120232ED2F;
	Thu, 30 Oct 2025 23:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ct0EKul6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6852A2620DE
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761865944; cv=none; b=i6F6ZcMOmADzAngy5HkrvNBzAof4qioeVz9n27FTbbb71do5ksHjhskMsWwqetboG1lcmivlxkLK7Rta9VVk6VK8F0c6QEV7SmIp0iDW+fKgzTcFdgdgyPG9o3GvCWto2S0BKf8+NS0HBFgeNZQ0EZtWIYBJU13izawYBLiqLco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761865944; c=relaxed/simple;
	bh=FWdZ5+r53HLL6DD6sEpsfn5ekax5F9yKhc50i2IuozI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eR5eYm8k1U70RIFwpFl15+HB/tA71y4exyw/YwEStSSSpiwPyEH+BcLlGDqQ1h5yW4Q3iOrsxgjuDvF25kWRlfmqdQz+i/DciEqkB0vG1q2IPpuRU19Ps8+DwhKTCo4CD9iA164Lt8eBaLUHB9H8RBBTgu6zP9VkDbzmT1kR0hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ct0EKul6; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-430cd27de3eso7008405ab.1
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 16:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761865941; x=1762470741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QKw/K+nf9p8Pnc1atkVkdHnJUnVEG2Qa10stPI+AJG0=;
        b=Ct0EKul6gNF8oEa1rVowJH7xNJqnNnkDnN+eQgu0CSUhdbtSfyp+KnG74k/koKq5/1
         LnOWqqU/ZGgK/BJ+FHNYW4O3zcHE+P5stxO/czsxcC01+ehOzBwKXA/QwozPm8XVA6Zr
         VaWtnd15nDUc24sDpPFVzQUX257loU7lOTpRGnZul4w2oJTQXrnzuV02Rs1e6G8JMBwx
         phRolvEZT+Hee70K7nEr86YqqkRrlpaRPPZnOVHCt7Lmp+7q7t6c0I7xdCW3I0eAkBPt
         TV5K8HUINY5Oqlo1O14OBat8raw/6f08fXHWDooWhKObGAaSml7m6iQZYatWg/cjte6G
         D8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761865941; x=1762470741;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QKw/K+nf9p8Pnc1atkVkdHnJUnVEG2Qa10stPI+AJG0=;
        b=fdX5DUiIuUCXiIhcMJ9jjrtk+fNhe+6D/OJeOSwxYOBYMZ9zQkttUF4hr529mYBe/L
         Fp9E9q9QW26wLhiYegqc/ALfgrwL4x2035/HKqIpM5WLS5TveSkbMdl6fIUIIlJ8XB+a
         ZcCbGpeQEIqt9W9aUOL4aCzjwKVXPpkckcsKIqQmhlDGyku2ltAnYY516dgPtJVwRHlI
         4xKfuIhM++qNy9P8eXv2kXlDzsCr5NeGpAzZnuVi87rinJKnBesAApqBr4eU73zx0iiE
         djJ9Y08Mssfnqy7x4FEKPVhQJuaJzYQfmeYODQh9/m6cJEhw8LjXi9YzMoa8ggQXtwba
         aPqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7crAAMROwPPhBco2tZKKKBdR2PJ3X5hFfGU3TKj9keFcsjRS1JX3aIHD1AtFEXcwBZM2gHIiPxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHaKgYiULn/J1AhlzJlXpU+aB+UBABdv2SWfwp1vlTrofrqsNL
	alUyyqPlx4yPvqi3TXS4f53T9pHY1ILB+CsbiU6CePGJRnAoSERdzHiqLPM9yLGmVdg=
X-Gm-Gg: ASbGnctaSrs0mY7xDEj5dEAy+BqwIK16FeS01kZLcZ+et1HPrZvKqsxtXHCnFFyfhRF
	oagJCFA92xjo4dXZcgWVO2zdHSFfIujqT73MWXgwyGNDdv91hsKMNkG4Xh7bOgVHjFM2Cw1lF0n
	9NjTKnUu23HqRky8YaW1sx3y9LUBkJ/FLkmeGRBuNPk+nmxzugdYo3GxPaXNJTsTTy8Vn0jUPYk
	JD8/1Ii71EuOdAWkzDaAjDNDV6M5lUCrH6qnvp02tvhRCq3vgVSA4SOaHTfqI0Xzu8O7pvZfEA8
	smFbLF7Zsox2V8TZDZIAK5mi1+ObnWwv/db1CCRf0cbjjSPtQSlrR51scsBQiibRSPggXgW13p9
	QtPNiSL+LOYepiCB9Mlawfc6YXJ01shklk1uscjmmIKzdzVdbS4ZVcyYUsb0uhV9Zvs/tT9o73w
	==
X-Google-Smtp-Source: AGHT+IG1jqu6NrajMqpFEesfbT6+KRwNSIkAiHV63BYEEQUBt3tmL4uGzZ8irT3xY6DfvGjvO0dkZg==
X-Received: by 2002:a05:6e02:3712:b0:426:39a:90f1 with SMTP id e9e14a558f8ab-4330d1c904amr29475295ab.18.1761865941610;
        Thu, 30 Oct 2025 16:12:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94827c84cedsm925939f.12.2025.10.30.16.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 16:12:20 -0700 (PDT)
Message-ID: <132ed630-d885-4fb7-9f85-0d8ce8f25fbb@kernel.dk>
Date: Thu, 30 Oct 2025 17:12:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: global-out-of-bounds Read in
 io_uring_show_fdinfo
To: syzbot <syzbot+b883b008a0b1067d5833@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, kbusch@kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6903e7f7.050a0220.3344a1.044d.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6903e7f7.050a0220.3344a1.044d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next

-- 
Jens Axboe


