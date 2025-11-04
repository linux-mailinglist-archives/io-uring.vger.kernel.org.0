Return-Path: <io-uring+bounces-10368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7958C32128
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 17:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D24B1882762
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 16:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C46274B2A;
	Tue,  4 Nov 2025 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NUr6XYCV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF83267B9B
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273921; cv=none; b=E007J9TkxjlDhsXlrf04bUazEHzzAg2WCwkEM3AKPAZze6hCcM/1B9Mf9TKn0QfOmLtGveztdWxlPDK9fF0V2G0wSL/HMadRb8QZhYDhm4Oif3P7AJRDPrej9Ljkvy4Kkzu3l35qkDkKnLt4iSSZ3gQb878dOn2wNuuPd87OGK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273921; c=relaxed/simple;
	bh=4VFPklLqYtX/jdrg9wzjhWMHbHSz6iFaDKuezPH70jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=afc7BaRtuSAzV62tIHa3zQuyTa+I+skGclzz7q/9OLiclZWnNXLXPGWNObFtKMEpPtJqTLFbX3hSN+3f4sIb570ocX8ptonXeweBQ6XP1KaiRx5UG1Klsui9cmjj33gI8gTmNHgX5LFvbw2AkKHRGYA1/poAXGdIy7Ec8SrufDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NUr6XYCV; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-93e2c9821fcso564598939f.3
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 08:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762273916; x=1762878716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2BHowm207wgP9VU9HgJ35is8X/jKON/dW70RUpyWsQw=;
        b=NUr6XYCVhHh8qrflqcSmARwhX9n3a/f1GB54rQaphI/EjoVkynHJyHX3iWidyt20gv
         Xrj901V24/fpRgLq9BBI8H5H3Ex7p2+E1F2FS/NmGy/+ze6XlRT3i91rpveJjWezhtkd
         Vn1J14X6kbi89HaMz0l2MoDPeLYbRSFjsdkH0xMhskt2aw3dzGxwHS3g9PgFSpeEsT6G
         TQVV77N4fg36p8BehbJqcNO/S/oyWyzMezXDi7//6MZi+hdWlJqJqZWmvlEjARE3yIgR
         cd1YaqMfYAw4KC2uh15pbK7PKU+moAl+1bkAVbPCUQJ88MqeDkWy4datZCou2JCHM5AN
         y2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762273916; x=1762878716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2BHowm207wgP9VU9HgJ35is8X/jKON/dW70RUpyWsQw=;
        b=HagnE/Shyq2PslLI12gwbhdXK5py2iG8Wd7RfUKzIAhK+OL/KjQjoSgSy6zEXVI1m6
         ifLZ/iHgxTeh9KtEY0HAJFrsBdsyEc5E3SQbY2V9P90D32nbKLgSMGGqsgZikN+WCyUO
         U+35dz6Ne0wf+8wG5K1IlDbIF0aKPkO+8bWuDHnBXNdmOUDgSoiHV2kXwBdES5CLn+pm
         xfiS+c7GjqBcsBJV1DI5jQzJPTUuy8bMl37nVaCfVq8+wyPL5OQbvq9Vbt1xMqUnGTCZ
         L0WDewG0cyUS9F1BVYp1HSYqsQm2wZfUQeeN51+ECEHytZHg3JX/YPid5pzwaR8oGQoy
         B1Vg==
X-Forwarded-Encrypted: i=1; AJvYcCU2OcMcCH3uptVhoFh8LQdpKWw6NU4Pfz2W5RpcvixjU9UOx3po9QMAvgZAiCTfKBYKeEnfzIBfaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp3WZ/IxZTTKvTgSSKW7I/LtPk9uHnirq8+b+T0WL2uC2E4zbC
	njQ9mZuJtRS/gXo31SSoaT0np/2mwMcmB/TqRXmldaV+lnpJUzgCZa1hrIYDJaAaAbp1ZF+rNoZ
	Wnn9V
X-Gm-Gg: ASbGncsg69e5rvbZbQFWLHBiY20Mfy5QBtI/df4kg2w95cqMCihWRH6qFjS9hY7iWS/
	ZHgVEsp6l6ffAaegfWAzooAJ5qfh4Kf4FfEv/gl0ze+thSeeCYx95UlvWgSaEUN+1PQ4A/g5fR+
	fLn26ilTTsrcUOqLTnZCNBTJ34obpaOUwcsJz2dnK9t0RsMKfahqWoArMZdr75HSd5uCrGFfjxU
	Rednu72UcKoD3gWbtirNkwnCDDSyXxUzlYbmajzvGk/ZSKF15C7UQfh9ZviFPuH613+N237o+rU
	K5pLRkJNFv7EBmq6QPyopQSYNnZkmh83PDX1DyRM+a2BYyu1jOOORdqmzALP4U05AGL2WMnwjJI
	xM7bH/K1PjhAqZSQZyvyYist5MbF+0iDje8yf8o+9LFR7uyQQITHJskgee1s27stkkQ2SKv4WbB
	HO9b2qrxg=
X-Google-Smtp-Source: AGHT+IGCZI9F6EEv8v9RVuqsXLHdOKsTygD54RkRqIgDWFit/NLh7pMR2y9HFlUNkjSymAOe/HCUCA==
X-Received: by 2002:a05:6602:6d06:b0:93e:8bfb:726a with SMTP id ca18e2360f4ac-948229bd9eamr2494408639f.18.1762273915898;
        Tue, 04 Nov 2025 08:31:55 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94854fc6cdfsm125106739f.9.2025.11.04.08.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 08:31:54 -0800 (PST)
Message-ID: <61d52217-a737-4222-85da-6d2ae15faba9@kernel.dk>
Date: Tue, 4 Nov 2025 09:31:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] io_uring/notif: move io_notif_flush() to net.c
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20251103184937.61634-1-axboe@kernel.dk>
 <20251103184937.61634-4-axboe@kernel.dk>
 <7d071bfc-02c1-49b9-9c47-83ec62031530@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7d071bfc-02c1-49b9-9c47-83ec62031530@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/25 6:05 AM, Pavel Begunkov wrote:
> On 11/3/25 18:48, Jens Axboe wrote:
>> It's specific to the networking side, move it in there.
> 
> It's there because notif.[c,h] know about struct io_notif_data
> internals and net.c in general shouldn't, otherwise it's not
> any more net specific than anything else notification related.

I guess the notif stuff is all networking anyway, almost doesn't
make sense to have it split out. But as long as we do, we can keep
that stuff in there. I'll drop this one.

-- 
Jens Axboe


