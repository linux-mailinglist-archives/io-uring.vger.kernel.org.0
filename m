Return-Path: <io-uring+bounces-9913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80679BC1788
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 15:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B2C719A2ADB
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 13:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98BF2E0914;
	Tue,  7 Oct 2025 13:20:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400342DF6FF
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759843212; cv=none; b=IujKWQs3D0Z8izPsFYo+PLsJwoo0ijKF2HyBtv75P/2gujOIa+uIK7BRWnnlBVb0U+WiqSdnc3ctNZOL7kCAj3ykVPNf0I+h0VUM1cKZK1hL4txmphGWxCrOVl06CFx0AzTDAQP7jSWuyW6Nsz+m1qz3FTHJ91zW5Y+WSAeIGgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759843212; c=relaxed/simple;
	bh=HCIgy9FzRlDPKwgdolMgt+NcJMv5yID3856qGOPZ9ag=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=MaVvHKsToNTjKZGT9kor3r+W3lGg8z5Uu9a0OayYVclqCytVRZpgTAyGA9zRX0YP0sdPiHGy/XkXY8AryWRwP6QT/5/qrnDY6gm9fyuAWMptZFu9rg1T0YQ37emcTLtAmjP0ywblBgyf3/n0qspuC6mZJdYLe36T9GwvcNVw1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-9228ed70eb7so1501918239f.2
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 06:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759843210; x=1760448010;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOfGvihmVurLYIYTy01Sm4ZrKHqm1xB9ugNFGyMdrTM=;
        b=PPtgVWz1VypHCxa1GzIguhceTxQ84eJcx4VyxzjEib+hb1QfVkCgHozY0eldMByccO
         JkeBr9aWNK8FHfdG6f790ZaMCl1H7cfSWEF3oawuwuE3iZ4aBJkQKRUNGV0KJoZ8Mrem
         khjorYHe8FsY4XrzhgVsHiF1sR3RhqOiTGckaoWHpoTrRNZwMQh7A1Z1Ohgxf00ocid7
         /cBSog+VGzibp5VitM/6k9KdvVjyLzPJMA37n5PyoDsbqg3sgKU/VQLXS81ch1QRJmpv
         L2XWm5XyEN+oXMKCyXLvowNOLnF8xaoPgR27qiK1X5yosbpLQhNCq85csM3AnMV7ogwd
         A2Yg==
X-Forwarded-Encrypted: i=1; AJvYcCU7jiPU8+QYSZXozF++QbZXVgqy1ohEPVvGA3qyGQl0sNjnmjht/PWAjzGy63Jwu3CT2SMVpWNU5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHzWeaRaPERscflX2vGg7Oo2O3Qw87XSOoHBuj+sngQl1Bazhq
	SH+9uuOOfFikOjYtM45NkScuZzJLEvh5CBTNcW2tzoQ5WIvXNFsHFGfYCMz68qrin6jFAK8oO+O
	fK3DyhBxZJShsvcujAb+anH2B3JOo+JLDNTH/bw+lpaOoWfCJp2dJzuPZ88g=
X-Google-Smtp-Source: AGHT+IHVR1JzLJS2esFeRv/iYFpIROg6XXXiqM63kA4an+8QZbGWpq2qhVwZppeC8RTUXsyvhwYrPL0Z/wT0M3z8muPrcIwAd83X
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4190:b0:918:f2e8:ba6c with SMTP id
 ca18e2360f4ac-93b96aa991emr2345226139f.18.1759843210374; Tue, 07 Oct 2025
 06:20:10 -0700 (PDT)
Date: Tue, 07 Oct 2025 06:20:10 -0700
In-Reply-To: <7c0346f9-e90c-4c15-a2d6-b2d40005361c@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e5138a.a00a0220.298cc0.047a.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_waitid_wait
From: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>
To: axboe@kernel.dk
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git

want either no args or 2 args (repo, branch), got 5

>
> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
> index 26c118f3918d..f25110fb1b12 100644
> --- a/io_uring/waitid.c
> +++ b/io_uring/waitid.c
> @@ -230,13 +230,14 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
>  	if (!pid_child_should_wake(wo, p))
>  		return 0;
>  
> +	list_del_init(&wait->entry);
> +
>  	/* cancel is in progress */
>  	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
>  		return 1;
>  
>  	req->io_task_work.func = io_waitid_cb;
>  	io_req_task_work_add(req);
> -	list_del_init(&wait->entry);
>  	return 1;
>  }
>  
>
> -- 
> Jens Axboe

