Return-Path: <io-uring+bounces-4868-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC389D3ED9
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 718D1281D32
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D381714CD;
	Wed, 20 Nov 2024 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eLaxmxqB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785BA1F61C
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732115676; cv=none; b=Wd2+Y84H+O/cj9Ug/jV0E9qKUVIKVNf3+5uGyqrmTMhUT7cTmybVElduv/x3bH8YI0ylI9W29xT+4wZpMER7gW392EWap0pq0QmvzpPs5SFVCcD1UU0D36h02mGa0H2XQq/uw/JLlSNYtoPB7ARPTz7GukkgHUOiKkJ70l2sIRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732115676; c=relaxed/simple;
	bh=o1j/Albla1/PkvphP2JzJa0TU5NZzt1QmBqKueXYVNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u9UPYv013Y7+fk1XNYVczVSynVI7juzyhsci0yKdknMHW7KalkLvrvMu+dGiSxX7yP+p+3ythJKll3bgfN8/sYRwbXdG9nXv0E6xg9bTI5V5R+03ejxVj+Gn3U2veIWBOrTE4g99jZv2Hg6I0RjGVvSRfZHn23hcmrgdeDj8BU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eLaxmxqB; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3e6005781c0so3612492b6e.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 07:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732115674; x=1732720474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6syN8PaaK8yRJ5R3n5u7e4t+723sbfBLvN043ezkFak=;
        b=eLaxmxqBoU9XCcBzzPC0NQKJt0SeLw93uQI7CKjJuDR6oABpFgwlSuLfD5mKvnqeCf
         yql44DMo+WDVxpEzlwZA9ogbYRflrAmrWrkzhqgYSx3pZ3Y99MrJLBuRYPf0uTSBIwx9
         aGSfhVVMMi6ydM68bLuK83DRbnufdXHbrFouynvAPlM9oDftErqy3jZwTu7Q1S3GyG5H
         /KrzuQO7GNSuBjTHafCLsq0Y798kp0CQPRfONxs8zjs6Qj3NIbB1B5tLVglKdLKNrXps
         X3rTx95k3graXYF39Q8bbYxK7ed2kBbobcoiQy9AQxF7Xj7giRHhu1cCXTbyQVaJvaHn
         A0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732115674; x=1732720474;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6syN8PaaK8yRJ5R3n5u7e4t+723sbfBLvN043ezkFak=;
        b=GD8ZMpJrszdmuZEX0fDNelurxc7HlbLSk2FkHQf5q2dKE7WEjRwBO6J2gACxTsvggI
         NIavtAjYMpVucks1aWFWZYTFJkC30BLxjWR+Ot3rf2IYLNEQ2RsLMBTJyH1urbpIHw3W
         M2yy7p+U5PLC12dtzDTIJjDE78QS0HQAAka7fe4qYMO7war3tTYhTcUgUetgTH7DXbeA
         a5r1VTEIWnCZu7f1fssGGfAnNpjwlZD59xNCuyaIUOBkh1XcrZsExWQ9QZKbCrdtVakm
         vydS6aMRTw1NQZJJRHt9HuChPF6EjJUlv6p/iD2t+htEyyBPul4pFp/m9poZiIyfONes
         QE0w==
X-Gm-Message-State: AOJu0YzkP2NQrMcPCzywVn80nT3mZTkU4FKryTuJRK9Z4VITA0x29Cbo
	XpmsGYzO1zCBiw7QMtBHwuFSbJwpqVcSyoI0tEyZVkNrsErv6ClGGBOJEN7ftMg=
X-Google-Smtp-Source: AGHT+IHdCa+nVmJOP81hLcdeZ/U2BHXxvMqIit8nWC2bZcW1L9qKHJUn3ZjU643kUJDd9kSpxhWVbA==
X-Received: by 2002:a05:6808:3945:b0:3e7:f089:5099 with SMTP id 5614622812f47-3e7f0895810mr291795b6e.22.1732115674127;
        Wed, 20 Nov 2024 07:14:34 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a780fed32sm3949209a34.26.2024.11.20.07.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 07:14:33 -0800 (PST)
Message-ID: <2fe3005b-279d-489d-823f-731c6a52e5b1@kernel.dk>
Date: Wed, 20 Nov 2024 08:14:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] io_uring: add support for fchmod
To: lizetao <lizetao1@huawei.com>,
 "asml.silence@gmail.com" <asml.silence@gmail.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <e291085644e14b3eb4d1c3995098bf4e@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e291085644e14b3eb4d1c3995098bf4e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 1:12 AM, lizetao wrote:
> Adds support for doing chmod through io_uring. IORING_OP_FCHMOD
> behaves like fchmod(2) and takes the same arguments.

Looks pretty straight forward. The only downside is the forced use of 
REQ_F_FORCE_ASYNC - did you look into how feasible it would be to allow
non-blocking issue of this? Would imagine the majority of fchmod calls
end up not blocking in the first place.

-- 
Jens Axboe

