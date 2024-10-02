Return-Path: <io-uring+bounces-3363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5574098CCAD
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 07:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98099282E40
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 05:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066C880038;
	Wed,  2 Oct 2024 05:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmMpMqYJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FE07DA9C;
	Wed,  2 Oct 2024 05:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848568; cv=none; b=mua7ieaBWYkNeIyvwKFsIo4H9nya+smopzz68lcJWj1yXidTLcIqhbhhKdenH+fbfKMOBWWIBmx2zRNKF0QlU70Q0t7nbYp8pJBN6pxvsH7CZpYqCE55H7cmAc7pNkkKsC5hMmNZ7pLM1BL7Czbt0YCGsp98S90JdSiMJIlSfKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848568; c=relaxed/simple;
	bh=XUX4OBfr6Eq3jRSSojwq+QgdiYRvla06RsocKrAygKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4JFm6wJcy+k3eUDZErjQ1KWGSTVwsa3/pjz9eufriSP74dSuJH5WORL3xUKtwfCy/zn9wAS0mNO9NO2MZulevmqcZ53olWG7N0y9ACyjXQ179VRfbzycVB4/DEzpGwIavLxq4Ek3gSUu2AzZ73V+eYFObqmdeDHEfF7u9bwnuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmMpMqYJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBDDC4CEC5;
	Wed,  2 Oct 2024 05:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727848568;
	bh=XUX4OBfr6Eq3jRSSojwq+QgdiYRvla06RsocKrAygKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HmMpMqYJIeNhmW4qP0Hb2vrEEDw/lkmhjpzBbVmCPlGuLQwfBBq5EF5GWcshRJmR3
	 4XP48LO+7UlKAQIkv76YLCFFEeRA1+ovLNBJ1+fTdNb407rYVLzkToaFTjW5OcL53a
	 9wXaqaSduyhy5tEIL1uWqKlRphXrOlq3cqWFJGgytleIF20G/q+d3B/GFbOgBNRIqp
	 APdt8veizVLwB5UNsn0frw+bpuxXyrcG+9lYAB9e2ehHEYHjows4izbERwNyvEN+th
	 AScq7LKQ7hLtyN9IBS9dJeVsrUyPhmuk2GpWek3CNJH9/4gAhfqOjWUVXsh9JFuMQk
	 neYwj1TK0Q/uQ==
Date: Wed, 2 Oct 2024 07:56:04 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	cgzones@googlemail.com
Subject: Re: [PATCH 1/9] xattr: switch to CLASS(fd)
Message-ID: <20241002-erhielten-kronzeuge-08f761e7ed53@brauner>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>

On Wed, Oct 02, 2024 at 02:22:22AM GMT, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

