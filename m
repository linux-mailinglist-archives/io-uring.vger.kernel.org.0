Return-Path: <io-uring+bounces-10358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61ABAC311B7
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 14:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D02342131E
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 13:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359732EC576;
	Tue,  4 Nov 2025 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmXcswqa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D93B239E65
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 13:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261559; cv=none; b=fw+kcsycIsEEYTgyjnTs0OcN11cUdJE02NvSMXgg5kl3+UX3l9SUpmc3ajg9xEn86LkoYFWpdbS9VrMClUCyOs3m/p+MFllq6w/aLpTlVDjkCwD25LvorS/AeqzPhP9liJ3xz3Cjl+p4M70DpMyCRDH2MSH/zaLjbdtSaSr02Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261559; c=relaxed/simple;
	bh=YgIBf53tbktfv7ufRbdwMmaZtnz4p8mbpaTDS9mejBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZCdXuqqrC6SWD3cXZd3+xMJQayaDwrzV57sWybyMQj1GLXsxYqvWLcU+A/geyawZtsg9M3TWeYtKmiB3qaTL1YYNx1RijfVVMEe9X/YJUl3vVuYuXk0pvr0OJBrhsjEy4t68rsbxjY7GFqCNCUcjrmEczvuw9dZYcBOe/Z00gfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmXcswqa; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso286025e9.1
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 05:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762261556; x=1762866356; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dBujDGPWI1BLknfUULW66WyvdibM/fM1T9snJzs37h8=;
        b=hmXcswqaGO5o2sNXpxNWZC8/bE+pOgLFjmsWbsofwJjuZZnM5uB1Prtlc1WjHypx17
         O23fg8YnhoToN2I1R/lOgDCroIHyXF2Nb4fujC421yhYc4sA5Sul8H8C6qOaXHTt/U2f
         IAtFd3s1uxfK4k1DyGYrufLSw2EbY9WnZTwIm+AW8H+F2yXL3KE7k5kXg6Iu2bwSBs8W
         nc2n/2E6tc2EdB7VqfJMpfeQZrkZSQ3Aa/Up2fuS8V4QWdsWzpyMqsrsfmf2xYMRPjX5
         oVkg+rAmrD0GS8+15YzZbg5uljyhBtIJtdV+mIhgQD0r3/If+kbhyLRjNDKY3qvq3XPB
         OW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261556; x=1762866356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBujDGPWI1BLknfUULW66WyvdibM/fM1T9snJzs37h8=;
        b=bB3lY7iFish/iaaj+5QB2YK1b3m1OuaIP+mRQpk/5jBYThUtri9lGMNUuVN5Tu/Myw
         RFoKpqeNPUR0S4dOHcOAOtBwOrbklusw4cD6RnK2nBrHQCuxpAWaJgXx4NH3CS3QGEm1
         0tHuc8ZJpFOQHiZkeXyj078Orw99zOTWc+e3FyAkaj64ADW0Ng+EqtQAdoYX6c6hucF0
         bc/JBaqQ6AX41fV9rFLdqmKLEqr4fSep6YVg/HLyshARMXfV+Hr0Z1gj+ASECGiXYR10
         dQ4o5x29AxeoOZy1P6RzaWQYuDzkcWoX/2OY60zQFI+JLgek5w6OiU5Oyk5GKO7EPfpz
         IxRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5+w/Xrdng4C++D67ZRZKOUg7DjyXMmqzmp9K9K9a5cUBvoTd1dRPLhtI4JbYF7v7iOZmqdCq0nA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxoo+ga6oTdHlc5s2z2tCbCdyzOpa9GW+x0GvGHcMLHHCdnKWr
	YUWjtuL0dOBqrwjND8OJrTOa1pOUWldhf4xQtnXs9uyGe4ldOpHbdZaU
X-Gm-Gg: ASbGncsDAm3pHIrrjsaFcKugg6eg11BBPw71otDDlnS+FY9BKcW8BYrZxAK7UPIKwo2
	X0ZCn0P8hf9nCnzzSSqsp7zCdrsxPopJY/G+RbTSWT5mYrKrC34ITTYWw9Ff0JsuJKFd+bTIoDg
	86N2GVICYmCInV2KofvlM5sDgRbAoQ9t9CdXutxTJQQVJM4WBq8BfQFTTMBCv11YND3jZ61vWMn
	QwQx8RTxW4B8I3DQM4MRH0xv23j51npVqNoilqJoD8AfAIcH28/aKgF1YoblrL0+ae5aZ/I8mD2
	XoaPPKUrT2KUb4gfSkclJNOBxKqkxSP9x1oRNeCLVj+RCGwHw0sBBzn36eYuybzmiXrFhGbjwK2
	ElkfSBLPHWaEVtxS+durFt12MEDO/VSHUlX0KxfyOMnZaGMIVc4ssOqmU6nlc56r+/MKyfj6Gd4
	1ljtcDxILubPpXV119TCpG4pDrJ7uoz0JXtUslNMDbZiW2GGStKBwNdiRzOmJjMw==
X-Google-Smtp-Source: AGHT+IF6Do6vpYH8qy5Yws3PdFJR5VHwY5gQTpHZtFzE8uU1bNKGYNd0Hca3FMqDpplbKi0ArKKAVw==
X-Received: by 2002:a05:600c:5252:b0:46f:b42e:e394 with SMTP id 5b1f17b1804b1-477308b0a6amr150708155e9.41.1762261555450;
        Tue, 04 Nov 2025 05:05:55 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f5ccasm4480133f8f.25.2025.11.04.05.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 05:05:54 -0800 (PST)
Message-ID: <7d071bfc-02c1-49b9-9c47-83ec62031530@gmail.com>
Date: Tue, 4 Nov 2025 13:05:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] io_uring/notif: move io_notif_flush() to net.c
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20251103184937.61634-1-axboe@kernel.dk>
 <20251103184937.61634-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251103184937.61634-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 18:48, Jens Axboe wrote:
> It's specific to the networking side, move it in there.

It's there because notif.[c,h] know about struct io_notif_data
internals and net.c in general shouldn't, otherwise it's not
any more net specific than anything else notification related.

-- 
Pavel Begunkov


