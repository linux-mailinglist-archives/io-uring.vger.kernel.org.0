Return-Path: <io-uring+bounces-7229-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B00FFA70199
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82916845083
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3DE2641F3;
	Tue, 25 Mar 2025 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ly9wMgH0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1874259CA2
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 12:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742907049; cv=none; b=bBCko9RzS138qLhEuBEHA4/XE+GAa9uWpt3neSN/4urfZpUlDrMWyD1BF77wz08fpZJNCPtNuUCDUyFlOEjJS6xCH5ZFCdmD252EZI2LbMh6yeFK6y8J6+ipB6Spt17DbMyZgH+4btM8PdqdWojGsKqxGrzs9qqSfNxdWQ9F538=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742907049; c=relaxed/simple;
	bh=fRi6zeg6T5KPv8WzZ4XrsVxzdIG8PsIqcDMVZVuZ3yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vD0lvbdA/V8mC6CoGsEI/Tg4dWKBmXt7wK36h44XrzVEX2h2MymQqyCw+iEEt898i/OtkIcjaUSLfTqfGz68UWFMty4zwETDEyfjK+a6BMnann+OUzVkO8z59ybIrL/t0t4uqcvlpT5SY6Iywq8Riq0dGbEv7uJB+V79X4dCp0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ly9wMgH0; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e8fd49b85eso86848486d6.0
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 05:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742907045; x=1743511845; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=86XTbjdHZToTO9vFgFMOUGoOt+ekVajyxhh4sxGzdh0=;
        b=Ly9wMgH0r12gWqhtoLNAzVFDpE+A9YcjarPtEwYA4cowDL+LJIdiIFXiuEc7Cg6pe7
         N8emrmLy1dnhvMa+KWgG92/dojfPZmj0B6Pr7RrG8iKeW3OmyttZLU50kUuyrKlKNjVm
         WGxGni3ayKUMBQs/5q7vkqLUtECzXDh+JsjA9sMbCVYFfK+ibFRRWCPQkD0ylsaFWBfL
         DDm697XL6NImQ15/lUu7S+6PcB67LhgpgK6XW0AIf/mrLC4bby9zpg5iY11aYLvt62nC
         wfGyt/2E/E6dO3e59qf8xGfH6qUhgJrXz0jfbKte/EX4Dd3lefsx0pAovF233EdviKDj
         gSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742907045; x=1743511845;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=86XTbjdHZToTO9vFgFMOUGoOt+ekVajyxhh4sxGzdh0=;
        b=t8hwvzGCqfLcn339PebAR1I0LhnilbxaRxS4F/8HtNEzfUR1yb+H7greLCaKOvTjvc
         G7ox75JDUVY2bwn5j+Ahx/A6d8XILC5JpxNZKZGknprzLSTf1crhfezDsrF/YJjIureq
         EciD3R0rcgpFh2YLznA5AdhFqprzN0qZVYevdfpwQVEH4CpbZCR0fzCJta2vf1BSL/30
         gKjbqph2IowinwptgHIJoP6nehKfIwdJ8pMdZL03p1W/hSSxoyXPi6SKx9Zv9vi7N77g
         c2T0Jtx+XEe/5HykOXG+7JWs31KGy7LwBUmwqkP1iz6vyqcDlpv7LL2G1y8/zpaZbvAT
         8hog==
X-Forwarded-Encrypted: i=1; AJvYcCXP5Uxs2LUaXxKaRgcwxNZKhh5jFomwf78uuoWX216MV1owWsdJUaBiruCig8PY7vJZxKVuNiV0Rg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr/GBvTHjuCk54YEQBvlrmP9Fj2d4V5so5oiK0FDbyK0Uf4aG/
	K2PInIHIZFQ/L6K+fH919SBpRf+9eBCvF9rp6/qzDP09vYHGjZC41RDqHnqCoq0=
X-Gm-Gg: ASbGncua40Whfp7k0LAynKcNvLq766CJn4b9ssGIo4UM98FDbsVWSvnSg9OSGv8DnBC
	8/fdGqsLqrAfP0Zg2VyCIdlrEeE/sZdTRZJmiGIILwrLziypL98cwNSed0br2d3Vs5B4WRwSxnT
	afUsBmuIZjhhsr7YcH+IqO1Sk2a1E7zORAb7HGQAYVSKzZShfOyDfgg84bomt7r9ObwiEYop+zY
	zlGBexS6cq+nU2AZ86kyfH9nHk+jfha/IRo3wt/kfPmLOWP8iQ6sE9p2bFat4g0iyTLauWA4hYA
	gzdAi6SpWeRAOt8+uDgauv2xMXI54XRE3wMAQv/6WA==
X-Google-Smtp-Source: AGHT+IGuLsKAsZriQ88efYyaOks4mTlTOIy6vgScpsPY432E17wHEpRLiv45zRl6y2rkbK9/IlgDcw==
X-Received: by 2002:a05:6214:212a:b0:6ea:d40e:2bc5 with SMTP id 6a1803df08f44-6eb3f2bb5fcmr272837256d6.9.1742907044676;
        Tue, 25 Mar 2025 05:50:44 -0700 (PDT)
Received: from [172.22.32.183] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eb3ef317fdsm55908016d6.62.2025.03.25.05.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 05:50:43 -0700 (PDT)
Message-ID: <80ac818e-33e0-4b91-9207-74da182de025@kernel.dk>
Date: Tue, 25 Mar 2025 06:50:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] nvme/ioctl: don't warn on vectorized uring_cmd
 with fixed buffer
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Xinyu Zhang <xizhang@purestorage.com>, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250324200540.910962-1-csander@purestorage.com>
 <20250324200540.910962-2-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250324200540.910962-2-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/24/25 2:05 PM, Caleb Sander Mateos wrote:
> The vectorized io_uring NVMe passthru opcodes don't yet support fixed
> buffers. But since userspace can trigger this condition based on the
> io_uring SQE parameters, it shouldn't cause a kernel warning.

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


