Return-Path: <io-uring+bounces-4372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1B39BA86B
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DCCC1C20C74
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8945189BA0;
	Sun,  3 Nov 2024 22:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/R9nKwh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3536D176233;
	Sun,  3 Nov 2024 22:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730671307; cv=none; b=nh27k5qAN4mkzn17o0MM8cKlkFvwB3cSVqW5fTfcCVqOld1a3PkH6MKAo6aDMU9WfA4YBoH4ESYWpB/r9n9g3mlCFjmGDgLEzo+4Sp7z7fAhxLzGT5UkjdfbkEoy6oi+FF/FevhYzBTbTZfrT5SS5nO1hypaTvJ4QMqJ1OEPHPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730671307; c=relaxed/simple;
	bh=/c7+eVEfAlyBOZLUxM7Po2DGxU0pdwK6+J+qznd6Y9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bJxdxWYjXrI1urVwttNHnu1Pc2+37H2gS7sjaoGTiOYKdVCtrpcpmCFMc8oPoPHROqA+/+n6wXzkpYG8Cx8vktETZNuGOCYHRyhdlQqRlwjXQmex5wCDMHXRHXkC6R+llX6FX3PajRKC5oXceOGTiru5EM3xN60vLWLlDA5ddZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q/R9nKwh; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d518f9abcso2516736f8f.2;
        Sun, 03 Nov 2024 14:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730671304; x=1731276104; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ywM/fl3gftWQ4VJhR6v55mxzawiaiTlz+rX2vu+q50=;
        b=Q/R9nKwhXxG90TW0JTYHg35rypNl9QARpfYxKtU0vuTUMqQKMN8LG/vCub6gVIA1GH
         VDe3400dumNfqtOsxcQ/vSSflUtnbfAT80unfYxKaH1yDnP+NjZ3rbkihNmtnuyqbFpI
         biQWtqgmARcDL/Z/DX87PSDKx3WUlrt+L2KirT4EGnHlTXShHdibf5c50T/htF7CO6Cb
         Q1AXNcRkXqG3+k8cIjKz0YA0Gxp21GaAuUYMZxao21iJjbKPhJ9cKTGpprLEDFIXfxYJ
         Tc35zcntmWINx8hr8+1zZh6XbMi91YdgItXQ0DEMMYKUY4XpnrRSFVcVwX9GZDEQOokj
         w7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730671304; x=1731276104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ywM/fl3gftWQ4VJhR6v55mxzawiaiTlz+rX2vu+q50=;
        b=DzAn1kOec/ZgS2tst2dbSEVpPFQZ/UJOnxn2ORYB3UKw0NdvsgYue9/YHx73aU+LA1
         aC+zQsPeteQNSLbHg5yAunnUpv/1bOrWjNHFRR7VbNc3hkp9KVYANSLP8sfustg/Amgq
         9rfaCsHBya49nu39kxKYDh83oWaPvNSj2ocuqLiVm2sHX/l7oqrx8orn7GLm08IgcXMW
         x4JveJL13uK4ednJt8fQ60BeNCEvljV5jI2T/99t78/rJeKhozO12fBNfamMyH1NAVR5
         ZmEKnw/zhyABls2ZN4JxnDfs1l5QDpiPyNVnZv8zDlAUJEzrdDR82FEZzDLAUgKcmGG9
         s65g==
X-Forwarded-Encrypted: i=1; AJvYcCXd9Si6MADPMLlr7pP7REtzw+TcvgaWaIQTdH6m49rtBN+QbupqF7vntmeOpUxAuD11F212zJXVU7bpJg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yytr5h590Hru9x6y43fkAfnCHgA6cFqNXFaowpYuOC2q86sZT7O
	fjq7VPIHPB2GGq7Txh51JP7L3OH2z0DK9+GnFSLKb3QqnhQMPwnPr6EbmQ==
X-Google-Smtp-Source: AGHT+IGJHBYXy3GgeVC/ezo0/wH8PfuQ6ICosf6MptraxyqnPsyOhSbDA/MOc8i3e9D2ovmx5irLsQ==
X-Received: by 2002:a05:6000:104a:b0:37d:2de4:d64 with SMTP id ffacd0b85a97d-38061162c32mr19755152f8f.35.1730671304194;
        Sun, 03 Nov 2024 14:01:44 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10e734csm11495671f8f.60.2024.11.03.14.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:01:43 -0800 (PST)
Message-ID: <ede8da14-539b-4f84-b46c-518457df4339@gmail.com>
Date: Sun, 3 Nov 2024 22:01:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/cmd: let cmds to know about dying task
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20241031163257.3616106-1-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241031163257.3616106-1-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 16:32, Mark Harmstone wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> When the taks that submitted a request is dying, a task work for that
> request might get run by a kernel thread or even worse by a half
> dismantled task. We can't just cancel the task work without running the
> callback as the cmd might need to do some clean up, so pass a flag
> instead. If set, it's not safe to access any task resources and the
> callback is expected to cancel the cmd ASAP.

I was just going to write that you didn't CC io_uring for the
rest of the series, but I can't find it in the btrfs list, did
did something go wrong?

Regardless, I think it should be fine to merge it through
the btrfs tree

-- 
Pavel Begunkov

