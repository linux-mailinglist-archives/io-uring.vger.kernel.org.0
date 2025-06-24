Return-Path: <io-uring+bounces-8467-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C8ECAE6439
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 14:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5DE44A01F8
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15EB257AF0;
	Tue, 24 Jun 2025 12:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KH/rx7gm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504ED13C82E
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 12:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766818; cv=none; b=mA6Uzz42RL+dkG2Vfsz6X1WtYqiuP2JPUSOu2uK56u4MC7+LqJFu2z2oMFqhMEdUvi6ooeTPaEg9yOQ+9YfyY36xnX8tzjil9iPTeOhojcJQ6DJ857qujavBbLVdtWhI/TOSPrQoEtHZB1pPcJaIjkQI7YWkaQlQdAYsajiaFhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766818; c=relaxed/simple;
	bh=YOXeXx+NGcBevPYTv83Uwuc8xcvtvOeqhxGAARh1ce4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XG9cT0FVRnC960h8rv+oJQklZ+Yqy9cvY4ujoiQuDt/sGliF1aUp8c77x24lbTrXXPxSgogmZweWbW/UgHI/YNbNHH8VlH9r3TGpZn8ur5TP3+kfS97eR0c6g7yL6rbDc1JCieG8Q4gajvRPCCmKV3oxVDxDrPuGN+b1vOscDMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KH/rx7gm; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-601dfef6a8dso8325724a12.1
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750766816; x=1751371616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T7JxM8+KOnZkbYFOjvcFirFsraETh0dxKqIz0bVAKD4=;
        b=KH/rx7gmodd3s4VydM/GartCNa7NurLlQLRkThKYAE3P8QYB6n87NeRdmRE4vgxbWs
         MgsrLIaV7++8Npc/hU6HULMbMCpSfa/C671GI67/ygsNZQiGm+XYC0WYId8gzf6SPDhv
         NTGcIUFQ8rjSwnHrXLV5STLN5aU5d4AFZwOcBUnRMPawoRHItKTjvN6Lll4XNh3q92dL
         0be5iPmvIHt6QdjZSyR9XDp2zluJOloMYP11IQH26aD5NXSS2WG+Il0wOfJDKaSKWByE
         XBYlExu0cfqsGga6kglnhrcW0W2qyGq4YUM/Nwi/nadk08Kb09IAfKDdoLSCWeCQM28B
         V+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750766816; x=1751371616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7JxM8+KOnZkbYFOjvcFirFsraETh0dxKqIz0bVAKD4=;
        b=v5DISKeLN1DIVvVEJ8tLkOfQS0YGLL/bEXg/brnMYJaMGdZbKTuzoItvdOorDXHmii
         JsUDgTzBHOS0NtIk3z08hse29ii0EB4o/mLxYx2mwmn5KUrgTSAlWXUeHrrbct9e7QPA
         FQ8KlqKnipYdv7FkpA9ATaF1JR0zjrPwl28DS40q4Fe3e8jDz0zn29++n+0fFAiNiUQA
         2dw6TKYUQUzgMKtlKhM/S0G4elZIjBd4si64Qb8QnsVia7npYOQ1yyBk1k5y0Om/Yetq
         9wdNMFsVIF7lgmR6MxyxvagMxfnPXcM1Oq6EP2Q12CfthtBKVZ3HoH8fOoUUW9gmHjhd
         9D4g==
X-Forwarded-Encrypted: i=1; AJvYcCX1n0qE3rgDeVShWRyanzQAm9Oii0ayf4IxOXpoRDOrPWNJ7e5ACyoP0T2cCbnrg8ztIw4tczH9UQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMATjJVVbmkd/P6pvi1apMuc28aQff7WXyER7BN7qs6jCu15NG
	v+leqAe5iUzSuYTcmzRi+Gb+ZC2+/eiJUSdcX27PIC3Qzy/Oz5PcAeK2DQVhWQ==
X-Gm-Gg: ASbGncvBalyzcJ6TFpbDnRFQRMPt2Tqt6G4z2ysc5g+3CnoMG/AuH2QKeqzTyKbHxAL
	0Ob4kqpT3TwzZpaXpEiwQzrkfn7QQpZoEzTjc1zzMM2sbF80nSoOvI0hdWRtbHFj8cGVyqoYXy2
	IflJ1aoKwKY4+i9Jj8fIg2nIpIUuSy/nbegnYgJwJtjjtAXwTYCqBtDjXH19neLRuVRv7pptGKI
	h2aht9QMbl7ivfCl6KXCsyYOsS2rwKWZufnnyxBy7kPU47rBAIvleKZOoFt1K08ykRDyWnzYs/4
	tcRT7Lq4vn/cGnLmjjI7LmDco3K5PK4JmKK2a3XGxPd1E5URd2h37Khcj4Hv1330J/xXw6vabfc
	=
X-Google-Smtp-Source: AGHT+IHcnM8CM7psfj9FGndHruTR2jXDrpB523tZ6m8dbUcTdVM0HYLFExD5ngUrOpBnY/BanZRfRQ==
X-Received: by 2002:a05:6402:2554:b0:607:f431:33f8 with SMTP id 4fb4d7f45d1cf-60a1d18f46emr14025081a12.24.1750766815316;
        Tue, 24 Jun 2025 05:06:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f196f3bsm960426a12.9.2025.06.24.05.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 05:06:54 -0700 (PDT)
Message-ID: <7c922136-39e6-4206-93ab-b3150b52a3c7@gmail.com>
Date: Tue, 24 Jun 2025 13:08:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] io_uring/rsrc: fix folio unpinning
To: David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
References: <cover.1750760501.git.asml.silence@gmail.com>
 <380d4fed5a9c49448f7ae030c54a6c0c5ec514c0.1750760501.git.asml.silence@gmail.com>
 <731f7ada-2544-483f-b33e-84c19d62d6e6@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <731f7ada-2544-483f-b33e-84c19d62d6e6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/25 12:57, David Hildenbrand wrote:
> On 24.06.25 12:35, Pavel Begunkov wrote:
>> [  108.070381][   T14] kernel BUG at mm/gup.c:71!
>> [  108.070502][   T14] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>> [  108.123672][   T14] Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250221-8.fc42 02/21/2025
>> [  108.127458][   T14] Workqueue: iou_exit io_ring_exit_work
>> [  108.174205][   T14] Call trace:
>> [  108.175649][   T14]  sanity_check_pinned_pages+0x7cc/0x7d0 (P)
>> [  108.178138][   T14]  unpin_user_page+0x80/0x10c
>> [  108.180189][   T14]  io_release_ubuf+0x84/0xf8
>> [  108.182196][   T14]  io_free_rsrc_node+0x250/0x57c
>> [  108.184345][   T14]  io_rsrc_data_free+0x148/0x298
>> [  108.186493][   T14]  io_sqe_buffers_unregister+0x84/0xa0
>> [  108.188991][   T14]  io_ring_ctx_free+0x48/0x480
>> [  108.191057][   T14]  io_ring_exit_work+0x764/0x7d8
>> [  108.193207][   T14]  process_one_work+0x7e8/0x155c
>> [  108.195431][   T14]  worker_thread+0x958/0xed8
>> [  108.197561][   T14]  kthread+0x5fc/0x75c
>> [  108.199362][   T14]  ret_from_fork+0x10/0x20
>>
>> We can pin a tail page of a folio, but then io_uring will try to unpin
>> the the head page of the folio. While it should be fine in terms of
>> keeping the page actually alive, but mm folks say it's wrong and
>> triggers a debug warning. Use unpin_user_folio() instead of
>> unpin_user_page*.
> 
> Right, unpin_user_pages() expects that you unpin the exact pages you pinned,
> not some other pages of the same folio.
> 
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: David Hildenbrand <david@redhat.com>
> 
> Probably should be:
> 
> Debugged-by: David Hildenbrand <david@redhat.com>
> Reported-by: syzbot+1d335893772467199ab6@syzkaller.appspotmail.com
> Closes: https://lkml.kernel.org/r/683f1551.050a0220.55ceb.0017.GAE@google.com

Sure, we can do that

-- 
Pavel Begunkov


