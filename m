Return-Path: <io-uring+bounces-3366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF0198CCBA
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 07:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EE661F226F1
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 05:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185D280038;
	Wed,  2 Oct 2024 05:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mS/TjsTy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18E27DA9C;
	Wed,  2 Oct 2024 05:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848681; cv=none; b=KNPi8fVBSi1eVolY3btugCUrxaIbtLc+X5xphQRPv5bO57nqJ6i6L09UBe118coe0uWB3BDwIWeqly0IK2tdx78Q1U40nbhgu/nTyzP3PWhwB263yQSw1UXUrIz0NStz4EardVDne4uzGMGThpKtbSdcJeIDKWTA5eULAUHYLMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848681; c=relaxed/simple;
	bh=l4EDxmEomTNIqEgzbteB4jyT954jnWCtPJjTQ+IgPkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LriC+10IvP4aeEBwqWyeCZmAxk1+oAPYAtYfVVkccihWRlmQBcyOrVEGxsl3q/3n3pr9URTHX2K+w+DZohPF4IP7c/xQK7ATGunvpUjFaltrWf8Lb5QLAww6t/NzeL3fULNVRP6kVhH5Q2EHv3tgxWDb2CF9HPM/qnpNDHykqRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mS/TjsTy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49080C4CEC5;
	Wed,  2 Oct 2024 05:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727848680;
	bh=l4EDxmEomTNIqEgzbteB4jyT954jnWCtPJjTQ+IgPkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mS/TjsTywOvOndqJ6JovmJyYOR8cCSM7DEB0l3NWSBiNvs0IGRBDvzq0oRkpEVtzB
	 DCMCnMREpG/IBYoifI632VUIkfidLtao4zg7N50ELOV07+LUa2BfjPhL/LbFbTu7jv
	 IBgIQpKXhl97RRc1N+ylnyBfZr+9opnxiRh4dmiUBhrSHTfAfi5/2/lTkYGIegjPX1
	 5Tqk0TJC1W0PH43tMWO62sJkwwNlxhopqjO3dnlCEmki9CpeyUHJ6hExl5FjV+9nuN
	 z62F7TTNV2EkcCRuvurEhbXW3Dj/DqhK9WwEweGqY7OnwcR354JDzsz9lA46NLgnqF
	 T6VL1IMq8nsnw==
Date: Wed, 2 Oct 2024 07:57:56 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	cgzones@googlemail.com
Subject: Re: [PATCH 4/9] new helper: import_xattr_name()
Message-ID: <20241002-abtun-filialen-1f377f997a4c@brauner>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-4-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241002012230.4174585-4-viro@zeniv.linux.org.uk>

On Wed, Oct 02, 2024 at 02:22:25AM GMT, Al Viro wrote:
> common logics for marshalling xattr names.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

