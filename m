Return-Path: <io-uring+bounces-9858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A69B8F580
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 09:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3029189BB7D
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 07:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8468A2749CF;
	Mon, 22 Sep 2025 07:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxIAdxYb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7293A920
	for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 07:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758527643; cv=none; b=u+yhHWd45SBNB5PWbem2uircrDxc38xy5T5p2G4ARWZ3DpbiMZD6fV2gd4/ox9CreHZ6jVgqSFNAcK9wrtZhVWGfmjplJNISzJqQPMScRJGfq9ju9HenLQfd7REH9dPDGWM9NaeJDqo0az3wHROYtFZkHXAVaV9Er7JUOcVJfN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758527643; c=relaxed/simple;
	bh=qri0lyCq5jCiDgMn3RDkOxcla299jzKdnUOK+YGRbiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=acuqRuqXV9X/O4we0ay1yJqMT7V5Ua3EzuzFMOkgBBAppqEMfWaP+OLrfvh1TZ752t30nO4DaKERcXO5JP6lQQwQMogcwuQOu3OopDsDKtEOLvjMOmyGI+cgCDBDglgwqo/Wiu/UAqeNCNM9azfFevcCAqx5TicdN+60fOEWSq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxIAdxYb; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62fc686dc41so2264877a12.1
        for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 00:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758527639; x=1759132439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZI6wZrxJQoLuwnQq+4IXNXHG5D3b2upy9AIVIX299xQ=;
        b=LxIAdxYbnQY/f/uxlVbvKhAdzfduxH5SYXLqOgOje01AJsUzJ03qViX8ZWtVYwejjb
         bgFwTIt8RxYvQjCN7XKNtAqXavYBcqv/9iPjod9McCFlIzuWs3INydelKoA618BuDzLh
         LsilK+v/pfPFP7hzq4/58NhH3SK/KhwIJhKJ6e0BFHOW/wuzR69lKiXppayHNQsxi+RP
         Nyn5h5k/F2VdRONCX8+U6C4hRWMq1r4W1AbDDmvhUr66FcTGe/sNKU2DnaG361UuV8aZ
         SwQwT3RB+BGu0CQVZknZX//BzOEcZkfFeFlIemevqLz9bcEkFsyu+TMxtPa0z2T4c43M
         zRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758527639; x=1759132439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI6wZrxJQoLuwnQq+4IXNXHG5D3b2upy9AIVIX299xQ=;
        b=sp38MaDl++YzhMxa8AUEjVDs7MPNArP/qh9vOYKAZr/LaLXsuCEQmURxMrK3eq5V1W
         pKuHjQ4Vj1HSEFruhUCZBhXk1ZNlpOOVsmGDNZZ3jICpB1xij/ttzHDjoWWSQSEEQrCX
         4nK0ijL0Ph3KhrzDALDEMbI8soLQ8pZgVmf3QQCdLZ/wZdFnwBtBhgbuoFlEIIJoIaDz
         WhQzgzic1FlGW/Tu3xPdVBKtQTxN5d1SdCDx899ltfMTMbGRpxbbpgLyy9ekobxBv6cc
         RZPRdvbE6Q5sAqGF7DBDyF8PbwsT96lB2mQSs6iAAsT34sSNwOfbQipy35fqMpkV2RYc
         cvkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV6kRIk6DlI5d8GFS1TOljL00aKDIVf0O6Cix0yRq79H01CMN499DtiK7Dz4xr9/elzTp03Qzg4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0o7291E9DCW47zb6OTpl93whWZ6i3AtnyYyGCyQG5pgAiDeYi
	61ZGYqzP24YrVpN1/DXBzO55raeyUfPLads/QX535WCIjrW1sN53DMMSiyUHcEds
X-Gm-Gg: ASbGncs8vb3DlsdSwLHN5ooK130J7n45dD29gbMd1ymt4rnz1w38ErFnqFozhOSWotZ
	A0abEnV4A4ZLdsO+A8BYF/69+JHhJL9I+TWYLnJTPe6X/RyeTcna8CBhV9RFNszONvA+x2Q1GhN
	HStmTfNi1qEiMmX6r5hOnLzL5sflX0t9NmS6WKnvAnXPFxm3c47i9CL0EqyjTZsA2UZYiTK9tu+
	727r3INBJz6Favgy5FhlGUe5IpiAiUv6kNHyTl+VZSxHYxC+ngEkVnP+MwI8kgGcRvQZrHd30nq
	wyVemgxkvbLTX1C2ybLC8o856jKtqXLnC9ZjZlHmLebHHQWWyEomlkgJ2is7xvHuyeNqdgOXBvP
	/5RZ09FBM5rKUWwrEVnsd7zNWJphhn5Zxmg==
X-Google-Smtp-Source: AGHT+IGaVXVcqf8OIHiH0s224i9xXUfBOIu6YXbPlfnJ1/XzKrv+X3GSYP2RifhC1UBnEoWnaOyDPw==
X-Received: by 2002:a05:6402:5411:b0:62f:b398:ffd1 with SMTP id 4fb4d7f45d1cf-62fc08d5d76mr9730152a12.3.1758527639230;
        Mon, 22 Sep 2025 00:53:59 -0700 (PDT)
Received: from [10.135.195.141] ([148.252.132.189])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa5f2766fsm8465890a12.35.2025.09.22.00.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 00:53:58 -0700 (PDT)
Message-ID: <0571f0d5-afef-4ba9-9db9-b2b61611368c@gmail.com>
Date: Mon, 22 Sep 2025 08:55:31 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/6] Add query and mock tests
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1757589613.git.asml.silence@gmail.com>
 <175828771958.850015.18156781064751353661.b4-ty@kernel.dk>
 <55ffd8a2-feca-427b-90f3-151e3e78ecc5@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <55ffd8a2-feca-427b-90f3-151e3e78ecc5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/25 17:56, Jens Axboe wrote:
> On 9/19/25 7:15 AM, Jens Axboe wrote:
...>> [1/6] tests: test the query interface
>>        commit: 7e565c0116ba6e0cd1bce3a42409b31fd4dd47d3
>> [2/6] tests: add t_submit_and_wait_single helper
>>        commit: f1fc45cbcdcd35064b2fbe3eab6a2b89fb335ec6
>> [3/6] tests: introduce t_iovec_data_length helper
>>        commit: 7a936a80be37f50a1851379aa0592eeb3b42a9a1
>> [4/6] tests: add t_sqe_prep_cmd helper
>>        commit: 7d3773fd9e5352b113b7d425aa5708acdd48d3c0
>> [5/6] tests: add helper for iov data verification
>>        commit: 9e69daf86de39c9b4e70c2dd23e4046293585f34
>> [6/6] tests: add mock file based tests
>>        commit: d5673a9b4ad074745e28bf7ddad3692115da01fd
> 
> I noticed that there's no man page additions for this. Can
> you add something for IORING_REGISTER_QUERY? Might not be a bad idea to
> add a helper for this so applications don't have to use
> io_uring_register(), and then the documentation for how to use the query
> API could just go in there and just get referenced from
> io_uring_register.2 rather than put all of it in there.

Will take a bit to do, but that should be fine as it's
not yet released and will take at least few releases to
really become useful.

-- 
Pavel Begunkov


