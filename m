Return-Path: <io-uring+bounces-5597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85CA59FB5D1
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 21:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EA31160568
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 20:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003F21D5AD8;
	Mon, 23 Dec 2024 20:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QDNrd8JS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F77E188587
	for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 20:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734987099; cv=none; b=Za4cmevhLw+BOAkfDOV9im/Q6wa0mJoKBs6lOfbrdEdPhyseA801Xbxzvx2fL+tBrm9vm0cmMGsRT510dZtt1t8faUSb0DdWNiSfUlQibxaMvfk5aWjyeipJ1tBSciSrBrN44N4UfswD19Lp7Zz6/bkWnvT+JIZqgLDwfoqP2mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734987099; c=relaxed/simple;
	bh=iJLQDGnq5WK3rMYxRtvaFWfRqXBlJ/3X0LHx1ArAMmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OAWqpnomV/PvSLyDhqztkJO9Ff2l+E/ehP8Mldg2ciSb4Nu7RtCTiAKqK54rzgK7C87QwPsRaYAPkJthOqxCz4C2Swk6v27fVdsoWy23tPiPh8e7uqxYUz71Buj7+ySZ2jtq1Jhp3NYApe7hmsE7laCp8jeeYfkRv/IvsM36TCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QDNrd8JS; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2165448243fso49476845ad.1
        for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 12:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734987097; x=1735591897; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ArW7W4Abo5CHRwM6j0qFulCmMvkRwCKm2DvxayKL7Zc=;
        b=QDNrd8JSs5mY13gyILg6FM+5K8ME0oVH5rp9Nq1oXDVbCqldLmTS+zVqG5BnNUEVms
         CHhSvCc0TTB9saWXgbB+0GTiSIfnhTMGxjX2Nr6WwZDxK3dPeZDI2gcupnmzylCBN7lf
         zbBIET+XDvNCcu1aWZ/FDqi4c69p2pZq28EvNDPQjk0UfonCeQPs2dHKLqSyxtCrQ554
         BoWULePMy5MxjgUzi50LEIrAIMMfpAIRjiqEymlnLPbf2e5jSNL396YnKaiCrWWaUSnr
         q86k2PfhZ7AGlwF4I2JU5z87sc+APZ66Kf0TDopmDUwOIvZP9JFeY8c9WTzQFcU8gIIH
         5Enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734987097; x=1735591897;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArW7W4Abo5CHRwM6j0qFulCmMvkRwCKm2DvxayKL7Zc=;
        b=sG6J1qvdchP+QKTrG7epdAV2WtT8JzoKyiNF97b41XQABgLpCb9E8hcSs4fKw+kQOg
         lOazL7A62kiz82alpYUpXG4to8lPFEMuzIaEJsX5Ig8GhjXMC29swH4bFjLRO4n1Cd39
         mS8W4Lgs6AdGBzwnginiMfEtz49JmUGCM8xiaZJ6MIwjaTK+DdE+2oc/OnOokzBdfl2B
         tuZc0rkrfJeN4STVTk6eNJc2XdQzvB6LncxCB6jdrpw0PZ8mVd7M4dY4FN3zftXCz8Dx
         ls4OTL1Hzcg9Waaw4hNa0mihhCHWiL/m6U1KcYgHw4un7vU0EIUylogV2tUm4xnVf/W4
         PKJA==
X-Forwarded-Encrypted: i=1; AJvYcCX12MV63PXf9e8nZAihHdagQCNK6o0LVgTG3L6RmqlzaBhEFWU7PIf8kQ0aDjxAf15bJKT5CxuJLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVv/IKhAuH717zH1ILLian59K8UTJc+sVq7ie2zI9Po/F1eAhl
	M4bO3x0xjDtb8b53YP+hKYkZTAw8JGTNI40xDiwCPtjYZN7M+txBrAis82TXbDg=
X-Gm-Gg: ASbGncvRFfk5IWXArfu/F8X1DxesOzst5gcl5tJu6ck7OkRcIBr9YOFikALJ/9zGy+u
	oks9cd7RMzbyX10Yw1qwRjI3OkmmZR7aeByY28ZZg9RydJ8uOvQE6t/ON1hv6yCWJtPq5WZuXSh
	GQgmZSM80jFEDYVnEiwPONYHxlx0uYSS6JpwoxOlnF1w5Rde91enkGQwnBm1Uql6s8gUIceUnS3
	JRdtQnLBS4S1GdYgHqQJODfk3QlCD2dIeWliJYimFPMZ/sUsuQhMg==
X-Google-Smtp-Source: AGHT+IF+nCEhzRs6+vF5OPxC9cX97TRnKXK9iYpgEoSVs7O56zej1lfNaxiOSphglIOhRCi6bO3B9g==
X-Received: by 2002:a17:902:e5cf:b0:216:7761:cc48 with SMTP id d9443c01a7336-219e6f14859mr223074095ad.40.1734987096823;
        Mon, 23 Dec 2024 12:51:36 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f7457sm75967115ad.201.2024.12.23.12.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 12:51:36 -0800 (PST)
Message-ID: <a824c39c-89c5-4979-85c3-d0e41983b9b0@kernel.dk>
Date: Mon, 23 Dec 2024 13:51:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in percpu_ref_put_many
To: syzbot <syzbot+3dcac84cc1d50f43ed31@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6769bf7b.050a0220.226966.0041.GAE@google.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <6769bf7b.050a0220.226966.0041.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz set subsystems: nvme

-- 
Jens Axboe

