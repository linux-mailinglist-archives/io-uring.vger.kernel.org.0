Return-Path: <io-uring+bounces-10253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A514C1223B
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 01:04:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 17BF64ED989
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 00:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4564BA937;
	Tue, 28 Oct 2025 00:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9yn1CEY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4AC4C6D;
	Tue, 28 Oct 2025 00:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761609803; cv=none; b=udbYonYMulz7j/k2UqdWD1a9Hmx416wjT91f8nJISfECHIhhj5bQhbems28/3uhgKmPjuw1Prl38+c1XGB7Lc0WfL9vhUemnhYpbWK4ixCiq/2IztvCYaK2gHUSvybi0JG2ICfDZx+v3XRYHuACaME5HD+EfInSIoooFKSGazx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761609803; c=relaxed/simple;
	bh=W6yp4rZxJEPAZgyXo3pUf8GslHOxy3GF6WmC6h31yp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0aC00XiL9Jmlp6SPQ700w6vUIzeYCU/biQDpdyaSm31xVWirPCC+QsyctW4dfdGst+82r7ol5R1iORzxnbnRTYuQvBBq6+MtuGjsOZhcIGSnfUeXVzqpfwrfiuEXQTmznf8017Sj73pm6qxa/MhjeH/T4h57Y4LAFwH8nnzOzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9yn1CEY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FA0C4CEF1;
	Tue, 28 Oct 2025 00:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761609801;
	bh=W6yp4rZxJEPAZgyXo3pUf8GslHOxy3GF6WmC6h31yp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l9yn1CEY+Jmv/oIqGEcspeB1ZZE13VDfTLfmZC9/oN80iJzAUUWmjuNOEokQCrPkK
	 yq7vAGkhMt50vxUCUhbgCGO4O9EIRCze8hr/7u9Arc6zUK1guf3uDmd2/P3txwRaK9
	 zadL0qbe5GJ9rsdwD8yG0N5AynMMGXSYAUxBKjkWA5y/RKNXwFDe9wV4jeZtPhcPwN
	 iCkYhgnPMg3GvyyCblHxz1FSF4a8zqXZ8qZ72F1k03xMbUTDjy69hBmXrymHapdibz
	 a4t8poW4VMNoXLJYbK03o3/vXiBQig7rvSbjIa3gTpj29qnfi6cXBBsZqHKP3YRYgb
	 SdQn4dnIzNHXA==
Date: Mon, 27 Oct 2025 18:03:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node
 (5)
Message-ID: <aQAIR9DQwiySzEj-@kbusch-mbp>
References: <68ffdf18.050a0220.3344a1.039e.GAE@google.com>
 <d0cd8a65-b565-4275-b87d-51d10e88069f@kernel.dk>
 <aP_48DOFFdm4kB7Q@kbusch-mbp>
 <e6fd5269-d6c0-4925-912a-7967313d991c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6fd5269-d6c0-4925-912a-7967313d991c@kernel.dk>

On Mon, Oct 27, 2025 at 05:15:56PM -0600, Jens Axboe wrote:
> >> leaves fdinfo open up to being broken. Before, we had:
> >>
> >> sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
> >>
> >> as a cap for the loop, now you just have:
> >>
> >> while (sq_head < sq_tail) {
> >>
> >> which seems like a bad idea. It's also missing an sq_head increment if
> >> we hit this condition:
> > 
> > This would have to mean the application did an invalid head ring-wrap,
> > right?
> 
> Right, it's a malicious use case. But you always have to be able to deal
> with those, it's not like broken hardware in that sense.
> 
> > Regardless, I messed up and the wrong thing will happen here in
> > that case as well as the one you mentioned.
> 
> Yep I think so too, was more interested in your opinion on the patch :-)

Yeah, patch looks good. I plowed through this thinking the mixed CQE
showed the way, but didn't appreciate the subtle differences on the
submission side.

