Return-Path: <io-uring+bounces-7364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A5DA78DF8
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 14:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6178188ADF4
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 12:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01388802;
	Wed,  2 Apr 2025 12:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dx2CFzeX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDFC238166
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 12:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743595962; cv=none; b=Bz3iEFWrfNLNovH3xsBndp0RR3NTfMsqJQhloZLTisErx4xiUTBB+pbzM3xucOW0/NicBhoA75lOndbWKwNiOdtoOciH6R9HIYcWEvoGdWOIRlxEgtiogdIrieRjIAACPCmhFgwD9Y76sVTcl9H2WREVlNzLNumg5BqHkhr/Fd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743595962; c=relaxed/simple;
	bh=OR4pdji1T7Ud4EcXXdp5rq0IaDUnAD86QPkd60emFiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGNDxbRLNS+qfk2ZOoY0NpGzPTIMcFZ/34WNPcf/ReLywApLW4aYe5eLy7VUUdlYkjCkaDb9IALGRF9GvVsQh0t/D6lnH6XUlz+wWY1poMMmkUOMOa0NAwfSG8yObXVOc16rK71+o5tPXxtyPwUqnBUUiB+uNitZsvG+YIlMf+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dx2CFzeX; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e6f4b3ebe5so11998537a12.0
        for <io-uring@vger.kernel.org>; Wed, 02 Apr 2025 05:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743595959; x=1744200759; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IZEPzSd51nAYSge+LvoW4HT6QjRu8iShuKdP78gvwww=;
        b=Dx2CFzeXmEnXP0l+l58pYHu3+6JF0jKikoEb+RANEkIZEr+kBzVbWJgakGNfMbyXxP
         k6rfXcHEqnK0ZIpPr+VTnfM7pGXFmULdrSdyr79pAZuMUJ0ulZEgfhqUNTpBhgSAc1Ep
         TX1X/OcBqhbDU+jObzTsSJR7Q1NzZCJ0J6DqTpCM8Y+/NRZWw17qJmosjOnhJ2Znv0lX
         SR6efWz/Y2uAMKRBr1MLeCMKlVSUJnZEdwyqH50KTdSfB+4BQIYcppGxpTCw+nCUI5LW
         uKm+dAGZx1DPsf8DcEpMaCDEpbRWyG7GgRYOtatOg7unwL5XufLgXPThL943XgE65QNj
         Ar4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743595959; x=1744200759;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IZEPzSd51nAYSge+LvoW4HT6QjRu8iShuKdP78gvwww=;
        b=WJryIh8jI/UKr0z02YGSaDuVlJB/czo5Ss7oU3vdEGnxBbVIHCKbSQp7UQMuxoqSXU
         kbjlhyqkRgpxqLQ28ysrhEa7JlsF+2KYRZDxgb9GySYMkbwOYzPYc4ImNKMqYBapEMfn
         AVYC/ajFPpgdx5ThBcg9/7R5+uX30eB6gmTlPSIvs8C6Lcl3iBs/0416tGZalK00xbiz
         Pl40cpjpnQuXlHY1uiSNuklYQ748kFH0FQf66zkNoy80bZuOfwN6BP0gvc3UXYfizCPx
         2XhMAy4DuUV4bOtTkyGkfRVkP6jL69ZLm9AWQqDi2eOsEPw6KRzc+iRmzxfGxL/ietf8
         bmAw==
X-Forwarded-Encrypted: i=1; AJvYcCVBkHN9+kpKeA0LC1zzY8OoHU4et+SQPHb24lxz3Mz8JfqFNcVGEU+amfm763QgrxV1PtB+RQsHmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuc9XtFfMv+Oq+hwoNGA9Aw3wOr+Hun2eesSY8LzUad8tilgw9
	Cuth8tdDID9b1J/1mIFyBcNQblvJwX8Onb9IaOt9JndSkPp4wWtRd8gbrw==
X-Gm-Gg: ASbGncsetX6QP4JA0o/rr5uh44dTMe9QNxZkv04IwKfNeAKky1WOX24GZ68kHA4XJUB
	aJ/3Rcz3EdJ3gqLcBvIRmQ7aVq2wmWfhUyn8vqqmYC6qNcmCKerYa1Y29WN3/xsl8WzXD0KCOWS
	pAQGe3lxUWbNkRFCFnfb4INx/ZkQFbPro2rI5FSOCdsm2TeA8+ktZTKz3U9M6GrSnmZYv6pIgTI
	mUsFKlF0KPGYyRiakAW0/K5hG/mIkk8GRf19oEMDKHVSXtMJOLVlUX1c3+Z4HK+yUd2LolruUry
	I7Ewa5n/O1DjaMYEnBgolTbDIeQOnYSc8ARg5FQqwb1AaFGfgcwp4Xc=
X-Google-Smtp-Source: AGHT+IGQRQx0hgU77IgzSInWtv4WCd2hSeSuoyLcZYwB4tGnCYDHMFywQFCc+MmFX1rlJzH1sXHJIA==
X-Received: by 2002:a05:6402:2709:b0:5dc:7725:a0c7 with SMTP id 4fb4d7f45d1cf-5edfcc053c3mr16061719a12.3.1743595959284;
        Wed, 02 Apr 2025 05:12:39 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.143])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edfaacd006sm6971126a12.79.2025.04.02.05.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 05:12:38 -0700 (PDT)
Message-ID: <26767f79-4ed3-487e-aba8-aa6ff124b2c3@gmail.com>
Date: Wed, 2 Apr 2025 13:13:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] io_uring: support vectored fixed kernel buffer
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
 <Z-zt3YraxRSHVIWv@fedora> <c252ec4e-aa97-4831-8062-43fcd1065324@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c252ec4e-aa97-4831-8062-43fcd1065324@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/2/25 12:59, Jens Axboe wrote:
> On 4/2/25 1:57 AM, Ming Lei wrote:
>> On Tue, Mar 25, 2025 at 09:51:49PM +0800, Ming Lei wrote:
>>> Hello Jens,
>>>
>>> This patchset supports vectored fixed buffer for kernel bvec buffer,
>>> and use it on for ublk/stripe.
>>>
>>> Please review.
>>>
>>> Thanks,
>>> Ming
>>>
>>>
>>> Ming Lei (4):
>>>    io_uring: add validate_fixed_range() for validate fixed buffer
>>>    block: add for_each_mp_bvec()
>>>    io_uring: support vectored kernel fixed buffer
>>>    selftests: ublk: enable zero copy for stripe target
>>
>> Hello,
>>
>> Ping...
> 
> Looks fine to me and pretty straight forward, but it was in the merge
> window. Anything that makes this important for 6.15? We can still
> include it if so. If not, let's take a look for 6.16 when the merge
> window closes.

fwiw, I looked through it, looks correct, but it'd be a good
to test it aside from ublk. I guess I'll just extend a kernel
hack I used before.

No opinion on 6.15 vs 6.16, but the argument might be to have
it in the same release with ublk zc, and have less probing
for the user.

-- 
Pavel Begunkov


