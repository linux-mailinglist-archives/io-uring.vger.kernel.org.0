Return-Path: <io-uring+bounces-1507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 070C18A1857
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 17:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1869CB25BA3
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 15:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900001427E;
	Thu, 11 Apr 2024 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R7pDm3GO"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0F13ADC;
	Thu, 11 Apr 2024 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712848399; cv=none; b=pEK4+7MVatbTy6goEo2CweqIiVtaOlXXMNiQ+i2/CzexVEIR3yUf8qvIMferVpHMirGpoIvZ0pKDYfnyK5BL+HJ+S39k5Fk6WSihKotk0UxuvYSw6D063b2ZA30d6UL8BIGLU2dEP58V2oIDsCxHR1e1knT5MQjEeQK0Wb6FJVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712848399; c=relaxed/simple;
	bh=pN56ayWZsVC8Qsmxepu8PbsNstNvWyI8do9fFIC3f0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tc1ykkZQuNnkHO+r52jlJf4vFhj9p1MgE5wIMi/53CLCY1mHdVsjXqo89TYGDZYauSrBfitO6YgRF5MCVXlLb5H1VV+AH+7dA0NUF6fQ5zfIbj+rQ6QYI3FdGLI4X6G80SppGWjujEjVmi7lybIgB8ii5ASPbMgBpS4b5pYvCwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R7pDm3GO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=h/MHPqAJUaQnVuOJ9LRPRm8bT9y8j34KRGcWL/KK0UA=; b=R7pDm3GO8Ii5Ili8nlCHbqY/ci
	HwQiGoHrPt0/QFJGLkfOYWapAgqNSD0m7dN47qkovXWmIJGWNxm24EBH2uEXCEf1pwbP/T0uTO8gR
	/rf/ABFbrwhzwh1YaFsnJvOjD4FFPRlfjqXYQ4RRF8PPw0rOa25/OIn9ZdvO0hQc8wJpxKcRL7i/l
	0y/jb12ZbyYiTzdtSNeuMI4b98guH1CwWtzoAnQiVaDAeoxaKUcUwh1eqyGFcqjXXvAmxC4RhZeLx
	5jIDVlbbv4+L8DyPrR2/AwByKwg+ryYd7CukrFp9FKQQRznSA/iPSrw4ecKOwVRqeyHtPJVHvE+yq
	YiNbS37w==;
Received: from [50.53.2.121] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruw71-0000000CgHE-2Zjz;
	Thu, 11 Apr 2024 15:13:15 +0000
Message-ID: <5ca63761-93e4-47e2-8fd0-e300a08f044a@infradead.org>
Date: Thu, 11 Apr 2024 08:13:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] treewide: Fix common grammar mistake "the the"
To: Thorsten Blum <thorsten.blum@toblux.com>, kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org, speakup@linux-speakup.org,
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org,
 ecryptfs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
 linux-arch@vger.kernel.org, io-uring@vger.kernel.org, cocci@inria.fr,
 linux-perf-users@vger.kernel.org
References: <20240411150437.496153-4-thorsten.blum@toblux.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240411150437.496153-4-thorsten.blum@toblux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/11/24 8:04 AM, Thorsten Blum wrote:
> Use `find . -type f -exec sed -i 's/\<the the\>/the/g' {} +` to find all
> occurrences of "the the" and replace them with a single "the".
> 
> Changes only comments and documentation - no code changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  Documentation/trace/histogram.rst                 | 2 +-
>  arch/arm/Kconfig                                  | 4 ++--
>  arch/arm/include/asm/unwind.h                     | 2 +-
>  arch/arm64/Kconfig                                | 2 +-
>  arch/arm64/kernel/entry-ftrace.S                  | 2 +-
>  arch/s390/kernel/perf_cpum_sf.c                   | 2 +-
>  arch/s390/kernel/sthyi.c                          | 2 +-
>  drivers/accessibility/speakup/speakup_soft.c      | 2 +-
>  drivers/gpu/drm/i915/display/intel_crt.c          | 2 +-
>  drivers/gpu/drm/i915/i915_request.c               | 2 +-
>  drivers/mailbox/Kconfig                           | 2 +-
>  drivers/net/wireless/intel/iwlwifi/fw/api/tx.h    | 4 ++--
>  drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
>  drivers/scsi/bfa/bfa_fcs_rport.c                  | 2 +-
>  drivers/scsi/fcoe/fcoe_ctlr.c                     | 2 +-
>  drivers/scsi/isci/host.h                          | 2 +-
>  drivers/scsi/isci/remote_device.h                 | 2 +-
>  drivers/scsi/isci/remote_node_context.h           | 2 +-
>  drivers/scsi/isci/task.c                          | 2 +-
>  fs/afs/flock.c                                    | 2 +-
>  fs/ecryptfs/keystore.c                            | 2 +-
>  fs/netfs/direct_read.c                            | 2 +-
>  fs/netfs/direct_write.c                           | 2 +-
>  fs/overlayfs/super.c                              | 2 +-
>  include/uapi/asm-generic/fcntl.h                  | 2 +-
>  io_uring/kbuf.c                                   | 2 +-
>  lib/zstd/common/fse_decompress.c                  | 2 +-
>  lib/zstd/decompress/zstd_decompress_block.c       | 2 +-
>  scripts/coccinelle/misc/badty.cocci               | 2 +-
>  tools/perf/Documentation/perf-diff.txt            | 2 +-
>  30 files changed, 32 insertions(+), 32 deletions(-)
> 

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
#Randy

