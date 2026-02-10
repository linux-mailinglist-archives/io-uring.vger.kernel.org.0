Return-Path: <io-uring+bounces-12138-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uKlmN5v/imnJPAAAu9opvQ
	(envelope-from <io-uring+bounces-12138-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 10:51:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65461119218
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 10:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CB33D3014A30
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 09:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C40342526;
	Tue, 10 Feb 2026 09:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJDSjegW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB81E34252A
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 09:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770717080; cv=none; b=fxiLJaF0LtnJqUJxBKv4Kvk19/595uJRBien28CdsbrDq1JjLqROaEwwUIow+h351QLQviDoQGovFoSCmFGpszVwCGfdDpZgogkYAo6uQ0jyij1Ffiha4Ngn/yV2yiuTG/WIZmBtNovJTfIfkS/HD4MW7PtaGOETgIf8+MMyhwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770717080; c=relaxed/simple;
	bh=n6FpRhchlYK4gCUtDY3/xSBsXHxUxDL97A1RrbrcKsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gE4mJeuaKYkA2HOQnt3j8+mepuYwll0xW9BxFZZfeLGNvVbbuoqXHE/r6RccUUPJh3kDong+AuPmB55uivj3sbg8F0ibPQiItYCdRMs9pxT8OZxIUefNX2prOrLlSzj+iRAkhN5ltirh60jrqxZgxfZ+0ljM2MWvGVf2QB73Jo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJDSjegW; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4801bc32725so29945735e9.0
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 01:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770717076; x=1771321876; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uZcHGxiK+5KMw4Kq6kdFmSpZMVuR/5kI3+jLmhyX5EU=;
        b=iJDSjegW1iOHDJRbOXxEio/mt8qxBo5fLF4HWZb+l4CS2NCQavjo5XAtfZ5oHsijjM
         hxvlNCP+utUz+UgzHbkrhJ/7Idv9bP/e6yZ9kghVshfgBJYKRovyWyCJxvYYPztL/yl+
         dMTs3t/DZ1kn//SUa8Nt6yCIqOoDRxjmyKyqonzoCUTnjs9ltAFAHt49EyzEPygfIuCQ
         0Q/KUlu0XYdqg6LxsraDibWgqrSA+V7tH4aU9w+KsTSDNnuR74hlMQlC03UQ9D0PRMGR
         hAIr+p30gZWODvxh77lHDiM7u1VRgdwlxY2JJ3rxYNRnRNT3rkTPI11Dk5dnPEW9w4zG
         vpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770717076; x=1771321876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uZcHGxiK+5KMw4Kq6kdFmSpZMVuR/5kI3+jLmhyX5EU=;
        b=IOCeLVibQGcxhmwktvmXLsXyEsYBFyjWWFdApV2SsoeH5AuCHJYQdiEq7M31MwoJtJ
         vzZ0Zcl5AVDLoGN9+HgVgLtczCEA6fUl+DsU/ynHF061OY3OB64v3keIrIZ2r+hQNwal
         Khtm76jS2sBOAwqpLXebAaDA/V6tlBX9p0q73wfOrFK3It224mht9sZP++Pi5jBBlzrk
         hpusZ/VNTG50sQQIgE2EP7IGAhOlCNhJSXunF3NU/nq4rMGmxieXrUy7dQHS5pQa+c2F
         PdJ2WtGV3qhp7ak5EAmgNeK8ydeHLXgWobe3I4Hw4+4NhQDI0GPricRlycsLNRi5qVLP
         36Gw==
X-Gm-Message-State: AOJu0YzutRzlX5iVHrcmIUnaNf3YPAXmsP9c9CZbrVkhBQmqOpxJtFXH
	OMrRSip74dxbWm0zPgYfXcy9bvfEEYmuUzry8ui89sIlFzsDPJyg1Nz9B4/RZ0x2
X-Gm-Gg: AZuq6aIOzdgBYYg4P+u/mN71VRT8LFvfrKH9NUPDyttttZS3Ck2JW/SNZVqERbHkIZS
	lKn5uiLI2Oitb5waFR2Qj2uV0D9dlvJa0DQBbIZnVBM+FWz9SrkpnYLex3zs1oXduIELkHozrrI
	kD/ZsHCmT7sd9WL2BBYcP3yDFdI5GVl3Xx/EFhNLB9yHkH3IUtS0cQ4fFHeZSkAIlw6YWc427CZ
	U6Mb9Cb9Wmi3fc4TWf6HdI4s3K07FaDvWKHLXkD9ZVovv9mgWDF8f40dWFWmzvoMqtkRJPzpofU
	XPbpzpcFT4v/Q+OJgdZlc7jYQuSOSYFCmji/vroVF4Hi6PuwYSs12Q4xaUXYbdlGyW3Tsx8aF/1
	M9ewN+6DvpyzrL9XXAKqq7cLmFvzrDRUCw/mCJoyuEDcp2VpQQoaA4fdx25xPx1CkmXrv5ycpPc
	lyhI0im84a83Ja3DLIdH70j1lcOq9atD5qwRm5Ha+zwKZeDzmq+xxKj9/uVzAJi4zeCqeSLpyKf
	rSWruI8paCPKi5y3RpufoHvLEtnU+PHrL3kjOZwYXtnV9aCXMvcp5rlfuk=
X-Received: by 2002:a05:600c:4f88:b0:47e:e946:3a57 with SMTP id 5b1f17b1804b1-483202272e0mr203884075e9.36.1770717075986;
        Tue, 10 Feb 2026 01:51:15 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:627f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a1c2sm73965585e9.9.2026.02.10.01.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 01:51:15 -0800 (PST)
Message-ID: <ff0d5185-6837-4144-aa2c-d3e90e539c94@gmail.com>
Date: Tue, 10 Feb 2026 09:51:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: replace reg buffer bit field with flags
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk
References: <b2fa5a88797fc54bc365f88f4884a845b0a16530.1770646345.git.asml.silence@gmail.com>
 <CADUfDZqJzVKEnoNWd5F0NAK6oKaUB3beJQ65WfKwmnXcGU5TWg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZqJzVKEnoNWd5F0NAK6oKaUB3beJQ65WfKwmnXcGU5TWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12138-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 65461119218
X-Rspamd-Action: no action

On 2/9/26 16:44, Caleb Sander Mateos wrote:
> On Mon, Feb 9, 2026 at 6:33 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> -       if (imu->is_kbuf)
>> +       if (imu->flags & IO_REGBUF_F_KBUF)
>>                  return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iovs, vec);
>>
>>          return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
>> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
>> index 4a5db2ad1af2..cff0f8834c35 100644
>> --- a/io_uring/rsrc.h
>> +++ b/io_uring/rsrc.h
>> @@ -28,6 +28,10 @@ enum {
>>          IO_IMU_SOURCE   = 1 << ITER_SOURCE,
>>   };
>>
>> +enum {
>> +       IO_REGBUF_F_KBUF                = 1,
> 
> 1 << 0 if this is intended to be extended with more flag bits in the future?

It's not worth of respinning, will get converted if ever
becomes a problem.

-- 
Pavel Begunkov


