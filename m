Return-Path: <io-uring+bounces-3812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCBE9A3BB4
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 12:36:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBA691C22E25
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 10:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D13D201242;
	Fri, 18 Oct 2024 10:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoVwh6nq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C923201101;
	Fri, 18 Oct 2024 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729247814; cv=none; b=hcTnZ94rfLPmS2IuE2I1udqvdemFuH9iHscCqJxPEp4otfz7cy9RFo/ueDiMZfwTcRl0mDqz2Ri5QPU98nEvPrwuMl6v5DYLeeVIEoRNErhY4apJNvBgXd9kT1Ka9DWwfO/MHSg39nSjRbrH+gRO40WI1+gd2fnXu0GRxrtMqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729247814; c=relaxed/simple;
	bh=kdEKBGd/o+LCP4VEZn2k137ecP+nMhkjpKlmx5BcJ/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r7lakmR7eCDfMojTiHvmseiDARVlcPEApgr5oiAUHiwxnF4WIoW7Q+B5lJd+v6OvkEc0rFN0zOOOsTWYM55NL2+E1Iq0yz6Vb792576oTCSFoMlhogSO4DzwSXBXSMCSfura3cMzWuCMzlE7QmqNs/xlrc+iXpZhr8bzzpns43Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoVwh6nq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6487FC4CEC3;
	Fri, 18 Oct 2024 10:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729247813;
	bh=kdEKBGd/o+LCP4VEZn2k137ecP+nMhkjpKlmx5BcJ/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hoVwh6nqYfX3J50k+DnUpaUfrwrRDhXQhELQQk1EQqjlhpj4euVCdRfwm9zzqJUKv
	 R3YVC7bmls3lv6CeVmSdrgo4nNJXjP1Grf5hG1rkfJzG+brfmXkF/tMP7oYMe/Fio0
	 TIlgm+9cGH0yuCwtKxcBuFVkgatka/ky/BVjw5E4=
Date: Fri, 18 Oct 2024 12:36:51 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 5.10 5.15 1/3] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Message-ID: <2024101844-preamble-triumph-ede6@gregkh>
References: <20241017115029.178246-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017115029.178246-1-felix.moessbauer@siemens.com>

On Thu, Oct 17, 2024 at 01:50:27PM +0200, Felix Moessbauer wrote:
> commit f011c9cf04c06f16b24f583d313d3c012e589e50 upstream.

All now queued up, thanks.

greg k-h

