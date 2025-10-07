Return-Path: <io-uring+bounces-9914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ED11FBC1791
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 15:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8E25C4F63B8
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 13:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46732E0B74;
	Tue,  7 Oct 2025 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UtIk1H+p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6CC255E27
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 13:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759843213; cv=none; b=SgrWhzYZ/ACbiJ2jRv4a3k4n1TxSjYqjNWmSuBqXBJKa6btGozUIL36J3IgUlZFhnsd02OHRIlV0sWAUT8dc1MOQtS3DcC7eOmQswFSXNuvbk1AAlvjNBCHnpgg5ka5P6g5sev+gff6/Ud4V1veYISxFTwTEfqNRfNGYnH9txzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759843213; c=relaxed/simple;
	bh=giqCpi0LH1kxCJpdQzyBEXWToPuMe+YtyXITit3AxbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NVPtl0xbJBhsN8ip2GZcQplWPzYa3pbowF4rSdDvM5OM2J6GT3ndcRCjuxjGJ5WOWAKA44iT8ZrVFBOBk68eQj3G5G6H/LqyDOm7mmu02I/uckC/9MPNzJdQ9I2GM4jpYx/wAXrSYJp+3+mTNjdfJl8hYwmMdOJkABWqDZqrSPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UtIk1H+p; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-42f3acb1744so22407885ab.0
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 06:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759843209; x=1760448009; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gFkYQqELpZ/I5DDYLLleq52CpzNajwjStFZiAMR6DNo=;
        b=UtIk1H+pZiERYJW1o3TSw0V0VmA2OmaJNMk62hQAkPaDJobOLDpAnWVDRDCTzkurBR
         Lb2TXJU7az8mZXJS87I3pP442yv5K8RUYso01xvAOnNpo3zISzSwavb5K8mY8chl9bXB
         +D6XgevkZZYgbO0PSnrAV53Ac82K+iWbZgsFNe4oeBF8i3vVBMCuOYOL914rDYBaVvxW
         DIGDOTVxtWk4/grtNHJdJyTIV3XDbcPTza85KwnkuXy82c2bLNrlm9DNxmm0h+jKSTjU
         ZY+kWu3AyGgB8lQ8yE5HAI9LbM8CgepJjJpYEJEea+oXjboSilov8V2s948GxLO/FuKZ
         hFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759843209; x=1760448009;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gFkYQqELpZ/I5DDYLLleq52CpzNajwjStFZiAMR6DNo=;
        b=wtFSwzk0aU0XMVIV9Y6PTGo3l4E5UtyekUYdzu5sJzRDmr644S30adWdLPVMC6nmn6
         yIt5gvkzc97UReqWhbl/Dqf7R9S7G1MR5dUl9heUSILrpL3hqxRELCiTVw5HqKROLCMQ
         Rm+H3HC0pHt2QdoCMCFApGBlN/7S/X6xFS92y1ROVIMWB6HdgcZVYuOPkO1TDf5wNiIu
         IkIvWXsVvCEpDLT/uNoNsxOl3KDOdr/KRG8D5jZCExIKdLLXGkgTRuUgrttaLZzEX9gM
         09Aiv2cgsPxdGgMciK2D+STMTqQOBGlz0+1kOI9wOd5zzc0pIlTlRU/47WPfA27NMdKB
         m4tA==
X-Forwarded-Encrypted: i=1; AJvYcCXgbPNfWWO/yAkdKxC5ywJE4XWbUBXD/CWHM859DOUlI3jqHspUDr3Xeb4DxW6TpO/gvsJMqPARig==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw/YJx7CNfauN9YhMM5I6GnnGqhIU6WmrvyKFQTPH8WZjBUT5f
	bhQ+lHhrPsA5RK8iYINrOHxwtFsrw9XjSDsegg2G3Y987efhZ+npGgie1SCgHrvr2UlChh4Q7LD
	tCyZ2ucQ=
X-Gm-Gg: ASbGnctwX2CBv2SeiuSBbSfFw3hU20Kq+2YkMzj0nJBUqsk5piaCIx4PJURVPfB5ukU
	sHWGIPXQrvcG+p6jRf/7r3hd818O0dh83B+2Iol2zu7JYcixOBCgQD8K0i5XlBfr+2s5uSVAqix
	KChdSfw150cX4pdNX4S6cBqxOmCCeMGJ+scD5+eu6t9WSmT88KI+QrAyV3geHxaOEHt+g+7bruK
	DKDb/b+LkxPiPZqEPshj3GBwoROjNHNyV4nXlS4neUTULsFVmJzjYU+C4HU1LoUVkSMoDjS3toR
	/WG4IhGPZc3KyMgIxUihKSM6fETu3CpjHnVheQQPbIcB9H3tjp73p5BKgvt0lDz3dweWau582f+
	3073KjNC4V3D83y+0EaD2+cXU4uGtRgpLsrxMr4QO/5IvfKbJ4PR4tHQ=
X-Google-Smtp-Source: AGHT+IECpoJl5ZknvT8EatO5MCAHJVtZrLUEEc1VV9KUIEqsn3vWrqz+GBQUzNa/CwNmBAZBLoaGKQ==
X-Received: by 2002:a05:6e02:1fe9:b0:425:7466:624d with SMTP id e9e14a558f8ab-42e7ada91abmr224158295ab.26.1759843209434;
        Tue, 07 Oct 2025 06:20:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b294ddfsm63257435ab.33.2025.10.07.06.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 06:20:08 -0700 (PDT)
Message-ID: <7c0346f9-e90c-4c15-a2d6-b2d40005361c@kernel.dk>
Date: Tue, 7 Oct 2025 07:20:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_waitid_wait
To: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68e50af2.a00a0220.298cc0.0479.GAE@google.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <68e50af2.a00a0220.298cc0.0479.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 26c118f3918d..f25110fb1b12 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -230,13 +230,14 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 	if (!pid_child_should_wake(wo, p))
 		return 0;
 
+	list_del_init(&wait->entry);
+
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return 1;
 
 	req->io_task_work.func = io_waitid_cb;
 	io_req_task_work_add(req);
-	list_del_init(&wait->entry);
 	return 1;
 }
 

-- 
Jens Axboe

