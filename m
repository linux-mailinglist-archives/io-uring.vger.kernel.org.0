Return-Path: <io-uring+bounces-5388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AECD9EA6FF
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:08:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8B29188983C
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51EFB22489F;
	Tue, 10 Dec 2024 04:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5Cx/u6T"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A0622371B;
	Tue, 10 Dec 2024 04:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803677; cv=none; b=BdGuxag+Agl5f24dFMzd/vLlGWe5zeqZN3uUVBf+sJCbZb9Yt1eh/+quMhSm+Hp/nqsxqUu/+R5qQct6AEWVh8631C5twux7M7phkaQ5bDaS7fmtQaGmcYWUg4jWvZNaeBnZ+hcoQpwrBf3MjwocU7833G3CjQCyfjfcHK51Dt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803677; c=relaxed/simple;
	bh=zoo1XexIv2JhN3L7IphblXb6SaQg+P4ejGJwyIF+uwU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYd+4HuNhV8m/noNB5VLdsQ4M6SiISLJhRoJd3dN8mdcDOSlut52xjp+Htmf3ouR3zaHREUKrmCeE8KTYHAEFSCqPqFQgLNMrRP9AuG6bTlbA70kIqIfkAkMU6pY/81FUycJr2WefejUeo2o/nl/53g461hRIiQEqU/HFAHS5RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5Cx/u6T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A05CC4CED6;
	Tue, 10 Dec 2024 04:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733803676;
	bh=zoo1XexIv2JhN3L7IphblXb6SaQg+P4ejGJwyIF+uwU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D5Cx/u6T+OlCWbRV713YGXBUo2tp068nPWdN1yiDozPt5XQH8eqKXY/+34+lex+ja
	 Sfwat3gI2mXhNYMnk2d6CCqlRkENeFHrbHyRzCgUy9vo4TBDgiZLxpEEoT4qh9cAu9
	 pRPLAcv5kHVtmCeTp8rqJJLdtkSSm7GM8yP8rcCqewuDeFjkCIegY3qb7yq5gWVIL/
	 nPrgeW2EKqrjeqvpFDojEifq4MvBZHq1QIHQfbEGQYjPQFBPQKEV2yc0fcWVX+rtL9
	 hrrfstqbtPqB4qQIbQ1U2C2np5VDJOcPQf17wb9OD51HQUC1PW2bFzTCuMKUREIjGR
	 bKvCYT2tQ9gug==
Date: Mon, 9 Dec 2024 20:07:55 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 09/17] io_uring/zcrx: add interface queue
 and refill queue
Message-ID: <20241209200755.357d4ed6@kernel.org>
In-Reply-To: <9debb3d5-d1a2-434e-b188-0e1a9d5c0ad3@gmail.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-10-dw@davidwei.uk>
	<20241209194920.3bc07355@kernel.org>
	<9debb3d5-d1a2-434e-b188-0e1a9d5c0ad3@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 04:03:32 +0000 Pavel Begunkov wrote:
> On 12/10/24 03:49, Jakub Kicinski wrote:
> > On Wed,  4 Dec 2024 09:21:48 -0800 David Wei wrote:  
> >> +	depends on INET  
> > 
> > Interesting, why INET? Just curious, in theory there shouldn't
> > be anything IP related in ZC.  
> 
> Because of direct calls to tcp_read_sock(). With more protocols
> should be turned into a callback (or sharing it with splice).

Ah, I guess that comes in later patches :S Makes sense.

