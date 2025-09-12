Return-Path: <io-uring+bounces-9767-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE92FB55132
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 16:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59AA57C6E23
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 14:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13773112CF;
	Fri, 12 Sep 2025 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trxktfTZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90AA310635;
	Fri, 12 Sep 2025 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757686953; cv=none; b=mKvY1l59NmApokNgsokFQGuQorWpqvNbhhPFyIb9HtzrancpgAxW4qLt2KVA90LoAgYGDLYiFDAiEUoejiqDEcKzTYGALNk8NdWDHKXHAHr239AvugZm5RD5g+HOv1j7+/9AO1yuETiwzswq1nH9Iq/OIg+IPNSj9J7o3RuNkaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757686953; c=relaxed/simple;
	bh=6gVH98vnEQp7d3I+Ud6918Xk9foWHiIBcXR2vivNm8E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lTEtCLEMKFl1asAyLTRhVKK2cbkbzCjXZG6jC70MmrpwiY0JhJKg5W4nKXBW7vBIpB6UimuojNy2LfcOFyrCrW14Ma6Q0ARnLVCtIZgtxv8IylknzATMdg7FJH9qAA1oSo6fAM0eJ+l4alvZ3CbvxIMucfdCJnObhzqBXf4UQrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trxktfTZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598D6C4CEF1;
	Fri, 12 Sep 2025 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757686953;
	bh=6gVH98vnEQp7d3I+Ud6918Xk9foWHiIBcXR2vivNm8E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=trxktfTZNWwSMJNyjwi48c2iIkYZNFQD1zr4T+3OtUKfpK+EFzDmPAGhJNdgiOA1x
	 HVnPIVKOyZT/udHznrXOCiMJ3j4tjvG34pw1TkosIrh8EIAifeWuy8zAHDJmTjqsWW
	 4P3UoCZwwG2zJgkU2c4IiPAbpRquvzpE4n7tNhSXlPhiFduf2PXo2vtyNXCf1OxWdd
	 6PIPsgxG5WPgklTAHc32MWZ5p0ViZLHGxcEB/DGhkf3b5Dp5+ArcTY1Ilg2x+u7kYR
	 yFs826pRmH46sM7M9ue+oI0m9PQF/U1aizFgeBH7ofTOAmxm4j9s2hOrISnTIYLehG
	 Dttibo0FxNygg==
Date: Fri, 12 Sep 2025 07:22:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Feng zhou <zhoufeng.zf@bytedance.com>, axboe@kernel.dk,
 almasrymina@google.com, dtatulea@nvidia.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangzhenze@bytedance.com,
 wangdongdong.6@bytedance.com
Subject: Re: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get
 dma_dev is NULL
Message-ID: <20250912072232.5019e894@kernel.org>
In-Reply-To: <58ca289c-749f-4540-be15-7376d926d507@gmail.com>
References: <20250912083930.16704-1-zhoufeng.zf@bytedance.com>
	<58ca289c-749f-4540-be15-7376d926d507@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Sep 2025 13:40:06 +0100 Pavel Begunkov wrote:
> On 9/12/25 09:39, Feng zhou wrote:
> > From: Feng Zhou <zhoufeng.zf@bytedance.com>
> > 
> > ifq->if_rxq has not been assigned, is -1, the correct value is
> > in reg.if_rxq.  
> 
> Good catch. Note that the blamed patch was merged via the net tree
> this time around to avoid conflicts, and the io_uring tree doesn't
> have it yet. You can repost it adding netdev@vger.kernel.org and
> the net maintainers to be merged via the net tree. Otherwise it'll
> have to wait until 6.18-rc1 is out

If only we had a maintainers entry that makes people automatically 
CC both lists, eh? :\

