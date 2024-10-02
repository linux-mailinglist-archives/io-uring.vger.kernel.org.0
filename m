Return-Path: <io-uring+bounces-3383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D36398E203
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 20:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E0C91C22CF0
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 18:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3D38F58;
	Wed,  2 Oct 2024 18:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XCTkLsF5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E7F1D1508
	for <io-uring@vger.kernel.org>; Wed,  2 Oct 2024 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727892050; cv=none; b=p76eKMeANnEFyFs+Zd4r2TncylfiIRqyv+SBQF00Irv77lFCmC7o4739GAlFqlZyfeMk2dsGUmgkeXQ0CCd1A+nVusORuPRR38ERMsvTGXp0cPZbXyaiNOUsc3HOJtLYfCO7TsLx86Rp+XDsq7Ok6H5S4g4tO/zn+9TdOHT1RW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727892050; c=relaxed/simple;
	bh=05yGC6hKcwAdcRf2UNZvWovJuEM40Fh85xtp43QdXw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nS0mD4H5Mu5N8CUgLdCW9540gEiWSJu0t80s+dY/vGOjl0gHCiAAXeOQ/QK5+zOp7FdFzYgR+aukugqi2HbrgEmq3vgKik3KXT9KLv7pd6YGdbOwOiZIisbfQ9yCu8hSsO17sS7vPutB7H4/+Xw3qI+cMDc26PwjVcOIq8btWvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XCTkLsF5; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-82cd93a6617so3827439f.3
        for <io-uring@vger.kernel.org>; Wed, 02 Oct 2024 11:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727892047; x=1728496847; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ozC4Wyjdu4pmuRDMmWKmlCuUQ8Fi4PleS7Ihu8qdzqI=;
        b=XCTkLsF5N1KWJzDSbmV3mQUMCmkrzLpyNO5sElOzLS+PG6lCvStq/Mnr7ovCLhfD/y
         exGpoKNkRFBT203heedOdSKCEiJl9YyuQQaSiNPMTYfzCE5Avb0CvfEIwdV7h9aAjIx6
         4fYBUzLL2OvVHgWpfK+JlwxvcxoYnAisX5Ame0hrXIRvwym+Ow6jhAqqisxN6TzJYMCL
         /id1szqRyCxrHTtkn02RUVgCCFZNZQjZ0wVGxKZLj5iZdwqRpaDBSboWQd7LW2xjIt71
         GWQ1uFSi7BAynuuilFCr1zItXMcp8HCfEcJ5Aqu93hGuD7FzBhOuxz8dmoca9WZFzidK
         9w6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727892047; x=1728496847;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozC4Wyjdu4pmuRDMmWKmlCuUQ8Fi4PleS7Ihu8qdzqI=;
        b=XrMNlgZOWQ+w+p5VL0guAjwWhWKwKwLgDU+bRXu/Iz9tRe0hfiZ75hI3vocKWYAAf2
         Mem4mcIQlS6a/lUuiPZhEhnXFfw3k4rUMWztqaxTETHOM1sqQBA/Q/PhlLXrv/Wld8O3
         OxetRWKfZDxQDIGCqLvcNVkXHhlol1qixkRyq3LjUqd5e70halU/SQee+omPxF8LFJZM
         II3YgiVxIPXcfZb+uzzz+JtAqiK/Rs+x9EUW1AkJrrIbhsCDOEp/eBvvhRNtK/q0DSO7
         T+hRS7QghhHPKaX7bMISP8QHyzvswZVAXAehuTOKbFfsvufP3BZdmjpD6NWqDRwwdJcY
         yKAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAU0LRCgSnSn6HYq6vgsaJgcQrKDDJaAKoDYh/bpB9ZSk2PphybJTbTKr1xCfQ0IpJfCBdRN9H3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbG82fQUe0wOy502mccZhpptusd7SUEGsbaBBdrYFnTuyiRNVF
	UGcxBg34K/6yBsLswwV/q1grQQad+5k2DQMsL+5y4q6kE5IMUQDIcDFsmleQby0=
X-Google-Smtp-Source: AGHT+IH/ifZ/wMzuWeC+hfqcHscZJhSVf6PjF+TaiduZ1HBSmEb0uj5p+wUO7ZhbON7h4/zjUcNT5Q==
X-Received: by 2002:a05:6602:6d0e:b0:82d:2a45:79f5 with SMTP id ca18e2360f4ac-834d84d4e78mr356729039f.13.1727892046900;
        Wed, 02 Oct 2024 11:00:46 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d8888f9b30sm3200185173.171.2024.10.02.11.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 11:00:46 -0700 (PDT)
Message-ID: <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
Date: Wed, 2 Oct 2024 12:00:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
 io-uring@vger.kernel.org, cgzones@googlemail.com
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241002020857.GC4017910@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/1/24 8:08 PM, Al Viro wrote:
> On Tue, Oct 01, 2024 at 07:34:12PM -0600, Jens Axboe wrote:
> 
>>> -retry:
>>> -	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
>>> -	if (!ret) {
>>> -		ret = __io_setxattr(req, issue_flags, &path);
>>> -		path_put(&path);
>>> -		if (retry_estale(ret, lookup_flags)) {
>>> -			lookup_flags |= LOOKUP_REVAL;
>>> -			goto retry;
>>> -		}
>>> -	}
>>> -
>>> +	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
>>>  	io_xattr_finish(req, ret);
>>>  	return IOU_OK;
>>
>> this looks like it needs an ix->filename = NULL, as
>> filename_{s,g}xattr() drops the reference. The previous internal helper
>> did not, and hence the cleanup always did it. But should work fine if
>> ->filename is just zeroed.
>>
>> Otherwise looks good. I've skimmed the other patches and didn't see
>> anything odd, I'll take a closer look tomorrow.
> 
> Hmm...  I wonder if we would be better off with file{,name}_setxattr()
> doing kvfree(cxt->kvalue) - it makes things easier both on the syscall
> and on io_uring side.
> 
> I've added minimal fixes (zeroing ix->filename after filename_[sg]etxattr())
> to 5/9 and 6/9 *and* added a followup calling conventions change at the end
> of the branch.  See #work.xattr2 in the same tree; FWIW, the followup
> cleanup is below; note that putname(ERR_PTR(-Ewhatever)) is an explicit
> no-op, so there's no need to zero on getname() failures.

Looks good to me, thanks Al!

-- 
Jens Axboe

