Return-Path: <io-uring+bounces-10880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB11C9BEAF
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 16:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6E9244E3639
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 15:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38964252292;
	Tue,  2 Dec 2025 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S8w5sAPv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44689234984
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764688610; cv=none; b=tlytksVyQucs0Jpjeo+z/1YnRmAEYsYVW7LvhsJYLCIoD0uRTK0EayGbAQgpNzfxMgX3y1LcbfDpQcccurnxR3crd6ApYmnxa6HakA4oVWe9QYzFl2hQa5CFJjYfsleGGxHhVdRhTPAni8rt4eEzGPkuviJXd1Aksxk9r7AAgME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764688610; c=relaxed/simple;
	bh=mAu0akhRHq/shpaNT69oOYFhqx50El6e8sTt1pWOscI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ut3NKZ720PxvUj2673oSqbn3Jo88wCYluG1u2R5TD2/uXm9PVuWNy1bfU1t1mir1sqCBEtCxhSC19JvcAg3g7tXx7UBOYhkb8JbgAgmkxvYeXCH22IRz5W8E7zsBjzhuT3JGYp24Ic91bJkrOKjDFLvzZwxG30MrS4W5XFwrx7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S8w5sAPv; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c71cca8fc2so3638834a34.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 07:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764688605; x=1765293405; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3LZ7jXwfEVLGzn6udKHx8/eLtM6cSG7PyocXsivACdw=;
        b=S8w5sAPvhtK0K4E3+w2gtHsQI0IFQ5uWf42Si1F2BAsPXQy3MYTD9BHbluiFJ/zg3Y
         qL3euwnutjBtpS2SHet4oWkr7i/2pgawMU1iUySHX+V9eR1Bi5e5wskypvOD8wM1dVAg
         iETwoIfK8SwcilGn7bRVO2ZMLTz4tM5OoiKNMHoR9h7s/f9Kz3zIvEEjGPKwVdsXFkSC
         W5FmMf7dfs1F8LGzkz9wJVi66xbCkdmVmKZoWkOG7sKwnRE3skgO/tTuUY8xvFKZdirE
         bth8z/CTzsYGFRPY02DyFRlOWDDx2DPI9euTnrXMAsZI0apBtuWA8wllGXgmJxzmu6ou
         HVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764688605; x=1765293405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3LZ7jXwfEVLGzn6udKHx8/eLtM6cSG7PyocXsivACdw=;
        b=sFevAqW/MM6g+fDHo5kqD01p2A7pZVmnEMZvopylpSwCgAbsL8nCA3eOygYWqPL2mL
         MVQ0ObvDSTgHkvJoCg5jJ+gQ4pz1LoF0CpKCP06/rrBZM7FDHSk46YocJ+ADh2YylMRl
         VXHpzWTmjeB02/6c4DVo7v3ZAdJqbZ7nSEa+mJMnD7WWifeiEsQV4PFr5yNENJJN/qxY
         DGytYgvjuyI37jUcpUPRqGnuOzNCttOWpDwuXrp9RViK3EDDH80EjpUFhTEjZzikW32N
         MxlLopREpR9PcYqSo6v3Q0vWtaS3cQoE+TqP4bqC9c3mKZzwY0XjO74dyKqIx17NyU+h
         umVQ==
X-Gm-Message-State: AOJu0Yx1nk8v8BBi1xzDZo8bhsLUebUSOdsw7lijl/nIK8ze62t8sZPE
	3J1tMHOcX7cWqANItur6cwccQdSTFnqsj4+ezoI91W9iV4/dWWti3hKNdAoEdY+hE6Q=
X-Gm-Gg: ASbGnct6Zc5l42IqA21MtFR1iRAfndcWUL0cGk33fZufc6YMz5QpiMtOgMJ+AIz3/1m
	Vf/8rFifiLElAaJVYmVUedgkQ7dT7hTjZ/+3/u51A1Qbth6jcG1be4X4/WtSWaj9qjkF5SWj8fY
	+/pYsHM5t1kxCKDCZyVsDzZB41mrSam9Kq4TgEahZbCrANs53CrlYv0foI8/lRTb6mpyXRxaody
	n6r2jH6x290mi/s7yZ/BYMn6G5g4tDnDJXcIwfUpIW4YzlRPzndfiVlKBsrhAjplcpI407qvHXh
	JdDayjPkxNDI4qc7Q54M8Hjj1ApmK144DBbxcarIQl4rV/75hZavfAnph6mxqk8ewVZ8XDT4NHe
	gTlEPZHHU0qix+cIDQ8ZLX9qhsa9RtA/ZtMTuFeWPrpQacKe+c2WbJESwxC5+nP63AfyVpcmKma
	kGf1/QTq7A
X-Google-Smtp-Source: AGHT+IGE3z9vnTemXpfo5dk+whs0kqZI+w9zN1eR6v2CdEhy4VsAnw9rs28vJ1XXuAK7PUMxQM8RtA==
X-Received: by 2002:a05:6830:4486:b0:7c7:6043:dd87 with SMTP id 46e09a7af769-7c798c4b2b8mr22020130a34.6.1764688604915;
        Tue, 02 Dec 2025 07:16:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c90f5fe927sm6722826a34.9.2025.12.02.07.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 07:16:43 -0800 (PST)
Message-ID: <7dbc9882-0f14-4e0d-9d9c-64307baa5332@kernel.dk>
Date: Tue, 2 Dec 2025 08:16:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 0/4] liburing: getsockname support
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, csander@purestorage.com
References: <20251125212715.2679630-1-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251125212715.2679630-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 2:27 PM, Gabriel Krisman Bertazi wrote:
> Since V1:
>   - bind-test.t: use client socket used when doing a getpeername
>   - Use the new io_uring_prep_uring_cmd to define prep_cmc_getsockname

Can you send a v3 please, with the things highlighted in my review
sorted? I want to release liburing 2.13 before the holidays, and since
we'll have the kernel support for this in the 6.19 kernel, we really
should have the liburing support in place too.

-- 
Jens Axboe

