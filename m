Return-Path: <io-uring+bounces-2410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F686923F37
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 15:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4627A1F21BCB
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 13:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C9E1B4C47;
	Tue,  2 Jul 2024 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbZeHPCg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6152915B109
	for <io-uring@vger.kernel.org>; Tue,  2 Jul 2024 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719927669; cv=none; b=iljoruSsyxswDzI0CHlqwu5msuOM73p3NdDhLRV+8u3xVFnvTASfzX+zz/vmUWht7WaDZNk8g2BpCTAAN1tGUSCUf4a+vLkH8T36Wx0hjdwib4dqtaOOdOpcbmNjqVUDxfL1IahBZtquH9Y+H2Jn8mpl1wBIaPhjSfWYt8Q8B5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719927669; c=relaxed/simple;
	bh=emuuILoaPNiv7/qLJe4vThUaWJpJ8SrtHxo1bZPObm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P7qhkuQgj4rRP+EAEjdbVq9PGj3uJEfxTDwD6PNL3niHNmgzaPd8n2ZDTCE0Qs0PoE2qho3rRnhdxH4ay1uAv83wYWS7l0MhPr6xjjTRpj/wPlNck71TBZEgbKvvKbYdwZ/f5EO5jc4uwxZVhefdEFW2iT8lNvGOoymisUr33Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KbZeHPCg; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-36532d177a0so2488093f8f.2
        for <io-uring@vger.kernel.org>; Tue, 02 Jul 2024 06:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719927666; x=1720532466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uYXAXCfWhbxVF2vd5+baGOK+JC3diKOmi5BVe4SHX68=;
        b=KbZeHPCg6oo4BTfX6EZlrEOl7rihgCSE3UMUD1G5Cjx5zYpFYloltHlFsaSXpbedOs
         DqHoRnveI3lFQLtZstdH5vIHiQvie7gkHJyHBVinoh6FMWK6IbGhgQKs3LFn5Ao0QHWY
         4Pt/lLpAtEAY2STfEH6ynLnT+T3qgStO+JpsuG7TbPVBF0BvO6P+QDXuv5ehJkJ8pqZ1
         GWlxsZ4eT+WL4c5czc2sT0Xnt05VlDmIvGxT91rCEKH21NbXCn8K6d0C8w6ZndTKvBpP
         /1fJ5WbipiRpnwF/WHFyhBkzjZHc4Fn+nknbkAeQ/f31VpK5AEglpfKJCSKKrkwO1hLs
         IjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719927666; x=1720532466;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uYXAXCfWhbxVF2vd5+baGOK+JC3diKOmi5BVe4SHX68=;
        b=sVHPGG9k1lHT7d2Pz3P438hfDNpbXJS4uHyppnpydK3ADJH3fzkWY4QFALs9Px8DDd
         vpLkcj4PgG1of2Gb7RS5O4makO69YrEciZXFIEGK0jqdudmMC4r6RgwUF8ek1SyQ/IBv
         jhwckJickMG24reM99rLj4y88e06t3+H60MJbuNhtziACflX5CBTew2K6tnsLzAo2LfH
         O3a8ijpLk4XjVhgfMGM7xpOHiQxSFPO+hktHaVbBZXN7+VmexnMr27W+LLTQhslHQXvf
         rSKKz9Sg8CaumzzrcdLf+S78473b+JhWdgRSP8h7hwqfr3/cuYxTCJYl35Y/44hEChsd
         Yx/w==
X-Gm-Message-State: AOJu0Yy2RvPd/10uzkLpibs0uE+DNPDXfq5+kGl6/4Carxqm1xB/KX6/
	ClpVjuNfwXJbMVzvfMHzq8nSkKV8uc+yXj4W8Cvj2u++OSOgDhFS6lBg7A==
X-Google-Smtp-Source: AGHT+IHkb7kr5WQKH6/lDOGPZJYPu/Z8lAkkiy8CeA1qJKBrcOB/FYWRTyFrUY/2ACf9Da0vF28Q7w==
X-Received: by 2002:a05:6000:ac3:b0:362:aab6:9a5 with SMTP id ffacd0b85a97d-367756a8d62mr5096051f8f.26.1719927666099;
        Tue, 02 Jul 2024 06:41:06 -0700 (PDT)
Received: from [192.168.42.74] ([148.252.146.204])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0e1412sm13236778f8f.53.2024.07.02.06.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 06:41:05 -0700 (PDT)
Message-ID: <c148fd4f-01ee-4053-aba2-f89b78cea40c@gmail.com>
Date: Tue, 2 Jul 2024 14:41:14 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/msg_ring: fix overflow posting
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
 syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com
References: <c7350d07fefe8cce32b50f57665edbb6355ea8c1.1719927398.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c7350d07fefe8cce32b50f57665edbb6355ea8c1.1719927398.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/24 14:38, Pavel Begunkov wrote:
> The caller of io_cqring_event_overflow() should be holding the
> completion_lock, which is violated by io_msg_tw_complete. There
> is only one caller of io_add_aux_cqe(), so just add locking there
> for now.

Seems like it can be squashed into the blamed patch
and it's still somewhat on top.

note: msg-ring-overflow.t reproduces it well.

-- 
Pavel Begunkov

