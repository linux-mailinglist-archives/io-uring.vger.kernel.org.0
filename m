Return-Path: <io-uring+bounces-7657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DE8A98063
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 09:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA5DA3B7FC3
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 07:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5E8267B16;
	Wed, 23 Apr 2025 07:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mesS3JxQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B841DE4E3
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 07:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745392542; cv=none; b=M25y7ev7CmUzxCY7S9Gyl/OKGAEDo7f47Epr6OeJV2Bjpd9KD/P+g7AwItMw+1E8QJ7Gu/wJTHCeL7F6j0mVSImPeHPH2Uu2W36H1M4DwF5KabOYiaODvI+oTbu16I/fd69aEe2gZfmE/6bhoFUsr4sUMWfOTY20BTJKlbRtNak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745392542; c=relaxed/simple;
	bh=uI2wFD+Hm7/nLz67jPzMu1Ieo6hjbAhlm/gJ/rJb3Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=W+rZV/+xQOvG6Pkr3BmpHXYz0uLkcFb2CWMPiY5SJdULJE/CdtsE6tUZTF37nkPj6tP8MBPAy18s+Ntm4NLNCecyCnzZrIOU2839fphINxOrU3xggRwP3A6bY3BGtC5cQl5/Cr8oXfphkGE2pruqRznakURRFwYno7OSKdT9Gck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mesS3JxQ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d0c18e84eso27818575e9.3
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 00:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745392539; x=1745997339; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sh+uOd8eGU5o2ma6hdsKkM63VhkhvPlITdHi7SkwgXs=;
        b=mesS3JxQSSrP62vVJ7eATHl9pQjWE4Lwt7aqBOaCXBqGWTuLbu/xOS3khr+jCsFdxq
         ugwlbOCvEFyr01w/ePAtSamQY0IQ9dxWJwcqS04piJcldabkXWPT34WHrS/njo2onNZG
         PqE3tuSnQr4q45fRDDzQ1lxZ+IKd6dc4KGZ7kY6P3IXrQ5PYZvTZaKXLR0wa9SCqDKq/
         +JjRVRiRaUNSt2GomrPPn7nWQPq7TA1VK/cpXCkvTC5fnA//CvrrAy53BqSMNzik1Z+t
         i4K5Ese/ESpTp728WxxFKyl9F16B1yaCOtRHoGfZyskItW0U6tFwkhKJfEm/ORH9ZHzo
         QNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745392539; x=1745997339;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sh+uOd8eGU5o2ma6hdsKkM63VhkhvPlITdHi7SkwgXs=;
        b=NKGL3QSwddAVFgIXHA4sad6YI7glmxvZ/hqY0QeYqn70eRTaOxI31wFijfQNCdBwC9
         D1TBI5rUN/iViE+DU3/IYmb0zhf3SX0diDaRO5GW6lnWaR09yyQYIW9dWlqs/WKqI3OL
         dxYMe9NdOFNYBbo4OKZM8NpE9es4W/7Fcy8PgTUoRk+cvDdUWoNbgRRLOh0613nLpjDt
         B+AR8Q6i4cq9uJnZKcy5/d0YWnEEpeODZdM9x707QnmBD/9H1NdIrWxYbGPOMLh3apbf
         4umjc6n5qy4UD7QoRGU8x/W4RK8aW+cSrURWE3h6EtDBSOqsjs8vt581bzw5Kculs2O9
         6PaQ==
X-Gm-Message-State: AOJu0YzvFCaK2/RGegTK9xhNzYds40ZlVwsIi6ip+eW2OqZ4TTnznytr
	GgZX7S3UJHYelBGQjSY3i+4YsBrsIMbA4C7WZkImyQu741pbp7nJUH46pVNmfEg=
X-Gm-Gg: ASbGncucPs6tgk6YlNXdqW3phYmZ2B0Ya+UsBOKZn/NpZJ0B05gQTiY1+WooMnYXDDW
	KPNTuidaXuldo3KkR+4SWwgG2j9Kh5LvXgWSNoXrzMb2VTWMBHB+pVYguciTU4uZrB6GaEjz7Kt
	rkrkdbEbmkAO9lmC7iW/j14LijYgLz9Ep8EZHdsyukgI7MnvKQpL00tR/VGJNTBjBhf/hE61juQ
	oR7GBmSdTJHbldgyniV9YPKCfexIy/N1Fn3jbZRbJYwTH/EPT9F8YTc/RxkFcm615RCDlSYkeAf
	qqJ9KIclgDCM5BLlUMeqML89a0luMQUMdTTsguiXegeOmg==
X-Google-Smtp-Source: AGHT+IEQxBQ5OB7PWPdmnaqMi44eqdBJvWkRTL+a+rC3OOnK0jkaH3wQeHe6rhSrEMtt/qE7EIkgPA==
X-Received: by 2002:a05:600c:1383:b0:43d:585f:ebf5 with SMTP id 5b1f17b1804b1-4406ab7a7dfmr153659965e9.1.1745392538631;
        Wed, 23 Apr 2025 00:15:38 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-44092d22f69sm14641505e9.10.2025.04.23.00.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 00:15:38 -0700 (PDT)
Date: Wed, 23 Apr 2025 10:15:34 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: [bug report] io_uring/zcrx: add support for multiple ifqs
Message-ID: <aAiTlrx6uXuyoCkf@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Pavel Begunkov,

Commit 9c2a1c508442 ("io_uring/zcrx: add support for multiple ifqs")
from Apr 20, 2025 (linux-next), leads to the following Smatch static
checker warning:

	io_uring/zcrx.c:457 io_register_zcrx_ifq()
	error: uninitialized symbol 'id'.

io_uring/zcrx.c
    355 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
    356                           struct io_uring_zcrx_ifq_reg __user *arg)
    357 {
    358         struct pp_memory_provider_params mp_param = {};
    359         struct io_uring_zcrx_area_reg area;
    360         struct io_uring_zcrx_ifq_reg reg;
    361         struct io_uring_region_desc rd;
    362         struct io_zcrx_ifq *ifq;
    363         int ret;
    364         u32 id;
    365 
    366         /*
    367          * 1. Interface queue allocation.
    368          * 2. It can observe data destined for sockets of other tasks.
    369          */
    370         if (!capable(CAP_NET_ADMIN))
    371                 return -EPERM;
    372 
    373         /* mandatory io_uring features for zc rx */
    374         if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
    375               ctx->flags & IORING_SETUP_CQE32))
    376                 return -EINVAL;
    377         if (copy_from_user(&reg, arg, sizeof(reg)))
    378                 return -EFAULT;
    379         if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
    380                 return -EFAULT;
    381         if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)) ||
    382             reg.__resv2 || reg.zcrx_id)
    383                 return -EINVAL;
    384         if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
    385                 return -EINVAL;
    386         if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
    387                 if (!(ctx->flags & IORING_SETUP_CLAMP))
    388                         return -EINVAL;
    389                 reg.rq_entries = IO_RQ_MAX_ENTRIES;
    390         }
    391         reg.rq_entries = roundup_pow_of_two(reg.rq_entries);
    392 
    393         if (copy_from_user(&area, u64_to_user_ptr(reg.area_ptr), sizeof(area)))
    394                 return -EFAULT;
    395 
    396         ifq = io_zcrx_ifq_alloc(ctx);
    397         if (!ifq)
    398                 return -ENOMEM;
    399 
    400         scoped_guard(mutex, &ctx->mmap_lock) {
    401                 /* preallocate id */
    402                 ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
    403                 if (ret)
    404                         goto err;

Potentially uninitialized on this path.  Presumably we don't need to
erase id if alloc fails.

    405         }
    406 
    407         ret = io_allocate_rbuf_ring(ifq, &reg, &rd, id);
    408         if (ret)
    409                 goto err;
    410 
    411         ret = io_zcrx_create_area(ifq, &ifq->area, &area);
    412         if (ret)
    413                 goto err;
    414 
    415         ifq->rq_entries = reg.rq_entries;
    416 
    417         ret = -ENODEV;
    418         ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
    419                                           &ifq->netdev_tracker, GFP_KERNEL);
    420         if (!ifq->netdev)
    421                 goto err;
    422 
    423         ifq->dev = ifq->netdev->dev.parent;
    424         ret = -EOPNOTSUPP;
    425         if (!ifq->dev)
    426                 goto err;
    427         get_device(ifq->dev);
    428 
    429         mp_param.mp_ops = &io_uring_pp_zc_ops;
    430         mp_param.mp_priv = ifq;
    431         ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
    432         if (ret)
    433                 goto err;
    434         ifq->if_rxq = reg.if_rxq;
    435 
    436         reg.offsets.rqes = sizeof(struct io_uring);
    437         reg.offsets.head = offsetof(struct io_uring, head);
    438         reg.offsets.tail = offsetof(struct io_uring, tail);
    439         reg.zcrx_id = id;
    440 
    441         scoped_guard(mutex, &ctx->mmap_lock) {
    442                 /* publish ifq */
    443                 ret = -ENOMEM;
    444                 if (xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL))
    445                         goto err;
    446         }
    447 
    448         if (copy_to_user(arg, &reg, sizeof(reg)) ||
    449             copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
    450             copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
    451                 ret = -EFAULT;
    452                 goto err;
    453         }
    454         return 0;
    455 err:
    456         scoped_guard(mutex, &ctx->mmap_lock)
--> 457                 xa_erase(&ctx->zcrx_ctxs, id);
                                                  ^^

    458         io_zcrx_ifq_free(ifq);
    459         return ret;
    460 }

regards,
dan carpenter

