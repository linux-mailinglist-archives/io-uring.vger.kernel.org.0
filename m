Return-Path: <io-uring+bounces-680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB0E861B18
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 19:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 244E61F24B99
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 18:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10C5143C40;
	Fri, 23 Feb 2024 18:05:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FA414263E;
	Fri, 23 Feb 2024 18:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708711506; cv=none; b=dqsRPXUhBgflnNQnAJg8h2CQcKaCCgoGoTAKoQs48//AYlFjz7Qs2O+6lhHNnhCBYxuyThH4Hq5hr8rcInzvTo0BpWeiK1uii8wIKsYJ0OaI16TSkUpibTSFXVv2r3hKW5mhUMIuLnkB52NWyI9eE3yR25DZXiLP3NqqFin1TxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708711506; c=relaxed/simple;
	bh=LnhjvqUeq0CK0kIwGNY2StqDTPb27nbR7qd6jVWv0QA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMSzBA10+2Z3T90xbs5EiUSeTqNg7jmyGmiZQOxZXuOFM1nATIvRraeF0YyclHdUwGpK8Ggz0K5mWr53bADO5hQ6lcWXK8E/ZBr/Z92x1oO9dVw+5KByebqUx5GQNBVnqbc3fBCHbRlfBDigxw9Ro+tFUroYHpKhqigrVFFAMPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370BEC433C7;
	Fri, 23 Feb 2024 18:05:01 +0000 (UTC)
Date: Fri, 23 Feb 2024 13:06:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-block@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
 linux-pm@vger.kernel.org, iommu@lists.linux.dev,
 linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, ath10k@lists.infradead.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-usb@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-edac@vger.kernel.org,
 selinux@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-hwmon@vger.kernel.org, io-uring@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-wpan@vger.kernel.org, dev@openvswitch.org,
 linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net, Julia
 Lawall <Julia.Lawall@inria.fr>
Subject: Re: [FYI][PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <20240223130653.2cc317a8@gandalf.local.home>
In-Reply-To: <20240223125634.2888c973@gandalf.local.home>
References: <20240223125634.2888c973@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Feb 2024 12:56:34 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Note, the same updates will need to be done for:
> 
>   __assign_str_len()
>   __assign_rel_str()
>   __assign_rel_str_len()

Correction: The below macros do not pass in their source to the entry
macros, so they will not need to be updated.

-- Steve

>   __assign_bitmask()
>   __assign_rel_bitmask()
>   __assign_cpumask()
>   __assign_rel_cpumask()


