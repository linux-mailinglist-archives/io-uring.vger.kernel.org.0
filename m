Return-Path: <io-uring+bounces-686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3828861DFE
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 21:47:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 593391F20F88
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 20:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B2114CAA4;
	Fri, 23 Feb 2024 20:43:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C27EAD2;
	Fri, 23 Feb 2024 20:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708721026; cv=none; b=f/Wx12iSHfpF7xf7NqVy2JgaNi+1zMpqr74k9EAiQTvTG90cOikuv1K9QrFHVTkyIJmjYffky1mvG0CUJfF6mhSMsYbJlduk0w3zTvdAPSh2XM27CHGGBDyr5Ge+Q06YeH86zVWiAUNktCug5SZh+reGq0AkFHyxDodnovurm4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708721026; c=relaxed/simple;
	bh=PvtLspH93t1y4HSID2+UQ++sl1bnWl4rFM9++eE9Kiw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjkj4An0NsVm9VFkk6dIH9AjZE1Eek+qJgxBeFZ5ctXoJvzPfS8XnInFF7aqDkSuPWQGn0frWL6Snv6tyi6Sj8RWOAXiWPXSwrq3dyoI/zvfcv4o9TmF2DdbRO7CQrnaEzovU79DIoqZCMd0gXOIMq2/kurKenWiqSZqyAS/iZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DE0C43390;
	Fri, 23 Feb 2024 20:43:39 +0000 (UTC)
Date: Fri, 23 Feb 2024 15:45:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <amd-gfx@lists.freedesktop.org>, <intel-gfx@lists.freedesktop.org>,
 <intel-xe@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
 <freedreno@lists.freedesktop.org>, <virtualization@lists.linux.dev>,
 <linux-rdma@vger.kernel.org>, <linux-pm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
 <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
 <ath11k@lists.infradead.org>, <ath12k@lists.infradead.org>,
 <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>,
 <linux-usb@vger.kernel.org>, <linux-bcachefs@vger.kernel.org>,
 <linux-nfs@vger.kernel.org>, <ocfs2-devel@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-edac@vger.kernel.org>, <selinux@vger.kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-hwmon@vger.kernel.org>,
 <io-uring@vger.kernel.org>, <linux-sound@vger.kernel.org>,
 <bpf@vger.kernel.org>, <linux-wpan@vger.kernel.org>, <dev@openvswitch.org>,
 <linux-s390@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
 Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [FYI][PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <20240223154532.76475d82@gandalf.local.home>
In-Reply-To: <20240223134653.524a5c9e@gandalf.local.home>
References: <20240223125634.2888c973@gandalf.local.home>
	<0aed6cf2-17ae-45aa-b7ff-03da932ea4e0@quicinc.com>
	<20240223134653.524a5c9e@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Feb 2024 13:46:53 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Now one thing I could do is to not remove the parameter, but just add:
> 
> 	WARN_ON_ONCE((src) != __data_offsets->item##_ptr_);
> 
> in the __assign_str() macro to make sure that it's still the same that is
> assigned. But I'm not sure how useful that is, and still causes burden to
> have it. I never really liked the passing of the string in two places to
> begin with.

Hmm, maybe I'll just add this patch for 6.9 and then in 6.10 do the
parameter removal.

-- Steve

diff --git a/include/trace/stages/stage6_event_callback.h b/include/trace/stages/stage6_event_callback.h
index 0c0f50bcdc56..7372e2c2a0c4 100644
--- a/include/trace/stages/stage6_event_callback.h
+++ b/include/trace/stages/stage6_event_callback.h
@@ -35,6 +35,7 @@ #define __assign_str(dst, src)
 	do {								\
 		char *__str__ = __get_str(dst);				\
 		int __len__ = __get_dynamic_array_len(dst) - 1;		\
+		WARN_ON_ONCE((src) != __data_offsets.dst##_ptr_); 	\
 		memcpy(__str__, __data_offsets.dst##_ptr_ ? :		\
 		       EVENT_NULL_STR, __len__);			\
 		__str__[__len__] = '\0';				\

