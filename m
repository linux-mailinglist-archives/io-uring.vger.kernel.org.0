Return-Path: <io-uring+bounces-7424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF89A7E048
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 16:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A2193A732A
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 13:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A2D1ADC68;
	Mon,  7 Apr 2025 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wDyy1aqp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C55A1ACEAD
	for <io-uring@vger.kernel.org>; Mon,  7 Apr 2025 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744034057; cv=none; b=Wk6+yCMYxtsMOOqc6v7tGxMep+zODN95RXLy7rWxtpxYe3DOr+HClm190nawHKaYRmFzPJlITgio5/9j6Ry5gHjK4UJ7dxzlVVw1ADLHPecDzgdQA2TqGZMtPCfKK/mhveK/WCVIU7UD0cByvlb+1L+gbXaDgAF3nrThfqzH8CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744034057; c=relaxed/simple;
	bh=MkXTb/ouK8ImRYD7V2/UgcaAK97B5qaOZF8+u14ugQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PVDGvlK8w90melAQpXwh41tzUL0X4ixHLSSiyIoq0AL9mO9/pZShJM7k6rxasdiz/S8sogXlJUne2jDPo6TmFk0d+gbx3IMr/dTBAE3ByImrsBRuAIBjCQarpsa0utBrJVq+rKz3citYwAFiy86WuZLMBjsaTDc6WLXtWV+nzas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wDyy1aqp; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so21127145ab.2
        for <io-uring@vger.kernel.org>; Mon, 07 Apr 2025 06:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744034053; x=1744638853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=wDyy1aqpegNO6c0N1HRaCO2GPRGZlZXfygkIKKJLmJrj1J/neJQOY0AXnqkr42tqvW
         zHxWkoS+FsXQ6NVNpExYDD5veBsCK0Srk8ntEIm/cvq7VHkW2xJCkqW6qT6QMvV/NmJ/
         uPkpLMoVqaLx3blo0ZA74hZJmIcHH/SPlADqJHrscGGbcJMphhzmjCYvi5MGgO0d6g/t
         yi1NktQMS+NssAVjgxjhiqefsCqpeSlC+aZVZZRcGyUJQqBs0Aib82eh0Lairq1fByvD
         D24E9Ey0fodE5WcT6uQKcfuePYhPOge4HGkUCcJCOeMkUzbadmhagE8iZKlfboiZ9/Jz
         blzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744034053; x=1744638853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=FrGXHeKvoIWaAxN7YB35u4ZeQ6AcItjd37amSHpAKtwMerESEgOzoDayN4lH17rWRt
         /YaTmx818xjLPjxxejKkWVs5w10AMx245U2aBlFYjy5mrLdSPaJt9E6KJX67u9WqrIXd
         hDls/VV6+zgtwS/znl3/xNN5wUYBs4ug2k6pONGU56qGNGjjiFUw6h4akJvdKTEU78IL
         3PtQaEv+qn0QsUI73i/cOUI56RPGIJhI1RfvHDPoQG/WvCuDzZ2qf410HwiywGX4hiCl
         cAGow4Xh6G0ujsmOUqBLOQlsRMezzfBS4F/em+m4jak6SzGjMbTsRFlwCwy5KrJIytae
         L3wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFbMHS9JdDw3qp2ZG7MLO0afNH5rCLNsr02zsA/fUiy85ZFcnGjv2x+0BB9V+/LI+adi99lJa4lQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/661DPLeo+rry3T14rZv3S1G9FhvuhMe9U6pLzKWwYE0VZIvC
	S9QNicHJsfS35pA5cvtcBX2aqYpjcwpApQ4bodxT2968L6lXKmHQgbCynF10Hw7tST5BCkN8mwz
	B
X-Gm-Gg: ASbGncsRThPz3EitXoq/14WEuUFZ+dlr2q9hryopFp02Ddzgi0U7Ct35gecvMXIe/lJ
	m4bHJgmlhbUoJNW56GjhravhTqdPtcG3nOPW3mlIX4y5TDJVmwhyNKtNsjPEMTDBKW7BvoJWW9O
	CkfeLlen7vaRF6iq8jkwfNNMlhUXOVZwXVVCt7SA3rmqlh2/9lNRxg0kZtKOjqb+KHW3uPXNRB8
	ldJvJMv6rcXLKpiOCAaLTAvi95SPgXVwKLBMaxUVLps+x0nFP9VKtAqxgTSb9kXWa3A/f04TRy8
	SleSdXsL3lVPQFVAeyuNLqVFVPT/UyFsJiEDXlp9
X-Google-Smtp-Source: AGHT+IHb+OE41VXBz4t2l0EPc4uLAMG7Y/fHmBTo9SI33zVc1xF3i9oLWho7ajI/jcyykBC9Kfan5A==
X-Received: by 2002:a05:6e02:1749:b0:3d6:d162:be12 with SMTP id e9e14a558f8ab-3d6e3f8e08cmr151979105ab.21.1744034053439;
        Mon, 07 Apr 2025 06:54:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de7b9b60sm24637645ab.29.2025.04.07.06.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 06:54:12 -0700 (PDT)
Message-ID: <7bcb21c4-4ce1-43fd-8adc-c22684cbf0e7@kernel.dk>
Date: Mon, 7 Apr 2025 07:54:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
To: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67f1224b.050a0220.0a13.0239.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67f1224b.050a0220.0a13.0239.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git syztest

-- 
Jens Axboe


