Return-Path: <io-uring+bounces-2580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E259293C50D
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 16:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61068B2649B
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 14:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4793419AD9B;
	Thu, 25 Jul 2024 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PCQXhSs9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266BA8468
	for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918800; cv=none; b=KYgjjV/pqm32Ab2TJ7Wp73NDvpVkirZ8wR14OcSFhpw524kOFzsCbmqflZv3Vs5aa/HQKD2aSYOJAEMjncYcfAp/28HW5TE0pOm14rqqQTdJbtq0SltP6frxkXw3XvagVhPUaa0YG96zAeL5NCJ7MMVFdxB1c0zPnCgMrWjY+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918800; c=relaxed/simple;
	bh=mT9MNFKr7aPAgYb5AtQxuvxZh/ZL8WawfhwUBSoD+kI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FA5dNoMUOxbFk1bK1Hohj4zLM01WTiOMh6Z6rLH86bNoIoKJT7CnnfZMjd9uyTlQ3Jx3K3Eb0YM941EHKO+RipBv8l6zM1LXltzJs3EyN1SLRUV0LYax1HJBt2sjdDmLCA0s2Fzfxk1AhQsLjFMrphhAQxO+QWfzlJ1LNhooCSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PCQXhSs9; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7f906800b4cso1559339f.3
        for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 07:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721918796; x=1722523596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qJ44A6ixhFSJuEsftmBa7Xjp0gzBXl2+go4fssUyIos=;
        b=PCQXhSs9ZcXnCyYEtAsvfzs5JZVl6r9m/gfizQoQvy+ZZ2YEFTJaTEV/bEiUfzz5d6
         xqyP1W1REeVLNXZj0xlp51pzP4s2xvTBWu5mxDrmComg6D4Lof3OGDtP9yUm0SOpCRb9
         babTrl2zG1/pZL8+VkJg1KCtQ892ALaRyI7beMIXF49MwwVwhrD7qWgoBFAgZBY19BaD
         W1joZJI65+Ds7hQwxlLBco1SFfWtXyyd5s+KBIjIlN0Lfk4Bkn2jQ5Au3ImT6c5pnu4J
         77nYHLqngGy1p3xIjjscDgBDCs+amYNhgX3K0QrejE7whA9VJ4PYRIhtCM64v8fKk7qJ
         GjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721918796; x=1722523596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJ44A6ixhFSJuEsftmBa7Xjp0gzBXl2+go4fssUyIos=;
        b=JIHt0x/Qzjw+h/G8fKqMTlJDpzcZLRYPqUxh30yChMm7i8qGC+WljRSM8rjk+pqRgh
         py63mNYoKtSeK5AcMtk+J3RXhB4Zo+0/DyjkVn5seNrHK90dmqW5CEfvCK6jQ5F4pH+h
         RMVCL+WQYGsNwf534S+pgVGqG2bNTfq770GJy78ovOTugHy+3o1Tb5Y4xnnksfhbhni0
         ubzma7NvfC/xHjF/ht8/7WctxbxLRjKdTgwd/YnHpizhvUj8oXmncJbYyKKZf/PrlA0l
         mEQlYRWOizeugUmOzWSCPhmSWozKvhOFt8+IbRB/rHaVnI8imhWyqBZSKK1Zbr8oQbf9
         Fz+w==
X-Forwarded-Encrypted: i=1; AJvYcCXiPKC3SENWrMgbqEQeV2wn4gArB/Blub2xviDKv1o/BK9O1nRdI0pDR2/aByTeB1gYOEci3gUnEcyhGZFPaQOrgKmyLxI1B8I=
X-Gm-Message-State: AOJu0YxHdQQ/a8jx7J+6/UE/OZ7CsPy1BTpljzheBmJrrwU6AN69vay9
	ABJiWl3en5Jagj6L/s6sCxTIH76hrId53DaeXNyByJVVTZiKouzO/a60vD4i8C8=
X-Google-Smtp-Source: AGHT+IGA9KwcxBUdYQDg20GqQAKCjSIkt0PdFqcrD+7PVFv1W533RWITS7rn/Jx4ssMY3sa3NjAzQA==
X-Received: by 2002:a05:6e02:17cd:b0:375:a4f9:e701 with SMTP id e9e14a558f8ab-39a22d22302mr19350355ab.3.1721918796065;
        Thu, 25 Jul 2024 07:46:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9fa5a0c5csm1086245a12.91.2024.07.25.07.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 07:46:35 -0700 (PDT)
Message-ID: <b8783e34-1011-4eae-86cc-9ba2b310863d@kernel.dk>
Date: Thu, 25 Jul 2024 08:46:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in
 io_req_task_work_add_remote
To: syzbot <syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a4fe65061e049a02@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000a4fe65061e049a02@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 3:03 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com
> Tested-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         c33ffdb7 Merge tag 'phy-for-6.11' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17d29bb5980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f26f43c6f7db5ad2
> dashboard link: https://syzkaller.appspot.com/bug?extid=82609b8937a4458106ca
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=120b7dad980000
> 
> Note: testing is done by a robot and is best-effort only.

#syz test: git://git.kernel.dk/linux io_uring-6.11

-- 
Jens Axboe



