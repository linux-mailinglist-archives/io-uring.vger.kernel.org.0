Return-Path: <io-uring+bounces-7072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E363A5F5B2
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 14:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 377978802F3
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 13:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92168267710;
	Thu, 13 Mar 2025 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkfmqRF0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF52724E010;
	Thu, 13 Mar 2025 13:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741871700; cv=none; b=DkpPqkU3rrXIuHHtO+NrFyZHtPHZzaOjkv/daQ4oqPLj4kdJ+qNk3kjB8kjkYTXsuBrYUUG8bfX+aXU+aUhFRbD10S9uz0qCpQyv8zc2GwXBHeOI6P/KgV3lKWtLR73U3xJcMGviPdr9HYDhhpd1u+xE5bXk2YhZPV3+Fl6607c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741871700; c=relaxed/simple;
	bh=VLJNg6lVMoooVVl1DScIpAPZZeM78jzK1vkciFNTLM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFfObx1D0V6ZUFfKOfABiF+erw8zQRfc+spfBpV2f9I3lilfIfFOsEh+0iCi49c4EKBRjD+RyOtQSBzZb1yJ7XR/z1J7z/8QfI20HcMBttwbwIebpWW9vHTS2UiUv4l7e80b76IYFE1rrOjJEfthnXXZS1Y+cE5QTrHJYWjlSvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkfmqRF0; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e5e0caa151so1658148a12.0;
        Thu, 13 Mar 2025 06:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741871697; x=1742476497; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pDzKsxJKNgXSp+dU7QY1JBhVYKMUfmTAqfRS6qsK4MU=;
        b=NkfmqRF0ir4f8I0+PeVl/o4Mb0lyZA3YLhd15S4vXmPbmzlcnQuvC17mHj5EDFzfny
         be9vgo4DqdninqrR+6/Y1eY063tdalrI/FgAp/wvcEzWzuiY7MsAN7ttlB5khDxowonX
         RBwWJzWGlNOeAJZly2OAGty+IxjhreqlQDZa4W3uFl9uDOafo7A431qkdUsSgb9M4NRL
         KrSVp66zLX3MbZx/Yl62+SHpKoa8B3xKXs3hYT1NwbuMhmXCli+mmq4DkYXh8/oEwT8Y
         n9O4tUd3dr5aWqBpeC7R1Vh86CYGEtHUZWRwiI6udSOFwd/81UC2QA0kmVXBo+PVmdDj
         0ftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741871697; x=1742476497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDzKsxJKNgXSp+dU7QY1JBhVYKMUfmTAqfRS6qsK4MU=;
        b=K/M/6Aj0qAUQPsmKM1TiXphL8oQDcNbEOCY1bKHmcIiDG2C4MSUiumZQ1MT3ovB6qV
         xNZyfev1nN4QhxKduHO2Iz9fLmu/SSBjVK1sNSE4Zp4HfPY2OD4VFDKAKQ/BjpZzwrrI
         l3stPblmZ/JBcI65Vf9fX8+5oQta+WH/kiEXhbPnKcTribUCj3cuFVv+pYLFOS16lhCC
         1k3U84vHsH4mt+76P+rZaihMeh9WM0G3nEKkpmgpPQJwsIj5U6FR0T0dU8dG89wEqOT3
         Swatknnbb9+Gndg6RDjFZMEas2SxBaDUatIXSSSUoMzQCwLCGGMrHJ39CG/pReoY/WNb
         oM3w==
X-Forwarded-Encrypted: i=1; AJvYcCV5s55UytItDzx0H36nSyg2h4WBClGV9ruB2cXUZhNWnDL+ntRkJEQRbhye3SojYuF08qjVllmYzEtkD95T@vger.kernel.org, AJvYcCVaoJOwHLhYh6H1ax1V1Ws5eQg/bElu5XmyoER/WB93QtxOYDgHcmJwPdpeKthiMY4FSoFF6klvlA==@vger.kernel.org, AJvYcCXeSmTHFEpEgRxpIel72QZNsQ7vUIt1JL1kvCtw7RApHXKabZT/ecnxAhxq04RBYh+b6VCNXt6UMAWDttY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRpyQ46f8gNI0yx4PgvQyu04q1QZGehmdj/ZjTXFCoUEP+rr3o
	QMxMpU6GPJMhEUragVApX2VhNqHUJvxBTGG9zSD/pjQnVGKEIb3Y
X-Gm-Gg: ASbGncvnTY8P9MAkF+Iqci9i4vS9Et+hgmKDIgzaT+wqNGPtSmV2ixFhhUnXxWb/EdW
	kK1YHu9duZ16NxopjyMUY8q8VXG3bv3akLyaEViNm378qz0wcvtGaK9ewZUqQEJd6v2udf0XpfC
	RJGsO3Rf+i7QH5CaD0aBRoP0IUXjN+9Tpc5jVc0SUo2GI4p1cH7qcjSR8yTpGnR4Vp+sSsFoa6t
	JS/fOIbtO7aUoqqp+ObmFmO/36lCvpGXuY+/mh6zCbIJ075OJBH9buLw86H4TBWqJYu344k3+us
	n8OEpBltEuldV+N8kicJa4heIdA5uFlunhABZ+KqqijItJar824Wpt4AIg==
X-Google-Smtp-Source: AGHT+IGloPfMpVcyvSI4gSYAfTMqQJN5Evc9ByhQ/i5dxx727NH40uiKtBLFMDYVKpT1JPovCIn/FA==
X-Received: by 2002:a05:6402:5248:b0:5e7:b081:d6e0 with SMTP id 4fb4d7f45d1cf-5e7b081d955mr9681473a12.19.1741871696725;
        Thu, 13 Mar 2025 06:14:56 -0700 (PDT)
Received: from [192.168.116.141] ([148.252.146.254])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e81692e534sm746639a12.1.2025.03.13.06.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 06:14:55 -0700 (PDT)
Message-ID: <95529e8f-ac4d-4530-94fa-488372489100@gmail.com>
Date: Thu, 13 Mar 2025 13:15:50 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
 <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>
 <Z9K2-mU3lrlRiV6s@sidongui-MacBookPro.local>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z9K2-mU3lrlRiV6s@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/25 10:44, Sidong Yang wrote:
> On Thu, Mar 13, 2025 at 08:57:45AM +0000, Pavel Begunkov wrote:
>> On 3/12/25 14:23, Sidong Yang wrote:
>>> This patche series introduce io_uring_cmd_import_vec. With this function,
>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>>> for new api for encoded read in btrfs by using uring cmd.
>>
>> Pretty much same thing, we're still left with 2 allocations in the
>> hot path. What I think we can do here is to add caching on the
>> io_uring side as we do with rw / net, but that would be invisible
>> for cmd drivers. And that cache can be reused for normal iovec imports.
>>
>> https://github.com/isilence/linux.git regvec-import-cmd
>> (link for convenience)
>> https://github.com/isilence/linux/tree/regvec-import-cmd
>>
>> Not really target tested, no btrfs, not any other user, just an idea.
>> There are 4 patches, but the top 3 are of interest.
> 
> Thanks, I justed checked the commits now. I think cache is good to resolve
> this without allocation if cache hit. Let me reimpl this idea and test it
> for btrfs.

Sure, you can just base on top of that branch, hashes might be
different but it's identical to the base it should be on. Your
v2 didn't have some more recent merged patches.

-- 
Pavel Begunkov


