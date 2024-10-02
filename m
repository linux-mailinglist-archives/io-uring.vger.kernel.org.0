Return-Path: <io-uring+bounces-3369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF8698CCDE
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 08:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29E651C2184E
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 06:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E848178C75;
	Wed,  2 Oct 2024 06:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3KZcVUs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FA328F4;
	Wed,  2 Oct 2024 06:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848902; cv=none; b=duXRVGJOktVR6K+GszjTX0x97yXvGtsR1ghUKVSXStIzwSCEUOrWbZpQlOY+z0PwOaxwtGy3ujehZhUdDyugS+ptmR5m30YZEYCYZmIP5mw5ylV9RRM8ksmzICBfk4vyX9hAhndt4ge5qxr56c0fSW8E4Gd6xrsoXrpxeYsuNFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848902; c=relaxed/simple;
	bh=lfGnxmR6N27fYnVgga0eiMD7nUKiqGD8ipkG3wJKnGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sofx3Z2ZI6shEKKFxKzIoNOT0jroQJHUM90St/F/ZQQiTCh7LpmBrjeERLcUuiAuPDN/b/P1XRmnmmwgYO628m8xI2NiTkP9WL06IsONvWew8TFLWf76qCMwj5nAo00qn/d3UzoZp+izfE9yw7MbRs124w6W5FeOZQhhDE2tczk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3KZcVUs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C50DC4CEC5;
	Wed,  2 Oct 2024 06:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727848902;
	bh=lfGnxmR6N27fYnVgga0eiMD7nUKiqGD8ipkG3wJKnGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b3KZcVUsF2NSVZ3QYNlO4oXxPv4lzW9yWexwHLwuBY8MgM2K0upJUKz/Nstg7B3Vh
	 TwURTxsNFV7gyQnJyyao5wp1Dqj4Wp+XSiCX3w64aeJvvSzNvZGYfyRtAVzDdOuWrL
	 eS12nX9DNXlfrMzPTxHcP8DvWfO4RhA2GVN+iEO0UsXEy+YKOtxadqIVx9T3BkkfrV
	 hFXHjgcaluCTVTlHEHKS/+cK4hARgFXXmwAqTGxoI02Uuu4YANpIj7vfHo6iuP6N1J
	 2onIX8lb+7HGN3qY2SHc5W4lMaFFk6HadOSVPAY84fqMBwCYrRBSpoUd1f/e13Mue4
	 YzHgcnTJ2QcDg==
Date: Wed, 2 Oct 2024 08:01:39 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	cgzones@googlemail.com
Subject: Re: [PATCH 8/9] new helpers: file_removexattr(),
 filename_removexattr()
Message-ID: <20241002-gehackt-neugliederung-9acde4d513d5@brauner>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-8-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241002012230.4174585-8-viro@zeniv.linux.org.uk>

On Wed, Oct 02, 2024 at 02:22:29AM GMT, Al Viro wrote:
> switch path_removexattrat() and fremovexattr(2) to those
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

