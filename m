Return-Path: <io-uring+bounces-7084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9511DA6345E
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 07:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABB0A3AD439
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 06:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856F4256D;
	Sun, 16 Mar 2025 06:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7WTcofU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2E37F9
	for <io-uring@vger.kernel.org>; Sun, 16 Mar 2025 06:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742108207; cv=none; b=uklHFj7cv8kKTtIk6bwtAdu6R94uKee/UEAOFxopBGyHckhYZLZtnQdGcPeXgJfl+M9ofHuqcWoPq/sxnC7t6U4e6iuTtuhVmmDWgeTrjWQ+aHfxTIJxw6DTOBOoIhPWfpbWAb/40Ua4GjVajv/DpSqYK+wB1FdujXmAZBMH6OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742108207; c=relaxed/simple;
	bh=YDgmR5v5ic8Lv31HnUJfNN/x1JBbnJB6YuC+OFSafIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fhriikxTtyhI73vwvyq6ShI4AV5/O9/vXgZGMTyFfj3ZVbPfxUKD6Sz1ZTtjoG6Z58Je8bkkC8kyxXi33uR7a6FPMddqUSkNPkPmDZRxbSRdJhIMar80lAc+KXvc8U/6Tt1118T0ep02eGvlM2OBjZtMmD0nOnhOZHoLNni2ZbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X7WTcofU; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-391211ea598so1846170f8f.1
        for <io-uring@vger.kernel.org>; Sat, 15 Mar 2025 23:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742108204; x=1742713004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7LS3pcsb1yGeFq9W+oosb5iAysDvAjJJo+mBg09N9Us=;
        b=X7WTcofUbVwWrvM06Hn0CB3GNq7THi9nMzDPsRJp/e4r3B+wr3FtaQNTERjX7xbZan
         YlDdAhQIAsVfV9sZUPhylznTjma6cMdoQ4WKt1qR53QQVRXqabG/tTM3k6XgJJOCaDAZ
         s0oBhKnud5vVHA2P2z++6vN3azLfKRqX4dAdgeN45YDA5ZE+thzlGNCBQk4tjoBwCKUu
         IVxNkZ+hoZkMTPy3LJUDetZdX5QV9WmgUJ3i5XKAPpzfYBUu/dHUd35c5G72qu9DG54v
         owfpUHjC3hduZtkcsqmT/39jYeLKAXsP74WMt9B5bHMsjGCq28TSN/kPurMj4pseb84U
         OXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742108204; x=1742713004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LS3pcsb1yGeFq9W+oosb5iAysDvAjJJo+mBg09N9Us=;
        b=ofFTSZGVOUwuOL9RHowXNQfEld7SCRlot6O7NbCsN/7Ye3Kk+hJAXdh7KG72pGe7Xs
         B1jS1zU7kQJyM8mG8L/yfrMkvyEzBrHtZ6wBP9XqlcOzXzYUH2Ah/fWV/k9Jz4DQE8FB
         JUMKU/jvH1h4e9whAOPgBVquyESNwrurlU8p/drUTgK1G3WuuEgk6JOFksGqqyMgTmJa
         1FsmVd+wp/iCeDPcwyvDlMza3pwUa6yrPZl0He40DxQNEFFqs/GSxw9c7PnpqHWQ5wtL
         89J3tjyIsmcAFHec2IZDdXaqZu1OGC8dppUu8H3JyzboUzqlnPicN1b6Jegwt6+zEyZa
         oEZA==
X-Forwarded-Encrypted: i=1; AJvYcCUrl61EqaMhxfGfkxN2qsbmtGCyd+ys+vnhyiLyHaS+haJ3F7+SMST/DvITulMGtDDMYn3pqHIk8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhww5viCj0xvtcd5NzvVeI1ZZ2eDQrLfbfep2+VWLHyTsJPOuw
	tzVtfoQ2VEESBfkg6fKE/t0SC5N/Bs2DUvR2asOaRFI9Uf5+m02WJvQ+3eR1
X-Gm-Gg: ASbGncsx1bZKDIbEMtmIP+79zwxrMN86FTHO8yvdT1Z2++PYLMz/A7M7ZS482VyXcge
	IAPZ4uY5OdwWLVqlfXm6C8yuBAoE3eylcVX5E+I5+h1tE5/kz0I4EZE0QBQhll4mythQ6bUEBGZ
	Rp1TkY2aJmfaabt0B7fMBrp9Up1D+Dc7W/rBWO8guQVHXrAHRgPvqK58BLbVZ45AkKn8kIiRfgX
	paKU4kCYc6/576qxJB3hb/3InP3xuJMbnNQbBEXRArQZEiG8PHYU8nH9YVRYx1TM3EGBZI6l7Ky
	fEKMukgnTUgBFNP8oOUh2x3FkXHLFd0jHvxjF1tB/rimHVQu2o7ErkWeJkSINNckNXUnZfBH81Y
	kjcbhPlxw
X-Google-Smtp-Source: AGHT+IFHBvAvexpO+lFOm6S+7H7mTg4X9fXVLOPkUyaZnAbhC9FfW2ZFgzRA7+U1aABxGnfU3iZGGg==
X-Received: by 2002:a5d:47c4:0:b0:390:fbba:e64b with SMTP id ffacd0b85a97d-3971f7f8f98mr10617757f8f.31.1742108203761;
        Sat, 15 Mar 2025 23:56:43 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c82c23ffsm10974757f8f.22.2025.03.15.23.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 23:56:42 -0700 (PDT)
Message-ID: <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
Date: Sun, 16 Mar 2025 06:57:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: enable toggle of iowait usage when waiting
 on CQEs
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 18:48, Jens Axboe wrote:
> By default, io_uring marks a waiting task as being in iowait, if it's
> sleeping waiting on events and there are pending requests. This isn't
> necessarily always useful, and may be confusing on non-storage setups
> where iowait isn't expected. It can also cause extra power usage, by

I think this passage hints on controlling iowait stats, and in my opinion
we shouldn't conflate stats and optimisations. Global iowait stats
is there to stay, but ideally we want to never account io_uring as iowait.
That's while there were talks about removing optimisation toggle at all
(and do it as internal cpufreq magic, I suppose).

How about posing it as an optimisation option only and that iowait stat
is a side effect that can change. Explicitly spelling that in the commit
message and in a comment on top of the flag in an attempt to avoid the
uapi regression trap. We'd also need it in the option's man when it's
written. And I'd also add "hint" to the flag name, like
IORING_ENTER_HINT_NO_IOWAIT, as we might need to nop it if anything
changes on the cpufreq side.

-- 
Pavel Begunkov


