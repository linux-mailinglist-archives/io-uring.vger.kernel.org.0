Return-Path: <io-uring+bounces-501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97EF6841FE0
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 10:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 554592934E2
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 09:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A20AA6773A;
	Tue, 30 Jan 2024 09:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k89W3fNu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770A6604C5;
	Tue, 30 Jan 2024 09:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706607619; cv=none; b=LdzQMAu1jgSK+kHEnH5ZRksSIX9nm9vtjcE5h5NyAAFlya2TfdSuSL4eW/vHQa6odukAUut+vTMs+Eq6kUMJDQoEJ6ElvzQexbPb7at25ROPPmyqAqkZnIMasai4NuodkASIg4LSNhH6HtTNkKDAtVrgFeWrerNvaHxw9oJkdpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706607619; c=relaxed/simple;
	bh=xUaZx4N1QE80irAt1NX8WXJz2OwOYqPlUd6lRcye/iQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ieNJWWHd8UgAPjQR9jA/1KAi8Hd4rYA6TPrdeYZUatg6IP3x0ZvtRf/RCG6/781oNeolGpZZ+9DayWr1KJMj8y5jKmPoy4Oi/qkyA3LowXea9C5v3j0O1M4yXoCgpihg9q/ZEYg3hBrmF4EHoWaeDLvMHBBZw+ZnNBlXhTcZFuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k89W3fNu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AADFC433F1;
	Tue, 30 Jan 2024 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706607618;
	bh=xUaZx4N1QE80irAt1NX8WXJz2OwOYqPlUd6lRcye/iQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k89W3fNu1+8v1LGnmWRj7Vw1PA7slHL37vdWX8L+PKn4lqSX8eEuzqdxdsVI7Lr0l
	 y0oMN4+NHLwoeHKNGXKJNe0IgTmivKediiL0rZdJexRfrHdR+A6mTsU+etVb0gmwLg
	 eA5354wundGuhve3m2ceG8GFw1oW3a2/BUnMKtMWHEuFiL0KrhGtRnHMrELFPmbfyI
	 B+6+vKgLuw2aPGO0xCAgylrIBbcg2E1mn65rxG3bhhC8sJ4gps/Be2+zv98U1HDKzS
	 gzJW5oxQKmhU/kRAzrNvTeL8coccx8LkYGkuEEPqzIfgFGXCS5NEmQw0brTIMwpUux
	 MtfZZL//+U6Wg==
Date: Tue, 30 Jan 2024 10:40:13 +0100
From: Christian Brauner <brauner@kernel.org>
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring: use file_mnt_idmap helper
Message-ID: <20240130-bergbahn-lehrling-9094b2794711@brauner>
References: <20240129180024.219766-1-aleksandr.mikhalitsyn@canonical.com>
 <20240129180024.219766-2-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240129180024.219766-2-aleksandr.mikhalitsyn@canonical.com>

On Mon, Jan 29, 2024 at 07:00:24PM +0100, Alexander Mikhalitsyn wrote:
> Let's use file_mnt_idmap() as we do that across the tree.
> 
> No functional impact.
> 
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: <io-uring@vger.kernel.org>
> Cc: <linux-fsdevel@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

