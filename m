Return-Path: <io-uring+bounces-8466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C67AE63F5
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 13:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6B6C174516
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 11:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF8D252287;
	Tue, 24 Jun 2025 11:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPyg1135"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2171528EA4D
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 11:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766251; cv=none; b=Fm/7R3MGuGt4TeYFB5wNUsp5moG1R/ltVWTG+4bdnhWMujpBNlhI7fNH5kwiO6zLDQeffEBYKkxVP8i+IDzBnJR/VH8e18uiOlnmfoH6t3T+4nabUY3TjCgM2TZBomeW0qzaMBQ9l+sIHUGoc3fQqdtUn9xAZi7VFCU7Ooaj09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766251; c=relaxed/simple;
	bh=406JsfbV3wkEZ6a6a8M6TGy1hBce9VFR0b4RqdtEUmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rAWxpreMMB9ZwLS4pjP91lU7gJ+bikk1xUHb5NY1JJqgNhZQhc4aneYKb2Gc92v2sIHMzxkYJNB7dxOEC8hHrE6RDNN00DU+Aqtu5F6ohKJpYtQyK17zdyNUxgqGmfsV4B/A5Bu4Sr/JOTEMgGp1dgp0ufx90GcG3ZRQyCx7wk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HPyg1135; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750766249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z1V8dxB5/t6XmTrfBw33D/WiQ0b3b2IUzkoO3yElUk8=;
	b=HPyg11359FSbkeoCm1SCshjJpoKKGRPAOWZsrampYhP6lBby055Cw2eBc18Q3fcdbr+HP1
	0AJBdk8lIngVJUpjNxp2gHrLNm6UZ21UjpZeCEAcOWWaIU6qgQnm7q/4Lc6rJmG/E19ZfE
	l5MTwXrASvHr7xIMfSobVDvp0XDQn40=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-DnhPx_O6Nr6g2lqShGsiEQ-1; Tue, 24 Jun 2025 07:57:27 -0400
X-MC-Unique: DnhPx_O6Nr6g2lqShGsiEQ-1
X-Mimecast-MFC-AGG-ID: DnhPx_O6Nr6g2lqShGsiEQ_1750766246
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4535d300d2dso2983945e9.1
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 04:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750766246; x=1751371046;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z1V8dxB5/t6XmTrfBw33D/WiQ0b3b2IUzkoO3yElUk8=;
        b=jp+eYGQTjWANSz8VEYS2JhVUPEZzacrme+X03fV3s5A3idrfyMh4gvSW2JE0WbGN+L
         c3rz+JeJau+IOVn8dmznYDfKA77ppyKHcttacARWvQlCE9CxsUCiWdRwXXuOBaAVBcqK
         pp6r7mqal4ewnF5lEBqqJW645ujSGiJKbchj9qAPoTgbmVkivZ78a5ReZ5tKFAAP9h8f
         26Vnd60rFAEDsUYcjRWhvjPTPqXl15YBP/MwWlYL0VTJ/b4QwM+Ej2ztHlub4TT5jN/T
         qUYqfynjJx0vz6U0TMTTeHGeMnzfEJ4IdV7+bw6WbJeyY00tpAVxfOKoWI1lFi8SvQZg
         7PXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW4GOe1ByG8I+i5lT/xRJU2kqaSsvUvjyqOGZzxttIMMd5tMZhISmeSKomadXL79WRl7xBGOXD3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvFxMQ+tVwTF1jFyOjJSRjBcUuzgPGCMk8WUUpM1d8oi5WCLJ7
	R9o3aO5Y3LQ7o/tj1NVDDYmzgQFoNynRJC3sWJNGMsNx3zBLk4p/AqJb9uK9HZgYxkhNelS4JbG
	DmsGIN4w3si1imv704A42jgr9CPCCzJMP+HxDKrLlYvEBsuMgfwtQkE7gSV5r
X-Gm-Gg: ASbGncu66NK07OITTcr4GO1TF6/OLmM8SHjS0Yf6M024zU84WmlYewOz33oW75PXmZq
	QQCURNN1UjiIusvXRAFcg8cRSFlaqz+/PnkMb2IkMD/Qre0vz5T8Xt1gjM3JiOw3cNCFOTb3WJg
	uXweHFT7UY/SBJ0pvtD1JqSdzfKXloqBIQ5sOiQFd0NnnuFd8vsiI7qGkKwba49cEbYZs6mWRbw
	rAnv5G49KWSIKeqf3gndqjXj6FdglclPclmavZeuUDtImgb0PKW5M5Bvvq8JpsbFoyAaPJcqyXa
	mg0SbRMm1F92jB5RmBr24/gDIg+Iuu4u2E28f7yeksq6HhGf3kTBy9Q=
X-Received: by 2002:a05:6000:4185:b0:3a5:2923:8006 with SMTP id ffacd0b85a97d-3a6d12daab6mr10560879f8f.25.1750766246211;
        Tue, 24 Jun 2025 04:57:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8oV+65pjonZUUT2twzKhe4SP46fCBrgrxk3fCoS8F5YXm8ASpJVR0Qh9yZ13liHrE8jbSBw==
X-Received: by 2002:a05:6000:4185:b0:3a5:2923:8006 with SMTP id ffacd0b85a97d-3a6d12daab6mr10560867f8f.25.1750766245810;
        Tue, 24 Jun 2025 04:57:25 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8069d78sm1763378f8f.45.2025.06.24.04.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 04:57:25 -0700 (PDT)
Message-ID: <731f7ada-2544-483f-b33e-84c19d62d6e6@redhat.com>
Date: Tue, 24 Jun 2025 13:57:24 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] io_uring/rsrc: fix folio unpinning
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1750760501.git.asml.silence@gmail.com>
 <380d4fed5a9c49448f7ae030c54a6c0c5ec514c0.1750760501.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <380d4fed5a9c49448f7ae030c54a6c0c5ec514c0.1750760501.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.06.25 12:35, Pavel Begunkov wrote:
> [  108.070381][   T14] kernel BUG at mm/gup.c:71!
> [  108.070502][   T14] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [  108.123672][   T14] Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250221-8.fc42 02/21/2025
> [  108.127458][   T14] Workqueue: iou_exit io_ring_exit_work
> [  108.174205][   T14] Call trace:
> [  108.175649][   T14]  sanity_check_pinned_pages+0x7cc/0x7d0 (P)
> [  108.178138][   T14]  unpin_user_page+0x80/0x10c
> [  108.180189][   T14]  io_release_ubuf+0x84/0xf8
> [  108.182196][   T14]  io_free_rsrc_node+0x250/0x57c
> [  108.184345][   T14]  io_rsrc_data_free+0x148/0x298
> [  108.186493][   T14]  io_sqe_buffers_unregister+0x84/0xa0
> [  108.188991][   T14]  io_ring_ctx_free+0x48/0x480
> [  108.191057][   T14]  io_ring_exit_work+0x764/0x7d8
> [  108.193207][   T14]  process_one_work+0x7e8/0x155c
> [  108.195431][   T14]  worker_thread+0x958/0xed8
> [  108.197561][   T14]  kthread+0x5fc/0x75c
> [  108.199362][   T14]  ret_from_fork+0x10/0x20
> 
> We can pin a tail page of a folio, but then io_uring will try to unpin
> the the head page of the folio. While it should be fine in terms of
> keeping the page actually alive, but mm folks say it's wrong and
> triggers a debug warning. Use unpin_user_folio() instead of
> unpin_user_page*.

Right, unpin_user_pages() expects that you unpin the exact pages you pinned,
not some other pages of the same folio.

> 
> Cc: stable@vger.kernel.org
> Reported-by: David Hildenbrand <david@redhat.com>

Probably should be:

Debugged-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+1d335893772467199ab6@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/683f1551.050a0220.55ceb.0017.GAE@google.com


> Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Cheers,

David / dhildenb


