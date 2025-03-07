Return-Path: <io-uring+bounces-7020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C07E6A56EF2
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A01273AB8A9
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F2D323F420;
	Fri,  7 Mar 2025 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEv2hMnP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E2014293
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741368342; cv=none; b=bhuzz/4f+T3T9jOWziFj5C1e5z9DHwlYOhFKWs4llvKWVYmqgEKVOM7E5bJB+t4/0ECg9u0IcyD+MMRrMuCx9NIdqjPBN+zMEjRr1yDWT1TqdQtWfFiV8ZzFCbXFYIXQxx4mBC8ZUKkioa4vAAVn/IfKEk+Qsw1NYMw+G9YhiKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741368342; c=relaxed/simple;
	bh=GhBE6Xlx8RHjSZeTYuokWQmxla7Ui8P9pPZZJcUC/2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T9pmpcPKAdhpjVqrbN46LTPyNBkzHPuBwaLbK0YHD2s91DqtcNC5JC/G5twFMrQm2kQwKvYZ8KmBMPQQCXB8QIH5joP3OXgpmPjfaZM4t3w2Lox0WjVhEeGnJLhnjO+KqG77DxSwriGnDS4kWEHRuv+hZALJd1K6VeYKJH/3WmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gEv2hMnP; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e5bc066283so3222867a12.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 09:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741368339; x=1741973139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JSbZOuUCpS/UjebJDowoIE3TNgWK2n3WWwtUY3Uv1LM=;
        b=gEv2hMnPy/QX4YbCTGZawr2pL9uQUekQ+uY0IIDLAskho8aFFYN2RwFBbUujIrPXB0
         LJ6XG7bB4qCzE5Ym+z+uX+CgECSyHxjDMfFAV4MmoBotjhryxNQdlO7/1kDH7a3oixjU
         EZYFu9MAqNB6gc2i2Zz+5jXl7lMZymaG5dCpnJeGxImCKJF+gbnHUaiqCBKYWwF+WGEp
         J7sf2mUst1p6gVt/zfhvebgvxJbkyi6upVxc3Dzud/0R7CnI4RvaM/IeEgNLZ8C+vtaO
         pFhRMPILwcACWb48dF4Y0pFZ0MxJQT9cChXPHmwLjeAmvM4lJmCrmoq1uWGwn5/JPtlU
         mxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741368339; x=1741973139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JSbZOuUCpS/UjebJDowoIE3TNgWK2n3WWwtUY3Uv1LM=;
        b=Ew4D4evcN/4iAIkLSZ5/8iM8jevlLtOJwEd7XR27YRX1J3Vn9Wg2CVJGgm1iruO/um
         xfILXgRUplRzEIdm1w5YICKsDSk1s0iO0nqfOBkY58/3Tq2NDOdBBbr+RkdA8qbx43Gj
         dge8JctVp1uFoiH2fzqDo5XZpAETuoLTSDSfl64oEpRyhtXj25YuKTeDrgR8PUcOt1km
         WQ72En44L48NS2mF14R2HW81fiMAlD8I9CbHJ6H+toWdHA6KPTDkHAjClMbDfMbNds9w
         ybCysv6IbtDtzVTAFBH2SuTfF+WKUS/G6hjMGLnWSpwawxOd19SDAzGwhGXHapvppswV
         7C6A==
X-Gm-Message-State: AOJu0Yw9LLEsYjkGifDjDkxQvvuAtonr7TawjceMpdITSqA/w5njqctF
	JnVx7RmZknk520Ek1gnXY9v/Zzdu32GizaXoDOrjTB0SEPy3EAgO
X-Gm-Gg: ASbGncsKjHkyuVaZ20FHs59aOzw6DhC+CduLH217wHQ9remo4uVr6/W840pPc6AFz9M
	5RT93coNurxIcfWT/MNdNZTx6De/KxmU6drjS35yfJdl3G56hL66AJ4GSPF+SYnx1C5HjAe85p4
	NyS819HKhw0Xv5Ndw/RKKLyS7iVdfMjb/21jtepMF1yn80cMlfnHC88ctqBJ9zhisDx7t50lJIj
	Yx/71jRmzRCgyVhk0WJ9ONk9zRKIia56eiScsHIKrmtHgDsVCfJA6OJE+9oC+/gvYh8rGxTJojM
	EGhV6Uw0DWwaTHFfdwVqQfJdq8gTMqbm/XZpWrDNac58BWpzD5j3WQ==
X-Google-Smtp-Source: AGHT+IElKMaX7excrpWzleL20JrObKqNbu94JdZvDInQf19f+RrIW5PX73uwitIDlmJH91kbQqyTWw==
X-Received: by 2002:a05:6402:254b:b0:5e5:e090:7b52 with SMTP id 4fb4d7f45d1cf-5e5e24d4000mr4008102a12.29.1741368338847;
        Fri, 07 Mar 2025 09:25:38 -0800 (PST)
Received: from [192.168.8.100] ([85.255.232.206])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2760091a12.56.2025.03.07.09.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 09:25:38 -0800 (PST)
Message-ID: <ae241647-3d95-4989-a733-c9271b45dd50@gmail.com>
Date: Fri, 7 Mar 2025 17:26:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/4] Add vectored registered buffer req init
 helpers
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <cover.1741364284.git.asml.silence@gmail.com>
 <60182eae68ff13f31d158e08abc351205d59c929.1741364284.git.asml.silence@gmail.com>
 <CADUfDZpzxCDR8g7iP=3wSRMJW6q3fACEgLFvYYHHG_yDd=ht=A@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZpzxCDR8g7iP=3wSRMJW6q3fACEgLFvYYHHG_yDd=ht=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 17:10, Caleb Sander Mateos wrote:
> On Fri, Mar 7, 2025 at 8:22 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> +IOURINGINLINE void io_uring_prep_writev2_fixed(struct io_uring_sqe *sqe, int fd,
>> +                                      const struct iovec *iovecs,
>> +                                      unsigned nr_vecs, __u64 offset,
>> +                                      int flags, int buf_index)
>> +{
>> +       io_uring_prep_writev2(sqe, fd, iovecs, nr_vecs, offset, flags);
>> +       sqe->opcode = IORING_OP_WRITE_FIXED;
> 
> IORING_OP_WRITEV_FIXED?

Good catch, that came from a prototype where it was based on
that opcode, I should just use the helper in the test.

-- 
Pavel Begunkov


