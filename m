Return-Path: <io-uring+bounces-3929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C679ABAD8
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 03:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACBDB1F244D7
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 01:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57116168DA;
	Wed, 23 Oct 2024 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WuWt1lZ3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A074F4A32
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 01:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729645879; cv=none; b=KrSIrwaVMSZ3LwnDkCwgjMsmwh9E2gy+p+wIC8eZJHXZFJUlkZDyjdKBmPmUYb+oAc4Gvb/8L0w/s7f6mz8ZeoWDtZNN6FV5Oqs9AV/cpGqAxWHIuBNtBhQyMrpW2gVRDp03hjwf9BjgcCB/ouOX73DMilmjK1OyzWScG17Euxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729645879; c=relaxed/simple;
	bh=PahWAHcbCDSrFfPODlI8INWUH30nbDz07iBszKp8XDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FQ+PHwe/qfmGV5WaiHiKf/ZIdSjyGfRxXkkxOvK5v4uZJKUb5sY9W9hqn4Rgh2KQaA9bUUNUubEWQBdOyhujT4CX2FZzyQBm4i5fSEqjK2b8asKay6Sl+NUJlNLm94r+fWv9r7JSzHSqJugZ8NnMxs2B9qIMdrNgdIIwHd5VC6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WuWt1lZ3; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e467c3996so4120772b3a.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 18:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729645876; x=1730250676; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7EpfrZy46viZZtoAa1v6SwV+lfwBXPSIjLSjs+x6Zj8=;
        b=WuWt1lZ3z80PNJsHyG/zqHNWU3eOTyjl1f7XtqWExEhNwP5wx/0/gPZpOzekuW1sp9
         0g1wqZgOc8J9NS9oj9qjNdu9I80YkcjKyDHUSwfLUSrKkLX/sg5qYL+J0owzg7YCd1qW
         vYb3Hkc26lkkhlox0nJEMO4DhwYcK+6RNI+ZKKqS8ZVafSGppw23n/JZMueem4WRjpJZ
         PBmyA624h5Y6HOipwgh7TwbY7gqh24Y6b05BfzZ6d52mszxX/we6KviN60w4XJLyMgm3
         JOqFtXMR5WusLmXiddHsymnIU5UYlgxohw+8ltBS6KSWYPZmJvI1Z35HpuTNCcxLhzkG
         BI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729645876; x=1730250676;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EpfrZy46viZZtoAa1v6SwV+lfwBXPSIjLSjs+x6Zj8=;
        b=ao01q7jsEBN6pI5b8j+zQLlCojZgCn+4TKvcDqffdptOVU43YGQfBkURaep79CTRDu
         VYJ2jcNy7QWuExXU5u2WbVW2/rSwNmphnPpORUhlQYYUOaDmDY1gfOFjAxBL0fWXBPvg
         3bCwN833P0pRW0+m1BQpWWJned+zrg2P5l+urBfS+gzBJq2ZdoteG2pS/9LPiVe3759Y
         5s+WoKRbNHrvEY12K7m6LvN8zKNzGBZw4jg9j084tCqjD4Akbr879L2YOUOF2SL66msj
         q3NqRtQXPHANTqSv+s26856ClFTUa+odIplBIMqQSKOA5PmKbVZTSebmWxcTgdo5Otk7
         ZbmQ==
X-Gm-Message-State: AOJu0YzhBOsT2z8ry2TNsMI+C0Ulv5gwx5VvYQVktZhretGVFkAHa/de
	WtQdXhpQHLW92YxOlzHcF/0GXebuL9JnlRGxaWthR/iXtNX5mIj77B2c7ftpIH1dp5cl6US6Ubq
	k
X-Google-Smtp-Source: AGHT+IHCrF+RY7se/FMh2p8Xw1srIVmM0oiXaafHubswcog2otmWPz51UP9xpF4Ms304NoLdwCaSwA==
X-Received: by 2002:a05:6a21:6b0b:b0:1d8:a13d:723d with SMTP id adf61e73a8af0-1d978bae5d1mr1046393637.31.1729645875785;
        Tue, 22 Oct 2024 18:11:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0bd578sm48190595ad.126.2024.10.22.18.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 18:11:15 -0700 (PDT)
Message-ID: <e811d58f-a9b1-4e13-a805-063bc3eccf00@kernel.dk>
Date: Tue, 22 Oct 2024 19:11:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring: change io_get_ext_arg() to uaccess begin +
 end
To: Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org
References: <20241022204708.1025470-1-axboe@kernel.dk>
 <20241022204708.1025470-3-axboe@kernel.dk> <Zxgp9uPGPJZijSoq@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zxgp9uPGPJZijSoq@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/24 4:40 PM, Keith Busch wrote:
> On Tue, Oct 22, 2024 at 02:39:03PM -0600, Jens Axboe wrote:
>> In scenarios where a high frequency of wait events are seen, the copy
>> of the struct io_uring_getevents_arg is quite noticeable in the
>> profiles in terms of time spent. It can be seen as up to 3.5-4.5%.
>> Rewrite the copy-in logic, saving about 0.5% of the time.
> 
> I'm surprised it's faster to retrieve field by field instead of a
> straight copy. But you can't argue with the results!

It's a pretty common setup - mostly when copying separate entities. But
works here too!

> I was looking for the 'goto' for this label and discovered it's in the
> macro. Neat.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>

Thanks, will add.

-- 
Jens Axboe

