Return-Path: <io-uring+bounces-9355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 212C6B38E56
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 00:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF32436190F
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 22:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD0B2D323E;
	Wed, 27 Aug 2025 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BWwsJX2H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD112F7468
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 22:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333413; cv=none; b=NIxlfz3faWgGqIXDQrzaRE6c9PuhnoIYjWcu4uZzsDM9GtpIw2ur31nGZiMOKMBmIiP+dNSRs+RPmvysGgJ1vjEwW6vgKVSGwEhUwepu1MnyGhwN9NAEMYWmPa4H6Ta1Pdd1UgzYCK4dDT9P8f4uYCtBS2KS5gVZvR6ZRQDOTkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333413; c=relaxed/simple;
	bh=Koedtw7q0lWiWCcYzjgUSinsr/wTxwCoNrsLzxhoFtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XoHSGBTrlT6GPzpE1HM8lvsbjXrnEuoi2Cl49VwdtwZp4RjRXOS2yu6Nk1gJAya2P1GX/bCtExjApKQf3zs2UIaMpNnOOTIRRavdfJ90S5gXiZ2EFl1fq2y8ZBTPKdMp9BXcxB0R9Pn+7tXLjbFf2AONS2o0dujhSFF47h2pvJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BWwsJX2H; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-770530175b2so302675b3a.3
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 15:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756333410; x=1756938210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pxFYz5su5aGOBTMJArO0RJNHBnuvaDOgygQdn3ZQKyw=;
        b=BWwsJX2H9DITW32BrGbArrMOkBoMCV0xsriyFVr2hyE6XAylX2VJ4w7wuMWtZSMA1M
         XKQKOnjjPFyfwvoonK2xO0wFVEJAkVQDLBJUJHs2ETQp1Uf8j9+bci+3+B8Kxm5ehFJA
         VowsXvQxrDB0su5OsQkleRY36IH1hruM2s4NeC44vcZsLv7TKC4xJIRrsou499k9jSgj
         7TbstJX21/LPYuOggew3iI+H+qBTx14lVf6J6a48zLrZgpfaIM7DQez2qzRQZMbMxaz9
         AI+P1LtcTzmL96GsMDfikwjaG1OsIMEQMDxwd6LOk8qih0clxLBiw81DHbX42bkSuv3O
         V7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756333410; x=1756938210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxFYz5su5aGOBTMJArO0RJNHBnuvaDOgygQdn3ZQKyw=;
        b=dlXIFAR4KSdSOlJ+cKWlIN7lKRIR4FWzXJMUoC604ZLyC/rnsia6JxJAAZ+TqRcvlD
         /GqiYT67gZ9pyWS9l1f699L6+2om8jZXL8rH7WDxoH+7izjoii4wbFxkxkBV6XcLYeT7
         egFTzABW9Q48kDCbggmRNtot8rz2DVzqper2v1JCQ9QHQSV9pFZqKkQF+8pulvS7db1O
         lERQlO7zdJJ4o+UqjHIbspvo7TG1CAOS/TZXeMqHqQm1AF3htjFl7jjU92I4V/lGaaXq
         tNNjy4LSqRWDqLk4+VNu8l/TjoIpxYZOEiSzJKcw6jdB0yvfL03WTTrKN4Jz0ibG0opF
         mSVA==
X-Forwarded-Encrypted: i=1; AJvYcCXwAXgnA98wnJK0u8xqrvQPqCRi/7HGUoxnZdYBrLv66YExSrdu5UZzxDOCgbHpDt1Z/7gDvllfhg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9WSwDD+AlVahbwK6JNJ9vZIjzLq2FPoRpjUGitTqx+TWCvXQl
	iLSztbwkkfu4Apd/q47flsiCDoQQQ2XWaGoRaxzX+QBTAMO8Ju93d4T24Tnx2hA3j1s=
X-Gm-Gg: ASbGncuKL24NbawqUN5wiXoi2+v9j1eOSy+0Y4jtVU3f77Q6ovugpyU5QJxPQHwN4P8
	BZNJT+Ug/nWCSwXOGB/z0mom85kwCXCHreazK2ZJiR4jIasSSe3xeDjPfIfdxnC8UmoEK1k1LQV
	3gkpXbk5qOefcUvdTSYmHTV33t+hjCGDQkxTUUy5S5OK+rDo5rj5vGkW1HI3SK6KP/uMUVx6ILe
	XLZ6Jlc5E5FL+76ZTNr65/JFEcOWU5AN+5nqmhCK9THo5cDnd8lm42KfWlWWzqOZk82gdzWeJbA
	cXF7PR0t6lR072gGmxWHHRVP3UNbiIg9jCYSMtm8uzD9fkhhQzVkJHo0kEdAJAWPjIMfjteC9DT
	ts95O8e97ua4kp4wEOd5a
X-Google-Smtp-Source: AGHT+IH3o5DBqG938ns4gTHALqTiqdJfZVA/v8WB+nBjR0/wmCjbESOn8ppRetrlrQ4Ln7XLDlrgzw==
X-Received: by 2002:a17:902:f60d:b0:248:79d4:939a with SMTP id d9443c01a7336-24879d4964emr82700735ad.29.1756333410184;
        Wed, 27 Aug 2025 15:23:30 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-248b7299dd1sm15506835ad.131.2025.08.27.15.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 15:23:29 -0700 (PDT)
Message-ID: <7ac936ab-ff4f-457c-a745-56bccaa19a08@kernel.dk>
Date: Wed, 27 Aug 2025 16:23:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
To: Keith Busch <kbusch@kernel.org>
Cc: Qingyue Zhang <chunzhennn@qq.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, Suoxing Zhang <aftern00n@qq.com>
References: <20250827114339.367080-1-chunzhennn@qq.com>
 <tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com>
 <fcfd5324-9918-4613-94b0-c27fb8398375@kernel.dk>
 <4b8eb795-239f-4f46-af4f-7a05056ab516@kernel.dk>
 <aK9_u9ZK9NgKiBkE@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aK9_u9ZK9NgKiBkE@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 3:59 PM, Keith Busch wrote:
> On Wed, Aug 27, 2025 at 03:45:28PM -0600, Jens Axboe wrote:
>>> +		buf_len = READ_ONCE(buf->len);
>>> +		this_len = min_t(int, len, buf_len);
>>> +		buf_len -= this_len;
>>> +		if (buf_len) {
>>>  			buf->addr += this_len;
>>> +			buf->len = buf_len;
>>>  			return false;
>>>  		}
>>> +		buf->len = 0;
> 
> Purely for symmetry, assigning buf->len ought to be a WRITE_ONCE.

I did think about that, perhaps I should've mentioned it in the commit
message. While the reader side is important for the reasons stated, the
updating of buf->len isn't really as only the serialized kernel side
will do it. Hence the WRITE_ONCE() should not be needed on the write
side, outside of perhaps documenting that this is a shared buffer.

-- 
Jens Axboe

