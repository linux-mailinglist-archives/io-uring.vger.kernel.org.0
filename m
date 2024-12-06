Return-Path: <io-uring+bounces-5265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C36D9E63F1
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 03:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD27F1884BAD
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 02:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E2113C8FF;
	Fri,  6 Dec 2024 02:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j23gqL9N"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5062AE9A;
	Fri,  6 Dec 2024 02:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733451483; cv=none; b=P0+y3eQwoaq6WdIzzEmMZ5WSJ5PO3GgM603C0CH+3ukrSZQ3gI6Pgi1sO+uDyB2vk1QN/FKap8mta0X5/JWJnfg/gNdvpF5Hs3YD7dRh2acBjp50g6Cm0w2dyY5/T3i2Y0jKbGbIC7WWyme4K0NF+lZhdoG57AeLVpbsDh0QyjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733451483; c=relaxed/simple;
	bh=r87v6RI14MYvQVvrhHKKo5H2rpySP4RbfqYlrBpFKZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N3uKhbaPz3IQcM+yQq9woYOG+u7X/LOZoPUhw/zBxUzJ9+bfbb1Fud2DGdg6+ASYDXfwNYzS+nHMNsHkiWf8RODUyAtibU/8c8uEGtPE0J2aPb8zHe4MW4pP9iBQAiChjxAt384JEwNXDCnFj0jL9Lam0KlyhDkO+ApXjaha43o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j23gqL9N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82697C4CED1;
	Fri,  6 Dec 2024 02:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733451482;
	bh=r87v6RI14MYvQVvrhHKKo5H2rpySP4RbfqYlrBpFKZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j23gqL9NEopbGtSbdZPKivdMJRqAbKO9sZrmDC9Ftd7yGWUZjm7lqHDO+LEwRqY8d
	 ravnVsXVQyLyjxep89kWNPXh6GBbszdLpwXr949hXgA6myo8XkrUh38CEWu3Y0E3yP
	 7VefFhA/L9eD9sJ66hry0eg642xiu0axIFqdVHWLzKa/ja1ZGPaVMuAkHxWMIo3CB/
	 fAo/MnU4QUa0oycKNt2Mayt0BIqPwAOI8FthnQDHJLTdt/uhxBJOTc9zB3E9wQRs2O
	 PcJnm9gXJ2c9Ka0TZKACIgHBjNatA9vsIO4mutBw3MyVnf6t1GyMe3eiD+NdyQFfLC
	 2IYRR7LQK3HRA==
Date: Thu, 5 Dec 2024 18:18:00 -0800
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com
Subject: Re: [PATCHv11 00/10] block write streams with nvme fdp
Message-ID: <Z1Je2Do8Tj_NYePW@kbusch-mbp.dhcp.thefacebook.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206015308.3342386-1-kbusch@meta.com>

On Thu, Dec 05, 2024 at 05:52:58PM -0800, Keith Busch wrote:
> Changes from v10:
> 
>  Merged up to block for-6.14/io_uring, which required some
>  new attribute handling.
> 
>  Not mixing write hints usage with write streams. This effectively
>  abandons any attempts to use the existing fcntl API for use with
>  filesystems in this series.
> 
>  Exporting the stream's reclaim unit nominal size.
> 
> Christoph Hellwig (5):
>   fs: add a write stream field to the kiocb
>   block: add a bi_write_stream field
>   block: introduce a write_stream_granularity queue limit
>   block: expose write streams for block device nodes
>   nvme: add a nvme_get_log_lsi helper
> 
> Keith Busch (5):
>   io_uring: protection information enhancements
>   io_uring: add write stream attribute
>   block: introduce max_write_streams queue limit
>   nvme: register fdp queue limits
>   nvme: use fdp streams if write stream is provided

I fucked up the format-patch command by ommitting a single patch. The
following should have been "PATCH 1/11", but I don't want to resend for
just this:

commit 9e40f4a4da6d0cef871d1c5daf55cc0497fd9c39
Author: Keith Busch <kbusch@kernel.org>
Date:   Tue Nov 19 13:16:15 2024 +0100

    fs: add write stream information to statx
    
    Add new statx field to report the maximum number of write streams
    supported and the granularity for them.
    
    Signed-off-by: Keith Busch <kbusch@kernel.org>
    [hch: renamed hints to streams, add granularity]
    Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/fs/stat.c b/fs/stat.c
index 0870e969a8a0b..00e4598b1ff25 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -729,6 +729,8 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
 	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
 	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
+	tmp.stx_write_stream_granularity = stat->write_stream_granularity;
+	tmp.stx_write_stream_max = stat->write_stream_max;
 
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 3d900c86981c5..36d4dfb291abd 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -57,6 +57,8 @@ struct kstat {
 	u32		atomic_write_unit_min;
 	u32		atomic_write_unit_max;
 	u32		atomic_write_segments_max;
+	u32		write_stream_granularity;
+	u16		write_stream_max;
 };
 
 /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 887a252864416..547c62a1a3a7c 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -132,9 +132,11 @@ struct statx {
 	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
 	/* 0xb0 */
 	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
-	__u32   __spare1[1];
+	__u32   stx_write_stream_granularity;
 	/* 0xb8 */
-	__u64	__spare3[9];	/* Spare space for future expansion */
+	__u16   stx_write_stream_max;
+	__u16	__sparse2[3];
+	__u64	__spare3[8];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -164,6 +166,7 @@ struct statx {
 #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
 #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
 #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
+#define STATX_WRITE_STREAM	0x00020000U	/* Want/got write_stream_* */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 

