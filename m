Return-Path: <io-uring+bounces-6299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69AF8A2C546
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 15:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AC4C7A4489
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 14:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4037023ED74;
	Fri,  7 Feb 2025 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xlHiBUBs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18E923ED56
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738938601; cv=none; b=GKvGDM60y8DoKMJXcOOnXk2LhFALJEfP7XUI+r79Tyk3EwPGZFgZa9YtecGQQbhOhBO68VlpkWu3swRUrEr3nSTzVitnkn45l93R6LEp/R763pWRjoHe648+NcvUfxVLmXb/xrTc2fdSATH0fSq1putBE7qWNA9L1A5Zi0Dy8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738938601; c=relaxed/simple;
	bh=YTa6ov9b5XOK3EO+RwdO9zZmT4AW4O8xTz2pzZj6Tgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OuB+8WfcHm/DQoObCjGu49mGNdKutDIce5Z220fAYwFGMElU0AXrn5Ko3IvHR2+3J63mW5vNbbwo+zHyNCqEJETQyFur9QUXrl+DwdgZoLZpfEVqrZ4Hb0yz7BKGs+FtHYqjJBnwpSpwnSLKbgudwG5Vq+O1ARLJINR8wD8lSEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xlHiBUBs; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso6276415ab.1
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 06:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738938598; x=1739543398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mK9iHfXVPyKgVAcRe+WC3DkXEmQ7j6QGi4OQ4+GyxIo=;
        b=xlHiBUBsmYUt0oIdH4PV8ThYokKgBvsaDFef1OY44DAD4d9rGLUPmMtCDDngkVTz40
         5Vi5knJE74erKIqb5BjmbsPS226ZTiDXWSfLlm0NWokO0sYSZC/mrEzJyjoYEMlnPHSv
         UnR3g+T7nkfkNLKLmKPkltYkZbrsEEzWjqmp0Gg2sgQJ71x/rFsxT5mlSVWD8J3BqiAS
         zaSFVfAcBsADlHsguGNYBLzzb5aKu4Gmoy3MI3wIzciKp88XAzfqICV4HOWtZ3Up34BL
         3l5Ns8fz7llSAGBhk1ZcNku+OFt0SkqkeLm55x2vOoR2LO5Qj85L+MK/WCYcz/0OxazE
         7dZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738938598; x=1739543398;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mK9iHfXVPyKgVAcRe+WC3DkXEmQ7j6QGi4OQ4+GyxIo=;
        b=uIHq3tAlcOh/5fZ2YohthjoGO+GKsXGk/I0GyBcslhO2KBU9L/cqutEE0J0Nk2ZP7F
         v1cm3yDAxGBmu/3hWkDQcFdbYMkMYHJk58/33kHbGiHTUzbC/Zg1IJrAEMXJRIGCb1Tz
         tXVB1IHmA/CQXQlkWvCAZ1GUSsxbiGwcJqrvdtK9CUiplGw+lFFz/pvXjR4wr9GR5196
         CAfQONHDDMp888ySHrYAmgK66bC1wDbtNIiJGgDiPAfXIj6rJmQ7ZLhn33A7SVMA7D7c
         46u+2vdAyq2rw6S/75KmNKbFvnJP+0RlJmVrTGKB6fM4g4aQwlhd2sCWkJcEd4uOX2uN
         qiiA==
X-Forwarded-Encrypted: i=1; AJvYcCUY+9t8yr1L24q695OKkGQFjBHiJzT/U4WsN/uoxzAFom3y1XxR2pPRN5tEZVUpwSQtIfRW8BAClw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYgNYVP+wmiZJTMBDdjM3FaT/gvjhSLjjf5oe56ay/SU7lI4Zq
	mgmxIkkXzhMu2g40d9WB6yCSJhzn0Lp2YXw2j1yNJ3hEoJG/TNSN65V09ziU8ck=
X-Gm-Gg: ASbGnctKAp5k/wzG86ZUlj5Xa8uAuBxGDdkGQh9F0o2bxXM3XNFYzqEqeMn1ZfCzSVG
	VLSiYh+YQB1kDz8JLiUxtVW5JZWL9HRqutghYig6/uM0azTPviJZwRpbJ4JQ//nwPXhx5va6AW+
	sh59q8e0H7i+mBAo1hldpobdFt0z6k5G/4ihVXM35IPBldIitmxDyUIz2kSelBx0AxZ48pZOABU
	8YOCrIt2uGNuDvliHqag5Oca9m21Y2vpZx8BRH2JRw401m4G0903k2AmNKVhCXDi2Y+P2FJdY6R
	K11LidLq6hw=
X-Google-Smtp-Source: AGHT+IGd7DnH33tkyJ8hxgyBPzgMaU05BkKvDWzJ0ikrIgFeRyaEdmsS2P+eeDbT7hlwKO1GFFjQvA==
X-Received: by 2002:a05:6e02:2163:b0:3d0:2331:f809 with SMTP id e9e14a558f8ab-3d13dcde9e4mr29029665ab.2.1738938597885;
        Fri, 07 Feb 2025 06:29:57 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eccf9dfa95sm779444173.41.2025.02.07.06.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 06:29:57 -0800 (PST)
Message-ID: <6b27f9ee-290f-4905-a929-82d68f80ab2a@kernel.dk>
Date: Fri, 7 Feb 2025 07:29:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] io_uring/poll: add IO_POLL_FINISH_FLAG
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250204194814.393112-1-axboe@kernel.dk>
 <20250204194814.393112-9-axboe@kernel.dk>
 <42382d54-4789-42dc-af17-79071af48849@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <42382d54-4789-42dc-af17-79071af48849@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/7/25 5:15 AM, Pavel Begunkov wrote:
> On 2/4/25 19:46, Jens Axboe wrote:
>> Use the same value as the retry, doesn't need to be unique, just
>> available if the poll owning mechanism user wishes to use it for
>> something other than a retry condition.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/poll.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/io_uring/poll.h b/io_uring/poll.h
>> index 2f416cd3be13..97d14b2b2751 100644
>> --- a/io_uring/poll.h
>> +++ b/io_uring/poll.h
>> @@ -23,6 +23,7 @@ struct async_poll {
>>     #define IO_POLL_CANCEL_FLAG    BIT(31)
>>   #define IO_POLL_RETRY_FLAG    BIT(30)
>> +#define IO_POLL_FINISH_FLAG    IO_POLL_RETRY_FLAG
> 
> The patches use io_poll_get_ownership(), which already might set
> the flag and with a different meaning put into it.

Oh true, I totally missed that. I'll just add another flag for it
instead and shrink the ref mask.

-- 
Jens Axboe


