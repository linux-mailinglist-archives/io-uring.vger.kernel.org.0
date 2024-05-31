Return-Path: <io-uring+bounces-2044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D93CD8D6B8B
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 145C91C25552
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7814624B4A;
	Fri, 31 May 2024 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ClFa7+sj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDD0182B9
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717191024; cv=none; b=gO94j0l9uOjOuVl/kqIV0zW9bYj9XIQBDwgcD+wfTrvqLX4OzFscV0BpJqyQ283fYSXQhpTUMX1kTgCelZQcMVm7vmGrq1vlVxGHZ0s30U/qII69cClsOkl4unTcYT/5WBRqnI6X7IwuxwXewXaKcur/SZ09Oyq8K267SYB7fms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717191024; c=relaxed/simple;
	bh=LKl0W6th+BKERbSY8pZEAnqVLHuG94KuZoojRceouWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=deZJ6bAAzPqMXpiVc1uSxrRts+vlC+nEBcYi05EN0aPuqekiBNjcbvRyN5sRlfc0XjFXsbdF3DoxtLl9v62dptfcwoV6loKgnsF89u/RCOO97ojrI2F1CHSNzN9Ri0fBUeB/MR1JdTO9MB3iryMvpaXUGSpjo9o4Lfu638A9KNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ClFa7+sj; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-64ecc2f111dso290642a12.2
        for <io-uring@vger.kernel.org>; Fri, 31 May 2024 14:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717191021; x=1717795821; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sy5IKBWMM2shXUBddUnGfO8egM0wSf++SsNLF8eClc8=;
        b=ClFa7+sj9J2ZBmmqVKsOulQ0JRdf1ZnFCK+csgmpEWOk7y98LD654UgVd1xrEurMYy
         VKqacGUa8/9K7GYdOKbyJk2ARisceJcdtJzn8vGvQ3OxvJ8GjwGEmQcEw3HWrq5VEeaN
         cJxIkZ1WuBbQ8NTdzqt+43r/kP1fgBuNu/L6xePbyltLFtAYBEt+IdNdo3hV9ciV+zQE
         Fi006QdHjuNP6bpFgO2MB1uVzzy+2h40UKDpY31pMBuk65aT1Av1PzxQSQaIATTo6BFV
         AbOAxRMyxzEuPHwRFX2E5XciurHqcTgUPFHto90JoxHG2opv+9AiC6rmh/QIRgH3E3RU
         T07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717191021; x=1717795821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sy5IKBWMM2shXUBddUnGfO8egM0wSf++SsNLF8eClc8=;
        b=ZZjKLGmpomMJmLdyAhk1VgR0YyDOU9ZVw7RptPcovCzxjt0YvdfgTUM3h/3OY9xeNa
         sEaJVrcQAHyH/nVfycOc1zjxOsMyw704txtAsgYNhaLoNB/QDL1SYs4pY5rZGYku+37u
         6O8Z3Yu9FDcGXOgan3bUR+mfpZHA+HTpUb41IT0BX5XpdyNV4Y5e1inxN1Gy/nQIMP3/
         qQ1FMGDaIiL+LlWD3s7Mv8QMapmPiFI23wP3klaT1VqjCpvv4/Jm6z0CkmOMKv0f/8zp
         2ZXdmmDL7BREa+GwCvL20ycXRRfp8z69u28I93FUWLKIgdy0RQKAoIVHpMpgBOTrtmLA
         9rxQ==
X-Gm-Message-State: AOJu0YwKFPhCNQ7oOCYCcpCbmWrpE+0q2POVHRuRhHwfJd/BLh1nh4vr
	YWFSIaF4DB4k+fmAKBEPV6bZH4zhwEV5/OjjMdLX4Ypo8WoPZGqfSUFhpK3M+fA=
X-Google-Smtp-Source: AGHT+IFqsWKRD5IpXEQFjVYHf5HDjhMvFO15Bcat/fj7davM/2CbtZpYSR8STPWmmeoVJkIK3b16iQ==
X-Received: by 2002:a05:6a20:3ca4:b0:1af:93b0:efff with SMTP id adf61e73a8af0-1b26f1468e3mr3734473637.2.1717191021022;
        Fri, 31 May 2024 14:30:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242b2f706sm1800399b3a.207.2024.05.31.14.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 14:30:20 -0700 (PDT)
Message-ID: <d071a3f8-c4af-48ef-adae-385ea8705377@kernel.dk>
Date: Fri, 31 May 2024 15:30:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] io_uring: Fix leak of async data when connect prep
 fails
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20240531211211.12628-1-krisman@suse.de>
 <20240531211211.12628-2-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240531211211.12628-2-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/24 3:12 PM, Gabriel Krisman Bertazi wrote:
> move_addr_to_kernel can fail, like if the user provides a bad sockaddr
> pointer. In this case where the failure happens on ->prep() we don't
> have a chance to clean the request later, so handle it here.

Hmm, that should still get freed in the cleanup path? It'll eventually
go on the compl_reqs list, and it has REQ_F_ASYNC_DATA set. Yes it'll
be slower than the recycling it, but that should not matter as it's
an erred request.

-- 
Jens Axboe



