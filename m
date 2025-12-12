Return-Path: <io-uring+bounces-11032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F868CBA12F
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 00:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74950304BDBF
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 23:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C30284686;
	Fri, 12 Dec 2025 23:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wy6WXOEQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA96418C2C;
	Fri, 12 Dec 2025 23:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765583841; cv=none; b=XBGVhkT8FcJrgQq34UvV/mnv+vOVC8X2uHP+Bdf8cyF6eOiQ2d+99Y80yTb+n4jqSFhcrZUi42jQiX7iYTakLrBXgXHN+fsjx0GzSuHjbr46lsXBM3VSFHBp96L1gLavuQowuns8yw+lYxq4+YwBbgi2WA99XKh/PrjdfFRlcxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765583841; c=relaxed/simple;
	bh=PZVjRldkunoNGINIT/nt2MXiPRPv7k8noqm6t1X0Bv8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdX1gzI5hi19iYen4Aim7CafpGjeZToVS+XVw7Y2FjJMUzjSGX7t42o469PPZTICGvh6MkUccq1AwBWTfG0l/bdQzaljtigz0/fisulg00BS3QngJQ1FrnNhpF2u0KJSsSKuUKPNGz2HmyxdsZdRkytYL/1v8zS+2VWlY4JXy6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wy6WXOEQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A180BC4CEF1;
	Fri, 12 Dec 2025 23:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765583840;
	bh=PZVjRldkunoNGINIT/nt2MXiPRPv7k8noqm6t1X0Bv8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Wy6WXOEQSdT9WD4jekzMMRAh4PKNWPnLUkfe57ABEqRtLbSdgmF5HALwXec7/4K2Y
	 TC9qVEp+y/MJJRQI5YnCXBh1rHxzpjf9Bv9/pgIaufZZamgYE/qaLCd0ThvWoMM5sG
	 NajAAli6ha662QrbjCnX+2R9cZ9ISw7OyWe6x+GTrs1BxpfZyQ1hIEdOcq5WX7SQ8L
	 zYqfdNgc73lP8AHaRtnxaXHLDijlBLSA8Uh7HkyRaQ9oqaW7ObRaAq/QfCb6P4PA6e
	 A1fHflxzc6/XH2NIhZAw1gdWwn5R1fIZLMIosB+cX1weBWTusEeQqJYdeYwm9NhI+r
	 n816fVzEar3qA==
Date: Sat, 13 Dec 2025 08:57:13 +0900
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Shuah Khan <shuah@kernel.org>, Mina Almasry
 <almasrymina@google.com>, Stanislav Fomichev <sdf@fomichev.me>, Yue Haibing
 <yuehaibing@huawei.com>, David Wei <dw@davidwei.uk>, Haiyue Wang
 <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>, Joe Damato
 <jdamato@fastly.com>, Simon Horman <horms@kernel.org>, Vishwanath Seshagiri
 <vishs@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 io-uring@vger.kernel.org, dtatulea@nvidia.com
Subject: Re: [PATCH net-next v7 4/9] net: let pp memory provider to specify
 rx buf len
Message-ID: <20251213085713.087c028e@kernel.org>
In-Reply-To: <878759ec-f630-4961-a17f-6355df26507f@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
	<0364ec97cc65b7b7b7376b98438c2630fa2e003c.1764542851.git.asml.silence@gmail.com>
	<20251202110431.376dc793@kernel.org>
	<878759ec-f630-4961-a17f-6355df26507f@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 01:31:09 +0000 Pavel Begunkov wrote:
> > Also RX_PAGE_SIZE is a better name for the fields? RX_BUF_SIZE
> > is easy to confuse with RX_BUF_LEN which we are no longer trying
> > to modify.  
> 
> It's not "page" because there are no struct page's, and those are
> just buffers. Maybe it's also some net/driver specific term?
> I don't get the difference here b/w "size" and "len" either, but
> in any case I don't really have any real opinion about the name,
> and it can always be changed later.

RX_BUF_LEN is the existing config options which we were trying to use
initially. We're not following that approach any more. The thinking
about page is that we're replacing the device pages (rather than host
struct page), in bnxt we're replacing a define called
BNXT_RX_PAGE_SIZE. I suspect we'd be doing a similar replacement
in most drivers, replace some define / math they have based on PAGE_SIZE

