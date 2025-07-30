Return-Path: <io-uring+bounces-8865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 306E1B163E6
	for <lists+io-uring@lfdr.de>; Wed, 30 Jul 2025 17:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29978566507
	for <lists+io-uring@lfdr.de>; Wed, 30 Jul 2025 15:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625D12DBF5C;
	Wed, 30 Jul 2025 15:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UeayzgbI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE38D2D836D;
	Wed, 30 Jul 2025 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753890632; cv=none; b=XTWvvZvJNYou7GsN7WYjXSrQI4EMkRD1Ur06BjW7o/MvRVxR6HzWkWwm/Q4per4wMlhg6I+9aE3r8oNOyzFUreObW6SFT6jNmU+zFnx8c0a85nJrXOVwSHgG1xyMX7uICgjYlWm0g3Tu26uT8XKWx4vtsvTgMd72ENDvy8qgocQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753890632; c=relaxed/simple;
	bh=arMKhOBLikpHaHAqPDpBd39QMVKwVAHNPlJ8sgfvslQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZOVe2odG271G1EkFHdHHwOzobXKa8QAI7YBCgAK9/Lhc5SFnt7ZWBUVnkjfDQeu/ApMgQmdJow6A4gihR2TWGPqkSPMWxIHOKjZRfE7W/w7VzG1f3qV8iA6l4ID1vHPbCOcDgzvrj355guNFvX0ocj3dJonRXR2v13KOjKWIcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UeayzgbI; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2402b5396cdso30525ad.2;
        Wed, 30 Jul 2025 08:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753890630; x=1754495430; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NED2UMqrSrQGMbE3C/Q4Yjl2hrXoKZhjTD2VJX228bA=;
        b=UeayzgbIqC4CAqsQz087pSfjvwjriEq339l+S6np2aK6pNXPfz0vRhM8V7TPftGy0g
         udfUR0aeQI7+Yt+SZt7X5Qt6mbrVvC8OATkoogwEVfIXfqdHmmqfewIHjxsELXTC1tmJ
         lfzDzVf+hWmb33xWtiMDnEZzG+Uq5IL2RdZw4o6xachxpJDCQ9QDHeV0USm3ggHC6hzf
         YjedEoCkqZe9uK8K96TBCfYac2SOHoItq+J9odcl58sTjVR2qwZsNm00sAww9WjqgmZe
         whxJ0CPG7tMtOmX8/23GLEzhm8t2l7U3mPD1hb2Vq9OCbkw67Tf0y5E42NM1EF7laQdj
         j/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753890630; x=1754495430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NED2UMqrSrQGMbE3C/Q4Yjl2hrXoKZhjTD2VJX228bA=;
        b=OV23QwB1Yagkte+UacjlJzxdwxOlbXq/1xzyaJSTQPZ2woIg2CEMaDE2QkRs+W8j5H
         NfTbSZFMM/UjujkTJygHuUrbBOcxHxkqTAAjAmba5sygEsV061WFQI3P2f+kaXPz/mMd
         cz/fZd8FlGloM79AhaSbB2olBnvNRRjSSY13/zqh4ACPCYqsTYMccJgJbwHYajfCI8bE
         2+xjVgm4jZz5zd6JD9PC+Hy5SIJAU8xjO9Td22pFSz76R/q63oodPcwgJFVXsvbWL6+X
         PNsWUhAqjKZZeDtGe0NCHTTkE7DCgi+vYNrUUwKdLpYBrJaNjsTvMVVQXZsF9JWTUpuW
         mevg==
X-Forwarded-Encrypted: i=1; AJvYcCVK8a6dz0iiGOI7P/VJ+hVxJ+9jqukx295mmq8yT+1aoFZiHeWPi36NEZJPsQBdFUndxqBsfahq7Q==@vger.kernel.org, AJvYcCVRcXIUE3x/VjFChSuTjrKB23tSE1w+WrhIQfXTt95Zj7r4/6B8menhlyL6rdEMLzOI9ktCrzuj@vger.kernel.org
X-Gm-Message-State: AOJu0YzqsVTyEPfNleXIHwcRIb7u9UWzp7ZdVK+1OMa7IvSBr2fu8lP2
	G/VR2pf9M96m8l1TnyW1NzYe8lZi8+K97vlpya1bYgEfca5i/vojXwE=
X-Gm-Gg: ASbGnctP9ELx6VWwV3Bg0wf0dDYhuzP8vPCj/3vDW+DYnvUaxz9GbLyV4bIk1zToW1J
	jc3/wjLAj3niORjVDy9PfW1lg20YMCVpon+mDm5ht+8Vci5lkcwblXJ0sTltdHbAhYxGVAOWXSv
	TfegE79rZS/mUWIb8jpSfGZ1jLNukCKmbR/YOo1CfYzuDl35SNYJyO1DJ92uKsp6U3yyk1epw2g
	28TnW8aYy1aKEaccKiKBFjYF2muf6PRWce3IQoEdxQxj18/aGPKxlEiGRQ8tUgLVXxajPQYtRlc
	lxpxIf4VAaTsQUAPU+dQd+Tnhk7VdS55iSiBlWylwASUOW5J1Q29GiNsZDIGY1iXzTYWVX8yXQo
	O1ygmNd4YXAXt0mTagRv2c4RZ3zYn2YmoZyN72eXgL96KbvMSiiKLntiuVoQ=
X-Google-Smtp-Source: AGHT+IEznLW3jKKzs4oHvJBTPQ+AIMpFNQ2jjLmy6dpKZpS/IYA6WwUM4m4xMubpKhhs4KWcLWsIPA==
X-Received: by 2002:a17:903:32cd:b0:23d:d0e7:754b with SMTP id d9443c01a7336-24096a6685dmr55470865ad.18.1753890629780;
        Wed, 30 Jul 2025 08:50:29 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2403de0710bsm66281925ad.12.2025.07.30.08.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 08:50:29 -0700 (PDT)
Date: Wed, 30 Jul 2025 08:50:28 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch,
	horms@kernel.org, davem@davemloft.net, sdf@fomichev.me,
	almasrymina@google.com, dw@davidwei.uk, michael.chan@broadcom.com,
	dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
Message-ID: <aIo_RMVBBWOJ7anV@mini-arch>
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch>
 <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch>
 <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
 <aIf0bXkt4bvA-0lC@mini-arch>
 <52597d29-6de4-4292-b3f0-743266a8dcff@gmail.com>
 <aIj3wEHU251DXu18@mini-arch>
 <46fabfb5-ee39-43a2-986e-30df2e4d13ab@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46fabfb5-ee39-43a2-986e-30df2e4d13ab@gmail.com>

On 07/30, Pavel Begunkov wrote:
> On 7/29/25 17:33, Stanislav Fomichev wrote:
> > On 07/28, Pavel Begunkov wrote:
> > > On 7/28/25 23:06, Stanislav Fomichev wrote:
> > > > On 07/28, Pavel Begunkov wrote:
> > > > > On 7/28/25 21:21, Stanislav Fomichev wrote:
> > > > > > On 07/28, Pavel Begunkov wrote:
> > > > > > > On 7/28/25 18:13, Stanislav Fomichev wrote:
> > > > > ...>>> Supporting big buffers is the right direction, but I have the same
> > > > > > > > feedback:
> > > > > > > 
> > > > > > > Let me actually check the feedback for the queue config RFC...
> > > > > > > 
> > > > > > > it would be nice to fit a cohesive story for the devmem as well.
> > > > > > > 
> > > > > > > Only the last patch is zcrx specific, the rest is agnostic,
> > > > > > > devmem can absolutely reuse that. I don't think there are any
> > > > > > > issues wiring up devmem?
> > > > > > 
> > > > > > Right, but the patch number 2 exposes per-queue rx-buf-len which
> > > > > > I'm not sure is the right fit for devmem, see below. If all you
> > > > > 
> > > > > I guess you're talking about uapi setting it, because as an
> > > > > internal per queue parameter IMHO it does make sense for devmem.
> > > > > 
> > > > > > care is exposing it via io_uring, maybe don't expose it from netlink for
> > > > > 
> > > > > Sure, I can remove the set operation.
> > > > > 
> > > > > > now? Although I'm not sure I understand why you're also passing
> > > > > > this per-queue value via io_uring. Can you not inherit it from the
> > > > > > queue config?
> > > > > 
> > > > > It's not a great option. It complicates user space with netlink.
> > > > > And there are convenience configuration features in the future
> > > > > that requires io_uring to parse memory first. E.g. instead of
> > > > > user specifying a particular size, it can say "choose the largest
> > > > > length under 32K that the backing memory allows".
> > > > 
> > > > Don't you already need a bunch of netlink to setup rss and flow
> > > 
> > > Could be needed, but there are cases where configuration and
> > > virtual queue selection is done outside the program. I'll need
> > > to ask which option we currently use.
> > 
> > If the setup is done outside, you can also setup rx-buf-len outside, no?
> 
> You can't do it without assuming the memory layout, and that's
> the application's role to allocate buffers. Not to mention that
> often the app won't know about all specifics either and it'd be
> resolved on zcrx registration.

I think, fundamentally, we need to distinguish:

1. chunk size of the memory pool (page pool order, niov size)
2. chunk size of the rx queue entries (this is what this series calls
   rx-buf-len), mostly influenced by MTU?

For devmem (and same for iou?), we want an option to derive (2) from (1):
page pools with larger chunks need to generate larger rx entries.

