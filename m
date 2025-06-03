Return-Path: <io-uring+bounces-8194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6BBACC83F
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 15:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5283D3A3911
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 13:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E223238C25;
	Tue,  3 Jun 2025 13:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZKVPmdyU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A623771C
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 13:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958493; cv=none; b=ZjYx25tkoWWasu4q8jOTSPNa2N2PRDxxlXNPfRTo2sB2ztXomzkXCI6nGh4rMNWCdyTprvmFi/e+fAliWHBmWNDEtfU1YF280bp4o2wKZbig0iZKPEdimMiY0K/gGucUgkvSNJHt6XCvxnk6bbGmHPKDd94gibjQ9ar8B1yw7lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958493; c=relaxed/simple;
	bh=diENWU0rm8g8GWvSaCt5esaUVBjX44tVBHdazyJY6lE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uxOwFQ4k/MaPCvq33cTCLTa7InD2+fOr/9LJwH1/4JIKTR7CODjM4+4KdqQecpfrKbIlk29kV76GwWTi+v3YaNfXDkt5J5Mb+6a5ozhpjWIn/fZ5iYJJkwaLC3HjzciWmPPv2ibXRjkT1970CmX08KYN7vxucGLVJyx5oxT0W80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZKVPmdyU; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d0c598433so100474639f.3
        for <io-uring@vger.kernel.org>; Tue, 03 Jun 2025 06:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748958491; x=1749563291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZspdQ7EI0TACc+C0kgd5hGUIEk1smUx4AY7qpGGjV68=;
        b=ZKVPmdyU7MYV+mOwmEqngwkbiQHcugqDu8RL5QmSAhVVX9/0LWK1ZF8qOreUUVwO+0
         6YEiUDic7m7xMXsst0g2Bsq2N2ZWDV34Pi7CA7tsW4vyA2m5FbGOb7rx4FBRrmK1cdYs
         bizPvtFhZA4OeMcU7YN156B7y1c97bCsfT4eIILogxAgY+6SWWT4n1Y35MTvZp9GmR+4
         sZwFKfxmmJfiItpKhLZBcONMMrWy7JtC5CIrynRI4wviBo/jVTmd0AhNExBIlVbPQBm9
         xshl/5BrtEiNr5u6U5+jmJa1kLVhkQIV1uiWd4NgdlXvFOoq+nDFWMSPy6EqnbMiRLnI
         VE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958491; x=1749563291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZspdQ7EI0TACc+C0kgd5hGUIEk1smUx4AY7qpGGjV68=;
        b=NkeUdGXNz4YT31JZK0gKpwyYdSgag7DvPlkUWXyF/9CZhXlLcgmsguLiDVaoCSXpiZ
         GQi6VeL5kAgP+cLpm7bCcU3H6Sa/S5vMO0MwSgdi2ftM2f49IFo+KhBVas1jkS0Y5G2C
         B8+AQCmAb/o6PJaV8Xi1XGlnoDbYWLHGgc60gQIU39GkarLIIzGaNVwe3DwmOQmnADwJ
         MzCo/t8bRXZ4Ot64aNwhX1g2Ajmj0ElcEMmU5MDu6LByxQRm1dM3XgnTDxl2xayk2fWW
         SMC6sNsefk3WEK20P3X+SeI15cZNfRROfH0jeuZ7M7D4qGjJFr/0F7yNnrZuzSaS9mpm
         7ZrA==
X-Forwarded-Encrypted: i=1; AJvYcCXPtuC9XRaScHrscmDS2M2GnHLxrAPXDbxFnKsXGNOg7H9GX0IHylIVp23PfezO9M2oWTK0OIhurw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+zzL+hN2soJnmz20yUafH8VJiilzCVK4weBWLoEV9fp4aC2cH
	O02mEtoLXQyczCVzErCSpB0wb6G7CxqB+1+KpQ6tWimVqFlPgBxTVyG+1J60K51G5vehzYNrBGI
	9KPlz
X-Gm-Gg: ASbGncsPSPOYHWeX0g3Wqn3oBivywCn9CdHq4xTsNicjV9SVRYkLIFSThiEmkqpfc6t
	gG5KKzEQTtvEpNcrRWxWqqSmxopao8eeisKpMZA4aOBZm1TaNePMB0H8Fc2A2tc/JihNa5HezWo
	68vj2e18cyviKbWYcc2QLSM7+cUDCVMU3YTvDQPisSfN8N8LU/W7TH1cBxFclODtw1kSP7T/Wnv
	OwDhWI1uVmDhOKZSSRgSaDSUDZjbCRev9cDwjq6EVWAy+WBXcOnICmi4h+rWd3L3p/dZoxHrBLA
	pJdZ/w17c5Y3qlKyu04a9TShEOkoZg85Ccd9ZnMSoEoVDfY=
X-Google-Smtp-Source: AGHT+IHxTNlj5dRsC94rCewQM74xflTtLssDmZMFNikBqGrWKpDJrvzYli5sSElATcdJLn0xaxg7JA==
X-Received: by 2002:a05:6602:3f06:b0:85b:3f1a:30aa with SMTP id ca18e2360f4ac-86d2d9a8edemr1437460539f.9.1748958491651;
        Tue, 03 Jun 2025 06:48:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7ed81b1sm2278199173.86.2025.06.03.06.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 06:48:11 -0700 (PDT)
Message-ID: <2dfb1e75-6a4a-4818-80b5-4519c0a06c4d@kernel.dk>
Date: Tue, 3 Jun 2025 07:48:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node
 (4)
To: syzbot <syzbot+818ea33e64f8caf968d1@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org, krisman@suse.de,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <683d14f9.a00a0220.d8eae.003d.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <683d14f9.a00a0220.d8eae.003d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git io_uring-6.16

-- 
Jens Axboe


