Return-Path: <io-uring+bounces-1555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC5C8A5602
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 17:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 087301C2219A
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 15:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22213762E0;
	Mon, 15 Apr 2024 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="afcYw8qV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECEE762D0;
	Mon, 15 Apr 2024 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713193616; cv=none; b=sHFyYQui/JXiEyLwWCSfUDMuEZFB3aBC7VutXY3z636Au81ZdNqpXA2MS23SRc+h03sK90KJ3Dff0WGFtxQbXTk3+Beml9QvM4/p38cMuAVtm/8f4RzluPKEMSqFffdPWcKn92ggS+02fEEADJ+9gzoT50WkvLUVjMW5A09GGtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713193616; c=relaxed/simple;
	bh=fo9y5t172LfDuFmPfvG8nPyZgXk8vePbKgvHaewlI+s=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=UAai+KPcvuIkKSTXMkvQ+umh5dRo2kEjqigfaHgOy90au5sf5lK5zBOKcgJhscBfJ4sZTLQhY5rh4bKyoDzD4cLmXj5LDs9eRlDcatsH9xQkCt+vbnkAORt9kjI2Q+b2+JZnZQxeZF5u9wL9haJ/baQdTVTtAqk8yhTtq3gwKTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=afcYw8qV; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-78d778e6d3cso304664085a.3;
        Mon, 15 Apr 2024 08:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713193613; x=1713798413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qggmMOwxDeK7hvmgMXReK9EVETMDWVfdWiCof6KB3Ks=;
        b=afcYw8qV33rbgXQDaHWYtrlFMv/rnJjBNiO4hXFTnKT9o8/NAOuVwOBZGS3Kwk9eHG
         SXEzPFBZNMf2Pj0GFm9Tw3g5eh79CyFOiPOrkdevX8WvFRBCk+EOdw1K8Pyl9Q5QgAKF
         wyWmZE5QMbEyThDG7nfI+uCsE70Vf8UnvDhG/4BU6mrlr00HiAwUMQRd8c2MdvNM6BoH
         w0DkZ0dqnp2mxmbxGAVjpsmShx+OzICiRH35hEHyWa6wjivDCkdBYwvbZK1H86kZd3vr
         GXvkcDG99wanxf05ovwV3TrnGK2AeBEmw53BAYctYWzazETNxLZH92cQSBuZTZSX09gO
         H9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713193613; x=1713798413;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qggmMOwxDeK7hvmgMXReK9EVETMDWVfdWiCof6KB3Ks=;
        b=JBXu3Jw39pyQu+pNZ25xLvKIH/XK3T2DfHk3o99j11z0Mt9oMQWx9fTRmZXDK7ohnB
         Tx9hc7qtQq/zVmdCHPUqXA9jbjsaL1QD8lgitKjPH+RtbeW1KMF60mKHU1B4HYPFre8k
         ULdmmrZMjUZYjLlf8LSEhbZA9yBpto013PNR661GI8kuJBbyD89vdZv8tcWWMEORlnLV
         P/M8AWvwIDvkh7qoczl9uyCqUhpZqeze0B1slwToQEcuNodPgN69gC3OmDYHgvGO5nLl
         yFgND98+frgHkna7qonrV+pYQk+CQN0G0UfYU5FOldu1Kl2hrlfon+h3fnsmd8IMu/Yt
         a8Sw==
X-Forwarded-Encrypted: i=1; AJvYcCWesVK31qRn6PLJKvEPPdlfme1D62TUtvv1CXG3GItTZlZEw3UMIA9hehmCGTChQ/DTJ7icWP4Hr74WVdr4ZHkgi5C9MTqCelfC5BnCruNhXcFJJr0Nik+inaqq5Z1xP74=
X-Gm-Message-State: AOJu0YyUZGLN/sRaXnU65RBB4OUYulWRKJMJnWSMM51JQW1rrmJQkrQM
	D1O6ooED/ugqvHmixywezsc316Oqf1OCu/pR6hRgangDD6rZtav6
X-Google-Smtp-Source: AGHT+IGXgC4EJp/WqobAe9u/lgLjL9nefw0n8pKO+M6oFtRpiEDLzrZOmmw+BMtvmzqBi8yiesVPTw==
X-Received: by 2002:a05:620a:671:b0:789:df6e:c412 with SMTP id a17-20020a05620a067100b00789df6ec412mr10938653qkh.24.1713193613548;
        Mon, 15 Apr 2024 08:06:53 -0700 (PDT)
Received: from localhost (73.84.86.34.bc.googleusercontent.com. [34.86.84.73])
        by smtp.gmail.com with ESMTPSA id i10-20020a05620a144a00b0078d5fdc929fsm6443442qkl.104.2024.04.15.08.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 08:06:52 -0700 (PDT)
Date: Mon, 15 Apr 2024 11:06:52 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>
Message-ID: <661d428c4c454_1073d2945f@willemb.c.googlers.com.notmuch>
In-Reply-To: <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
 <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
 <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> On 4/14/24 18:07, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> We'll need to associate additional callbacks with ubuf_info, introduce
> >> a structure holding ubuf_info callbacks. Apart from a more smarter
> >> io_uring notification management introduced in next patches, it can be
> >> used to generalise msg_zerocopy_put_abort() and also store
> >> ->sg_from_iter, which is currently passed in struct msghdr.
> > 
> > This adds an extra indirection for all other ubuf implementations.
> > Can that be avoided?
> 
> It could be fitted directly into ubuf_info, but that doesn't feel
> right. It should be hot, so does it even matter?

That depends on the workload (working set size)?

> On the bright side,
> with the patch I'll also ->sg_from_iter from msghdr into it, so it
> doesn't have to be in the generic path.

I don't follow this: is this suggested future work?

> 
> I think it's the right approach, but if you have a strong opinion
> I can fit it as a new field in ubuf_info.

If there is a significant cost, I suppose we could use
INDIRECT_CALL or go one step further and demultiplex
based on the new ops

    if (uarg->ops == &msg_zerocopy_ubuf_ops)
        msg_zerocopy_callback(..);



