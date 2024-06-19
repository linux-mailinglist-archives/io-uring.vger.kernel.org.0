Return-Path: <io-uring+bounces-2261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0256390E0FB
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 02:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 973D41F234F8
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 00:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01651878;
	Wed, 19 Jun 2024 00:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npdLNms9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C611917F6;
	Wed, 19 Jun 2024 00:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718758194; cv=none; b=DmLVue3vOE7HB6RCxvm7FEP2qnw6Ssl+BXGBUDgmbhpR9eSXFNCaMKXvE7j+RT7zElechG8kE1x4ESPkHOhW6FKZzk40bJZjDfVrLIet7DXJrUt53CVYmo35AcUy3Lw0JHXWpvVsPHHlfWoPIlZtSGlf7hgleb9x2yztt03wDL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718758194; c=relaxed/simple;
	bh=ewjF1UA9byt8xESNKoRYIelC1HoMzSMlvB5N2WYnojc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKdcvwri0Tce1oqLDJaX58tiljesMx7Tz9ObL3A5tEOGruXxFyRK6UOog/jrTwkDkX6LjTwJpNBVxfwOjc29MNXUc+du6o+ptvuvyL/2yUKLvJjBis67gy1x3mMzNbm3jYYecaIOrH3uecZ2SLocJXqP5TayjUeLVrHLAfxAlRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npdLNms9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A0CC3277B;
	Wed, 19 Jun 2024 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718758194;
	bh=ewjF1UA9byt8xESNKoRYIelC1HoMzSMlvB5N2WYnojc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=npdLNms94omxqc+a5JLYM8md27R/oOfkWYfl9rvzl67k5raqm6nvJ6bAcAT0rRRes
	 /hf9RLOsGgDaRJLyhn5t+PRehB75y1N4VuiikVymB2+12wlYYrXb0ilbs81g2B0N9h
	 8e/epxrlUfag778ns1UAVXWnXbj/7XEqWHFTI3rC6bmkZIiim1nlyT17gaoPZUxSHe
	 eF/WleaLiOo8FcEn8TtLndABGYeM5U1Nv0KMICgb4s3/AOPP/+05oYTXRb73QICffO
	 eP3YcCdMPIWya3l4+7Wz7jfjGfCMBXnxoN8IdwULaBeceQw/bE0glanW48/cz9Jokx
	 6igv8G3/YXclg==
Date: Tue, 18 Jun 2024 17:49:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
Message-ID: <20240618174953.5efda404@kernel.org>
In-Reply-To: <20240614163047.31581-1-krisman@suse.de>
References: <20240614163047.31581-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Jun 2024 12:30:44 -0400 Gabriel Krisman Bertazi wrote:
> io_uring holds a reference to the file and maintains a
> sockaddr_storage address.  Similarly to what was done to
> __sys_connect_file, split an internal helper for __sys_bind in
> preparation to supporting an io_uring bind command.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Acked-by: Jakub Kicinski <kuba@kernel.org>

