Return-Path: <io-uring+bounces-4456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DC39BCDA0
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 14:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57BB61C20C86
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 13:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A3A33981;
	Tue,  5 Nov 2024 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/AFfHpb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBA62A1CA;
	Tue,  5 Nov 2024 13:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730812586; cv=none; b=KjggCnEwSuq6zCFcfnmYoJNXREj0X0m4v21bZnXcno6wRp5UQi+ZN4eqK4HuMCUC6rOLy5OZfLjzXuvAjhuufHW+INKfBbT1IpgERzSbz7MQHtrQc3VjWuagt/sf7CVhJWpi4yefVzuGw6lfIeDSzWNPq85kOmZd54njti1BNU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730812586; c=relaxed/simple;
	bh=Ocildf959I3y+8xzEL+bTqiyMCQY0iHryKg4dAdTZak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=afzQUFYhLJ1ODSKTbBdMtal2Itf+AvRImbn/9xzMb8Cm5Zv4Jfxxu/kCyDnhBnDuMUpO8CUol7XTPbEhRsdlvEQQa94m9ZXIrpIGmqsTd4GHEenP/fvj3+zQeLOcokpWZgaUbfHHeEiOiP58pRcj3OBa5Dbu3KrRXDikQShKCWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/AFfHpb; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a6b4ca29bso704072766b.3;
        Tue, 05 Nov 2024 05:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730812583; x=1731417383; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kUiqPF7eEk2d6y3IpY6xcJvHUXSzKbQ+vpPCoyVJt4U=;
        b=g/AFfHpbI+t/sIp9mikBZ1q09NEtjFnZy+2Sc90+K/gNvMR+xcECnL/LkezaMO5G6L
         1yD3BZXME7Frq3+BVjpU5Uz+Fwh5/uf0qQ9hz4IRHO+BsidUOfnD5jnQ2Whyufx5B6ql
         RmZArN3dck6cdy9e4QlchjMHF9UBJ5jzNVabJJZRuyrf0YGfyALsCjqbjVd6flSaS9dN
         fnxeXkrB7teNgcjzemcBIblYwwfmtctsFnodQnqKZmXN+ur+CB2B2ve3qqbnnTQRLN0E
         1vMeGkHSq+bEo/Bz/LLGIlWUDJaP2lbGFExrMf1TNFQr3KYIvnj8GZZfxbIl0Q03DHAN
         sBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730812583; x=1731417383;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kUiqPF7eEk2d6y3IpY6xcJvHUXSzKbQ+vpPCoyVJt4U=;
        b=T+FzHsk7E4OoUper6S+boiOYcyvFMv2quCHgm6Jh2a/ZoOvJ2viFqhcayVRTe0Ngvn
         XlRWff1HvNXIYvvnyoZ/uQqYDUENBiqPs4pTtO4mxT2PHX70ENamfRHhsr62pbdRklt9
         Js9otB0sQvyZVJy0gO751kCiy5mVij7VS3yjuw8S1/SA9GMzNgazVTeYS1cel5VIWPye
         bjdawDkgMv9I8KjqhRoqNQG2LXOVME/1IJ7Zz5miS56aaOsvRbjH9ji7B/SWseYAS1M+
         +b8/Walps1gI/U7IbgWIRWDi016xTsQ2cpYnUf9nVik3IxFTiB7AN1Gg4VgWiszHMmtV
         AoVw==
X-Forwarded-Encrypted: i=1; AJvYcCUAfiq1TnI89zWccICORPPlaKXd6YhBNrUBPIHwpr4mW2RBLkM03tMD0s90F+VC2i1WTumL7KDuzigTDaQtNg==@vger.kernel.org, AJvYcCUwZvZDc58g9MVDo5DEmnJBKYKkAYAlV9396z0ty+zyrjBiwBfW98PtSygSmGqpMK3205ggGA178CyrKmA=@vger.kernel.org, AJvYcCXk84Dp14dBmJKigOvvx9atEmREAIhY4hGl5OWE55YpVDkF/NHd5XAyVVJ0jyAox8PdGLi4DFvKZw==@vger.kernel.org, AJvYcCXmNSWiS3UdUkEncID1K/WvIcvuS+CZOXq1nzyZVlKIDAeTH9CQtmE3WYsjDPputd5QmysTlkbVcerACQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8zFrKsD2yidYxJkypEONIPgkzbc5wl6exMMreLu1hep6xTWHO
	FUlj89GACXoPNwBKhChPS8e6HJYf7hHjWt9UfstMmgC1XwE87xnvL2YUZFJLb38ZhRNjDtDODb+
	c1gKBwdGRq0QpgBJEbdUnhrtiE6ZSOd4=
X-Google-Smtp-Source: AGHT+IF3BGph15U/Zucx/r0do/TaPI1aR0aJxfp41AlvjNpG2PVZbfdERVwBWNmIyHG6C8jDgVR54P3npeWrufTwIpI=
X-Received: by 2002:a17:907:72c4:b0:a9a:f82:7712 with SMTP id
 a640c23a62f3a-a9e50b672abmr1982167566b.52.1730812582661; Tue, 05 Nov 2024
 05:16:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141448epcas5p4179505e12f9cf45fd792dc6da6afce8e@epcas5p4.samsung.com>
 <20241104140601.12239-3-anuj20.g@samsung.com> <20241105100307.GA650@lst.de>
In-Reply-To: <20241105100307.GA650@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 5 Nov 2024 18:45:46 +0530
Message-ID: <CACzX3AvrzJCdOntY3yCLomgo9jrUQBpG2_seRYPuXWk-xOpieA@mail.gmail.com>
Subject: Re: [PATCH v7 02/10] block: copy back bounce buffer to user-space
 correctly in case of split
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org, 
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org, 
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> This shouldn't really have a from for me as it wasn't my patch
> originally.  But if you insist to re-attribute it, my signoff should
> be the first as signoffs are supposed to be a chain starting from
> the original author to the submitter.
>
Will change the sign-off order if I have to iterate.

