Return-Path: <io-uring+bounces-6753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4F0A4460A
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:28:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E607B1643E7
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD5E18DB19;
	Tue, 25 Feb 2025 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwWZ6Yb2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740A518C32C;
	Tue, 25 Feb 2025 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740500866; cv=none; b=tXRTVW6lW9Bj5xfXq+r+Jymg8UkdA6qD60Bc/CB1TM4gP+X9xRBySiFhCpRHiyLg+nHEIe4Q1gDJ3Dvl3ELqgtHIo1k2dMNQbMPf34+lBXdn+PppahpBIUgUsQTFjI5gWhZTg2qJva1eMSH0n140mVAu2vmrM9Of48DtbTRXgS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740500866; c=relaxed/simple;
	bh=v2tyS75rJCPLEHjAX+wdXSorQ28Vgd6RsK8pCbcntX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YrlUTxnoCKDP1tvZCUUcaLMp19NCDnoYTZLYSydQbY/4Oy09bmo6vd+ubmB3unouFwi6cQG5tWJP4Typ7+aLyfeaHHF1n34aj5wn+8jZ0JQXYNmI5o46JNIOboPRmFvh4pNAGdu3djxnybdfuZi4Jbnv/XO82q0vALjaNAJnGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwWZ6Yb2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DE6C4CEE6;
	Tue, 25 Feb 2025 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740500865;
	bh=v2tyS75rJCPLEHjAX+wdXSorQ28Vgd6RsK8pCbcntX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YwWZ6Yb27R2qLSBlkX+Z4ajy2K1QLDPf0GzaF8UwYM+U+2aCA+q7EuiZrP774IQjT
	 Upt99111ODggrin0ANhCSTrEl9A2q4MtfyFcuTJMRn/hqpxAe6BeeqWFPmTHBm/jwx
	 cEEy/Qy1r548dgNxwXOs1Rx3g28nE3s1PWD9ocJZgq5sjlRmkxVw76h5rb6AooYUrF
	 c9CqymZFtuC3+c/lEzdXGUvqkTnfdoL1yf9l6zrA8VLURByqcsYfwa5dEjN41579l8
	 K0b7yyojRNgfqNZuF3/EtN3dxVLOybLqeIq6gvuPqFDVb8KT+GcO0gV/iRBNYxG0uI
	 kUnQIxEd6XeWw==
Date: Tue, 25 Feb 2025 09:27:43 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z73vfy0wlCxwf4hp@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <90747c18-01ae-4995-9505-0bd29b7f17ab@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90747c18-01ae-4995-9505-0bd29b7f17ab@gmail.com>

On Tue, Feb 25, 2025 at 04:19:37PM +0000, Pavel Begunkov wrote:
> On 2/24/25 21:31, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Provide new operations for the user to request mapping an active request
> > to an io uring instance's buf_table. The user has to provide the index
> > it wants to install the buffer.
> 
> Do we ever fail requests here? I don't see any result propagation.
> E.g. what if the ublk server fail, either being killed or just an
> io_uring request using the buffer failed? Looking at
> __ublk_complete_rq(), shouldn't someone set struct ublk_io::res?

If the ublk server is killed, the ublk driver timeout handler will abort
all incomplete requests.

If a backend request using this buffer fails, for example -EFAULT, then
the ublk server notifies the ublk driver frontend with that status in a
COMMIT_AND_FETCH command, and the ublk driver completes that frontend
request with an appropriate error status.

