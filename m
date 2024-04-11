Return-Path: <io-uring+bounces-1511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C118A1C9A
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 19:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D61751C20F7D
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 17:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDF4824AD;
	Thu, 11 Apr 2024 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tyhicks.com header.i=@tyhicks.com header.b="LFrnW+gV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QjszwsZV"
X-Original-To: io-uring@vger.kernel.org
Received: from flow3-smtp.messagingengine.com (flow3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC183D547;
	Thu, 11 Apr 2024 16:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712852967; cv=none; b=A55tMoPpAQo7vmNMoj9PHZVivSIHyVldwlNSnnkcl9BG3F7JL5W6b8CrdwD76ZRGdOVVilZ4GFmHGHvNyrheZ65ZYsvHjQtvtUEde7XDXoTuPgAs4fPv+y9n8OGCTBHxwWNnrsPlya4KUYCDDYRdM1N3ntoEWvSb9nmDC5BLfTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712852967; c=relaxed/simple;
	bh=nG9AvDiE9iyn3GD+qkFmmatVAFhuimsNOSJez9ntW2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwwrynCnC+ifeyEMvSA5owY4P6X8wT5+JyrNTXLsVl1jcpRozvlfzJJ4sqz/60iQh2M5pOSb+aFIj8kkzrcJBHvNUBDrh6bnQvIIa875/fijsMQHv+X0JRrRWJsDUPRXnDtjvXBoowJlBVaUtxde/SdWg4cyrKbf8QcBwFN9Mno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tyhicks.com; spf=pass smtp.mailfrom=tyhicks.com; dkim=pass (2048-bit key) header.d=tyhicks.com header.i=@tyhicks.com header.b=LFrnW+gV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QjszwsZV; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tyhicks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tyhicks.com
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailflow.nyi.internal (Postfix) with ESMTP id 9DA22200367;
	Thu, 11 Apr 2024 12:29:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 11 Apr 2024 12:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1712852964; x=1712860164; bh=gqLmiSCFDE
	hztj3oo+M3RvxGGuNWOcopRWr00SfiOXg=; b=LFrnW+gVLOjXO932zV8JFLHcU4
	Z11oxiPjXEeIoTv+hRBxeNFBSHFRORV89RE+hDz8o/FNQfb0ZylM3LlaV7SfIbIh
	Addzl5MtYd6DCOKuuPjLWJpx7oS4vGZa3oYfHS1M59LR0YuAs7ja3h2OT7vsqFfY
	5lefW/nwLq1Gjc8RK3AO2aQKwckfEkr+nH8s5ZalQfAl92JZTgbm+Wg914c2UB5m
	eNqrL2vxBMmvDGIaiYP6BCPQg3oUbh782W0RrfBe4O6nE4nSNjLpbLzpSB9hnFID
	pXfng5Et+lGDZHZhWOFMibGKmgT0m+diqRUIayMGR5+j1SDWiOhyO1XbxcyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1712852964; x=1712860164; bh=gqLmiSCFDEhztj3oo+M3RvxGGuNW
	OcopRWr00SfiOXg=; b=QjszwsZVkv7GUJ0uc0dhoDjZrwffXdSQOTPWHmT4H3mj
	sdeyyErO2JxiM/ZM7lw+G2Xjk+V8dzc0F0tFHdo6JHONeBT/ha7tRiMO+nyluWht
	sCLk0CteXP+F0ciqwnwyEzKIhl9lFKOQejgIyx3d0knunefs6jkNYVEfPy6BfWky
	My4ZuOyf7c/xkIXD1YnRECJRudPOX5hGDB9SeyTh2Mi6k0tMbZfTJvdXYfILZCyY
	TMycg/iXXwbTaWErbdzYedwL/odNoQ4I/lF28UcD3TuK+QiDKYMU7xoQyKetNMnM
	xrjf9RbU15ha6PRU4peAkTbO7efhDWd6dUDQ8SlhlA==
X-ME-Sender: <xms:5A8YZul7kXoS-E9HTR43PZEfsjxiUGr6s04HTzfT7XGJQqRPvj-YWQ>
    <xme:5A8YZl00B3abTQ5vNWSDYehm_cfFWxdUj6XlCR_XJIzyPSm5bvgogBrpmjNhj3AbY
    YVU8tpnsP6EPyEyqaY>
X-ME-Received: <xmr:5A8YZsoxOZ0l_g7S6OVUqYg1WXYzf7dlDHutUKObDutlAEQVsPctVQbFuHs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudehkedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefvhihl
    vghrucfjihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtth
    gvrhhnpedvhedvtddthfefhfdtgfelheefgefgudejueevkeduveekvdegjedttdefgfel
    ieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegtoh
    guvgesthihhhhitghkshdrtghomh
X-ME-Proxy: <xmx:5A8YZikbMasM7VZgHvtObLV2P9GFgJ0r470-Kc7fgEo774Qvf2Oj3g>
    <xmx:5A8YZs0qX9ZGWE_5YIJqL-CXhvqo1qiTvKUehekqralf-0nAJJfbMQ>
    <xmx:5A8YZpsD3ILS-9-fb0yu84z7H8q2JBo_xGPFRaXTzSzJxv8tekgNbA>
    <xmx:5A8YZoVcbJKojpd_wm4DCcLSdUivGbr5St9mLlhRB_29tXjO_qgkvA>
    <xmx:5A8YZt4seqo2FXF3xVRK1SddDyq4KetKDKrVv1LOiQ97qa59hBpsDkJP>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Apr 2024 12:29:22 -0400 (EDT)
Date: Thu, 11 Apr 2024 11:29:19 -0500
From: Tyler Hicks <code@tyhicks.com>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
	speakup@linux-speakup.org, intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-afs@lists.infradead.org, ecryptfs@vger.kernel.org,
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org, linux-arch@vger.kernel.org,
	io-uring@vger.kernel.org, cocci@inria.fr,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] treewide: Fix common grammar mistake "the the"
Message-ID: <ZhgPuPVYT26SxgQW@sequoia>
References: <20240411150437.496153-4-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411150437.496153-4-thorsten.blum@toblux.com>

On 2024-04-11 17:04:40, Thorsten Blum wrote:
> Use `find . -type f -exec sed -i 's/\<the the\>/the/g' {} +` to find all
> occurrences of "the the" and replace them with a single "the".
> 
> Changes only comments and documentation - no code changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>

Reviewed-by: Tyler Hicks <code@tyhicks.com>

Tyler

