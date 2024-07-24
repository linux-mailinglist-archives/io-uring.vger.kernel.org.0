Return-Path: <io-uring+bounces-2574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1334A93B6E0
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 20:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C73802854F6
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 18:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F1A1591F3;
	Wed, 24 Jul 2024 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rLYrBZPN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DA15F3EF
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 18:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721846243; cv=none; b=PIpZlK2mezHpKc0d9KAOToRDAEJ78oSlN2kXLRMEQ71Nxhe7FBzqkJA5IP1iQYtSq/2ocwFq1+NxwOdq30S5iwqlU+CZJAhMk8D7QC53I+emaW97Tl8fVzuDfzf8Rh8gj8P751Zte6Wy1/Lg/+VbOFPYuhx5tPDRNhISn5q+hHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721846243; c=relaxed/simple;
	bh=t1Uq83j0GcvlWHYQheNUu02IHAWHu8FAUO8HAIkr/mI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=Zf81YRCMZvIyAhymLLw4RQnhsMAAHvcsIT7qXYdSiSaaNh3+Acs2hD+HsrN+RnPsHCc4Buh+FG51omyr1gHuc6w4VJQA/c1qojPGCAEsaa4ojqMy8Gbrs89dyt7leTtuf6du33joyqq23GfZi4BK/cy9bPvrkFtR2Z3qdc68QBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rLYrBZPN; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7092f277242so3731a34.3
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721846239; x=1722451039; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mwvs0Pg/CWzw7pNw0vEO0JSCGTQ/xOWqXNs4xnG2Mgc=;
        b=rLYrBZPNfBuV5NRueG8dm/RG/6aD5SNSwMvwYAgeXBDOUptb7z8hzWzLG2DgodYnDO
         puxlQ8TisO23RukVtehIoOQlzJVOINMrzYbSZsk7h12n9qNs6yWKaDdnTS51xcMQkSgV
         +hbSqPkAr7EJKucoZhkAi3AzXRzom8JPUyrTUsqKG7z1a7I6YVC7xzCk1pSAX7A8b+ad
         wT+E3KLLVSZMXoUHJZfqiI8c8a1CuiakQ5zX0Pu9zy5haSh9rLejnl/K3mRPvKGrUlye
         GK5AixK5edbPdE0MWPhj+WOhTibxo9/SgX+xnZDhdADAxwX6VmX489YBmtsPOmVmBeTP
         iuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721846239; x=1722451039;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mwvs0Pg/CWzw7pNw0vEO0JSCGTQ/xOWqXNs4xnG2Mgc=;
        b=BDM1oz/UBEeuhVJr+hN6HBJnrGYaBEjBMEm7n0X5Ff1HlAhbMf4tJKIg5pP6fPv52g
         EcV+quVaWCld+e5awVLOSMVD2PzPglQvVR+CikOcNk0XlSqHffC9wF5W0wJN8CPmAr2t
         glrxFkECaknsR5ikUHpt/IJWco6I3Ls702xWByXtUQZZlTVeNVHJdLDxnmVmlGMJp9a2
         JWTtxFjW/2Mf7ntNqrdQcqdSusNATEk4OunnX2T5YxiP1yk0lq29L+r/zv43UYSLDtyE
         07Rvu9FO5CaQKal6PMDcnm+BIl+xfPKUBPCmObUTzSmrTNlyixPaKM8KoUeedyxBcywV
         qS8w==
X-Forwarded-Encrypted: i=1; AJvYcCVumjuB1Bo8JZ71yhp/ikcTdBc2uqRh4HJBjDuhQ3RlofYbAySj9gPIctRd8MFinJlBfph5erJAYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAbLTT45KSiwExyR/6j2mxUS4PaUaRuoJ+aBufeFoCz50TJ8PT
	TWx5BHXfIOMwggYn/zPbWEjgQtGTc7cVSA0aIJQ5VFC9i1HxW8XSvR46JQ4BEAM=
X-Google-Smtp-Source: AGHT+IEWRY324XaCLYmUaTmaEPj0uTQobnb2PV1RlylCK5ZjvJLU7A0K7vZ4iuDj5jyWnQqqe1xo9g==
X-Received: by 2002:a05:6830:1212:b0:708:b80d:f3f with SMTP id 46e09a7af769-7092fb252f6mr82039a34.4.1721846239224;
        Wed, 24 Jul 2024 11:37:19 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-708f60d7529sm2603690a34.40.2024.07.24.11.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 11:37:18 -0700 (PDT)
Message-ID: <18c54a21-184c-4cde-811c-48c5c0e34f9b@kernel.dk>
Date: Wed, 24 Jul 2024 12:37:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in
 io_req_task_work_add_remote
To: syzbot <syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000fd3d8d061dfc0e4a@google.com>
Content-Language: en-US
In-Reply-To: <000000000000fd3d8d061dfc0e4a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 4:51 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    933069701c1b Merge tag '6.11-rc-smb3-server-fixes' of git:..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=16e38d5e980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c062b3d00b275b52
> dashboard link: https://syzkaller.appspot.com/bug?extid=82609b8937a4458106ca
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149e5245980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1388c55e980000

#syz test

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2626424f5d73..1aaab21e1574 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1137,9 +1137,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
-	 * they can even be queued lazily, fall back to non-lazy.
+	 * We don't know how many requests are in the link and whether they can
+	 * even be queued lazily, fall back to non-lazy.
 	 */
+	req->nr_tw = 0;
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 

-- 
Jens Axboe


