Return-Path: <io-uring+bounces-3738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA42B9A112E
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9005E1F26015
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B2C212F0B;
	Wed, 16 Oct 2024 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZ1dy0Jg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC45914A09E;
	Wed, 16 Oct 2024 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101849; cv=none; b=HbDedVBNlEDLrXtda8RbPj6Qtvw7+DqybHbkRI3W2xjZ4w6+bxV+nU+LM/PDyylTUqQV7bvHo7yjCj7hiMMNi+sMlkXB14fBiKc92s5XfknwwZbES9LqiqoijNBEnLBHtkiu6Kd99IlNCxK8s64YDWOqtpLrq2Lq1X8lKFXtk6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101849; c=relaxed/simple;
	bh=HzzmijPoH2mtXPKps8Y0il4uE+cACVfKq2wS0Ezsuf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfotoAr7DppuanbprAHbbB3GbD8bbp5KS2/WmZfsrBiGeB6QRxW617h+Z3kXxb0Ju6daDjLZV1VjXidyrehKass47aeNUCH8+F8UNkM0/9IlIH6Vt7WMheqks5gswrACDVpWELwwbpiWwRQQjf4D6P1zjxMAhrSsMV1DEEmkL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZ1dy0Jg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E3AC4CEC5;
	Wed, 16 Oct 2024 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729101849;
	bh=HzzmijPoH2mtXPKps8Y0il4uE+cACVfKq2wS0Ezsuf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kZ1dy0JgHxNeobOvzLSy5ftVhhY1QSE3SF3ksFod3MtCVn2w3jJzGNtgWDjYWUP5L
	 LvZBXl7bnuTnvtj7JgjPfD2ftk1YDHfC4QINDHlz+TLaC4tFJEBWbTIVvbWtDQz1jK
	 7bxdu4l9KFVnMpNVOVhSHW6M7tTWmdVCq0G0kKhNiCGdu/3ZElIS38qMslcr0extm8
	 hP/tHOAO5HoFPYYE+anpFHY79BTyBqQCcUle5fVGiJKHsG5bxMvRzrKsOhMEg+ltgx
	 QT6ZFR6nzZgEkfh0Qvz95GV6x7+0iooI3XkebrslYZAgVrEvFppGgCIlF/g2XWnMG5
	 QYOdwszwvc0WA==
Date: Wed, 16 Oct 2024 12:04:06 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 02/11] block: copy back bounce buffer to user-space
 correctly in case of split
Message-ID: <ZxAAFnC_Y6qpU-UK@kbusch-mbp.dhcp.thefacebook.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
 <CGME20241016113736epcas5p3a03665bf0674e68a8f95bbd5f3607357@epcas5p3.samsung.com>
 <20241016112912.63542-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-3-anuj20.g@samsung.com>

On Wed, Oct 16, 2024 at 04:59:03PM +0530, Anuj Gupta wrote:
> Copy back the bounce buffer to user-space in entirety when the parent
> bio completes.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

