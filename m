Return-Path: <io-uring+bounces-7300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1380CA7561B
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 12:57:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4FF516F709
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 11:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4FCB1C75F2;
	Sat, 29 Mar 2025 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Zd1cMoJ8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90E91C5D5B
	for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743249466; cv=none; b=nPP+gdcZ3SPrmIEhwVi7Gvbtlw9/SLKCgoZcyr72+WmS8OhiHoLDlqkv7KP49k2MoHyrRvubnaNt28xXLTrfbPfw+LNdESN8wEMQEv7JLqOEZpNB5q7ii4BMKQ5FV8c7WjujknctFxD4YSipMYQppkRfKVZ99OOD+s/EjQB1mlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743249466; c=relaxed/simple;
	bh=5C0CqVx382ZeaEsy06m0RH5YE9U+klBqmJGbuqPsDi4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UcIk3F1+s9TuJCQPmCDbvN5XmwDdkcKSFgMtB3HM+FtZHaUncPZpKEV7+CyoNOHBK8RwWKBIkvD7oXJhL8mzNtjQ6IuBUtO90j4iVQgtLxKcuT2/fDVPVhBEDDRliNBRrQDUT5KBkjDpqZaJDyLbKRGcpsyNhnUEQ45eWh6eln4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Zd1cMoJ8; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d03d2bd7d2so33229735ab.0
        for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 04:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743249461; x=1743854261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dq0x7a1wgRlDWyWdQ6X/9B8y+nTyu1lClYpvcORRHVo=;
        b=Zd1cMoJ8eGt8ed3Lf74pwIChdEYyi4ANohsupUx5HOjK+N4HQybBfyryf6mrlNEVw+
         4jAQfPtiWSRuwFAckM6jJqwLi7wy3yvY39d0ll/8/8Bt5iF0GvK3putYymTd6c6EWahi
         QbNOfw6QHW8YJpvdGJHiChfvihNvYMuSHPcG8G+D71R1CuT3BRoLwIxp0VX5AErL54IZ
         +xCEFtZLaAQHoMs4k4s7JrtpahCL37bx7Bz2k4GqxeM0xyg9Q9EiDrNhlGJHDkjyFDMU
         C1WSD0jCVWQFxmLQf3F3VGOhvExIJxA478RrFgQBTTFlE/8E1/pswmRKD7Nd8brDkQBU
         Mkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743249461; x=1743854261;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dq0x7a1wgRlDWyWdQ6X/9B8y+nTyu1lClYpvcORRHVo=;
        b=pFmbAVv6WSD6UE0UicjglCb6barEJ6pniXnedxXFPaqozemoGotl6c0Qk/JSMCbh5Y
         ZKl6e9CL3/y/b+hk34j2ERCZGa7MgHHsRbF2+6mqoA4tGAyQI7/Metnboh0d+wT+kqWv
         +t1jdhF4BkpvjGQfPac8ZcHdJcZOFJ7IaRY/vVhTB/7NGYpC6JCJeNX/Xn4Lyraf0Njt
         4I/LlApOlNEfhNZV6E7mgQppyrk1/zK4dPElwDCq5wBdy/YpykgKLTZk83PUdx6hglwH
         MrJwj8otULg5trp8bOAG4dVbYaJkpjVgDL9QHvCeRWlWQkvktwzSMMfkqE/4RBnEpYrW
         O/+Q==
X-Gm-Message-State: AOJu0YyyULcO5veq5HcPcM3s+I1Dg09Y4Dy0AEzqa8jaLB9Lalj1djKD
	bSxAYkWLDxi1P3m2MoabarvecCGsPSvJrjvOr95LBeK+iHzYvYQCqdLTPVDlsQ0PW/Ho/ttLbX5
	k
X-Gm-Gg: ASbGnct6egb2EPpaFZyodjZkBhvwp0fB4126o/8OvpP72Y6gs1h3/ZrNiiHi+L32Fpv
	AJn9oTBqOXi8Q7i9BpMH6kX1hd9R7yAtKousjfgkP37F1uJAYAs0lg+cBPVb1FN36HzNjnjF6zZ
	5z4OcbsVaTTy3ehqbxxh9jCpKMLO3nyXvGYROgzBZH1APmzAGSWrg7yD8SV2k9orzzJ/En8DTm7
	TPjBJHJlDZDN15eLflAsFi9jZ32h/ZrNtvvS0BGXb0/Kp64ltIe6D08eRurMdmOMJoxx4GSuWKr
	lkExeELMSyKkedBSZtEKnMHh9B5Gq5R1R/8LpSbh58L9ygQ=
X-Google-Smtp-Source: AGHT+IGc9bB6oC8qcwrNMj2Z+yl83r31o61fd262Bl6x1/tyfuRnz2PAqW+h0pip1CimQyoeUyN4fw==
X-Received: by 2002:a05:6e02:1989:b0:3d4:36da:19a1 with SMTP id e9e14a558f8ab-3d5e0a01a20mr28534265ab.21.1743249461388;
        Sat, 29 Mar 2025 04:57:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d5a6345esm9616765ab.1.2025.03.29.04.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Mar 2025 04:57:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1743202294.git.asml.silence@gmail.com>
References: <cover.1743202294.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/7] send request cleanups
Message-Id: <174324945999.1614213.16013468244929227092.b4-ty@kernel.dk>
Date: Sat, 29 Mar 2025 05:57:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 28 Mar 2025 23:10:53 +0000, Pavel Begunkov wrote:
> The first batch of assorted cleanups for send path, which grew out of
> shape over time. It also prepare the code base for supporting registered
> buffers with non-zc send requests, which will be useful with
> leased/kernel buffers.
> 
> Pavel Begunkov (7):
>   io_uring/net: open code io_sendmsg_copy_hdr()
>   io_uring/net: open code io_net_vec_assign()
>   io_uring/net: combine sendzc flags writes
>   io_uring/net: unify sendmsg setup with zc
>   io_uring/net: clusterise send vs msghdr branches
>   io_uring/net: set sg_from_iter in advance
>   io_uring/net: import zc ubuf earlier
> 
> [...]

Applied, thanks!

[1/7] io_uring/net: open code io_sendmsg_copy_hdr()
      commit: a20b8631c8885cda45a331a151d29a83dfbfdefb
[2/7] io_uring/net: open code io_net_vec_assign()
      commit: 5f364117db942c15980111f2e8ff6025c7e5893a
[3/7] io_uring/net: combine sendzc flags writes
      commit: c55e2845dfa72e647ed8d9a7b4c6e11a8ed0fc1e
[4/7] io_uring/net: unify sendmsg setup with zc
      commit: 63b16e4f0b90abad500ecb7bc7a625278febdc2c
[5/7] io_uring/net: clusterise send vs msghdr branches
      commit: 49dbce5602dc50343c9794d0ddf05d1f6c9cb592
[6/7] io_uring/net: set sg_from_iter in advance
      commit: ad3f6cc40084f9adb1a53bf386d966073dc6a4e9
[7/7] io_uring/net: import zc ubuf earlier
      commit: fbe1a30c5d3e6f184ddd63deded6f30c3ecc4c3f

Best regards,
-- 
Jens Axboe




