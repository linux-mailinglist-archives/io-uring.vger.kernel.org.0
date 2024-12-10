Return-Path: <io-uring+bounces-5382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A77A29EA6CE
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6692F287B6E
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517F413635E;
	Tue, 10 Dec 2024 03:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWiHLmAa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2697B4501A;
	Tue, 10 Dec 2024 03:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733802562; cv=none; b=eIPRkYBpn3BPcbAvxzADz/yEb2sPzYMFZcSBP+R0Q9N5rcbQB6vxwk0zDm0GFsujucWHo+raSMmgUyjzhQ1+JJxM8ctLcQmNf3FNLhPLEPykIvouwqxyjxXrWC1jsezvI7tE2t6HTTIec1HwLIKTWKUozmB8NSkGrZFcyJd1/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733802562; c=relaxed/simple;
	bh=WiPw36AHy+thVYAlbe9x8lWH1QFDYbuTxTaIBprT7Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fl1XuCJEUQnrsMX0jdImPR/K+u7nJeRZNLb4q2FI5maPAs9kiFD1cXaiWQNagmybSodQ2oxCsP9jklm3R02wiNySfQKEsP18iDqD7tQp3hj8JU1GNhyp6QwB1BQsxU2qDZILZXJ4/S8rPIVeZX4AAQ2rPAgP5Zeeit6l6rttwYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWiHLmAa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6EDC4CED6;
	Tue, 10 Dec 2024 03:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733802561;
	bh=WiPw36AHy+thVYAlbe9x8lWH1QFDYbuTxTaIBprT7Vw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uWiHLmAaB47zpRLKn8uPxNvkjOS7tZPXqVHIiiP+Cj3YhKsdv/SP+Z0FUp/fILWh9
	 b6/vDo9UUgVT3hBf/TJH4jWzysKHD3owZ36oIPm5JNeZOv3VPPzsI+8/GDDL4htXwG
	 uxql+XEx255rE56XwKxqF3FxxSg/szvOR3AVBIO/AKbDcjteiNN8nswS/p+W0HjLVe
	 5ZOjPZnmylgFxyuUYCADGfHD61kooWSLiD9FauoHskHkulfNFlXsAWzrFtKGKzYi/f
	 xqpW2DFH+NvWjckxdJynWrZLWlUKN/ypv3giKXbCXEx9GQjL24MFALSsZ0Ap+3iICQ
	 PoEqSmQHIePwA==
Date: Mon, 9 Dec 2024 19:49:20 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 09/17] io_uring/zcrx: add interface queue
 and refill queue
Message-ID: <20241209194920.3bc07355@kernel.org>
In-Reply-To: <20241204172204.4180482-10-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-10-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 09:21:48 -0800 David Wei wrote:
> +	depends on INET

Interesting, why INET? Just curious, in theory there shouldn't 
be anything IP related in ZC.

