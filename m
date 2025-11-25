Return-Path: <io-uring+bounces-10780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C8EC8321C
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 03:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 531E14E53BA
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 02:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEE317BEBF;
	Tue, 25 Nov 2025 02:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HplQ5l70"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8141A295;
	Tue, 25 Nov 2025 02:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764038852; cv=none; b=BIFQcBf+Qg0S8KZi2Yx14GiHkfvsgzIsRo0VG2g7upBkyqNeu/UdZo3XoDTwI8SLNnfQgGYa/mxx93R3Zq0Agk39cgzigkE30n7jsKnok9cZYmg7w1+UFNDqQCRoBeWaLBszSjvm6L2BwgltpFtRjdelTJtV9MOb8tkFybwuqwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764038852; c=relaxed/simple;
	bh=7Ws/PbUNVl0lL6lS4g6QyFe+ZcfmM3/1TNjllqxL5NU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AvUfSV7iV6xZhuywzZJiQL0ZZotHKQLBjBsNVRb8UuZ24Z0sC50xo9TtAF84mYGGOmHzYSeSq135f6/75rp/YcogHELk85IcusZCXWCIjDm1U4VqKF6Ye3U0m4QKM2Sym4OoNm7PoPwGy4OSXyCztYahf6o5/iNABBK22ZRXzqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HplQ5l70; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2F4C4CEF1;
	Tue, 25 Nov 2025 02:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764038851;
	bh=7Ws/PbUNVl0lL6lS4g6QyFe+ZcfmM3/1TNjllqxL5NU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HplQ5l70hjnVJ1gxxUIdSHwiqclcKmNTSunj+ZcPl2/2vICsQPKb7N/1chWROdcDf
	 tABFBPI4Lt3J0UQ+6/+1pC4M5k8FLyxjfafychqIDnttVlyNnzZi3Otyu4sPckGR+E
	 KkLEZGv4Qmj4ke4OyyHv+SgM6mK9OzUJoDAPqt+597B+9ZEvIr9S84SAvfKHEukQLI
	 n1y+mkkPwz/GdHKomZsEY3pUfhzlYy6ctIWJ1ITxbKiUue2z+C/fr75VajdtRwc+63
	 rc07z8XxIVwme/Zhfmyhulo054XUBQC4cXcvOtREMewGHafokF78sfwpmUqfF8qEDw
	 1si6Q74vahNpQ==
Date: Mon, 24 Nov 2025 18:47:29 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 ziy@nvidia.com, willy@infradead.org, toke@redhat.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 asml.silence@gmail.com, axboe@kernel.dk, ncardwell@google.com,
 kuniyu@google.com, dsahern@kernel.org, almasrymina@google.com,
 sdf@fomichev.me, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com,
 shivajikant@google.com, io-uring@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netmem, devmem, tcp: access pp fields
 through @desc in net_iov
Message-ID: <20251124184729.7e365941@kernel.org>
In-Reply-To: <20251121040047.71921-2-byungchul@sk.com>
References: <20251121040047.71921-1-byungchul@sk.com>
	<20251121040047.71921-2-byungchul@sk.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Nov 2025 13:00:46 +0900 Byungchul Park wrote:
> Convert all the legacy code directly accessing the pp fields in net_iov
> to access them through @desc in net_iov.

Please repost just this patch. The last one needs to come after the
merge window, when io-uring and net core changes converge in one tree.
-- 
pw-bot: cr

