Return-Path: <io-uring+bounces-1916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5728C89F5
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 18:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38FAE282897
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 16:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92CD312FB2C;
	Fri, 17 May 2024 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8J6rGhR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0225D3D9E;
	Fri, 17 May 2024 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715962994; cv=none; b=JbzhVl9QqOrGn5aI3Lp2QNl3nFNFVGz2U9XaYDDV5FovgM5gKKZAXRXy1/SmO9pdi7wgxYf4Ybf2RQI7LH29HkUaLiMIMdWi2pliMj4nIRJ4+c9q0QjMzoq0sWfXOJpcHg7fErYP1NBGlj//ZNX4xSSk6r7glY0UKNAc0GOIo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715962994; c=relaxed/simple;
	bh=uNwlZVn0k6bBYrUn2NOTbtyZjAe9hAwPUWGNLiaSzKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlIAnJvXoclx91HzV3KHgMAmzFsWWX7APIuqQKg6D8rdDfiO2lBWN8hNUnta8MkPvLMjbRrCzno9d+ey7uKWaxOu5yWMAIKuIS4yXd50yO6+ba4Jn3R+4XC21rSS0pTUnL9jV4xzW+y5gexohMQGsr+7nf1x4bn2gL2/M+fleQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8J6rGhR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70342C2BD10;
	Fri, 17 May 2024 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715962993;
	bh=uNwlZVn0k6bBYrUn2NOTbtyZjAe9hAwPUWGNLiaSzKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F8J6rGhR6abMw+H3e0sNsBE3c0HR9drUMq7zelYKMTQHa0vv/MIG2W8+/hD/7XTI+
	 9VkRoCKMyZzVY3LjQAv7zTKPKrfWjp+PaYpWL+HZIXKwJ9PpfHkWCOm8/AnprKJTiS
	 x71fH3FEiRuBcJ7Snaffb4mCRWAYWAV32gCoEeO44TUBKDap7ZLHPJJXjD0QMTmCNO
	 ZUj+MK/eDva4zMj4VegTwZ0y/H/lyuO2Nk/KqN8YnLbubwD8YFqugReL9OgeiAJUxc
	 u0pTJlCPPo4/7T1+KTMYWfO14b9TwwHb+K7KeD4YmO6RNA3DpP+PsNxwbeXmOHuVhd
	 +qE7xoo2PLRTA==
Date: Fri, 17 May 2024 09:23:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linux trace kernel <linux-trace-kernel@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org, linux-pm@vger.kernel.org,
	iommu@lists.linux.dev, linux-tegra@vger.kernel.org,
	netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org, ath12k@lists.infradead.org,
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
	linux-usb@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-cifs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-edac@vger.kernel.org, selinux@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-hwmon@vger.kernel.org,
	io-uring@vger.kernel.org, linux-sound@vger.kernel.org,
	bpf@vger.kernel.org, linux-wpan@vger.kernel.org,
	dev@openvswitch.org, linux-s390@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net,
	Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <20240517162312.GZ360919@frogsfrogsfrogs>
References: <20240516133454.681ba6a0@rorschach.local.home>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516133454.681ba6a0@rorschach.local.home>

On Thu, May 16, 2024 at 01:34:54PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> [
>    This is a treewide change. I will likely re-create this patch again in
>    the second week of the merge window of v6.10 and submit it then. Hoping
>    to keep the conflicts that it will cause to a minimum.
> ]
> 
> With the rework of how the __string() handles dynamic strings where it
> saves off the source string in field in the helper structure[1], the
> assignment of that value to the trace event field is stored in the helper
> value and does not need to be passed in again.
> 
> This means that with:
> 
>   __string(field, mystring)
> 
> Which use to be assigned with __assign_str(field, mystring), no longer
> needs the second parameter and it is unused. With this, __assign_str()
> will now only get a single parameter.
> 
> There's over 700 users of __assign_str() and because coccinelle does not
> handle the TRACE_EVENT() macro I ended up using the following sed script:
> 
>   git grep -l __assign_str | while read a ; do
>       sed -e 's/\(__assign_str([^,]*[^ ,]\) *,[^;]*/\1)/' $a > /tmp/test-file;
>       mv /tmp/test-file $a;
>   done
> 
> I then searched for __assign_str() that did not end with ';' as those
> were multi line assignments that the sed script above would fail to catch.
> 
> Note, the same updates will need to be done for:
> 
>   __assign_str_len()
>   __assign_rel_str()
>   __assign_rel_str_len()
> 
> I tested this with both an allmodconfig and an allyesconfig (build only for both).
> 
> [1] https://lore.kernel.org/linux-trace-kernel/20240222211442.634192653@goodmis.org/
> 
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Julia Lawall <Julia.Lawall@inria.fr>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

/me finds this pretty magical, but such is the way of macros.
Thanks for being much smarter about them than me. :)

Acked-by: Darrick J. Wong <djwong@kernel.org>	# xfs

--D

