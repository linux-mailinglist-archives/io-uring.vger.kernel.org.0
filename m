Return-Path: <io-uring+bounces-10809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5A8C880A2
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 05:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1AE814E14A5
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 04:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C4E301027;
	Wed, 26 Nov 2025 04:21:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01803236437;
	Wed, 26 Nov 2025 04:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764130869; cv=none; b=LJPB5GWOt13tBG7Wys4PrLEh7d3x+kz+S+TOruLdhTBLXUCPlN35bgPNRM3Q7h8C+Wxrp4g9eTSuDVg0ZFS7pbne4apc+uigGBMqAoyJQTO/kjxXtRFl2yNk7us35bdYSj8kgomBT4ixejkWNz18N0hT019bTYvia4ebD1Kk6zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764130869; c=relaxed/simple;
	bh=6Od6tKtafBggIrW0EfCiMEwi/gxLATPxr5yiAXADMiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQxdcsVb9fjku/hdJQbIPf46ZOt6Hs9qv7xEZ5KiMskIuQHXEYR7RqKuydOmUgLb+K1mGhOAlRdwu6DVx4agTlCWe+rJhc9fZYQcsR//jj8l0MX0kPXZ0dqUacE9ae5PPmiYJMCtxcTZoyZxYl9e77I/HC8k2bbtG8yxEQgbePQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-fe-692680265a1c
Date: Wed, 26 Nov 2025 13:20:49 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
	almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netmem, devmem, tcp: access pp fields
 through @desc in net_iov
Message-ID: <20251126042049.GA67399@system.software.com>
References: <20251121040047.71921-1-byungchul@sk.com>
 <20251121040047.71921-2-byungchul@sk.com>
 <20251124184729.7e365941@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124184729.7e365941@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec95d3Ycjk7T6lVBaqmFkJdIeKnoggTnoxkEJWErD+7kNm1T
	m0Gxymh5zRTRabUiUuesmKJOy3SmNbM5M2OFqYhmZWn3tInmZlHffjz/C/8PD01KvsNAmlel
	c2qVTCGlRFD00ffGpjBdGB9ln4vBtbNaXDXaLMBz5kkCV5oaAa59XUjhyr5siL/f+UXi2y3n
	CWxtmQT4fVkdhSe6x4R45NYbiO9daCLxWOFjCk+fd0DsbCwQYEdnDYWbdKNCPNBSSeFh86IA
	2w01EOuH7kPcbVyNfzz5APBgeQuBrw8l4medYxBXnCkA2D275K/oGhbuCmYbal4S7IuyIsi6
	2noI1mp4LWSNlgy2vjqcHXiawVpMFynW8uWykLU2fyXY/HPTFPt54hVkZ9oGKbbX+FDIfrUE
	x604KNqexCn4TE4dueOwSJ7nrBak2Unt24J+gQ6MEzmAphGzBfU74nOAjxd7jSVCD0MmFE3l
	tZMeppgNyOWa87I/E4Ky68uhh0kmX4AqbFoP+zFHkLnY5M2KGYxq80aW/CJawugB+jZbQywL
	K5G9fPxPOBy5Ft55N5BMEKpaoD1nHyYa3c/t8dpXMetRe+MjwtODmCIatdZbyeWhAaij2gUv
	AcbwX63hv1rDv1ojIE1AwqsylTJesSVCnqXitRFHU5UWsPQMt07NJzSDL859NsDQQOorvjsf
	yksEskxNltIGEE1K/cV1BSG8RJwkyzrJqVMT1RkKTmMDQTSUrhFv/nEiScIky9K5FI5L49R/
	VYL2CdSBwI6hs59ih1VRm3Y0IL3ixtbF8St9+x1+5tKF+PScwZL+vFb11DXLIWV1ckpcglZf
	krY3K6jNPnAA7nRfFQesvVmcsW5mPmFq96T7Z2y3RA5Pj+RufJ76y/SA1R0v63p7etuerttU
	DG/tdvYf63CHxMTlAlp5pCtS27SrLrFUJIUauSw6nFRrZL8B14M6GAgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsXC5WfdrKvWoJZp0HxKwWL1jwqL5Q92sFr8
	XPOcyWLOqm2MFqvv9rNZzDnfwmLxdf0vZot1u1qZLHbues5o8WrGWjaLp8cesVvcX/aMxWJP
	+3Zmi0f9J9gs3rWeY7E4PPckq8WFbX2sFucOr2Sz2N7wgN3i8q45bBb31vxntTg5ayWLRced
	vSwWxxaIWXw7/YbR4urMXUwWC+/EW1w6/IjFYnZjH6PF7x9A9bOP3mN3kPfYsvImk8e1GRNZ
	PG7sO8XksXPWXXaPBZtKPTav0PK4fLbUY9OqTjaPTZ8msXvs3PGZyaO3+R2bx8ent1g83u+7
	yuax+MUHJo8zC46we3zeJBcgEMVlk5Kak1mWWqRvl8CV0XNhBWvBSeaKF30XWRsYnzB1MXJy
	SAiYSJxZMIUdxGYRUJV43XOAGcRmE1CXuHHjJ5gtIqAi0bJ5JguIzSzQyyox+1AFiC0skCSx
	ZvIqsF5eAQuJ1T33geq5OIQEOhglvvxYyQSREJQ4OfMJVLOWxI1/L4HiHEC2tMTyfxwgYU4B
	Q4m93afAykUFlCUObDvONIGRdxaS7llIumchdC9gZF7FKJKZV5abmJljqlecnVGZl1mhl5yf
	u4kRGOnLav9M3MH45bL7IUYBDkYlHt4Nf1QzhVgTy4orcw8xSnAwK4nwru1TyRTiTUmsrEot
	yo8vKs1JLT7EKM3BoiTO6xWemiAkkJ5YkpqdmlqQWgSTZeLglGpglHmvcp7v7va8Im0jT6fi
	fzqmWr1G76aqpH19uumk0UeG3W7bj82wleDwTLyu8La3cH6hd4jFjZJDr/xvr5BdHNTam7I/
	OiytNUrza3CWaWV0drjy4ozptU9jT8T8MyqNzFtaPN1W98R87TL1zw+uRy+x779T/vVSktKG
	E/sjJF3Mc7dc8ApUYinOSDTUYi4qTgQAqP+FDPACAAA=
X-CFilter-Loop: Reflected

On Mon, Nov 24, 2025 at 06:47:29PM -0800, Jakub Kicinski wrote:
> On Fri, 21 Nov 2025 13:00:46 +0900 Byungchul Park wrote:
> > Convert all the legacy code directly accessing the pp fields in net_iov
> > to access them through @desc in net_iov.
> 
> Please repost just this patch. The last one needs to come after the
> merge window, when io-uring and net core changes converge in one tree.

Sure, I will.  Thanks.

	Byungchul
> --
> pw-bot: cr

