Return-Path: <io-uring+bounces-3503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3C09972EC
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6B128335B
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 17:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D538D1DFD8E;
	Wed,  9 Oct 2024 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pnxCgdPo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD67F1D318A;
	Wed,  9 Oct 2024 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728494391; cv=none; b=NQeaod9yPELJmSgcss+nhsHnW1c2F+9cOomUGU6UNmEHAmKX/nK9aGsIJTHog4CQ5XB/MBh0TGrK41c/YECaTm5F+d89JoUoDq1uh1sRiFx/PXkY7QWZOuTwCtXILV06TxwS9sTFIsOSVapT9c9urCp3qM02lZTL3xIqq06redE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728494391; c=relaxed/simple;
	bh=hPH7G999uoO6gpSkMFl/hA410eyuX3sIBYo6HYKqfj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V5UTBi0+VXjoqhoQHjiM28Ebml3PvNiUBVclt0/AGtD4RPdjM5ZlWS3Km0KJPoT41fNDl/ONnUKDms70SJhiywgVm4D6sQ2BGSZB/TpMGxhKIRadQyPL6vjjUdmSywUJ7S9Xs9gE6dpuEz6Z/rKv6ksSorh5di0TzYdu0Pv8MoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pnxCgdPo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1569C4CEC3;
	Wed,  9 Oct 2024 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728494391;
	bh=hPH7G999uoO6gpSkMFl/hA410eyuX3sIBYo6HYKqfj4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pnxCgdPo9fM8oAewqR2se2etX4nRioMzy18Qh/QTocO+QD65YPCQmbJyr/4wQrWUt
	 aAgfRrUVCQIJ8M4q8C7FZGLQO7nPp375F9HVz+uxfzGJzEjPHoVjDzBrp7k331lkZ6
	 yiphG77fKetkKWMNGknCOXej/BOUPS99sAdBMAmMKWYeEmpDdqCyoJZhe9ynNx7mGC
	 KOfwzRIO4kCFrHScC5zkGIIqERy+vVzgLzKTcp9NRlrgobPaJAYm+V6PNFkVH63v4J
	 U8S51d/M7JpscEiUh78otxc7ptpn1+VlWu8PylotPSHqfNXkNJ49eih92gRT42LxUQ
	 sRbCUtXpYOEoA==
Message-ID: <beb6e864-99a8-4ac5-b709-f764b1bcd7e4@kernel.org>
Date: Wed, 9 Oct 2024 11:19:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
Content-Language: en-US
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 10:55 AM, Mina Almasry wrote:
> 
> I've been thinking about this a bit, and I hope this feedback isn't
> too late, but I think your work may be useful for users not using
> io_uring. I.e. zero copy to host memory that is not dependent on page
> aligned MSS sizing. I.e. AF_XDP zerocopy but using the TCP stack.

I disagree with this request; AF_XDP by definition is bypassing the
kernel stack.




